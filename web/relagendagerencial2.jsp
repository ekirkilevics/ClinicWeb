<%@include file="cabecalho.jsp" %>
<%@page import="java.util.Vector" %>

<jsp:useBean class="recursos.Relatorio" id="relatorio" scope="page"/>

<%			
	String data  = request.getParameter("data");
	String prof_reg = request.getParameter("prof_reg");
	String medico = banco.getValor("nome", "SELECT nome FROM profissional WHERE prof_reg='" + prof_reg + "'");
	
	if(Util.isNull(ordem)) ordem = "hora";
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
	<div class="texto"><b><font size="+2"><%= medico %><br><%= Util.getDiaSemana(data) + " " + data %></font></b></div>	
	<br>
	<form name="frmcadastrar" id="frmcadastrar" method="post" action="relagenda2.jsp">
		<!-- Campos Ocultos -->
		<input type="hidden" name="data" value="<%= data%>">
		<input type="hidden" name="prof_reg" value="<%= prof_reg%>">
		
	<table width="98%" border="0" cellpadding="0" cellspacing="0" style="background-color:white;border: 0px; border-top: 1px solid #CCCCCC;	border-left: 1px solid #CCCCCC;">
	<%
		if(data != null && prof_reg != null) {
			Vector resp = relatorio.getLogAgendas(data, prof_reg, ordem);
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
