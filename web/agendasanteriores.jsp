<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.Agenda" id="agenda" scope="page"/>
<%
	//Paciente
	String codcli = request.getParameter("codcli");

	//Pegar as últimas 5 consultas
	String agendasanteriores = agenda.getAgendasAnteriores(codcli, Util.formataDataInvertida(Util.getData()), "");
%>

<html>
<head>
<title>Agendas Anteriores</title>
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
	
</head>

<body>
<center>
<br>
<table border="0" cellpadding="0" cellspacing="0" width="95%" class="table">
	<tr>
    	<td class="tdMedium" align="center">Agendas Anteriores</td>
    </tr>
	<tr>
    	<td class="tdLight"><%= agendasanteriores%></td>
    </tr>	
</table>
</center>
</body>
</html>
