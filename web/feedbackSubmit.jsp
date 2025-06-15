<%-- 
    Document   : feedbackSubmit
    Created on : 14 Jun 2025, 4:24:41 pm
    Author     : User
--%>
<%
    String email = (String) session.getAttribute("userEmail");
    if (email == null) {
        response.sendRedirect("login.jsp");
        return;
    }

%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
    <%@ include file="include/head.jsp" %>

    <body id="top" class="bg-light">
        <main>
            <% request.setAttribute("currentPage", "feedback");%>
            <%@ include file="include/navigation.jsp" %>

            <!-- ✅ Hero Section -->
            <section class="hero-section d-flex justify-content-center align-items-center bg-primary text-white" id="section_1" style="min-height: 30vh;">
                <div class="container text-center">
                    <h1 class="display-5">
                        <c:choose>
                            <c:when test="${feedback != null}">Edit Feedback</c:when>
                            <c:otherwise>Submit Feedback</c:otherwise>
                        </c:choose>
                    </h1>
                    <p class="text-primary-emphasis">Help us improve by sharing your thoughts or refining your previous feedback.</p>
                </div>
            </section>

            <!-- ✅ Form Section -->
            <div class="container mt-5 mb-5">
                <div class="card shadow">
                    <div class="card-body">
                        <c:if test="${feedback != null}">
                            <form action="feedback?action=update" method="post">
                            </c:if>
                            <c:if test="${feedback == null}">
                                <form action="feedback?action=insert" method="post">
                                </c:if>

                                <c:if test="${feedback != null}">
                                    <input type="hidden" name="id" value="<c:out value='${feedback.feedbackID}' />" />
                                </c:if>

                                <div class="mb-3">
                                    <label class="form-label">Feedback Title</label>
                                    <input type="text"
                                           name="title"
                                           class="form-control"
                                           value="<c:out value='${feedback.title}' />"
                                           required />
                                </div>

                                <div class="mb-3">
                                    <label class="form-label">Feedback Content</label>
                                    <textarea name="content"
                                              class="form-control"
                                              rows="4"
                                              required><c:out value='${feedback.content}' /></textarea>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label">Category</label>
                                    <select name="category" class="form-select" required>
                                        <c:forEach var="cat" items="${categoryList}">
                                            <option value="${cat.name}" <c:if test="${feedback != null && feedback.category == cat.name}">selected</c:if>>
                                                ${cat.name}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <div class="d-flex justify-content-between align-items-center">
                                    <a href="feedback?action=list" class="btn btn-secondary">Back</a>
                                    <button type="submit" class="btn btn-success">
                                        <i class="bi bi-send me-1"></i> Save
                                    </button>
                                </div>
                            </form>
                    </div>
                </div>
            </div>
        </main>

        <%@ include file="include/footer.jsp" %>

        <!-- Scripts -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script src="js/jquery.min.js"></script>
        <script src="js/bootstrap.bundle.min.js"></script>
        <script src="js/jquery.sticky.js"></script>
        <script src="js/click-scroll.js"></script>
        <script src="js/custom.js"></script>
    </body>
</html>
