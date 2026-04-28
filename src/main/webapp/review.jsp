<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>NearFix - Reviews</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .container { max-width: 800px; margin: 2rem auto; padding: 1rem; }
        .card {
            background: white; border-radius: 12px;
            padding: 1rem 1.2rem; margin-bottom: 1rem;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
        }
        .review-header { display: flex; justify-content: space-between; align-items: baseline; }
        .stars { color: #f5a623; font-weight: 700; }
        form.review-form label { display: block; margin: 0.6rem 0 0.2rem; font-weight: 600; }
        form.review-form select, form.review-form textarea, form.review-form input[type=number] {
            width: 100%; padding: 0.5rem; border: 1px solid #ccc; border-radius: 6px;
        }
        form.review-form button {
            margin-top: 0.8rem; padding: 0.6rem 1.2rem;
            background: #1f3c88; color: white; border: none;
            border-radius: 6px; font-weight: 600; cursor: pointer;
        }
        .alert-success { background: #e7f6ec; color: #1d6f3a; padding: 0.6rem 0.8rem; border-radius: 6px; margin-bottom: 1rem; }
        .alert-error { background: #fce8e8; color: #8a1f1f; padding: 0.6rem 0.8rem; border-radius: 6px; margin-bottom: 1rem; }
    </style>
</head>
<body>

<nav class="navbar">
    <a href="${pageContext.request.contextPath}/" class="logo">Near<span>Fix</span></a>
    <div class="nav-links">
        <c:choose>
            <c:when test="${not empty sessionScope.user}">
                <a href="${pageContext.request.contextPath}/profile">My Profile</a>
                <a href="${pageContext.request.contextPath}/logout">Logout</a>
            </c:when>
            <c:otherwise>
                <a href="${pageContext.request.contextPath}/login">Login</a>
            </c:otherwise>
        </c:choose>
    </div>
</nav>

<div class="container">
    <a href="javascript:history.back()" style="color:#1f3c88;font-weight:600;">&larr; Back</a>
    <h1>Reviews for <c:out value="${provider.businessName != null ? provider.businessName : 'Provider'}"/></h1>

    <c:if test="${submitted}">
        <div class="alert-success">Thanks! Your review has been submitted.</div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert-error"><c:out value="${error}"/></div>
    </c:if>

    <c:choose>
        <c:when test="${sessionScope.user.role == 'customer'}">
            <c:choose>
                <c:when test="${empty bookingIds}">
                    <div class="card">
                        <p>You don't have any completed bookings with this provider that are eligible for a review.</p>
                        <p style="opacity:0.7;font-size:0.9rem;">Reviews can only be submitted after a booking is marked completed.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="card">
                        <h2>Leave a review</h2>
                        <form class="review-form" method="post" action="${pageContext.request.contextPath}/review">
                            <input type="hidden" name="providerId" value="${provider.providerId}">
                            <label for="bookingId">Booking</label>
                            <select id="bookingId" name="bookingId" required>
                                <c:forEach var="bid" items="${bookingIds}">
                                    <option value="${bid}">Booking #${bid}</option>
                                </c:forEach>
                            </select>
                            <label for="rating">Rating (1-5)</label>
                            <input id="rating" type="number" name="rating" min="1" max="5" required>
                            <label for="comment">Comment</label>
                            <textarea id="comment" name="comment" rows="4" placeholder="Your experience..."></textarea>
                            <button type="submit">Submit Review</button>
                        </form>
                    </div>
                </c:otherwise>
            </c:choose>
        </c:when>
        <c:when test="${empty sessionScope.user}">
            <div class="card">
                <p><a href="${pageContext.request.contextPath}/login">Log in</a> to leave a review.</p>
            </div>
        </c:when>
    </c:choose>

    <h2>All reviews</h2>
    <c:choose>
        <c:when test="${empty existingReviews}">
            <p>No reviews yet.</p>
        </c:when>
        <c:otherwise>
            <c:forEach var="r" items="${existingReviews}">
                <div class="card">
                    <div class="review-header">
                        <strong><c:out value="${r.customerName}"/></strong>
                        <span class="stars">
                            <c:forEach begin="1" end="${r.rating}">&#9733;</c:forEach>
                            <c:forEach begin="${r.rating + 1}" end="5">&#9734;</c:forEach>
                        </span>
                    </div>
                    <p style="opacity:0.7;font-size:0.85rem;margin:0.3rem 0;">
                        <fmt:formatDate value="${r.reviewDate}" pattern="MMM d, yyyy"/>
                    </p>
                    <c:if test="${not empty r.comment}">
                        <p><c:out value="${r.comment}"/></p>
                    </c:if>
                </div>
            </c:forEach>
        </c:otherwise>
    </c:choose>
</div>

</body>
</html>
