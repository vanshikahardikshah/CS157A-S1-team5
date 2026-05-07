<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Provider Approvals - NearFix</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<nav class="navbar">
    <a href="${pageContext.request.contextPath}/" class="logo">Near<span>Fix</span></a>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/admin/approvals">Provider Approvals</a>
        <a href="${pageContext.request.contextPath}/logout">Logout</a>
    </div>
</nav>

<div class="provider-container">
    <h2>Provider Account Approvals</h2>

    <c:if test="${not empty sessionScope.success}">
        <div class="alert alert-success">${sessionScope.success}</div>
        <c:remove var="success" scope="session"/>
    </c:if>

    <c:if test="${not empty sessionScope.error}">
        <div class="alert alert-error">${sessionScope.error}</div>
        <c:remove var="error" scope="session"/>
    </c:if>

    <c:choose>
        <c:when test="${empty providers}">
            <p class="empty-message">No providers found.</p>
        </c:when>
        <c:otherwise>
            <table class="data-table">
                <thead>
                    <tr>
                        <th>Provider ID</th>
                        <th>Name</th>
                        <th>Email</th>
                        <th>Business Name</th>
                        <th>Phone</th>
                        <th>ZIP</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="provider" items="${providers}">
                        <tr>
                            <td>${provider.providerId}</td>
                            <td>${provider.name}</td>
                            <td>${provider.email}</td>
                            <td>${provider.businessName}</td>
                            <td>${provider.contactNumber}</td>
                            <td>${provider.zipCode}</td>
                            <td>${provider.approvalStatus}</td>
                            <td>
                                <form method="post" action="${pageContext.request.contextPath}/admin/approvals" style="display:inline;">
                                    <input type="hidden" name="providerId" value="${provider.providerId}">
                                    <input type="hidden" name="action" value="approve">
                                    <button type="submit" class="btn btn-primary btn-sm">Approve</button>
                                </form>

                                <form method="post" action="${pageContext.request.contextPath}/admin/approvals" style="display:inline;">
                                    <input type="hidden" name="providerId" value="${provider.providerId}">
                                    <input type="hidden" name="action" value="reject">
                                    <button type="submit" class="btn btn-danger btn-sm">Reject</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </c:otherwise>
    </c:choose>
</div>

<footer class="footer">
    <p>&copy; 2025 NearFix. CS 157A - Team 5.</p>
</footer>

</body>
</html>