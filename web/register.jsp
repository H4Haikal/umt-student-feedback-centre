<%-- 
    Document   : register
    Created on : 31 May 2025, 11:21:31 am
    Author     : User
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <title>Register</title>
        <!-- Google Fonts and CSS Files -->        
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@500;600;700&family=Open+Sans&display=swap" rel="stylesheet">
        <link href="css/bootstrap.min.css" rel="stylesheet">
        <link href="css/bootstrap-icons.css" rel="stylesheet">
        <link href="css/templatemo-topic-listing.css" rel="stylesheet">
    </head>
    <body class="site-header">
        <div class=" container section-padding">
            <div class="row justify-content-center">
                <div class="col-md-6">
                    <%
                        String error = request.getParameter("error");
                        if ("invalid_adminkey".equals(error)) {
                    %>
                    <div class="alert alert-danger" role="alert">
                        Invalid Admin Key. Only authorized personnel can register as Admin.
                    </div>
                    <%
                        }
                    %>

                    <h2 class="text-center mb-4">Register</h2>
                    <div class="tab-content p-4">
                        <form action="process/processRegister.jsp" method="post">
                            <div class="mb-3">
                                <label for="role" class="form-label">Register As</label>
                                <select class="form-control" name="role" id="role" required onchange="showIDField()">
                                    <option value="" disabled selected>Select role</option>
                                    <option value="student">Student</option>
                                    <option value="staff">Staff</option>
                                    <option value="admin">Admin</option>
                                </select>
                            </div>

                            <div class="mb-3" id="studentIDDiv" style="display:none;">
                                <label for="studentID" class="form-label">Student ID</label>
                                <input type="text" class="form-control" name="studentID" id="studentID">
                            </div>
                            <div class="mb-3" id="staffIDDiv" style="display:none;">
                                <label for="staffID" class="form-label">Staff ID</label>
                                <input type="text" class="form-control" name="staffID" id="staffID">
                            </div>
                            <div class="mb-3" id="adminIDDiv" style="display:none;">
                                <label for="adminID" class="form-label">Admin ID</label>
                                <input type="text" class="form-control" name="adminID" id="adminID">
                            </div>
                            <div class="mb-3" id="adminKeyDiv" style="display:none;">
                                <label for="adminKey" class="form-label">Admin Key</label>
                                <input type="password" class="form-control" name="adminKey" id="adminKey">
                            </div>

                            <div class="mb-3">
                                <label for="name" class="form-label">Name</label>
                                <input type="text" class="form-control" name="name" id="name" required>
                            </div>

                            <div class="mb-3">
                                <label for="email" class="form-label">Email</label>
                                <input type="email" class="form-control" name="email" id="email" required>
                            </div>

                            <div class="mb-3">
                                <label for="password" class="form-label">Password</label>
                                <input type="password" class="form-control" name="password" id="password" required>
                            </div>

                            <div class="d-grid">
                                <input type="submit" class="btn custom-btn" value="Register">
                            </div>
                        </form>
                        <p class="text-center mt-3">Already have an account? <a href="login.jsp">Login here</a>.</p>
                    </div>
                </div>
            </div>
        </div>

        <script>
            function showIDField() {
                var role = document.getElementById('role').value;
                document.getElementById('studentIDDiv').style.display = (role === 'student') ? 'block' : 'none';
                document.getElementById('staffIDDiv').style.display = (role === 'staff') ? 'block' : 'none';
                document.getElementById('adminIDDiv').style.display = (role === 'admin') ? 'block' : 'none';
                document.getElementById('adminKeyDiv').style.display = (role === 'admin') ? 'block' : 'none';
            }

        </script>
    </body>
</html>
