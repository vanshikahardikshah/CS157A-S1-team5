<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Categories - NearFix</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<nav class="navbar">
    <a href="${pageContext.request.contextPath}/" class="logo">Near<span>Fix</span></a>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a>
        <a href="${pageContext.request.contextPath}/admin/approvals">Approvals</a>
        <a href="${pageContext.request.contextPath}/admin/categories">Categories</a>
        <a href="${pageContext.request.contextPath}/admin/reviews">Reviews</a>
        <a href="${pageContext.request.contextPath}/admin/users">Users</a>
        <a href="${pageContext.request.contextPath}/logout">Logout</a>
    </div>
</nav>

<div class="provider-container">
    <h2>Manage Service Categories</h2>

    <c:if test="${not empty sessionScope.success}">
        <div class="alert alert-success">${sessionScope.success}</div>
        <c:remove var="success" scope="session"/>
    </c:if>
    <c:if test="${not empty sessionScope.error}">
        <div class="alert alert-error">${sessionScope.error}</div>
        <c:remove var="error" scope="session"/>
    </c:if>

    <section class="provider-section">
        <h3>Add New Category</h3>
        <form method="post" action="${pageContext.request.contextPath}/admin/categories">
            <input type="hidden" name="action" value="create">
            <div class="form-group">
                <label for="categoryName">Name</label>
                <input type="text" id="categoryName" name="categoryName" required maxlength="100" placeholder="e.g. Roofing">
            </div>
            <div class="form-group">
                <label for="description">Description</label>
                <textarea id="description" name="description" rows="2" placeholder="What this category covers"></textarea>
            </div>
            <button type="submit" class="btn btn-primary">Add Category</button>
        </form>
    </section>

    <section class="provider-section">
        <h3>Existing Categories</h3>
        <c:choose>
            <c:when test="${empty categories}">
                <p class="empty-message">No categories defined yet.</p>
            </c:when>
            <c:otherwise>
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Name</th>
                            <th>Description</th>
                            <th>Services</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="cat" items="${categories}">
                            <tr>
                                <td>${cat.categoryId}</td>
                                <td>${cat.categoryName}</td>
                                <td>${cat.description}</td>
                                <td>${cat.serviceCount}</td>
                                <td>
                                    <form method="post" action="${pageContext.request.contextPath}/admin/categories"
                                          onsubmit="return confirm('Delete this category? Only allowed if no services use it.');">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="categoryId" value="${cat.categoryId}">
                                        <button type="submit" class="btn btn-danger btn-sm" <c:if test="${cat.serviceCount > 0}">disabled</c:if>>Delete</button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:otherwise>
        </c:choose>
    </section>
</div>

<footer class="footer">
    <p>&copy; 2025 NearFix. CS 157A - Team 5.</p>
</footer>

</body>
</html>
