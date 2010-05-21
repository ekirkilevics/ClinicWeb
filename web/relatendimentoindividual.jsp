<%@include file="cabecalho.jsp" %>
<%@page import="java.util.Vector" %>

<jsp:useBean class="recursos.Relatorio" id="relatorio" scope="page"/>

<%			
	String de  = request.getParameter("de");
	String ate = request.getParameter("ate");
	String prof_reg = request.getParameter("executante");

%>
<html>
<head>
<title>Lançamentos Financeiros</title>
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
</head>

<body style="background-color:white">
	<center>
	<b><pre class="texto" style="text-align:center"><%= configuracao.getItemConfig("cabecalho", cod_empresa) %></pre></b>
	<br>
	<div class="texto"><b>Relatório de Atendimento Individual</b><br>Período de <%= de%> até <%= ate%></div>	
	<br>
	<table width="98%" border="0" cellpadding="0" cellspacing="0" style="background-color:white;border: 0px; border-top: 1px solid #CCCCCC;	border-left: 1px solid #CCCCCC;">
	<%
		if(de != null && ate != null) {
			Vector resp = relatorio.getAtendimentosIndividual(de, ate, prof_reg);
			for(int i=0; i<resp.size(); i++)
				out.println(resp.get(i).toString());
		}
	%>
	</table>
	<br>
	</center>
</body>
</html>
