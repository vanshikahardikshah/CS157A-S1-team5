package com.nearfix.servlet;

import com.nearfix.dao.SearchDAO;
import com.nearfix.dao.ServiceCategoryDAO;
import com.nearfix.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/search")
public class SearchServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String keyword = req.getParameter("service");
        String zipCode = req.getParameter("zipCode");
        String availableOn = req.getParameter("availableOn");

        if (zipCode == null || zipCode.isBlank()) {
            HttpSession session = req.getSession(false);
            if (session != null && session.getAttribute("user") instanceof User) {
                String profileZip = ((User) session.getAttribute("user")).getZipCode();
                if (profileZip != null && !profileZip.isBlank()) {
                    zipCode = profileZip;
                }
            }
        }

        int categoryId = parseIntOrZero(req.getParameter("categoryId"));
        int minRating = parseIntOrZero(req.getParameter("minRating"));
        if (minRating < 0 || minRating > 5) minRating = 0;

        SearchDAO searchDAO = new SearchDAO();
        ServiceCategoryDAO categoryDAO = new ServiceCategoryDAO();

        req.setAttribute("results", searchDAO.searchServices(keyword, zipCode, categoryId, minRating, availableOn));
        req.setAttribute("categories", categoryDAO.getAll());
        req.setAttribute("q_service", keyword == null ? "" : keyword);
        req.setAttribute("q_zip", zipCode == null ? "" : zipCode);
        req.setAttribute("q_categoryId", categoryId);
        req.setAttribute("q_minRating", minRating);
        req.setAttribute("q_availableOn", availableOn == null ? "" : availableOn);

        req.getRequestDispatcher("/searchResults.jsp").forward(req, resp);
    }

    private int parseIntOrZero(String s) {
        if (s == null || s.isBlank()) return 0;
        try { return Integer.parseInt(s.trim()); } catch (NumberFormatException e) { return 0; }
    }
}
