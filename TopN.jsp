<%@page language="java" contentType="text/html"%>  
<%@ page import="java.sql.*" %> 
<%@ page import="java.io.*" %> 
<%@ page import="java.util.ArrayList" %> 
<%@ page import="java.util.Random" %> 
<!DOCTYPE html>
<html> 
<head> <title>Top 3 Locations</title>
  <meta http-equiv="content-type" content="text/html; charset=UTF-8" /> 
<link rel="stylesheet" type="text/css" href="first.css">
  <title>Google Maps Multiple Markers</title> 
  <script src="http://maps.google.com/maps/api/js?sensor=false" 
          type="text/javascript"></script>
</head> 
<center><br/><br/><br/>
<h2> Top 3 locations for your selection are shown below : </h2><br/><br/><br/>
<body>
<%
ArrayList[] leader_list= (ArrayList[])session.getAttribute("ldata");
int[] temp=(int[])session.getAttribute("temp");
double[][] coords=new double[3][3];
for(int i=0;i<3;i++)
{
for(int j=0;j<2;j++)
{
String[] x=leader_list[temp[i]].get(0).toString().split(",");
coords[i][j]=Double.parseDouble(x[j+1]);
}
}
%>

  <div id="map" style="width: 500px; height: 400px;"></div>


  <script type="text/javascript">
    var locations = [
      [<%=coords[0][0]%>,<%=coords[0][1]%>],
      [<%=coords[1][0]%>,<%=coords[1][1]%>],
      [<%=coords[2][0]%>,<%=coords[2][1]%>]
    ];

    var map = new google.maps.Map(document.getElementById('map'), {
      zoom: 7,
      center: new google.maps.LatLng(35.57224, -79.5391),
      mapTypeId: google.maps.MapTypeId.ROADMAP
    });

    var infowindow = new google.maps.InfoWindow();

    var marker, i;

    for (i = 0; i < locations.length; i++) {  
      marker = new google.maps.Marker({
        position: new google.maps.LatLng(locations[i][0], locations[i][1]),
        map: map
      });

     /* google.maps.event.addListener(marker, 'click', (function(marker, i) {
        return function() {
          infowindow.setContent(locations[i][0]);
          infowindow.open(map, marker);
        }
      })(marker, i));*/
    }
  </script>
<br><br><br>
<form action=index.html method=post>
<input type=submit name=submit value="Go Home">
</form></center>
</body>
</html>
