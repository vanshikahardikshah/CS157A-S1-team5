<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>NearFix - My Bookings</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .container { max-width: 900px; margin: 2rem auto; padding: 1rem; }
        .card {
            background: white; border-radius: 12px;
            padding: 1rem 1.2rem; margin-bottom: 1rem;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
        }
        .row-head { display: flex; justify-content: space-between; align-items: baseline; }
        .meta { font-size: 0.9rem; opacity: 0.8; margin: 0.3rem 0 0.6rem; }
        .status {
            display: inline-block; padding: 0.2rem 0.6rem;
            border-radius: 999px; font-size: 0.8rem; font-weight: 700;
            text-transform: uppercase; letter-spacing: 0.03em;
        }
        .status-pending   { background: #fff5d8; color: #8a6d1c; }
        .status-confirmed { background: #d8eaff; color: #1d4f8a; }
        .status-completed { background: #e7f6ec; color: #1d6f3a; }
        .status-cancelled { background: #f0f0f0; color: #555; }
        .actions { margin-top: 0.6rem; display: flex; gap: 0.6rem; flex-wrap: wrap; }
        .actions button, .actions a {
            padding: 0.4rem 0.9rem; border-radius: 6px; border: none;
            font-weight: 600; cursor: pointer; text-decoration: none; font-size: 0.9rem;
        }
        .btn-cancel { background: #c0392b; color: white; }
        .btn-review { background: #1f3c88; color: white; }
        .alert-success { background: #e7f6ec; color: #1d6f3a; padding: 0.6rem 0.8rem; border-radius: 6px; margin-bottom: 1rem; }
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
    <h1>My Bookings</h1>

    <c:if test="${not empty success}"><div class="alert-success"><c:out value="${success}"/></div></c:if>

    <c:choose>
        <c:when test="${empty bookings}">
            <div class="card">
                <p>You haven't booked any services yet.</p>
                <p><a href="${pageContext.request.contextPath}/" style="color:#1f3c88;font-weight:600;">Search for a service &rarr;</a></p>
            </div>
        </c:when>
        <c:otherwise>
            <c:forEach var="b" items="${bookings}">
                <div class="card">
                    <div class="row-head">
                        <h3 style="margin:0;"><c:out value="${b.serviceName}"/></h3>
                        <span class="status status-${b.status}"><c:out value="${b.status}"/></span>
                    </div>
                    <div class="meta">
                        <c:out value="${b.categoryName}"/>
                        <c:if test="${not empty b.businessName}"> &middot; <c:out value="${b.businessName}"/></c:if>
                        &middot;
                        <fmt:formatDate value="${b.bookingDate}" pattern="EEE, MMM d, yyyy"/>
                    </div>
                    <p>
                        <strong>Total:</strong>
                        $<fmt:formatNumber value="${b.totalPrice}" minFractionDigits="2" maxFractionDigits="2"/>
                        &middot; Booking #${b.bookingId}
                    </p>
                    <c:if test="${not empty b.providerContact}">
                        <p style="font-size:0.9rem;opacity:0.85;">Provider phone: <c:out value="${b.providerContact}"/></p>
                    </c:if>
                    <div class="actions">
                        <c:if test="${b.status == 'pending' || b.status == 'confirmed'}">
                            <form method="post" action="${pageContext.request.contextPath}/bookings"
                                  onsubmit="return confirm('Cancel this booking?');">
                                <input type="hidden" name="action" value="cancel">
                                <input type="hidden" name="bookingId" value="${b.bookingId}">
                                <button class="btn-cancel" type="submit">Cancel</button>
                            </form>
                        </c:if>
                        <c:if test="${b.status == 'completed'}">
                            <a class="btn-review" href="${pageContext.request.contextPath}/review?providerId=${b.providerId}">Leave a review</a>
                        </c:if>
                    </div>
                </div>
            </c:forEach>
        </c:otherwise>
    </c:choose>
</div>

</body>
</html>
