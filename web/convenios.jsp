<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.Convenio" id="convenio" scope="page"/>
<jsp:useBean class="recursos.Faturamento" id="faturamento" scope="page"/>

<%
	if(strcod != null) rs = banco.getRegistro("convenio","cod_convenio", Integer.parseInt(strcod));
	if(ordem == null) ordem = "descr_convenio";
	
	String prof_reg = request.getParameter("prof_reg");
	String codOperadora = request.getParameter("codOperadora");
	String cod_med = request.getParameter("cod_med");
	
	//Se veio parâmetros do médico, cadastrar
	convenio.cadastraMedico(strcod, prof_reg, codOperadora);
	
	//Exclui o médico
	convenio.excluiMedico(cod_med);
%>

<html>
<head>
<title>Convênios</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
<script language="Javascript" src="CBE/cbe_util.js"></script>
<script language="JavaScript">
     //id do convênio
     var idReg = "<%= strcod%>";
	 //Informação vinda de gravarconvenio
	 var inf = "<%= inf%>";
	 //Nome dos campos
		 var nome_campos_obrigatorios = Array("Nome Fantasia","Razão Social", "Código ANS", "Retorno da consulta", "Pagamento", "Tipo de Identificação", "Código na Operadora");
	 //Página a enviar o formulário
	 var page = "gravarconvenio.jsp";
	 //Cod. da ajuda
	 cod_ajuda = 3;

     //Campos obrigatórios
	 var campos_obrigatorios = Array("sigla","razao","cod_ans", "retorno", "cod_banco", "tipoidentificadoroperadora", "identificadoroperadora");
	 	 
	function setarValores()
	{
		getObj("","uf").value = "<%= banco.getCampo("UF", rs)%>";
		getObj("","cod_banco").value = "<%= banco.getCampo("cod_banco", rs)%>";
		getObj("","tipoidentificadoroperadora").value = "<%= banco.getCampo("tipoidentificadoroperadora", rs)%>";
		tamMascara(getObj("","mascaranumconvenio"));
		
		barrasessao();
	}	 
	
	function incluiplano() {
		var frm = cbeGetElementById("frmcadastrar");

		//Se não escolheu o convênio
		if(idReg == "null") {
			mensagem("Selecione o convênio para inserir o plano",2);
			return;
		}
		
		//Se não preencheu o nome do plano
		if(frm.plano.value == "") {
			mensagem("Preecha o nome do plano para inserir", 2);
			return;
		}
			
		frm.action = "gravarplanos.jsp?acao=inc&cod=" + idReg;
		frm.submit();
	}
	
	function removeplano(cod_plano) {
		var frm = cbeGetElementById("frmcadastrar");

		//Não remover plano particular do convênio particular
		if(idReg == "-1" && cod_plano == "-2") {
			alert("Plano Particular do convênio Particular não pode ser excluído");
			return;
		}

		conf = confirm("Tem certeza que deseja excluir esse plano do convênio?\nOs valores de procedimentos cadastrados para esse plano serão excluídos e o plano será removido dos pacientes","Confirmação de Exclusão");
		if(conf) {
			frm.action = "gravarplanos.jsp?acao=exc&cod=" + idReg + "&id=" + cod_plano;
			frm.submit();
		}
	}
	
	var qtdabas;
	function iniciar() {
		qtdabas = 6;
		centralizarabas(qtdabas);
		abaatual = "<%= aba%>";
		alteraraba(abaatual,qtdabas,tdmedium,tddark);
		
		//Se for a aba de planos, focus no nome do plano
		if(abaatual == "4")
			cbeGetElementById("plano").focus();
		
		inicio();
		setarValores();
		window.onresize=iniciar;

	}
	
	function excluirconvenio() {
		//Se for particular, não permitir exclusão
		if(idReg == "-1") {
			alert("Convênio Particular não pode ser excluído!");
			return;
		}

		enviarAcao('exc');
	}
	
	function validaCNS(obj) {
		if(obj.value.length > 0 &&obj.value.length != 6) {
			alert("Cód. ANS deve ter 6 dígitos. \nSe necessário, complete com zeros à erquerda");
			obj.focus();
			return;
		}
	}
	
	function incluimedico() {
		var frm = cbeGetElementById("frmcadastrar");

		//Se não escolheu o convênio
		if(idReg == "null") {
			mensagem("Selecione o convênio para inserir o médico",2);
			return;
		}
		
		//Se não preencheu o nome do médico
		if(frm.prof_reg.value == "") {
			mensagem("Preecha o médico do convênio", 2);
			frm.prof_reg.focus();
			return;
		}

		//Se não preencheu o cód. do médico
		if(frm.codOperadora.value == "") {
			mensagem("Preecha o cód. do médico na operadora", 2);
			frm.codOperadora.focus();
			return;
		}
			
		frm.action = "convenios.jsp?cod=" + idReg;
		frm.submit();
		
	}
	
	function removemedico(cod_med) {
		var frm = cbeGetElementById("frmcadastrar");
		
		conf = confirm("Confirma exclusão do registro?");
		if(conf) {
			frm.action = "convenios.jsp?cod=" + idReg + "&cod_med=" + cod_med;
			frm.submit();
		}
	}	
	
	function tamMascara(obj) {
		cbeGetElementById("contmascara").innerHTML = obj.value.length;
	}
	
	function clickBotaoNovo() {
		botaoNovo();
	}
	
	function clickBotaoSalvar() {
		enviarAcao('inc');
	}
	
	function clickBotaoExcluir() {
		excluirconvenio();
	}	
