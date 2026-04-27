<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Provider Details - NearFix</title>
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
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/profile">My Profile</a>
                        <a href="${pageContext.request.contextPath}/customer/bookings">My Bookings</a>
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

<div class="provider-container">
    <a class="back-link" href="${pageContext.request.contextPath}/">← Back to Home</a>
    <h2>Provider Profile</h2>

    <c:if test="${not empty error}">
        <div class="alert alert-error">${error}</div>
    </c:if>

    <c:if test="${not empty provider}">
        <section class="provider-section">
            <h3>${provider.businessName}</h3>
            <p><strong>Contact Email:</strong> ${providerUser.email}</p>
            <p><strong>Contact Number:</strong> ${provider.contactNumber}</p>
            <p><strong>Service ZIP Code:</strong> ${providerUser.zipCode}</p>
            <p><strong>Approval Status:</strong> ${provider.approvalStatus}</p>
        </section>

        <section class="provider-section">
            <h3>Services Offered</h3>
            <c:choose>
                <c:when test="${empty services}">
                    <p class="empty-message">This provider has not listed any services yet.</p>
                </c:when>
                <c:otherwise>
                    <div class="service-list">
                        <c:forEach var="svc" items="${services}">
                            <div class="service-card">
                                <div class="service-info">
                                    <h4>${svc.serviceName}</h4>
                                    <p>${svc.description}</p>
                                    <span class="service-price">$${svc.price}</span>
                                    <span class="service-zip">ZIP: ${svc.locationZip}</span>
                                </div>
                                <c:if test="${sessionScope.user.role == 'customer'}">
                                    <a class="btn btn-success btn-sm" href="${pageContext.request.contextPath}/customer/book?serviceId=${svc.serviceId}">Request Booking</a>
                                </c:if>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </section>

        <section class="provider-section">
            <h3>Upcoming Availability</h3>
            <c:choose>
                <c:when test="${empty slots}">
                    <p class="empty-message">No appointment slots are currently available.</p>
                </c:when>
                <c:otherwise>
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Date</th>
                                <th>Start</th>
                                <th>End</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="slot" items="${slots}">
                                <tr>
                                    <td>${slot.availableDate}</td>
                                    <td>${slot.startTime}</td>
                                    <td>${slot.endTime}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
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
