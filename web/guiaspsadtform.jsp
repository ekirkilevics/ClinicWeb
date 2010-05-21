<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.TISS" id="tiss" scope="page"/>

<%
	if(strcod != null) rs = banco.getRegistro("guiassadt","codGuia", Integer.parseInt(strcod) );
	
	//Informação para ver se existe guia de outras despesas
	String outrasdespesas = request.getParameter("outrasdespesas");
	
	String dataHoraSolicitacao = Util.formataData(banco.getCampo("dataHoraSolicitacao", rs));
	
	String data = Util.isNull(banco.getCampo("dataEmissaoGuia", rs)) ?  Util.getData() : Util.formataData(banco.getCampo("dataEmissaoGuia", rs));
	
	String gerouxml = !Util.isNull(request.getParameter("gerouxml")) ? request.getParameter("gerouxml") : "";
	
	String codANS = banco.getCampo("registroANS", rs);
	
	String codPrestadorOperadora = banco.getValor("identificadoroperadora", "SELECT identificadoroperadora FROM convenio WHERE cod_ans='" + codANS + "'");

%>

<html>
<head>
<title>TISS - Guia de SP/SADT</title>
<link href="css/tisscss.css" rel="stylesheet" type="text/css">
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
<script language="Javascript" src="CBE/cbe_util.js"></script>

<script language="JavaScript">
     //id
     var idReg = "<%= strcod%>";
	 //Informação vinda de gravardiagnostico
	 var inf = "<%= inf%>";
	 //Se gerou XML o lote
	 var gerouxml = "<%= gerouxml%>";
	 //Nome dos campos
	 var nome_campos_obrigatorios = Array("nº da Guia", "Data da Guia", "Caráter da Solicitação", "Tipo de Atendimento", "Tipo de Saída", "Total de Procedimentos", "Total geral");
	 //Página a enviar o formulário
	 var page = "gravarguiaspsadt.jsp";
     //Campos obrigatórios
	 var campos_obrigatorios = Array("numeroGuiaPrestador","dataEmissaoGuia", "caraterAtendimento", "tipoAtendimento", "tipoSaida", "servicosExecutados", "totalGeral");
	 //Cód ANS
	 var jsans = "<%= codANS%>";
	 //Outras Despesas
	 var outrasdespesas = "<%= outrasdespesas%>";

	function iniciar() {
		cbeGetElementById("caraterAtendimento").value = "<%= banco.getCampo("caraterAtendimento", rs) %>";
		cbeGetElementById("tipoAtendimento").value = "<%= banco.getCampo("tipoAtendimento", rs) %>";
		cbeGetElementById("indicadorAcidente").value = "<%= banco.getCampo("indicadorAcidente", rs) %>";
		cbeGetElementById("tipoSaida").value = "<%= banco.getCampo("tipoSaida", rs) %>";
		cbeGetElementById("unidadeTempo").value = "<%= banco.getCampo("unidadeTempo", rs) %>";
		cbeGetElementById("tipoDoenca").value = "<%= banco.getCampo("tipoDoenca", rs) %>";
		
		trataMensagem(inf);
		if(gerouxml == "S") {
			alert("Essa guia é somente para visualização.\nNão é possível editá-la pois já foi gerado arquivo XML.");
		}
		
		if(outrasdespesas == "S")
			window.open('guiaoutrasdespesasform.jsp?cod=' + idReg,'popupoutrasdespesas','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,width=750,height=500,top=100,left=100');

		//Se o convênio é São Cristóvão e ainda não gravou, pedir cód. controle
		if(jsans == "314218" && inf == "null") {
			cbeGetElementById("divsaocristovao").style.display = 'block';
			cbeGetElementById("codcontrole").focus();
		}

		//Se veio inf, imprimir guia
		if( inf != "null") {
			parent.frames[1].focus();
			parent.frames[1].print();
		}
		
	}
	
	function gravarGuia() {
		if(gerouxml == "S") {
			alert("Não é possível alterar a Guia pois já gerou arquivo XML");
			return;
		}
		
		enviarAcao('inc');
	}

	function trataMensagem(inf) {
		if(inf == "1") {
			mens = "Registro Inserido com Sucesso";
		}
		else if(inf =="2") {
			mens = "Ocorreu um erro na inserção do registro";
		}
		else if(inf == "3") {
			mens = "Registro removido com sucesso";
		}
		else if(inf == "4") {
			mens = "Erro na remoção do registro";
		}
		else if(inf == "5") {
			mens = "Registro alterado com sucesso";
		}
		else if(inf == "6") {
			mens = "Erro na alteração do registro";
		}
		else if(inf == "7") {
			mens = "Registro Duplicado";
		}
		else mens = inf;
		
		if(mens != "" && mens != "null")
			alert(mens);
		
	}

	function imprimeGuia() {
		passou = validaCampos();
		if(!passou) return;
		mensagem("");
		self.print();	
	}
	
	function insereControleSaoCristovao() {
		var jscod = cbeGetElementById("codcontrole").value;
		var jsnumeroCarteira = cbeGetElementById("numeroCarteira");
		
		//Se digitou o cód. de controle
		if(jscod != "") {
			jsnumeroCarteira.value += jscod;
		}
		cbeGetElementById("divsaocristovao").style.display = 'none';
	
	}
	
	function fecharSaoCristovao() {
		cbeGetElementById("divsaocristovao").style.display = 'none';
	}
	


