<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.Vacina" id="vacina" scope="page"/>
<jsp:useBean class="recursos.Estoque" id="estoque" scope="page"/>

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
<%@include file="barraajax.jsp" %>
<form name="frmcadastrar" id="frmcadastrar" action="relsaidavacinas2.jsp" target="_blank" method="post" onSubmit="return validaForm()">
  <table width="600" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr>
      <td height="18" class="title">.: Relatório de Sa&iacute;da de Vacinas :.</td>
    </tr>
	<tr style="height:25px">
		<td align="right"><span name='msg' id='msg' class="msg">&nbsp;</span></td>
	</tr>
    <tr align="center" valign="top">
      <td>
         <table width="368" border="0" cellpadding="0" cellspacing="0" class="table">
		 	<tr>
	            <td height="21" colspan="5" align="center" class="tdMedium"><b>Filtros</b></td>
			</tr>
			<tr>
				<td width="82" class="tdMedium">Data in&iacute;cio: </td>
			  <td width="105" class="tdLight"><input type="text" name="de" id="de" class="caixa" size="12" maxlength="10" onKeyPress="return formatar(this, event, '##/##/####');" value='01/<%= Util.getMes(Util.getData()) + "/" + Util.getAno(Util.getData())%>'>
			    <input name="ordem" type="hidden" id="ordem" value="vac_saidas.data"></td>
		      <td width="83" class="tdMedium">Data Fim:</td>
		      <td width="97" class="tdLight"><input type="text" name="ate" id="ate" class="caixa" size="12" maxlength="10" onKeyPress="return formatar(this, event, '##/##/####');" value="<%= Util.getData()%>"></td>
			</tr>
			<tr>
				<td class="tdMedium">Unidade: </td>
				<td colspan="3" class="tdLight">
					<select name="unidade" id="unidade" class="caixa" ><option value=""> </option>
                  <%= vacina.getTodasUnidades()+"<option value='Doses Perdidas'> Doses Perdidas </option>"%>
                </select>				</td>
			</tr><tr>
				<td class="tdMedium">Vacina: </td>
				<td colspan="3" class="tdLight">
					<select name="cod_vacina" id="cod_vacina" class="caixa" style="width:95%">
						<option value=""></option>
						<%= vacina.getVacinas(cod_empresa) %>
					</select>
				</td>
			</tr>
			<tr>
				<td class="tdMedium">Laboratório: </td>
				<td colspan="3" class="tdLight">
					<select name="cod_laboratorio" id="cod_laborarorio" class="caixa" style="width:95%">
						<option value=""></option>
						<%= estoque.getLaboratorios(cod_empresa)%>
					</select>
				</td>
			</tr>
			<tr>
				<td class="tdMedium">Lote: </td>
				<td colspan="3" class="tdLight">
					<input type="text" class="caixa" name="lote" id="lote" size="10">
				</td>
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
