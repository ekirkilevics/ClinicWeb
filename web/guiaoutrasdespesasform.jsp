<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.TISS" id="tiss" scope="page"/>

<%
	String codGuia = request.getParameter("cod");

    //resp[0] = Reg. ANS
    //resp[1] = Guia de Referência
    //resp[2] = Cód. prestador na operadora
    //resp[3] = nome contratado
    //resp[4] = cód. CNES
    //resp[5] = gases
    //resp[6] = medicamentos
    //resp[7] = materiais
    //resp[8] = taxas
    //resp[9] = diarias
    //resp[10] = total
	String dadosGuia[] = tiss.getDadosGuia(codGuia, cod_empresa);
	
%>

<html>
<head>
<title>TISS - Guia de Outras Despesas</title>
<link href="css/tisscss.css" rel="stylesheet" type="text/css">
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
<script language="Javascript" src="CBE/cbe_util.js"></script>
<script language="JavaScript">

	function imprimeGuia() {
		self.print();	
	}


</script>
</head>

<body marginheight="10" onLoad="imprimeGuia()">
<form name="frmcadastrar" id="frmcadastrar" action="#" method="post">
	<table width="100%" cellpadding="0" cellspacing="0" class="tabela">
		<tr>
			  <td align="right"><span name='msg' id='msg' class="msg">&nbsp;</span></td>
		</tr>
		<tr>
			<td width="100%">
				<table border="0" width="100%" cellpadding="0" cellspacing="0">
					<tr>
						<td style="text-align:left; padding-left:20px">
							<%
								if(Util.existeArquivo("images/logo" + cod_empresa + ".gif"))
									out.println("<img src='images/logo" + cod_empresa + ".gif' border='0'>");

								if(Util.existeArquivo("images/logo" + dadosGuia[0] + ".jpg"))
									out.println("<img src='images/logo" + dadosGuia[0] + ".jpg' border='0'>");
							%>
						</td>
						<td style="text-align:left"><h5>GUIA DE OUTRAS DESPESAS</h5></td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td width="100%">
				<table cellpadding="2" cellspacing="0" width="100%" align="left">
					<tr>
						<td width="20%">
							<table cellpadding="0" cellspacing="0" class="tabela" width="100%">
								<tr>
									<td class="texto">1-Registro ANS</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="12px" align="center"><%= dadosGuia[0] %>&nbsp;</td>
								</tr>
							</table>
						</td>
						<td width="80%">
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="100%">
								<tr>
				                     <td height="12" class="texto">2-Nº da Guia de Referência</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="12px" align="left"><%= dadosGuia[1] %>&nbsp;</td>
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
									<td class="texto">3-Código na Operadora / CNPJ / CPF</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="12px" align="center">
										<%= dadosGuia[2] %>
									</td>
								</tr>
							</table>
						</td>
						<td>
							<table cellpadding="0" cellspacing="0" class="tabela" width="100%">
								<tr>
									<td class="texto">4-Nome do Contratado</td>
								</tr>
								<tr>
				                  <td class="dados" valign="bottom" height="12px" align="center"><%= dadosGuia[3] %></td>
								</tr>
							</table>
						</td>

						<td width="80">
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="100%">
								<tr>
									<td class="texto">5-Código CNES</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="12px" align="center"><%= dadosGuia[4] %>&nbsp;</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td width="100%" class="tdescuro">Código de Despesas Realizadas &nbsp;&nbsp;&nbsp;&nbsp;CD = 1-Gases Medicinais&nbsp;&nbsp;&nbsp;&nbsp;2-Medicamentos&nbsp;&nbsp;&nbsp;&nbsp;3-Materiais&nbsp;&nbsp;&nbsp;&nbsp;4-Taxas Diversas&nbsp;&nbsp;&nbsp;&nbsp;5-Diárias&nbsp;&nbsp;&nbsp;&nbsp;6-Aluguéis</td>
		</tr>
		<tr>
			<td width="100%">
				<table cellpadding="0" cellspacing="0" width="100%">
					<%= tiss.getItensOutrasDespesas(codGuia, cod_empresa)%>
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
									<td class="texto">17-Total Gases Medicinais R$</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="15px" align="center"><%= dadosGuia[5] %></td>
								</tr>
							</table>
						</td>
						<td>
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="100%">
								<tr>
									<td class="texto">18-Total Medicamentos R$</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="15px" align="center"><%= dadosGuia[6] %></td>
								</tr>
							</table>
						</td>
						<td>
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="100%">
								<tr>
									<td class="texto">19-Total Materiais R$</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="15px" align="center"><%= dadosGuia[7] %></td>
								</tr>
							</table>
						</td>
						<td>
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="100%">
								<tr>
									<td class="texto">20-Total Taxas Diversas R$</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="15px" align="center"><%= dadosGuia[8] %></td>
								</tr>
							</table>
						</td>
						<td>
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="100%">
								<tr>
									<td class="texto">21-Total Diárias e Aluguéis R$</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="15px" align="center"><%= dadosGuia[9] %></td>
								</tr>
							</table>
						</td>
						<td>
							<table cellpadding="0" cellspacing="0" class="tabelaescura" width="100%">
								<tr>
									<td class="texto">22-Total Geral R$</td>
								</tr>
								<tr>
									<td class="dados" valign="bottom" height="15px" align="center"><%= dadosGuia[10] %></td>
								</tr>
							</table>
						</td>

					</tr>
				</table>
			</td>
		</tr>
	</table>
</form>

</body>
</html>
