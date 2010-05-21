<%@include file="cabecalho.jsp" %>
<%@page import="java.util.Vector" %>

<jsp:useBean class="recursos.Lote" id="lote" scope="page"/>

<%			
	String lotes  = request.getParameter("lotes");
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
    <center>
	<%
		if(!Util.isNull(lotes)) {
			Vector resp = lote.getGuiasLote(lotes);
			for(int i=0; i<resp.size(); i++)
				out.println(resp.get(i).toString());
		}
	%>
    </center>
	<br>
</body>
</html>
