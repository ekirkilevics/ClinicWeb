<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.Relatorio" id="relatorio" scope="page"/>

<html>
<head>
<title>Relatório</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
<script language="JavaScript" src="js/ajax.js"></script>
<script language="JavaScript">
	
	 function validaForm() {
		var jsde = cbeGetElementById("de");
		var jsate = cbeGetElementById("ate");
		var jsmedicamento = cbeGetElementById("cod_comercial");

		if(jsde.value == "") {
			alert("Preencha data de início da pesquisa.");
			jsde.focus();
			return false;
		}

		if(jsate.value == "") {
			alert("Preencha data de fim da pesquisa.");
			jsate.focus();
			return false;
		}
		
		if(jsmedicamento.value == "") {
			alert("Escolha o medicamento a ser pesquisado");
			cbeGetElementById("comercial").focus();
			return false;
		}

		barrasessao();
		return true;
	 }
	 
	 function verHistorias(codcli) {
	 	parent.location = "historico.jsp?"
	 }
</script>
</head>

<body onLoad="barrasessao();">
<%@include file="barrasessao.jsp" %>
<%@include file="barraajax.jsp" %>
<form name="frmcadastrar" id="frmcadastrar" action="relmedicamentos2.jsp" target="iframemedicamentos" method="post" onSubmit="return validaForm()">
  <table width="600" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr>
      <td height="18" class="title">.: Pesquisa de Pacientes por Medicamentos :.</td>
    </tr>
	<tr style="height:25px">
		<td align="right"><span name='msg' id='msg' class="msg">&nbsp;</span></td>
	</tr>
    <tr align="center" valign="top">
      <td>
         <table width="400" border="0" cellpadding="0" cellspacing="0" class="table">
		 	<tr>
				
            <td height="21" colspan="5" align="center" class="tdMedium"><b>Filtros</b></td>
			</tr>
			<tr>
				<td class="tdMedium">Data Início: *</td>
				<td class="tdLight"><input type="text" name="de" id="de" class="caixa" size="12" maxlength="10" onKeyPress="return formatar(this, event, '##/##/####');" value='01/<%= Util.getMes(Util.getData()) + "/" + Util.getAno(Util.getData())%>'></td>
				<td class="tdMedium">Data Fim: *</td>
				<td class="tdLight"><input type="text" name="ate" id="ate" class="caixa" size="12" maxlength="10" onKeyPress="return formatar(this, event, '##/##/####');" value="<%= Util.getData()%>"></td>
			</tr>
			<tr>
				<td class="tdMedium">Medicamento: *</td>
                <td colspan="3" class="tdLight">
                    <input type="hidden" name="cod_comercial" id="cod_comercial">			
                    <input style="width:100%" class="caixa" type="text" name="comercial" id="comercial" onKeyUp="busca(this.value, 'cod_comercial', 'comercial','medicamentos')">
                </td>
			</tr>
			<tr>
				<td colspan="4" class="tdMedium" align="right"><button type="submit" class="botao"><img src="images/busca.gif">&nbsp;&nbsp;&nbsp;Buscar</button></td>
			</tr>
         </table>
      </td>
    </tr>
  </table>
</form>
<iframe name="iframemedicamentos" id="iframemedicamentos" width="100%" height="100%" frameborder="0" marginheight="0" marginwidth="0" src="branco.jsp"></iframe>
</body>
</html>
