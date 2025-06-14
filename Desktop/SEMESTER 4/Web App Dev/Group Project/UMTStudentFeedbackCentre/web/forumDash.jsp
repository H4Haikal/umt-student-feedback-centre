<%@ page session="true" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*, java.util.*, db.DBConnection" %>
<%
    String role = (String) session.getAttribute("userRole");
    String userID = (String) session.getAttribute("userID");
    if (role == null || userID == null || (!"admin".equals(role) && !"student".equals(role) && !"staff".equals(role))) {
        response.sendRedirect("login.jsp");
        return;
    }
    String filter = request.getParameter("filter");
%>
<!DOCTYPE html>
<html lang="en">
    <%@ include file="include/head.jsp" %>
    <body id="top">
        <main>
            <% request.setAttribute("currentPage", "forumDash");%>
            <%@ include file="include/navigation.jsp" %>

            <section class="hero-section d-flex justify-content-center align-items-center" id="section_1">
                <div class="row gutters-sm container">
                    <div class="col-md-4 mb-3">
                        <!-- ✅ Hero Section -->
                        <section class="hero-section d-flex justify-content-center align-items-center bg-primary text-white" id="section_1" style="min-height: 30vh;">
                            <div class="container text-center">
                                <h1 class="display-5">Student Feedback List</h1>
                                <p class="text-primary-emphasis">View, upvote, and contribute feedback to improve our campus life.</p>

                                <!-- Custom Submit Button -->

                                <a class="btn btn-lg btn-light text-dark fw-semibold shadow px-4 py-2 mt-3" href="createThread.jsp">
                                    <i class="bi bi-pencil-square me-2"></i> 
                                    + New Thread</a>
                            </div>
                        </section>

                        <div class="card mt-3">
                            
                        </div>
                    </div>

                    <div class="col-md-8">
                        <div class="card mb-3">
                            <div class="card-body">
                                <div class="d-flex justify-content-between align-items-center mb-3">
                                    <h4 class="mb-0">Latest Threads</h4>
                                    <div>
                                        <a class="btn btn-outline-primary btn-sm me-2" href="forumDash.jsp">All Threads</a>
                                        <a class="btn btn-outline-secondary btn-sm" href="forumDash.jsp?filter=mine">My Threads</a>
                                    </div>
                                </div>
                                <%
                                    try {
                                        Connection conn = DBConnection.getConnection();
                                        String sql = "SELECT t.threadID, t.title, t.createdBy, t.createdDate, u.name FROM forumthread t LEFT JOIN user u ON t.createdBy = u.userID";
                                        if ("mine".equals(filter)) {
                                            sql += " WHERE t.createdBy = ?";
                                        }
                                        sql += " ORDER BY t.createdDate DESC";
                                        PreparedStatement ps = conn.prepareStatement(sql);
                                        if ("mine".equals(filter)) {
                                            ps.setString(1, userID);
                                        }
                                        ResultSet rs = ps.executeQuery();
                                        while (rs.next()) {
                                %>
                                <div class="card mb-3 shadow-sm">
                                    <div class="card-body">
                                        <h5>
                                            <a href="viewThread.jsp?threadID=<%= rs.getInt("threadID")%>">
                                                <%= rs.getString("title")%>
                                            </a>
                                        </h5>
                                        <p class="mb-1 text-muted">
                                            By <strong><%= rs.getString("name") != null ? rs.getString("name") : rs.getString("createdBy")%></strong>
                                            on <%= rs.getDate("createdDate")%>
                                        </p>
                                    </div>
                                </div>
                                <%
                                        }
                                    } catch (Exception e) {
                                        out.println("<p class='text-danger'>Error loading threads.</p>");
                                        e.printStackTrace();
                                    }
                                %>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
        </main>
        <%@ include file="include/footer.jsp" %>
        <script src="js/jquery.min.js"></script>
        <script src="js/bootstrap.bundle.min.js"></script>
        <script src="js/jquery.sticky.js"></script>
        <script src="js/click-scroll.js"></script>
        <script src="js/custom.js"></script>
    </body>
</html>