</script>
</head>

<body onLoad="iniciar();">
<%@include file="barrasessao.jsp" %>
<form name="frmcadastrar" id="frmcadastrar" action="gravarconvenio.jsp" method="post">
  <!-- Campos Ocultos -->
  <input type="hidden" name="ordem" value="<%= ordem%>">
  <!-- Campos Ocultos -->
  <table width="600" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr>
      <td height="18" class="title">.: Conv&ecirc;nios :.</td>
    </tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td align="right"><span name='msg' id='msg' class="msg">&nbsp;</span></td>
	</tr>
    <tr align="center" valign="top">
      <td height="170px">&nbsp; </td>
    </tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<%= Util.getBotoes("convenios", pesq, tipo) %>
	<tr>
		<td>&nbsp;</td>
	</tr>
    <tr>
		<td width="100%" align="center">
			<table width="600px">
				<tr>
					<td width="29%" class="tdDark"><a title="Ordenar por Descrição" href="Javascript:ordenar('convenios','descr_convenio')">Descrição</a></td>
					<td class="tdDark"><a title="Ordenar por Razão Social" href="Javascript:ordenar('convenios','Razao_social')">Razão Social</a></td>
				</tr>
			</table>
			<div style="width:600; height:101; overflow: auto">
				<table width="100%">
				    <%
						String resp[] = convenio.getConvenios(pesq, ordem, numPag, 50, tipo, cod_empresa);
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
  
  <!-- MENU DE ABAS -->
  <div id="menuabas" style="width:600px; height: 20px; background-color:<%= fundo%>; position: absolute; left:0px; top:145px; overflow: auto">
		<input type="hidden" name="numeroaba" id="numeroaba" value="<%= aba%>">
		<table cellpadding="0" cellspacing="0" class="table">
			<tr>
				<td id="tdaba1" class="tdMedium" onClick="Javascript:alteraraba('1',qtdabas, tdmedium, tddark)"> Identificação </td>
				<td id="tdaba2" class="tdMedium" onClick="Javascript:alteraraba('2',qtdabas, tdmedium, tddark)"> Contato </td>
				<td id="tdaba3" class="tdMedium" onClick="Javascript:alteraraba('3',qtdabas, tdmedium, tddark)"> Detalhes </td>
				<td id="tdaba4" class="tdMedium" onClick="Javascript:alteraraba('4',qtdabas, tdmedium, tddark)"> Planos </td>
				<td id="tdaba5" class="tdMedium" onClick="Javascript:alteraraba('5',qtdabas, tdmedium, tddark)"> Médicos </td>
				<td id="tdaba6" class="tdMedium" onClick="Javascript:alteraraba('6',qtdabas, tdmedium, tddark)"> Extraordinário </td>
			</tr>
		</table>
  </div>
<!-- MENU DE ABAS -->
  
