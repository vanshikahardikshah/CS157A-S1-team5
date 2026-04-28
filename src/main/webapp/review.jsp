<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Leave Review - NearFix</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<nav class="navbar">
    <a href="${pageContext.request.contextPath}/" class="logo">Near<span>Fix</span></a>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/profile">My Profile</a>
        <a href="${pageContext.request.contextPath}/logout">Logout</a>
    </div>
</nav>

<div class="provider-container">
    <h2>Leave a Review</h2>

    <c:if test="${not empty success}">
        <div class="alert alert-success">${success}</div>
    </c:if>

    <c:if test="${not empty error}">
        <div class="alert alert-error">${error}</div>
    </c:if>

    <form method="post" action="${pageContext.request.contextPath}/review">
        <div class="form-group">
            <label for="bookingId">Booking ID</label>
            <input type="number" id="bookingId" name="bookingId" required>
        </div>

        <div class="form-group">
            <label for="providerId">Provider ID</label>
            <input type="number" id="providerId" name="providerId" required>
        </div>

        <div class="form-group">
            <label for="rating">Rating</label>
            <select id="rating" name="rating" required>
                <option value="">Select rating</option>
                <option value="1">1 - Poor</option>
                <option value="2">2</option>
                <option value="3">3 - Average</option>
                <option value="4">4</option>
                <option value="5">5 - Excellent</option>
            </select>
        </div>

        <div class="form-group">
            <label for="comment">Comment</label>
            <textarea id="comment" name="comment" rows="5" placeholder="Write your review here..."></textarea>
        </div>

        <button type="submit" class="btn btn-primary">Submit Review</button>
    </form>
</div>

<footer class="footer">
    <p>&copy; 2025 NearFix. CS 157A - Team 5.</p>
</footer>

</body>
</html>