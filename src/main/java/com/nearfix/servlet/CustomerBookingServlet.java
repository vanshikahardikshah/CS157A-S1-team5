package com.nearfix.servlet;

import com.nearfix.dao.AvailabilityDAO;
import com.nearfix.dao.BookingDAO;
import com.nearfix.dao.ProviderDAO;
import com.nearfix.dao.ServiceDAO;
import com.nearfix.dao.UserDAO;
import com.nearfix.model.Availability;
import com.nearfix.model.Booking;
import com.nearfix.model.Provider;
import com.nearfix.model.Service;
import com.nearfix.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/customer/book")
public class CustomerBookingServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!"customer".equals(user.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/");
            return;
        }

        loadBookingPage(req, resp, null);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!"customer".equals(user.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/");
            return;
        }

        String serviceIdParam = req.getParameter("serviceId");
        String availabilityIdParam = req.getParameter("availabilityId");
        if (serviceIdParam == null || availabilityIdParam == null) {
            loadBookingPage(req, resp, "Please select an available appointment slot.");
            return;
        }

        ServiceDAO serviceDAO = new ServiceDAO();
        AvailabilityDAO availabilityDAO = new AvailabilityDAO();
        BookingDAO bookingDAO = new BookingDAO();

        try {
            int serviceId = Integer.parseInt(serviceIdParam);
            int availabilityId = Integer.parseInt(availabilityIdParam);

            Service service = serviceDAO.getById(serviceId);
            Availability slot = availabilityDAO.getById(availabilityId);

            if (service == null || slot == null || slot.getProviderId() != service.getProviderId()) {
                loadBookingPage(req, resp, "That slot is no longer available.");
                return;
            }

            Booking booking = new Booking();
            booking.setCustomerId(user.getUserId());
            booking.setServiceId(service.getServiceId());
            booking.setBookingDate(slot.getAvailableDate());
            booking.setStatus("pending");
            booking.setTotalPrice(service.getPrice());

            boolean created = bookingDAO.createBooking(booking);
            boolean removedSlot = created && availabilityDAO.deleteSlot(slot.getAvailabilityId(), slot.getProviderId());

            if (created && removedSlot) {
                resp.sendRedirect(req.getContextPath() + "/customer/bookings?created=true");
                return;
            }

            loadBookingPage(req, resp, "Unable to create the booking right now. Please try again.");
        } catch (NumberFormatException e) {
            loadBookingPage(req, resp, "Invalid booking request.");
        }
    }

    private void loadBookingPage(HttpServletRequest req, HttpServletResponse resp, String error)
            throws ServletException, IOException {
        String serviceIdParam = req.getParameter("serviceId");
        if (serviceIdParam == null || serviceIdParam.isBlank()) {
            resp.sendRedirect(req.getContextPath() + "/");
            return;
        }

        int serviceId;
        try {
            serviceId = Integer.parseInt(serviceIdParam);
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/");
            return;
        }

        ServiceDAO serviceDAO = new ServiceDAO();
        ProviderDAO providerDAO = new ProviderDAO();
        AvailabilityDAO availabilityDAO = new AvailabilityDAO();
        UserDAO userDAO = new UserDAO();

        Service service = serviceDAO.getById(serviceId);
        if (service == null) {
            req.setAttribute("error", "Service not found.");
            req.getRequestDispatcher("/customerBook.jsp").forward(req, resp);
            return;
        }

        Provider provider = providerDAO.getById(service.getProviderId());
        if (provider == null) {
            req.setAttribute("error", "Provider not found.");
            req.getRequestDispatcher("/customerBook.jsp").forward(req, resp);
            return;
        }

        req.setAttribute("service", service);
        req.setAttribute("provider", provider);
        req.setAttribute("providerUser", userDAO.getById(provider.getUserId()));
        req.setAttribute("slots", availabilityDAO.getByProviderId(provider.getProviderId()));
        if (error != null) {
            req.setAttribute("error", error);
        }
        req.getRequestDispatcher("/customerBook.jsp").forward(req, resp);
    }
}
