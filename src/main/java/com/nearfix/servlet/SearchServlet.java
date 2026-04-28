package com.nearfix.servlet;

import com.nearfix.dao.ServiceDAO;
import com.nearfix.model.SearchResult;
import com.nearfix.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.Collections;
import java.util.List;

@WebServlet("/search")
public class SearchServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String service = req.getParameter("service");
        String zipCode = req.getParameter("zipCode");

        if (service != null) {
            service = service.trim();
        }
        if (zipCode != null) {
            zipCode = zipCode.trim();
        }

        if ((service == null || service.isEmpty()) && (zipCode == null || zipCode.isEmpty())) {
            req.setAttribute("results", Collections.emptyList());
            req.setAttribute("query", "");
            req.setAttribute("zipCode", "");
            req.setAttribute("error", "Enter a service keyword, a ZIP code, or both.");
            req.getRequestDispatcher("/searchResults.jsp").forward(req, resp);
            return;
        }

        if (zipCode != null && !zipCode.isEmpty() && !zipCode.matches("\\d{5}")) {
            req.setAttribute("results", Collections.emptyList());
            req.setAttribute("query", service == null ? "" : service);
            req.setAttribute("zipCode", zipCode);
            req.setAttribute("error", "ZIP code must be 5 digits.");
            req.getRequestDispatcher("/searchResults.jsp").forward(req, resp);
            return;
        }

        String preferredZip = null;
        HttpSession session = req.getSession(false);
        if (session != null) {
            User user = (User) session.getAttribute("user");
            if (user != null) {
                preferredZip = user.getZipCode();
            }
        }

        req.setAttribute("query", service == null ? "" : service);
        req.setAttribute("zipCode", zipCode == null ? "" : zipCode);

        try {
            ServiceDAO dao = new ServiceDAO();
            List<SearchResult> results = dao.search(service, zipCode, preferredZip);
            req.setAttribute("results", results);
        } catch (SQLException e) {
            e.printStackTrace();
            req.setAttribute("results", Collections.emptyList());
            req.setAttribute("error", "Search is temporarily unavailable. Check the database setup and try again.");
        }

        req.getRequestDispatcher("/searchResults.jsp").forward(req, resp);
    }
}
