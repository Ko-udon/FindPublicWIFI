package main;

import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.io.BufferedReader;
import java.io.IOException;
import java.sql.*;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

public class Main {
    public double userLAT;
    public double userLNT;

    public static void findWifiInfo(){
        String url = "jdbc:mysql://localhost:3306/wifiInfo";
        String userName = "root";
        String password = "ehddn";
        try {
            Connection connection = DriverManager.getConnection(url, userName, password);
            //Statement statement = connection.createStatement();

            String sql = "SELECT * FROM wifiTables WHERE ";
            PreparedStatement pstmt = connection.prepareStatement(sql);
            int res = pstmt.executeUpdate();  //실행결과
            connection.close();
            pstmt.close();

        } catch (SQLException e) {
            System.out.print(e.getMessage());

        }

    }

    public static void saveWifiInfo(){
        String result="";
        /*double userLAT=37.5058034;
        double userLNT=127.0936762;*/
        int pageNo=1;
        int numOfRows=1000;
        while(pageNo<=20000){
            try {
                StringBuilder urlBuilder = new StringBuilder("http://openapi.seoul.go.kr:8088"); /*URL*/
                urlBuilder.append("/" + URLEncoder.encode("646472456265686438385849497463", "UTF-8")); /*인증키 (sample사용시에는 호출시 제한됩니다.)*/
                urlBuilder.append("/" + URLEncoder.encode("json", "UTF-8")); /*요청파일타입 (xml,xmlf,xls,json) */
                urlBuilder.append("/" + URLEncoder.encode("TbPublicWifiInfo", "UTF-8")); /*서비스명 (대소문자 구분 필수입니다.)*/
                urlBuilder.append("/" + URLEncoder.encode(Integer.toString(pageNo), "UTF-8")); /*요청시작위치 (sample인증키 사용시 5이내 숫자)*/
                urlBuilder.append("/" + URLEncoder.encode(Integer.toString(numOfRows), "UTF-8")); /*요청종료위치(sample인증키 사용시 5이상 숫자 선택 안 됨)*/

                // 서비스별 추가 요청 인자이며 자세한 내용은 각 서비스별 '요청인자'부분에 자세히 나와 있습니다.
                //urlBuilder.append("/" + URLEncoder.encode("20220301","UTF-8")); /* 서비스별 추가 요청인자들*/

                URL url = new URL(urlBuilder.toString());
                HttpURLConnection conn = (HttpURLConnection) url.openConnection();

                conn.setRequestMethod("GET");
                conn.setRequestProperty("Content-type", "application/json");
                System.out.println("Response code: " + conn.getResponseCode());
                System.out.println(urlBuilder);
                BufferedReader br = new BufferedReader(new InputStreamReader(url.openStream(), "UTF-8"));
                result = br.readLine();

                JSONParser jsonParser = new JSONParser();
                JSONObject jsonObject = (JSONObject) jsonParser.parse(result);
                JSONObject jsonObject2 = (JSONObject) jsonObject.get("TbPublicWifiInfo");
                JSONArray jsonArray = (JSONArray) jsonObject2.get("row");

                for (int i = 0; i < jsonArray.size(); i++) {
                    JSONObject object = (JSONObject) jsonArray.get(i);


                /*double distance = distance(Double.parseDouble((String) object.get("LAT")), Double.parseDouble((String) object.get("LNT")),
                        userLAT, userLNT); //거리*/


                    String manageNo = (String) object.get("X_SWIFI_MGR_NO"); //관리번호
                    String reginalGu = (String) object.get("X_SWIFI_WRDOFC");  // 자치구
                    String wifiName = (String) object.get("X_SWIFI_MAIN_NM");//와이파이명
                    String addressDoromung = (String) object.get("X_SWIFI_ADRES1");//도로명주소
                    String address = (String) object.get("X_SWIFI_ADRES2"); //상세주소
                    String installPos = (String) object.get("X_SWIFI_INSTL_FLOOR"); //설치위치(층)
                    String installType = (String) object.get("X_SWIFI_INSTL_TY"); //설치유형
                    String installManagement = (String) object.get("X_SWIFI_INSTL_MBY"); //설치기관
                    String servType = (String) object.get("X_SWIFI_SVC_SE"); //서비스구분
                    String servLocalType = (String) object.get("X_SWIFI_CMCWR"); //망종류
                    String installYear = (String) object.get("X_SWIFI_CNSTC_YEAR"); //설치년도
                    String inOrOut = (String) object.get("X_SWIFI_INOUT_DOOR"); //실내외구분
                    String connType = (String) object.get("X_SWIFI_REMARS3"); //wifi접속환경
                    double LAT = Double.parseDouble((String) object.get("LAT")); //y좌표
                    double LNT = Double.parseDouble((String) object.get("LNT")); //x좌표
                    String work_dttm = (String) object.get("WORK_DTTM"); //작업일


                    String url2 = "jdbc:mysql://localhost:3306/wifiInfo";
                    String userName = "root";
                    String password = "ehddn";
                    try {
                        Connection connection = DriverManager.getConnection(url2, userName, password);

                        String sql = "INSERT INTO wifiTables VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
                        PreparedStatement pstmt = connection.prepareStatement(sql);
                        pstmt.setString(1, manageNo);
                        pstmt.setString(2, reginalGu);
                        pstmt.setString(3, wifiName);
                        pstmt.setString(4, addressDoromung);
                        pstmt.setString(5, address);
                        pstmt.setString(6, installPos);
                        pstmt.setString(7, installType);
                        pstmt.setString(8, installManagement);
                        pstmt.setString(9, servType);
                        pstmt.setString(10, servLocalType);
                        pstmt.setString(11, installYear);
                        pstmt.setString(12, inOrOut);
                        pstmt.setString(13, connType);
                        pstmt.setString(14, String.valueOf(LAT));
                        pstmt.setString(15, String.valueOf(LNT));
                        pstmt.setString(16, work_dttm);

                        int res = pstmt.executeUpdate();
                        connection.close();
                        pstmt.close();

                    } catch (SQLException e) {
                        System.out.print(e.getMessage());
                    }
                }
            }
            catch (Exception e){
                System.out.print(e.getMessage());
            }
            pageNo=numOfRows+1;
            numOfRows+=1000;
        }

    }


    public static void main(String[] args)throws IOException, ParseException {
        /*int i=1;
        int j=1000;
        while(j<=20000){
            saveWifiInfo(Integer.toString(i),Integer.toString(j));
            i=j++;
            j=j+1000;
        }*/
    }



    // dsitance(첫번쨰 좌표의 위도, 첫번째 좌표의 경도, 두번째 좌표의 위도, 두번째 좌표의 경도)
    public double distance(double lat1, double lon1, double lat2, double lon2){
        double theta = lon1 - lon2;
        double dist = Math.sin(deg2rad(lat1))* Math.sin(deg2rad(lat2)) + Math.cos(deg2rad(lat1))*Math.cos(deg2rad(lat2))*Math.cos(deg2rad(theta));
        dist = Math.acos(dist);
        dist = rad2deg(dist);
        dist = dist * 60*1.1515*1609.344;

        return dist/1000; //단위 killometer
    }
    //10진수를 radian(라디안)으로 변환
    public static double deg2rad(double deg){
        return (deg * Math.PI/180.0);
    }
    //radian(라디안)을 10진수로 변환
    public static double rad2deg(double rad){
        return (rad * 180 / Math.PI);
    }

}
