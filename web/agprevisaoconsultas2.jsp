<%@include file="cabecalho.jsp" %>
<%@page import="java.util.Vector" %>

<jsp:useBean class="recursos.Cliente53" id="cliente53" scope="page"/>

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

<body>
	<center>
	<br>
	<table width="600" border="0" cellpadding="0" cellspacing="0" class="table">
	<%
		if(mes != null && ano != null) {
			Vector resp = cliente53.getRelPrevisaoAgenda(mes, ano, prof_reg);
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
