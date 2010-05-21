<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.Vacina" id="vacina" scope="page"/>

<%
	if(strcod != null) rs = banco.getRegistro("vac_consumos","cod_consumo", Integer.parseInt(strcod) );
	if(Util.isNull(ordem)) ordem = "data DESC";
%>

<html>
<head>
<title>Material de Consumo</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
<script language="JavaScript">
     //id
     var idReg = "<%= strcod%>";
	 //Informação vinda de gravar
	 var inf = "<%= inf%>";
	 //Nome dos campos
	 var nome_campos_obrigatorios = Array("Descrição", "Data", "Valor");
	 //Página a enviar o formulário
	 var page = "gravarconsumo.jsp";
     //Campos obrigatórios
	 var campos_obrigatorios = Array("descricao", "data", "valor");

	function clickBotaoNovo() {
		botaoNovo();
	}
	
	function clickBotaoSalvar() {
		enviarAcao('inc');
	}
	
	function clickBotaoExcluir() {
		enviarAcao('exc');
	}
</script>
</head>

<body onLoad="inicio();barrasessao();">
<%@include file="barrasessao.jsp" %>
<form name="frmcadastrar" id="frmcadastrar" action="gravarconsumo.jsp" method="post">
  <table width="600" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr>
      <td width="651" height="18" class="title">.: Materiais de Consumo :.</td>
    </tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td align="right"><span name='msg' id='msg' class="msg">&nbsp;</span></td>
	</tr>
    <tr align="center" valign="top">
      <td>
          <table width="100%" border="0" cellpadding="0" cellspacing="0" class="table">
            <tr>
	            <td class="tdMedium">Descrição: *</td>
    	        <td colspan="3" class="tdLight"><input name="descricao" type="text" class="caixa" id="descricao" value="<%= banco.getCampo("descricao", rs) %>" size="85" maxlength="80"></td>
            </tr>
			<tr>
				<td class="tdMedium">Data: *</td>
				<td class="tdLight"><input type="text" name="data" id="data" onKeyPress="formatar(this, event, '##/##/####'); " value="<%= Util.formataData(banco.getCampo("data", rs)) %>" size="10" maxlength="10" class="caixa" onBlur="ValidaData(this);ValidaFuturo(this);"></td>
				<td class="tdMedium">Valor: *</td>
				<td class="tdLight"><input type="text" name="valor" onKeyPress="return OnlyNumbers(this,event);" class="caixa" id="valor" value="<%= banco.getCampo("valor", rs) %>" size="15" maxlength="10"></td>
			</tr>
          </table>
      </td>
    </tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<%= Util.getBotoes("consumo", pesq, tipo) %>
	<tr>
		<td>&nbsp;</td>
	</tr>
    <tr>
		<td width="100%" style="text-align:center">
			<table width="600px">
				<tr>
					<td class="tdDark"><a title="Ordenar por Descrição" href="Javascript:ordenar('consumo','descricao')">Consumo</a></td>					
					<td width="80" class="tdDark"><a title="Ordenar por Data" href="Javascript:ordenar('consumo','data')">Data</a></td>
					<td width="90" class="tdDark">Valor</td>					
				</tr>
			</table>
			<div style="width:600; height:101; overflow: auto">
				<table width="100%">
				    <%
						String resp[] = vacina.getConsumos(pesq, "descricao", ordem, numPag, 50, tipo, cod_empresa);
						out.println(resp[0]);
					%>
				</table>
			</div>
			<table width="600px">
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
