<%@include file="cabecalho.jsp" %>
<%@page import="java.util.Vector" %>

<jsp:useBean class="recursos.Vacina" id="vacina" scope="page"/>

<%			
	String de  = request.getParameter("de");
%>
<html>
<head>
<title>Relatório de Controle Diário</title>
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
</head>

<body style="background-color:white">
	<form name="frmcadastrar" id="frmcadastrar" action="relcontrolediario2.jsp" method="post">
	<!-- Campos ocultos -->
	<input type="hidden" name="de" value="<%= de%>">
	<center>
	<b><pre class="texto" style="text-align:center"><%= configuracao.getItemConfig("cabecalho", cod_empresa) %></pre></b>
	<br>
	<div class="texto"><b>Relatório de Controle Diário</b> - Data: <%= de%></div>	
	<br>
	<table width="98%" border="0" cellpadding="0" cellspacing="0">
	<%
		if(de != null) {
			Vector resp = vacina.getRelControleDiario(de, ordem);
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
