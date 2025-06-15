package dao;

import java.sql.*;
import java.util.*;
import model.Thread;
import db.DBConnection;

public class ThreadDAO {

    public static List<Thread> getTopThreads() {
        List<Thread> list = new ArrayList<>();
        String sql = "SELECT t.threadID, t.title, u.name, "
                + "(SELECT COUNT(*) FROM forumPost r WHERE r.threadID = t.threadID) AS reply_count "
                + "FROM forumthread t JOIN user u ON t.createdBy = u.userID ORDER BY reply_count DESC LIMIT 5";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Thread t = new Thread();
                t.setThreadID(rs.getString("threadID"));
                t.setTitle(rs.getString("title"));
                t.setAuthorName(rs.getString("name"));
                t.setReplyCount(rs.getInt("reply_count"));
                list.add(t);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public static List<Thread> searchThreads(String keyword) {
        List<Thread> list = new ArrayList<>();
        String sql = "SELECT t.threadID, t.title, u.name AS authorName, (SELECT COUNT(*) FROM forumpost r WHERE r.threadID = t.threadID) AS reply_count FROM forumthread t JOIN user u ON t.createdBy = u.userID WHERE t.title LIKE ? ORDER BY t.threadID DESC";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
             String kw = "%" + keyword + "%";
            ps.setString(1, kw);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Thread t = new Thread();
                t.setThreadID(rs.getString("threadID"));
                t.setTitle(rs.getString("title"));
                t.setAuthorName(rs.getString("name"));
                t.setReplyCount(rs.getInt("reply_count"));
                list.add(t);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
