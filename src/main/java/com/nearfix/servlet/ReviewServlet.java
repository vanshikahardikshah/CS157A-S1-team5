package com.nearfix.servlet;

import com.nearfix.dao.ReviewDAO;
import com.nearfix.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/review")
public class ReviewServlet extends HttpServlet {

    private final ReviewDAO reviewDAO = new ReviewDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/review.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");

        try {
            int bookingId = Integer.parseInt(req.getParameter("bookingId"));
            int providerId = Integer.parseInt(req.getParameter("providerId"));
            int rating = Integer.parseInt(req.getParameter("rating"));
            String comment = req.getParameter("comment");

            if (rating < 1 || rating > 5) {
                req.setAttribute("error", "Rating must be between 1 and 5.");
                req.getRequestDispatcher("/review.jsp").forward(req, resp);
                return;
            }

            boolean success = reviewDAO.addReview(bookingId, user.getUserId(), providerId, rating, comment);

            if (success) {
                req.setAttribute("success", "Review submitted successfully.");
            } else {
                req.setAttribute("error", "Failed to submit review.");
            }

            req.getRequestDispatcher("/review.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Invalid review submission.");
            req.getRequestDispatcher("/review.jsp").forward(req, resp);
        }
    }
}