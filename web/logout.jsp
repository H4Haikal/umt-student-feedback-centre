<%-- 
    Document   : logout
    Created on : 8 Jun 2025, 11:50:34 am
    Author     : User
--%>
<%@ page session="true" %>
<%
    session.invalidate();
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
    response.sendRedirect("login.jsp");
%>
