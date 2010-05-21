<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.Agenda" id="agenda" scope="page"/>

<%
	String prof_reg = request.getParameter("prof_reg");
	String data = request.getParameter("data");
	String profissional = request.getParameter("nome");
	String paciente = request.getParameter("paciente");
	
%>

<html>
<head>
<title>..:Encaixe:..</title>
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
<script language="JavaScript">

	var jsprof_reg = "<%= prof_reg%>";
	
	function gravarEncaixe() {
		var pai = window.opener;
		var jsprof_reg = "<%= prof_reg%>";
		var jshora = cbeGetElementById("hora").value;
		pai.setarComoEncaixe();
		pai.agendar(jsprof_reg, jshora);
		self.close();
	}
</script>

</head>

<body>
<form name="frmcadastrar" id="frmcadastrar" action="#" method="post">
	<table border="0" cellpadding="0" cellspacing="0" width="100%" class="table">
		<tr>
		  <td width="100%" height="18" class="title">.: Encaixe :.</td>
		</tr>
		<tr style="height:25px">
			<td align="right"><span name='msg' id='msg' class="msg">&nbsp;</span></td>
		</tr>
		<tr>
			<td width="100%">
				<table cellpadding="0" cellspacing="0" width="100%" class="table">
					<tr>
						<td class="tdMedium">Profissional:</td>
						<td class="tdLight"><%= profissional%>&nbsp;</td>
					</tr>
					<tr>
						<td class="tdMedium">Paciente:</td>
						<td class="tdLight"><%= paciente%>&nbsp;</td>
					</tr>
					<tr>
						<td class="tdMedium">Data:</td>
						<td class="tdLight"><%= data%>&nbsp;</td>
					</tr>
					<tr>
						<td class="tdMedium">Hora do Encaixe:</td>
						<td class="tdLight"><input type="text" name="hora" id="hora" class="caixa" size="5" maxlength="5" onBlur="ValidaHora(this)" onKeyPress="formatar(this, event, '##:##'); "></td>
					</tr>
				</table>
			</td>
		</tr>	
		<tr>
			<td class="tdMedium" align="center"><button type="button" class="botao" style="width:150px" onClick="gravarEncaixe()"><img src="images/grava.gif" height="17">&nbsp;&nbsp;&nbsp;&nbsp;Salvar</button></td>
		</tr>
	</table>

</form>
</body>
</html>
