<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Request Booking - NearFix</title>
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
    <a class="back-link" href="${pageContext.request.contextPath}/providers/view?providerId=${provider.providerId}">← Back to Provider Profile</a>
    <h2>Request a Booking</h2>

    <c:if test="${not empty error}">
        <div class="alert alert-error">${error}</div>
    </c:if>

    <c:if test="${not empty service}">
        <section class="provider-section">
            <h3>${service.serviceName}</h3>
            <p><strong>Provider:</strong> ${provider.businessName}</p>
            <p><strong>Contact Email:</strong> ${providerUser.email}</p>
            <p><strong>Description:</strong> ${service.description}</p>
            <p><strong>Price:</strong> $${service.price}</p>
            <p><strong>Location ZIP:</strong> ${service.locationZip}</p>
        </section>

        <section class="provider-section">
            <h3>Choose an Appointment Slot</h3>
            <c:choose>
                <c:when test="${empty slots}">
                    <p class="empty-message">This provider has no available appointment slots right now.</p>
                </c:when>
                <c:otherwise>
                    <form method="post" action="${pageContext.request.contextPath}/customer/book">
                        <input type="hidden" name="serviceId" value="${service.serviceId}">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>Select</th>
                                    <th>Date</th>
                                    <th>Start</th>
                                    <th>End</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="slot" items="${slots}">
                                    <tr>
                                        <td><input type="radio" name="availabilityId" value="${slot.availabilityId}" required></td>
                                        <td>${slot.availableDate}</td>
                                        <td>${slot.startTime}</td>
                                        <td>${slot.endTime}</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                        <div style="margin-top:1rem;">
                            <button type="submit" class="btn btn-success">Submit Booking Request</button>
                        </div>
                    </form>
                </c:otherwise>
            </c:choose>
        </section>
    </c:if>
</div>

<footer class="footer">
    <p>&copy; 2025 NearFix. CS 157A - Team 5.</p>
</footer>

</body>
</html>
