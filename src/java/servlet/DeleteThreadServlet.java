/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package servlet;

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
import db.DBConnection;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author User
 */
public class DeleteThreadServlet extends HttpServlet {

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
        int threadID = Integer.parseInt(request.getParameter("threadID"));
        String userID = (String) request.getSession().getAttribute("userID");
        String userRole = (String) request.getSession().getAttribute("userRole");

        try (Connection conn = DBConnection.getConnection()) {
            // Step 1: Delete replies under the thread (if any)
            String deletePosts = "DELETE FROM forumpost WHERE threadID = ?";
            try (PreparedStatement ps1 = conn.prepareStatement(deletePosts)) {
                ps1.setInt(1, threadID);
                ps1.executeUpdate();
            }

            // Step 2: Admins can delete any thread, users only their own
            String deleteThread;
            PreparedStatement ps2;
            if ("admin".equals(userRole)) {
                deleteThread = "DELETE FROM forumthread WHERE threadID = ?";
                ps2 = conn.prepareStatement(deleteThread);
                ps2.setInt(1, threadID);
            } else {
                deleteThread = "DELETE FROM forumthread WHERE threadID = ? AND createdBy = ?";
                ps2 = conn.prepareStatement(deleteThread);
                ps2.setInt(1, threadID);
                ps2.setString(2, userID);
            }

            int rowsAffected = ps2.executeUpdate();
            ps2.close();

            if (rowsAffected > 0) {
                // Redirect based on origin (optional)
                String source = request.getParameter("source");
                if ("admin".equals(source)) {
                    response.sendRedirect("manageUsers.jsp");
                } else {
                    response.sendRedirect("forumDash.jsp");
                }
            } else {
                response.sendRedirect("error.jsp?msg=Unauthorized or thread not found");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp?msg=Database error");
        } catch (Exception ex) {
            Logger.getLogger(DeleteThreadServlet.class.getName()).log(Level.SEVERE, null, ex);
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
