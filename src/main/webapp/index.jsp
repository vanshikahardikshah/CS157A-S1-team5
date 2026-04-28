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
                <c:choose>
                    <c:when test="${sessionScope.user.role == 'provider'}">
                        <a href="${pageContext.request.contextPath}/provider/profile">Provider Dashboard</a>
                        <a href="${pageContext.request.contextPath}/provider/services">My Services</a>
                        <a href="${pageContext.request.contextPath}/provider/bookings">Bookings</a>
                    </c:when>
                    <c:when test="${sessionScope.user.role == 'admin'}">
                        <a href="${pageContext.request.contextPath}/admin/categories">Admin: Categories</a>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/profile">My Profile</a>
                        <a href="${pageContext.request.contextPath}/bookings">My Bookings</a>
                    </c:otherwise>
                </c:choose>
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
    <form action="${pageContext.request.contextPath}/search" method="get" class="search-bar">
    <input type="text" name="service" placeholder="What service do you need?" required>
    <input type="text" name="zipCode" placeholder="Zip Code" style="max-width:140px;">
    <button type="submit">Search</button>
</form>
<p style="margin-top:0.8rem; font-size:0.85rem; opacity:0.7;">Search services by keyword and optional ZIP code.</p>
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
