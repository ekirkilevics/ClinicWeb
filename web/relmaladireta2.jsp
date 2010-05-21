<%@include file="cabecalho.jsp" %>
<%@page import="java.util.Vector" %>

<jsp:useBean class="recursos.Relatorio" id="relatorio" scope="page"/>

<%			
	String mes = request.getParameter("mes");
	String meses = request.getParameter("meses");
	String cod_convenio = request.getParameter("cod_convenio");
	String cod_diag = request.getParameter("cod_diag");
	String prof_reg = request.getParameter("prof_reg");
%>
<html>
<head>
<title>Mala Direta</title>
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
</head>

<body style="background-color:white">
		<%
			Vector resp = relatorio.getEtiquetas(mes, meses, cod_convenio, cod_diag, prof_reg, cod_empresa);
			for(int i=0; i<resp.size(); i++)
					out.println(resp.get(i).toString());

		%>
	<br>
</body>
</html>
