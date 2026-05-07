package com.nearfix.servlet;

import com.nearfix.dao.ProviderDAO;
import com.nearfix.dao.ReviewDAO;
import com.nearfix.model.Provider;
import com.nearfix.model.Review;
import com.nearfix.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/provider/reviews")
public class ProviderReviewsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        User user = (User) session.getAttribute("user");
        if (!"provider".equals(user.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/profile");
            return;
        }

        ProviderDAO providerDAO = new ProviderDAO();
        Provider provider = providerDAO.getByUserId(user.getUserId());
        if (provider == null) {
            resp.sendRedirect(req.getContextPath() + "/provider/profile");
            return;
        }

        ReviewDAO reviewDAO = new ReviewDAO();
        List<Review> reviews = reviewDAO.getByProviderId(provider.getProviderId());
        ReviewDAO.RatingStats stats = reviewDAO.getProviderRatingStats(provider.getProviderId());

        req.setAttribute("provider", provider);
        req.setAttribute("reviews", reviews);
        req.setAttribute("avgRating", stats.getAverageRating());
        req.setAttribute("reviewCount", stats.getReviewCount());
        req.getRequestDispatcher("/providerReviews.jsp").forward(req, resp);
    }
}
