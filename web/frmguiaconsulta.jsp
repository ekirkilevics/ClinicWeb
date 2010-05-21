<%
	String cod = request.getParameter("cod");
%>
<html>
<head>
<title>Guia de Consulta</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<frameset rows="40,*" frameborder="NO" border="0" framespacing="0">
  <frame src="controles.jsp" name="topFrame" scrolling="NO" noresize >
  <frame src="guiaconsultaform.jsp?cod=<%= cod%>" name="mainFrame">
</frameset>
<noframes><body>

</body></noframes>
</html>
