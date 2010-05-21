<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.OutrasDespesas" id="outrasdespesas" scope="page"/>

<%
	String nomeconvenio = request.getParameter("nomeconvenio") != null ? request.getParameter("nomeconvenio") : "";
	if(strcod != null) {
		rs = banco.getRegistro("outrasdespesas","cod_outrasdespesas", Integer.parseInt(strcod) );
		nomeconvenio = banco.getValor("descr_convenio", "SELECT descr_convenio FROM convenio WHERE cod_convenio=" + banco.getCampo("cod_convenio", rs));
	}
	if(ordem == null) ordem = "Procedimento";
	
	//Remove item se veio
	outrasdespesas.removeItem(request.getParameter("exc"));
		
%>

<html>
<head>
<title>Outras Despesas</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
<script language="JavaScript" src="js/ajax.js"></script>
<script language="JavaScript">
     //id
     var idReg = "<%= strcod%>";
	 //Informa��o vinda de gravar
	 var inf = "<%= inf%>";
	 //Nome dos campos
	 var nome_campos_obrigatorios = Array("Procedimento","Conv�nio");
	 //P�gina a enviar o formul�rio
	 var page = "gravaroutrasdespesas.jsp";
	 //Cod. da ajuda
	 cod_ajuda = 26;

     //Campos obrigat�rios
	 var campos_obrigatorios = Array("procedimento","cod_convenio");

	
	function iniciar() {
		getObj("","procedimento").value = "<%= banco.getCampo("cod_proced", rs)%>";
		inicio();
		barrasessao();
	}

	//Sobrescrendo a fun��o do AJAX
	function setar(chave, campo, valorchave, valorcampo) {
		cbeGetElementById(campo).value = valorcampo;
		cbeGetElementById(chave).value = valorchave;
		x.innerHTML = "";
		hide();

		return;
	}
	
	function insereItem() {
		var jscd = cbeGetElementById("cd");
		var jstabela = cbeGetElementById("tabela");
		var jscodigoitem = cbeGetElementById("codigoitem");
		var jsdescricao = cbeGetElementById("descricao");
		var jsvalor = cbeGetElementById("valor");
		
		//Valida os campos
		if(jscd.value == "") {
			mensagem("Preencha o C�d. da Despesa", 2);
			jscd.focus();
			return;
		}
		if(jstabela.value == "") {
			mensagem("Preencha a Tabela da Despesa", 2);
			jstabela.focus();
			return;
		}
		if(jscodigoitem.value == "") {
			mensagem("Preencha o c�digo do Item da Despesa", 2);
			jscodigoitem.focus();
			return;
		}
		else {
			if(jscodigoitem.value.length < 8) {
				mensagem("C�d. precisa ter um m�nimo de 8 d�gitos",2);
				jscodigoitem.focus();
				return;				
			}
		}
		if(jsdescricao.value == "") {
			mensagem("Preencha a descri��o do Item da Despesa", 2);
			jsdescricao.focus();
			return;
		}
		if(jsvalor.value == "") {
			mensagem("Preencha o valor do Item da Despesa", 2);
			jsvalor.focus();
			return;
		}
		enviarAcao('inc');
	}
	
	function excluirItem(exc) {
		var frm = cbeGetElementById("frmcadastrar");
		conf = confirm("Confirma exclus�o do item?");
		if(conf) {
			frm.action = "outrasdespesas.jsp?cod=" + idReg + "&exc=" + exc;
			frm.submit();
		}
	}
	
	function clickBotaoNovo() {
		botaoNovo();
	}
	
	function clickBotaoSalvar() {
		insereItem();
	}
	
	function clickBotaoExcluir() {
		enviarAcao('exc');
	}	
	

</script>
</head>

