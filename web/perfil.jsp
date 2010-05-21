<%@include file="cabecalho.jsp" %>

<%
	strcod = configuracao.getItemConfig("config_id", cod_empresa);
%>

<html>
<head>
<title>Perfil da Empresa</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
<script language="Javascript" src="CBE/cbe_util.js"></script>
<script language="JavaScript">
     //id do convênio
     var idReg = "<%= strcod%>";
	 //Informação vinda de gravardiagnostico
	 var inf = "<%= inf%>";
	 //Nome dos campos
	 var nome_campos_obrigatorios = Array("Razão Social", "Nome Fantasia");
	 //Página a enviar o formulário
	 var page = "gravarperfil.jsp";
	 //Cod. da ajuda
	 cod_ajuda = 4;

     //Campos obrigatórios
	 var campos_obrigatorios = Array("nomeContratado", "nomeFantasia");

	var jsusardefinitivo = "<%= configuracao.getItemConfig("usardefinitivo", cod_empresa)%>";
	var jsbloquearcarteiravencida = "<%= configuracao.getItemConfig("bloquearcarteiravencida", cod_empresa)%>";

	function iniciar() {
		mensagem(inf,0);
		barraStatus();
		window.defaultStatus = "..:: Clinic Web ::.."
		barrasessao();
		
		cbeGetElementById("tipoLogradouro").value = "<%= configuracao.getItemConfig("tipoLogradouro", cod_empresa)%>";
		cbeGetElementById("uf").value = "<%= configuracao.getItemConfig("uf", cod_empresa)%>";
		
		if(jsusardefinitivo == "S")
			cbeGetElementById("usardefinitivo").checked = true;
		if(jsbloquearcarteiravencida == "S")
			cbeGetElementById("bloquearcarteiravencida").checked = true;
	}
	
	function incluirbanco() {
		var frm = cbeGetElementById("frmcadastrar");
		if(cbeGetElementById("banco").value == "") {
			mensagem("Insira o nome do Banco",2);
			cbeGetElementById("banco").focus();
			return;
		}
		
		if(cbeGetElementById("agencia").value == "") {
			mensagem("Insira o número da agência",2);
			cbeGetElementById("agencia").focus();
			return;
		}
		
		if(cbeGetElementById("conta").value == "") {
			mensagem("Insira o número da conta",2);
			cbeGetElementById("conta").focus();
			return;
		}
		frm.action = "gravarbancos.jsp?acao=inc";
		frm.submit();
	}
	
	function excluirbanco(codbanco) {
		conf = confirm("Confirma exclusão da Conta?");
		if(conf) {
			window.location = "gravarbancos.jsp?acao=exc&id=" + codbanco;
		}
	}
	
	function validaCodigoIBGE(obj) {
		if(obj.value.length() > 0 && obj.value.length() != 7) {
			mensagem("Cód. IBGE Município deve ter 7 dígitos",2);
			obj.focus();
		}
	}	

</script>
</head>

