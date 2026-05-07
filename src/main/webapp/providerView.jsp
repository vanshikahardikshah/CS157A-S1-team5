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
            <c:choose>
                <c:when test="${reviewCount > 0}">
                    <p>
                        <span class="stars">
                            <c:forEach begin="1" end="5" var="i">
                                <c:choose>
                                    <c:when test="${i <= avgRating}">&#9733;</c:when>
                                    <c:otherwise>&#9734;</c:otherwise>
                                </c:choose>
                            </c:forEach>
                        </span>
                        <strong><fmt:formatNumber value="${avgRating}" pattern="#0.0"/></strong>
                        / 5 &middot; ${reviewCount} review<c:if test="${reviewCount != 1}">s</c:if>
                    </p>
                </c:when>
                <c:otherwise>
                    <p style="color:var(--text-muted);">No reviews yet.</p>
                </c:otherwise>
            </c:choose>
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
            <h3>Customer Reviews</h3>
            <c:choose>
                <c:when test="${empty reviews}">
                    <p class="empty-message">This provider has not received any reviews yet.</p>
                </c:when>
                <c:otherwise>
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
