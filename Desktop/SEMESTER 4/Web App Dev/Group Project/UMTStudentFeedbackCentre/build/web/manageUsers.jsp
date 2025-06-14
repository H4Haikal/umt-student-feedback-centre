<%@page import="db.DBConnection"%>
<%@ page import="java.sql.*, java.util.*" %>
<%@ page session="true" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%
    request.setAttribute("currentPage", "manageUsers");
    String role = (String) session.getAttribute("userRole");
    if (role == null || !"admin".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        conn = DBConnection.getConnection();

        // Get all users
        ps = conn.prepareStatement("SELECT userID, name, email, role FROM user ORDER BY name");
        rs = ps.executeQuery();
%>
<!doctype html>
<html lang="en">
    <%@ include file="include/head.jsp" %>
    <body id="top">
        <main>
            <%@ include file="include/navigation.jsp" %>

            <section class="hero-section d-flex justify-content-center align-items-center" id="section_1">
                <div class="container">
                    <h2 class="mb-4">User Activity</h2>
                    <div class="accordion" id="userAccordion">

                        <% while (rs.next()) {
                                String uid = rs.getString("userID");
                                String uname = rs.getString("name");
                                String uemail = rs.getString("email");
                                String urole = rs.getString("role");

                                // Feedbacks
                                List<String[]> feedbacks = new ArrayList<>();
                                PreparedStatement psFb = conn.prepareStatement("SELECT content, status FROM feedback WHERE userID = ?");
                                psFb.setString(1, uid);
                                ResultSet rsFb = psFb.executeQuery();
                                while (rsFb.next()) {
                                    feedbacks.add(new String[]{rsFb.getString("content"), rsFb.getString("status")});
                                }
                                rsFb.close();
                                psFb.close();

                                // Threads
                                List<String> threads = new ArrayList<>();
                                psFb = conn.prepareStatement("SELECT title FROM forumthread WHERE createdBy = ?");
                                psFb.setString(1, uid);
                                rsFb = psFb.executeQuery();
                                while (rsFb.next()) {
                                    threads.add(rsFb.getString("title"));
                                }
                                rsFb.close();
                                psFb.close();

                                // Replies
                                List<String[]> replies = new ArrayList<>();
                                psFb = conn.prepareStatement("SELECT ft.title, fp.content FROM forumpost fp JOIN forumthread ft ON fp.threadID = ft.threadID WHERE fp.postedBy = ?");
                                psFb.setString(1, uid);
                                rsFb = psFb.executeQuery();
                                while (rsFb.next()) {
                                    replies.add(new String[]{rsFb.getString("title"), rsFb.getString("content")});
                                }
                                rsFb.close();
                                psFb.close();

                                // Upvoted feedbacks
                                List<String> upvoted = new ArrayList<>();
                                psFb = conn.prepareStatement("SELECT f.content FROM feedback f JOIN feedbackupvote fu ON f.feedbackID = fu.feedbackID WHERE fu.userID = ?");
                                psFb.setString(1, uid);
                                rsFb = psFb.executeQuery();
                                while (rsFb.next()) {
                                    upvoted.add(rsFb.getString("content"));
                                }
                                rsFb.close();
                                psFb.close();
                        %>

                        <div class="accordion-item">
                            <h2 class="accordion-header" id="heading<%= uid%>">
                                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapse<%= uid%>">
                                    <strong><%= uname%> (<%= uemail%>)</strong> - <%= urole%>
                                </button>
                            </h2>
                            <div id="collapse<%= uid%>" class="accordion-collapse collapse" data-bs-parent="#userAccordion">
                                <div class="accordion-body">

                                    <h6>📝 Feedbacks</h6>
                                    <% if (feedbacks.isEmpty()) { %>
                                    <p class="text-muted">No feedback submitted.</p>
                                    <% } else { %>
                                    <ul>
                                        <% for (String[] fb : feedbacks) {%>
                                        <li><strong>Status:</strong> <%= fb[1]%> — <%= fb[0]%></li>
                                            <% } %>
                                    </ul>
                                    <% } %>

                                    <h6>🧵 Threads Created</h6>
                                    <% if (threads.isEmpty()) { %>
                                    <p class="text-muted">No threads created.</p>
                                    <% } else { %>
                                    <ul>
                                        <% for (String title : threads) {
                                                // Fetch thread ID too (update your query to fetch it)
                                                psFb = conn.prepareStatement("SELECT threadID, title FROM forumthread WHERE createdBy = ?");
                                                psFb.setString(1, uid);
                                                ResultSet rsFbThreads = psFb.executeQuery();
                                                while (rsFbThreads.next()) {
                                                    String threadID = rsFbThreads.getString("threadID");
                                                    String threadTitle = rsFbThreads.getString("title");
                                        %>
                                        <li>
                                            <a href="viewThread.jsp?threadID=<%= threadID%>" target="_blank">
                                                <%= threadTitle%>
                                            </a>
                                            <form method="post" action="DeleteThreadServlet" onsubmit="return confirm('Are you sure you want to delete this thread?');" style="display:inline;">
                                                <input type="hidden" name="threadID" value="<%= threadID%>">
                                                <input type="hidden" name="source" value="admin">
                                                <button type="submit" class="btn btn-sm btn-danger">Delete</button>
                                            </form>
                                        </li>
                                        <%
                                                }
                                                rsFbThreads.close();
                                                psFb.close();
                                            } %>
                                    </ul>
                                    <% } %>

                                </div>
                            </div>
                        </div>
                        <% } %>
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

<%
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<p class='text-danger'>Error loading user activity.</p>");
    } finally {
        if (conn != null) try {
            conn.close();
        } catch (Exception ignored) {
        }
    }
%>
