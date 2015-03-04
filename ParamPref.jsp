<html>
<head>
<title>Parameters Preferences</title>
<link rel="stylesheet" type="text/css" href="first.css">
</head>
<body>
<form action="PickBest.jsp"  method=post>
<br/><br/><br/>
<center>
<h2>
Please pick the parameters you want to consider for picking the best location. Assign the weights you would like to give for them as well.</h2><br/>
<br/><br/>
<table cellpadding=20px>
<th>Select</th>
<th></th><th>Weight</th><th></th><th></th>
<th>Parameter</th>
<tr>
<td><input type="checkbox" name="UserPref" value="pop" checked></td><td><input type=radio name=pwt value=Low checked>Low</td><td><input type=radio name=pwt value=Med>Med</td><td><input type=radio name=pwt value=High>High</td><td></td><td>Population</td>
</tr>
<tr>
<td><input type="checkbox" name="UserPref" value="earn"></td><td><input type=radio name=ewt value=Low checked>Low</td><td><input type=radio name=ewt value=Med >Med</td><td><input type=radio name=ewt value=High>High</td><td></td><td>Earnings</td>
</tr>
<tr>
<td><input type="checkbox" name="UserPref" value="comp"></td><td><input type=radio name=cwt value=Low checked>Low</td><td><input type=radio name=cwt value=Med >Med</td><td><input type=radio name=cwt value=High>High</td><td></td><td>Competitors</td>
</tr>
</table>
<br><input type="submit" name="submit" value="Submit"><br>
<input type=hidden name=cdata value=<%=session.getAttribute("cdata")%>
</center>
</form>
</body>

