<%@include file="cabecalho.jsp" %>
<%@page import="java.util.Vector" %>

<jsp:useBean class="recursos.Vacina" id="vacina" scope="page"/>

<%			
	String de  = request.getParameter("de");
	String ate = request.getParameter("ate");
	String codcli = request.getParameter("codcli");
	String cod_vacina = request.getParameter("cod_vacina");
	String cod_laboratorio = request.getParameter("cod_laboratorio");
%>
<html>
<head>
<title>Relat�rio de Aplica&ccedil;&atilde;o de Vacinas</title>
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
</head>

<body style="background-color:white">
	<form name="frmcadastrar" id="frmcadastrar" action="relvacinas2.jsp" method="post">
	<!-- Campos ocultos -->
	<input type="hidden" name="codcli" value="<%= codcli%>">
	<input type="hidden" name="de" value="<%= de%>">
	<input type="hidden" name="ate" value="<%= ate%>">
	<input type="hidden" name="cod_vacina" value="<%= cod_vacina%>">
	<input type="hidden" name="cod_laboratorio" value="<%= cod_laboratorio%>">
	<center>
	<b><pre class="texto" style="text-align:center"><%= configuracao.getItemConfig("cabecalho", cod_empresa) %></pre></b>
	<br>
	<div class="texto"><b>Relat�rio de Aplica&ccedil;&atilde;o de Vacinas</b><br>Per�odo de <%= de%> at� <%= ate%></div>	
	<br>
	<table width="98%" border="0" cellpadding="0" cellspacing="0" style="background-color:white;border: 0px; border-top: 1px solid #CCCCCC;	border-left: 1px solid #CCCCCC;">
	<%
		if(de != null && ate != null) {
			Vector resp = vacina.getRelAplicVacinas(de, ate, codcli, cod_vacina, cod_laboratorio, ordem);
			for(int i=0; i<resp.size(); i++)
				out.println(resp.get(i).toString());
		}
	%>
	</table>
	<br>
	</center>
	</form>
</body>
</html>
