<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.Paciente" id="paciente" scope="page"/>

<%
	String nomeconvenio = "";
	String nomeprofissao = "";
	if(strcod != null) {
		rs = banco.getRegistro("paciente","codcli", Integer.parseInt(strcod) );
		//Busca o nome da profissão
		nomeprofissao = "(" + banco.getCampo("profissao", rs) + ") " + banco.getValor("profissao", "SELECT profissao FROM cbo2002 WHERE codCBOS='" + banco.getCampo("profissao", rs) + "'");

		//Busca o nome do convênio do paciente
		String dadospaciente[] = paciente.getDadosPaciente(strcod);
		nomeconvenio = dadospaciente[1];
	}
	if(ordem == null) ordem = "nome";
	
	String del = request.getParameter("del");
	
	//Se veio código de exclusão, excluir alerta do paciente
	if(del != null) {
		banco.excluirTabela("alerta_paciente", "cod_alerta_paci", del);
	}
	
	String cod_paciente; 
	if(!banco.getCampo("codcli", rs).equals("")) {
		cod_paciente =  banco.getCampo("registro_hospitalar", rs);
	}
	else {
		cod_paciente = banco.getNext("paciente", "registro_hospitalar");
	}

	String alerta = paciente.getAlertasPaci(strcod);
	
	String UFpadrao = configuracao.getItemConfig("uf", cod_empresa);

%>

