<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.Paciente" id="paciente" scope="page"/>

<%
	String nasc = request.getParameter("hidnasc");
	String nome = !Util.isNull(request.getParameter("nome")) ? request.getParameter("nome") : "";
	String resp = "";
	String codnovo = "";
	
	if(nasc != null && !nasc.equals("")) {
			String proximo = banco.getNext("paciente", "codcli");
			codnovo = proximo;
			String convenio = request.getParameter("cod_convenio");
			String plano = !Util.isNull(request.getParameter("cod_plano")) ? request.getParameter("cod_plano") : "-1";
			String ddd_residencial = request.getParameter("ddd_residencial");
			String tel_residencial = request.getParameter("tel_residencial");
			String ddd_celular = request.getParameter("ddd_celular");
			String tel_celular = request.getParameter("tel_celular");
			String num_associado = !Util.isNull(request.getParameter("num_associado_convenio")) ? request.getParameter("num_associado_convenio") : "0";
			String validade = !Util.isNull(request.getParameter("validade_carteira")) ? request.getParameter("validade_carteira") : Util.getData();
			String prof_reg = !Util.isNull(request.getParameter("prof_reg")) ? request.getParameter("prof_reg") : "";
			String email = !Util.isNull(request.getParameter("email")) ? request.getParameter("email") : "";
			String cadastro = request.getParameter("cadastro");
			String imprime = !Util.isNull(request.getParameter("imprime")) ? request.getParameter("imprime") : "";	

			String dados[] = {proximo, nome, Util.formataDataInvertida(nasc),ddd_residencial, tel_residencial, ddd_celular, tel_celular, Util.formataDataInvertida(cadastro), prof_reg, email, cod_empresa, "0"};
			String campos[] = {"codcli", "nome", "data_nascimento","ddd_residencial","tel_residencial","ddd_celular","tel_celular","data_abertura_registro", "prof_reg", "email", "cod_empresa", "status"};
			
			//Valida duplicidade
			int validar[] = {1,2};
			boolean passou = banco.validaRegistro("paciente", "codcli", "", dados, campos, validar );
			if(!passou)
        		resp = "Registro Duplicado";
		    else {
				resp = banco.gravarDados("paciente", dados, campos);
				
				String sql = "INSERT INTO paciente_convenio(cod_pac_conv, codcli, cod_convenio, cod_plano, num_associado_convenio, validade_carteira) VALUES(";
				sql += banco.getNext("paciente_convenio", "cod_pac_conv") + "," + proximo + "," + convenio + "," + plano + ",'" + num_associado + "','";
				sql += Util.formataDataInvertida(validade) + "')";
				resp = banco.executaSQL(sql);
			}
						
			if(resp.equals("OK") && imprime.equals("true")) resp = "imprime";
				
	
	}
%>

<html>
<head>
<title>..:Cadastro Rápido:..</title>
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
<script language="JavaScript" src="js/ajax.js"></script>
<script language="JavaScript">

	var resp = "<%= resp%>";
	var jsnovo = "<%= codnovo%>";
	var jsnome = "<%= nome%>";
	
	function validarCampos() {
		var jsnome = getObj("","nome");
		var jsnasc = getObj("","nascimento");
		var jsnum = getObj("","num_associado_convenio");
		var jsvalidade = getObj("","validade_carteira");
		var jsconvenio = getObj("", "cod_convenio");
		var jsplano = getObj("", "cod_plano");
		
		if(jsnome.value == "") {
			mensagem("Entre com o nome do novo Paciente",2);
			jsnome.focus();
			return false;
		}
		else if(jsnasc.value == "") {
			mensagem("Entre com a data de nascimento do paciente",2);
			jsnasc.focus();
			return false;
		}
		else if(jsconvenio.value == "") {
			mensagem("Selecione o convênio do paciente",2);
			cbeGetElementById("descr_convenio").focus();
			return false;
		}
		else if(jsplano.value == "") {
			mensagem("Selecione o plano do paciente",2);
			cbeGetElementById("cod_plano").focus();
			return false;
		}
		return true;
	}

	function salvar()
	{
		var frm = cbeGetElementById("frmcadastrar");
		if( validarCampos() ) {
			getObj("","hidnasc").value = getObj("","nascimento").value;
			frm.action = "buscapaciente.jsp";
			frm.submit();
		}
	}

	function imprime() {
		var frm = cbeGetElementById("frmcadastrar");
		if( validarCampos() ) {
			getObj("","hidnasc").value = getObj("","nascimento").value;
			frm.action = "buscapaciente.jsp?imprime=true";
			frm.submit();
		}
	}

	function iniciar()
	{
		var pai = window.opener.location;
		if(resp == "OK") {
			alert("Cadastro efetuado com sucesso!");
			window.opener.location = pai + "?codcli=" + jsnovo + "&nome=" + jsnome;
			self.close();
		}
		else if(resp == "imprime") {
			self.location = "escolhemodelo.jsp?codcli=" + jsnovo + "&nome=" + jsnome;
			self.resizeTo(500,120);
			self.focus();
		}
		else if(resp != "") {
			mensagem(resp,2);
		}
	}
	
	function validaTamanho(obj, tam) {
		if(obj.value.length != 0 && obj.value.length != tam) {
			alert("Número da carteira com formato inválido. Digite novamente!");
			obj.value = "";
			obj.focus();
		}
	}
	
	//Sobrescrendo a função do AJAX
	function setar(chave, campo, valorchave, valorcampo, mascara) {
		cbeGetElementById(campo).value = valorcampo;
		cbeGetElementById(chave).value = valorchave;
		x.innerHTML = "";
		hide();
	
		buscaplanosconvenio(valorchave);
		
		if(mascara == "null")
			caixanassociado = "<input name='num_associado_convenio' type='text' class='caixa' id='num_associado_convenio' size='9' maxlength='25'>";
		else 
			caixanassociado = "<input name='num_associado_convenio' type='text' class='caixa' id='num_associado_convenio' size='9' onBlur='validaTamanho(this, " + mascara.length + ")' maxlength='" + mascara.length + "' onKeyPress=\"return formatar(this, event, '" + mascara + "')\">";			
		
		//Coloca a máscara
		cbeGetElementById("nassociado").innerHTML = caixanassociado;
		
		return;
	}
	
	
