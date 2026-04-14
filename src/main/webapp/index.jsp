<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>NearFix - Your One Stop Hub for Trusted Local Services</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<nav class="navbar">
    <a href="${pageContext.request.contextPath}/" class="logo">Near<span>Fix</span></a>
    <div class="nav-links">
        <c:choose>
            <c:when test="${not empty sessionScope.user}">
                <a href="${pageContext.request.contextPath}/profile">My Profile</a>
                <a href="${pageContext.request.contextPath}/logout">Logout</a>
            </c:when>
            <c:otherwise>
                <a href="${pageContext.request.contextPath}/login">Login</a>
                <a href="${pageContext.request.contextPath}/register">Register</a>
            </c:otherwise>
        </c:choose>
    </div>
</nav>

<section class="hero">
    <h1>Find Trusted Local Services</h1>
    <p>Connect with plumbers, electricians, cleaners, technicians and more in your area.</p>
    <div class="search-bar">
        <input type="text" placeholder="What service do you need?" disabled>
        <input type="text" placeholder="Zip Code" style="max-width:140px;" disabled>
        <button type="button" disabled>Search</button>
    </div>
    <p style="margin-top:0.8rem; font-size:0.85rem; opacity:0.7;">Search coming soon &mdash; register now to get started!</p>
</section>

<section class="categories">
    <h2>Popular Service Categories</h2>
    <div class="category-grid">
        <div class="category-card">
            <div class="icon">&#128268;</div>
            <h3>Electricians</h3>
        </div>
        <div class="category-card">
            <div class="icon">&#128295;</div>
            <h3>Plumbers</h3>
        </div>
        <div class="category-card">
            <div class="icon">&#129529;</div>
            <h3>Cleaners</h3>
        </div>
        <div class="category-card">
            <div class="icon">&#128736;</div>
            <h3>Technicians</h3>
        </div>
        <div class="category-card">
            <div class="icon">&#127912;</div>
            <h3>Painters</h3>
        </div>
    </div>
</section>

<footer class="footer">
    <p>&copy; 2025 NearFix. CS 157A - Team 5. All rights reserved.</p>
</footer>

</body>
</html>
