<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.TISS" id="tiss" scope="page"/>

<%
	if(strcod != null) rs = banco.getRegistro("guiasconsulta","codGuia", Integer.parseInt(strcod) );
	
	String data = Util.isNull(banco.getCampo("dataEmissaoGuia", rs)) ?  Util.getData() : Util.formataData(banco.getCampo("dataEmissaoGuia", rs));
	String dataAtendimento = Util.formataData(banco.getCampo("dataAtendimento", rs));
	
	String gerouxml = request.getParameter("gerouxml");
	
	String codANS = banco.getCampo("registroANS", rs);
	
%>

<html>
<head>
<title>TISS - Guia de Consulta</title>
<link href="css/tisscss.css" rel="stylesheet" type="text/css">
<link href="css/css.css" rel="stylesheet" type="text/css">

<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
<script language="JavaScript">
     //id
     var idReg = "<%= strcod%>";
	 //Informação vinda de gravar
	 var inf = "<%= inf%>";
	 //Nome dos campos
	 var nome_campos_obrigatorios = Array("Data de Emissão da Guia","Nº da Guia", "Data de Atendimento", "Código da Tabela", "Código do Procedimento", "Tipo de Consulta", "Tipo de Saída");
	 //Página a enviar o formulário
	 var page = "gravarguiaconsulta.jsp";
     //Campos obrigatórios
	 var campos_obrigatorios = Array("dataEmissaoGuia","numeroGuiaPrestador", "dataAtendimento", "codigoTabela", "codigoProcedimento", "tipoConsulta", "tipoSaida");

	 //Cód ANS
	 var jsans = "<%= codANS%>";
	 
	 var gerouxml = "<%= gerouxml%>";

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

	function iniciar() {
		cbeGetElementById("tipoDoenca").value = "<%= banco.getCampo("tipoDoenca", rs) %>";
		cbeGetElementById("unidadeTempo").value = "<%= banco.getCampo("unidadeTempo", rs) %>";
		cbeGetElementById("indicadorAcidente").value = "<%= banco.getCampo("indicadorAcidente", rs) %>";
		cbeGetElementById("tipoConsulta").value = "<%= banco.getCampo("tipoConsulta", rs) %>";
		cbeGetElementById("tipoSaida").value = "<%= banco.getCampo("tipoSaida", rs) %>";
		trataMensagem(inf);
		if(gerouxml == "S") {
			alert("Essa guia é somente para visualização.\nNão é possível editá-la pois já foi gerado arquivo XML.");
		}
		
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
	
	function imprimeGuia() {
		passou = validaCampos();
		if(!passou) return;
		mensagem("");
		self.print();	
	}
	
	function insereControleSaoCristovao() {
		var jscod = cbeGetElementById("codcontrole").value;
		var jsnumeroCarteira = cbeGetElementById("numeroCarteira");
		
		//Se escolheu algum valor
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
<form name="frmcadastrar" id="frmcadastrar" action="gravarguiaconsulta.jsp" method="post">
	<table width="100%" cellpadding="0" cellspacing="0" class="tabela">
		<tr>
			  <td align="right"><span name='msg' id='msg' class="msg">&nbsp;</span></td>
		</tr>
		<tr>
			<td width="100%">
				<table border="0" width="100%" cellpadding="0" cellspacing="0">
					<tr>
						<td width="100" style="text-align:center">
							<%
								if(Util.existeArquivo("images/logo" + cod_empresa + ".gif"))
									out.println("<img src='images/logo" + cod_empresa + ".gif' border='0'>");

								if(Util.existeArquivo("images/logo" + codANS + ".jpg"))
									out.println("<img src='images/logo" + codANS + ".jpg' border='0'>");
							%>
						</td>
						<td style="text-align:center"><h3>GUIA DE CONSULTA</h3></td>
						<td width="40" class="texto">2-nº</td>
						<td width="100" style="text-align:center"><input type="text" class="tiss" name="numeroGuiaPrestador" id="numeroGuiaPrestador" value="<%= banco.getCampo("numeroGuiaPrestador", rs) %>" maxlength="20" onKeyPress="return OnlyNumbersSemPonto(this,event);"></td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td width="100%">
				<table cellpadding="2" cellspacing="0">
					<tr>
						<td>
							<table cellpadding="0" cellspacing="0" class="tabela" width="100px">
								<tr>
									<td class="texto">1-Registro ANS</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="30px" align="center"><%= banco.getCampo("registroANS", rs) %>&nbsp;</td>
								</tr>
							</table>
						</td>
						<td>
							<table cellpadding="0" cellspacing="0" class="tabela" width="300px">
								<tr>
									<td class="texto">3-Data de Emissão da Guia</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="30px" align="center"><input type="text" class="tiss" name="dataEmissaoGuia" id="dataEmissaoGuia" value="<%= data%>" onKeyPress="return formatar(this, event, '##/##/####'); ValidaData(this)" maxlength="10"></td>
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
						<td width="40%">
							<table cellpadding="0" cellspacing="0" class="tabela" width="100%">
								<tr>
									<td class="texto">4-Número da Carteira</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="30px" align="center"><input type="text" name="numeroCarteira" id="numeroCarteira" class="tiss" value="<%= banco.getCampo("numeroCarteira", rs) %>" onKeyPress="return false"></td>
								</tr>
							</table>
						</td>
						<td width="30%">
							<table cellpadding="0" cellspacing="0" class="tabela" width="100%">
								<tr>
									<td class="texto">5-Plano</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="30px" align="center"><%= banco.getCampo("nomePlano", rs) %>&nbsp;</td>
								</tr>
							</table>
						</td>
						<td>
							<table cellpadding="0" cellspacing="0" class="tabela" width="100%">
								<tr>
									<td class="texto">6-Validade da Carteira</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="30px" align="center"><%= Util.formataData(banco.getCampo("validadeCarteira", rs)) %>&nbsp;</td>
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
						<td width="60%">
							<table cellpadding="0" cellspacing="0" class="tabela" width="100%">
								<tr>
									<td class="texto">7-Nome</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="30px" align="center"><%= banco.getCampo("nomeBeneficiario", rs) %>&nbsp;</td>
								</tr>
							</table>
						</td>
						<td width="40%">
							<table cellpadding="0" cellspacing="0" class="tabela" width="100%">
								<tr>
									<td class="texto">8-Número do Cartão Nacional de Saúde</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="30px" align="center"><%= banco.getCampo("numeroCNS", rs) %>&nbsp;</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td width="100%" class="tdescuro">Dados do Contratado</td>
		</tr>
		<tr>
			<td width="100%">
				<table cellpadding="2" cellspacing="0" width="100%">
					<tr>
						<td width="200">
							<table cellpadding="0" cellspacing="0" class="tabela" width="100%">
								<tr>
									<td class="texto">9-Código na Operadora / CNPJ / CPF</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="30px" align="center">
										<%= banco.getCampo("identificacaoContratado", rs) %>
									</td>
								</tr>
							</table>
						</td>
						<td>
							<table cellpadding="0" cellspacing="0" class="tabela" width="100%">
								<tr>
									<td class="texto">10-Nome do Contratado</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="30px" align="center"><%= banco.getCampo("contratado", rs)%></td>
								</tr>
							</table>
						</td>
						<td width="100">
							<table cellpadding="0" cellspacing="0" class="tabela" width="100%">
								<tr>
									<td class="texto">11-Código CNES</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="30px" align="center"><%= banco.getCampo("codCNES", rs)%>&nbsp;</td>
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
						<td width="50">
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="100%">
								<tr>
									<td class="texto">12-TL</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="30px" align="center"><%= configuracao.getItemConfig("tipoLogradouro", cod_empresa)%>&nbsp;</td>
								</tr>
							</table>
						</td>
						<td>
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="100%">
								<tr>
									<td class="texto">13-14-15-Logradouro-Número-Complemento</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="30px" align="center"><%= configuracao.getItemConfig("logradouro", cod_empresa)%>, <%= configuracao.getItemConfig("numero", cod_empresa)%>, <%= configuracao.getItemConfig("complemento", cod_empresa)%>&nbsp;</td>
								</tr>
							</table>
						</td>
						<td width="150">
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="100%">
								<tr>
									<td class="texto">16-Município</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="30px" align="center"><%= configuracao.getItemConfig("cidade", cod_empresa)%>&nbsp;</td>
								</tr>
							</table>
						</td>
						<td width="50">
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="100%">
								<tr>
									<td class="texto">17-UF</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="30px" align="center"><%= configuracao.getItemConfig("UF", cod_empresa)%>&nbsp;</td>
								</tr>
							</table>
						</td>
						<td width="90">
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="100%">
								<tr>
									<td class="texto">18-Código IBGE</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="30px" align="center"><%= configuracao.getItemConfig("codigoIBGEMunicipio", cod_empresa)%>&nbsp;</td>
								</tr>
							</table>
						</td>
						<td width="75">
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="100%">
								<tr>
									<td class="texto">19-CEP</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="30px" align="center"><%= configuracao.getItemConfig("cep", cod_empresa)%>&nbsp;</td>
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
									<td class="texto">20-Nome do Profissional Executante</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="30px" align="center"><%= banco.getCampo("nomeProfissional", rs) %>&nbsp;</td>
								</tr>
							</table>
						</td>
						<td width="130">
							<table cellpadding="0" cellspacing="0" class="tabela" width="100%">
								<tr>
									<td class="texto">21-Conselho Profissional</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="30px" align="center"><%= banco.getCampo("siglaConselho", rs) %>&nbsp;</td>
								</tr>
							</table>
						</td>
						<td width="130">
							<table cellpadding="0" cellspacing="0" class="tabela" width="100%">
								<tr>
									<td class="texto">22-Número do Conselho</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="30px" align="center"><%= banco.getCampo("numeroConselho", rs) %>&nbsp;</td>
								</tr>
							</table>
						</td>
						<td width="50">
							<table cellpadding="0" cellspacing="0" class="tabela" width="100%">
								<tr>
									<td class="texto">23-UF</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="30px" align="center"><%= banco.getCampo("ufConselho", rs) %>&nbsp;</td>
								</tr>
							</table>
						</td>
						<td width="100">
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="100%">
								<tr>
									<td class="texto">24-Código CBO S</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="30px" align="center"><%= banco.getCampo("cbos", rs) %>&nbsp;</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td width="100%" class="tdescuro">Hipótese Diagnóstica</td>
		</tr>
		<tr>
			<td width="100%">
				<table cellpadding="2" cellspacing="0" width="100%">
					<tr>
						<td width="110">
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="100%">
								<tr>
									<td class="texto">25-Tipo de Doença</td>
								</tr>
								<tr>
									<td class="texto" valign="bottom" height="30px" align="center">
										<select name="tipoDoenca" id="tipoDoenca" class="tiss">
											<option value=""></option>
											<option value="A">A - Aguda</option>
											<option value="C">C - Crônica</option>
										</select>
								</tr>
							</table>
						</td>
						<td width="170">
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="100%">
								<tr>
									<td class="texto">26-Tempo de Doença</td>
								</tr>
								<tr>
									<td class="texto" valign="bottom" height="30px" align="center">
										<input type="text" class="tiss" name="valor" id="valor" style="width:48%" value="<%= banco.getCampo("valor", rs) %>">
										<select name="unidadeTempo" id="unidadeTempo" class="tiss" style="width:48%">
											<option value=""></option>
											<option value="A">A - Anos</option>
											<option value="M">M - Meses</option>
											<option value="D">D - Dias</option>
										</select>
									</td>
								</tr>
							</table>
						</td>
						<td>
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="100%">
								<tr>
									 <td height="12" class="texto">27-Indicação de Acidente</td>
								</tr>
								<tr>
									<td class="texto" valign="bottom" height="30px" align="center">
										<select name="indicadorAcidente" id="indicadorAcidente" class="tiss">
											<option value=""></option>
											<option value="0">0-Acidente ou doença relacionado ao trabalho</option>
											<option value="1">1-Trânsito</option>
											<option value="2">2-Outros</option>
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
			<td width="100%">
				<table cellpadding="2" cellspacing="0" width="100%">
					<tr>
						<td width="25%">
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="100%">
								<tr>
									<td class="texto">28-CID Principal</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="30px" align="center">
										<input type="hidden" class="tiss" name="nomeTabela" id="nomeTabela" value="CID-10">
										<input type="text" class="tiss" name="codigoDiagnostico" id="codigoDiagnostico" value="<%= banco.getCampo("codigoDiagnostico", rs) %>">
									</td>
								</tr>
							</table>
						</td>
						<td width="25%">
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="100%">
								<tr>
									<td class="texto">29-CID (2)</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="30px" align="center"></td>
								</tr>
							</table>
						</td>
						<td width="25%">
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="100%">
								<tr>
									<td class="texto">30-CID (3)</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="30px" align="center"></td>
								</tr>
							</table>
						</td>
						<td width="25%">
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="100%">
								<tr>
									<td class="texto">31-CID (4)</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="30px" align="center"></td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td width="100%" class="tdescuro">Dados do Atendimento / Procedimento Realizado</td>
		</tr>
		<tr>
			<td width="100%">
				<table cellpadding="2" cellspacing="0">
					<tr>
						<td width="200">
							<table cellpadding="0" cellspacing="0" class="tabela" width="100%">
								<tr>
									<td class="texto">32-Data do Atendimento</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="30px" align="center"><input type="text" class="tiss" name="dataAtendimento" id="dataAtendimento" onKeyPress="return formatar(this, event, '##/##/####'); ValidaData(this)" maxlength="10" value="<%= dataAtendimento %>"></td>
								</tr>
							</table>
						</td>
						<td width="200">
							<table cellpadding="0" cellspacing="0" class="tabela" width="100%">
								<tr>
									<td class="texto">33-Código da Tabela</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="30px" align="center"><input type="text" class="tiss" name="codigoTabela" id="codigoTabela" value="<%= banco.getCampo("codigoTabela", rs)%>" onKeyPress="return false"></td>
								</tr>
							</table>
						</td>
						<td width="200">
							<table cellpadding="0" cellspacing="0" class="tabela" width="100%">
								<tr>
									<td class="texto">34-Código do Procedimento</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="30px" align="center"><input type="text" class="tiss" name="codigoProcedimento" id="codigoProcedimento" value="<%= banco.getCampo("codigoProcedimento", rs)%>"></td>
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
						<td width="50%">
							<table cellpadding="0" cellspacing="0" class="tabela" width="100%">
								<tr>
									<td class="texto">35-Tipo de Consulta</td>
								</tr>
								<tr>
									<td class="texto" valign="bottom" height="30px" align="center">
										<select name="tipoConsulta" id="tipoConsulta" class="tiss">
											<option value="1">1-Primeira</option>
											<option value="2">2-Seguimento</option>
											<option value="3">3-Pré-Natal</option>
										</select>									
									</td>
								</tr>
							</table>
						</td>
						<td width="50%">
							<table cellpadding="0" cellspacing="0" class="tabela" width="100%">
								<tr>
									<td class="texto">36-Tipo de Saída</td>
								</tr>
								<tr>
									<td class="texto" valign="bottom" height="30px" align="center">
										<select name="tipoSaida" id="tipoSaida" class="tiss">
											<option value="1">1-Retorno</option>
											<option value="2">2-Retorno SADT</option>
											<option value="3">3-Referência</option>
											<option value="4">4-Internação</option>
											<option value="5">5-Alta</option>
										</select>									
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
						<td width="100%">
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="100%">
								<tr>
									<td class="texto">37-Observação</td>
								</tr>
								<tr>
									<td class="dados" valign="top" height="60px" align="left"><input type="text" class="tiss" name="observacao" id="observacao" value="<%= banco.getCampo("observacao", rs)%>" maxlength="240"></td>
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
						<td width="50%">
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="100%">
								<tr>
									<td class="texto">38-Data e Assinatura do Médico</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="40px"><input type="text" class="tiss" value="<%= dataAtendimento %>" onKeyPress="formatar(this, event, '##/##/####'); " onBlur="ValidaData(this)" maxlength="10"></td>
								</tr>
							</table>
						</td>
						<td width="50%">
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="100%">
								<tr>
									<td class="texto">39-Data e Assinatura do Beneficiário ou Responsável</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="40px"><input type="text" class="tiss" value="<%= dataAtendimento %>" onKeyPress="formatar(this, event, '##/##/####'); " onBlur="ValidaData(this)" maxlength="10"></td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
                <br>
                <div class="texto">Emitido por: <%= banco.getCampo("usuario", rs) %></div>
			</td>
		</tr>

	</table>
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
