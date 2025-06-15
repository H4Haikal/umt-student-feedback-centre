<%-- 
    Document   : createThread
    Created on : 4 Jun 2025, 10:10:11 pm
    Author     : User
--%>
<%@ page session="true" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
    if (session.getAttribute("userID") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
    <%@ include file="include/head.jsp" %>

    <body id="top">
        <main>
            <% request.setAttribute("currentPage", "createThread");%>
            <%@ include file="include/navigation.jsp" %>

            <section class="hero-section d-flex justify-content-center align-items-center" id="section_1">

                <div class="container">
                    <div class="card">
                        <div class="card-body">
                            <h4 class="mb-4">Create New Thread</h4>
                            <form action="CreateThreadServlet" method="post">
                                <div class="mb-3">
                                    <input type="text" name="title" class="form-control" placeholder="Thread title" required />
                                </div>
                                <button type="submit" class="btn btn-success">Post Thread</button>
                            </form>
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