<body onLoad="iniciar()">
<%@include file="barrasessao.jsp" %>
<%@include file="barraajax.jsp" %>
<form name="frmcadastrar" id="frmcadastrar" action="gravaroutrasdespesas.jsp" method="post">
  <!-- Campos Ocultos -->
  <input type="hidden" name="ordem" value="<%= ordem%>">
  <!-- Campos Ocultos -->
  <table width="600" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr>
      <td height="18" class="title">.: Cadastro de Outras Despesas :.</td>
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
              <td class="tdMedium">Procedimento: *</td>
              <td class="tdLight">
			  		<select name="procedimento" id="procedimento" class="caixa" style="width:400px">
						<option value=""></option>
						<%= outrasdespesas.getProcedimentos( cod_empresa ) %>
					</select>
			  </td>
            </tr>
            <tr>
	          <td class="tdMedium">Conv&ecirc;nio: *</td>
              <td class="tdLight">
					<input type="hidden" name="cod_convenio" id="cod_convenio" value="<%= banco.getCampo("cod_convenio", rs) %>">			
					<input style="width:100%" class="caixa" type="text" name="descr_convenio" id="descr_convenio" onKeyUp="busca(this.value, 'cod_convenio', 'descr_convenio','convenio','AND ativo=\'S\'')" value="<%= nomeconvenio%>">
			  </td>
            </tr>
			<tr>
				<td class="tdDark" colspan="2" align="center">Registro de Itens</td>
			</tr>
			<tr>
				<td colspan="2">
					<table cellpadding="0" cellspacing="0" width="100%">
						<tr>
							<td class="tdMedium">CD</td>
							<td class="tdMedium">Tabela</td>
							<td class="tdMedium">C�digo do Item</td>
							<td class="tdMedium">Descri��o</td>
							<td class="tdMedium">Valor</td>
							<td class="tdMedium">A��o</td>
						</tr>
						<tr>
							<td class="tdLight">
								<select name="cd" id="cd" class="caixa" style="width:80px">
									<option value=""></option>
									<%= outrasdespesas.getCDs()%>
								</select>
							</td>
							<td class="tdLight">
								<select name="tabela" id="tabela" class="caixa" style="width:130px">
									<option value=""></option>
									<%= outrasdespesas.getTabelas( cod_empresa )%>
								</select>
							</td>
							<td class="tdLight"><input type="text" name="codigoitem" id="codigoitem" class="caixa" maxlength="10" size="8" onKeyPress="return OnlyNumbersSemPonto(this,event);"></td>
							<td class="tdLight"><input type="text" name="descricao" id="descricao" class="caixa" maxlength="50" size="20"></td>
							<td class="tdLight"><input type="text" onKeyPress="return OnlyNumbers(this,event);" name="valor" class="caixa" id="valor" size="7" maxlength="10"></td>
							<td class="tdLight" align="center"><a href="Javascript:insereItem()"><img src="images/add.gif" border="0"></a></td>
						</tr>
						<%= outrasdespesas.getItensOutrasDespesas(strcod)%>
					</table>
				</td>
			</tr>
          </table>
      </td>
    </tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<%= Util.getBotoes("outrasdespesas", pesq, tipo) %>
	<tr>
		<td>&nbsp;</td>
	</tr>
    <tr>
		<td width="100%" style="text-align:center">
			<table width="600px">
				<tr>
					<td width="20%" class="tdDark"><a title="Ordenar por C�digo" href="Javascript:ordenar('outrasdespesas','CODIGO')">C�d. Procedimento</a></td>					
					<td width="40%" class="tdDark"><a title="Ordenar por Procedimento" href="Javascript:ordenar('outrasdespesas','Procedimento')">Procedimento</a></td>
					<td width="40%" class="tdDark"><a title="Ordenar por Conv�nio" href="Javascript:ordenar('outrasdespesas','descr_convenio')">Conv�nio</a></td>					
				</tr>
			</table>
			<div style="width:600; height:101; overflow: auto">
				<table width="100%">
				    <%
						String resp[] = outrasdespesas.getOutrasDespesas(pesq,  ordem, numPag, 50, tipo, cod_empresa);
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
