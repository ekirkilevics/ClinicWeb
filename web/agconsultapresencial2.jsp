<%@include file="cabecalho.jsp" %>
<%@page import="java.util.Vector" %>

<jsp:useBean class="recursos.Cliente68" id="cliente68" scope="page"/>

<%			
	String mes  = request.getParameter("mes");
	String ano = request.getParameter("ano");
	String prof_reg = request.getParameter("prof_reg");
%>
<html>
<head>
<title>Relatório de Agenda</title>
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
</head>

<body style="background-color:white">
	<center>
	<b><pre class="texto" style="text-align:center"><%= configuracao.getItemConfig("cabecalho", cod_empresa) %></pre></b>
	<br>
    <div class="texto">Relatório para Agendamento Presencial <%= mes%> / <%= ano%></div><br>
	<table width="98%" border="0" cellpadding="0" cellspacing="0" style="background-color:white;border: 0px; border-top: 1px solid #CCCCCC;	border-left: 1px solid #CCCCCC;">
	<%
		if(mes != null && ano != null) {
			Vector resp = cliente68.getPacientesAgendaPresencial(mes, ano, prof_reg);
			for(int i=0; i<resp.size(); i++)
				out.println(resp.get(i).toString());
		}
	%>
	</table>
	</form>
	<br>
	</center>
</body>
</html>
