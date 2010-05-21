<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.Agenda" id="agenda" scope="page"/>
<%
	String cod_agenda = request.getParameter("cod");
	String codcli = request.getParameter("codcli");
	String obs = request.getParameter("obs");
	String gravou = "false";
	
	if(obs != null) {
		agenda.setObs(cod_agenda, obs);
		gravou = "true";
	}
	else obs = agenda.getObs(cod_agenda);
%>

<html>
<head>
<title>Observações</title>
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
<script language="JavaScript">
	var gravou = "<%= gravou%>";
	var codcli = "<%= codcli%>";
	function iniciar() {
		if(gravou=="true") self.close();
	}
	
	function mostrarLembretes() {
		displayPopup("lembretespaciente.jsp?codcli=" + codcli, "lembretes",400,610);
	}
	
</script>
	
</head>

<body onLoad="iniciar()">
<form name="frmcadastrar" action="obs.jsp?cod=<%= cod_agenda%>" method="post">
	<input type="hidden" name="codcli" id="codcli" value="<%= codcli%>">
	<table cellpadding="0" cellspacing="0" class="table"  width="100%">
		<tr>
			<td class="tdMedium" align="center" colspan="2">Observações</td>
		</tr>
		<tr>
			<td class="tdLight" colspan="2" align="center"><textarea name="obs" id="obs" class="caixa" rows="5" style="width:100%"><%= obs%></textarea></td>
		</tr>
		<tr>
			<td class="tdMedium" align="center"><button type="submit" class="botao"><img src="images/grava.gif" width="17">&nbsp;&nbsp;&nbsp;Gravar</button></td>
            <td class="tdMedium" align="center"><button type="button" class="botao" onClick="Javascript:mostrarLembretes()"><img src="images/postit.gif" width="17">&nbsp;&nbsp;Lembretes</button></td>
		</tr>
	</table>
</form>
</body>
</html>
