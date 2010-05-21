<%@include file="cabecalho.jsp" %>
<%@page import="java.util.Vector" %>

<jsp:useBean class="recursos.Relatorio" id="relatorio" scope="page"/>

<%			
	String n_lote  = request.getParameter("lote");
	String tiporel = request.getParameter("tiporel");
%>
<html>
<head>
<title>Lista do Lote</title>
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
</head>

<body style="background-color:white">
	<br>
	<%
		if(!Util.isNull(n_lote)) {
			Vector resp = relatorio.getListagemLote(n_lote, tiporel);
			for(int i=0; i<resp.size(); i++)
				out.println(resp.get(i).toString());
		}
	%>
	<br>
<%@include file="tamanhofontes.jsp" %>    
</body>
</html>
