<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.TISS" id="tiss" scope="page"/>

<%
	//Gerar a guia de Honorário Individual
	String reto = tiss.gerarGuiaHonorarioIndividual(strcod, nome_usuario);
	
	if(!reto.equals("OK")) out.println(reto);	
	
	if(strcod != null) rs = banco.getRegistro("guiashonorarioindividual","cod_honorario", Integer.parseInt(strcod) );

	String codANS = banco.getCampo("registroANS", rs);
	String data = Util.formataData(banco.getCampo("dataEmissaoGuia", rs));
	String codGuia = banco.getCampo("codGuia", rs);

%>

<html>
<head>
<title>TISS - Guia de Honorário Individual</title>
<link href="css/tisscss.css" rel="stylesheet" type="text/css">
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
<script language="Javascript" src="CBE/cbe_util.js"></script>
<script language="JavaScript">
	function iniciar() {
		self.print();	
	}

	function atualizaNumeroGuia() {
		var frm = cbeGetElementById("frmcadastrar");
		frm.action = "atualizanumeroguia.jsp?tipoGuia=3&cod=<%= strcod%>";
		frm.target = "iframenumeroguia";
		frm.submit();
		alert("Número de guia alterado com sucesso");
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
						<td style="text-align:center"><h5>GUIA DE HONORÁRIO INDIVIDUAL</h5></td>
						<td width="40" class="texto">2-nº</td>
						<td width="100" style="text-align:left; padding-left:3px" class="texto">
							<input size="8" type="text" name="numeroGuiaPrestador" id="numeroGuiaPrestador" onBlur="atualizaNumeroGuia()" class="caixa" value="<%= banco.getCampo("numeroGuiaPrestador", rs) %>">
                        </td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td height="30">&nbsp;</td>
		</tr>
		<tr>
			<td width="100%">
				<table cellpadding="2" cellspacing="0" width="100%" align="left">
					<tr>
						<td>
							<table cellpadding="0" cellspacing="0" class="tabela" width="300px">
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
									<td class="texto">3-Nº da Guia da Solicitação / Senha</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="12px" align="center"><%= banco.getCampo("numeroGuiaPrincipal", rs) %>&nbsp;</td>
								</tr>
							</table>
						</td>
						<td width="300px">
							<table cellpadding="0" cellspacing="0" class="tabela" width="300px">
								<tr>
				                  <td height="12" class="texto">4-Data da Emissão da Guia</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="12px" align="center"><%= data %>&nbsp;</td>
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
									<td class="texto">5-Número da Carteira</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="12px" align="center"><%= banco.getCampo("numeroCarteira", rs) %>&nbsp;</td>
								</tr>
							</table>
						</td>
						<td width="180">
							<table cellpadding="0" cellspacing="0" class="tabela" width="100%">
								<tr>
									<td class="texto">6-Plano</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="12px" align="center"><%= banco.getCampo("nomePlano", rs) %>&nbsp;</td>
								</tr>
							</table>
						</td>
						<td width="130">
							<table cellpadding="0" cellspacing="0" class="tabela" width="100%">
								<tr>
									<td class="texto">7-Validade da Carteira</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="12px" align="center"><%= Util.formataData(banco.getCampo("validadeCarteira", rs)) %>&nbsp;</td>
								</tr>
							</table>
						</td>
						<td>
							<table cellpadding="0" cellspacing="0" class="tabela" width="100%">
								<tr>
				                  <td height="12" class="texto">8-Nome</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="12px" align="center"><%= banco.getCampo("nomeBeneficiario", rs) %>&nbsp;</td>
								</tr>
							</table>
						</td>
						<td width="230">
							<table cellpadding="0" cellspacing="0" class="tabela" width="100%">
								<tr>
									<td class="texto">9-Número do Cartão Nacional de Saúde</td>
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
			<td width="100%" class="tdescuro">Dados do Contratado (onde foi executado o procedimento)</td>
		</tr>
		<tr>
			<td width="100%">
				<table cellpadding="2" cellspacing="0" width="100%">
					<tr>
						<td width="220">
							<table cellpadding="0" cellspacing="0" class="tabela" width="100%">
								<tr>
				                  <td height="12" class="texto">10-Código na Operadora / CNPJ / CPF</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="12px" align="center">
										<%= banco.getCampo("identificacaoHospital", rs) %>&nbsp;
									</td>
								</tr>
							</table>
						</td>
						<td>
							<table cellpadding="0" cellspacing="0" class="tabela" width="100%">
								<tr>
									<td class="texto">11-Nome do Contratado</td>
								</tr>
								<tr>
					                  <td class="dados" valign="bottom" height="12px" align="center"><%= banco.getCampo("nomeContratado", rs) %>&nbsp;</td>
								</tr>
							</table>
						</td>
						<td width="100">
							<table cellpadding="0" cellspacing="0" class="tabela" width="100%">
								<tr>
									<td class="texto">12-Código CNES</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="12px" align="center"><%= banco.getCampo("numeroCNES", rs) %>&nbsp;</td>
								</tr>
							</table>
						</td>
					</tr>
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
									<td class="texto">13-Código na Operadora / CNPJ / CPF</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="12px" align="center"><%= banco.getCampo("identificacaoContratado", rs) %>&nbsp;</td>
								</tr>
							</table>
						</td>
						<td>
							<table cellpadding="0" cellspacing="0" class="tabela" width="100%">
								<tr>
									<td class="texto">14-Nome do Contratado Executante</td>
								</tr>
								<tr>
				                  <td class="dados" valign="bottom" height="12px" align="center"><%= banco.getCampo("contratado", rs) %></td>
								</tr>
							</table>
						</td>
						<td width="80">
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="100%">
								<tr>
									<td class="texto">15-Código CNES</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="12px" align="center">&nbsp;</td>
								</tr>
							</table>
						</td>
						<td width="200">
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="100%">
								<tr>
									<td class="texto">16-Tipo da Acomodação Autorizada</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="12px" align="center"><%= banco.getCampo("tipoAcomodacao", rs) %>&nbsp;</td>
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
						<td width="130">
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="100%">
								<tr>
									<td class="texto">17-Grau Part.</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="12px" align="center"><%= banco.getCampo("posicaoProfissional", rs) %></td>
								</tr>
							</table>
						</td>
						<td>
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="100%">
								<tr>
									<td class="texto">18-Nome do Profissional Executante</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="12px" align="center"><%= banco.getCampo("nomeProfissional", rs) %></td>
								</tr>
							</table>
						</td>
						<td width="130">
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="100%">
								<tr>
									<td class="texto">19-Conselho Profissional</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="12px" align="center"><%= banco.getCampo("siglaConselho", rs) %></td>
								</tr>
							</table>
						</td>
						<td width="130">
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="100%">
								<tr>
									<td class="texto">20-Número no Conselho</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="12px" align="center"><%= banco.getCampo("numeroConselho", rs) %>&nbsp;</td>
								</tr>
							</table>
						</td>
						<td width="50">
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="100%">
								<tr>
									<td class="texto">21-UF</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="12px" align="center"><%= banco.getCampo("ufConselho", rs) %>&nbsp;</td>
								</tr>
							</table>
						</td>
						<td width="80">
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="100%">
								<tr>
									<td class="texto">22-Número no CPF</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="12px" align="center"><input type="text" class="tiss"></td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td width="100%" class="tdescuro">Procedimentos Realizados</td>
		</tr>
		<tr>
			<td width="100%">
				<table cellpadding="2" cellspacing="0" width="100%" class="tabela">
					<tr>
						<td class="tdescuro">Ordem</td>
						<td class="tdescuro">23-Data</td>
						<td class="tdescuro">24-Hora Inicial</td>
						<td class="tdescuro">25-Hora Final</td>
						<td class="tdescuro">26-Tabela</td>
						<td class="tdescuro">27-Código do Procedimento</td>
						<td class="tdescuro">28-Descrição</td>
						<td class="tdescuro">29-Qtde.</td>
						<td class="tdescuro">30-Via</td>
						<td class="tdescuro">31-Tec.</td>
						<td class="tdescuro">32-%Red./Acresc.</td>
						<td class="tdescuro">33-Valor Unitário - R$</td>
						<td class="tdescuro">34-Valor Total - R$</td>
					</tr>
					<%= tiss.getProcedimentosExecutadosHonorarioIndividual(codGuia, cod_empresa)%>
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
									<td class="texto">36-Observação</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="30px" align="left"><%= banco.getCampo("observacao", rs)%>&nbsp;</td>
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
						<td width="50%" class="texto">37-Prestador</td>
						<td width="50%" class="texto">38-Beneficiário ou Responsável</td>
					</tr>
					<tr>
						<td>
							<table cellpadding="0" cellspacing="0" width="100%">
								<tr>
									<td class="texto">Data</td>
									<td class="texto">Hora</td>
									<td class="texto">Assinatura</td>
								</tr>
								<tr>
									<td class="dados"><input type="text" class="texto" value="<%= data%>"></td>
									<td class="dados"><input type="text" class="texto" value="<%= Util.getHora()%>"></td>
									<td class="dados">&nbsp;</td>
								</tr>
							</table>
						</td>
						<td>
							<table cellpadding="0" cellspacing="0" width="100%">
								<tr>
									<td class="texto">Data</td>
									<td class="texto">Hora</td>
									<td class="texto">Assinatura</td>
								</tr>
								<tr>
									<td class="dados"><input type="text" class="texto" value="<%= data%>"></td>
									<td class="dados"><input type="text" class="texto" value="<%= Util.getHora()%>"></td>
									<td class="dados">&nbsp;</td>
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

<iframe name="iframenumeroguia" id="iframenumeroguia" frameborder="0" width="0" height="0"></iframe>

</body>
</html>
