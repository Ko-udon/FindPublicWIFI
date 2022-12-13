<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8"%>
<%@ page import="main.Main"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html PUBLIC>
<html>
<head>
  <title>Title</title>
</head>
<body>
<% String send_id=request.getParameter("send_id");
  request.setCharacterEncoding("utf-8");
  String url = "jdbc:mysql://localhost:3306/wifiInfo";
  String userName = "root";
  String password = "ehddn";
  try{
    Connection connection = DriverManager.getConnection(url, userName, password);
    PreparedStatement pstmt=connection.prepareStatement("DELETE FROM userHistory where ID=?"); //u
    pstmt.setString(1,send_id);
    pstmt.executeUpdate();
    pstmt.close();
    connection.close();
    response.sendRedirect("call_history.jsp");  //삭제 완료 후 다시 히스토리 페이지로 이동

  }catch (SQLException e) {
    System.out.print(e.getMessage());
  }
%>

</body>
</html>
