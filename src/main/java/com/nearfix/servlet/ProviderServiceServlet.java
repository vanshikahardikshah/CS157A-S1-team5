package com.nearfix.servlet;

import com.nearfix.dao.ProviderDAO;
import com.nearfix.dao.ServiceCategoryDAO;
import com.nearfix.dao.ServiceDAO;
import com.nearfix.model.Provider;
import com.nearfix.model.Service;
import com.nearfix.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;

@WebServlet("/provider/services")
public class ProviderServiceServlet extends HttpServlet {

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

        ServiceDAO serviceDAO = new ServiceDAO();
        ServiceCategoryDAO categoryDAO = new ServiceCategoryDAO();

        req.setAttribute("services", serviceDAO.getByProviderId(provider.getProviderId()));
        req.setAttribute("categories", categoryDAO.getAll());
        req.setAttribute("provider", provider);
        req.getRequestDispatcher("/providerServices.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
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

        String action = req.getParameter("action");
        ServiceDAO serviceDAO = new ServiceDAO();

        if ("add".equals(action)) {
            Service service = new Service();
            service.setProviderId(provider.getProviderId());
            service.setCategoryId(Integer.parseInt(req.getParameter("categoryId")));
            service.setServiceName(req.getParameter("serviceName"));
            service.setDescription(req.getParameter("description"));
            service.setPrice(new BigDecimal(req.getParameter("price")));
            service.setLocationZip(req.getParameter("locationZip"));

            if (serviceDAO.createService(service)) {
                req.setAttribute("success", "Service added.");
            } else {
                req.setAttribute("error", "Failed to add service.");
            }
        } else if ("delete".equals(action)) {
            int serviceId = Integer.parseInt(req.getParameter("serviceId"));
            if (serviceDAO.deleteService(serviceId, provider.getProviderId())) {
                req.setAttribute("success", "Service removed.");
            } else {
                req.setAttribute("error", "Failed to remove service.");
            }
        }

        ServiceCategoryDAO categoryDAO = new ServiceCategoryDAO();
        req.setAttribute("services", serviceDAO.getByProviderId(provider.getProviderId()));
        req.setAttribute("categories", categoryDAO.getAll());
        req.setAttribute("provider", provider);
        req.getRequestDispatcher("/providerServices.jsp").forward(req, resp);
    }
}
