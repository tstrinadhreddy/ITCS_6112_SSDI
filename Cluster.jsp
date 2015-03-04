<%@page language="java" contentType="text/html"%>  
<%@ page import="java.sql.*" %> 
<%@ page import="java.io.*" %> 
<%@ page import="java.util.ArrayList" %> 
<%@ page import="java.util.Random" %> 
<html>
<title>Kmeans Clustering</title>
<body>
<form action="ParamPref.jsp" method=post>
<%
try{
    String connectionURL = "jdbc:mysql://localhost/hotdetect";
    Connection connection = null; 
    Class.forName("com.mysql.jdbc.Driver").newInstance(); 
    connection = DriverManager.getConnection(connectionURL, "root", "");


String[] sql = request.getParameterValues("usersql");
 out.println(sql[0]);

if(!connection.isClosed())
{
         //out.println("Successfully connected to " + "MySQL server using TCP/IP...");	
	Statement s = connection.createStatement();

              ResultSet rs = s.executeQuery(sql[0]);
	      
	      int rowcount = 0;
	      if (rs.last())
	  {
  	      rowcount = rs.getRow();
  	      rs.beforeFirst(); 
          }
		out.println(rowcount);
              ArrayList<String> zip=new ArrayList<String>();
	      //ArrayList lat=new ArrayList();
	      //ArrayList lon=new ArrayList();
	      int count=0;
              while (rs.next()) {
		
	     	        //zip[count]=rs.getString(1);
			//latitude[count]=rs.getString(2);
			//longitude[count]=rs.getString(3);
			String temp=rs.getString(1)+","+rs.getString(2)+","+rs.getString(3);
			zip.add(temp);
			
              }
		Random rand = new Random();
		ArrayList[] leader_list = new ArrayList[15];
		for(int i=0;i<15;i++)
		{
		leader_list[i]=new ArrayList<String>();
		}
		
		for(int i=0;i<15;i++)
		{
			 int randomNum = rand.nextInt(rowcount-i);
			 leader_list[i].add(zip.get(randomNum));
		   	 zip.remove(randomNum);
		//out.println(leader_list[i].get(0));
		}

				//out.println(leader_list[0].get(0));
		for(int h=0;h<7;h++){
		for(int i=0;i<zip.size();i++)
		{
			double tempdist=25000;
			int tempj=0;
			for(int j=0;j<15;j++)
			{
				String[] ziptoks1=zip.get(i).toString().split(",");
				String[] ziptoks2=leader_list[j].get(0).toString().split(",");
				
				double distance = haversine(Double.parseDouble(ziptoks1[1]), Double.parseDouble(ziptoks1[2]),
						Double.parseDouble(ziptoks2[1]), Double.parseDouble(ziptoks2[2]));
				if(distance<tempdist)
				{
					tempj=j;
					//out.println(tempj);
					tempdist=distance;
				}
			}
			leader_list[tempj].add(zip.get(i));
			//out.println(tempdist);
		
			//calculateCenter();
//////////////////////////////////////////////////////////////////////////////////////////////


     /*  for (int p = 0; p< 15; p++) 
	{*/
		double slat=0;
		double slon=0;
		String x="";
		for(int q=0;q<leader_list[tempj].size();q++) 
			{
			String[] xziptoks=leader_list[tempj].get(q).toString().split(","); 
			//out.println("Splited !");                      
			slat=slat+Double.parseDouble(xziptoks[1]);
			//out.println("xxxxxxxxxxxxx");
			slon=slon+Double.parseDouble(xziptoks[2]);   
			//out.println("xxkjsadskl");                     
                        }
		//out.println(slat);
		//out.println(slon);
		String[] uziptoks=leader_list[tempj].get(0).toString().split(",");
		x=x+uziptoks[0];
		double alat=slat/leader_list[tempj].size();
		double alon=slon/leader_list[tempj].size();
               	x=x+","+alat+","+alon;
		//out.println(x+"\n");
                leader_list[tempj].set(0,x);
       // }

/////////////////////////////////////////////////////////////////////////////////////////////
		}}
session.setAttribute("cdata",leader_list);
              rs.close();


              s.close();
    connection.close();
 
}
}catch(Exception ex){
	out.println(ex);
    out.println("Unable to connect to database.");
}
%>
The data is clustered!<input type=submit name-=submit value=submit>
<% response.sendRedirect("/Sample/ParamPref.jsp");%>
<%!
public static double haversine(double lat1, double lon1, double lat2, double lon2) {
        double dLat = Math.toRadians(lat2 - lat1);
        double dLon = Math.toRadians(lon2 - lon1);
        lat1 = Math.toRadians(lat1);
        lat2 = Math.toRadians(lat2);
 
        double a = Math.sin(dLat / 2) * Math.sin(dLat / 2) + Math.sin(dLon / 2) * Math.sin(dLon / 2) * Math.cos(lat1) * Math.cos(lat2);
        double c = 2 * Math.asin(Math.sqrt(a));
        return 6372.8 * c;
    }
%>
</form>
</body>
</html>