</script>
</head>

<body marginheight="10" onLoad="iniciar()">
<form name="frmcadastrar" id="frmcadastrar" action="#" method="post">
	<table width="100%" cellpadding="0" cellspacing="0" class="tabela">
		<tr>
			  <td align="right"><span name='msg' id='msg' class="msg">&nbsp;</span></td>
		</tr>
		<tr>
			<td width="100%">
				<table border="0" width="100%" cellpadding="0" cellspacing="0">
					<tr>
						<td style="text-align:center">
							<%
								if(Util.existeArquivo("images/logo" + cod_empresa + ".gif"))
									out.println("<img src='images/logo" + cod_empresa + ".gif' border='0'>");

								if(Util.existeArquivo("images/logo" + codANS + ".jpg"))
									out.println("<img src='images/logo" + codANS + ".jpg' border='0'>");
							%>
						</td>
						<td style="text-align:center"><h5>GUIA DE SERVIÇO PROFISSIONAL / SERVIÇO AUXILIAR DE DIAGNÓSTICO E TERAPIA - SP/SADT</h5></td>
						<td width="40" class="texto">2-nº</td>
						<td width="100" style="text-align:center"><input type="text" class="tiss" name="numeroGuiaPrestador" id="numeroGuiaPrestador" value="<%= banco.getCampo("numeroGuiaPrestador", rs) %>" onKeyPress="return OnlyNumbersSemPonto(this,event);"></td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td width="100%">
				<table cellpadding="2" cellspacing="0" width="100%" align="left">
					<tr>
						<td>
							<table cellpadding="0" cellspacing="0" class="tabela" width="100px">
								<tr>
									<td class="texto">1-Registro ANS</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="12px" align="center"><%= codANS %>&nbsp;</td>
								</tr>
							</table>
						</td>
						<td width="100%">
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="100%">
								<tr>
									<td class="texto">3-Nº da Guia Principal</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="12px" align="center"><input type="text" class="tiss" name="numeroGuiaPrincipal" id="numeroGuiaPrincipal" value="<%= banco.getCampo("numeroGuiaPrincipal", rs) %>"></td>
								</tr>
							</table>
						</td>
						<td width="150">
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="150px">
								<tr>
									<td class="texto">4-Data da Autorização</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="12px" align="center"><input type="text" class="tiss" name="dataAutorizacao" id="dataAutorizacao" value="<%= Util.formataData(banco.getCampo("dataAutorizacao", rs)) %>" onKeyPress="formatar(this, event, '##/##/####'); " onBlur="ValidaData(this)" maxlength="10"></td>
								</tr>
							</table>
						</td>
						<td width="150">
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="150px">
								<tr>
									<td class="texto">5-Senha</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="12px" align="center"><input type="text" class="tiss" name="senhaAutorizacao" id="senhaAutorizacao" value="<%= banco.getCampo("senhaAutorizacao", rs) %>" maxlength="20"></td>
								</tr>
							</table>
						</td>
						<td width="150">
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="150px">
								<tr>
									<td class="texto">6-Data Validade da Senha</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="12px" align="center"><input type="text" class="tiss" name="validadeSenha" id="validadeSenha" value="<%= Util.formataData(banco.getCampo("validadeSenha", rs)) %>" onKeyPress="formatar(this, event, '##/##/####'); " onBlur="ValidaData(this)" maxlength="10"></td>
								</tr>
							</table>
						</td>
						<td width="150">
							<table cellpadding="0" cellspacing="0" class="tabela" width="150px">
								<tr>
				                  <td height="12" class="texto">7-Data da Emissão da Guia</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="12px" align="center"><input type="text" class="tiss" name="dataEmissaoGuia" id="dataEmissaoGuia" value="<%= data %>" onKeyPress="formatar(this, event, '##/##/####'); " onBlur="ValidaData(this)" maxlength="10"></td>
								</tr>
							</table>
						</td>

					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td width="100%" class="tdescuro">Dados do Beneficiário</td>
		</tr>
		<tr>
			<td width="100%">
				<table cellpadding="2" cellspacing="0" width="100%">
					<tr>
						<td width="100">
							<table cellpadding="0" cellspacing="0" class="tabela" width="100%">
								<tr>
									<td class="texto">8-Número da Carteira</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="12px" align="center"><input type="text" name="numeroCarteira" id="numeroCarteira" class="tiss" value="<%= banco.getCampo("numeroCarteira", rs) %>" onKeyPress="return false"></td>
								</tr>
							</table>
						</td>
						<td width="180">
							<table cellpadding="0" cellspacing="0" class="tabela" width="100%">
								<tr>
									<td class="texto">9-Plano</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="12px" align="center"><%= banco.getCampo("nomePlano", rs) %>&nbsp;</td>
								</tr>
							</table>
						</td>
						<td width="130">
							<table cellpadding="0" cellspacing="0" class="tabela" width="100%">
								<tr>
									<td class="texto">10-Validade da Carteira</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="12px" align="center"><%= Util.formataData(banco.getCampo("validadeCarteira", rs)) %>&nbsp;</td>
								</tr>
							</table>
						</td>
						<td>
							<table cellpadding="0" cellspacing="0" class="tabela" width="100%">
								<tr>
				                  <td height="12" class="texto">11-Nome</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="12px" align="center"><%= banco.getCampo("nomeBeneficiario", rs) %>&nbsp;</td>
								</tr>
							</table>
						</td>
						<td width="230">
							<table cellpadding="0" cellspacing="0" class="tabela" width="100%">
								<tr>
									<td class="texto">12-Número do Cartão Nacional de Saúde</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="12px" align="center"><%= banco.getCampo("numeroCNS", rs) %>&nbsp;</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td width="100%" class="tdescuro">Dados do Contratado Solicitante</td>
		</tr>
		<tr>
			<td width="100%">
				<table cellpadding="2" cellspacing="0" width="100%">
					<tr>
						<td width="220">
							<table cellpadding="0" cellspacing="0" class="tabela" width="100%">
								<tr>
				                  <td height="12" class="texto">13-Código na Operadora / CNPJ / CPF</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="12px" align="center">
										<input type="text" class="tiss" name="identificacaoContratado" id="identificacaoContratado" value="<%= banco.getCampo("identificacaoContratado", rs) %>">
									</td>
								</tr>
							</table>
						</td>
						<td>
							<table cellpadding="0" cellspacing="0" class="tabela" width="100%">
								<tr>
									<td class="texto">14-Nome do Contratado</td>
								</tr>
								<tr>
					                  <td class="dados" valign="bottom" height="12px" align="center"><input type="text" class="tiss" name="contratadoSolicitante" id="contratadoSolicitante" value="<%= banco.getCampo("contratadoSolicitante", rs) %>"></td>
								</tr>
							</table>
						</td>
						<td width="100">
							<table cellpadding="0" cellspacing="0" class="tabela" width="100%">
								<tr>
									<td class="texto">15-Código CNES</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="12px" align="center"> <input type="text" class="tiss" name="CNESSolicitante" id="CNESSolicitante" value="<%= banco.getCampo("CNESSolicitante", rs) %>" maxlength="7"></td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td width="100%">
				<table cellpadding="2" cellspacing="0" width="100%">
					<tr>
						<td>
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="100%">
								<tr>
									<td class="texto">16-Nome do Profissional Solicitante</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="12px" align="center"><input type="text" class="tiss" name="nomeProfissional" id="nomeProfissional" value="<%= banco.getCampo("nomeProfissional", rs) %>"></td>
								</tr>
							</table>
						</td>
						<td width="130">
							<table cellpadding="0" cellspacing="0" class="tabela" width="100%">
								<tr>
									<td class="texto">17-Conselho Profissional</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="12px" align="center"><input type="text" class="tiss" name="siglaConselho" id="siglaConselho" value="<%= banco.getCampo("siglaConselho", rs) %>"></td>
								</tr>
							</table>
						</td>
						<td width="130">
							<table cellpadding="0" cellspacing="0" class="tabela" width="100%">
								<tr>
									<td class="texto">18-Número do Conselho</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="12px" align="center"><input type="text" class="tiss" name="numeroConselho" id="numeroConselho" value="<%= banco.getCampo("numeroConselho", rs) %>"></td>
								</tr>
							</table>
						</td>
						<td width="50">
							<table cellpadding="0" cellspacing="0" class="tabela" width="100%">
								<tr>
					                <td class="texto">19-UF</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="12px" align="center"><input type="text" class="tiss" name="ufConselho" id="ufConselho" value="<%= banco.getCampo("ufConselho", rs) %>"></td>
								</tr>
							</table>
						</td>
						<td width="100">
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="100%">
								<tr>
								    <td class="texto">20-Código CBO S</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="12px" align="center"><input type="text" class="tiss" name="cbos" id="cbos" value="<%= banco.getCampo("cbos", rs) %>"></td>
								</tr>
							</table>
						</td>
					</tr>

				</table>
			</td>
		</tr>
		<tr>
			<td width="100%" class="tdescuro">dados da Solicitação / Procedimentos e Exames Solicitados</td>
		</tr>
		<tr>
			<td width="100%">
				<table cellpadding="2" cellspacing="0" width="100%">
					<tr>
						<td width="200">
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="100%">
								<tr>
									<td class="texto">21-Data/Hora da Solicitação</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="12px" align="center"><input type="text" class="tiss" name="dataHoraSolicitacao" id="dataHoraSolicitacao" value="<%= dataHoraSolicitacao %>"></td>
								</tr>
							</table>
						</td>
						<td width="250">
							<table cellpadding="0" cellspacing="0" class="tabela" width="100%">
								<tr>
									<td class="texto">22-Caráter da Solicitação</td>
								</tr>
								<tr>
									<td class="texto" valign="bottom" height="12px" align="center">
										<select name="caraterAtendimento" id="caraterAtendimento" class="tiss">
											<option value="E">E-Eletiva</option>
											<option value="U">U-Urgência/Emergência</option>
										</select>									
									</td>
								</tr>
							</table>
						</td>
						<td width="100">
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="100%">
								<tr>
									<td class="texto">23-CID 10</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="12px" align="center"><input maxlength="5" type="text" class="tiss" name="codigoDiagnostico" id="codigoDiagnostico" value="<%= banco.getCampo("codigoDiagnostico", rs) %>"></td>
								</tr>
							</table>
						</td>
						<td>
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="100%">
								<tr>
									<td class="texto">24-Indicação Clínica (obrigatório se pequena cirurgia, terapia, consulta de referência e alto custo)</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="12px" align="center"><input type="text" class="tiss" name="indicacaoClinica" id="indicacaoClinica" value="<%= banco.getCampo("indicacaoClinica", rs) %>"></td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td width="100%">
				<table cellpadding="2" cellspacing="0" width="100%" class="tabela">
					<tr>
						<td class="tdescuro">25-Tabela</td>
						<td class="tdescuro">26-Código do Procedimento</td>
						<td class="tdescuro">27-Descrição</td>
						<td class="tdescuro">28-Qt. Solic.</td>
						<td class="tdescuro">29-Qt. Autoriz.</td>
					</tr>
					<%= tiss.getProcedimentosSolicitados(strcod, cod_empresa) %>
				</table>
			</td>
		</tr>
		<tr>
			<td width="100%" class="tdescuro">Dados do Contratado Executante</td>
		</tr>
		<tr>
			<td width="100%">
				<table cellpadding="2" cellspacing="0" width="100%">
					<tr>
						<td width="170">
							<table cellpadding="0" cellspacing="0" class="tabela" width="100%">
								<tr>
									<td class="texto">30-Código na Operadora / CNPJ / CPF</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="12px" align="center">
										<%= codPrestadorOperadora %>
									</td>
								</tr>
							</table>
						</td>
						<td>
							<table cellpadding="0" cellspacing="0" class="tabela" width="100%">
								<tr>
									<td class="texto">31-Nome do Contratado</td>
								</tr>
								<tr>
				                  <td class="dados" valign="bottom" height="12px" align="center"><%= banco.getCampo("contratado", rs) %></td>
								</tr>
							</table>
						</td>
						<td width="50">
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="100%">
								<tr>
									<td class="texto">32-T.L.</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="12px" align="center"><%= configuracao.getItemConfig("tipoLogradouro", cod_empresa)%>&nbsp;</td>
								</tr>
							</table>
						</td>
						<td width="220">
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="100%">
								<tr>
									<td class="texto">33-34-35-Logradouro - Número - Complemento</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="12px" align="center"><%= configuracao.getItemConfig("logradouro", cod_empresa)%>, <%= configuracao.getItemConfig("numero", cod_empresa)%>, <%= configuracao.getItemConfig("complemento", cod_empresa)%>&nbsp;</td>
								</tr>
							</table>
						</td>
						<td width="120">
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="100%">
								<tr>
									<td class="texto">36-Município</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="12px" align="center"><%= configuracao.getItemConfig("cidade", cod_empresa)%>&nbsp;</td>
								</tr>
							</table>
						</td>
						<td width="40">
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="100%">
								<tr>
									<td class="texto">37-UF</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="12px" align="center"><%= configuracao.getItemConfig("UF", cod_empresa)%>&nbsp;</td>
								</tr>
							</table>
						</td>
						<td width="80">
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="100%">
								<tr>
									<td class="texto">38-Cód. IBGE</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="12px" align="center"><%= configuracao.getItemConfig("codigoIBGEMunicipio", cod_empresa)%>&nbsp;</td>
								</tr>
							</table>
						</td>
						<td width="70">
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="100%">
								<tr>
									<td class="texto">39-CEP</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="12px" align="center"><%= configuracao.getItemConfig("cep", cod_empresa)%>&nbsp;</td>
								</tr>
							</table>
						</td>

						<td width="80">
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="100%">
								<tr>
									<td class="texto">40-Código CNES</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="12px" align="center"><%= banco.getCampo("codCNES", rs) %>&nbsp;</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td width="100%">
				<table cellpadding="2" cellspacing="0" width="100%">
					<tr>
						<td>
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="100%">
								<tr>
									<td class="texto">41-Nome do Profissional Executante/Complementar</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="12px" align="center"><input type="text" class="tiss" name="nomeExecutanteC" id="nomeExecutanteC" value="<%= banco.getCampo("nomeExecutanteC", rs) %>"></td>
								</tr>
							</table>
						</td>
						<td width="130">
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="100%">
								<tr>
									<td class="texto">42-Conselho Profissional</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="12px" align="center"><input type="text" class="tiss" name="siglaConselhoC" id="siglaConselhoC" value="<%= banco.getCampo("siglaConselhoC", rs) %>"></td>
								</tr>
							</table>
						</td>
						<td width="130">
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="100%">
								<tr>
									<td class="texto">43-Número no Conselho</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="12px" align="center"><input type="text" class="tiss" name="numeroConselhoC" id="numeroConselhoC" value="<%= banco.getCampo("numeroConselhoC", rs) %>"></td>
								</tr>
							</table>
						</td>
						<td width="50">
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="100%">
								<tr>
									<td class="texto">44-UF</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="12px" align="center"><input type="text" class="tiss" name="ufConselhoC" id="ufConselhoC" value="<%= banco.getCampo("ufConselhoC", rs) %>"></td>
								</tr>
							</table>
						</td>
						<td width="80">
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="100%">
								<tr>
									<td class="texto">45-Cód. CBOS</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="12px" align="center"><input type="text" class="tiss" name="codigoCBOSC" id="codigoCBOSC" value="<%= banco.getCampo("codigoCBOSC", rs) %>" maxlength="10"></td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td width="100%" class="tdescuro">Dados do Atendimento</td>
		</tr>
		<tr>
			<td width="100%">
				<table cellpadding="2" cellspacing="0">
					<tr>
						<td width="50%">
							<table cellpadding="0" cellspacing="0" class="tabela" width="100%">
								<tr>
									<td class="texto">46-Tipo de Atendimento</td>
								</tr>
								<tr>
									<td class="texto" valign="bottom" height="12px" align="center">
										<select name="tipoAtendimento" id="tipoAtendimento" class="tiss">
											<option value="01">01 - Remoção</option>
											<option value="02">02 - Pequena Cirurgia</option>
											<option value="03">03 - Terapias</option>
											<option value="04">04 - Consulta</option>
											<option value="05">05 - Exame</option>
											<option value="06">06 - Atendimento Domiciliar</option>
											<option value="07">07 - SADT Internado</option>
											<option value="08">08 - Quimioterapia</option>
											<option value="09">09 - Radioterapia</option>
											<option value="10">10 - TRS-Terapia Renal Substitutiva</option>
										</select>
									</td>
								</tr>
							</table>
						</td>
						<td width="200">
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="100%">
								<tr>
									<td class="texto">47-Indicação de Acidente</td>
								</tr>
								<tr>
									<td width="100%">
										<select name="indicadorAcidente" id="indicadorAcidente" class="tiss">
											<option value="0">0 - Acidente ou doença relacionado ao trabalho</option>
											<option value="1">1 - Trânsito</option>
											<option value="2">2 - Outros</option>
										</select>
									</td>
								</tr>
							</table>
						</td>
						<td width="300">
							<table cellpadding="0" cellspacing="0" class="tabela" width="100%">
								<tr>
									<td class="texto">48-Tipo de Saída</td>
								</tr>
								<tr>
									<td class="texto" valign="bottom" height="12px" align="center">
										<select name="tipoSaida" id="tipoSaida" class="tiss">
											<option value="1">1 - Retorno</option>
											<option value="2">2 - Retorno SADT</option>
											<option value="3">3 - Referência</option>
											<option value="4">4 - Internação</option>
											<option value="5">5 - Alta</option>
											<option value="6">6 - Óbito</option>
										</select>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td width="100%" class="tdescuro">Consulta Referência</td>
		</tr>
		<tr>
			<td width="100%">
				<table cellpadding="2" cellspacing="0">
					<tr>
						<td width="200">
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="100%">
								<tr>
									<td class="texto">49-Tipo de Doença</td>
								</tr>
								<tr>
									<td class="texto" valign="bottom" height="12px" align="center">
											<select name="tipoDoenca" id="tipoDoenca" class="tiss">
											<option value="A">A - Aguda</option>
											<option value="C">C - Crônica</option>
										</select>
									</td>
								</tr>
							</table>
						</td>
						<td width="200">
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="100%">
								<tr>
									<td class="texto">50-Tempo de Doença</td>
								</tr>
								<tr>
									<td class="texto" valign="bottom" height="12px" align="center">
										<input type="text" class="tiss" name="valor" id="valor" style="width:48%" value="<%= banco.getCampo("valor", rs) %>">
										<select name="unidadeTempo" id="unidadeTempo" class="tiss" style="width:48%">
											<option value="A">A - Anos</option>
											<option value="M">M - Meses</option>
											<option value="D">D - Dias</option>
										</select>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td width="100%" class="tdescuro">Procedimentos e Exames Realizados</td>
		</tr>
		<tr>
			<td width="100%">
				<table cellpadding="2" cellspacing="0" width="100%" class="tabela">
					<tr>
						<td class="tdescuro">51-Data</td>
						<td class="tdescuro">52-Hora Inicial</td>
						<td class="tdescuro">53-Hora Final</td>
						<td class="tdescuro">54-Tabela</td>
						<td class="tdescuro">55-Código do Procedimento</td>
						<td class="tdescuro">56-Descrição</td>
						<td class="tdescuro">57-Qtde.</td>
						<td class="tdescuro">58-Via</td>
						<td class="tdescuro">59-Tec.</td>
						<td class="tdescuro">60-%Red./Acresc.</td>
						<td class="tdescuro">61-Valor Unitário - R$</td>
						<td class="tdescuro">62-Valor Total - R$</td>
					</tr>
					<%= tiss.getProcedimentosExecutados(strcod, cod_empresa)%>
				</table>
			</td>
		</tr>
		<tr>
			<td width="100%">
				<table cellpadding="2" cellspacing="0" width="100%">
					<tr>
						<td width="100%">
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="100%">
								<tr>
									<td class="texto">63-Data e Assinatura de Procedimentos em Série</td>
								</tr>
								<tr>
									<td align="left" width="100%">
										<table width="100%">
											<tr>
												<td class="texto">1-____/____/_____ _________________</td>
												<td class="texto">3-____/____/_____ _________________</td>
												<td class="texto">5-____/____/_____ _________________</td>
												<td class="texto">7-____/____/_____ _________________</td>
												<td class="texto">9-____/____/_____ _________________</td>
											</tr>
											<tr>
												<td class="texto">2-____/____/_____ _________________</td>
												<td class="texto">4-____/____/_____ _________________</td>
												<td class="texto">6-____/____/_____ _________________</td>
												<td class="texto">8-____/____/_____ _________________</td>
												<td class="texto">10-____/____/_____ _________________</td>
											</tr>
										</table>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td width="100%">
				<table cellpadding="2" cellspacing="0" width="100%">
					<tr>
						<td>
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="100%">
								<tr>
									<td class="texto">64-Observação</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="15px" align="left"><input type="text" class="tiss" name="observacao" id="observacao" value="<%= banco.getCampo("observacao", rs)%>"></td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td width="100%">
				<table cellpadding="2" cellspacing="0" width="100%">
					<tr>
						<td>
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="100%">
								<tr>
									<td class="texto">65-Total Procedimentos R$</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="15px" align="center"><input type="text" class="tiss" name="servicosExecutados" id="servicosExecutados" value="<%= banco.getCampo("servicosExecutados", rs)%>"></td>
								</tr>
							</table>
						</td>
						<td>
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="100%">
								<tr>
									<td class="texto">66-Total Taxas e Aluguéis R$</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="15px" align="center"><input type="text" class="tiss" name="taxas" id="taxas" value="<%= banco.getCampo("taxas", rs)%>"></td>
								</tr>
							</table>
						</td>
						<td>
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="100%">
								<tr>
									<td class="texto">67-Total Materiais R$</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="15px" align="center"><input type="text" class="tiss" name="materiais" id="materiais" value="<%= banco.getCampo("materiais", rs)%>"></td>
								</tr>
							</table>
						</td>
						<td>
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="100%">
								<tr>
									<td class="texto">68-Total Medicamentos R$</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="15px" align="center"><input type="text" class="tiss" name="medicamentos" id="medicamentos" value="<%= banco.getCampo("medicamentos", rs)%>"></td>
								</tr>
							</table>
						</td>
						<td>
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="100%">
								<tr>
									<td class="texto">69-Total Diárias R$</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="15px" align="center"><input type="text" class="tiss" name="diarias" id="diarias" value="<%= banco.getCampo("diarias", rs)%>"></td>
								</tr>
							</table>
						</td>
						<td>
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="100%">
								<tr>
									<td class="texto">70-Total Gases Medicinais R$</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="15px" align="center"><input type="text" class="tiss" name="gases" id="gases" value="<%= banco.getCampo("gases", rs)%>"></td>
								</tr>
							</table>
						</td>
						<td>
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="100%">
								<tr>
									<td class="texto">71-Total Geral da Guia R$</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="15px" align="center"><input type="text" class="tiss" name="totalGeral" id="totalGeral" value="<%= banco.getCampo("totalGeral", rs)%>"></td>
								</tr>
							</table>
						</td>

					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td width="100%">
				<table cellpadding="2" cellspacing="0" width="100%">
					<tr>
						<td>
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="100%">
								<tr>
									<td class="texto">86-Data e Assinatura do Solicitante</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom"><input type="text" class="tiss" value="<%= dataHoraSolicitacao %>" onKeyPress="formatar(this, event, '##/##/####'); " onBlur="ValidaData(this)" maxlength="10"></td>
								</tr>
							</table>
						</td>
						<td>
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="100%">
								<tr>
									<td class="texto">87-Data e Assinatura do Responsável pela Autorização</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="15px" align="center">&nbsp;</td>
								</tr>
							</table>
						</td>
						<td>
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="100%">
								<tr>
									<td class="texto">88-Data e Assinatura do Beneficiário ou Responsável</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom"><input type="text" class="tiss" value="<%= dataHoraSolicitacao %>" onKeyPress="formatar(this, event, '##/##/####'); " onBlur="ValidaData(this)" maxlength="10"></td>
								</tr>
							</table>
						</td>
						<td>
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="100%">
								<tr>
									<td class="texto">89-Data e Assinatura do Prestador Executante</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom"><input type="text" class="tiss" value="<%= dataHoraSolicitacao %>" onKeyPress="formatar(this, event, '##/##/####'); " onBlur="ValidaData(this)" maxlength="10"></td>
								</tr>
							</table>
						</td>
						
					</tr>
				</table>
			</td>
		</tr>
	</table>
    <br>
    <div class="texto">Emitido por: <%= banco.getCampo("usuario", rs) %></div>
</form>

<div id="divsaocristovao" style="position: absolute; top: 0; left: 0; width: 100%; height: 100%; background-image:url(images/fundoalpha.gif); display: none; text-align: center">
	<br><br><br><br><br><br>
	<table border="1" cellpadding="0" cellspacing="0" class="tabela" align="center">
		<tr>
			<td colspan="2" class="tdMedium" align="center">São Cristóvão</td>
		</tr>
		<tr>
			<td class="tdMedium">Cód. Controle:</td>
			<td class="tdLight"><input type="text" name="codcontrole" id="codcontrole" maxlength="5" class="caixa"></td>
		</tr>
		<tr>
			<td class="tdMedium" align="center"><input type="button" class="botao" value="Gravar" onClick="insereControleSaoCristovao()"></td>
			<td class="tdMedium" align="center"><input type="button" class="botao" value="Fechar" onClick="fecharSaoCristovao()"></td>
		</tr>
	</table>
</div>


</body>
</html>
