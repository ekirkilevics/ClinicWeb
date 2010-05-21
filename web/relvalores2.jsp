<%@include file="cabecalho.jsp" %>
<%@page import="java.util.Vector" %>

<jsp:useBean class="recursos.Relatorio" id="relatorio" scope="page"/>

<%			
	String cod_convenio = request.getParameter("cod_convenio");
%>
<html>
<head>
<title>Relatório de Valores</title>
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
</head>

<body style="background-color:white">
	<center>
		<b><pre class="texto" style="text-align:center"><%= configuracao.getItemConfig("cabecalho", cod_empresa) %></pre></b>	
	</center>
	<br>
		<%

			Vector resp = relatorio.getRelValores(cod_convenio, cod_empresa);
			for(int i=0; i<resp.size(); i++)
					out.println(resp.get(i).toString());

		%>
	<br>
</body>
</html>
