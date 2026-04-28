<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>NearFix - Search Results</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .results-container {
            max-width: 900px;
            margin: 2rem auto;
            padding: 1rem;
        }

        .result-card {
            background: white;
            border-radius: 12px;
            padding: 1rem 1.2rem;
            margin-bottom: 1rem;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
        }

        .result-card h3 {
            margin-bottom: 0.5rem;
        }

        .result-card .meta {
            font-size: 0.9rem;
            opacity: 0.8;
            margin-bottom: 0.5rem;
        }

        .back-link {
            display: inline-block;
            margin-bottom: 1rem;
            text-decoration: none;
            color: #1f3c88;
            font-weight: 600;
        }

        .refine-bar {
            display: flex;
            gap: 0.5rem;
            margin-bottom: 1.5rem;
        }
        .refine-bar input {
            flex: 1;
            padding: 0.6rem 0.8rem;
            border: 1px solid #ccc;
            border-radius: 8px;
        }
        .refine-bar button {
            padding: 0.6rem 1.2rem;
            border: none;
            border-radius: 8px;
            background: #1f3c88;
            color: white;
            font-weight: 600;
            cursor: pointer;
        }
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
                        <a href="${pageContext.request.contextPath}/provider/services">My Services</a>
                        <a href="${pageContext.request.contextPath}/provider/bookings">Bookings</a>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/profile">My Profile</a>
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

<div class="results-container">
    <a class="back-link" href="${pageContext.request.contextPath}/">&larr; Back to Home</a>
    <h1>Search Results</h1>

    <form action="${pageContext.request.contextPath}/search" method="get" class="refine-bar">
        <input type="text" name="service" value="<c:out value='${query}'/>" placeholder="Service keyword" required>
        <input type="text" name="zipCode" value="<c:out value='${zipCode}'/>" placeholder="ZIP" maxlength="10" style="max-width:140px;">
        <button type="submit">Search</button>
    </form>

    <c:choose>
        <c:when test="${empty results}">
            <p>No matching services found for "<c:out value='${query}'/>"<c:if test="${not empty zipCode}"> in ZIP <c:out value='${zipCode}'/></c:if>.</p>
        </c:when>
        <c:otherwise>
            <p style="margin-bottom:1rem; opacity:0.75;"><c:out value='${results.size()}'/> result(s) for "<c:out value='${query}'/>"<c:if test="${not empty zipCode}"> in ZIP <c:out value='${zipCode}'/></c:if>.</p>
            <c:forEach var="r" items="${results}">
                <div class="result-card">
                    <h3><c:out value="${r.serviceName}"/></h3>
                    <div class="meta">
                        <c:out value="${r.categoryName}"/>
                        <c:if test="${not empty r.businessName}"> &middot; <c:out value="${r.businessName}"/></c:if>
                        <c:if test="${not empty r.locationZip}"> &middot; ZIP <c:out value="${r.locationZip}"/></c:if>
                    </div>
                    <div class="rating">
                        <c:choose>
                            <c:when test="${r.reviewCount > 0}">
                                <span style="color:#f5a623;font-weight:700;">&#9733; <fmt:formatNumber value="${r.avgRating}" minFractionDigits="1" maxFractionDigits="1"/></span>
                                <span style="opacity:0.7;font-size:0.9rem;">(${r.reviewCount} review<c:if test="${r.reviewCount != 1}">s</c:if>)</span>
                            </c:when>
                            <c:otherwise>
                                <span style="opacity:0.7;font-size:0.9rem;">No reviews yet</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <p><c:out value="${r.description}"/></p>
                    <p><strong>Price:</strong> $<fmt:formatNumber value="${r.price}" minFractionDigits="2" maxFractionDigits="2"/></p>
                    <c:if test="${not empty r.contactNumber}">
                        <p><strong>Phone:</strong> <c:out value="${r.contactNumber}"/></p>
                    </c:if>
                    <c:if test="${not empty r.providerEmail}">
                        <p><strong>Email:</strong> <c:out value="${r.providerEmail}"/></p>
                    </c:if>
                    <p style="margin-top:0.6rem;">
                        <a href="${pageContext.request.contextPath}/review?providerId=${r.providerId}" style="color:#1f3c88;font-weight:600;text-decoration:none;">Read &amp; leave reviews &rarr;</a>
                    </p>
                </div>
            </c:forEach>
        </c:otherwise>
    </c:choose>
</div>

</body>
</html>