<!-- ABA DE IDENTIFICAÇÃO -->
  <div id="aba1" style="width:600px; height:150px; background-color:<%= fundo%>; position: absolute; left:0px; top:165px; z-index:10; overflow: auto">
	 <table width="600" border="0" cellpadding="0" cellspacing="0" class="table">
	  <tr>
		  <td class="tdMedium">Nome Fantasia: *</td>
		  <td colspan="5" class="tdLight"><input name="sigla" type="text" class="caixa" id="sigla" value="<%= banco.getCampo("descr_convenio", rs) %>" style="width:100%" maxlength="80"></td>
	  </tr>
	  <tr>
		  <td class="tdMedium">Razão Social: *</td>
		  <td colspan="5" class="tdLight"><input name="razao" type="text" class="caixa" id="razao" value="<%= banco.getCampo("Razao_social", rs) %>" style="width:100%" maxlength="80"></td>
	  </tr>
	  <tr>
		  <td class="tdMedium">CNPJ:</td>
		  <td colspan="2" class="tdLight"><input name="cnpj" type="text" class="caixa" id="cnpj" onKeyPress="return formatar(this, event, '##.###.###/####-##'); " value="<%= banco.getCampo("CGC", rs) %>" size="18" maxlength="18" onBlur="valida_cpf_cnpj(this)"></td>
		  <td class="tdMedium">Código ANS: *</td>
		  <td colspan="2" class="tdLight"><input name="cod_ans" type="text" class="caixa" id="cod_ans" value="<%= banco.getCampo("cod_ans", rs) %>" size="10" maxlength="6" onKeyPress="Javascript:OnlyNumbersSemPonto(this,event);" onBlur="validaCNS(this)"></td>
		</tr>
		<tr>
			<td class="tdMedium">Endere&ccedil;o:</td>
			<td colspan="5" class="tdLight"><input name="endereco" type="text" class="caixa" id="endereco" value="<%= banco.getCampo("Endereco", rs) %>" style="width:100%" maxlength="100"></td>
		</tr>
		<tr>
			  <td class="tdMedium">Número:</td>
			  <td class="tdLight"><input name="numero" type="text" class="caixa" id="numero" value="<%= banco.getCampo("numero", rs) %>" size="10" maxlength="5"></td>
			  <td  class="tdMedium">Complemento:</td>
			  <td colspan="3" class="tdLight"><input name="complemento" type="text" class="caixa" id="complemento" value="<%= banco.getCampo("complemento", rs) %>" style="width:100%" maxlength="50"></td>
		</tr>
		<tr>
		  <td class="tdMedium">Cidade:</td>
		  <td class="tdLight"><input name="cidade" type="text" class="caixa" id="cidade" value="<%= banco.getCampo("Cidade", rs) %>" size="20" maxlength="30"></td>
		  <td class="tdMedium">UF:</td>
		  <td class="tdLight">
				<select name="uf" class="caixa" id="uf">
					<option value="" ></option>
					<option value=AC >AC </option>
					<option value=AL >AL </option>
					<option value=AM >AM </option>
					<option value=AP >AP </option>
					<option value=BA >BA </option>
					<option value=CE >CE </option>
					<option value=DF >DF </option>
					<option value=ES >ES </option>
					<option value=GO >GO </option>
					<option value=MA >MA </option>
					<option value=MG >MG </option>
					<option value=MS >MS </option>
					<option value=MT >MT </option>
					<option value=PA >PA </option>
					<option value=PB >PB </option>
					<option value=PE >PE </option>
					<option value=PI >PI </option>
					<option value=PR >PR </option>
					<option value=RJ >RJ </option>
					<option value=RN >RN </option>
					<option value=RO >RO </option>
					<option value=RR >RR </option>
					<option value=RS >RS </option>
					<option value=SC >SC </option>
					<option value=SE >SE </option>
					<option value=SP SELECTED>SP </option>
					<option value=TO >TO </option>
					</select>
		  </td>
		  <td class="tdMedium">CEP:</td>
		  <td class="tdLight"><input name="cep" type="text" class="caixa" id="cep" onKeyPress="return formatar(this, event, '#####-###');" value="<%= banco.getCampo("CEP", rs) %>" size=9 maxlength="9"></td>
		</tr>
		
	</table>
  </div>
<!-- ABA DE IDENTIFICAÇÃO -->

