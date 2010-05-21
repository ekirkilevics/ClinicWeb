<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.Hospital" id="hospital" scope="page"/>

<%
	if(strcod != null) rs = banco.getRegistro("hospitais","cod_hospital", Integer.parseInt(strcod) );
	if(Util.isNull(ordem)) ordem = "descricao";
%>

<html>
<head>
<title>Hospitais</title>
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
	 var nome_campos_obrigatorios = Array("Descrição", "CNPJ", "Tipo Logradouro", "Endereço", "UF", "CEP", "Cód. IBGE Município");
	 //Página a enviar o formulário
	 var page = "gravarhospitais.jsp";
	 //Cod. da ajuda
	 cod_ajuda = 27;

     //Campos obrigatórios
	 var campos_obrigatorios = Array("descricao", "cnpj", "tipoLogradouro", "logradouro", "numero", "uf", "cep", "codigoIBGEMunicipio");
	 
	 function iniciar() {
	 	cbeGetElementById("uf").value = "<%= banco.getCampo("uf", rs) %>";
		cbeGetElementById("tipoLogradouro").value = "<%= banco.getCampo("tipoLogradouro", rs) %>";
		inicio();
		barrasessao();
	 }
	 
	function validaCodigoIBGE(obj) {
		if(obj.value.length() > 0 && obj.value.length() != 7) {
			mensagem("Cód. IBGE Município deve ter 7 dígitos",2);
			obj.focus();
		}
	}	

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

<body onLoad="iniciar()">
<%@include file="barrasessao.jsp" %>
<form name="frmcadastrar" id="frmcadastrar" action="gravarhospitais.jsp" method="post">
  <table width="600" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr>
      <td width="651" height="18" class="title">.: Hospitais :.</td>
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
              <td colspan="3" class="tdLight"><input type="text" class="caixa" name="descricao" id="descricao" value="<%= banco.getCampo("descricao", rs) %>" maxlength="100" size="85"></td>
            </tr>
            <tr>
              <td class="tdMedium">CNPJ: *</td>
              <td class="tdLight"><input type="text" class="caixa" name="cnpj" id="cnpj" value="<%= banco.getCampo("cnpj", rs) %>" maxlength="18" size="20" onKeyPress="return formatar(this, event, '##.###.###/####-##'); "></td>
              <td class="tdMedium">CNES: </td>
              <td class="tdLight"><input type="text" class="caixa" name="cnes" id="cnes" value="<%= banco.getCampo("cnes", rs) %>" maxlength="7" size="10"></td>
            </tr>
			<tr>
				<td class="tdMedium">Tipo Logradouro: *</td>
				<td class="tdLight">
					<select name="tipoLogradouro" id="tipoLogradouro" class="caixa" style="width:120px">
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
				<td class="tdMedium">Endere&ccedil;o: *</td>
				<td class="tdLight"><input type="text" class="caixa" name="logradouro" id="logradouro" value="<%= banco.getCampo("logradouro", rs) %>" maxlength="40" size="50"></td>
		    </tr>
			<tr>
				<td class="tdMedium">Número: *</td>
				<td colspan="3">
					<table cellpadding="0" cellspacing="0" width="100%">
						<tr>
							<td class="tdLight"><input type="text" class="caixa" name="numero" id="numero" value="<%= banco.getCampo("numero", rs) %>" size="8" maxlength="5"></td>
							<td class="tdMedium">UF: *</td>
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
					</table>
				</td>
			</tr>
			<tr>
				<td class="tdMedium">CEP: *</td>
				<td colspan="3">
					<table cellpadding="0" cellspacing="0" width="100%">
						<tr>
							<td class="tdLight"><input type="text" class="caixa" name="cep" id="cep" value="<%= banco.getCampo("cep", rs) %>" size="10" maxlength="9" onKeyPress="return formatar(this, event, '#####-###');"></td>
							<td class="tdMedium">Cód. IBGE Município: *</td>
							<td class="tdLight"><input type="text" class="caixa" name="codigoIBGEMunicipio" id="codigoIBGEMunicipio" value="<%= banco.getCampo("codigoIBGEMunicipio", rs) %>" style="width:100%" maxlength="7" onBlur="validaCodigoIBGE(this)"></td>
						</tr>
					</table>
				</td>
			</tr>
          </table>
      </td>
    </tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
		<%= Util.getBotoes("hospitais", pesq, tipo) %>
	<tr>
		<td>&nbsp;</td>
	</tr>
    <tr>
		<td width="100%" style="text-align:center">
			<table width="600px">
				<tr>
					<td width="100%" class="tdDark">Hospitais</td>
				</tr>
			</table>
			<div style="width:600; height:101; overflow: auto">
				<table width="100%">
				    <%
						String resp[] = hospital.getHospitais(pesq, "descricao", ordem, numPag, 50, tipo, cod_empresa);
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
