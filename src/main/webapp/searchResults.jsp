<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>NearFix - Search Results</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .filter-bar { display: grid; grid-template-columns: repeat(auto-fit, minmax(150px, 1fr)); gap: 0.75rem; align-items: end; }
        .filter-bar .form-group { margin: 0; }
        .filter-bar label { font-size: 0.85rem; font-weight: 600; display: block; margin-bottom: 0.25rem; }
        .filter-bar input, .filter-bar select {
            width: 100%; padding: 0.55rem 0.65rem;
            border: 1px solid var(--border); border-radius: var(--radius-sm);
            background: var(--surface); color: var(--text); font-size: 0.9rem;
        }
        .filter-actions { display: flex; gap: 0.5rem; }
        .result-meta { display: flex; flex-wrap: wrap; gap: 1rem; font-size: 0.88rem; color: var(--text-secondary); margin: 0.25rem 0 0.6rem; }
        .badge { display: inline-block; padding: 0.15rem 0.55rem; background: var(--surface-alt); border: 1px solid var(--border); border-radius: 999px; font-size: 0.78rem; color: var(--text-secondary); }
    </style>
</head>
<body>

<c:set var="userRole" value="${sessionScope.user.role}"/>

<nav class="navbar">
    <a href="${pageContext.request.contextPath}/" class="logo">Near<span>Fix</span></a>
    <div class="nav-links">
        <c:choose>
            <c:when test="${not empty sessionScope.user}">
                <c:choose>
                    <c:when test="${userRole == 'admin'}">
                        <a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a>
                    </c:when>
                    <c:when test="${userRole == 'provider'}">
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

<div class="results-container">
    <a class="back-link" href="${pageContext.request.contextPath}/">&larr; Back to Home</a>
    <h1>Search Results</h1>

    <section class="provider-section">
        <h3>Refine Search</h3>
        <form method="get" action="${pageContext.request.contextPath}/search" class="filter-bar">
            <div class="form-group">
                <label for="service">Keyword</label>
                <input type="text" id="service" name="service" value="<c:out value='${q_service}'/>" placeholder="e.g. cleaning">
            </div>
            <div class="form-group">
                <label for="categoryId">Category</label>
                <select id="categoryId" name="categoryId">
                    <option value="0">All categories</option>
                    <c:forEach var="cat" items="${categories}">
                        <option value="${cat.categoryId}" <c:if test="${q_categoryId == cat.categoryId}">selected</c:if>>${cat.categoryName}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="form-group">
                <label for="zipCode">ZIP Code</label>
                <input type="text" id="zipCode" name="zipCode" value="<c:out value='${q_zip}'/>" maxlength="10" placeholder="e.g. 95112">
            </div>
            <div class="form-group">
                <label for="minRating">Min Rating</label>
                <select id="minRating" name="minRating">
                    <option value="0">Any</option>
                    <c:forEach var="r" begin="1" end="5">
                        <option value="${r}" <c:if test="${q_minRating == r}">selected</c:if>>${r}+ stars</option>
                    </c:forEach>
                </select>
            </div>
            <div class="form-group">
                <label for="availableOn">Available On</label>
                <input type="date" id="availableOn" name="availableOn" value="<c:out value='${q_availableOn}'/>">
            </div>
            <div class="form-group filter-actions">
                <button type="submit" class="btn btn-primary btn-sm">Apply</button>
                <a class="btn btn-sm" href="${pageContext.request.contextPath}/search">Reset</a>
            </div>
        </form>
    </section>

    <c:choose>
        <c:when test="${empty results}">
            <p class="empty-message">No matching services found. Try a different keyword or relax your filters.</p>
        </c:when>
        <c:otherwise>
            <p class="help-text"><c:out value="${fn:length(results)}"/><c:if test="${not empty q_service}"> result(s) for &ldquo;<c:out value='${q_service}'/>&rdquo;</c:if>, ordered by relevance then location.</p>
            <c:forEach var="r" items="${results}">
                <div class="result-card">
                    <h3><c:out value="${r.serviceName}"/></h3>
                    <div class="result-meta">
                        <span class="badge"><c:out value="${r.categoryName}"/></span>
                        <c:if test="${r.zipMatch == 1}"><span class="badge">Matches your ZIP</span></c:if>
                    </div>
                    <p><strong>Provider:</strong> <c:out value="${r.businessName}"/></p>
                    <p><strong>Description:</strong> <c:out value="${r.description}"/></p>
                    <p><strong>Price:</strong> $<fmt:formatNumber value="${r.price}" minFractionDigits="2" maxFractionDigits="2"/></p>
                    <p><strong>ZIP Code:</strong> <c:out value="${r.locationZip}"/></p>
                    <p><strong>Email:</strong> <c:out value="${r.providerEmail}"/></p>
                    <p><strong>Rating:</strong>
                        <c:choose>
                            <c:when test="${r.reviewCount > 0}">
                                <span class="stars">
                                    <c:forEach var="i" begin="1" end="5">
                                        <c:choose>
                                            <c:when test="${i <= (r.avgRating + 0.5)}">&#9733;</c:when>
                                            <c:otherwise>&#9734;</c:otherwise>
                                        </c:choose>
                                    </c:forEach>
                                </span>
                                <fmt:formatNumber value="${r.avgRating}" minFractionDigits="1" maxFractionDigits="1"/> / 5
                                (${r.reviewCount} review<c:if test="${r.reviewCount != 1}">s</c:if>)
                            </c:when>
                            <c:otherwise>
                                <span style="color:var(--text-muted);">No reviews yet</span>
                            </c:otherwise>
                        </c:choose>
                    </p>
                    <div class="result-actions">
                        <a class="btn btn-primary btn-sm" href="${pageContext.request.contextPath}/providers/view?providerId=${r.providerId}">View Provider Profile</a>
                        <c:choose>
                            <c:when test="${userRole == 'customer'}">
                                <a class="btn btn-success btn-sm" href="${pageContext.request.contextPath}/customer/book?serviceId=${r.serviceId}">Request Booking</a>
                            </c:when>
                            <c:when test="${empty sessionScope.user}">
                                <a class="btn btn-success btn-sm" href="${pageContext.request.contextPath}/login">Login to Book</a>
                            </c:when>
                        </c:choose>
                    </div>
                </div>
            </c:forEach>
        </c:otherwise>
    </c:choose>
</div>

</body>
</html>
