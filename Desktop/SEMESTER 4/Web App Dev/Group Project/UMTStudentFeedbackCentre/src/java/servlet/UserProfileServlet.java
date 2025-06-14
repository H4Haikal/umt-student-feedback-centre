package servlet;

import java.io.IOException;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class UserProfileServlet extends HttpServlet {

    // Update your DB details accordingly
    private final String DB_URL = "jdbc:mysql://localhost:3307/umt_student_feedback_center";
    private final String DB_USER = "root";
    private final String DB_PASS = ""; // Add your MySQL password if any

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false); // false = don't create new if none exists

        String userID = (String) session.getAttribute("userID");
        // proceed with DB query

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            String sql = "SELECT * FROM user WHERE userID = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, userID);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                request.setAttribute("userID", rs.getString("userID"));
                request.setAttribute("name", rs.getString("name"));
                request.setAttribute("email", rs.getString("email"));
                request.setAttribute("role", rs.getString("role"));
            }

            rs.close();
            stmt.close();
            conn.close();

            // Forward to the JSP
            RequestDispatcher dispatcher = request.getRequestDispatcher("userProfile.jsp");
            dispatcher.forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Ralat ketika memuatkan profil pengguna.");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Servlet yang memaparkan profil pengguna berdasarkan userID.";
    }
}
