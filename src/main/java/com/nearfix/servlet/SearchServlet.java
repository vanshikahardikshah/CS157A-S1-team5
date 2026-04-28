package com.nearfix.servlet;

import com.nearfix.dao.ServiceDAO;
import com.nearfix.model.SearchResult;
import com.nearfix.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/search")
public class SearchServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String service = req.getParameter("service");
        String zipCode = req.getParameter("zipCode");

        String preferredZip = null;
        HttpSession session = req.getSession(false);
        if (session != null) {
            User user = (User) session.getAttribute("user");
            if (user != null) preferredZip = user.getZipCode();
        }

        ServiceDAO dao = new ServiceDAO();
        List<SearchResult> results = dao.search(service, zipCode, preferredZip);

        req.setAttribute("results", results);
        req.setAttribute("query", service == null ? "" : service);
        req.setAttribute("zipCode", zipCode == null ? "" : zipCode);
        req.getRequestDispatcher("/searchResults.jsp").forward(req, resp);
    }
}
