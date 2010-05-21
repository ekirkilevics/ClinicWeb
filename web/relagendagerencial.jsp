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
     //id do convênio
     var idReg = "<%= strcod%>";
	
	 function validaForm() {
		var vdata = getObj("","data");
		var vprof_reg = getObj("","prof_reg");
	
		if(vdata.value == "") {
			mensagem("Preencha a data de pesquisa", 2);
			vdata.focus();
			return false;
		}

		if(vprof_reg.value == "") {
			mensagem("Seleciona o profissional", 2);
			vprof_reg.focus();
			return false;
		}

		barrasessao();
		return true;
	 }


</script>
</head>

<body onLoad="barrasessao();">
<%@include file="barrasessao.jsp" %>
<form name="frmcadastrar" id="frmcadastrar" action="relagendagerencial2.jsp" target="_blank" method="post" onSubmit="return validaForm()">
  <table width="600" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr>
      <td height="18" class="title">.: Relatório de Log de Agenda :.</td>
    </tr>
	<tr style="height:25px">
		<td align="right"><span name='msg' id='msg' class="msg">&nbsp;</span></td>
	</tr>
    <tr align="center" valign="top">
      <td>
         <table width="300" border="0" cellpadding="0" cellspacing="0" class="table">
			<tr>
				<td class="tdMedium">Data: *</td>
				<td class="tdLight"><input type="text" name="data" id="data" class="caixa" size="12" maxlength="10" onKeyPress="return formatar(this, event, '##/##/####');" value='<%= Util.getData() %>'></td>
			</tr>
			<tr>
				<td class="tdMedium">Profissional: *</td>
				<td class="tdLight">
					<select name="prof_reg" id="prof_reg" class="caixa" style="width: 300px">
						<%= relatorio.getProfissionais(cod_empresa) %>
					</select>
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


</body>
</html>
