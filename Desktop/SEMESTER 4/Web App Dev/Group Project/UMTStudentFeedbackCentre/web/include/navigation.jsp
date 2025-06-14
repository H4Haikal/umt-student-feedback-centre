
<%-- 
    Document   : navigation
    Created on : 31 May 2025, 2:06:08 pm
    Author     : User
--%>


<!-- Make sure Bootstrap and Bootstrap Icons are linked in your main layout -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

<nav class="navbar navbar-expand-lg">
    <div class="container">
        <a class="navbar-brand" href="index.jsp">
            <i class="bi-back"></i>
            <span>UMTSFC</span>
        </a>

        <!-- Mobile Profile + Logout -->
        <div class="d-lg-none ms-auto me-4 d-flex align-items-center gap-3">
            <a href="userProfile.jsp" class="navbar-icon bi-person" title="Profile"></a>
            <a href="logout.jsp" class="navbar-icon bi-box-arrow-right" title="Logout"
               onclick="return confirm('Are you sure you want to logout?')"></a>
        </div>

        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav"
                aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-lg-5 me-lg-auto">
                <li class="nav-item">
                    <a class="nav-link <%= "home".equals(request.getAttribute("currentPage")) ? " active" : ""%>" href="index.jsp">Home</a>
                </li>

                <li class="nav-item">
                    <a class="nav-link <%= "feedback".equals(request.getAttribute("currentPage")) ? " active" : ""%>" href="feedback?action=list">Feedback</a>
                </li>


                <li class="nav-item">
                    <a class="nav-link <%= "forum".equals(request.getAttribute("currentPage")) ? " active" : ""%>" href="forumDash.jsp">Forum</a>
                </li>

                <%

                    if ("admin".equals(session.getAttribute("userRole"))) {
                %>
                <li class="nav-item">
                    <a class="nav-link <%= "manageUsers".equals(request.getAttribute("currentPage")) ? " active" : ""%>" href="manageUsers.jsp">User Activities</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link <%= "report".equals(request.getAttribute("currentPage")) ? " active" : ""%>" href="ReportServlet">Report</a>
                </li>
                <%
                } else if ("staff".equals(session.getAttribute("userRole"))) {
                %>
                <li class="nav-item">
                    <a class="nav-link <%= "report".equals(request.getAttribute("currentPage")) ? " active" : ""%>" href="ReportServlet">Report</a>
                </li>
                <%
                } else if ("student".equals(session.getAttribute("userRole"))) {
                    // Students see no extra nav links (only Home, Feedback, Forum, Profile)
                } else {
                %>

                <%
                    }
                %>

                <li class="nav-item">
                    <a class="nav-link <%= "profile".equals(request.getAttribute("currentPage")) ? " active" : ""%>" href="userProfile.jsp">Profile</a>
                </li>
            </ul>

            <!-- Desktop Profile + Logout -->
            <div class="d-none d-lg-flex align-items-center gap-3">
                <a href="userProfile.jsp" class="navbar-icon bi-person" title="Profile"></a>
                <a href="logout.jsp" class="navbar-icon bi-box-arrow-right" title="Logout"
                   onclick="return confirm('Are you sure you want to logout?')"></a>
            </div>
        </div>
    </div>
    <!-- TEMP DEBUG -->
    <% out.println("Sign In As: " + session.getAttribute("userRole"));%>

</nav>
