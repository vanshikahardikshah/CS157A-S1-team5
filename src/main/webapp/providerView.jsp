<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Provider Details - NearFix</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .provider-container { max-width: 950px; margin: 2rem auto; padding: 1rem; }
        .provider-section { background: white; border-radius: 12px; padding: 1rem 1.2rem; margin-bottom: 1rem; box-shadow: 0 2px 10px rgba(0,0,0,0.08); }
        .service-card { display:flex; justify-content:space-between; gap:1rem; align-items:flex-start; padding:0.8rem 0; border-bottom:1px solid #eee; }
        .service-card:last-child { border-bottom:none; }
        .service-actions { display:flex; gap:0.6rem; flex-wrap:wrap; }
        .btn-link, .btn-primary { text-decoration:none; border-radius:6px; font-weight:600; padding:0.5rem 0.9rem; }
        .btn-primary { background:#1f3c88; color:white; }
        .btn-link { color:#1f3c88; }
        .data-table { width:100%; border-collapse:collapse; }
        .data-table th, .data-table td { padding:0.7rem; border-bottom:1px solid #eee; text-align:left; }
        .back-link { color:#1f3c88; font-weight:600; text-decoration:none; }
        .empty-message { opacity:0.75; }
    </style>
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

<div class="provider-container">
    <a class="back-link" href="${pageContext.request.contextPath}/">&larr; Back to Home</a>
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
            <p><a class="btn-link" href="${pageContext.request.contextPath}/review?providerId=${provider.providerId}">Read and leave reviews &rarr;</a></p>
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
                                    <p><strong>Price:</strong> $<fmt:formatNumber value="${svc.price}" minFractionDigits="2" maxFractionDigits="2"/></p>
                                    <p><strong>ZIP:</strong> ${svc.locationZip}</p>
                                </div>
                                <div class="service-actions">
                                    <c:if test="${not empty sessionScope.user and sessionScope.user.role == 'customer'}">
                                        <a class="btn-primary" href="${pageContext.request.contextPath}/book?serviceId=${svc.serviceId}">Book This Service</a>
                                    </c:if>
                                </div>
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
                                    <td><fmt:formatDate value="${slot.availableDate}" pattern="EEE, MMM d, yyyy"/></td>
                                    <td><fmt:formatDate value="${slot.startTime}" type="time" pattern="h:mm a"/></td>
                                    <td><fmt:formatDate value="${slot.endTime}" type="time" pattern="h:mm a"/></td>
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
