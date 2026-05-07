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
        <div class="alert alert-success">Your booking request has been submitted successfully<c:if test="${param.paid == 'true'}"> and the payment was recorded</c:if>.</div>
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
                            <th>Booking Status</th>
                            <th>Payment</th>
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
                                        <c:when test="${not empty booking.paymentStatus}">
                                            <span class="status-badge status-${booking.paymentStatus}">${booking.paymentStatus}</span>
                                            <c:if test="${not empty booking.cardLast4}">
                                                <span class="payment-note">Card ending ${booking.cardLast4}</span>
                                            </c:if>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-muted">No payment</span>
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
