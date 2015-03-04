<%@page language="java" contentType="text/html"%>  
<%@ page import="java.sql.*" %> 
<%@ page import="java.io.*" %> 
<html>
<title>Operation Data</title>
<link rel="stylesheet" type="text/css" href="first.css">
<body><br><br>
<div id=wrapper>&nbsp;</div>


<center><br><br>
<h2>


Do you want to process the following data ? <br><br>
<form action="OptionsSelect.html" name=form1 method=post><input type=submit name=submit value="Go Back"></form>
<form action="Cluster.jsp" name=form2 method=post><input type=submit name=submit value="Process Data"><br/><br><br>
The following zipcodes are taken into account:</h2>

<table cellpadding="6" border="0" width="0" style="font-size:14px" >

       <TR>

          <!--TD><FONT FACE="Arial" SIZE="4"><B>Zip_Code</B></FONT></TD-->



          </FONT></TD>

       </TR>

<%
try {
    String connectionURL = "jdbc:mysql://localhost/hotdetect";
    Connection connection = null; 
    Class.forName("com.mysql.jdbc.Driver").newInstance(); 
    connection = DriverManager.getConnection(connectionURL, "root", "");


String[] position = request.getParameterValues("Areas");
 int i=0;
     for(i=0;i<position.length;i++)
     {
      //out.println(position[i]);
     }


String sql;
sql="SELECT Zip,Latitude,Longitude,Position,City from zipcode where State='NC' AND Position IN (";
int j=0;
for(j=0;j<position.length;j++)
{
if(j==position.length-1)
sql=sql+"'"+position[j]+"')";
else
sql=sql+"'"+position[j]+"',";
}

%>
<input type=hidden name=usersql value="<%=sql%>">
<%


    if(!connection.isClosed())
{
         //out.println(sql);	
	Statement s = connection.createStatement();

              ResultSet rs = s.executeQuery(sql);
	      
	      int rowcount = 0;
	      if (rs.last())
	  {
  	      rowcount = rs.getRow();
  	      rs.beforeFirst(); 
          }
		//out.println(rowcount);
              String[] zip=new String[rowcount];
	      String[] latitude=new String[rowcount];
	      String[] longitude=new String[rowcount];
		  String[] City=new String[rowcount];

	      int count=0;
		int dispcount=0;
              while (rs.next()) {
		
	     	        zip[count]=rs.getString(1);
			latitude[count]=rs.getString(2);
			longitude[count]=rs.getString(3);
            City[count]=rs.getString(5);
              
			if(dispcount==0)
			{

                        out.println("<TR>");
			}
                        

                        out.println("<TD>" + zip[count] +"-"+ City[count] + "</TD>");

                      
			dispcount++;
			if(dispcount>=6)
			{
			out.println("</TR>");
			dispcount=0;
			}
			count++;

              }

              rs.close();


              s.close();
    connection.close();
 
}
}catch(Exception ex){
	out.println(ex);
    out.println("Unable to connect to database.");
}
%>
</font-size>
</form>
</center>
</table>
</body>
</html>
