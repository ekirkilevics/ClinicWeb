<%@include file="cabecalho.jsp" %>
<%@page import="java.util.Vector" %>

<jsp:useBean class="recursos.Vacina" id="vacina" scope="page"/>

<%			
	String de  = request.getParameter("de");
	String ate = request.getParameter("ate");
		
%>
<html>
<head>
<title>Relatório de Resumo de Faturas em Vacinas </title>
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
</head>

<body style="background-color:white">
	<center>
	<b><pre class="texto" style="text-align:center"><%= configuracao.getItemConfig("cabecalho", cod_empresa) %></pre></b>
	<br>
	<div class="texto"><b>Relatório de Resumo de Faturas em Vacinas </b><br>Período de <%= de%> até <%= ate%></div>	
	<br>
	<table width="98%" border="0" cellpadding="0" cellspacing="0" style="background-color:white;border: 0px; border-top: 1px solid #CCCCCC;	border-left: 1px solid #CCCCCC;">
	<%
		if(de != null && ate != null) {
			out.println(vacina.getRelFechamentoPeriodo(de, ate, cod_empresa));
		}
	%>
	</table>
	<br>
	</center>
</body>
</html>
