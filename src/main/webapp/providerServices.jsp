<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Services - NearFix</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<nav class="navbar">
    <a href="${pageContext.request.contextPath}/" class="logo">Near<span>Fix</span></a>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/provider/profile">Profile</a>
        <a href="${pageContext.request.contextPath}/provider/services">Services</a>
        <a href="${pageContext.request.contextPath}/provider/availability">Availability</a>
        <a href="${pageContext.request.contextPath}/provider/bookings">Bookings</a>
        <a href="${pageContext.request.contextPath}/logout">Logout</a>
    </div>
</nav>

<div class="provider-container">
    <h2>My Services</h2>

    <c:if test="${not empty success}">
        <div class="alert alert-success">${success}</div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-error">${error}</div>
    </c:if>

    <!-- Add New Service -->
    <section class="provider-section">
        <h3>Add a New Service</h3>
        <form method="post" action="${pageContext.request.contextPath}/provider/services">
            <input type="hidden" name="action" value="add">
            <div class="form-group">
                <label for="serviceName">Service Name</label>
                <input type="text" id="serviceName" name="serviceName" required placeholder="e.g. Pipe Repair">
            </div>
            <div class="form-group">
                <label for="categoryId">Category</label>
                <select id="categoryId" name="categoryId" required class="form-select">
                    <option value="">-- Select Category --</option>
                    <c:forEach var="cat" items="${categories}">
                        <option value="${cat.categoryId}">${cat.categoryName}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="form-group">
                <label for="description">Description</label>
                <textarea id="description" name="description" rows="3" class="form-textarea"
                          placeholder="Describe your service..."></textarea>
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label for="price">Price Rate ($)</label>
                    <input type="number" id="price" name="price" step="0.01" min="0" required placeholder="0.00">
                </div>
                <div class="form-group">
                    <label for="locationZip">Service Zip Code</label>
                    <input type="text" id="locationZip" name="locationZip" pattern="\d{5}" maxlength="5"
                           value="${sessionScope.user.zipCode}" placeholder="e.g. 95112">
                </div>
            </div>
            <button type="submit" class="btn btn-primary">Add Service</button>
        </form>
    </section>

    <!-- Existing Services -->
    <section class="provider-section">
        <h3>Your Services</h3>
        <c:choose>
            <c:when test="${empty services}">
                <p class="empty-message">You haven't added any services yet.</p>
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
                            <form method="post" action="${pageContext.request.contextPath}/provider/services"
                                  onsubmit="return confirm('Remove this service?');">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="serviceId" value="${svc.serviceId}">
                                <button type="submit" class="btn btn-danger btn-sm">Remove</button>
                            </form>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </section>
</div>

<footer class="footer">
    <p>&copy; 2025 NearFix. CS 157A - Team 5.</p>
</footer>

</body>
</html>
