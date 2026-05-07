<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>NearFix - Search Results</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
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

            String ratingJoin =
                  "LEFT JOIN (SELECT provider_id, AVG(rating) AS avg_rating, COUNT(*) AS review_count " +
                  "FROM reviews GROUP BY provider_id) rs ON s.provider_id = rs.provider_id ";

            String selectCols = "SELECT s.service_id, s.provider_id, s.service_name, s.description, s.price, s.location_zip, " +
                                "p.business_name, u.email, " +
                                "COALESCE(rs.avg_rating, 0) AS avg_rating, " +
                                "COALESCE(rs.review_count, 0) AS review_count ";

            if (zipCode != null && !zipCode.trim().isEmpty()) {
                sql = selectCols +
                      "FROM services s " +
                      "JOIN providers p ON s.provider_id = p.provider_id " +
                      "JOIN users u ON p.user_id = u.user_id " +
                      ratingJoin +
                      "WHERE s.service_name LIKE ? AND s.location_zip = ? " +
                      "ORDER BY s.service_name, p.business_name";
                ps = con.prepareStatement(sql);
                ps.setString(1, "%" + service + "%");
                ps.setString(2, zipCode.trim());
            } else {
                sql = selectCols +
                      "FROM services s " +
                      "JOIN providers p ON s.provider_id = p.provider_id " +
                      "JOIN users u ON p.user_id = u.user_id " +
                      ratingJoin +
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
                <%
                    int reviewCount = rs.getInt("review_count");
                    double avgRating = rs.getDouble("avg_rating");
                %>
                <div class="result-card">
                    <h3><%= rs.getString("service_name") %></h3>
                    <p><strong>Provider:</strong> <%= rs.getString("business_name") %></p>
                    <p><strong>Description:</strong> <%= rs.getString("description") %></p>
                    <p><strong>Price:</strong> $<%= rs.getString("price") %></p>
                    <p><strong>ZIP Code:</strong> <%= rs.getString("location_zip") %></p>
                    <p><strong>Email:</strong> <%= rs.getString("email") %></p>
                    <p><strong>Rating:</strong>
                        <% if (reviewCount > 0) { %>
                            <span class="stars"><%
                                for (int i = 1; i <= 5; i++) {
                                    out.print(i <= Math.round(avgRating) ? "★" : "☆");
                                }
                            %></span>
                            <%= String.format("%.1f", avgRating) %> / 5
                            (<%= reviewCount %> review<%= reviewCount == 1 ? "" : "s" %>)
                        <% } else { %>
                            <span style="color:var(--text-muted);">No reviews yet</span>
                        <% } %>
                    </p>
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
