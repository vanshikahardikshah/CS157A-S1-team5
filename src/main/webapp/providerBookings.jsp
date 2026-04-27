<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bookings - NearFix</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<nav class="navbar">
    <a href="${pageContext.request.contextPath}/" class="logo">Near<span>Fix</span></a>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/provider/profile">Profile</a>
        <a href="${pageContext.request.contextPath}/provider/services">Services</a>
        <a href="${pageContext.request.contextPath}/provider/availability">Availability</a>
        <a href="${pageContext.request.contextPath}/provider/bookings">Bookings</a>
        <a href="${pageContext.request.contextPath}/logout">Logout</a>
    </div>
</nav>

<div class="provider-container">
    <h2>Booking Requests</h2>

    <c:if test="${not empty success}">
        <div class="alert alert-success">${success}</div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-error">${error}</div>
    </c:if>

    <section class="provider-section">
        <c:choose>
            <c:when test="${empty bookings}">
                <p class="empty-message">No booking requests yet.</p>
            </c:when>
            <c:otherwise>
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>Booking ID</th>
                            <th>Service</th>
                            <th>Customer</th>
                            <th>Date</th>
                            <th>Total Price</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="booking" items="${bookings}">
                            <tr>
                                <td>#${booking.bookingId}</td>
                                <td>${booking.serviceName}</td>
                                <td>${booking.customerName}</td>
                                <td>${booking.bookingDate}</td>
                                <td>$${booking.totalPrice}</td>
                                <td>
                                    <span class="status-badge status-${booking.status}">${booking.status}</span>
                                </td>
                                <td>
                                    <c:if test="${booking.status == 'pending'}">
                                        <form method="post" action="${pageContext.request.contextPath}/provider/bookings"
                                              style="display:inline;">
                                            <input type="hidden" name="bookingId" value="${booking.bookingId}">
                                            <input type="hidden" name="action" value="accept">
                                            <button type="submit" class="btn btn-success btn-sm">Accept</button>
                                        </form>
                                        <form method="post" action="${pageContext.request.contextPath}/provider/bookings"
                                              style="display:inline;">
                                            <input type="hidden" name="bookingId" value="${booking.bookingId}">
                                            <input type="hidden" name="action" value="reject">
                                            <button type="submit" class="btn btn-danger btn-sm">Reject</button>
                                        </form>
                                    </c:if>
                                    <c:if test="${booking.status != 'pending'}">
                                        <span class="text-muted">--</span>
                                    </c:if>
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
