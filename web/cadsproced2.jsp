<%@include file="cabecalho.jsp" %>
<%@page import="java.util.Vector" %>

<jsp:useBean class="recursos.Relatorio" id="relatorio" scope="page"/>

<%			
	String de = request.getParameter("de");
	String ate = request.getParameter("ate");
%>
<html>
<head>
<title>Consistências: Cadastro sem Procedimento</title>
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
</head>

<body style="background-color:white">
	<center>
	<b><pre class="texto" style="text-align:center"><%= configuracao.getItemConfig("cabecalho", cod_empresa) %></pre></b>	<br>
	<div class="texto"><b>Relatório de Inconsistências<br><br>
		Cadastro sem Procedimento<br></b><br>
		Período de <%= de%> até <%= ate%></div>	
</center>
	<br>
		<%
			Vector resp = relatorio.getPacientesSemLancamento(de, ate, cod_empresa);
			for(int i=0; i<resp.size(); i++)
					out.println(resp.get(i).toString());
		%>
	<br>
</body>
</html>
