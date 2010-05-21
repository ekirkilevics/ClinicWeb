<%
	String cod = request.getParameter("cod");
	String outrasdespesas = request.getParameter("outrasdespesas");
%>
<html>
<head>
<title>Guia de SP/SADT</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<frameset rows="40,*" frameborder="NO" border="0" framespacing="0">
  <frame src="controles.jsp" name="topFrame" scrolling="NO" noresize >
  <frame src="guiaspsadtform.jsp?cod=<%= cod%>&outrasdespesas=<%=outrasdespesas %>" name="mainFrame">
</frameset>
<noframes><body>

</body></noframes>
</html>
