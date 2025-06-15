package servlet;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import java.util.UUID;
import db.DBConnection;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author User
 */
public class CreateReplyServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String content = request.getParameter("content");
        int threadID = Integer.parseInt(request.getParameter("threadID"));
        String postedBy = (String) request.getSession().getAttribute("userID");

        try (Connection conn = DBConnection.getConnection()) {
            // Step 1: Generate new custom postID like "P001"
            String getLastIdSQL = "SELECT postID FROM forumpost WHERE postID LIKE 'P%' ORDER BY postID DESC LIMIT 1";
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(getLastIdSQL);

            String postID = "P001"; // Default first ID
            if (rs.next()) {
                String lastID = rs.getString("postID"); // e.g., "P007"
                int number = Integer.parseInt(lastID.substring(1)); // Extract number
                number++; // Increment
                postID = String.format("P%03d", number); // Format e.g., P008
            }

            // Step 2: Insert reply with custom postID, auto timestamp handled by DB
            String sql = "INSERT INTO forumpost (postID, content, postedBy, threadID) VALUES (?, ?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, postID);
            ps.setString(2, content);
            ps.setString(3, postedBy);
            ps.setInt(4, threadID);
            ps.executeUpdate();

            response.sendRedirect("viewThread.jsp?threadID=" + threadID);

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("viewThread.jsp?threadID=" + threadID + "&error=db");
        } catch (Exception ex) {
            Logger.getLogger(CreateReplyServlet.class.getName()).log(Level.SEVERE, null, ex);
            response.sendRedirect("viewThread.jsp?threadID=" + threadID + "&error=server");
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
