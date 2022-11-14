<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8"%>
<%--<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>--%>
<% request.setCharacterEncoding("UTF-8");%>
<% response.setContentType("text/html; charset=UTF-8");%>
<%@ page import="main.Main"%>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html PUBLIC>
<head>

    <meta charset="UTF-8">
    <title>와이파이 구하기</title>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="http://ajax.aspnetcdn.com/ajax/jQuery/jquery-1.12.4.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/vue/dist/vue.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>

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
<h1>와이파이 정보 구하기</h1>
<a href="index.jsp">홈으로 돌아가기</a>


<%
    Main m=new Main();
    m.userLNT=Double.parseDouble(request.getParameter("userLNT"));
    m.userLAT=Double.parseDouble(request.getParameter("userLAT"));

    String url = "jdbc:mysql://localhost:3306/wifiInfo";
    String userName = "root";
    String password = "ehddn";


    //history에 먼저 저장
    try {
        Connection connection = DriverManager.getConnection(url, userName, password);
        //Statement statement = connection.createStatement();

        String sql = "INSERT INTO userHistory(LAT,LNT,requestTime) values(?,?,?) ";
        LocalDateTime now = LocalDateTime.now();
        PreparedStatement pstmt = connection.prepareStatement(sql);
        pstmt.setString(1,String.valueOf(m.userLAT));
        pstmt.setString(2,String.valueOf(m.userLNT));
        pstmt.setString(3,String.valueOf(now));
        pstmt.executeUpdate();
        connection.close();
        pstmt.close();
        System.out.println("히스토리 저장");

    } catch (SQLException e) {
        System.out.print(e.getMessage());

    }
%>
<table id="api">
    <thead>
    <tr>
        <th>거리</th>
        <th>관리번호</th>
        <th>자치구</th>
        <th>와이파이명</th>
        <th>도로명주소</th>
        <th>상세주소</th>
        <th>설치위치(층)</th>
        <th>설치유형</th>
        <th>설치기관</th>
        <th>서비스구분</th>
        <th>망종류</th>
        <th>설치년도</th>
        <th>실내외 구분</th>
        <th>WIFI접속 환경</th>
        <th>X좌표</th>
        <th>Y좌표</th>
        <th>작업일자</th>
    </tr>
    </thead>
    <tbody>
    <%

        try {
            double distance=0;

            Connection connection = DriverManager.getConnection(url, userName, password);
            ResultSet rs=null;
            //한국 좌표 범위는 경도범위 125-132 , 위도범위는 33-43  ,, 반경 2키로 이내의 데이터만 출력
            String sql = "SELECT *,ST_Distance_Sphere(POINT(?,?),POINT(LNT,LAT))/1000 as distance from wifiTables WHERE LNT BETWEEN 125 and 132 and LAT BETWEEN 33 and 43 HAVING distance<=2.0  order by distance limit 20";
            PreparedStatement pstmt = connection.prepareStatement(sql);
            pstmt.setDouble(1,m.userLNT);
            pstmt.setDouble(2,m.userLAT);

            rs=pstmt.executeQuery();
            while(rs.next()){
    %>
    <tr>
        <td><%=String.format("%.4f",rs.getDouble("distance"))%></td>
        <td><%=rs.getString("manageNo")%></td>
        <td><%=rs.getString("reginalGu")%></td>
        <td><%=rs.getString("wifiName")%></td>
        <td><%=rs.getString("addressDoromung")%></td>
        <td><%=rs.getString("address")%></td>
        <td><%=rs.getString("installPos")%></td>
        <td><%=rs.getString("installType")%></td>
        <td><%=rs.getString("installManagement")%></td>
        <td><%=rs.getString("servType")%></td>
        <td><%=rs.getString("servLocalType")%></td>
        <td><%=rs.getString("installYear")%></td>
        <td><%=rs.getString("inOrOut")%></td>
        <td><%=rs.getString("connType")%></td>
        <td><%=rs.getString("LAT")%></td>
        <td><%=rs.getString("LNT")%></td>
        <td><%=rs.getString("work_dttm")%></td>


    </tr>
    <%
            }
            connection.close();
            pstmt.close();

        } catch (SQLException e) {
            System.out.print(e.getMessage());

        }


    %>
    </tbody>
</table>



