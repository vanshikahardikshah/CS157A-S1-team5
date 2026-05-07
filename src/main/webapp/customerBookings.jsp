<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Bookings - NearFix</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<nav class="navbar">
    <a href="${pageContext.request.contextPath}/" class="logo">Near<span>Fix</span></a>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/profile">My Profile</a>
        <a href="${pageContext.request.contextPath}/customer/bookings">My Bookings</a>
        <a href="${pageContext.request.contextPath}/logout">Logout</a>
    </div>
</nav>

<div class="provider-container">
    <h2>My Bookings</h2>

    <c:if test="${param.created == 'true'}">
        <div class="alert alert-success">
            <c:choose>
                <c:when test="${param.payment == 'true'}">Your booking request has been submitted successfully and payment was recorded.</c:when>
                <c:otherwise>Your booking request has been submitted successfully.</c:otherwise>
            </c:choose>
        </div>
    </c:if>

    <c:if test="${param.reviewed == 'true'}">
        <div class="alert alert-success">Thank you! Your review has been submitted.</div>
    </c:if>
    <c:if test="${param.error == 'alreadyReviewed'}">
        <div class="alert alert-error">You have already reviewed that booking.</div>
    </c:if>
    <c:if test="${param.error == 'notCompleted'}">
        <div class="alert alert-error">You can only review a booking after it is completed.</div>
    </c:if>

    <section class="provider-section">
        <c:choose>
            <c:when test="${empty bookings}">
                <p class="empty-message">You have not made any bookings yet.</p>
            </c:when>
            <c:otherwise>
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>Booking ID</th>
                            <th>Service</th>
                            <th>Provider</th>
                            <th>Date</th>
                            <th>Total Price</th>
                            <th>Status</th>
                            <th>Review</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="booking" items="${bookings}">
                            <tr>
                                <td>#${booking.bookingId}</td>
                                <td>${booking.serviceName}</td>
                                <td>${booking.providerBusinessName}</td>
                                <td>${booking.bookingDate}</td>
                                <td>$${booking.totalPrice}</td>
                                <td><span class="status-badge status-${booking.status}">${booking.status}</span></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${booking.status != 'completed'}">
                                            <span style="color:var(--text-muted);">—</span>
                                        </c:when>
                                        <c:when test="${reviewedBookingIds.contains(booking.bookingId)}">
                                            <span style="color:var(--success); font-weight:600;">Reviewed</span>
                                        </c:when>
                                        <c:otherwise>
                                            <a class="btn btn-primary btn-sm" href="${pageContext.request.contextPath}/customer/review?bookingId=${booking.bookingId}">Leave Review</a>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:otherwise>
        </c:choose>
    </section>
</div>

<footer class="footer">
    <p>&copy; 2025 NearFix. CS 157A - Team 5.</p>
</footer>

</body>
</html>