<html>
<head>
<title>Pacientes</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
<script language="JavaScript" src="js/ajax.js"></script>
<script language="JavaScript">

     //id
     var idReg = "<%= strcod%>";
	 //Informação vinda de gravar
	 var inf = "<%= inf%>";
	 //Nome dos campos
	 var nome_campos_obrigatorios = Array("Nome Completo","Nascimento","Sexo", "Situação");
	 //Página a enviar o formulário
	 var page = "gravarpaciente.jsp";
	 //Cód. da ajuda
	 cod_ajuda = "2";

     //Campos obrigatórios
	 var campos_obrigatorios = Array("nome","data_nascimento","cod_sexo", "status");
	 var novo_codcli = "<%= banco.getNext("paciente", "registro_hospitalar")%>";
	 
	 //Cod. da ajuda
	 cod_ajuda = 2;

	 //Quantidade de alertas
	 var qtdealertas = parseInt("<%= alerta%>");
	 
	function setarValores()	{
		getObj("","cod_sexo").value = "<%= banco.getCampo("cod_sexo", rs)%>";
		getObj("","cod_estado_civil").value = "<%= banco.getCampo("cod_est_civil", rs)%>";
		getObj("","cod_cor").value = "<%= banco.getCampo("cod_cor", rs)%>";
		getObj("","status").value = "<%= banco.getCampo("status", rs)%>";
		getObj("","indicacao").value = "<%= banco.getCampo("indicacao", rs)%>";
		getObj("","prof_reg").value = "<%= banco.getCampo("prof_reg", rs)%>";
		
		//Se for inserir, usar data padrão de hoje
		if(idReg == "null") setarData();
		
		//Preeche idade do paciente
		if(idReg != "null") calculaIdade();

	}
	
	function setarData() {
		//Campo da datas
		campo = cbeGetElementById("data_abertura_registro");

		//Número do registro
		cbeGetElementById("registro_hospitalar").value = novo_codcli;
		
		//Preenche a data
		campo.value = getHoje();
		
		//Estado padrão
		cbeGetElementById("uf").value = "<%= UFpadrao%>";
		
		//Habilita caixa de nº de registro
		getObj("","registro_hospitalar").disabled = false;
		
		//Limpa idade
		cbeGetElementById("idade").innerHTML = "";
	}	 
	
	function salvarRegistro() {
		
		//Se preencheu o número do celular, pedir o DDD
		if(cbeGetElementById("tel_celular").value != "") {
			//Se não preencheu o DDD do celular
			if(cbeGetElementById("ddd_celular").value == "") {
				alert("Preencha o DDD do celular");
				cbeGetElementById("ddd_celular").focus();
			}
		}

		enviarAcao('inc');
	}
	
	function calculaIdade()
	{
		cbeGetElementById("idade").innerHTML = getIdade(cbeGetElementById("data_nascimento").value);
	}
	
	function abreAlertas() {
		if(idReg == "null") {
			mensagem("Selecione o paciente para editar os alertas.", 2);
			return;
		}
		displayPopup("editaralertas.jsp?codcli=" + idReg, "alertas",300,500);
		barrasessao();
	}
	
	var qtdabas;
	function iniciar() {
		var botaoalerta = cbeGetElementById("btnalerta");

		//Abas
		qtdabas = 5;
		abaatual = "<%= aba%>";		
		centralizarabas(qtdabas);
		alteraraba(abaatual,qtdabas,tdmedium,tddark);
		
		inicio();
		setarValores();
		barrasessao();
		<% if(!Util.isNull(strcod)) {%>		
			botaoalerta.style.visibility = 'visible';
			if(qtdealertas == 0) msgbtn = "Sem alertas";
			else if(qtdealertas == 1) msgbtn = "1 alerta";
			else msgbtn = qtdealertas + " alertas";
			botaoalerta.value = msgbtn;
		<% } else { %>
			cbeGetElementById("status").value = "0";
		<% } %>

	}
	
	function insereFoto() {
		if(idReg == "null") {
			mensagem("Escolha um paciente para carregar a foto.",2);
		}
		else {
			displayPopup("inserefoto.jsp?codcli="+idReg,"inserefoto","70","300");
		}
	}

	function webcam() {
		if(idReg == "null") {
			mensagem("Escolha um paciente para carregar a foto.",2);
		}
		else {
			displayPopup("webcam.jsp?codcli="+idReg,"webcam","340","320");
		}
	}

	function removefoto(foto) {
			conf = confirm("Confirma exclusão da foto?");
			if(conf) {
				frm = cbeGetElementById("frmcadastrar");
				frm.action = "gravarfoto.jsp?codcli="+idReg+"&exc="+foto;
				frm.submit();
			}
	}
	
	function incluirconvenio() {
		var frm = cbeGetElementById("frmcadastrar");
		var jsconvenio = cbeGetElementById("cod_convenio");
		var jsnumero = cbeGetElementById("num_associado_convenio");
		var jsplano = cbeGetElementById("cod_plano");
		var jsvalidade = cbeGetElementById("validade_carteira");
		
		if(jsconvenio == "-1") {
			alert("Plano particular não precisa ser inserido no cadastro do paciente.");
			return;
		}
		if(jsconvenio.value == "") {
			alert("Escolha o convênio do paciente");
			cbeGetElementById("descr_convenio").focus();
			return;
		} 
		if(jsplano.value == "") {
			alert("Escolha o plano de convênio do paciente");
			jsplano.focus();
			return;
		} 
		if(jsnumero.value == "") {
			alert("Entre com o número da carteira do paciente");
			jsnumero.focus();
			return;
		} 
		if(jsvalidade.value == "") {
			alert("Entre com a validade da carteira do paciente");
			jsvalidade.focus();
			return;
		} 

		enviarAcao('inc');		
	}
	
	function excluirconvenio(cod_convenio) {
		conf = confirm("Confirma exclusão desse convênio para o paciente?");
		if(conf) {
			var frm = cbeGetElementById("frmcadastrar");
			frm.action = "gravarconvenios.jsp?acao=exc&id=" + cod_convenio + "&codcli=" + idReg;
			frm.submit();
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
	
	function imprime() {
		if(idReg == "null") {
			alert("Salve o paciente para depois imprimir a ficha modelo");
			return;
		}
		displayPopup("escolhemodelo.jsp?codcli=" + idReg,'popup',120,500);
	}
	
	function novoPaciente() {
		botaoNovo();
		setarData();
		cbeGetElementById("status").value = "0";
	}
	
	function insereProfissao() {
		var descr = cbeGetElementById("profissao").value;
		var jsdivprofissao = cbeGetElementById("divprofissao");
		centralizar(jsdivprofissao, "H");
		jsdivprofissao.style.Zindex = "0";
		cbeGetElementById("novaprofissao").value = descr;
		jsdivprofissao.style.display = "block";
	}
	
	function gravarProfissao() {
		var frmpro = cbeGetElementById("frmprofissao");
		cbeGetElementById("divprofissao").style.display = "none";
		hideAll();
		frmpro.submit();
	}

	//Cancela o cadastro de nova profissão fechando a tela
	function cancelaCadastro() {
		cbeGetElementById("divprofissao").style.display = "none";
	}
	
	//Insere novo número de registro hospitalar
	function pegaNovoRegistroHospitalar() {
		//Número do registro
		if(cbeGetElementById("registro_hospitalar").value == "")
			cbeGetElementById("registro_hospitalar").value = novo_codcli;
	}

	//Muda o foco para o prox. campo
	function campoDDD(campo, tammax, prox) {
		if(campo.value.length == tammax)
			cbeGetElementById(prox).focus();
	}
	
	function buscarCEP() {
		var jscep = cbeGetElementById("cep").value;
		
		if(jscep == "") {
			alert("Preencha o CEP para buscar o endereço");
			return;
		}
		
		if(jscep.length != 8) {
			alert("O CEP deve ter 8 dígitos");
			return;
		}
		
		alert("A busca de CEP está desabilitada para essa versão. Para usar a busca por CEP, <%= contato%>");
	}
	
	function clickBotaoNovo() {
		novoPaciente();
	}
	
	function clickBotaoSalvar() {
		salvarRegistro();
	}
	
	function clickBotaoExcluir() {
		enviarAcao('exc');
	}	

</script>
</head>

<body onLoad="iniciar();">
<%@include file="barrasessao.jsp" %>
<form name="frmcadastrar" id="frmcadastrar" action="gravarconvenio.jsp" method="post">
<%@include file="barraajax.jsp" %>
  <!-- Campos Ocultos -->
  <input type="hidden" name="ordem" value="<%= ordem%>">
  <!-- Campos Ocultos -->
  <table width="600" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr>
      <td height="18" class="title">.: Cadastrar Pacientes :.</td>
    </tr>
	<tr>
      <td>&nbsp;</td>
	</tr>
	<tr>
		  <td align="right"><span name='msg' id='msg' class="msg">&nbsp;</span></td>
	</tr>
    <tr align="center" valign="top">
      <td height="190px">&nbsp; </td>
    </tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<%= Util.getBotoes("pacientes", pesq, tipo, true) %>
	<tr>
		<td>&nbsp;</td>
	</tr>
    <tr>
		<td width="100%" align="center">
			<table width="600px">
				<tr>
					<td width="68%" class="tdDark"><a title="Ordenar por Nome" href="Javascript:ordenar('pacientes','nome')">Nome</a></td>
					<td class="tdDark"><a title="Ordenar por Nascimento" href="Javascript:ordenar('pacientes','data_nascimento')">Nascimento</a></td>
				</tr>
			</table>
			<div style="width:600; height:101; overflow: auto">
				<table width="100%">
				    <%
						String resp[] = paciente.getPacientes(pesq, ordem, numPag, 50, tipo, cod_empresa);
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
	<tr>
		<td>&nbsp;</td>
	</tr>
  </table>
  
  <!-- MENU DE ABAS -->
  <div id="menuabas" style="width:600px; height: 20px; background-color:<%= fundo%>; position: absolute; left:0px; top:145px; overflow: auto">
		<input type="hidden" name="numeroaba" id="numeroaba" value="<%= aba%>">
		<table cellpadding="0" cellspacing="0" class="table">
			<tr>
				<td id="tdaba1" class="tdMedium" onClick="Javascript:alteraraba('1',qtdabas, tdmedium, tddark)"> Identificação </td>
				<td id="tdaba2" class="tdMedium" onClick="Javascript:alteraraba('2',qtdabas, tdmedium, tddark)"> Endereço </td>
				<td id="tdaba3" class="tdMedium" onClick="Javascript:alteraraba('3',qtdabas, tdmedium, tddark)"> Complemento 1 </td>
				<td id="tdaba4" class="tdMedium" onClick="Javascript:alteraraba('4',qtdabas, tdmedium, tddark)"> Complemento 2 </td>
				<td id="tdaba5" class="tdMedium" onClick="Javascript:alteraraba('5',qtdabas, tdmedium, tddark)"> Convênios </td>
			</tr>
		</table>
  </div>
<!-- MENU DE ABAS -->

<!-- ABA DE IDENTIFICAÇÃO -->
  <div id="aba1" style="width:600px; height:170px; background-color:<%= fundo%>; position: absolute; left:0px; top:165px; z-index:10; overflow: auto">
	 <table width="600" border="0" cellpadding="0" cellspacing="0" class="table">
		<tr>
		  <td class="tdMedium">Data do Registro:</td>
		  <td width="141" class="tdLight"><input type="text" onKeyPress="return formatar(this, event, '##/##/####'); " name="data_abertura_registro" class="caixa" id="data_abertura_registro" value="<%= Util.formataData(banco.getCampo("data_abertura_registro", rs)) %>" size="10" maxlength="10" onBlur="ValidaData(this);"></td>
		  <td width="127" class="tdMedium">nº de registro:</td>
		  <td class="tdLight" nowrap><input name="registro_hospitalar" type="text" class="caixa" id="registro_hospitalar" value="<%= cod_paciente %>" size="9" maxlength="11"><a href="Javascript:pegaNovoRegistroHospitalar()" title="Atribui Número de Registro"><img src="images/22.gif" border="0" hspace="0"></a></td>
		  <td class="tdMedium">Cartão SUS:</td>
		  <td class="tdLight"><input name="cartao_sus" type="text" class="caixa" id="cartao_sus" value="<%= banco.getCampo("cartao_sus", rs) %>" size="10" maxlength="11"></td>
		</tr>
		<tr>
			<td class="tdMedium">Nome Completo: *</td>
			<td colspan="4" class="tdLight"><input name="nome" type="text" class="caixa" id="nome" value="<%= banco.getCampo("nome", rs) %>" size="60" maxlength="80"></td>
			<td rowspan="2" class="tdLight" align="center" valign="middle">
				<% 
					if(Util.isNull(banco.getCampo("foto", rs))) {
						out.println("<a id='foto' name='foto' title='Inserir Foto' href='Javascript:insereFoto()'><img src='images/photo.gif' border='0'></a>");
					}
					else {
						out.println("<a id='foto' name='foto' href=\"Javascript: mostraImagem('upload/" + rs.getString("foto") + "')\"><img src='upload/" + rs.getString("foto") + "' border=0 width=40 height=40></a><a title='Remover Foto' href=\"Javascript:removefoto('" + rs.getString("foto") + "')\"><img src='images/excluir.gif' style='border: 1px solid #000000'></a>");
					}
				%>
			</td>
		</tr>
	  <tr> 
		<td class="tdMedium">Responsável/Cônjuge:</td>
			<td colspan="4" class="tdLight"><input name="nome_responsavel" type="text" class="caixa" id="nome_responsavel" value="<%= banco.getCampo("nome_responsavel", rs) %>" size="60" maxlength="50"></td>
		</tr>
	  <tr>
		  <td class="tdMedium">Nascimento: *</td>
		  <td class="tdLight"><input name="data_nascimento" type="text" class="caixa" id="data_nascimento" onKeyPress="return formatar(this, event, '##/##/####'); " value="<%= Util.formataData(banco.getCampo("data_nascimento", rs)) %>" size="9" maxlength="10" onBlur="ValidaData(this);ValidaFuturo(this);calculaIdade(this);"></td>
		  <td class="tdMedium">Idade:</td>
		  <td width="131" class="tdLight">
				<span id='idade'>&nbsp;</span>&nbsp;
		  </td>
		  <td width="87" class="tdMedium">Sexo: *</td>
		  <td width="119" class="tdLight">
			<select name="cod_sexo" id="cod_sexo" class="caixa">
				<option value=""></option>
				<option value="M">Masculino</option>
				<option value="F">Feminino</option>
			</select>
		  </td>
		</tr>
			<tr>			
              <td class="tdMedium">Cor:</td>
              <td colspan="2" class="tdLight">
			  	<select name="cod_cor" id="cod_cor" class="caixa">
					<option value=""></option>
					<option value="B">Branco</option>
                    <option value="N">Negro</option>
                    <option value="P">Pardo</option>
                    <option value="I">&Iacute;ndio</option>
                    <option value="A">Amarelo</option>
					<option value="O">Outros</option>
				</select>
			  </td>
              <td class="tdMedium">Estado Civil:</td>
              <td colspan="2" class="tdLight">
			  	<select name="cod_estado_civil" id="cod_estado_civil" class="caixa">
					<option value=""></option>
                    <option value="C">Casado</option>
                    <option value="S">Solteiro</option>
                    <option value="E">Separado</option>
                    <option value="D">Divorciado</option>
                    <option value="V">Viuvo</option>
                    <option value="O">Outros</option>
				</select>
			  </td>
            </tr>
            <tr>
	          <td class="tdMedium">RG: </td>
              <td colspan="2" class="tdLight"><input name="rg" type="text" class="caixa" id="rg" value="<%= banco.getCampo("rg", rs) %>" size="15" maxlength="15"></td>
              <td class="tdMedium">Emissor:</td>
              <td colspan="2" class="tdLight">
			  		<input name="rg_emissor" type="text" class="caixa" id="rg_emissor" value="<%= banco.getCampo("rg_emissor", rs) %>" size="3" maxlength="10">
					<input name="rg_estado" type="text" class="caixa" id="rg_estado" value="<%= banco.getCampo("rg_estado", rs) %>" size="2" maxlength="2">
			  </td>
            </tr>
            <tr>
	            <td width="79" class="tdMedium">CPF:</td>
                <td class="tdLight"><input name="cpf" type="text" onKeyPress="return formatar(this, event, '###.###.###-##');" class="caixa" id="cpf" value="<%= banco.getCampo("cic", rs) %>" size="16" maxlength="14" onBlur="valida_cpf_cnpj(this)"></td>
                <td class="tdMedium">e-mail:</td>
                <td colspan="4" class="tdLight"><input name="email" type="text" class="caixa" id="email" value="<%= banco.getCampo("email", rs) %>" size="45" maxlength="100" onBlur="validaemail(this);"></td>
            </tr>
	</table>
  </div>  
<!-- ABA DE IDENTIFICAÇÃO -->

<!-- ABA DE ENDEREÇO -->
  <div id="aba2" style="width:600px; height:170px; background-color:<%= fundo%>; position: absolute; left:0px; top:165px; z-index:2; overflow: auto">
      <table width="600" border="0" cellpadding="0" cellspacing="0" class="table">
		<tr>
		  <td class="tdMedium">Contato:</td>
		  <td colspan="2" class="tdLight"><input name="contato" type="text" class="caixa" id="contato" value="<%= banco.getCampo("nome_contato", rs) %>" size="30" maxlength="60"></td>
		  <td class="tdMedium">CEP:</td>
		  <td class="tdLight"><input name="cep" onKeyPress="return formatar(this, event, '########');" type="text" class="caixa" id="cep" value="<%= banco.getCampo("cep", rs) %>" size="9" maxlength="8"></td>
		  <td class="tdLight">
		  	<a href="JavaScript:buscarCEP()" title="Buscar dados de endereço"><img src="images/lupa.gif" border="0"></a>
			<span id="imgcep">&nbsp;</span>
		  </td>
		</tr>
		<tr>
		  <td class="tdMedium">Endereço:</td>
		  <td colspan="5" class="tdLight"><input name="endereco" type="text" class="caixa" id="endereco" value="<%= banco.getCampo("nome_logradouro", rs) %>" style="width:472" maxlength="50"></td>
		</tr>
		<tr>
		  <td class="tdMedium">Número:</td>
		  <td class="tdLight"><input name="numero" type="text" class="caixa" id="numero" value="<%= banco.getCampo("numero", rs) %>" size="10" maxlength="10"></td>
		  <td class="tdMedium">Complemento:</td>
		  <td colspan="3" class="tdLight"><input name="complemento" type="text" class="caixa" id="complemento" value="<%= banco.getCampo("complemento", rs) %>" style="width:260" maxlength="50"></td>
		</tr>
		<tr>
		  <td class="tdMedium">Bairro:</td>
		  <td class="tdLight"><input name="bairro" type="text" class="caixa" id="bairro" value="<%= banco.getCampo("bairro", rs) %>" size="15" maxlength="50"></td>
		  <td class="tdMedium">Cidade:</td>
		  <td class="tdLight"><input name="cidade" type="text" class="caixa" id="cidade" value="<%= banco.getCampo("cidade", rs) %>" size="15" maxlength="30"></td>
		  <td class="tdMedium">Estado:</td>
		  <td class="tdLight">
				<%= Util.getUF(banco.getCampo("uf", rs))  %>
		  </td>
		</tr>
		<tr>
		  <td class="tdMedium">Tel. Residencial:</td>
		  <td colspan="2" class="tdLight">
			<input onKeyUp="campoDDD(this, 2, 'tel_residencial')" name="ddd_residencial" type="text" class="caixa" id="ddd_residencial" value="<%= banco.getCampo("ddd_residencial", rs) %>" size="1" maxlength="2" onKeyPress="Javascript:OnlyNumbers(this,event);">
			<input onKeyUp="campoDDD(this, 8, 'ddd_celular')" name="tel_residencial" type="text" class="caixa" id="tel_residencial" value="<%= banco.getCampo("tel_residencial", rs) %>" size="8" maxlength="8" onKeyPress="Javascript:OnlyNumbers(this,event);">	
		  </td>
		  <td class="tdMedium">Celular:</td>
		  <td colspan="2" class="tdLight">
			<input onKeyUp="campoDDD(this, 2, 'tel_celular')" name="ddd_celular" type="text" class="caixa" id="ddd_celular" value="<%= banco.getCampo("ddd_celular", rs) %>" size="1" maxlength="2" onKeyPress="Javascript:OnlyNumbers(this,event);">
			<input onKeyUp="campoDDD(this, 8, 'ddd_comercial')" name="tel_celular" type="text" class="caixa" id="tel_celular" value="<%= banco.getCampo("tel_celular", rs) %>" size="8" maxlength="8" onKeyPress="Javascript:OnlyNumbers(this,event);">
		  </td>
	</tr>
	<tr>
		  <td class="tdMedium">Tel. Comercial:</td>
		  <td colspan="2" class="tdLight">
			<input onKeyUp="campoDDD(this, 2, 'tel_comercial')" name="ddd_comercial" type="text" class="caixa" id="ddd_comercial" value="<%= banco.getCampo("ddd_comercial", rs) %>" size="1" maxlength="2" onKeyPress="Javascript:OnlyNumbers(this,event);">
			<input onKeyUp="campoDDD(this, 8, 'ramal')" name="tel_comercial" type="text" class="caixa" id="tel_comercial" value="<%= banco.getCampo("tel_comercial", rs) %>" size="8" maxlength="8" onKeyPress="Javascript:OnlyNumbers(this,event);">
		  </td>
		  <td class="tdMedium">Ramal:</td>
		  <td colspan="2" class="tdLight">
			<input name="ramal" type="text" class="caixa" id="ramal" value="<%= banco.getCampo("ramal", rs) %>" size="8" maxlength="8">
		  </td>
		</tr>
	  </table>
  </div>  
<!-- ABA DE ENDEREÇO -->

<!-- ABA DE COMPLEMENTO 1 -->
  <div id="aba3" style="width:600px; height:170px; background-color:<%= fundo%>; position: absolute; left:0px; top:165px; z-index:2; overflow: auto">
     <table width="600" border="0" cellpadding="0" cellspacing="0" class="table">
		<tr>
		  <td class="tdMedium">Profissão:</td>
		  <td colspan="3" class="tdLight">
			<input type="hidden" name="codCBOS" id="codCBOS" value="<%= banco.getCampo("profissao", rs) %>">			
			<input style="width:90%" class="caixa" type="text" name="profissao" id="profissao" onKeyUp="buscaprofissao(this.value)" value="<%= nomeprofissao%>">
			<a title="Insere Profissão" href="Javascript:insereProfissao()"><img src="images/grava.gif" border="0"></a>
		  </td>
		</tr>
		<tr>
		  <td class="tdMedium">Nome do Pai:</td>
		  <td colspan="3" class="tdLight"><input name="pai" type="text" class="caixa" id="pai" value="<%= banco.getCampo("pai", rs) %>" size="50" maxlength="50"></td>
		</tr>
		<tr>
		  <td class="tdMedium"> Nome da Mãe:</td>
		  <td colspan="3" class="tdLight"><input name="mae" type="text" class="caixa" id="mae" value="<%= banco.getCampo("mae", rs) %>" size="50" maxlength="50"></td>
		</tr>
		<tr>
		  <td class="tdMedium"> Religião:</td>
		  <td class="tdLight"><input name="religiao" type="text" class="caixa" id="religiao" value="<%= banco.getCampo("religiao", rs) %>" size="40" maxlength="50"></td>
		  <td class="tdMedium"> PIS/PASEP:</td>
		  <td class="tdLight"><input name="pis_pasep" type="text" class="caixa" id="pis_pasep" value="<%= banco.getCampo("pis_pasep", rs) %>" size="15" maxlength="11" onKeyPress="Javascript:OnlyNumbersSemPonto(this, event)"></td>
		</tr>
	 </table>
  </div>
<!-- ABA DE COMPLEMENTO 1 -->

<!-- ABA DE COMPLEMENTO 2 -->
  <div id="aba4" style="width:600px; height:170px; background-color:<%= fundo%>; position: absolute; left:0px; top:165px; z-index:2; overflow: auto">
     <table width="600" border="0" cellpadding="0" cellspacing="0" class="table">
		<tr>
		  <td class="tdMedium">Indicado por: </td>
		  <td class="tdLight">
			<select name="indicacao" id="indicacao" class="caixa">
				<%= paciente.getIndicacoes(cod_empresa)%>
			</select>
		  </td>
		  <td class="tdMedium">Outras Indicações:</td>
		  <td class="tdLight"><input name="indicado_por" type="text" class="caixa" id="indicado_por" value="<%= banco.getCampo("indicado_por", rs) %>" size="25" maxlength="40"></td>
		</tr>
		<tr>
		  <td class="tdMedium">Alertas:</td>
		  <td class="tdLight">
			<input name="btnalerta" style="color:red" id="btnalerta" type="button" class="botao" value="" onClick="abreAlertas()">
		  </td>
		  <td class="tdMedium">Situação: *</td>
		  <td class="tdLight">
				<select name="status" id="status" class="caixa">
					<option value="0">Ativo</option>
					<option value="1">Inativo</option>
					<option value="2">Falecido</option>
				</select>
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
		  <td class="tdMedium">Observação:</td>
		  <td colspan="3" class="tdLight"><textarea name="obs" class="caixa" id="obs" cols="80" rows="4" style="overflow:auto"><%= banco.getCampo("obs", rs) %></textarea></td>
		</tr>
	 </table>
  </div>
<!-- ABA DE COMPLEMENTO 2 -->

<!-- ABA DE CONVÊNIOS -->
  <div id="aba5" style="width:600px; height:170px; background-color:<%= fundo%>; position: absolute; left:0px; top:165px; z-index:2; overflow: auto">
	 <table width="100%" border="0" cellpadding="0" cellspacing="0" class="table">
		<tr>
			<td colspan="6" class="tdDark" align="center">Convênios</td>
		</tr>
		<tr>
			<td colspan="6">
				<table width="100%" cellpadding="0" cellspacing="0">
					<tr>
						<td class="tdMedium">Nome</td>
						<td class="tdMedium">Plano</td>
						<td class="tdMedium">nº conv.</td>
						<td class="tdMedium">Validade</td>
						<td class="tdMedium">Ação</td>
					</tr>
					<tr>
						<td class="tdLight">
							<input type="hidden" name="cod_convenio" id="cod_convenio">			
							<input size="38" class="caixa" type="text" name="descr_convenio" id="descr_convenio" onKeyUp="buscaconvenios(this.value)">
						</td>
						<td class="tdLight">
							<div id="listaplanos">
								<select name="cod_plano" id="cod_plano" class="caixa" style="width:120px">
									<option value=""></option>
								</select>
							</div>
						</td>
						<td class="tdLight"><div id="nassociado">&nbsp;</div></td>
						<td class="tdLight"><input type="text" name="validade_carteira" id="validade_carteira" class="caixa" size="10" maxlength="10" onKeyPress="return formatar(this, event, '##/##/####'); " onBlur="ValidaData(this);ValidaPassado(this);"></td>
						<td class="tdLight" align="center"><a href="Javascript:incluirconvenio()" title="Inserir Convênio"><img src="images/add.gif" border="0"></a></td>
					</tr>
					<%= paciente.getConvenios(strcod)%>
				</table>
			</td>
		</tr>
	</table>
  </div>
<!-- ABA DE CONVÊNIOS -->

<!-- IFRAME EMBAIXO DAS ABAS -->
  <iframe id="iframeaba" style="position: absolute; left:0px; top:165px; width:600px; height:170px; z-index:1; background-color:<%= fundo%>; border:0"></iframe>
</form>

<!-- DIV para cadastrar nova profissão -->
<div id="divprofissao" style="position: absolute; left:-300px; top:70px; height:100px; width:200px; z-index:1; display:'none'">
	<form name="frmprofissao" id="frmprofissao" method="post" action="gravarnovaprofissao.jsp" target="iframeprofissao">
	<table border="0" cellpadding="0" cellspacing="0" class="table" width="100%">
		<tr>
			<td class="tdMedium">Nova Profissão</td>
		</tr>
		<tr>
			<td class="tdLight"><input type="text" name="novaprofissao" id="novaprofissao" class="caixa" maxlength="100" width="180"></td>
		</tr>
		<tr>
			<td class="tdMedium" align="center">
				<input type="button" class="botao" value="Cadastrar" onClick="Javascript: gravarProfissao()">
				<input type="button" class="botao" value="Cancelar" onClick="Javascript: cancelaCadastro()">
			</td>
		</tr>
	</table>
	</form>
</div>
<iframe name="iframeprofissao" id="iframeprofissao" width="400" height="0" style="display:none"></iframe>
<!-- DIV para cadastrar nova profissão -->
</body>
</html>
