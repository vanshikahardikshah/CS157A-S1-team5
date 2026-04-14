<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Availability - NearFix</title>
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
    <h2>My Availability</h2>

    <c:if test="${not empty success}">
        <div class="alert alert-success">${success}</div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-error">${error}</div>
    </c:if>

    <!-- Add Availability Slot -->
    <section class="provider-section">
        <h3>Add Availability Slot</h3>
        <form method="post" action="${pageContext.request.contextPath}/provider/availability">
            <input type="hidden" name="action" value="add">
            <div class="form-row">
                <div class="form-group">
                    <label for="availableDate">Date</label>
                    <input type="date" id="availableDate" name="availableDate" required>
                </div>
                <div class="form-group">
                    <label for="startTime">Start Time</label>
                    <input type="time" id="startTime" name="startTime" required>
                </div>
                <div class="form-group">
                    <label for="endTime">End Time</label>
                    <input type="time" id="endTime" name="endTime" required>
                </div>
            </div>
            <button type="submit" class="btn btn-primary">Add Slot</button>
        </form>
    </section>

    <!-- Current Slots -->
    <section class="provider-section">
        <h3>Your Availability Slots</h3>
        <c:choose>
            <c:when test="${empty slots}">
                <p class="empty-message">No availability slots set.</p>
            </c:when>
            <c:otherwise>
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>Date</th>
                            <th>Start Time</th>
                            <th>End Time</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="slot" items="${slots}">
                            <tr>
                                <td>${slot.availableDate}</td>
                                <td>${slot.startTime}</td>
                                <td>${slot.endTime}</td>
                                <td>
                                    <form method="post" action="${pageContext.request.contextPath}/provider/availability"
                                          style="display:inline;"
                                          onsubmit="return confirm('Remove this slot?');">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="slotId" value="${slot.availabilityId}">
                                        <button type="submit" class="btn btn-danger btn-sm">Remove</button>
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
