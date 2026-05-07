package com.nearfix.servlet;

import com.nearfix.dao.ReviewDAO;
import com.nearfix.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/admin/reviews")
public class AdminReviewServlet extends HttpServlet {

    private final ReviewDAO reviewDAO = new ReviewDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!requireAdmin(req, resp)) return;
        req.setAttribute("reviews", reviewDAO.getAll());
        req.getRequestDispatcher("/adminReviews.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!requireAdmin(req, resp)) return;

        HttpSession session = req.getSession();
        try {
            int reviewId = Integer.parseInt(req.getParameter("reviewId"));
            if (reviewDAO.delete(reviewId)) {
                session.setAttribute("success", "Review removed.");
            } else {
                session.setAttribute("error", "Failed to remove review.");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("error", "Invalid review id.");
        }
        resp.sendRedirect(req.getContextPath() + "/admin/reviews");
    }

    private boolean requireAdmin(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return false;
        }
        User user = (User) session.getAttribute("user");
        if (!"admin".equalsIgnoreCase(user.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/profile");
            return false;
        }
        return true;
    }
}
