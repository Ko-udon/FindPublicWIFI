<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8"%>
<%--<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>--%>
<% request.setCharacterEncoding("UTF-8");%>
<% response.setContentType("text/html; charset=UTF-8");%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>와이파이 구하기</title>

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="http://ajax.aspnetcdn.com/ajax/jQuery/jquery-1.12.4.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/vue/dist/vue.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
    <%--<script type="text/javascript" src="https://maps.googleapis.com/maps/api/js?key=YOUR_API_KEY"></script>--%>

    <script >
        let userLAT=0;
        let userLNT=0;
    </script>
    <script>function getLocation() {

        if (navigator.geolocation) { // GPS를 지원하면
            navigator.geolocation.getCurrentPosition(function(position) {
                alert(position.coords.latitude + ' ' + position.coords.longitude);
                console.log(position.coords.latitude,position.coords.longitude);
                userLAT=position.coords.latitude;
                userLNT=position.coords.longitude;

                document.getElementById("userLAT").value = userLAT;
                document.getElementById("userLNT").value = userLNT;

                //console.log(userLAT,userLNT);
            }, function(error) {
                console.error(error);
            }, {
                enableHighAccuracy: false,
                maximumAge: 0,
                timeout: Infinity
            });
        } else {
            alert('GPS를 지원하지 않습니다');
        }
    }</script>

    <script>function setUserPos(){
        document.getElementById("userLAT").value = userLAT;
        document.getElementById("userLNT").value = userLNT;
        //console.log("함수수행");

    }</script>
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
<form action="index.jsp" method="post">
    <input type="submit" value="홈">
</form>
<form action="call_history.jsp" method="post">
    <input type="submit" value="위치 히스토리 목록">
</form>
<form action="call_saveAPI.jsp" method="post">
    <input type="submit" value="Open API 와이파이 정보 가져오기">
</form>

<form action="call_findWIFIInfo.jsp" method="post">
    LAT: <input type="text" id="userLAT" name="userLAT">,
    LNT: <input type="text" id="userLNT" name="userLNT">
    <input type="button" value="내 위치 가져오기" onclick="getLocation()">
    <input type="submit" value="근처와이파이 정보보기">
</form>
<h2>꼭 위치정보를 먼저 조회 후 이용해주세요!</h2>
</html>