<!-- ABA DE CONTATO -->
  <div id="aba2" style="width:600px; height:150px; background-color:<%= fundo%>; position: absolute; left:0px; top:165px; z-index:2; overflow: auto">
	<table width="100%" cellpadding="0" cellspacing="0" class="table">
	  <tr>
		  <td class="tdMedium">Contato:</td>
		  <td class="tdLight"><input name="contato" type="text" class="caixa" id="contato" value="<%= banco.getCampo("Contato", rs) %>" size="20" maxlength="50"></td>
		  <td class="tdMedium">Telefone:</td>
		  <td colspan="3" class="tdLight">
			(<input name="ddd" type="text" class="caixa" id="ddd" value="<%= banco.getCampo("DDD", rs) %>" size="2" maxlength="2" onKeyPress="Javascript:OnlyNumbers(this,event);">) &nbsp;&nbsp;&nbsp;&nbsp;
			<input name="tel" type="text" class="caixa" id="tel" onKeyPress="return formatar(this, event, '####-####')" value="<%= banco.getCampo("Telefone", rs) %>" size="9" maxlength="9">&nbsp;&nbsp;&nbsp;
			Ramal:<input name="ramal" type="text" class="caixa" id="ramal" value="<%= banco.getCampo("Ramal", rs) %>" size="6" maxlength="10"></td>
		</tr>
		<tr>
			  <td class="tdMedium">Fax:</td>
			  <td class="tdLight">
				(<input name="dddfax" type="text" class="caixa" id="dddfax" value="<%= banco.getCampo("DDD_FAX", rs) %>" size="2" maxlength="2" onKeyPress="Javascript:OnlyNumbers(this,event);">)&nbsp
				<input name="telfax" type="text" class="caixa" id="telfax" onKeyPress="return formatar(this, event, '####-####')" value="<%= banco.getCampo("Fax", rs) %>" size="9" maxlength="9"></td>
			  <td class="tdMedium">e-mail:</td>
			  <td colspan="3" class="tdLight"><input name="email" type="text" class="caixa" id="email" value="<%= banco.getCampo("email", rs) %>" style="width:100%" maxlength="50" onBlur="validaemail(this)"></td>
		</tr>
		
	</table>
  </div>
  <!-- ABA DE CONTATO -->
  
  <!-- ABA DE DETALHES -->
  <div id="aba3" style="width:600px; height:150px; background-color:<%= fundo%>; position: absolute; left:0px; top:165px; z-index:2; overflow: auto">
     <table width="600" border="0" cellpadding="0" cellspacing="0" class="table">
		<tr>
			<td class="tdMedium">Retorno consulta: *</td>		
		  	<td colspan="2" class="tdLight"><input name="retorno" type="text" class="caixa" id="retorno" onKeyPress="Javascript:OnlyNumbers(this,event);" value="<%= banco.getCampo("retorno_consulta", rs) %>" size="2" maxlength="3"> dias</td>
		  	<td class="tdMedium">Pagamento: *</td>
		  	<td colspan="2" class="tdLight">
				<select name="cod_banco" id="cod_banco" class="caixa" style="width:160px">
					<option value=""><-- Selecione a conta --></option>
					<%= convenio.getBancos(cod_empresa)%>
				</select>
		  	</td>
		</tr>
		<tr>
			<td class="tdMedium">Dias para recurso:</td>		
		  	<td colspan="2" class="tdLight"><input name="diasrecurso" type="text" class="caixa" id="diasrecurso" onKeyPress="Javascript:OnlyNumbers(this,event);" value="<%= banco.getCampo("diasrecurso", rs) %>" size="2" maxlength="3"> dias</td>
			<td class="tdMedium">Vezes para recurso:</td>		
		  	<td colspan="2" class="tdLight"><input name="qtderecurso" type="text" class="caixa" id="qtderecurso" onKeyPress="Javascript:OnlyNumbers(this,event);" value="<%= banco.getCampo("qtderecurso", rs) %>" size="2" maxlength="3"> vezes</td>
		</tr>
		<tr>
		  <td class="tdMedium">Máscara do associado:</td>
		  <td colspan="5" class="tdLight">
		  	<input onKeyUp="tamMascara(this)" name="mascaranumconvenio" type="text" class="caixa" id="mascaranumconvenio" value="<%= banco.getCampo("mascaranumconvenio", rs) %>" maxlength="30"> Ex.: ##.###-##
			 (<span id="contmascara">0</span> caracteres )
		  </td>
		</tr>
		<tr>
			<td class="tdMedium">Tipo Identificação: *</td>		
		  	<td colspan="2" class="tdLight">
				<select name="tipoidentificadoroperadora" id="tipoidentificadoroperadora" class="caixa">
					<option value="1">CNPJ</option>
					<option value="2">Código na Operadora</option>
					<option value="3">CPF</option>
				</select>
			</td>
			<td class="tdMedium">Cód. na Operadora: *</td>		
		  	<td colspan="2" class="tdLight"><input name="identificadoroperadora" type="text" class="caixa" id="identificadoroperadora" value="<%= banco.getCampo("identificadoroperadora", rs) %>" size="15" maxlength="15"></td>
		</tr>
	  </table>
    </div>
  <!-- ABA DE DETALHES -->

  <!-- ABA DE PLANOS -->
  <div id="aba4" style="width:600px; height:150px; background-color:<%= fundo%>; position: absolute; left:0px; top:165px; z-index:2; overflow: auto">
     <table width="600" border="0" cellpadding="0" cellspacing="0" class="table">
		<tr>
			<td colspan="5" class="tdMedium">Planos</td>
			<td class="tdMedium" align="center">Ação</td>
		</tr>
		<tr>
			<td colspan="5" class="tdLight">
				<input type="text" name="plano" id="plano" class="caixa" maxlength="50" style="width: 90%">
			</td>
			<td class="tdLight" align="center"><a href="Javascript: incluiplano()" title="Incluir Plano"><img src="images/add.gif" border="0"></a></td>
		</tr>
		<%= convenio.getPlanos(strcod)%>
	  </table>
    </div>
  <!-- ABA DE PLANOS -->

  <!-- ABA DE MÉDICOS -->
  <div id="aba5" style="width:600px; height:150px; background-color:<%= fundo%>; position: absolute; left:0px; top:165px; z-index:2; overflow: auto">
     <table width="600" border="0" cellpadding="0" cellspacing="0" class="table">
		<tr>
			<td class="tdMedium">Profissional</td>
			<td class="tdMedium">Cód. da Operadora</td>
			<td class="tdMedium" align="center">Ação</td>
		</tr>
		<tr>
			<td class="tdLight">
			  	<select name="prof_reg" id="prof_reg" class="caixa" style="width: 300px">
					<option value=""></option>
					<%= faturamento.getProfissionais(cod_empresa) %>
				</select>
			</td>
			<td class="tdLight"><input type="text" name="codOperadora" id="codOperadora" size="10" class="caixa"></td>
			<td class="tdLight" align="center"><a href="Javascript: incluimedico()" title="Incluir Médico"><img src="images/add.gif" border="0"></a></td>
		</tr>
		<%= convenio.getMedicos(strcod)%>
	  </table>
    </div>
  <!-- ABA DE MÉDICOS -->

