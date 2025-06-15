<%-- 
    Document   : procesLogin
    Created on : 31 May 2025, 11:48:53 am
    Author     : User
--%>
<%@ page import="java.sql.*, db.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String email = request.getParameter("email");
    String password = request.getParameter("password");

    try (Connection con = DBConnection.getConnection()) {
        PreparedStatement ps = con.prepareStatement(
                "SELECT * FROM user WHERE email = ? AND password = ?"
        );
        ps.setString(1, email);
        ps.setString(2, password); // Hash check in real apps!

        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            String role = rs.getString("role");
            session.setAttribute("userID", rs.getString("userID"));
            session.setAttribute("userRole", role);
            session.setAttribute("userEmail", email);
            session.setAttribute("userName", rs.getString("name"));

            if ("admin".equals(role)) {
                response.sendRedirect("../adminDash.jsp");
            } else if ("staff".equals(role)) {
                response.sendRedirect("../staffDash.jsp");
            } else if ("student".equals(role)) {
                response.sendRedirect("../studentDash.jsp");
            } else {
                response.sendRedirect("../index.jsp");
            }

        } else {
            response.sendRedirect("../login.jsp?error=invalid_credentials");
        }
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("../login.jsp?error=exception");
    }
%>
