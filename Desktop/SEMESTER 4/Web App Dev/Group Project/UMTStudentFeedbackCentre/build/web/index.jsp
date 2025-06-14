<%@page import="java.util.List"%>
<%@page import="java.util.List"%>
<%@page import="model.Thread"%>
<%@page import="model.Feedback"%>
<%@page import="dao.ThreadDAO"%>
<%@page import="dao.FeedbackDAO"%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String email = (String) session.getAttribute("userEmail");
    if (email == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    request.setAttribute("currentPage", "home");
    String keyword = request.getParameter("keyword");
    List<Thread> threadList = null;
    List<Feedback> feedbackList = null;

    ThreadDAO threadDAO = new ThreadDAO();          // ✅ Only if your ThreadDAO uses instances
    FeedbackDAO feedbackDAO = new FeedbackDAO();    // ✅ FIX: Create instance

    if (keyword != null && !keyword.trim().isEmpty()) {
        threadList = ThreadDAO.searchThreads(keyword); // OK if static
        feedbackList = feedbackDAO.searchFeedbacks(keyword); // ✅ FIXED
    } else {
        threadList = ThreadDAO.getTopThreads(); // OK if static
        feedbackList = feedbackDAO.getTopFeedbacks(); // ✅ FIXED
    }
%>
<!doctype html>
<html lang="en">
    <%@ include file="include/head.jsp" %>
    <body id="top">
        <main>
            <%@ include file="include/navigation.jsp" %>

            <section class="hero-section d-flex justify-content-center align-items-center" id="section_1">
                <div class="container">
                    <div class="row">
                        <div class="col-lg-8 col-12 mx-auto">
                            <h1 class="text-white text-center">UMT Student Feedback Centre</h1>
                            <h6 class="text-center">A platform to crowdsource ideas, feedback, and solutions.</h6>
                            <form method="get" class="custom-form mt-4 pt-2 mb-lg-0 mb-5" role="search">
                                <div class="input-group input-group-lg">
                                    <span class="input-group-text bi-search" id="basic-addon1"></span>
                                    <input name="keyword" type="search" class="form-control" id="keyword" placeholder="Parking, Toilets, Classroom..." aria-label="Search" value="<%= keyword != null ? keyword : ""%>">
                                    <button type="submit" class="form-control">Search</button>
                                </div>
                            </form>
                            <div class="d-flex justify-content-center gap-3 mt-4">
                                <a href="createThread.jsp" class="custom-btn btn-outline-light btn-lg text-dark">
                                    <i class="fas fa-pen-nib"></i> Create Thread
                                </a>
                                <a href="feedback?action=list" class="custom-btn btn-outline-success btn-lg text-dark">
                                    <i class="fas fa-comment-dots"></i> Submit Feedback
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            <section class="section-padding section-bg">
                <div class="container">
                    <h2 class="mb-4">Top Threads</h2>
                    <div class="row">
                        <%
                            for (Thread thread : threadList) {
                        %>
                        <div class="col-md-6 mb-4">
                            <div class="card p-4 shadow rounded-4">
                                <h4>
                                    <a href="viewThread.jsp?threadID=<%= thread.getThreadID()%>" class="text-decoration-none text-dark">
                                        <%= thread.getTitle()%>
                                    </a>
                                </h4>

                                <p>by <%= thread.getAuthorName()%></p>
                                <p><%= thread.getReplyCount()%> replies</p>
                            </div>
                        </div>
                        <% } %>
                    </div>
                </div>
            </section>

            <section class="section-padding">
                <div class="container">
                    <h2 class="mb-4">Top Feedbacks</h2>
                    <div class="row">
                        <%
                            for (Feedback fb : feedbackList) {
                        %>
                        <div class="col-md-6 mb-4">
                            <div class="card p-4 shadow rounded-4">
                                <h4><%= fb.getTitle()%></h4>
                                <p><%= fb.getContent()%></p>
                                <span class="badge bg-info">Submitted by <%= fb.getAuthorName()%></span>
                            </div>
                        </div>
                        <% }%>
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
