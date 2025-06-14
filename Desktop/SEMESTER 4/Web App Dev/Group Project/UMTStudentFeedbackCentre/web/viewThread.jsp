<%@ page session="true" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*, db.DBConnection" %>
<%
    String role = (String) session.getAttribute("userRole");
    String userID = (String) session.getAttribute("userID");
    if (role == null || userID == null || (!"admin".equals(role) && !"student".equals(role) && !"staff".equals(role))) {
        response.sendRedirect("login.jsp");
        return;
    }
    int threadID = Integer.parseInt(request.getParameter("threadID"));
%>
<!DOCTYPE html>
<html lang="en">
    <%@ include file="include/head.jsp" %>
    <body id="top">
        <main>
            <%@ include file="include/navigation.jsp" %>
            <section class="hero-section d-flex justify-content-center align-items-center" id="section_1">
                <div class="row gutters-sm container">
                    <div class="col-md-8 offset-md-2">
                        <div class="card mb-3">
                            <div class="card-body">
                                <%
                                    Connection conn = DBConnection.getConnection();
                                    PreparedStatement pst = conn.prepareStatement("SELECT t.title, t.createdDate, t.createdBy, t.editedAt, u.name FROM forumthread t LEFT JOIN user u ON t.createdBy = u.userID WHERE t.threadID = ?");
                                    pst.setInt(1, threadID);
                                    ResultSet threadRs = pst.executeQuery();
                                    if (threadRs.next()) {
                                        String threadOwner = threadRs.getString("createdBy");
                                %>
                                <div class="d-flex justify-content-between align-items-center">
                                    <h4 id="threadTitleDisplay"><%= threadRs.getString("title")%></h4>
                                    <%
                                        Timestamp threadEditedAt = threadRs.getTimestamp("editedAt");
                                        if (threadEditedAt != null) {
                                    %>
                                    <span class="text-info">(edited on <%= threadEditedAt.toString()%>)</span>
                                    <%
                                        }
                                    %>

                                    <% if (userID.equals(threadOwner)) {%>
                                    <div id="threadEditControls">
                                        <button class="btn btn-sm btn-outline-primary" onclick="enableThreadEdit()"><i class="bi bi-pencil-square"></i> Edit</button>
                                        <form action="DeleteThreadServlet" method="post" class="d-inline" onsubmit="return confirm('Are you sure you want to delete this thread and all its replies?');">
                                            <input type="hidden" name="threadID" value="<%= threadID%>" />
                                            <button type="submit" class="btn btn-sm btn-outline-danger mt-2"><i class="bi bi-trash"></i> Delete</button>
                                        </form>
                                    </div>
                                    <form id="editThreadForm" action="EditThreadServlet" method="post" class="d-none">
                                        <input type="hidden" name="threadID" value="<%= threadID%>" />
                                        <div class="input-group">
                                            <input type="text" name="title" class="form-control" value="<%= threadRs.getString("title")%>" required />
                                            <button type="submit" class="btn btn-outline-success"><i class="bi bi-check-circle"></i> Save</button>
                                        </div>
                                    </form>
                                    <% }%>
                                </div>
                                <p class="text-muted">
                                    By <%= threadRs.getString("name")%> on <%= threadRs.getTimestamp("createdDate").toString()%>
                                </p>
                                <% } %>
                            </div>
                        </div>

                        <div class="card mb-3">
                            <div class="card-body">
                                <h5>Replies</h5>
                                <%
                                    PreparedStatement postStmt = conn.prepareStatement("SELECT p.postID, p.content, p.postedAt, p.editedAt, p.postedBy, u.name FROM forumpost p LEFT JOIN user u ON p.postedBy = u.userID WHERE threadID=? ORDER BY postedAt ASC");
                                    postStmt.setInt(1, threadID);
                                    ResultSet postRs = postStmt.executeQuery();
                                    while (postRs.next()) {
                                        String postID = postRs.getString("postID");
                                        String replyOwner = postRs.getString("postedBy");
                                %>
                                <div class="border-bottom py-2" id="replyBlock-<%= postID%>">
                                    <p id="contentDisplay-<%= postID%>"><%= postRs.getString("content")%></p>

                                    <small class="text-muted" id="timestamp-<%= postID%>">
                                        By <%= postRs.getString("name")%> on <%= postRs.getTimestamp("postedAt")%>
                                        <%
                                            Timestamp editedAt = postRs.getTimestamp("editedAt");
                                            if (editedAt != null) {
                                        %>
                                        <span class="text-info">(edited on <%= editedAt.toString()%>)</span>
                                        <%
                                            }
                                        %>
                                    </small>




                                    <% if (userID.equals(replyOwner)) {%>
                                    <div class="mt-2">
                                        <button class="btn btn-sm btn-outline-primary" onclick="enableReplyEdit('<%= postID%>')"><i class="bi bi-pencil-square"></i> Edit</button>
                                        <form action="DeleteReplyServlet" method="post" class="d-inline" onsubmit="return confirm('Are you sure you want to delete this reply?');">
                                            <input type="hidden" name="postID" value="<%= postID%>" />
                                            <input type="hidden" name="threadID" value="<%= threadID%>" />
                                            <button type="submit" class="btn btn-sm btn-outline-danger"><i class="bi bi-trash"></i> Delete</button>
                                        </form>
                                    </div>
                                    <form action="EditReplyServlet" method="post" class="d-none mt-2" id="editReplyForm-<%= postID%>">
                                        <input type="hidden" name="postID" value="<%= postID%>" />
                                        <input type="hidden" name="threadID" value="<%= threadID%>" />
                                        <div class="input-group">
                                            <input type="text" name="content" class="form-control" value="<%= postRs.getString("content")%>" required />
                                            <button type="submit" class="btn btn-outline-success"><i class="bi bi-check-circle"></i> Save</button>
                                        </div>
                                    </form>
                                    <% } %>
                                </div>
                                <% }%>
                            </div>
                        </div>

                        <div class="card">
                            <div class="card-body">
                                <h5>Reply</h5>
                                <form action="CreateReplyServlet" method="post">
                                    <div class="mb-3">
                                        <textarea name="content" class="form-control" rows="3" required></textarea>
                                        <input type="hidden" name="threadID" value="<%= threadID%>" />
                                    </div>
                                    <button type="submit" class="btn btn-primary">Post Reply</button>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
        </main>
        <%@ include file="include/footer.jsp" %>
        <script src="js/bootstrap.bundle.min.js"></script>
        <!-- JAVASCRIPT FILES -->
        <script src="js/jquery.min.js"></script>
        <script src="js/bootstrap.bundle.min.js"></script>
        <script src="js/jquery.sticky.js"></script>
        <script src="js/click-scroll.js"></script>
        <script src="js/custom.js"></script>
        <script>
                                            function enableThreadEdit() {
                                                document.getElementById('editThreadForm').classList.remove('d-none');
                                                document.getElementById('threadEditControls').classList.add('d-none');
                                                document.getElementById('threadTitleDisplay').classList.add('d-none');
                                            }

                                            function enableReplyEdit(postID) {
                                                document.getElementById('editReplyForm-' + postID).classList.remove('d-none');
                                                document.getElementById('contentDisplay-' + postID).classList.add('d-none');
                                            }

                                            // Append "edited on ..." dynamically when user submits the edit form
                                            document.addEventListener("DOMContentLoaded", function () {
                                                const urlParams = new URLSearchParams(window.location.search);
                                                const editedPostID = urlParams.get("editedPostID");
                                                if (editedPostID) {
                                                    const editedSpan = document.getElementById("editedTime-" + editedPostID);
                                                    if (editedSpan) {
                                                        const now = new Date();
                                                        const timeStr = now.toLocaleString();
                                                        editedSpan.textContent = " (edited on " + timeStr + ")";
                                                    }
                                                }
                                            });
        </script>

    </body>
</html>