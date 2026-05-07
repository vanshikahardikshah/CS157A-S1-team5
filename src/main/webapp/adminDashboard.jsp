<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - NearFix</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<nav class="navbar">
    <a href="${pageContext.request.contextPath}/" class="logo">Near<span>Fix</span></a>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a>
        <a href="${pageContext.request.contextPath}/admin/approvals">Approvals</a>
        <a href="${pageContext.request.contextPath}/admin/categories">Categories</a>
        <a href="${pageContext.request.contextPath}/admin/reviews">Reviews</a>
        <a href="${pageContext.request.contextPath}/admin/users">Users</a>
        <a href="${pageContext.request.contextPath}/logout">Logout</a>
    </div>
</nav>

<div class="admin-container">
    <h1>Admin Dashboard</h1>
    <p>Moderate the platform and manage administration tasks.</p>

    <div class="admin-grid">
        <a class="admin-card" href="${pageContext.request.contextPath}/admin/approvals">
            <h3>Provider Approvals</h3>
            <p>Approve or reject provider accounts.</p>
        </a>

        <a class="admin-card" href="${pageContext.request.contextPath}/admin/categories">
            <h3>Service Categories</h3>
            <p>Add or remove categories used to organize listings.</p>
        </a>

        <a class="admin-card" href="${pageContext.request.contextPath}/admin/reviews">
            <h3>Review Moderation</h3>
            <p>Remove inappropriate or fraudulent reviews.</p>
        </a>

        <a class="admin-card" href="${pageContext.request.contextPath}/admin/users">
            <h3>Manage Users</h3>
            <p>View all accounts and remove fraudulent users.</p>
        </a>

        <a class="admin-card" href="${pageContext.request.contextPath}/profile">
            <h3>My Profile</h3>
            <p>View and manage your admin account profile.</p>
        </a>
    </div>
</div>

<footer class="footer">
    <p>&copy; 2025 NearFix. CS 157A - Team 5.</p>
</footer>

</body>
</html>