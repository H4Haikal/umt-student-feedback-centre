<%@ page import="java.sql.*, java.net.URLEncoder, db.DBConnection" %>
<%
    String adminKey = request.getParameter("adminKey");
    String expectedAdminKey = "ADMINUMTSFC"; // You define this securely in real use
    String role = request.getParameter("role");
    String id = ("student".equals(role)) ? request.getParameter("studentID")
            : ("staff".equals(role)) ? request.getParameter("staffID")
            : request.getParameter("adminID");

    String name = request.getParameter("name");
    String email = request.getParameter("email");
    String password = request.getParameter("password");
    
    if ("admin".equals(role) && (adminKey == null || !adminKey.equals(expectedAdminKey))) {
    response.sendRedirect("../register.jsp?error=invalid_adminkey");
    return;
}

    try (Connection con = DBConnection.getConnection()) {
        String sql = "INSERT INTO user (role, userId, name, email, password) VALUES (?, ?, ?, ?, ?)";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setString(1, role);
        ps.setString(2, id);
        ps.setString(3, name);
        ps.setString(4, email);
        ps.setString(5, password);

        int result = ps.executeUpdate(); // Must insert into user first

        if (result > 0) {
            if ("admin".equals(role)) {
                PreparedStatement ps2 = con.prepareStatement("INSERT INTO admin (adminID) VALUES (?)");
                ps2.setString(1, id);
                ps2.executeUpdate();
            } else if ("staff".equals(role)) {
                PreparedStatement ps2 = con.prepareStatement("INSERT INTO staff (staffID) VALUES (?)");
                ps2.setString(1, id);
                ps2.executeUpdate();
            } else if ("student".equals(role)) {
                PreparedStatement ps2 = con.prepareStatement("INSERT INTO student (studentID) VALUES (?)");
                ps2.setString(1, id);
                ps2.executeUpdate();
            }

            response.sendRedirect("../login.jsp?message=success");
        } else {
            response.sendRedirect("../register.jsp?error=registration_failed");
        }

    } catch (SQLException e) {
        response.sendRedirect("../register.jsp?error=sql_exception&message=" + URLEncoder.encode(e.getMessage(), "UTF-8"));
    } catch (Exception e) {
        response.sendRedirect("../register.jsp?error=exception&message=" + URLEncoder.encode(e.getMessage(), "UTF-8"));
    }
%>
