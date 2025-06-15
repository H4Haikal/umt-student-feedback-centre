<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    String email = (String) session.getAttribute("userEmail");
    if (email == null) {
        response.sendRedirect("login.jsp");
        return;
    }

%>
<!DOCTYPE html>
<html lang="en">
    <%@ include file="include/head.jsp" %>
    <body id="top">
        <main>

            <% request.setAttribute("currentPage", "feedback");%>
            <%@ include file="include/navigation.jsp" %>

            <!-- ✅ Hero Section -->
            <section class="hero-section d-flex justify-content-center align-items-center bg-primary text-white" id="section_1" style="min-height: 30vh;">
                <div class="container text-center">
                    <h1 class="display-5">Student Feedback List</h1>
                    <p class="text-primary-emphasis">View, upvote, and contribute feedback to improve our campus life.</p>

                    <!-- Custom Submit Button -->
                    <a href="feedback?action=new" class="btn btn-lg btn-light text-dark fw-semibold shadow px-4 py-2 mt-3">
                        <i class="bi bi-pencil-square me-2"></i> Submit New Feedback
                    </a>
                </div>
            </section>
            <!-- Filter Toggle Buttons -->
            <div class="d-flex justify-content-center mb-4 mt-2">
                <a href="feedback?action=list&filter=all" class="btn btn-outline-primary me-2 ${param.filter == 'all' || param.filter == null ? 'active' : ''}">
                    <i class="bi bi-people-fill me-1"></i> All Feedback
                </a>
                <a href="feedback?action=list&filter=mine" class="btn btn-outline-success ${param.filter == 'mine' ? 'active' : ''}">
                    <i class="bi bi-person-fill-check me-1"></i> My Feedback
                </a>
            </div>

            <!-- ✅ Feedback Cards Section -->
            <div class="container my-5">
                <div class="row g-4">
                    <c:forEach var="feedback" items="${listFeedback}">
                        <c:if test="${param.filter == null || param.filter == 'all' || (param.filter == 'mine' && feedback.userID == sessionScope.userID)}">

                            <div class="col-md-6 col-lg-4">
                                <div class="card shadow-sm h-100">
                                    <div class="card-body d-flex flex-column">
                                        <h5 class="card-title text-primary">${feedback.title}</h5>
                                        <p class="card-text mb-2 text-muted small">${feedback.createdAt} by ${feedback.userID}</p>
                                        <p class="card-text">${feedback.content}</p>

                                        <div class="mt-auto">
                                            <span class="badge bg-info mb-2">${feedback.category}</span>
                                            <span class="badge ${feedback.status == 'Resolved' ? 'bg-success' : 'bg-warning'} mb-2">${feedback.status}</span>
                                            <span class="badge bg-secondary mb-2">${feedback.upvotes} Upvotes</span>

                                            <!-- Upvote -->
                                            <div class="mb-2">
                                                <c:choose>
                                                    <c:when test="${feedback.userID == sessionScope.userID}">
                                                        <span class="text-muted">Your Feedback</span>
                                                    </c:when>
                                                    <c:when test="${upvotedSet.contains(feedback.feedbackID)}">
                                                        <button class="btn btn-sm btn-outline-secondary w-100" disabled>Upvoted</button>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <form action="feedback?action=upvote" method="post">
                                                            <input type="hidden" name="id" value="${feedback.feedbackID}" />
                                                            <button type="submit" class="btn btn-sm btn-outline-primary w-100">Upvote</button>
                                                        </form>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>

                                            <!-- Admin Status Toggle -->
                                            <c:if test="${sessionScope.userRole == 'admin'}">
                                                <form action="feedback?action=toggleStatus" method="post" class="mb-2">
                                                    <input type="hidden" name="id" value="${feedback.feedbackID}" />
                                                    <input type="hidden" name="currentStatus" value="${feedback.status}" />
                                                    <button type="submit"
                                                            class="btn btn-sm w-100 ${feedback.status == 'Resolved' ? 'btn-success' : 'btn-warning'}">
                                                        Toggle Status
                                                    </button>
                                                </form>
                                            </c:if>

                                            <!-- Actions -->
                                            <c:if test="${feedback.userID == sessionScope.userID}">
                                                <div class="d-flex justify-content-between">
                                                    <a href="feedback?action=edit&id=${feedback.feedbackID}" class="btn btn-sm btn-secondary w-50 me-1">Edit</a>
                                                    <a href="feedback?action=delete&id=${feedback.feedbackID}" onclick="return confirm('Are you sure?')" class="btn btn-sm btn-danger w-50">Delete</a>
                                                </div>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:if>
                    </c:forEach>
                </div>

                <!-- Add New Feedback Button -->
                <div class="d-flex justify-content-end mt-4">
                    <a href="feedback?action=new" class="btn btn-success">
                        <i class="bi bi-plus-lg me-1"></i> Submit New Feedback
                    </a>
                </div>
            </div>
        </main>

        <%@ include file="include/footer.jsp" %>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script src="js/jquery.min.js"></script>
        <script src="js/bootstrap.bundle.min.js"></script>
        <script src="js/jquery.sticky.js"></script>
        <script src="js/click-scroll.js"></script>
        <script src="js/custom.js"></script>
    </body>
</html>
