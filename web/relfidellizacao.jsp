<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.Relatorio" id="relatorio" scope="page"/>

<html>
<head>
<title>Relatório</title>
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
		var jqtde = getObj("","qtde");
	
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
		
		if(jqtde.value=="" || jqtde.value=="0") {
			alert("Quantidade deve ser maior ou igual a 1");
			jqtde.focus();
			return false;
		}

		barrasessao();
		return true;
	 }

</script>
</head>

<body onLoad="barrasessao();">
<%@include file="barrasessao.jsp" %>
<form name="frmcadastrar" id="frmcadastrar" action="relfidellizacao2.jsp" target="_blank" method="post" onSubmit="return validaForm()">
  <table width="600" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr>
      <td height="18" class="title">.: Relatório: Fidelização :.</td>
    </tr>
	<tr style="height:25px">
		<td align="right"><span name='msg' id='msg' class="msg">&nbsp;</span></td>
	</tr>
    <tr align="center" valign="top">
      <td>
         <table width="300" border="0" cellpadding="0" cellspacing="0" class="table">
		 	<tr>
				
            <td height="21" colspan="5" align="center" class="tdMedium"><b>Filtros</b></td>
			</tr>
			<tr>
				<td class="tdMedium">Data Início</td>
				<td class="tdLight"><input type="text" name="de" id="de" class="caixa" size="12" maxlength="10" onKeyPress="return formatar(this, event, '##/##/####');"></td>
				<td class="tdMedium">Data Fim</td>
				<td class="tdLight"><input type="text" name="ate" id="ate" class="caixa" size="12" maxlength="10" onKeyPress="return formatar(this, event, '##/##/####');"></td>
			</tr>
			<tr>
				<td class="tdMedium">Grupo de Procedimento:</td>
				<td colspan="3" class="tdLight">
					<select name="grupoproced" id="grupoproced" class="caixa">
						<option value="todos"><-- Todos --></option>
						<%= relatorio.getGruposProcecimentos(cod_empresa)%>
					</select>
				</td>
			</tr>
			<tr>
				<td class="tdMedium">Frequência:</td>
				<td colspan="3" class="tdLight"><input type="text" class="caixa" name="qtde" id="qtde" maxlength="4" size="5"> procedimentos</td>
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
