<%@include file="cabecalho.jsp" %>
<%@page import="java.util.Vector" %>

<jsp:useBean class="recursos.Atendimento" id="atendimento" scope="page"/>
<%
	String de = request.getParameter("de");
	String ate = request.getParameter("ate");
	String procedente[] = request.getParameterValues("procedente");
	String encaminhado[] = request.getParameterValues("encaminhado");
	String hora1 = request.getParameter("hora1");
	String hora2 = request.getParameter("hora2");
	String codcli = request.getParameter("codcli");
%>

<html>
<head>
<title>Relatório</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
<script language="JavaScript" src="js/ajax.js"></script>

</head>

<body>
      <div class="title">.: Relatório de Atendimentos :.</div>
		<center>
	  	<table cellpadding="0" cellspacing="0" width="100%">
		<%
			Vector resp = atendimento.getRelAtendimentos(de, ate, procedente, encaminhado, hora1, hora2, codcli);
			for(int i=0; i<resp.size(); i++)
				out.println(resp.get(i).toString());
		%>
		</table>
		</center>
</body>
</html>
