<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Provider Profile - NearFix</title>
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

<div class="profile-container">
    <h2 style="margin-bottom:1.5rem; color:#2c3e50;">Provider Profile</h2>

    <c:if test="${not empty success}">
        <div class="alert alert-success">${success}</div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-error">${error}</div>
    </c:if>

    <section>
        <h3>${not empty provider ? 'Edit Profile' : 'Create Provider Profile'}</h3>
        <form method="post" action="${pageContext.request.contextPath}/provider/profile">
            <div class="form-group">
                <label for="businessName">Business Name</label>
                <input type="text" id="businessName" name="businessName"
                       value="${provider.businessName}" required
                       placeholder="e.g. John's Plumbing Services">
            </div>
            <div class="form-group">
                <label for="contactNumber">Contact Number</label>
                <input type="tel" id="contactNumber" name="contactNumber"
                       value="${provider.contactNumber}" required
                       placeholder="e.g. (408) 555-1234">
            </div>
            <div class="form-group">
                <label>Email</label>
                <input type="email" value="${sessionScope.user.email}" disabled>
            </div>
            <div class="form-group">
                <label>Zip Code</label>
                <input type="text" value="${sessionScope.user.zipCode}" disabled>
            </div>
            <c:if test="${not empty provider}">
                <div class="form-group">
                    <label>Approval Status</label>
                    <input type="text" value="${provider.approvalStatus}" disabled>
                </div>
            </c:if>
            <button type="submit" class="btn btn-primary">
                ${not empty provider ? 'Update Profile' : 'Create Profile'}
            </button>
        </form>
    </section>
</div>

<footer class="footer">
    <p>&copy; 2025 NearFix. CS 157A - Team 5.</p>
</footer>

</body>
</html>
