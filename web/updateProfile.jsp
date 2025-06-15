<%-- 
    Document   : updateProfile.jsp
    Created on : 10 Jun 2025, 2:49:47 pm
    Author     : User
--%>

<%@ page import="java.sql.*, db.DBConnection" %>
<%@ page session="true" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String role = (String) session.getAttribute("userRole");
    String userId = (String) session.getAttribute("userID");

    if (role == null || userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Common fields
    String name = request.getParameter("name");
    String email = request.getParameter("email");

    // Fields based on role
    String program = request.getParameter("program");
    String course = request.getParameter("course");
    String level = request.getParameter("level");

    String department = request.getParameter("department");
    String faculty = request.getParameter("faculty");
    String position = request.getParameter("position");

    Connection con = null;
    PreparedStatement psUser = null;
    PreparedStatement psRole = null;

    try {
        con = DBConnection.getConnection();

        // Update user table
        String sqlUser = "UPDATE user SET name = ?, email = ? WHERE userId = ?";
        psUser = con.prepareStatement(sqlUser);
        psUser.setString(1, name);
        psUser.setString(2, email);
        psUser.setString(3, userId);
        psUser.executeUpdate();

        // Update role-specific table
        if ("student".equals(role)) {
            String sql = "UPDATE student SET program = ?, course = ?, level = ? WHERE studentID = ?";
            psRole = con.prepareStatement(sql);
            psRole.setString(1, program);
            psRole.setString(2, course);
            psRole.setString(3, level);
            psRole.setString(4, userId);
            psRole.executeUpdate();

        } else if ("staff".equals(role)) {
            String sql = "UPDATE staff SET department = ?, faculty = ?, position = ? WHERE staffID = ?";
            psRole = con.prepareStatement(sql);
            psRole.setString(1, department);
            psRole.setString(2, faculty);
            psRole.setString(3, position);
            psRole.setString(4, userId);
            psRole.executeUpdate();

        } else if ("admin".equals(role)) {
            String sql = "UPDATE admin SET department = ?, faculty = ?, position = ? WHERE adminID = ?";
            psRole = con.prepareStatement(sql);
            psRole.setString(1, department);
            psRole.setString(2, faculty);
            psRole.setString(3, position);
            psRole.setString(4, userId);
            psRole.executeUpdate();
        }

        // ✅ Update session with common fields
        session.setAttribute("name", name);
        session.setAttribute("email", email);

// ✅ Update session with role-specific fields
        if ("student".equals(role)) {
            session.setAttribute("program", program);
            session.setAttribute("course", course);
            session.setAttribute("level", level);

        } else if ("staff".equals(role)) {
            session.setAttribute("department", department);
            session.setAttribute("faculty", faculty);
            session.setAttribute("position", position);

        } else if ("admin".equals(role)) {
            session.setAttribute("department", department);
            session.setAttribute("faculty", faculty);
            session.setAttribute("position", position);
        }

        response.sendRedirect("userProfile.jsp?message=updated");

    } catch (SQLException e) {
        e.printStackTrace();
        response.sendRedirect("userProfile.jsp?error=sql&msg=" + e.getMessage());
    } finally {
        try {
            if (psUser != null) {
                psUser.close();
            }
        } catch (Exception ignored) {
            ignored.printStackTrace();
        }
        try {
            if (psRole != null) {
                psRole.close();
            }
        } catch (Exception ignored) {
            ignored.printStackTrace();
        }
        try {
            if (con != null) {
                con.close();
            }
        } catch (Exception ignored) {
            ignored.printStackTrace();
        }
    }
%>
