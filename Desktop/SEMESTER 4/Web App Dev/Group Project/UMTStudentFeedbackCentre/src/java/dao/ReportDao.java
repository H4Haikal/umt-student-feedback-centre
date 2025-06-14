package dao;

import db.DBConnection;
import static db.DBConnection.getConnection;
import model.*;

import java.sql.*;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ReportDao {

    public List<StatusCount> getStatusCounts() {
        List<StatusCount> list = new ArrayList<>();
        String sql = "SELECT category AS status, COUNT(*) AS count FROM feedback GROUP BY category";

        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                StatusCount s = new StatusCount();
                s.setStatus(rs.getString("status"));
                s.setCount(rs.getInt("count"));
                list.add(s);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<CategoryCount> getCategoryCounts() {
        List<CategoryCount> list = new ArrayList<>();
        String sql = "SELECT category, COUNT(*) AS count FROM feedback GROUP BY category";

        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                CategoryCount c = new CategoryCount();
                c.setCategory(rs.getString("category"));
                c.setCount(rs.getInt("count"));
                list.add(c);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<TopFeedback> getTopFeedback() {
        List<TopFeedback> list = new ArrayList<>();
        String sql = """
        SELECT f.feedbackID, f.title, f.content, f.userID, u.name AS userName, COUNT(fu.upvoteID) AS upvotes
        FROM feedback f
        JOIN user u ON f.userID = u.userID
        LEFT JOIN feedbackupvote fu ON f.feedbackID = fu.feedbackID
        GROUP BY f.feedbackID
        ORDER BY upvotes DESC
        LIMIT 5
    """;

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                TopFeedback tf = new TopFeedback();
                tf.setFeedbackID(rs.getInt("feedbackID"));
                tf.setTitle(rs.getString("title"));
                tf.setContent(rs.getString("content"));
                tf.setUserID(rs.getString("userID"));
                tf.setUserName(rs.getString("userName"));
                tf.setUpvotes(rs.getInt("upvotes"));
                list.add(tf);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception ex) {
            Logger.getLogger(ReportDao.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    public List<ActiveUser> getMostActiveUsers() {
        List<ActiveUser> list = new ArrayList<>();
        String sql = """
                SELECT u.userID, u.name, COUNT(p.postID) AS totalPosts
                FROM forumpost p
                JOIN user u ON p.postedBy = u.userID
                GROUP BY p.postedBy
                ORDER BY totalPosts DESC
                LIMIT 5
                """;

        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ActiveUser u = new ActiveUser();
                u.setUserName(rs.getString("name"));
                u.setPostCount(rs.getInt("totalPosts"));
                list.add(u);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public int getTotalThreads() {
        String sql = "SELECT COUNT(*) AS total FROM forumthread";

        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("total");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int getTotalReplies() {
        String sql = "SELECT COUNT(*) AS total FROM forumpost";

        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("total");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
}
