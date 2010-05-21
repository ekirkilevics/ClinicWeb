<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.TISS" id="tiss" scope="page"/>
<jsp:useBean class="recursos.HonorarioIndividual" id="honorario" scope="page"/>


<%
	//Gerar a guia de Honor�rio Individual
	String reto = tiss.gerarGuiaResumoInternacao(strcod, nome_usuario, cod_empresa);
	
	if(!reto.equals("OK")) out.println(reto);	
	
	if(strcod != null) rs = banco.getRegistro("guiasresumointernacao","codGuia", Integer.parseInt(strcod) );

	String codANS = banco.getCampo("registroANS", rs);
	String data = Util.formataData(banco.getCampo("dataEmissaoGuia", rs));
	String codGuia = banco.getCampo("codGuia", rs);

%>

<html>
<head>
<title>TISS - Guia de Resumo de Interna��o</title>
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
		frm.action = "atualizanumeroguia.jsp?tipoGuia=4&cod=<%= strcod%>";
		frm.target = "iframenumeroguia";
		frm.submit();
		alert("N�mero de guia alterado com sucesso");
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
						<td style="text-align:center"><h5>GUIA DE RESUMO DE INTERNA��O</h5></td>
						<td width="40" class="texto">2-n�</td>
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
									<td class="texto">3-N� da Guia de Solicita��o</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="12px" align="center"><%= banco.getCampo("numeroGuiaSolicitacao", rs) %>&nbsp;</td>
								</tr>
							</table>
						</td>
						<td width="300px">
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="150px">
								<tr>
				                  <td height="12" class="texto">4-Data da Autoriza��o</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="12px" align="center"><%= Util.formataData(banco.getCampo("dataAutorizacao", rs)) %>&nbsp;</td>
								</tr>
							</table>
						</td>
						<td width="300px">
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="150px">
								<tr>
				                  <td height="12" class="texto">5-Senha</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="12px" align="center"><%= banco.getCampo("senhaAutorizacao", rs) %>&nbsp;</td>
								</tr>
							</table>
						</td>
						<td width="300px">
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="150px">
								<tr>
				                  <td height="12" class="texto">6-Data Validade da Senha</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="12px" align="center"><%= Util.formataData(banco.getCampo("validadeSenha", rs)) %>&nbsp;</td>
								</tr>
							</table>
						</td>
						<td width="300px">
							<table cellpadding="0" cellspacing="0" class="tabela" width="150px">
								<tr>
				                  <td height="12" class="texto">7-Data de Emiss�o da Guia</td>
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
			<td width="100%" class="tdescuro">Dados do Benefici�rio</td>
		</tr>
		<tr>
			<td width="100%">
				<table cellpadding="2" cellspacing="0" width="100%">
					<tr>
						<td width="100">
							<table cellpadding="0" cellspacing="0" class="tabela" width="100%">
								<tr>
									<td class="texto">8-N�mero da Carteira</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="12px" align="center"><%= banco.getCampo("numeroCarteira", rs) %>&nbsp;</td>
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
									<td class="texto">12-N�mero do Cart�o Nacional de Sa�de</td>
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
			<td width="100%" class="tdescuro">Dados do Contratado Executante</td>
		</tr>
		<tr>
			<td width="100%">
				<table cellpadding="2" cellspacing="0" width="100%">
					<tr>
						<td width="170">
							<table cellpadding="0" cellspacing="0" class="tabela" width="100%">
								<tr>
									<td class="texto">13-C�digo na Operadora / CNPJ / CPF</td>
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
									<td class="texto">15-C�digo CNES</td>
								</tr>
								<tr>
									<td class="dados" align="center"><%= banco.getCampo("codCNES", rs) %>&nbsp;</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
        <tr>
        	<td width="100%">
            	<table cellpadding="0" cellspacing="0" width="100%">
                	<tr>
						<td width="50">
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="100%">
								<tr>
									<td class="texto">16-T.L.</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="12px" align="center"><%= configuracao.getItemConfig("tipoLogradouro", cod_empresa)%>&nbsp;</td>
								</tr>
							</table>
						</td>
						<td width="220">
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="100%">
								<tr>
									<td class="texto">17-18-19-Logradouro - N�mero - Complemento</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="12px" align="center"><%= configuracao.getItemConfig("logradouro", cod_empresa)%>, <%= configuracao.getItemConfig("numero", cod_empresa)%>, <%= configuracao.getItemConfig("complemento", cod_empresa)%>&nbsp;</td>
								</tr>
							</table>
						</td>
						<td width="120">
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="100%">
								<tr>
									<td class="texto">20-Munic�pio</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="12px" align="center"><%= configuracao.getItemConfig("cidade", cod_empresa)%>&nbsp;</td>
								</tr>
							</table>
						</td>
						<td width="40">
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="100%">
								<tr>
									<td class="texto">21-UF</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="12px" align="center"><%= configuracao.getItemConfig("UF", cod_empresa)%>&nbsp;</td>
								</tr>
							</table>
						</td>
						<td width="80">
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="100%">
								<tr>
									<td class="texto">22-C�d. IBGE</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="12px" align="center"><%= configuracao.getItemConfig("codigoIBGEMunicipio", cod_empresa)%>&nbsp;</td>
								</tr>
							</table>
						</td>
						<td width="70">
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="100%">
								<tr>
									<td class="texto">23-CEP</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="12px" align="center"><%= configuracao.getItemConfig("cep", cod_empresa)%>&nbsp;</td>
								</tr>
							</table>
						</td>
                     </tr>
                </table>
            </td>
        </tr>
		<tr>
			<td width="100%" class="tdescuro">Dados da Interna��o</td>
		</tr>
		<tr>
			<td width="100%">
				<table cellpadding="2" cellspacing="0" width="100%">
					<tr>
						<td width="200">
							<table cellpadding="0" cellspacing="0" class="tabela" width="100%">
								<tr>
									<td class="texto">24-Car�ter da Solicita��o</td>
								</tr>
								<tr>
									<td class="texto" valign="bottom" height="12px">
										|<strong>&nbsp;<%= banco.getCampo("caraterInternacao", rs)%>&nbsp;</strong>| E-Eletiva &nbsp;&nbsp;U-Urg&ecirc;ncia/Emerg&ecirc;ncia
									</td>
								</tr>
							</table>
						</td>
						<td width="150">
							<table cellpadding="0" cellspacing="0" class="tabela" width="100%">
								<tr>
									<td class="texto">25-Tipo da Acomoda��o Autorizada</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="12px" align="center"><%= banco.getCampo("acomodacao", rs) %>&nbsp;</td>
								</tr>
							</table>
						</td>
						<td width="150">
							<table cellpadding="0" cellspacing="0" class="tabela" width="100%">
								<tr>
									<td class="texto">26-Data/Hora da Interna��o</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="12px" align="center"><%= Util.formataDataHora(banco.getCampo("dataHoraInternacao", rs)) %>&nbsp;</td>
								</tr>
							</table>
						</td>
						<td width="150">
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="100%">
								<tr>
									<td class="texto">27-Data/Hora de Sa�da Interna��o</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="12px" align="center"><%= Util.formataDataHora(banco.getCampo("dataHoraInternacao", rs)) %>&nbsp;</td>
								</tr>
							</table>
						</td>
						<td>
							<table cellpadding="0" cellspacing="0" class="tabela" width="100%">
								<tr>
									<td class="texto">28-Tipo Interna��o</td>
								</tr>
								<tr>
									<td class="texto" valign="bottom" height="12px" >
										|<strong>&nbsp;<%= banco.getCampo("tipoInternacao", rs)%>&nbsp;</strong>| 1-Cl�nica&nbsp;&nbsp;2-Cir�rgica&nbsp;&nbsp;3-Obst�trica&nbsp;&nbsp;4-Pedi�trica&nbsp;&nbsp;5-Psiqui�trica
                                    </td>
								</tr>
							</table>
						</td>
						<td>
							<table cellpadding="0" cellspacing="0" class="tabela" width="100%">
								<tr>
									<td class="texto">29-Regime de Interna��o</td>
								</tr>
								<tr>
									<td class="texto" valign="bottom" height="12px">
										|<strong>&nbsp;<%= banco.getCampo("regimeInternacao", rs)%>&nbsp;</strong>| 1-Hospital &nbsp;&nbsp;2-Hospital-dia&nbsp;&nbsp;3-Domiciliar
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
						<td width="100%">
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="100%">
								<tr>
									<td class="texto">30-Interna��o Obst�trica - selecione mais de um se necess�rio com "X"</td>
								</tr>
								<tr>
									<td class="texto" valign="bottom" height="12px" align="left">
										<%= honorario.check("emGestacao", rs, "Em gesta��o") %>
                                        <%= honorario.check("aborto", rs, "Aborto")%>
                                        <%= honorario.check("transtornoMaternoRelGravidez", rs, "Transtorno Materno Relacionado � Gravidez")%>
                                        <%= honorario.check("complicacaoPeriodoPuerperio", rs, "Complic. Puerp�rio")%>
                                        <%= honorario.check("atendimentoRNSalaParto", rs, "Atend. ao RN na sala de parto")%>
                                        <%= honorario.check("complicacaoNeonatal", rs, "Complica��o Neonatal")%>
                                        <%= honorario.check("baixoPeso", rs, "Bx. Peso &lt;2,5 Kg.")%>
                                        <%= honorario.check("partoCesareo", rs, "Parto Ces�reo")%>
                                        <%= honorario.check("partoNormal", rs, "Parto Normal")%>
                                        
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
        <tr>
        	<td width="100%">
            	<table cellpadding="0" cellspacing="0" width="100%">
                	<tr>
						<td>
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="100%">
								<tr>
									<td class="texto">31-Se �bito em mulher</td>
								</tr>
								<tr>
									<td class="texto" valign="bottom" height="12px">
						|<strong>&nbsp;<%= banco.getCampo("obitoMulher", rs)%>&nbsp;</strong>| <strong>1-</strong>Gr�vida &nbsp;<strong>2-</strong>at� 42 dias ap�s fim gesta��o &nbsp;<strong>3-</strong>de 43 dias a 12 meses ap�s fim gesta��o
                                    </td>
								</tr>
							</table>
						</td>
						<td>
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="100%">
								<tr>
									<td class="texto">32-Se �bito neonatal</td>
								</tr>
								<tr>
									<td class="texto" valign="bottom" height="12px">
                                    	|<strong>&nbsp;<%= banco.getCampo("qtdeobitoPrecoce", rs) %>&nbsp;</strong>|Qtde. �bito neonatal precoce&nbsp;&nbsp;
										|<strong>&nbsp;<%= banco.getCampo("qtdeobitoTardio", rs) %>&nbsp;</strong>| Qtde. �bito neonatal tardio
                                    </td>
								</tr>
							</table>
						</td>
						<td>
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="100%">
								<tr>
									<td class="texto">33-n� Decl. Nasc. Vivos</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="12px" align="center"><%= banco.getCampo("declaracoesNascidosVivos", rs) %>&nbsp;</td>
								</tr>
							</table>
						</td>
						<td>
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="100%">
								<tr>
									<td class="texto">34-Qtde. Nasc. Vivos a Termo</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="12px" align="center"><%= banco.getCampo("qtdNascidosVivosTermo", rs) %>&nbsp;</td>
								</tr>
							</table>
						</td>
						<td>
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="100%">
								<tr>
									<td class="texto">35-Qtde. Nasc. Mortos</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="12px" align="center"><%= banco.getCampo("qtdNascidosMortos", rs) %>&nbsp;</td>
								</tr>
							</table>
						</td>
						<td>
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="100%">
								<tr>
									<td class="texto">36-Qtde. Nasc. Vivos Prematuro</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="12px" align="center"><%= banco.getCampo("qtdVivosPrematuros", rs) %>&nbsp;</td>
								</tr>
							</table>
						</td>
                     </tr>
                </table>
            </td>
        </tr>
		<tr>
			<td width="100%" class="tdescuro">Dados da Sa�da da Interna��o</td>
		</tr>
		<tr>
			<td width="100%">
				<table cellpadding="2" cellspacing="0" width="100%">
					<tr>
						<td width="170">
							<table cellpadding="0" cellspacing="0" class="tabela" width="100%">
								<tr>
									<td class="texto">37-CID 10 Principal</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" align="center"><%= banco.getCampo("codigoDiagnostico", rs) %>&nbsp;</td>
								</tr>
							</table>
						</td>
						<td>
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="100%">
								<tr>
									<td class="texto">38-CID 10 (2)</td>
								</tr>
								<tr>
				                  <td class="dados" valign="bottom" align="center">&nbsp;</td>
								</tr>
							</table>
						</td>
						<td>
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="100%">
								<tr>
									<td class="texto">39-CID 10 (3)</td>
								</tr>
								<tr>
				                  <td class="dados" valign="bottom" align="center">&nbsp;</td>
								</tr>
							</table>
						</td>
						<td>
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="100%">
								<tr>
									<td class="texto">40-CID 10 (4)</td>
								</tr>
								<tr>
				                  <td class="dados" valign="bottom" align="center">&nbsp;</td>
								</tr>
							</table>
						</td>
						<td>
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="100%">
								<tr>
									<td class="texto">41-Indicador de Acidente</td>
								</tr>
								<tr>
				                  <td class="texto" valign="bottom" height="12px" align="left">
						|<strong>&nbsp;<%= banco.getCampo("indicadorAcidente", rs)%>&nbsp;</strong>| <strong>0-</strong>Acidente ou doen�a relacionado ao trabalho &nbsp;<strong>1-</strong>Tr�nsito &nbsp;<strong>2-</strong>Outros
                                  </td>
								</tr>
							</table>
						</td>
						<td>
							<table cellpadding="0" cellspacing="0" class="tabela" width="100%">
								<tr>
									<td class="texto">42-Motivo Sa�da</td>
								</tr>
								<tr>
									<td class="dados" align="center"><%= banco.getCampo("motivoSaidaInternacao", rs)%>&nbsp;</td>
								</tr>
							</table>
						</td>
						<td>
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="100%">
								<tr>
									<td class="texto">43-CID 10 �bito</td>
								</tr>
								<tr>
									<td class="dados" align="center">&nbsp;</td>
								</tr>
							</table>
						</td>
						<td>
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="100%">
								<tr>
									<td class="texto">44-N� declara��o do �bito</td>
								</tr>
								<tr>
									<td class="dados" align="center">&nbsp;</td>
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
						<td class="tdescuro">Ordem</td>
						<td class="tdescuro">45-Data</td>
						<td class="tdescuro">46-Hora Inicial</td>
						<td class="tdescuro">47-Hora Final</td>
						<td class="tdescuro">48-Tabela</td>
						<td class="tdescuro">49-C�digo do Procedimento</td>
						<td class="tdescuro">50-Descri��o</td>
						<td class="tdescuro">51-Qtde.</td>
						<td class="tdescuro">52-Via</td>
						<td class="tdescuro">53-Tec.</td>
						<td class="tdescuro">54-%Red./Acresc.</td>
						<td class="tdescuro">55-Valor Unit�rio - R$</td>
						<td class="tdescuro">56-Valor Total - R$</td>
					</tr>
					<%= tiss.getProcedimentosExecutadosResumoInternacao(codGuia, cod_empresa)%>
				</table>
			</td>
		</tr>
		<tr>
			<td width="100%" class="tdescuro">Identifica��o da Equipe</td>
		</tr>
		<tr>
			<td width="100%">
				<table cellpadding="2" cellspacing="0" width="100%" class="tabela">
					<tr>
						<td class="tdescuro" width="70">57-Seq.Ref.</td>
						<td class="tdescuro" width="70">58-Gr.Part.</td>
						<td class="tdescuro">59-C�d. Operadora/CPF</td>
						<td class="tdescuro">60-Nome do Profissional</td>
						<td class="tdescuro" width="100" nowrap>61-Conselho Prof.</td>
						<td class="tdescuro" width="130" nowrap>62-N�mero Conselho</td>
						<td class="tdescuro" width="45">63-UF</td>
						<td class="tdescuro">64-CPF</td>
					</tr>
					<%= tiss.getProfEquipeResumoInternacao(codGuia, cod_empresa)%>
				</table>
			</td>
		</tr>
		<tr>
			<td width="100%">
				<table cellpadding="2" cellspacing="0" width="100%">
					<tr>
						<td>
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="100%" height="100%">
								<tr>
									<td class="texto">73-Tipo Faturamento R$</td>
								</tr>
								<tr>
									<td class="texto" valign="bottom">
                                    	|<b>&nbsp;<%= banco.getCampo("tipoFaturamento", rs)%>&nbsp;</b>| T-Total &nbsp;P-Parcial
                                    </td>
								</tr>
							</table>
						</td>
						<td>
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="100%">
								<tr>
									<td class="texto">74-Total Procedimentos R$</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="15px" align="center"><%= banco.getCampo("servicosExecutados", rs)%>&nbsp;</td>
								</tr>
							</table>
						</td>
						<td>
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="100%">
								<tr>
									<td class="texto">75-Total Di�rias R$</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="15px" align="center"><%= banco.getCampo("taxas", rs)%>&nbsp;</td>
								</tr>
							</table>
						</td>
						<td>
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="100%">
								<tr>
									<td class="texto">76-Total Taxas e Alugu�is R$</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="15px" align="center"><%= banco.getCampo("materiais", rs)%>&nbsp;</td>
								</tr>
							</table>
						</td>
						<td>
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="100%">
								<tr>
									<td class="texto">77-Total Materiais R$</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="15px" align="center"><%= banco.getCampo("medicamentos", rs)%>&nbsp;</td>
								</tr>
							</table>
						</td>
						<td>
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="100%">
								<tr>
									<td class="texto">78-Total Medicamentos R$</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="15px" align="center"><%= banco.getCampo("diarias", rs)%>&nbsp;</td>
								</tr>
							</table>
						</td>
						<td>
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="100%">
								<tr>
									<td class="texto">79-Total Gases Medicinais R$</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="15px" align="center"><%= banco.getCampo("gases", rs)%>&nbsp;</td>
								</tr>
							</table>
						</td>
						<td>
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="100%">
								<tr>
									<td class="texto">80-Total Geral R$</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="15px" align="center"><%= banco.getCampo("totalGeral", rs)%> &nbsp;</td>
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
						<td width="50%" class="texto">82-Data e Assinatura do Contratado</td>
						<td width="50%" class="texto">83-Data e Assinatura do(s) auditor(es) da Operadora</td>
					</tr>
					<tr>
						<td width="50%" class="texto">___________/___________/__________________</td>
						<td width="50%" class="texto">___________/___________/__________________</td>
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
