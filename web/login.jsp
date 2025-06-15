<%-- 
    Document   : login.
    Created on : 31 May 2025, 11:44:57 am
    Author     : User
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
    <%@ include file="include/head.jsp" %>
    <body class="site-header">
        <div class="container section-padding">
            <div class="row justify-content-center">
                <div class="col-md-6">
                    <h2 class="text-center mb-4">Login</h2>
                    <%-- Check for message parameter --%>
                    <%
                        String message = request.getParameter("message");
                        String error = request.getParameter("error");
                        if ("success".equals(message)) {
                    %>
                    <div class="alert alert-success" role="alert">
                        Registration successful! Please log in.
                    </div>
                    <%
                    } else if ("invalid_credentials".equals(error)) {
                    %>
                    <div class="alert alert-danger" role="alert">
                        Invalid email or password. Please try again.
                    </div>
                    <%
                    } else if ("exception".equals(error)) {
                    %>
                    <div class="alert alert-danger" role="alert">
                        An error occurred. Please try again later.
                    </div>
                    <%
                        }
                    %>

                    <div class="tab-content p-4">
                        <form action="process/processLogin.jsp" method="post">
                            <div class="mb-3">
                                <label for="email" class="form-label">Email</label>
                                <input type="email" class="form-control" name="email" id="email" required>
                            </div>

                            <div class="mb-3">
                                <label for="password" class="form-label">Password</label>
                                <input type="password" class="form-control" name="password" id="password" required>
                                <div class="mb-3 text-end">
                                    <a href="forgotPassword.jsp" class="text-decoration-none small">Forgot your password?</a>
                                </div>

                            </div>

                            <div class="d-grid">
                                <input type="submit" class="btn custom-btn" value="Login">
                            </div>
                        </form>
                        <p class="text-center mt-3">Don't have an account? <a href="register.jsp">Register here</a>.</p>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
