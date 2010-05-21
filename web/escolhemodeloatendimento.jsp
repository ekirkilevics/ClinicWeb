<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.Modelos" id="modelo" scope="page"/>
<%
	String codatend = request.getParameter("codatend");
%>

<html>
<head>
<title>..:: Modelo ::..</title>
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
<script language="JavaScript">
	function abrirmodelo() {
		var frm = cbeGetElementById("frmcadastrar");
		if(frm.modelos.value == "") {
			alert("Selecione o modelo a imprimir");
			frm.modelos.focus();
			return;
		}
		frm.submit();
	}
</script>
</head>

<body style="background-color: white" onLoad="iniciar()">
<form name="frmcadastrar" id="frmcadastrar" action="abremodeloatendimento.jsp?codatend=<%= codatend%>" method="post">
	<br>
	<table width="100%" cellpadding="0" cellspacing="0" class="table">
		<tr>
			<td colspan="3" class="tdDark" align="center">Selecione o modelo a imprimir</td>
		</tr>
		<tr>
			<td class="tdMedium">Modelo:</td>
			<td class="tdLight">
				<select name="modelos" id="modelos" class="caixa">
					<option value=""></option>
					<%= modelo.getModelos(cod_empresa)%>
				</select>
			</td>
			<td class="tdMedium"><input type="button" class="botao" value="OK" onClick="abrirmodelo()"></td>
		</tr>
	</table>
</form>
</body>
</html>