<!-- ABA DE EXTRAORDINÁRIO -->
  <div id="aba6" style="width:600px; height:150px; background-color:<%= fundo%>; position: absolute; left:0px; top:165px; z-index:2; overflow: auto">
     <table width="600" border="0" cellpadding="0" cellspacing="0" class="table">
		<tr>
			<td class="tdMedium">Extra Semana:</td>
			<td class="tdLight">
				das <input type="text" name="iniciosemana" id="iniciosemana" class="caixa" size="5" maxlength="5" onBlur="ValidaHora(this)" onKeyPress="formatar(this, event, '##:##'); " value="<%= Util.formataHora(banco.getCampo("iniciosemana", rs)) %>">
				às <input type="text" name="fimsemana" id="fimsemana" class="caixa" size="5" maxlength="5" onBlur="ValidaHora(this)" onKeyPress="formatar(this, event, '##:##'); " value="<%= Util.formataHora(banco.getCampo("fimsemana", rs)) %>">
			</td>
		</tr>
		<tr>
			<td class="tdMedium">Extra Sábado:</td>
			<td class="tdLight">
				das <input type="text" name="iniciosabado" id="iniciosabado" class="caixa" size="5" maxlength="5" onBlur="ValidaHora(this)" onKeyPress="formatar(this, event, '##:##'); " value="<%= Util.formataHora(banco.getCampo("iniciosabado", rs)) %>">
				às <input type="text" name="fimsabado" id="fimsabado" class="caixa" size="5" maxlength="5" onBlur="ValidaHora(this)" onKeyPress="formatar(this, event, '##:##'); " value="<%= Util.formataHora(banco.getCampo("fimsabado", rs)) %>">
			</td>
		</tr>
	 </table>
  </div>
<!-- ABA DE EXTRAORDINÁRIO -->

<!-- IFRAME EMBAIXO DAS ABAS -->
  <iframe id="iframeaba" style="position: absolute; left:0px; top:165px; width:600px; height:150px; z-index:1; background-color:<%= fundo%>; border:0"></iframe>
</form>

</body>
</html>
