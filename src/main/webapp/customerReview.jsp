<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Leave a Review - NearFix</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .star-group {
            display: flex;
            flex-direction: row-reverse;
            justify-content: flex-end;
            gap: 0.4rem;
            margin: 0.5rem 0 1rem;
        }
        .star-group label {
            cursor: pointer;
            font-size: 1.6rem;
            color: var(--border-strong);
            transition: color 0.15s ease;
        }
        .star-group input[type="radio"] {
            display: none;
        }
        .star-group input[type="radio"]:checked ~ label,
        .star-group label:hover,
        .star-group label:hover ~ label {
            color: var(--star);
        }
    </style>
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
    <a class="back-link" href="${pageContext.request.contextPath}/customer/bookings">← Back to My Bookings</a>
    <h2>Leave a Review</h2>

    <c:if test="${not empty error}">
        <div class="alert alert-error">${error}</div>
    </c:if>

    <c:if test="${not empty booking}">
        <section class="provider-section">
            <h3>${service.serviceName}</h3>
            <p><strong>Provider:</strong> ${provider.businessName}</p>
            <p><strong>Booking Date:</strong> ${booking.bookingDate}</p>
            <p><strong>Total Paid:</strong> $${booking.totalPrice}</p>
        </section>

        <section class="provider-section">
            <form method="post" action="${pageContext.request.contextPath}/customer/review">
                <input type="hidden" name="bookingId" value="${booking.bookingId}">

                <div class="form-group">
                    <label>Rating</label>
                    <div class="star-group">
                        <input type="radio" id="star5" name="rating" value="5" required><label for="star5" title="5 stars">&#9733;</label>
                        <input type="radio" id="star4" name="rating" value="4"><label for="star4" title="4 stars">&#9733;</label>
                        <input type="radio" id="star3" name="rating" value="3"><label for="star3" title="3 stars">&#9733;</label>
                        <input type="radio" id="star2" name="rating" value="2"><label for="star2" title="2 stars">&#9733;</label>
                        <input type="radio" id="star1" name="rating" value="1"><label for="star1" title="1 star">&#9733;</label>
                    </div>
                </div>

                <div class="form-group">
                    <label for="comment">Comment (optional)</label>
                    <textarea id="comment" name="comment" rows="4" placeholder="Share your experience"></textarea>
                </div>

                <button type="submit" class="btn btn-primary">Submit Review</button>
            </form>
        </section>
    </c:if>
</div>

<footer class="footer">
    <p>&copy; 2025 NearFix. CS 157A - Team 5.</p>
</footer>

</body>
</html>
