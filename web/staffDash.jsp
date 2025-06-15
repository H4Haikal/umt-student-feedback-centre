<%-- 
    Document   : staffDash
    Created on : 9 Jun 2025
    Author     : User
--%>

<%@ page session="true" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String role = (String) session.getAttribute("userRole");
    if (role == null || !"staff".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
    <%@ include file="include/head.jsp" %>

    <body id="top">
        <main>
            <% request.setAttribute("currentPage", "staffDash");%>
            <%@ include file="include/navigation.jsp" %>

            <section class="hero-section d-flex justify-content-center align-items-center" id="section_1">
                <div class="container mt-5">
                    <div class="row justify-content-center">
                        <div class="col-md-8">
                            <div class="card shadow-sm p-4 position-relative">
                                <!-- Close "X" button -->
                                <a href="index.jsp" class="btn btn-sm btn-light position-absolute top-0 end-0 m-2" title="Back to Home">
                                    <i class="fas fa-times"></i>
                                </a>

                                <div class="d-flex align-items-center mb-4">
                                    <img src="https://bootdey.com/img/Content/avatar/avatar7.png" alt="Admin" class="rounded-circle" width="150">
                                    <div>
                                        <h2 class="mb-0">Welcome, <%= session.getAttribute("userName")%></h2>
                                        <small class="text-muted">Staff Dashboard</small>
                                    </div>
                                </div>

                                <p class="lead">
                                    This is your staff dashboard where you can assist students, manage content, and handle academic records.
                                </p>

                                <div class="d-flex gap-3 flex-wrap">
                                    <a href="userProfile.jsp" class="btn btn-primary btn-lg">
                                        <i class="fas fa-id-badge"></i> View Profile
                                    </a>
                                    <a href="creatThread.jsp" class="btn btn-outline-secondary btn-lg">
                                        <i class="fas fa-pen-nib"></i> Create Thread
                                    </a>
                                    <a href="ReportServlet" class="btn btn-outline-info btn-lg">
                                        <i class="fas fa-chart-line"></i> View Report
                                    </a>
                                </div>

                            </div>
                        </div>
                    </div>
                </div>
            </section>
        </main>

        <%@ include file="include/footer.jsp" %>

        <!-- JAVASCRIPT FILES -->
        <script src="js/jquery.min.js"></script>
        <script src="js/bootstrap.bundle.min.js"></script>
        <script src="js/jquery.sticky.js"></script>
        <script src="js/click-scroll.js"></script>
        <script src="js/custom.js"></script>
    </body>
</html>
