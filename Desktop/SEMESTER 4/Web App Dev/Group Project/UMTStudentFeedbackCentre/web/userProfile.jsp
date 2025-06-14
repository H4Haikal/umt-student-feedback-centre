<%-- 
    Document   : userProfile
    Created on : 31 May 2025, 3:11:18 pm
    Author     : User
--%>


<%@ page import="java.sql.*, db.DBConnection" %>
<%
    String email = (String) session.getAttribute("userEmail");
    if (email == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    String name = "", role = "", userID = "";
    int totalFeedback = 0, resolvedFeedback = 0, totalThreads = 0, totalReplies = 0;
    String mostUpvotedFeedback = "None", mostActiveThread = "None";

    String facebook = "", twitter = "", instagram = "", google = "";
    String program = "", course = "", level = "", department = "", faculty = "", position = "";

    // Admin-only stats
    int totalFeedbackReports = 0, resolvedFeedbackReports = 0, pendingFeedbackReports = 0;
    int totalForumReports = 0, resolvedForumReports = 0, pendingForumReports = 0;
    int feedbacksHandled = 0, usersRegistered = 0, threadsMonitored = 0;

    try {
        conn = DBConnection.getConnection();

        // Get user details
        ps = conn.prepareStatement("SELECT userID, name, email, role, facebook, twitter, instagram, google FROM user WHERE email = ?");
        ps.setString(1, email);
        rs = ps.executeQuery();
        if (rs.next()) {
            userID = rs.getString("userID");
            name = rs.getString("name");
            role = rs.getString("role");
            facebook = rs.getString("facebook");
            twitter = rs.getString("twitter");
            instagram = rs.getString("instagram");
            google = rs.getString("google");
        }
        rs.close();
        ps.close();

        // If student, fetch academic info
        if ("student".equalsIgnoreCase(role)) {
            ps = conn.prepareStatement("SELECT program, course, level FROM student WHERE studentID = ?");
            ps.setString(1, userID);
            rs = ps.executeQuery();
            if (rs.next()) {
                program = rs.getString("program");
                course = rs.getString("course");
                level = rs.getString("level");
            }
            rs.close();
            ps.close();
        } else if ("staff".equalsIgnoreCase(role)) {
            ps = conn.prepareStatement("SELECT department, faculty, position FROM staff WHERE staffID = ?");
            ps.setString(1, userID);
            rs = ps.executeQuery();
            if (rs.next()) {
                department = rs.getString("department");
                faculty = rs.getString("faculty");
                position = rs.getString("position");
            }
            rs.close();
            ps.close();
        } else if ("admin".equalsIgnoreCase(role)) {
            ps = conn.prepareStatement("SELECT department, faculty, position FROM admin WHERE adminID = ?");
            ps.setString(1, userID);
            rs = ps.executeQuery();
            if (rs.next()) {
                department = rs.getString("department");
                faculty = rs.getString("faculty");
                position = rs.getString("position");
            }
            rs.close();
            ps.close();
        }

        // Feedback summary
        ps = conn.prepareStatement("SELECT COUNT(*) FROM feedback WHERE userID = ?");
        ps.setString(1, userID);
        rs = ps.executeQuery();
        if (rs.next()) {
            totalFeedback = rs.getInt(1);
        }
        rs.close();
        ps.close();

        ps = conn.prepareStatement("SELECT COUNT(*) FROM feedback WHERE userID = ? AND status = 'Resolved'");
        ps.setString(1, userID);
        rs = ps.executeQuery();
        if (rs.next()) {
            resolvedFeedback = rs.getInt(1);
        }
        rs.close();
        ps.close();

        ps = conn.prepareStatement("SELECT content FROM feedback WHERE userID = ? ORDER BY feedbackID DESC LIMIT 1");
        ps.setString(1, userID);
        rs = ps.executeQuery();
        if (rs.next()) {
            mostUpvotedFeedback = rs.getString("content");
        }
        rs.close();
        ps.close();

        // Forum summary (per user)
        ps = conn.prepareStatement("SELECT COUNT(*) FROM forumthread WHERE createdBy = ?");
        ps.setString(1, userID);
        rs = ps.executeQuery();
        if (rs.next()) {
            totalThreads = rs.getInt(1);
        }
        rs.close();
        ps.close();

        ps = conn.prepareStatement("SELECT COUNT(fp.postID) AS totalReplies FROM forumpost fp JOIN forumthread ft ON fp.threadID = ft.threadID WHERE ft.createdBy = ?");
        ps.setString(1, userID);
        rs = ps.executeQuery();
        if (rs.next()) {
            totalReplies = rs.getInt("totalReplies");
        }
        rs.close();
        ps.close();

        ps = conn.prepareStatement("SELECT ft.title FROM forumthread ft JOIN forumpost fp ON ft.threadID = fp.threadID WHERE ft.createdBy = ? GROUP BY ft.threadID ORDER BY COUNT(fp.postID) DESC LIMIT 1");
        ps.setString(1, userID);
        rs = ps.executeQuery();
        if (rs.next()) {
            mostActiveThread = rs.getString("title");
        }
        rs.close();
        ps.close();

        // Admin-wide summary
        if ("admin".equalsIgnoreCase(role)) {
            // Total Feedback Reports
            ps = conn.prepareStatement("SELECT COUNT(*) FROM feedback");
            rs = ps.executeQuery();
            if (rs.next()) {
                totalFeedbackReports = rs.getInt(1);
            }
            rs.close();
            ps.close();

            ps = conn.prepareStatement("SELECT COUNT(*) FROM feedback WHERE status = 'Resolved'");
            rs = ps.executeQuery();
            if (rs.next()) {
                resolvedFeedbackReports = rs.getInt(1);
            }
            rs.close();
            ps.close();

            ps = conn.prepareStatement("SELECT COUNT(*) FROM feedback WHERE status = 'Pending'");
            rs = ps.executeQuery();
            if (rs.next()) {
                pendingFeedbackReports = rs.getInt(1);
            }
            rs.close();
            ps.close();

            // Forum reports (from 'report' table)
            ps = conn.prepareStatement("SELECT COUNT(*) FROM report");
            rs = ps.executeQuery();
            if (rs.next()) {
                totalForumReports = rs.getInt(1);
            }
            rs.close();
            ps.close();

            ps = conn.prepareStatement("SELECT COUNT(*) FROM feedback WHERE status = 'Resolved'");
            rs = ps.executeQuery();
            if (rs.next()) {
                resolvedForumReports = rs.getInt(1);
            }
            rs.close();
            ps.close();

            ps = conn.prepareStatement("SELECT COUNT(*) FROM report WHERE status = 'Pending'");
            rs = ps.executeQuery();
            if (rs.next()) {
                pendingForumReports = rs.getInt(1);
            }
            rs.close();
            ps.close();

            // Other stats
            ps = conn.prepareStatement("SELECT COUNT(*) FROM feedback WHERE status = 'Resolved'");
            rs = ps.executeQuery();
            if (rs.next()) {
                feedbacksHandled = rs.getInt(1);
            }
            rs.close();
            ps.close();

            ps = conn.prepareStatement("SELECT COUNT(*) FROM user");
            rs = ps.executeQuery();
            if (rs.next()) {
                usersRegistered = rs.getInt(1);
            }
            rs.close();
            ps.close();

            ps = conn.prepareStatement("SELECT COUNT(*) FROM forumthread");
            rs = ps.executeQuery();
            if (rs.next()) {
                threadsMonitored = rs.getInt(1);
            }
            rs.close();
            ps.close();

            request.setAttribute("totalFeedbackReports", totalFeedbackReports);
            request.setAttribute("resolvedFeedbackReports", resolvedFeedbackReports);
            request.setAttribute("pendingFeedbackReports", pendingFeedbackReports);
            request.setAttribute("totalForumReports", totalForumReports);
            request.setAttribute("resolvedForumReports", resolvedForumReports);
            request.setAttribute("pendingForumReports", pendingForumReports);
            request.setAttribute("feedbacksHandled", feedbacksHandled);
            request.setAttribute("usersRegistered", usersRegistered);
            request.setAttribute("threadsMonitored", threadsMonitored);
        }

        // Set to request scope
        request.setAttribute("userID", userID);
        request.setAttribute("name", name);
        request.setAttribute("email", email);
        request.setAttribute("role", role);
        request.setAttribute("facebook", facebook);
        request.setAttribute("twitter", twitter);
        request.setAttribute("instagram", instagram);
        request.setAttribute("google", google);
        request.setAttribute("program", program);
        request.setAttribute("course", course);
        request.setAttribute("level", level);
        request.setAttribute("department", department);
        request.setAttribute("faculty", faculty);
        request.setAttribute("position", position);
        request.setAttribute("totalFeedback", totalFeedback);
        request.setAttribute("resolvedFeedback", resolvedFeedback);
        request.setAttribute("mostUpvotedFeedback", mostUpvotedFeedback);
        request.setAttribute("totalThreads", totalThreads);
        request.setAttribute("totalReplies", totalReplies);
        request.setAttribute("mostActiveThread", mostActiveThread);

    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try {
            if (conn != null) {
                conn.close();
            }
        } catch (Exception ignored) {
        }
    }
%>


<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!doctype html>
<html lang="en">
    <%@ include file="include/head.jsp" %>

    <body id="top">

        <main>
            <% request.setAttribute("currentPage", "profile");%>
            <%@ include file="include/navigation.jsp" %>


            <section class="hero-section d-flex justify-content-center align-items-center" id="section_1">
                <div class="row gutters-sm container">
                    <div class="col-md-4 mb-3">
                        <div class="card">
                            <div class="card-body">
                                <div class="d-flex flex-column align-items-center text-center">
                                    <img src="https://bootdey.com/img/Content/avatar/avatar7.png" alt="Admin" class="rounded-circle" width="150">
                                    <div class="mt-3">
                                        <h4>${name}</h4>
                                        <p class="text-secondary mb-1">${role}</p>
                                        <p class="text-muted font-size-sm">${userID}</p> <!-- You can expand this later -->
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!--                        <div class="card mt-3">
                                                    <ul class="list-group list-group-flush">
                                                        <li class="list-group-item d-flex justify-content-between align-items-center flex-wrap">
                                                            <h6 class="mb-0"><i class="fab fa-google mr-2"></i> Google</h6>
                                                            <span class="text-secondary">${google}</span>
                                                        </li>
                                                        <li class="list-group-item d-flex justify-content-between align-items-center flex-wrap">
                                                            <h6 class="mb-0"><i class="fab fa-twitter mr-2 text-info"></i> Twitter</h6>
                                                            <span class="text-secondary">${twitter}</span>
                                                        </li>
                                                        <li class="list-group-item d-flex justify-content-between align-items-center flex-wrap">
                                                            <h6 class="mb-0"><i class="fab fa-instagram mr-2 text-danger"></i> Instagram</h6>
                                                            <span class="text-secondary">${instagram}</span>
                                                        </li>
                                                        <li class="list-group-item d-flex justify-content-between align-items-center flex-wrap">
                                                            <h6 class="mb-0"><i class="fab fa-facebook mr-2 text-primary"></i> Facebook</h6>
                                                            <span class="text-secondary">${facebook}</span>
                                                        </li>
                                                    </ul>
                        
                                                </div>-->
                        <c:choose>
                            <c:when test="${sessionScope.userRole == 'student'}">
                                <div class="card mt-3">
                                    <div class="row">
                                        <div class="col-sm-12 align-items-center text-center">
                                            <a href="feedback?action=list.jsp" class="btn btn-primary m-3 btn-outline btn-lg">
                                                <i class="fas fa-comment-dots"></i> Submit Feedback
                                            </a>
                                            <a href="creatThread.jsp" class="btn btn-success m-3 btn-outline btn-lg">
                                                <i class="fas fa-pen-nib"></i> Create Thread
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </c:when>
                            <c:when test="${sessionScope.userRole == 'admin'}">
                                <div class="card mt-3">
                                    <div class="row">
                                        <div class="col-sm-12 align-items-center text-center">
                                            <a class="btn btn-primary m-3 btn-outline btn-lg" href="manageUsers.jsp"> User Activities</a>
                                            <a class="btn btn-dark m-3 btn-outline btn-lg" href="ReportServlet">
                                                <i class="bi bi-bar-chart-line"></i> View Reports
                                            </a>

                                        </div>
                                    </div>
                                </div>
                            </c:when>
                            <c:when test="${sessionScope.userRole == 'staff'}">
                                <div class="card mt-3">
                                    <div class="row">
                                        <div class="col-sm-12 align-items-center text-center">
                                            <a href="feedback?action=list" class="btn btn-primary m-3 btn-outline btn-lg">
                                                <i class="fas fa-comment-dots"></i> Submit Feedback
                                            </a>
                                            <a href="creatThread.jsp" class="btn btn-success m-3 btn-outline btn-lg">
                                                <i class="fas fa-pen-nib"></i> Create Thread
                                            </a>
                                            <a class="btn btn-dark m-3 btn-outline btn-lg" href="ReportServlet">
                                                <i class="bi bi-bar-chart-line"></i> View Reports
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </c:when>
                            <c:otherwise><p>Unauthorised or unidentified role</p></c:otherwise>
                        </c:choose>

                    </div>
                    <div class="col-md-8">

                        <form action="updateProfile.jsp" method="post" id="profileForm">
                            <div class="card mb-3 mt-4 p-3">
                                <div class="row">
                                    <div class="col-sm-3">
                                        <h6 class="mb-0">Full Name</h6>
                                    </div>
                                    <div class="col-sm-9 text-secondary">
                                        <input type="text" name="name" class="form-control-plaintext" value="${name}" readonly>
                                    </div>
                                </div>
                                <hr>
                                <div class="row">
                                    <div class="col-sm-3">
                                        <h6 class="mb-0">Email</h6>
                                    </div>
                                    <div class="col-sm-9 text-secondary">
                                        <input type="email" name="email" class="form-control-plaintext" value="${email}" readonly>
                                    </div>
                                </div>
                                <hr>

                                <c:choose>
                                    <c:when test="${sessionScope.userRole == 'student'}">
                                        <div class="row">
                                            <div class="col-sm-3">
                                                <h6 class="mb-0">Program</h6>
                                            </div>
                                            <div class="col-sm-9 text-secondary">
                                                <input type="text" name="program" class="form-control-plaintext" value="${program}" readonly>
                                            </div>
                                        </div>
                                        <hr>
                                        <div class="row">
                                            <div class="col-sm-3">
                                                <h6 class="mb-0">Course</h6>
                                            </div>
                                            <div class="col-sm-9 text-secondary">
                                                <input type="text" name="course" class="form-control-plaintext" value="${course}" readonly>
                                            </div>
                                        </div>
                                        <hr>
                                        <div class="row">
                                            <div class="col-sm-3">
                                                <h6 class="mb-0">Level</h6>
                                            </div>
                                            <div class="col-sm-9 text-secondary">
                                                <input type="text" name="level" class="form-control-plaintext" value="${level}" readonly>
                                            </div>
                                        </div>
                                    </c:when>
                                    <c:when test="${sessionScope.userRole == 'staff' || sessionScope.userRole == 'admin'}">
                                        <div class="row">
                                            <div class="col-sm-3">
                                                <h6 class="mb-0">Department</h6>
                                            </div>
                                            <div class="col-sm-9 text-secondary">
                                                <input type="text" name="department" class="form-control-plaintext" value="${department}" readonly>
                                            </div>
                                        </div>
                                        <hr>
                                        <div class="row">
                                            <div class="col-sm-3">
                                                <h6 class="mb-0">Faculty</h6>
                                            </div>
                                            <div class="col-sm-9 text-secondary">
                                                <input type="text" name="faculty" class="form-control-plaintext" value="${faculty}" readonly>
                                            </div>
                                        </div>
                                        <hr>
                                        <div class="row">
                                            <div class="col-sm-3">
                                                <h6 class="mb-0">Position</h6>
                                            </div>
                                            <div class="col-sm-9 text-secondary">
                                                <input type="text" name="position" class="form-control-plaintext" value="${position}" readonly>
                                            </div>
                                        </div>
                                    </c:when>
                                </c:choose>
                                <div class="d-flex gap-2 m-1 mt-3">
                                    <button type="button" class="btn btn-info" onclick="enableEdit()">Update</button>
                                    <button type="submit" class="btn btn-success d-none" id="saveBtn">Save</button>
                                    <button type="button" class="btn btn-secondary d-none" id="cancelBtn" onclick="cancelEdit()">Cancel</button>
                                </div>
                            </div>

                        </form>


                        <c:choose>
                            <c:when test="${sessionScope.userRole == 'student' || sessionScope.userRole == 'staff'}">
                                <!-- Student View -->
                                <div class="row gutters-sm">
                                    <!-- Feedback Status -->
                                    <div class="col-sm-6 mb-3">
                                        <div class="card h-100">
                                            <div class="card-body">
                                                <h6 class="d-flex align-items-center mb-3">
                                                    <i class="material-icons text-info mr-2">feedback</i> Feedback Summary
                                                </h6>
                                                <small>Total Feedback Submitted</small>
                                                <div class="progress mb-3" style="height: 5px">
                                                    <div class="progress-bar bg-success" role="progressbar" style="width:100%"></div>
                                                </div>
                                                <p><b>${totalFeedback}</b> feedback(s)</p>

                                                <small>Most Upvoted Feedback</small>
                                                <div class="progress mb-3" style="height: 5px">
                                                    <div class="progress-bar bg-primary" role="progressbar" style="width:100%"></div>
                                                </div>
                                                <p><b>"${mostUpvotedFeedback}"</b></p>

                                                <small>Resolved Feedback</small>
                                                <div class="progress mb-3" style="height: 5px">
                                                    <div class="progress-bar bg-info" role="progressbar" style="width:100%"></div>
                                                </div>
                                                <p><b>${resolvedFeedback}</b> resolved</p>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Forum Status -->
                                    <div class="col-sm-6 mb-3">
                                        <div class="card h-100">
                                            <div class="card-body">
                                                <h6 class="d-flex align-items-center mb-3">
                                                    <i class="material-icons text-info mr-2">forum</i> Forum Summary
                                                </h6>
                                                <small>Total Threads Created</small>
                                                <div class="progress mb-3" style="height: 5px">
                                                    <div class="progress-bar bg-success" role="progressbar" style="width:100%"></div>
                                                </div>
                                                <p><b>${totalThreads}</b> threads</p>

                                                <small>Most Active Thread</small>
                                                <div class="progress mb-3" style="height: 5px">
                                                    <div class="progress-bar bg-primary" role="progressbar" style="width:100%"></div>
                                                </div>
                                                <p><b>"${mostActiveThread}"</b></p>

                                                <small>Total Replies</small>
                                                <div class="progress mb-3" style="height: 5px">
                                                    <div class="progress-bar bg-info" role="progressbar" style="width:100%"></div>
                                                </div>
                                                <p><b>${totalReplies}</b> replies</p>
                                            </div>
                                        </div>
                                    </div>
                                </c:when>


                                <c:when test="${sessionScope.userRole == 'admin'}">
                                    <!-- Admin View -->
                                    <div class="row gutters-sm">
                                        <!-- Feedback Report Summary -->
                                        <div class="col-sm-6 mb-3">
                                            <div class="card h-100">
                                                <div class="card-body">
                                                    <h6 class="d-flex align-items-center mb-3">
                                                        <i class="material-icons text-danger mr-2">flag</i> Feedback Report Summary
                                                    </h6>
                                                    <p><strong>Total Feedback Reports:</strong> ${totalFeedbackReports}</p>
                                                    <p><strong>Resolved Feedback Reports:</strong> ${resolvedFeedbackReports}</p>
                                                    <p><strong>Pending Feedback Reports:</strong> ${pendingFeedbackReports}</p>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Forum Activity Summary -->
                                        <div class="col-sm-6 mb-3">
                                            <div class="card h-100">
                                                <div class="card-body">
                                                    <h6 class="d-flex align-items-center mb-3">
                                                        <i class="material-icons text-warning mr-2">forum</i> Forum Activity Summary
                                                    </h6>
                                                    <p><strong>Total Threads:</strong> ${totalThreads}</p>
                                                    <p><strong>Total Replies:</strong> ${totalReplies}</p>
                                                    <p><strong>Most Active Thread:</strong> ${mostActiveThread}</p>
                                                </div>
                                            </div>
                                        </div>


                                        <!-- Admin Actions Overview & Feedback Stats -->
                                        <div class="row gutters-sm">
                                            <!-- Admin Actions -->
                                            <div class="col-sm-6 mb-3">
                                                <div class="card mb-3">
                                                    <div class="card-body">
                                                        <h5>Admin Actions Overview</h5>
                                                        <hr>
                                                        <p><strong>Feedbacks Handled:</strong> ${feedbacksHandled}</p>
                                                        <p><strong>Users Registered:</strong> ${usersRegistered}</p>
                                                        <p><strong>Threads Monitored:</strong> ${threadsMonitored}</p>
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- Feedback Stats (Simplified) -->
                                            <div class="col-sm-6 mb-3">
                                                <div class="card h-90">
                                                    <div class="card-body">
                                                        <h6 class="d-flex align-items-center mb-3">
                                                            <i class="material-icons text-info mr-2">feedback</i> Feedback Stats
                                                        </h6>
                                                        <p><strong>Resolved:</strong> ${resolvedFeedbackReports}</p>
                                                        <p><strong>Pending:</strong> ${pendingFeedbackReports}</p>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </c:when>


                                    <c:otherwise>
                                        <p>Unauthorized access or unknown role.</p>
                                    </c:otherwise>
                                </c:choose>          





                                </section>
                                </main>

                                <%@ include file="include/footer.jsp" %>


                                <!-- JAVASCRIPT FILES -->
                                <script src="js/jquery.min.js"></script>
                                <script src="js/bootstrap.bundle.min.js"></script>
                                <script src="js/jquery.sticky.js"></script>
                                <script src="js/click-scroll.js"></script>
                                <script src="js/custom.js"></script>
                                <script>
                                        function enableEdit() {
                                            const inputs = document.querySelectorAll('#profileForm input');
                                            inputs.forEach(input => {
                                                input.readOnly = false;
                                                input.classList.remove('form-control-plaintext');
                                                input.classList.add('form-control');
                                            });

                                            document.getElementById('saveBtn').classList.remove('d-none');
                                            document.getElementById('cancelBtn').classList.remove('d-none');
                                        }

                                        function cancelEdit() {
                                            // Reload to discard changes
                                            location.reload();
                                        }
                                </script>

                                </body>
                                </html>

