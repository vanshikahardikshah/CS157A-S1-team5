<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>NearFix - Admin: Service Categories</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .container { max-width: 800px; margin: 2rem auto; padding: 1rem; }
        .card {
            background: white; border-radius: 12px;
            padding: 1rem 1.2rem; margin-bottom: 1rem;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
        }
        form.create-form label { display: block; margin: 0.6rem 0 0.2rem; font-weight: 600; }
        form.create-form input, form.create-form textarea {
            width: 100%; padding: 0.5rem; border: 1px solid #ccc; border-radius: 6px;
        }
        form.create-form button, .delete-btn {
            padding: 0.5rem 1rem; border: none; border-radius: 6px; font-weight: 600; cursor: pointer;
        }
        form.create-form button { background: #1f3c88; color: white; margin-top: 0.8rem; }
        .delete-btn { background: #c0392b; color: white; }
        table { width: 100%; border-collapse: collapse; }
        th, td { text-align: left; padding: 0.6rem; border-bottom: 1px solid #eee; vertical-align: top; }
        .alert-success { background: #e7f6ec; color: #1d6f3a; padding: 0.6rem 0.8rem; border-radius: 6px; margin-bottom: 1rem; }
        .alert-error { background: #fce8e8; color: #8a1f1f; padding: 0.6rem 0.8rem; border-radius: 6px; margin-bottom: 1rem; }
    </style>
</head>
<body>

<nav class="navbar">
    <a href="${pageContext.request.contextPath}/" class="logo">Near<span>Fix</span></a>
    <div class="nav-links">
        <span style="opacity:0.8;">Admin: <c:out value="${sessionScope.user.name}"/></span>
        <a href="${pageContext.request.contextPath}/logout">Logout</a>
    </div>
</nav>

<div class="container">
    <h1>Service Categories</h1>

    <c:if test="${not empty success}"><div class="alert-success"><c:out value="${success}"/></div></c:if>
    <c:if test="${not empty error}"><div class="alert-error"><c:out value="${error}"/></div></c:if>

    <div class="card">
        <h2>Create category</h2>
        <form class="create-form" method="post" action="${pageContext.request.contextPath}/admin/categories">
            <input type="hidden" name="action" value="create">
            <label for="name">Name</label>
            <input id="name" type="text" name="name" maxlength="100" required>
            <label for="description">Description</label>
            <textarea id="description" name="description" rows="3"></textarea>
            <button type="submit">Add Category</button>
        </form>
    </div>

    <div class="card">
        <h2>Existing categories</h2>
        <c:choose>
            <c:when test="${empty categories}">
                <p>No categories yet.</p>
            </c:when>
            <c:otherwise>
                <table>
                    <thead><tr><th>ID</th><th>Name</th><th>Description</th><th></th></tr></thead>
                    <tbody>
                        <c:forEach var="cat" items="${categories}">
                            <tr>
                                <td>${cat.categoryId}</td>
                                <td><c:out value="${cat.categoryName}"/></td>
                                <td><c:out value="${cat.description}"/></td>
                                <td>
                                    <form method="post" action="${pageContext.request.contextPath}/admin/categories" onsubmit="return confirm('Delete this category?');">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="categoryId" value="${cat.categoryId}">
                                        <button class="delete-btn" type="submit">Delete</button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:otherwise>
        </c:choose>
    </div>
</div>

</body>
</html>
