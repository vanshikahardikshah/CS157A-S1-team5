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
    </style>
</head>
<body>

<nav class="navbar">
    <a href="${pageContext.request.contextPath}/" class="logo">Near<span>Fix</span></a>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/login">Login</a>
        <a href="${pageContext.request.contextPath}/register">Register</a>
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
                sql = "SELECT s.*, p.business_name, u.email FROM services s " +
                      "JOIN providers p ON s.provider_id = p.provider_id " +
                      "JOIN users u ON p.user_id = u.user_id " +
                      "WHERE s.service_name LIKE ? AND s.location_zip = ?";
                ps = con.prepareStatement(sql);
                ps.setString(1, "%" + service + "%");
                ps.setString(2, zipCode.trim());
            } else {
                sql = "SELECT s.*, p.business_name, u.email FROM services s " +
                      "JOIN providers p ON s.provider_id = p.provider_id " +
                      "JOIN users u ON p.user_id = u.user_id " +
                      "WHERE s.service_name LIKE ?";
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
