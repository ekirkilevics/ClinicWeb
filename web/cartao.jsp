<%@include file="cabecalho.jsp" %>
<%
	String cod 	  = request.getParameter("cod") != null ? request.getParameter("cod") : ""; 
	String gravar = request.getParameter("gravar") != null ? request.getParameter("gravar") : ""; 
	String valor = banco.getValor("valor", "SELECT valor FROM faturas_itens WHERE cod_subitem=" + cod);

	if(!cod.equals("")) {
		rs = banco.getRegistro("faturas_cartoes","cod_subitem", Integer.parseInt(cod));
		//Se já cadastrou o valor, colocar na tela
		if(!Util.isNull(banco.getCampo("valor", rs)))
			valor = banco.getCampo("valor", rs);
	}

	if(gravar.equals("sim")) {
		//Configuração
		String tabela = "faturas_cartoes";
		String chave  = "cod_cartao";
	
		//Nome dos campos (form e tabela)
		String campostabela[] = {"cod_cartao","cod_subitem","Bandeira","numero_cartao","vencimento","valor","parcelas"};
	
		//Vetor de dados que vai ser preenchido
		String dados[] = new String[campostabela.length];
	
		//Remove todos os dados de cartão para inserir novamente
		banco.excluirTabela("faturas_cartoes", "cod_subitem", cod);
	
		//Código do cheque é sequencial
		dados[0] = banco.getNext(tabela, chave );
	
		//Dados dos campos
		dados[1] = cod;
		dados[2] = request.getParameter("bandeira");
		dados[3] = request.getParameter("num");
		dados[4] = request.getParameter("vencimento");
		dados[5] = request.getParameter("valorpagto").replace(",",".");
		dados[6] = request.getParameter("nparcelas");

		//Grava os dados do Cheque
		banco.gravarDados(tabela, dados, campostabela);
	}

%>
<html>
<head>
<title>..:Cartão de Crédito:..</title>
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
<script language="JavaScript">
	var vsalvar = "<%= gravar%>";
	var valortotal;

	function inicio() {
		if(vsalvar == "sim") {
			alert("Dados do cartão inserido com sucesso.")
			self.close();
		}
		else {
			cbeGetElementById("bandeira").value = "<%= banco.getCampo("Bandeira", rs) %>";
		}
	}

	function salvar() {
		var frm = cbeGetElementById("frmcadastrar");
		var vnum = cbeGetElementById("num");
		var vvcto = cbeGetElementById("vencimento");
		var vvalor = cbeGetElementById("valorpagto");
		var vparcelas = cbeGetElementById("nparcelas");
		
		if(vnum.value == "") {
			alert("Preencha o número do cartão de crédito!")
			vnum.focus();
			return;
		}
		if(vvcto.value == "") {
			alert("Preencha o vencimento do cartão de crédito!")
			vvcto.focus();
			return;
		}
		if(vvalor.value == "") {
			alert("Preencha o valor a ser debitado no cartão de crédito!")
			vvalor.focus();
			return;
		}
		if(vparcelas.value == "") {
			alert("Preencha a quantidade de parcelas!")
			vparcelas.focus();
			return;
		}

		frm.action += "&gravar=sim";
		frm.submit();
	}
</script>
</head>

<body onLoad="inicio()">
<form name="frmcadastrar" id="frmcadastrar" action="cartao.jsp?cod=<%= cod%>" method="post">
  <table name="tabela" id="tabela" width="100%" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr>
      <td width="100%" height="18" class="title">.: Cartão de Crédito :.</td>
    </tr>
	<tr style="height:30px">
		<td align="right"><span name='msg' id='msg' class="msg">&nbsp;</span></td>
	</tr>
    <tr align="center" valign="top">
      <td width="100%">
		<table cellpadding="0" cellspacing="0" class="table">
			<tr>
				<td class="tdMedium">Bandeira</td>
				<td class="tdLight">
					<select name="bandeira" id="bandeira" class="caixa">
						<option value="Mastercard">Mastercard</option>
						<option value="VISA">VISA</option>
						<option value="AMEX">AMEX</option>
					</select>
				</td>
			</tr>
			<tr>
				<td class="tdMedium">nº do cartão</td>
				<td class="tdLight"><input type="text" name="num" id="num" class="caixa" size="20" maxlength="16" value="<%= banco.getCampo("numero_cartao", rs) %>"></td>
			</tr>
			<tr>
				
            <td height="21" class="tdMedium">Vencimento</td>
				<td class="tdLight"><input type="text" name="vencimento" id="vencimento" class="caixa" size="6" maxlength="7" value="<%= banco.getCampo("vencimento", rs) %>"></td>
			</tr>
			<tr>
				<td class="tdMedium">Valor</td>
				<td class="tdLight"><input type="text" name="valorpagto" id="valorpagto" class="caixa" size="10" value="<%= valor %>" onKeyPress="return somenteNumeros(event)"></td>
			</tr>
			<tr>
				<td class="tdMedium">Parcelas</td>
				<td class="tdLight"><input type="text" name="nparcelas" id="nparcelas" class="caixa" maxlength="2" size="3" value="<%= banco.getCampo("parcelas", rs) %>"></td>
			</tr>
			<tr>
			  <td colspan="5" class="tdMedium" align="center">
				  <button name="button2" type="button" class="botao" style="width:60px; text-align:center" onClick="salvar()"><img src="images/gravamini.gif" width="15" height="15"><br>
			    Gravar</button>&nbsp;&nbsp;
				<button name="button" type="button" class="botao" style="width:60px; text-align:center" onClick="Javascript:self.close()"><img src="images/no.gif" width="15" height="15"><br>
				Fechar</button>
			  </td>
			</tr>
		</table>
	  </td>
    </tr>
  </table>
</form>
</body>
</html>
