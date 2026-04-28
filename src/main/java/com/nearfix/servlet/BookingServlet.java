package com.nearfix.servlet;

import com.nearfix.dao.AvailabilityDAO;
import com.nearfix.dao.BookingDAO;
import com.nearfix.dao.ProviderDAO;
import com.nearfix.dao.ServiceCategoryDAO;
import com.nearfix.dao.ServiceDAO;
import com.nearfix.model.Availability;
import com.nearfix.model.Provider;
import com.nearfix.model.Service;
import com.nearfix.model.ServiceCategory;
import com.nearfix.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/book")
public class BookingServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login?redirect=book&serviceId=" + req.getParameter("serviceId"));
            return;
        }
        User user = (User) session.getAttribute("user");
        if (!"customer".equals(user.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/");
            return;
        }
        String serviceIdStr = req.getParameter("serviceId");
        if (serviceIdStr == null) {
            resp.sendRedirect(req.getContextPath() + "/");
            return;
        }
        try {
            int serviceId = Integer.parseInt(serviceIdStr);
            ServiceDAO sdao = new ServiceDAO();
            Service service = sdao.getById(serviceId);
            if (service == null) {
                resp.sendRedirect(req.getContextPath() + "/");
                return;
            }
            ProviderDAO pdao = new ProviderDAO();
            Provider provider = pdao.getById(service.getProviderId());
            ServiceCategoryDAO cdao = new ServiceCategoryDAO();
            ServiceCategory category = cdao.getById(service.getCategoryId());
            AvailabilityDAO adao = new AvailabilityDAO();
            List<Availability> slots = adao.getFutureByProviderId(service.getProviderId());

            req.setAttribute("service", service);
            req.setAttribute("provider", provider);
            req.setAttribute("category", category);
            req.setAttribute("slots", slots);
            if ("true".equals(req.getParameter("error"))) {
                req.setAttribute("error", "Booking failed. The slot may have been taken — please pick another.");
            }
            req.getRequestDispatcher("/book.jsp").forward(req, resp);
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/");
        }
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
        try {
            int serviceId = Integer.parseInt(req.getParameter("serviceId"));
            int availabilityId = Integer.parseInt(req.getParameter("availabilityId"));
            BookingDAO bdao = new BookingDAO();
            Integer bookingId = bdao.create(user.getUserId(), serviceId, availabilityId);
            if (bookingId == null) {
                resp.sendRedirect(req.getContextPath() + "/book?serviceId=" + serviceId + "&error=true");
            } else {
                resp.sendRedirect(req.getContextPath() + "/bookings?booked=" + bookingId);
            }
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/");
        }
    }
}
