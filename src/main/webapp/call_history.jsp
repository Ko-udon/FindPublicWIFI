<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8"%>
<%@ page import="main.Main"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html PUBLIC>
<html>
<head>
    <style type="text/css">
        table {
            margin-left:auto;
            margin-right:auto;
        }

        table, td, th {
            border-collapse : collapse;
            border : 1px solid black;
        }
    </style>
</head>
<h1>위치 히스토리 목록</h1>
<a href="index.jsp">홈으로 돌아가기</a>


<style type="text/css">
    table {
        margin-left:auto;
        margin-right:auto;
    }

    table, td, th {
        border-collapse : collapse;
        border : 1px solid black;
    }
</style>

<table id="history">
    <thead>
    <tr>
        <th>ID</th>
        <th>X좌표</th>
        <th>Y좌표</th>
        <th>조회일자</th>
        <th>비고</th>
    </tr>
    </thead>
    <tbody>
        <%
            Main m=new Main();
            String url = "jdbc:mysql://localhost:3306/wifiInfo";
            String userName = "root";
            String password = "ehddn";
            ResultSet rs=null;

            try {
                Connection connection = DriverManager.getConnection(url, userName, password);

                String sql = "SELECT * from userHistory";
                PreparedStatement pstmt = connection.prepareStatement(sql);
                rs=pstmt.executeQuery();
                while(rs.next()){
        %>
    <tr>
        <td><%=rs.getString("ID")%></td>
        <td><%=rs.getString("LAT")%></td>
        <td><%=rs.getString("LNT")%></td>
        <td><%=rs.getString("requestTime")%></td>
        <td><a href="<%=request.getContextPath()%>/call_deleteHistory.jsp?send_id=<%=rs.getString("ID")%>">삭제</a>
            <%--해당하는 ID값 삭제처리--%>
        </td>
    </tr>
        <%
                }
                connection.close();
                pstmt.close();
            } catch (SQLException e) {
                System.out.print(e.getMessage());
            }
        %>
</table>
</html>