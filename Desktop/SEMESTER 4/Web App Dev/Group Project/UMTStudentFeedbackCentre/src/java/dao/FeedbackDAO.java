package dao;

import model.Feedback;
import model.FeedbackCategory;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class FeedbackDAO {

    private final String jdbcURL = "jdbc:mysql://localhost:3307/umt_student_feedback_center";
    private final String jdbcUsername = "root";
    private final String jdbcPassword = "";

    private Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
        } catch (ClassNotFoundException e) {
            throw new SQLException(e);
        }
    }

    // ✅ Insert new feedback
    public void insertFeedback(Feedback feedback) throws SQLException {
        String sql = "INSERT INTO feedback (title, content, category, userID, createdAt) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, feedback.getTitle());
            stmt.setString(2, feedback.getContent());
            stmt.setString(3, feedback.getCategory());
            stmt.setString(4, feedback.getUserID());
            stmt.setDate(5, java.sql.Date.valueOf(LocalDate.now()));
            stmt.executeUpdate();
        }
    }

    // ✅ List all feedbacks
    public List<Feedback> selectAllFeedbacks() throws SQLException {
        List<Feedback> list = new ArrayList<>();
        String sql = "SELECT f.feedbackID, f.title, f.content, f.category, f.userID, f.createdAt, f.status, COUNT(u.upvoteID) AS upvotes "
                + "FROM feedback f LEFT JOIN feedbackupvote u ON f.feedbackID = u.feedbackID "
                + "GROUP BY f.feedbackID";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Feedback f = new Feedback();
                f.setFeedbackID(rs.getString("feedbackID"));
                f.setTitle(rs.getString("title"));
                f.setContent(rs.getString("content"));
                f.setCategory(rs.getString("category"));
                f.setUserID(rs.getString("userID"));
                f.setCreatedAt(rs.getDate("createdAt").toLocalDate());
                f.setUpvotes(rs.getInt("upvotes"));
                f.setStatus(rs.getString("status"));
                list.add(f);
            }
        }
        return list;
    }

    // ✅ Get feedback by ID
    public Feedback getFeedbackById(int id) throws SQLException {
        String sql = "SELECT * FROM feedback WHERE feedbackID = ?";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                Feedback f = new Feedback();
                f.setFeedbackID(rs.getString("feedbackID"));
                f.setTitle(rs.getString("title"));
                f.setContent(rs.getString("content"));
                f.setCategory(rs.getString("category"));
                f.setUserID(rs.getString("userID"));
                f.setCreatedAt(rs.getDate("createdAt").toLocalDate());
                return f;
            }
        }
        return null;
    }

    // ✅ Update feedback
    public boolean updateFeedback(Feedback feedback) throws SQLException {
        String sql = "UPDATE feedback SET title = ?, content = ?, category = ? WHERE feedbackID = ?";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, feedback.getTitle());
            stmt.setString(2, feedback.getContent());
            stmt.setString(3, feedback.getCategory());
            stmt.setInt(4, Integer.parseInt(feedback.getFeedbackID()));
            return stmt.executeUpdate() > 0;
        }
    }

    // ✅ Delete feedback
    public boolean deleteFeedback(int id) throws SQLException {
        String sql = "DELETE FROM feedback WHERE feedbackID = ? ";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        }
    }

    // ✅ List all feedback categories
    public List<FeedbackCategory> selectAllCategories() throws SQLException {
        List<FeedbackCategory> list = new ArrayList<>();
        String sql = "SELECT * FROM feedbackcategory";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(new FeedbackCategory(
                        rs.getInt("categoryID"),
                        rs.getString("name"),
                        rs.getString("description")
                ));
            }
        }
        return list;
    }

    // ✅ Check if a user has already upvoted
    public boolean hasUserUpvoted(String userID, int feedbackID) throws SQLException {
        String sql = "SELECT COUNT(*) FROM feedbackupvote WHERE userID = ? AND feedbackID = ?";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, userID);
            stmt.setInt(2, feedbackID);
            ResultSet rs = stmt.executeQuery();
            return rs.next() && rs.getInt(1) > 0;
        }
    }

    // ✅ Add upvote
    public boolean addUpvote(String userID, int feedbackID) throws SQLException {
        if (hasUserUpvoted(userID, feedbackID)) {
            return false;
        }

        String insert = "INSERT INTO feedbackupvote (userID, feedbackID) VALUES (?, ?)";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(insert)) {
            stmt.setString(1, userID);
            stmt.setInt(2, feedbackID);
            stmt.executeUpdate();
            return true;
        }
    }

    // ✅ Get top 5 feedbacks
    public List<Feedback> getTopFeedbacks() {
        List<Feedback> list = new ArrayList<>();
        String sql = "SELECT f.feedbackID, f.title, f.content, u.name "
                + "FROM feedback f JOIN user u ON f.userID = u.userID "
                + "ORDER BY f.createdAt DESC LIMIT 5";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Feedback f = new Feedback();
                f.setFeedbackID(rs.getString("feedbackID"));
                f.setTitle(rs.getString("title"));
                f.setContent(rs.getString("content"));
                f.setAuthorName(rs.getString("name"));
                list.add(f);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ✅ Search feedbacks
    public List<Feedback> searchFeedbacks(String keyword) {
        List<Feedback> list = new ArrayList<>();
        String sql = "SELECT f.feedbackID, f.title, f.content, u.name "
                + "FROM feedback f JOIN user u ON f.userID = u.userID "
                + "WHERE f.title LIKE ? OR f.content LIKE ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            String kw = "%" + keyword + "%";
            ps.setString(1, kw);
            ps.setString(2, kw);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Feedback f = new Feedback();
                f.setFeedbackID(rs.getString("feedbackID"));
                f.setTitle(rs.getString("title"));
                f.setContent(rs.getString("content"));
                f.setAuthorName(rs.getString("name"));
                list.add(f);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public void updateStatus(int feedbackID, String newStatus) throws SQLException {
        String sql = "UPDATE feedback SET status = ? WHERE feedbackID = ?";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, newStatus);
            stmt.setInt(2, feedbackID);
            stmt.executeUpdate();
        }
    }

}
