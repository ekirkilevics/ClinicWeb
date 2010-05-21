<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.Lote" id="lote" scope="page"/>

<html>
<head>
<title>Relatório</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
<script language="javascript">
	function gerarLista() {
		var frm = cbeGetElementById("frmcadastrar");
		
		if(frm.lotes.value == "") {
			alert("Seleciona pelo menos 1 lote para exibir o relatório");
			return;
		}
		frm.submit();
	}
</script>	
</head>

<body onLoad="barrasessao();">
<%@include file="barrasessao.jsp" %>
<form name="frmcadastrar" id="frmcadastrar" action="rellotefinanceiro2.jsp" method="post" target="_blank">
  <table width="600" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr>
      <td height="18" class="title">.: Relatório Financeiro de Lote :.</td>
    </tr>
	<tr style="height:25px">
		<td align="right"><span name='msg' id='msg' class="msg">&nbsp;</span></td>
	</tr>
    <tr align="center" valign="top">
      <td>
         <table width="400" border="0" cellpadding="0" cellspacing="0" class="table">
			<tr>
				<td class="tdMedium" width="180">Lotes: (ex. 34,35,37,40)</td>
				<td class="tdLight">
					<input type="text" name="lotes" id="lotes" class="caixa" size="30" maxlength="50">
				</td>
			</tr>
			<tr>
				<td colspan="2" class="tdMedium" align="center"><button type="button" class="botao" onClick="Javascript:gerarLista()"><img src="images/print.gif">&nbsp;&nbsp;&nbsp;Gerar Relatório</button></td>
			</tr>
         </table>
      </td>
    </tr>
  </table>
</form>

</body>
</html>
