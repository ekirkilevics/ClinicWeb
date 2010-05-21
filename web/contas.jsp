<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.Conta" id="conta" scope="page"/>

<%
	if(strcod != null) rs = banco.getRegistro("contas","cod_conta", Integer.parseInt(strcod) );
	if(Util.isNull(ordem)) ordem = "data_vencimento DESC";
%>

<html>
<head>
<title>Contas a Pagar</title>
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
	 var nome_campos_obrigatorios = Array("Data Vencimento", "Valor");
	 //Página a enviar o formulário
	 var page = "gravarcontas.jsp";
     //Campos obrigatórios
	 var campos_obrigatorios = Array("data_vencimento", "valortotal");
	 
 	function clickBotaoNovo() {
		botaoNovo();
	}
	
	function clickBotaoSalvar() {
		enviarAcao('inc');
	}
	
	function clickBotaoExcluir() {
		enviarAcao('exc');
	}
	
	function iniciar() {
		cbeGetElementById("banco").value = "<%= banco.getCampo("banco", rs) %>";
		cbeGetElementById("operacao").value = "<%= banco.getCampo("operacao", rs) %>";
	
		inicio();
		barrasessao();
	}
	 

</script>
</head>

<body onLoad="iniciar()">
<%@include file="barrasessao.jsp" %>
<form name="frmcadastrar" id="frmcadastrar" action="gravarcontas.jsp" method="post">
  <table width="600" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr>
      <td width="651" height="18" class="title">.: Contas a Pagar :.</td>
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
            	<td colspan="4" class="tdDark"><b>Lançamento</b></td>
            </tr>
            <tr>
	           <td class="tdMedium">Número do Documento: </td>
               <td class="tdLight"><input name="documento" type="text" class="caixa" id="documento" value="<%= banco.getCampo("documento", rs) %>" size="15" maxlength="15"></td>
            	<td class="tdMedium">Data Vencimento: *</td>
                <td class="tdLight"><input type="text" onKeyPress="return formatar(this, event, '##/##/####'); " class="caixa" size="10" name="data_vencimento" id="data_vencimento" maxlength="10" value="<%= Util.formataData(banco.getCampo("data_vencimento", rs))%>" onBlur="ValidaData(this)"></td>
            </tr>
            <tr>
            	<td class="tdMedium">Descrição: *</td>
                <td class="tdLight" colspan="3"><textarea name="descricao" id="descricao" class="caixa" style="width:90%" rows="3"><%= banco.getCampo("descricao", rs)%></textarea></td>
            </tr>
            <tr>
            	<td class="tdMedium">Valor Total: *</td>
                <td class="tdLight" colspan="3"><input onKeyPress="return somenteNumeros(event)" name="valortotal" type="text" class="caixa" id="valortotal" value="<%= banco.getCampo("valortotal", rs) %>" size="15" maxlength="10"></td>
            </tr>
          </table>
		  <br>
          <table width="100%" border="0" cellpadding="0" cellspacing="0" class="table">
			<tr>
            	<td colspan="4" class="tdDark"><b>Pagamento</b></td>
            </tr>
            <tr>
            	<td class="tdMedium">Data Pagamento: </td>
                <td class="tdLight"><input type="text" onKeyPress="return formatar(this, event, '##/##/####'); " class="caixa" size="10" name="data_pagamento" id="data_pagamento" maxlength="10" value="<%= Util.formataData(banco.getCampo("data_pagamento", rs))%>" onBlur="ValidaData(this);ValidaPassado(this)"></td>
            	<td class="tdMedium">Valor Pago: </td>
                <td class="tdLight"><input onKeyPress="return somenteNumeros(event)" name="valorpago" type="text" class="caixa" id="valorpago" value="<%= banco.getCampo("valorpago", rs) %>" size="15" maxlength="10"></td>
            </tr>
            <tr>
            	<td class="tdMedium">Banco: </td>
                <td class="tdLight">
                	<select name="banco" id="banco" class="caixa">
							<option value=""></option>
          					<%= conta.getBancos(cod_empresa)%>
                    </select>
                </td>
            	<td class="tdMedium">Operacão:</td>
                <td class="tdLight">
                	<select name="operacao" id="operacao" class="caixa">
						<option value=""></option>
						<option value="1">Dinheiro</option>
						<option value="2">Cheque</option>
						<option value="3">Cartão</option>
						<option value="4">Internet</option>
						<option value="5">Débito Automático</option>
						<option value="6">Depósito</option>
                    </select>
                </td>
            </tr>
           </table>
      </td>
    </tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<%= Util.getBotoes("contas", pesq, tipo) %>
	<tr>
		<td>&nbsp;</td>
	</tr>
    <tr>
		<td width="100%" style="text-align:center">
			<table width="600px">
				<tr>
					<td width="80" class="tdDark"><a title="Ordenar por Data" href="Javascript:ordenar('contas','data_vencimento')">Data</a></td>
                    <td class="tdDark"><a title="Ordenar por Descrição" href="Javascript:ordenar('contas','descricao')">Descrição</a></td>
                    <td width="90" class="tdDark"><a title="Ordenar por Valor" href="Javascript:ordenar('contas','valortotal')">Valor</a></td>
				</tr>
			</table>
			<div style="width:600; height:101; overflow: auto">
				<table width="100%">
				    <%
						String resp[] = conta.getContas(pesq, "descricao", ordem, numPag, 50, tipo, cod_empresa);
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
