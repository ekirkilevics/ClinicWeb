<%@include file="cabecalho.jsp" %>
<%@page import="java.util.Vector" %>

<jsp:useBean class="recursos.Vacina" id="vacina" scope="page"/>

<%			
	String de  = request.getParameter("de");
	String ate  = request.getParameter("ate");
	String unidade = request.getParameter("unidade");
	String cod_vacina = request.getParameter("cod_vacina");
	String cod_laboratorio = request.getParameter("cod_laboratorio");
	String lote = request.getParameter("lote");
		
%>
<html>
<head>
<title>Relat�rio de Vacinas</title>
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
</head>

<body style="background-color:white">
	<form name="frmcadastrar" id="frmcadastrar" action="relsaidavacinas2.jsp" method="post">
	<!-- Campos ocultos -->
	<input type="hidden" name="de" value="<%= de%>">
    	<input type="hidden" name="ate" value="<%= ate%>">
	<input type="hidden" name="unidade" value="<%= unidade%>">
	<input type="hidden" name="cod_vacina" value="<%= cod_vacina%>">
	<input type="hidden" name="cod_laboratorio" value="<%= cod_laboratorio%>">
	<input type="hidden" name="lote" value="<%= lote%>">
	<center>
	<b><pre class="texto" style="text-align:center"><%= configuracao.getItemConfig("cabecalho", cod_empresa) %></pre></b>
	<br>
	<div class="texto"><b>Relat�rio de Sa&iacute;da de Vacinas</b><br>Per�odo de <%= de%> at� <%= ate%></div>	
	<br>
	<table width="98%" border="0" cellpadding="0" cellspacing="0" style="background-color:white;border: 0px; border-top: 1px solid #CCCCCC;	border-left: 1px solid #CCCCCC;">
	<%
		if(de != null && ate != null) {
			Vector resp = vacina.getRelSaidaVacinas(de, ate, unidade, cod_vacina, cod_laboratorio, lote, ordem);
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
