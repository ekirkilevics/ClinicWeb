<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.Relatorio" id="relatorio" scope="page"/>


<html>
<head>
<title>Relatório de Valores</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
<script language="JavaScript" src="js/ajax.js"></script>
<script language="JavaScript">
     //id do convênio
     var idReg = "<%= strcod%>";

	 function enviarForm() {
		var frm = cbeGetElementById("frmcadastrar");
		if(frm.cod_convenio.value == "") {
			mensagem("Selecione o convênio para emitir o relatório", 2);
			return;
		}
		barrasessao();	
		frm.submit();
	 }
	 
	 function setTodos(obj) {
	 	if(obj.checked) {
			cbeGetElementById("cod_convenio").value = "todos";
			cbeGetElementById("descr_convenio").value = "Todos";
			cbeGetElementById("descr_convenio").disabled = true;
		}
		else {
			cbeGetElementById("cod_convenio").value = "";
			cbeGetElementById("descr_convenio").disabled = false;
			cbeGetElementById("descr_convenio").value = "";
		}
	 }
	 
	 function iniciar() {
		 barrasessao();
		 cbeGetElementById("descr_convenio").focus();
	 }
	 
</script>
</head>

<body onLoad="iniciar();">
<%@include file="barrasessao.jsp" %>
<%@include file="barraajax.jsp" %>
<form name="frmcadastrar" id="frmcadastrar" action="relvalores2.jsp" method="post" target="_blank">
  <table width="600" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr>
      <td height="18" class="title">.: Relatório: Valores</td>
    </tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr style="height:25px">
		<td align="right"><span name='msg' id='msg' class="msg">&nbsp;</span></td>
	</tr>
    <tr align="center" valign="top">
      <td>
         <table width="100%" border="0" cellpadding="0" cellspacing="0" class="table">
	       <tr>
              <td class="tdMedium">Convênio:</td>
              <td class="tdLight">
					<input type="hidden" name="cod_convenio" id="cod_convenio">			
					<input style="width:350" class="caixa" type="text" name="descr_convenio" id="descr_convenio" onKeyUp="busca(this.value, 'cod_convenio', 'descr_convenio','convenio','AND ativo=\'S\'')">
					&nbsp;&nbsp;&nbsp;<input type="checkbox" value="ok" onClick="setTodos(this)">Todos					
 			  </td>
            </tr>
			<tr>
				<td colspan="3" class="tdMedium" align="right"><input name="btnimprimir" id="btnimprimir" type="button" class="botao" value="Imprimir" onClick="enviarForm()"></td>
			</tr>
          </table>
		  <br>
      </td>
    </tr>
  </table>
</form>

</body>
</html>
