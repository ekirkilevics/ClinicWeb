<%@include file="cabecalho.jsp" %>

<html>
<head>
<title>Faturamento</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
<script language="JavaScript">
     //id do convênio
     var idReg = "<%= strcod%>";
	
	 function validaForm() {
		var vde = getObj("","de");
		var vate = getObj("","ate");
	
		if(vde.value == "") {
			alert("Preencha data de início da pesquisa.");
			vde.focus();
			return false;
		}

		if(vate.value == "") {
			alert("Preencha data de fim da pesquisa.");
			vate.focus();
			return false;
		}

		barrasessao();
		return true;
	 }

</script>
</head>

<body onLoad="barrasessao();">
<%@include file="barrasessao.jsp" %>
<form name="frmcadastrar" id="frmcadastrar" action="relpagamentos2.jsp" method="post" target="_blank" onSubmit="return validaForm()">
  <table width="600" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr>
      <td height="18" class="title">.: Relatório: Recebimentos de Particulares :.</td>
    </tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr style="height:25px">
		<td align="right"><span name='msg' id='msg' class="msg">&nbsp;</span></td>
	</tr>
    <tr align="center" valign="top">
      <td>
         <table width="300" border="0" cellpadding="0" cellspacing="0" class="table">
		 	<tr>
				<td colspan="5" class="tdMedium" align="center"><b>Filtros</b></td>
			</tr>
			<tr>
				<td class="tdMedium">Data Início</td>
				<td class="tdLight"><input type="text" name="de" id="de" class="caixa" size="12" maxlength="10" onKeyPress="return formatar(this, event, '##/##/####');" value='01/<%= Util.getMes(Util.getData()) + "/" + Util.getAno(Util.getData())%>'></td>
				<td class="tdMedium">Data Fim</td>
				<td class="tdLight"><input type="text" name="ate" id="ate" class="caixa" size="12" maxlength="10" onKeyPress="return formatar(this, event, '##/##/####');" value="<%= Util.getData()%>"></td>
			</tr>
			<tr>
				<td class="tdMedium">Tipo Pagto</td>
				<td class="tdLight" colspan="3">
					<select name="tipopagto" id="tipopagto" class="caixa">
						<option value="todos">Todos</option>
						<option value="1">Dinheiro</option>
						<option value="2">Cheque</option>
						<option value="3">Cartão</option>
					</select>
				</td>
			</tr>
			<tr>
				<td class="tdMedium">Nº do cheque</td>
				<td class="tdLight" colspan="3"><input type="text" name="cheque" id="cheque" class="caixa"></td>
			</tr>
			<tr>
				<td colspan="4" class="tdMedium" align="right"><button type="submit" class="botao"><img src="images/print.gif">&nbsp;&nbsp;&nbsp;Imprimir</button></td>
			</tr>
         </table>
      </td>
    </tr>
  </table>
</form>

</body>
</html>
