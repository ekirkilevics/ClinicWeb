<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.Historico" id="historico" scope="page"/>

<%
	if(ordem == null) ordem = "paciente.nome";
	String de  = !Util.isNull(request.getParameter("de")) ? request.getParameter("de") : Util.getData();
	String ate = !Util.isNull(request.getParameter("ate")) ? request.getParameter("ate") : Util.getData();
%>

<html>
<head>
<title>..:Buscar Históricos:..</title>
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
<script language="JavaScript">
	function escolher(codcli, nomepaciente) {
		window.opener.location = "historicopac.jsp?codcli=" + codcli + "&nome=" + nomepaciente;
	}
</script>
</head>

<body>
<form name="frmcadastrar" id="frmcadastrar" action="buscarhistoricos.jsp" method="post">
  <table width="100%" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr>
      <td width="100%" height="18" class="title">.: Buscar Históricos :.</td>
    </tr>
	<tr style="height:30px">
		<td align="right"><span name='msg' id='msg' class="msg">&nbsp;</span></td>
	</tr>
    <tr align="center" valign="top">
      <td width="100%">
		<table cellpadding="0" cellspacing="0" width="100%" class="table">
			<tr>
				<td class="tdMedium">De:</td>
				<td class="tdLight"><input type="text" name="de" id="de" class="caixa" value="<%= de%>" onKeyPress="formatar(this, event, '##/##/####'); " size="10" maxlength="10" onBlur="ValidaData(this);ValidaFuturo(this);"></td>
				<td class="tdMedium">Até:</td>
				<td class="tdLight"><input type="text" name="ate" id="ate" class="caixa" value="<%= ate%>" onKeyPress="formatar(this, event, '##/##/####'); " size="10" maxlength="10" onBlur="ValidaData(this);ValidaFuturo(this);"></td>
				<td class="tdMedium" align="center"><input type="submit" class="botao" value="Pesquisar"></td>
			</tr>
		</table>
	  </td>
    </tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
    <tr>
		<td width="100%" style="text-align:center">
			<table width="600px">
				<tr>
					<td class="tdDark"><a title="Ordenar por Nome" href="Javascript:ordenar('buscarhistoricos','paciente.nome')">Paciente</a></td>
					<td width="80" class="tdDark"><a title="Ordenar por Data" href="Javascript:ordenar('buscarhistoricos','DTACON')">Data</a></td>
					<td width="250" class="tdDark"><a title="Ordenar por Profissonal" href="Javascript:ordenar('buscarhistoricos','profissional.nome')">Profissional</a></td>
				</tr>
			</table>
			<div style="width:600; height:101; overflow: auto">
				<table width="100%">
				    <%
						String resp[] = historico.getHistoriasPorPeriodo(de, ate, ordem, numPag, 50, cod_empresa);
						out.println(resp[0]);
					%>
				</table>
			</div>
			<table width="100%">
				<tr>
					<td colspan="2" class="tdMedium" style="text-align:right"><%= resp[1]%></td>
				</tr>
			</table>
		</td>
	</tr>
  </table>
</form>

</body>
</html>
