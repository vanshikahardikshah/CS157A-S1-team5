<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Reviews - NearFix</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .summary {
            background: var(--surface);
            padding: 1.25rem 1.5rem;
            border: 1px solid var(--border);
            border-radius: var(--radius);
            margin-bottom: 1.5rem;
            box-shadow: var(--shadow-sm);
        }
        .summary .big-rating { font-size: 2.25rem; font-weight: 700; color: var(--primary-dark); }
    </style>
</head>
<body>

<nav class="navbar">
    <a href="${pageContext.request.contextPath}/" class="logo">Near<span>Fix</span></a>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/provider/profile">Profile</a>
        <a href="${pageContext.request.contextPath}/provider/services">Services</a>
        <a href="${pageContext.request.contextPath}/provider/availability">Availability</a>
        <a href="${pageContext.request.contextPath}/provider/bookings">Bookings</a>
        <a href="${pageContext.request.contextPath}/provider/reviews">Reviews</a>
        <a href="${pageContext.request.contextPath}/logout">Logout</a>
    </div>
</nav>

<div class="provider-container">
    <h2>Customer Reviews</h2>

    <div class="summary">
        <c:choose>
            <c:when test="${reviewCount > 0}">
                <p><span class="big-rating"><fmt:formatNumber value="${avgRating}" pattern="#0.0"/></span> / 5</p>
                <p class="stars">
                    <c:forEach begin="1" end="5" var="i">
                        <c:choose>
                            <c:when test="${i <= avgRating}">&#9733;</c:when>
                            <c:otherwise>&#9734;</c:otherwise>
                        </c:choose>
                    </c:forEach>
                </p>
                <p>Based on ${reviewCount} review<c:if test="${reviewCount != 1}">s</c:if>.</p>
            </c:when>
            <c:otherwise>
                <p class="empty-message">You have not received any reviews yet.</p>
            </c:otherwise>
        </c:choose>
    </div>

    <c:if test="${not empty reviews}">
        <c:forEach var="review" items="${reviews}">
            <div class="review-card">
                <p class="stars">
                    <c:forEach begin="1" end="5" var="i">
                        <c:choose>
                            <c:when test="${i <= review.rating}">&#9733;</c:when>
                            <c:otherwise>&#9734;</c:otherwise>
                        </c:choose>
                    </c:forEach>
                </p>
                <p><strong>${review.customerName}</strong> on ${review.serviceName}</p>
                <p class="meta">${review.reviewDate}</p>
                <c:if test="${not empty review.comment}">
                    <p style="margin-top:0.5rem;">${review.comment}</p>
                </c:if>
            </div>
        </c:forEach>
    </c:if>
</div>

<footer class="footer">
    <p>&copy; 2025 NearFix. CS 157A - Team 5.</p>
</footer>

</body>
</html>
