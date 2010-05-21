<%@page import="recursos.*" %>
<%@page import="java.sql.*" %>

<jsp:useBean class="recursos.Ponto" id="ponto" scope="page"/>
<%
	String hora 	= request.getParameter("hora") != null ? request.getParameter("hora") : "";
	String campo	= request.getParameter("campo") != null ? request.getParameter("campo") : "";
	String usuario	= request.getParameter("usuario") != null ? request.getParameter("usuario") : "";
	String data		= request.getParameter("data") != null ? request.getParameter("data") : "";
	
	String resposta = ponto.atualizaPonto(hora, campo, usuario, data);
%>
<html>
<head>
<script language="JavaScript">
	
	var jsresposta = "<%= resposta%>";
	function iniciar() {
		if(jsresposta == "OK")
			alert("Horário alterado com sucesso!");
	}
</script>
</head>
<body onLoad="iniciar()">
</body>
</html>