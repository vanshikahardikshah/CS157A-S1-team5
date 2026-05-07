package com.nearfix.servlet;

import com.nearfix.dao.AvailabilityDAO;
import com.nearfix.dao.ProviderDAO;
import com.nearfix.dao.ReviewDAO;
import com.nearfix.dao.ServiceDAO;
import com.nearfix.dao.UserDAO;
import com.nearfix.model.Provider;
import com.nearfix.model.Service;
import com.nearfix.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/providers/view")
public class ProviderViewServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String providerIdParam = req.getParameter("providerId");
        if (providerIdParam == null || providerIdParam.isBlank()) {
            resp.sendRedirect(req.getContextPath() + "/");
            return;
        }

        int providerId;
        try {
            providerId = Integer.parseInt(providerIdParam);
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/");
            return;
        }

        ProviderDAO providerDAO = new ProviderDAO();
        ServiceDAO serviceDAO = new ServiceDAO();
        AvailabilityDAO availabilityDAO = new AvailabilityDAO();
        UserDAO userDAO = new UserDAO();
        ReviewDAO reviewDAO = new ReviewDAO();

        Provider provider = providerDAO.getById(providerId);
        if (provider == null) {
            req.setAttribute("error", "Provider not found.");
            req.getRequestDispatcher("/providerView.jsp").forward(req, resp);
            return;
        }

        User providerUser = userDAO.getById(provider.getUserId());
        List<Service> services = serviceDAO.getByProviderId(providerId);
        ReviewDAO.RatingStats stats = reviewDAO.getProviderRatingStats(providerId);

        req.setAttribute("provider", provider);
        req.setAttribute("providerUser", providerUser);
        req.setAttribute("services", services);
        req.setAttribute("slots", availabilityDAO.getByProviderId(providerId));
        req.setAttribute("reviews", reviewDAO.getByProviderId(providerId));
        req.setAttribute("avgRating", stats.getAverageRating());
        req.setAttribute("reviewCount", stats.getReviewCount());
        req.getRequestDispatcher("/providerView.jsp").forward(req, resp);
    }
}