</script>
</head>

<body onLoad="iniciar()">
<%@include file="barraajax.jsp" %>
<form name="frmcadastrar" id="frmcadastrar" action="#" method="post">
<!-- Campos ocultos para cadastrar novo paciente -->
<input type="hidden" name="hidnasc" id="hidnasc">
<!-- Campos ocultos para cadastrar novo paciente -->
  <table name="tabela" id="tabela" width="100%" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr>
      <td width="100%" height="18" class="title">.: Cadastro Rápido :.</td>
    </tr>
	<tr style="height:25px">
		<td align="right"><span name='msg' id='msg' class="msg">&nbsp;</span></td>
	</tr>
	<tr>
		<td>
			 <table width="100%" border="0" cellpadding="0" cellspacing="0" class="table">
				<tr>
					<td class="tdMedium">Nome Completo: *</td>
					<td colspan="3" class="tdLight"><input name="nome" type="text" class="caixa" id="nome" maxlength="80" style="width:100%" value="<%= nome%>"></td>
				</tr>	
			 	<tr>
					<td class="tdMedium">Nascimento: *</td>
					<td colspan="3" class="tdLight">
						<input type="text" name="nascimento" onKeyPress="formatar(this, event, '##/##/####'); " id="nascimento" size="10" maxlength="10" class="caixa" onBlur="ValidaData(this);ValidaFuturo(this);">
						<input type="hidden" name="cadastro" id="cadastro" value="<%= Util.getData()%>">
					</td>
				</tr>
				<tr>
					<td class="tdMedium">Convênio: *</td>
					<td class="tdLight">
              			<input type="hidden" name="cod_convenio" id="cod_convenio">			
						<input style="width:100%" class="caixa" type="text" name="descr_convenio" id="descr_convenio" onKeyUp="buscaconvenios(this.value)">
					</td>
					<td class="tdMedium">Plano:</td>
					<td class="tdLight">
						<div id="listaplanos">
							<select name="cod_plano" id="cod_plano" class="caixa" style="width:120px">
								<option value=""></option>
							</select>
						</div>
					</td>
				</tr>
				<tr>
					<td class="tdMedium">Médico Responsável:</td>
					<td colspan="3" class="tdLight">
						<select name="prof_reg" id="prof_reg" class="caixa">
							<option value="">Todos</option>
							<%= paciente.getProfissionais( cod_empresa)%>
						</select>
					</td>
				</tr>
			 	<tr>
					<td class="tdMedium">Núm. Associado:</td>
					<td class="tdLight"><div id="nassociado">&nbsp;</div></td>					
					<td class="tdMedium">Validade da Carteira:</td>
					<td class="tdLight">
						<input name="validade_carteira" type="text" class="caixa" id="validade_carteira" size="10" maxlength="10" onKeyPress="formatar(this, event, '##/##/####'); ">
					</td>
				</tr>
			 	<tr>
					<td class="tdMedium">Tel. Residencial:</td>
					<td class="tdLight">
						<input name="ddd_residencial" type="text" class="caixa" id="ddd_residencial" size="1" maxlength="2" onKeyUp="mudaFoco(this, 2, 'tel_residencial')">
					    <input name="tel_residencial" type="text" class="caixa" id="tel_residencial" size="8" maxlength="8" onKeyUp="mudaFoco(this, 8, 'ddd_celular')">	
			  		</td>					
					<td class="tdMedium">Celular:</td>
					<td class="tdLight">
						<input name="ddd_celular" type="text" class="caixa" id="ddd_celular" size="1" maxlength="2" onKeyUp="mudaFoco(this, 2, 'tel_celular')">
						<input name="tel_celular" type="text" class="caixa" id="tel_celular" size="8" maxlength="8" onKeyUp="mudaFoco(this, 8, 'botaosalvar')">
					</td>
				</tr>
				<tr>
					<td class="tdMedium">e-mail:</td>
					<td colspan="3" class="tdLight"><input name="email" type="text" class="caixa" id="email" size="45" maxlength="100" onBlur="validaemail(this);"></td>
				</tr>
				<tr>
					<td colspan="2" class="tdMedium" style="text-align:center">
						<button name="botaosalvar" id="botaosalvar" type="button" style="width:200px" class="botao" onClick="salvar()"><img src="images/gravamini.gif">&nbsp;&nbsp;&nbsp;Salvar</button>
					</td>
					<td colspan="2" class="tdMedium" style="text-align:center">
						<button type="button" style="width:200px" class="botao" onClick="imprime()"><img src="images/print.gif">&nbsp;&nbsp;&nbsp;Imprimir</button>
					</td>
				</tr>
			 </table>
		</td>
	</tr>
  </table>
</form>

</body>
</html>
