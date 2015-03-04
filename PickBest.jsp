<%@page language="java" contentType="text/html"%>  
<%@ page import="java.sql.*" %> 
<%@ page import="java.io.*" %> 
<%@ page import="java.util.ArrayList" %> 
<%@ page import="java.util.Random" %> 
<html>
<title>Best Location </title>
<link rel="stylesheet" type="text/css" href="first.css">
<body>
<form action="TopN.jsp" method=post>
<br/><br/><br/>
<center>
<h2>
The best location for your selection is shown below : </h2><br/><br/>
<br/><br/>
<%
try {

		
    String connectionURL = "jdbc:mysql://localhost/hotdetect";
    Connection connection = null; 
    Class.forName("com.mysql.jdbc.Driver").newInstance(); 
    connection = DriverManager.getConnection(connectionURL, "root", "");

ArrayList[] leader_list= (ArrayList[])session.getAttribute("cdata");
String[] userpref = request.getParameterValues("UserPref");
String pwt = (String)request.getParameter("pwt");
String ewt = (String)request.getParameter("ewt");
String cwt = (String)request.getParameter("cwt");
//out.println(pwt);
//out.println(ewt);
//out.println(cwt);
double[] abpm=new double[15];

for(int i=0;i<15;i++)
{	
	abpm[i]=0;	
	double tbpm=0;
	for(int j=0;j<leader_list[i].size();j++)
	{
		double dbpm=1;
		String zip=leader_list[i].get(j).toString().substring(0,5);
		int izip=Integer.parseInt(zip);
		String sql = "select N_MedianInc,N_MeanInc,N_Pop,N_Comp from zipcode_data where Zip="+izip;
		//out.println(sql);
		//out.println(leader_list[i].size());
		if(!connection.isClosed())
{	
		Statement s = connection.createStatement();

              	ResultSet rs = s.executeQuery(sql);
		while (rs.next()) {
		for(int k=0;k<userpref.length;k++)
		{
			if(userpref[k].equals("pop"))
			{
				//dbpm=dbpm*Double.parseDouble(rs.getString(3));
				//out.println(dbpm);

				if(pwt.equals("Med"))
				dbpm=dbpm*(6.67*Double.parseDouble(rs.getString(3)));
				else if(pwt.equals("High"))
				dbpm=dbpm*(10*Double.parseDouble(rs.getString(3)));
				else
				dbpm=dbpm*(3.3*Double.parseDouble(rs.getString(3)));
			}
			else if(userpref[k].equals("earn"))
			{
				//dbpm=dbpm*((Double.parseDouble(rs.getString(1))*0.5)+(Double.parseDouble(rs.getString(2))*0.5));
				double temp=((Double.parseDouble(rs.getString(1))*0.5)+(Double.parseDouble(rs.getString(2))*0.5));
				//out.println(dbpm);

				if(ewt.equals("Med"))
				dbpm=dbpm*(6.67*temp);
				else if(ewt.equals("High"))
				dbpm=dbpm*(10*temp);
				else
				dbpm=dbpm*(3.3*temp);
			}
			else if(userpref[k].equals("comp"))
			{
				if (Double.parseDouble(rs.getString(4))==0)
				{			
				if(cwt.equals("Med"))
				dbpm=dbpm/(6.67*0.1);
				else if(cwt.equals("High"))
				dbpm=dbpm/(10*0.1);
				else 
				dbpm=dbpm/(3.3*0.1);
				}
				else
				{
				if(cwt.equals("Med"))
				dbpm=dbpm/(6.67*Double.parseDouble(rs.getString(4)));
				else if(cwt.equals("High"))
				dbpm=dbpm/(10*Double.parseDouble(rs.getString(4)));
				else 
				dbpm=dbpm/(3.3*Double.parseDouble(rs.getString(4)));
				}
					
				//out.println(dbpm);
			}		
		}}
	tbpm=tbpm+dbpm;	
	}
	//out.println(tbpm);
	abpm[i]=tbpm/leader_list[i].size();
	//out.println(abpm[i]);
}
}
for(int p=0;p<15;p++)
{
//out.println(abpm[p]);
}

double t=-1;
int[] temp=new int[3];
for(int g=0;g<3;g++)
temp[g]=0;

for(int i=0;i<15;i++)
{
	if(abpm[i]>t)
	{
		temp[0]=i;
		t=abpm[i];
	}
}
//out.println(temp[0]);
t=0;
for(int i=0;i<15;i++)
{
	if(abpm[i]>t && abpm[i]<abpm[temp[0]])
	{
		temp[1]=i;
		t=abpm[i];
	}
}
//out.println(temp[1]);
t=0;
for(int i=0;i<15;i++)
{
	if(abpm[i]>t && abpm[i]<abpm[temp[1]])
	{
		temp[2]=i;
		t=abpm[i];
	}
}
//out.println(temp[2]);

String[] x=leader_list[temp[0]].get(0).toString().split(",");
double lat=Double.parseDouble(x[1]);
double lon=Double.parseDouble(x[2]);
//out.println(lat);
//out.println(lon);
session.setAttribute("ldata",leader_list);
session.setAttribute("temp", temp);
%>
<center>
<script src="http://maps.google.com/maps/api/js?sensor=false" 
          type="text/javascript"></script>
<div id="map" style="width: 500px; height: 400px;"></div>
<script type="text/javascript">
    var locations = [
      [ <%=lat%>,<%=lon%>],
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
function codeLatLng() {
  var input = document.getElementById('marker').value;
  var latlngStr = input.split(',', 2);
  var lat = parseFloat(latlngStr[0]);
  var lng = parseFloat(latlngStr[1]);
  var latlng = new google.maps.LatLng(lat, lng);
  geocoder.geocode({'latLng': latlng}, function(results, status) {
    if (status == google.maps.GeocoderStatus.OK) {
      if (results[1]) {
        map.setZoom(11);
        marker = new google.maps.Marker({
            position: latlng,
            map: map
        });
        infowindow.setContent(results[1].formatted_address);
        infowindow.open(map, marker);
      } else {
        alert('No results found');
      }
    } else {
      alert('Geocoder failed due to: ' + status);
    }
  });
}

google.maps.event.addDomListener(window, 'load', initialize);
     /* google.maps.event.addListener(marker, 'click', (function(marker, i) {
        return function() {
          infowindow.setContent(locations[i][0]);
          infowindow.open(map, marker);
        }
      })(marker, i));*/
    }
  </script>
<br/><br/><br/><br/>
<input type=submit name=submit value="Get Top 3 Locations">
<center>
<%
}catch(Exception ex){
	out.println(ex);
    out.println("Unable to connect to database.");
}
%>
</form>
</body>
</html>
