<%@ page import="java.util.List" %>
<%@ page import="model.TopFeedback" %>
<%@ page import="model.ActiveUser" %>
<%@ page import="model.StatusCount" %>
<%@ page import="model.CategoryCount" %>
<%@ page import="com.google.gson.Gson" %>
<%@ page session="true" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String role = (String) session.getAttribute("userRole");
    if (role == null || !"admin".equals(role) && !"staff".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }

    Gson gson = new Gson();
    String statusJson = gson.toJson(request.getAttribute("statusCounts"));
    String categoryJson = gson.toJson(request.getAttribute("categoryCounts"));
%>
<!DOCTYPE html>
<html lang="en">
    <%@ include file="include/head.jsp" %>
    <body id="top">
        <main>
            <%@ include file="include/navigation.jsp" %>

            <section class="hero-section d-flex justify-content-center align-items-center" id="section_1">
                <div class="container py-5">
                    <h2 class="mb-4">System Report Overview</h2>
                    <p class="text-muted">Updated until: <%= request.getAttribute("updatedUntil")%></p>
                    
                    <button class="btn btn-primary my-3" onclick="downloadPDF()">Download Report as PDF</button>

                    <ul class="nav nav-tabs mb-3" id="reportTabs" role="tablist">
                        <li class="nav-item">
                            <button class="nav-link active" data-bs-toggle="tab" data-bs-target="#feedback" type="button">Feedback</button>
                        </li>
                        <li class="nav-item">
                            <button class="nav-link" data-bs-toggle="tab" data-bs-target="#forum" type="button">Forum</button>
                        </li>
                    </ul>

                    <div class="tab-content border p-4">
                        <!-- Feedback Tab -->
                        <div class="tab-pane fade show active" id="feedback">
                            <h4>Feedback Overview</h4>
                            <canvas id="statusChart" height="100"></canvas>
                            <div style="width: 500px; height: 500px; margin: auto;">
                                <canvas id="categoryChart"></canvas>
                            </div>
                            <h5 class="mt-4">Top Feedbacks</h5>
                            <table class="table table-striped">
                                <thead><tr><th>Feedback</th><th>By</th><th>Upvotes</th></tr></thead>
                                <tbody>
                                    <%
                                        List<TopFeedback> topFeedbacks = (List<TopFeedback>) request.getAttribute("topFeedbacks");
                                        if (topFeedbacks != null && !topFeedbacks.isEmpty()) {
                                            for (TopFeedback fb : topFeedbacks) {
                                    %>
                                    <tr>
                                        <td><%= fb.getContent()%></td>
                                        <td><%= fb.getUserName()%></td>
                                        <td><%= fb.getUpvotes()%></td>
                                    </tr>
                                    <% }
                                    } else { %>
                                    <tr><td colspan="3" class="text-center text-muted">No feedback available.</td></tr>
                                    <% }%>
                                </tbody>
                            </table>
                        </div>

                        <!-- Forum Tab -->
                        <div class="tab-pane fade" id="forum">
                            <h4>Forum Overview</h4>
                            <div class="row mb-4">
                                <div class="col-md-6"><div class="card p-3">Total Threads: <%= request.getAttribute("totalThreads")%></div></div>
                                <div class="col-md-6"><div class="card p-3">Total Replies: <%= request.getAttribute("totalReplies")%></div></div>
                            </div>
                            <h5>Top Active Users</h5>
                            <table class="table table-striped">
                                <thead><tr><th>User</th><th>Total Replies</th></tr></thead>
                                <tbody>
                                    <%
                                        List<ActiveUser> activeUsers = (List<ActiveUser>) request.getAttribute("activeUsers");
                                        if (activeUsers != null && !activeUsers.isEmpty()) {
                                            for (ActiveUser u : activeUsers) {
                                    %>
                                    <tr>
                                        <td><%= u.getUserName()%></td>
                                        <td><%= u.getPostCount()%></td>
                                    </tr>
                                    <% }
                                    } else { %>
                                    <tr><td colspan="2" class="text-muted text-center">No active users found.</td></tr>
                                    <% }%>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </section>
        </main>

        <%@ include file="include/footer.jsp" %>
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <script src="js/jquery.min.js"></script>
        <script src="js/bootstrap.bundle.min.js"></script>
        <script src="js/custom.js"></script>
        <script src="js/jquery.min.js"></script>
        <script src="js/bootstrap.bundle.min.js"></script>
        <script src="js/jquery.sticky.js"></script>
        <script src="js/click-scroll.js"></script>
        <script src="js/custom.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>

        <!-- Chart rendering -->
        <script>
                        const statusData = <%= statusJson%>;
                        const categoryData = <%= categoryJson%>;

                        new Chart(document.getElementById('statusChart'), {
                            type: 'bar',
                            data: {
                                labels: statusData.map(i => i.status),
                                datasets: [{
                                        label: 'Feedback Status Count',
                                        data: statusData.map(i => i.count),
                                        backgroundColor: ['#0d6efd', '#198754', '#ffc107', '#dc3545', '#6f42c1']
                                    }]
                            }
                        });

                        new Chart(document.getElementById('categoryChart'), {
                            type: 'doughnut',
                            data: {
                                labels: categoryData.map(i => i.category),
                                datasets: [{
                                        data: categoryData.map(i => i.count),
                                        backgroundColor: ['#6610f2', '#20c997', '#fd7e14', '#dc3545', '#0dcaf0']
                                    }]
                            }
                        });

                        function downloadPDF() {
                            const element = document.querySelector(".tab-content"); // or any container you want to export
                            html2pdf().set({
                                margin: 0.5,
                                filename: 'System_Report.pdf',
                                image: {type: 'jpeg', quality: 0.98},
                                html2canvas: {scale: 2},
                                jsPDF: {unit: 'in', format: 'letter', orientation: 'portrait'}
                            }).from(element).save();
                        }
        </script>
    </body>
</html>