<body onLoad="iniciar()">
<%@include file="barrasessao.jsp" %>
<form name="frmcadastrar" id="frmcadastrar" action="gravarperfil.jsp" method="post">
  <table width="600" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr>
      <td height="18" class="title">.: Perfil da Empresa :.</td>
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
				<td class="tdMedium">Razão Social:</td>
				<td colspan="3" class="tdLight"><input type="text" class="caixa" name="nomeContratado" id="nomeContratado" value="<%= configuracao.getItemConfig("nomeContratado", cod_empresa)%>" maxlength="70" style="width: 100%"></td>
			</tr>
            <tr>
				<td class="tdMedium">Nome Fantasia:</td>
				<td colspan="3" class="tdLight"><input type="text" class="caixa" name="nomeFantasia" id="nomeFantasia" value="<%= configuracao.getItemConfig("nomeFantasia", cod_empresa)%>" maxlength="70" style="width: 100%"></td>
			</tr>
			<tr>
				<td class="tdMedium">CNPJ:</td>
				<td class="tdLight"><input type="text" class="caixa" name="cod_operadora" id="cod_operadora" value="<%= configuracao.getItemConfig("cod_operadora", cod_empresa)%>" maxlength="18" size="20" onKeyPress="return formatar(this, event, '##.###.###/####-##'); "></td>
				<td class="tdMedium">CNES: </td>
				<td class="tdLight"><input type="text" class="caixa" name="codCNES" id="codCNES" value="<%= configuracao.getItemConfig("codCNES", cod_empresa)%>" maxlength="50" size="20"></td>
			</tr>
			<tr>
				<td class="tdMedium">Tipo Logradouro:</td>
				<td class="tdLight">
					<select name="tipoLogradouro" id="tipoLogradouro" class="caixa" style="width:100px">
						<option value="645"/>ACAMPAMENTO</option>
						<option value="001"/>ACESSO</option>
						<option value="002"/>ADRO</option>
						<option value="501"/>AEROPORTO</option>
						<option value="004"/>ALAMEDA </option>
						<option value="005"/>ALTO</option>
						<option value="472"/>AREA</option>
						<option value="654"/>AREA ESPECIAL</option>
						<option value="465"/>ARTERIA</option>
						<option value="007"/>ATALHO</option>
						<option value="008"/>AVENIDA</option>
						<option value="651"/>AVENIDA CONTORNO</option>
						<option value="015"/>BAIXA</option>
						<option value="470"/>BALAO</option>
						<option value="009"/>BALNEÁRIO</option>
						<option value="011"/>BECO</option>
						<option value="010"/>BELVEDERE</option>
						<option value="012"/>BLOCO</option>
						<option value="013"/>BOSQUE</option>
						<option value="014"/>BOULEVARD</option>
						<option value="496"/>BURACO</option>
						<option value="016"/>CAIS</option>
						<option value="571"/>CALÇADA</option>
						<option value="017"/>CAMINHO</option>
						<option value="023"/>CAMPO</option>
						<option value="495"/>CANAL</option>
						<option value="481"/>CHÁCARA</option>
						<option value="019"/>CHAPADÃO</option>
						<option value="479"/>CIRCULAR</option>
						<option value="021"/>COLÔNIA</option>
						<option value="503"/>COMPLEXO VIÁRIO</option>
						<option value="485"/>CONDOMÍNIO</option>
						<option value="020"/>CONJUNTO</option>
						<option value="022"/>CORRREDOR</option>
						<option value="024"/>CÓRREGO</option>
						<option value="478"/>DESCIDA</option>
						<option value="027"/>DESVIO</option>
						<option value="028"/>DISTRITO</option>
						<option value="468"/>ELEVADA</option>
						<option value="573"/>ENTRADA PARTICULAR</option>
						<option value="652"/>ENTRE QUADRA</option>
						<option value="030"/>ESCADA</option>
						<option value="474"/>ESPLANADA</option>
						<option value="032"/>ESTAÇÃO</option>
						<option value="564"/>ESTACIONAMENTO</option>
						<option value="033"/>ESTADIO</option>
						<option value="498"/>ESTÂNCIA</option>
						<option value="031"/>ESTRADA</option>
						<option value="650"/>ESTRADA MUNICIPAL</option>
						<option value="036"/>FAVELA</option>
						<option value="037"/>FAZENDA</option>
						<option value="040"/>FEIRA</option>
						<option value="038"/>FERROVIA</option>
						<option value="039"/>FONTE</option>
						<option value="043"/>FORTE</option>
						<option value="045"/>GALERIA</option>
						<option value="046"/>GRANJA</option>
						<option value="486"/>HABITACIONAL</option>
						<option value="050"/>ILHA</option>
						<option value="052"/>JARDIM</option>
						<option value="473"/>JARDINETE</option>
						<option value="053"/>LADEIRA</option>
						<option value="499"/>LAGO</option>
						<option value="055"/>LAGOA</option>
						<option value="054"/>LARGO</option>
						<option value="056"/>LOTEAMENTO</option>
						<option value="477"/>MARINA</option>
						<option value="497"/>MÓDULO</option>
						<option value="060"/>MONTE</option>
						<option value="059"/>MORRO</option>
						<option value="500"/>NÚCLEO</option>
						<option value="067"/>PARADA</option>
						<option value="471"/>PARADOURO</option>
						<option value="062"/>PARALELA</option>
						<option value="072"/>PARQUE</option>
						<option value="074"/>PASSAGEM</option>
						<option value="502"/>PASSAGEM SUBTERRÂNEA</option>
						<option value="073"/>PASSARELA</option>
						<option value="063"/>PASSEIO</option>
						<option value="064"/>PÁTIO</option>
						<option value="483"/>PONTA</option>
						<option value="076"/>PONTE</option>
						<option value="469"/>PORTO</option>
						<option value="065"/>PRAÇA</option>
						<option value="504"/>PRAÇA DE ESPORTES</option>
						<option value="070"/>PRAIA</option>
						<option value="071"/>PROLONGAMENTO</option>
						<option value="077"/>QUADRA</option>
						<option value="079"/>QUINTA</option>
						<option value="475"/>QUINTAS</option>
						<option value="082"/>RAMAL</option>
						<option value="482"/>RAMPA</option>
						<option value="087"/>RECANTO</option>
						<option value="487"/>RESIDENCIAL</option>
						<option value="089"/>RETA</option>
						<option value="088"/>RETIRO</option>
						<option value="091"/>RETORNO</option>
						<option value="569"/>RODO ANEL</option>
						<option value="090"/>RODOVIA</option>
						<option value="506"/>ROTATÓRIA</option>
						<option value="476"/>RÓTULA</option>
						<option value="081"/>RUA</option>
						<option value="653"/>RUA DE LIGAÇÃO</option>
						<option value="566"/>RUA DE PEDESTRE</option>
						<option value="094"/>SERVIDÃO</option>
						<option value="095"/>SETOR</option>
						<option value="092"/>SÍTIO</option>
						<option value="096"/>SUBIDA</option>
						<option value="098"/>TERMINAL</option>
						<option value="100"/>TRAVESSA</option>
						<option value="570"/>TRAVESSA PARTICULAR</option>
						<option value="452"/>TRECHO</option>
						<option value="099"/>TREVO</option>
						<option value="097"/>TRINCHEIRA</option>
						<option value="567"/>TÚNEL</option>
						<option value="480"/>UNIDADE</option>
						<option value="565"/>VALA </option>
						<option value="106"/>VALE</option>
						<option value="568"/>VARIANTE</option>
						<option value="453"/>VEREDA</option>
						<option value="101"/>VIA</option>
						<option value="572"/>VIA DE ACESSO</option>
						<option value="484"/>VIA DE PEDESTRE</option>
						<option value="505"/>VIA ELEVADO </option>
						<option value="646"/>VIA EXPRESSA</option>
						<option value="103"/>VIADUTO</option>
						<option value="105"/>VIELA</option>
						<option value="104"/>VILA</option>
						<option value="108"/>ZIGUE-ZAGUE</option>
					</select>
				</td>
				<td class="tdMedium">Endere&ccedil;o:</td>
				<td class="tdLight"><input type="text" class="caixa" name="logradouro" id="logradouro" value="<%= configuracao.getItemConfig("logradouro", cod_empresa)%>" maxlength="40" size="35"></td>
		    </tr>
			<tr>
				<td class="tdMedium">Número:</td>
				<td class="tdLight"><input type="text" class="caixa" name="numero" id="numero" value="<%= configuracao.getItemConfig("numero", cod_empresa)%>" size="8" maxlength="5"></td>
				<td class="tdMedium">Complemento:</td>
				<td class="tdLight"><input type="text" class="caixa" name="complemento" id="complemento" value="<%= configuracao.getItemConfig("complemento", cod_empresa)%>" size="35" maxlength="15"></td>
			</tr>
			<tr>
				<td class="tdMedium">Cidade:</td>
				<td class="tdLight"><input style="width:100%" maxlength="30" type="text" name="cidade" id="cidade" class="caixa" value="<%= configuracao.getItemConfig("cidade", cod_empresa)%>"></td>
				<td class="tdMedium">UF:</td>
				<td class="tdLight">
						<select name="uf" class="caixa" id="uf">
							<option value="" ></option>
							<option value=AC >AC</option>
							<option value=AL >AL</option>
							<option value=AM >AM</option>
							<option value=AP >AP</option>
							<option value=BA >BA</option>
							<option value=CE >CE</option>
							<option value=DF >DF</option>
							<option value=ES >ES</option>
							<option value=GO >GO</option>
							<option value=MA >MA</option>
							<option value=MG >MG</option>
							<option value=MS >MS</option>
							<option value=MT >MT</option>
							<option value=PA >PA</option>
							<option value=PB >PB</option>
							<option value=PE >PE</option>
							<option value=PI >PI</option>
							<option value=PR >PR</option>
							<option value=RJ >RJ</option>
							<option value=RN >RN</option>
							<option value=RO >RO</option>
							<option value=RR >RR</option>
							<option value=RS >RS</option>
							<option value=SC >SC</option>
							<option value=SE >SE</option>
							<option value=SP >SP</option>
							<option value=TO >TO</option>
						</select>
				  </td>
				</tr>
			<tr>
				<td class="tdMedium">CEP:</td>
				<td class="tdLight"><input type="text" class="caixa" name="cep" id="cep" value="<%= configuracao.getItemConfig("cep", cod_empresa)%>" size="10" maxlength="9" onKeyPress="return formatar(this, event, '#####-###');"></td>
				<td class="tdMedium">Cód. IBGE Município:</td>
				<td class="tdLight"><input type="text" class="caixa" name="codigoIBGEMunicipio" id="codigoIBGEMunicipio" value="<%= configuracao.getItemConfig("codigoIBGEMunicipio", cod_empresa)%>" style="width:100%" maxlength="7" onBlur="validaCodigoIBGE(this)"></td>
			</tr>
			<tr>
              <td class="tdMedium">Cabeçalho: </td>
              <td colspan="3" class="tdLight"><textarea style="width:90%" rows="5" name="cabecalho" id="cabecalho" class="caixa"><%= configuracao.getItemConfig("cabecalho", cod_empresa)%></textarea></td>
            </tr>
            <tr>
              <td class="tdMedium">Rodapé: </td>
              <td colspan="3" class="tdLight"><textarea style="width:90%" rows="5" name="rodape" id="rodape" class="caixa"><%= configuracao.getItemConfig("rodape", cod_empresa)%></textarea></td>
            </tr>
			<tr>
				<td class="tdMedium">Site:</td>
				<td colspan="3" class="tdLight"><input size="50" maxlength="50" type="text" name="site" id="site" class="caixa" value="<%= configuracao.getItemConfig("site", cod_empresa)%>"></td>
			</tr>
			<tr>
				<td class="tdMedium">Início do Atendimento:</td>
				<td class="tdLight"><input size="10" maxlength="5" type="text" name="inicio" id="inicio" class="caixa" value="<%= Util.formataHora(configuracao.getItemConfig("inicio_atendimento", cod_empresa))%>" onKeyPress="return formatar(this, event, '##:##'); "></td>
				<td class="tdMedium">Fim do Atendimento:</td>
				<td class="tdLight"><input size="10" maxlength="5" type="text" name="fim" id="fim" class="caixa" value="<%= Util.formataHora(configuracao.getItemConfig("fim_atendimento", cod_empresa))%>" onKeyPress="return formatar(this, event, '##:##'); "></td>
			</tr>
			<tr>
				<td class="tdMedium">Tempo de aviso do SMS:</td>
				<td class="tdLight"><input size="10" maxlength="2" type="text" name="horasenviosms" id="horasenviosms" class="caixa" value="<%= Util.formataHora(configuracao.getItemConfig("horasenviosms", cod_empresa))%>" onKeyPress="return formatar(this, event, '###'); "> horas</td>
				<td class="tdMedium">Telefones:</td>
				<td class="tdLight"><input size="20" maxlength="20" type="text" name="telefone" id="telefone" class="caixa" value="<%= configuracao.getItemConfig("telefone", cod_empresa)%>"> </td>
			</tr>
			<tr>
				<td class="tdMedium" align="right"><input type="checkbox" name="usardefinitivo" id="usardefinitivo" value="S"></td>
				<td class="tdLight">Ativar História Definitiva</td>
				<td class="tdMedium" align="right"><input type="checkbox" name="bloquearcarteiravencida" id="bloquearcarteiravencida" value="S"></td>
				<td class="tdLight">Bloquear carteira vencida</td>
			</tr>
            <tr>
            	<td class="tdMedium">Expiração de Senha: *</td>
                <td colspan="3" class="tdLight"><input type="text" name="qtdediasexpirasenha" id="qtdediasexpirasenha" class="caixa" maxlength="5" size="8" value="<%= configuracao.getItemConfig("qtdediasexpirasenha", cod_empresa)%>" onKeyPress="return formatar(this, event, '#####'); "> dias
            
			<tr align="center" valign="top">
			  <td colspan="4" width="100%">
					<table width="100%" border="0" cellpadding="0" cellspacing="0">
						<tr>
							<td class="tdMedium" style="text-align:center"><button name="salvar" id="salvar" type="button" class="botao" style="width:100px" onClick="enviarAcao('inc')"><img src="images/gravamini.gif" height="17">&nbsp;&nbsp;&nbsp;&nbsp;Salvar</button></td>
						</tr>
					</table>
			  </td>
			</tr>
		</table>
	</tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td width="100%">
			<table width="100%" cellpadding="0" cellspacing="0" class="table">
				<tr>
					<td class="tdDark" align="center">Contas</td>
				</tr>
				<tr>
					<td width="100%">
						<table cellpadding="0" cellspacing="0" width="100%">
							<tr>
								<td height="21" class="tdMedium">Banco</td>
								<td class="tdMedium">Agência</td>
								<td class="tdMedium">Conta</td>
								<td class="tdMedium">Ação</td>
							</tr>
							<tr>
								<td class="tdLight"><input type="text" class="caixa" size="30" maxlength="50" name="banco" id="banco"></td>
								<td class="tdLight"><input type="text" class="caixa" size="10" maxlength="10" name="agencia" id="agencia"></td>
								<td class="tdLight"><input type="text" class="caixa" size="15" maxlength="15" name="conta" id="conta"></td>
								<td class="tdLight" align="center"><a href="Javascript:incluirbanco()" title="Incluir Conta"><img src="images/add.gif" border="0"></a></td>
							</tr>
							<%= configuracao.getBancos(cod_empresa)%>
						</table>
					</td>
				</tr>
			</table>
	  </td>
    </tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
  </table>
</form>

</body>
</html>
