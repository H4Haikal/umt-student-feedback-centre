package servlet;

import dao.FeedbackDAO;
import model.Feedback;
import model.FeedbackCategory;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@WebServlet("/feedback")
public class FeedbackServlet extends HttpServlet {

    private FeedbackDAO feedbackDAO;

    @Override
    public void init() {
        feedbackDAO = new FeedbackDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response); // optional: handle form submission via GET routing logic
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        try {
            if ("insert".equals(action)) {
                insertFeedback(request, response);
            } else if ("update".equals(action)) {
                updateFeedback(request, response);
            } else if ("edit".equals(action)) {
                showEditForm(request, response);
            } else if ("delete".equals(action)) {
                deleteFeedback(request, response);
            } else if ("upvote".equals(action)) {
                upvoteFeedback(request, response);
            } else if ("list".equals(action)) {
                listFeedbacks(request, response);
            } else if ("new".equals(action)) {
                showNewForm(request, response);
            } else if ("toggleStatus".equals(action)) {
                toggleStatus(request, response);
            } else {
                response.sendRedirect("index.jsp"); // fallback
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
    // ✅ List all feedbacks

    private void listFeedbacks(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        request.setAttribute("currentPage", "feedback");
        List<Feedback> listFeedback = feedbackDAO.selectAllFeedbacks();
        String userID = (String) request.getSession().getAttribute("userID");

        // Build set of feedbackIDs the user has already upvoted
        Set<String> upvotedSet = new HashSet<>();
        for (Feedback fb : listFeedback) {
            if (feedbackDAO.hasUserUpvoted(userID, Integer.parseInt(fb.getFeedbackID()))) {
                upvotedSet.add(fb.getFeedbackID());
            }
        }

        request.setAttribute("listFeedback", listFeedback);
        request.setAttribute("upvotedSet", upvotedSet);
        RequestDispatcher dispatcher = request.getRequestDispatcher("submitList.jsp");
        dispatcher.forward(request, response);
    }

    // ✅ Show edit form (populate feedback + categories)
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        Feedback feedback = feedbackDAO.getFeedbackById(id);

        String sessionUserID = (String) request.getSession().getAttribute("userID");

        if (feedback == null || !feedback.getUserID().equals(sessionUserID)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "You are not allowed to edit this feedback.");
            return;
        }

        List<FeedbackCategory> categories = feedbackDAO.selectAllCategories();

        request.setAttribute("feedback", feedback);
        request.setAttribute("categoryList", categories);

        RequestDispatcher dispatcher = request.getRequestDispatcher("submitFeedback.jsp");
        dispatcher.forward(request, response);
    }

    // ✅ Insert feedback
    private void insertFeedback(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {

        String title = request.getParameter("title");
        String content = request.getParameter("content");
        String category = request.getParameter("category");
        String userID = (String) request.getSession().getAttribute("userID");

        Feedback feedback = new Feedback(title, content, category, userID);
        feedbackDAO.insertFeedback(feedback);
        response.sendRedirect("feedback?action=list");
    }

    // ✅ Update feedback
    private void updateFeedback(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {

        int feedbackID = Integer.parseInt(request.getParameter("id"));
        String sessionUserID = (String) request.getSession().getAttribute("userID");

        // Load feedback from DB to check ownership
        Feedback existing = feedbackDAO.getFeedbackById(feedbackID);
        if (existing == null || !existing.getUserID().equals(sessionUserID)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "You cannot update this feedback.");
            return;
        }

        // If authorized, proceed
        String title = request.getParameter("title");
        String content = request.getParameter("content");
        String category = request.getParameter("category");

        Feedback feedback = new Feedback();
        feedback.setFeedbackID(String.valueOf(feedbackID));
        feedback.setTitle(title);
        feedback.setContent(content);
        feedback.setCategory(category);

        feedbackDAO.updateFeedback(feedback);
        response.sendRedirect("feedback?action=list");
    }

    // ✅ Delete feedback
    private void deleteFeedback(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {

        int feedbackID = Integer.parseInt(request.getParameter("id"));
        String sessionUserID = (String) request.getSession().getAttribute("userID");

        Feedback existing = feedbackDAO.getFeedbackById(feedbackID);
        if (existing == null || !existing.getUserID().equals(sessionUserID)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "You cannot delete this feedback.");
            return;
        }

        feedbackDAO.deleteFeedback(feedbackID);
        response.sendRedirect("feedback?action=list");
    }

    // ✅ Upvote
    private void upvoteFeedback(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {

        int feedbackID = Integer.parseInt(request.getParameter("id"));
        String userID = (String) request.getSession().getAttribute("userID");

        feedbackDAO.addUpvote(userID, feedbackID); // ignore success flag here
        response.sendRedirect("feedback?action=list");
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {

        List<FeedbackCategory> categories = feedbackDAO.selectAllCategories();
        request.setAttribute("categoryList", categories);

        RequestDispatcher dispatcher = request.getRequestDispatcher("feedbackSubmit.jsp");
        dispatcher.forward(request, response);
    }

    private void toggleStatus(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {

        int feedbackID = Integer.parseInt(request.getParameter("id"));
        String currentStatus = request.getParameter("currentStatus");

        // Flip status
        String newStatus = "Pending".equalsIgnoreCase(currentStatus) ? "Resolved" : "Pending";

        feedbackDAO.updateStatus(feedbackID, newStatus);
        response.sendRedirect("feedback?action=list");
    }

}
