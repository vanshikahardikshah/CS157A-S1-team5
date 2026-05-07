<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile - NearFix</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
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

<div class="profile-container">
    <h2 style="margin-bottom:1.5rem;">Welcome, ${sessionScope.user.name}</h2>

    <c:if test="${not empty success}">
        <div class="alert alert-success">${success}</div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-error">${error}</div>
    </c:if>

    <section>
        <h3>Edit Profile</h3>
        <form method="post" action="${pageContext.request.contextPath}/profile">
            <input type="hidden" name="action" value="updateProfile">
            <div class="form-group">
                <label for="name">Full Name</label>
                <input type="text" id="name" name="name" value="${sessionScope.user.name}" required>
            </div>
            <div class="form-group">
                <label for="zipCode">Zip Code</label>
                <input type="text" id="zipCode" name="zipCode" value="${sessionScope.user.zipCode}" placeholder="e.g. 95112">
            </div>
            <div class="form-group">
                <label>Email</label>
                <input type="email" value="${sessionScope.user.email}" disabled>
            </div>
            <button type="submit" class="btn btn-primary">Update Profile</button>
        </form>
    </section>

    <section>
        <h3>Change Password</h3>
        <form method="post" action="${pageContext.request.contextPath}/profile">
            <input type="hidden" name="action" value="changePassword">
            <div class="form-group">
                <label for="oldPassword">Current Password</label>
                <input type="password" id="oldPassword" name="oldPassword" required>
            </div>
            <div class="form-group">
                <label for="newPassword">New Password</label>
                <input type="password" id="newPassword" name="newPassword" required minlength="6">
            </div>
            <button type="submit" class="btn btn-primary">Change Password</button>
        </form>
    </section>

    <section>
        <h3>Delete Account</h3>
        <p style="font-size:0.9rem; margin-bottom:1rem; color:var(--text-secondary);">This action is permanent and cannot be undone.</p>
        <form method="post" action="${pageContext.request.contextPath}/profile"
              onsubmit="return confirm('Are you sure you want to delete your account? This cannot be undone.');">
            <input type="hidden" name="action" value="deleteAccount">
            <div class="form-group">
                <label for="deletePassword">Confirm Password</label>
                <input type="password" id="deletePassword" name="password" required>
            </div>
            <button type="submit" class="btn btn-danger">Delete My Account</button>
        </form>
    </section>
</div>

<footer class="footer">
    <p>&copy; 2025 NearFix. CS 157A - Team 5.</p>
</footer>

</body>
</html>
