<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>NearFix - Book Service</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .container { max-width: 800px; margin: 2rem auto; padding: 1rem; }
        .card {
            background: white; border-radius: 12px;
            padding: 1rem 1.2rem; margin-bottom: 1rem;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
        }
        .meta { font-size: 0.9rem; opacity: 0.8; margin-bottom: 0.5rem; }
        .slot-list { list-style: none; padding: 0; margin: 0; }
        .slot-list li { padding: 0.5rem 0; border-bottom: 1px solid #eee; }
        .slot-list label { cursor: pointer; }
        .book-btn {
            margin-top: 1rem; padding: 0.7rem 1.4rem;
            background: #1f3c88; color: white; border: none;
            border-radius: 6px; font-weight: 600; cursor: pointer;
        }
        .alert-error { background: #fce8e8; color: #8a1f1f; padding: 0.6rem 0.8rem; border-radius: 6px; margin-bottom: 1rem; }
    </style>
</head>
<body>

<nav class="navbar">
    <a href="${pageContext.request.contextPath}/" class="logo">Near<span>Fix</span></a>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/profile">My Profile</a>
        <a href="${pageContext.request.contextPath}/bookings">My Bookings</a>
        <a href="${pageContext.request.contextPath}/logout">Logout</a>
    </div>
</nav>

<div class="container">
    <a href="javascript:history.back()" style="color:#1f3c88;font-weight:600;">&larr; Back</a>
    <h1>Book Service</h1>

    <c:if test="${not empty error}"><div class="alert-error"><c:out value="${error}"/></div></c:if>

    <div class="card">
        <h2><c:out value="${service.serviceName}"/></h2>
        <div class="meta">
            <c:if test="${not empty category}"><c:out value="${category.categoryName}"/> &middot; </c:if>
            <c:if test="${not empty provider.businessName}"><c:out value="${provider.businessName}"/></c:if>
            <c:if test="${not empty service.locationZip}"> &middot; ZIP <c:out value="${service.locationZip}"/></c:if>
        </div>
        <p><c:out value="${service.description}"/></p>
        <p><strong>Price:</strong> $<fmt:formatNumber value="${service.price}" minFractionDigits="2" maxFractionDigits="2"/></p>
        <c:if test="${not empty provider.contactNumber}">
            <p><strong>Provider phone:</strong> <c:out value="${provider.contactNumber}"/></p>
        </c:if>
    </div>

    <div class="card">
        <h2>Pick a slot</h2>
        <c:choose>
            <c:when test="${empty slots}">
                <p>No upcoming availability. Please check back later or contact the provider.</p>
            </c:when>
            <c:otherwise>
                <form method="post" action="${pageContext.request.contextPath}/book">
                    <input type="hidden" name="serviceId" value="${service.serviceId}">
                    <ul class="slot-list">
                        <c:forEach var="slot" items="${slots}" varStatus="loop">
                            <li>
                                <label>
                                    <input type="radio" name="availabilityId" value="${slot.availabilityId}" <c:if test="${loop.first}">checked</c:if> required>
                                    <fmt:formatDate value="${slot.availableDate}" pattern="EEE, MMM d, yyyy"/>
                                    &middot;
                                    <fmt:formatDate value="${slot.startTime}" type="time" pattern="h:mm a"/>
                                    &ndash;
                                    <fmt:formatDate value="${slot.endTime}" type="time" pattern="h:mm a"/>
                                </label>
                            </li>
                        </c:forEach>
                    </ul>
                    <button class="book-btn" type="submit">Book Now</button>
                    <p style="margin-top:0.6rem; font-size:0.85rem; opacity:0.7;">
                        Booking will be created in <em>pending</em> status until the provider confirms it.
                    </p>
                </form>
            </c:otherwise>
        </c:choose>
    </div>
</div>

</body>
</html>
