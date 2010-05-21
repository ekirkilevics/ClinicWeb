<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.Atendimento" id="atendimento" scope="page"/>


<html>
<head>
<title>Relatório</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
<script language="JavaScript" src="js/ajax.js"></script>
<script language="JavaScript">
     //id do convênio
     var idReg = "<%= strcod%>";
	
	 function validaForm() {
		var vde = getObj("","de");
		var vate = getObj("","ate");
		var vhora1 = getObj("","hora1");
		var vhora2 = getObj("","hora2");
		var vprocedente = getObj("", "procedente");
	
		if(vde.value == "") {
			mensagem("Preencha data de início da pesquisa.", 2);
			vde.focus();
			return false;
		}

		if(vate.value == "") {
			mensagem("Preencha data de fim da pesquisa.", 2);
			vate.focus();
			return false;
		}
		
		achou = false;
		for(var j=0; j<vprocedente.length; j++) {
			if(vprocedente.options[j].selected == true)
				achou = true;
		}

		if(!achou) {
			mensagem("Escolha pelo menos um item dos procedentes", 2);
			vprocedente.focus();
			return false;
		}

		if(vhora1.value == "") {
			mensagem("Preencha o intervalo de horas a ser filtrado.", 2);
			vhora1.focus();
			return false;
		}

		if(vhora2.value == "") {
			mensagem("Preencha o intervalo de horas a ser filtrado.", 2);
			vhora2.focus();
			return false;
		}

		barrasessao();
		return true;
	 }


</script>
</head>

<body onLoad="barrasessao();hideAll();">
<%@include file="barrasessao.jsp" %>
<%@include file="barraajax.jsp" %>
<form name="frmcadastrar" id="frmcadastrar" action="relentradasaidaanalitico2.jsp" target="_blank" method="post" onSubmit="return validaForm()">
  <table width="600" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr>
      <td height="18" class="title">.: Relatório de Atendimentos Analítico :.</td>
    </tr>
	<tr style="height:25px">
		<td align="right"><span name='msg' id='msg' class="msg">&nbsp;</span></td>
	</tr>
    <tr align="center" valign="top">
      <td>
         <table width="300" border="0" cellpadding="0" cellspacing="0" class="table">
		 	<tr>
	            <td height="21" colspan="5" align="center" class="tdMedium"><b>Período</b></td>
			</tr>
			<tr>
				<td class="tdMedium">Data Início</td>
				<td class="tdLight"><input type="text" name="de" id="de" class="caixa" size="12" maxlength="10" onKeyPress="return formatar(this, event, '##/##/####');" value='01/<%= Util.getMes(Util.getData()) + "/" + Util.getAno(Util.getData())%>'></td>
				<td class="tdMedium">Data Fim</td>
				<td class="tdLight"><input type="text" name="ate" id="ate" class="caixa" size="12" maxlength="10" onKeyPress="return formatar(this, event, '##/##/####');" value="<%= Util.getData()%>"></td>
			</tr>
			<tr>
				<td colspan="4" class="tdMedium" align="right"><input type="submit" class="botao" value="Buscar"></td>
			</tr>
         </table>
        </td>
    </tr>
  </table>
</form>

</body>
</html>
