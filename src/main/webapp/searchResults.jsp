<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>NearFix - Search Results</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .results-container {
            max-width: 900px;
            margin: 2rem auto;
            padding: 1rem;
        }

        .result-card {
            background: white;
            border-radius: 12px;
            padding: 1rem 1.2rem;
            margin-bottom: 1rem;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
        }

        .result-card h3 {
            margin-bottom: 0.5rem;
        }

        .back-link {
            display: inline-block;
            margin-bottom: 1rem;
            text-decoration: none;
            color: #1f3c88;
            font-weight: 600;
        }

        .result-actions {
            margin-top: 1rem;
            display: flex;
            gap: 0.75rem;
            flex-wrap: wrap;
        }
    </style>
</head>
<body>

<%
    Object sessionUser = session.getAttribute("user");
    String userRole = null;
    if (sessionUser != null) {
        try {
            userRole = ((com.nearfix.model.User) sessionUser).getRole();
        } catch (Exception ignored) {}
    }
%>

<nav class="navbar">
    <a href="${pageContext.request.contextPath}/" class="logo">Near<span>Fix</span></a>
    <div class="nav-links">
        <% if (session.getAttribute("user") != null) { %>
            <% if ("provider".equals(userRole)) { %>
                <a href="${pageContext.request.contextPath}/provider/profile">Provider Dashboard</a>
            <% } else { %>
                <a href="${pageContext.request.contextPath}/profile">My Profile</a>
                <a href="${pageContext.request.contextPath}/customer/bookings">My Bookings</a>
            <% } %>
            <a href="${pageContext.request.contextPath}/logout">Logout</a>
        <% } else { %>
            <a href="${pageContext.request.contextPath}/login">Login</a>
            <a href="${pageContext.request.contextPath}/register">Register</a>
        <% } %>
    </div>
</nav>

<div class="results-container">
    <a class="back-link" href="${pageContext.request.contextPath}/">← Back to Home</a>
    <h1>Search Results</h1>

    <%
        String service = request.getParameter("service");
        String zipCode = request.getParameter("zipCode");

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/nearfix?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC",
                "nearfix_user",
                ""
            );

            String sql;

            if (zipCode != null && !zipCode.trim().isEmpty()) {
                sql = "SELECT s.service_id, s.provider_id, s.service_name, s.description, s.price, s.location_zip, " +
                      "p.business_name, u.email " +
                      "FROM services s " +
                      "JOIN providers p ON s.provider_id = p.provider_id " +
                      "JOIN users u ON p.user_id = u.user_id " +
                      "WHERE s.service_name LIKE ? AND s.location_zip = ? " +
                      "ORDER BY s.service_name, p.business_name";
                ps = con.prepareStatement(sql);
                ps.setString(1, "%" + service + "%");
                ps.setString(2, zipCode.trim());
            } else {
                sql = "SELECT s.service_id, s.provider_id, s.service_name, s.description, s.price, s.location_zip, " +
                      "p.business_name, u.email " +
                      "FROM services s " +
                      "JOIN providers p ON s.provider_id = p.provider_id " +
                      "JOIN users u ON p.user_id = u.user_id " +
                      "WHERE s.service_name LIKE ? " +
                      "ORDER BY s.service_name, p.business_name";
                ps = con.prepareStatement(sql);
                ps.setString(1, "%" + service + "%");
            }

            rs = ps.executeQuery();
            boolean found = false;

            while (rs.next()) {
                found = true;
    %>
                <div class="result-card">
                    <h3><%= rs.getString("service_name") %></h3>
                    <p><strong>Provider:</strong> <%= rs.getString("business_name") %></p>
                    <p><strong>Description:</strong> <%= rs.getString("description") %></p>
                    <p><strong>Price:</strong> $<%= rs.getString("price") %></p>
                    <p><strong>ZIP Code:</strong> <%= rs.getString("location_zip") %></p>
                    <p><strong>Email:</strong> <%= rs.getString("email") %></p>
                    <div class="result-actions">
                        <a class="btn btn-primary btn-sm" href="${pageContext.request.contextPath}/providers/view?providerId=<%= rs.getInt("provider_id") %>">View Provider Profile</a>
                        <% if ("customer".equals(userRole)) { %>
                            <a class="btn btn-success btn-sm" href="${pageContext.request.contextPath}/customer/book?serviceId=<%= rs.getInt("service_id") %>">Request Booking</a>
                        <% } else if (sessionUser == null) { %>
                            <a class="btn btn-success btn-sm" href="${pageContext.request.contextPath}/login">Login to Book</a>
                        <% } %>
                    </div>
                </div>
    <%
            }

            if (!found) {
    %>
                <p>No matching services found.</p>
    <%
            }

        } catch (Exception e) {
    %>
            <p>Error: <%= e.getMessage() %></p>
    <%
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    %>
</div>

</body>
</html>
