<%@include file="cabecalho.jsp" %>
<%@page import="java.util.Vector" %>

<jsp:useBean class="recursos.Relatorio" id="relatorio" scope="page"/>

<%			
	String de  = request.getParameter("de");
	String ate = request.getParameter("ate");
	String paciente = request.getParameter("paciente");
	String prof_reg = request.getParameter("prof_reg");
	String cod_convenio = request.getParameter("cod_convenio");
	String status = request.getParameter("status");
	String mes = request.getParameter("mes");
	int tipomatch = Integer.parseInt(request.getParameter("tipo"));
	
		
%>
<html>
<head>
<title>Relatório de Pacientes</title>
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
</head>

<body style="background-color:white">
	<center>
	<b><pre class="texto" style="text-align:center"><%= configuracao.getItemConfig("cabecalho", cod_empresa) %></pre></b>
	<br>
	<div class="texto">
		<b>
			Relatório de Pacientes<br>
		</b>
	</div>
	<br>
	<table width="98%" border="0" cellpadding="0" cellspacing="0" style="background-color:white;border: 0px;">
	<%
		Vector resp = relatorio.getPacientes(de, ate, paciente, tipomatch, prof_reg, status, cod_convenio, mes, cod_empresa);
		for(int i=0; i<resp.size(); i++)
			out.println(resp.get(i).toString());
	%>
	</table>
	<br>
	</center>
</body>
</html>
