<%@ page language="java" contentType="text/html; charset=EUC-KR"
         pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC>
<%@ page import="main.Main"%>
<%@ page import="java.sql.*" %>
<a href="index.jsp">홈으로 돌아가기</a>
<%
    Main m=new Main();
    m.saveWifiInfo();
    int count=0;
    String url = "jdbc:mysql://localhost:3306/wifiInfo";
    String userName = "root";
    String password = "ehddn";
    try {
        Connection connection = DriverManager.getConnection(url, userName, password);

        Statement sm=connection.createStatement();

        ResultSet rs=sm.executeQuery("SELECT COUNT(*) FROM WifiTables");
        if(rs.next()) count=rs.getInt(1);

        connection.close();
        sm.close();

    } catch (SQLException e) {
        System.out.print(e.getMessage());

    }
%>
<script>
    alert("db저장 완료");
</script>
<p><%=count%>개의 WIFI 정보를 정상적으로 저장하였습니다.</p>