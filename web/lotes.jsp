<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.Lote" id="lote" scope="page"/>

<%
	String total = "0";
	String tipoGuia = "", ret = "";
	if(strcod != null) {
		rs = banco.getRegistro("lotesguias","codLote", Integer.parseInt(strcod) );
		tipoGuia = banco.getCampo("tipoGuia", rs);
		String tabela = lote.getNomeTabelaGuia(tipoGuia);
		total = banco.getValor("total", "SELECT COUNT(*) AS total FROM " + tabela + " WHERE codLote=" + strcod);
	}

	String gerouXML = banco.getCampo("gerouGuia", rs);

	if(ordem == null) ordem = "codLote DESC";
	
%>

<html>
<head>
<title>Lotes</title>
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
	 var nome_campos_obrigatorios = Array("Data da Transação", "Hora da Transação");
	 //Página a enviar o formulário
	 var page = "gravarlotes.jsp";
	 //Cod. da ajuda
	 cod_ajuda = 25;

     //Campos obrigatórios
	 var campos_obrigatorios = Array("dataRegistroTransacao", "horaRegistroTransacao");

	 var gerouXML = "<%= gerouXML %>";
	 var mandouGerar = "<%= request.getParameter("gerar")%>";

	function iniciar() {
		barrasessao();
		inicio();
			
		if(mandouGerar == "S")
			mensagem("XML gerado com sucesso", 1);
	}
	
	function botExcluir() {
		if(idReg != "null") {
			if(gerouXML == "S") {
				confi= confirm("Lote já gerou arquivo XML.\nAo excluir o lote, todas as guias sairão do lote e poderão entrar em novo lote.\nConfirma exclusão do lote?");
				if(!confi) return;
			}
			enviarAcao('exc');	
		}
	}
	
	function botSalvar() {
		if(gerouXML == "S" && idReg != "null") {
			alert("ATENÇÃO!\n\nLote já gerou arquivo. Qualquer alteração necessita da geração novamente do arquivo XML");
		}
		enviarAcao('inc');
	}
	
	function mostrarGuias(codLote, tipoGuia) {
		<% if(tipoGuia.equals("3")) {%>
			alert("Guia de Honorário Individual não pode ser editada");
		<% } else {%>
		if(codLote != "" && codLote != "null") {
			window.location = "listaconsultaslote.jsp?cod=" + codLote + "&gerouxml=<%= gerouXML%>" + "&tipoguia=" + tipoGuia;
		}
		else {
			mensagem("Escolha um lote para a visualização das guias", 2);
		}
		<% } %>				
	}

	function gerarXML() {
		alert("Geração de XML TISS desabilidado nessa versão. Para gerar XML, <%= contato%>");
	}

	function gerarXMLOld() {
		alert("Geração de XML TISS desabilidado nessa versão. Para gerar XML, <%= contato%>");
	}
	
	function gerarRelatorio() {
		var jstipo = cbeGetElementById("tiporel").value;

		window.open("rellote2.jsp?lote=" + idReg + "&tiporel=" + jstipo,'rellote','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,menubar=no,width=700,height=550,top=10,left=10');			
	}

</script>
</head>

<body onLoad="iniciar()">
<%@include file="barrasessao.jsp" %>
<form name="frmcadastrar" id="frmcadastrar" action="gravarlotes.jsp" method="post">
  <table width="600" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr>
      <td width="651" height="18" class="title">.: Lotes de Guias :.</td>
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
	            <td width="60" class="tdMedium">Convênio: </td>
				<td class="tdLight"><%= banco.getCampo("identificacao", rs)%>&nbsp;</td>
	            <td class="tdMedium">Código ANS:</td>
				<td class="tdLight"><%= banco.getCampo("registroANS", rs)%>&nbsp;</td>
			</tr>
            <tr>
	            <td class="tdMedium">Tipo de Transação: </td>
       	       	<td colspan="3" class="tdLight"><%= banco.getCampo("tipoTransacao", rs)%>&nbsp;</td>
            </tr>
            <tr>
	            <td class="tdMedium">Data da Transação: *</td>
       	       	<td class="tdLight"><input type="text" name="dataRegistroTransacao" id="dataRegistroTransacao" class="caixa" value="<%= Util.formataData(banco.getCampo("dataRegistroTransacao", rs))%>" onKeyPress="return formatar(this, event, '##/##/####'); " maxlength="10" size="10"></td>
	            <td class="tdMedium">Hora da Transação: *</td>
       	       	<td class="tdLight"><input type="text" name="horaRegistroTransacao" id="horaRegistroTransacao" class="caixa" value="<%= Util.formataHora(banco.getCampo("horaRegistroTransacao", rs))%>" onKeyPress="return formatar(this, event, '##:##'); " maxlength="5" size="5"></td>
            </tr>
            <tr>
	            <td class="tdMedium">Tipo do Cód. do Prestador: </td>
       	       	<td class="tdLight"><%= banco.getCampo("tipoCodigoPrestadorNaOperadora", rs)%>&nbsp;</td>
	            <td class="tdMedium">Cód. Prestador na Operadora: </td>
       	       	<td class="tdLight"><%= banco.getCampo("codigoPrestadorNaOperadora", rs)%>&nbsp;</td>
            </tr>
			<tr>
	            <td class="tdMedium">Tipo de Guias:</td>
				<td class="tdLight">
				<%= lote.getTipoGuia(tipoGuia)%>&nbsp;</td>
				<td class="tdMedium">Guias Cadastradas: ( <%= total%> )</td>
				<td class="tdLight" align="center"><a title='Listagem de Guias do Lote' href="Javascript:mostrarGuias('<%= strcod%>','<%= tipoGuia%>')"><img src="images/6.gif" border=0></a></td>
			</tr>
            <tr>
	            <td class="tdMedium">Data Previsão:</td>
       	       	<td class="tdLight"><input type="text" name="dataprevisao" id="dataprevisao" class="caixa" value="<%= Util.formataData(banco.getCampo("dataprevisao", rs))%>" onKeyPress="return formatar(this, event, '##/##/####'); " maxlength="10" size="10"></td>
	            <td class="tdMedium">nº NF: </td>
       	       	<td class="tdLight"><input type="text" name="nf" id="nf" class="caixa" value="<%= banco.getCampo("nf", rs)%>" maxlength="10" size="10"></td>
            </tr>
            <tr>
            	<td class="tdMedium">Observação:</td>
                <td colspan="3" class="tdLight"><textarea class="caixa" name="obs" id="obs" rows="3" style="width:100%"><%= banco.getCampo("obs", rs)%></textarea></td>
            </tr>
			<% if(!Util.isNull(strcod)) { %>
			<tr>	
				<td class="tdMedium">Gerar XML:</td>
				<td colspan="3" class="tdLight">
                	&nbsp;<a href="Javascript:gerarXML()" title="Gerar XML"><img src="images/grava.gif" border="0"></a> (Versão Atual 2.02.01)
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <a href="Javascript:gerarXMLOld()" title="Gerar XML Versão Antiga"><img src="images/grava.gif" border="0"></a> (Versão Antiga do TISS 2.01.03)                    
                 </td>
			</tr>
			<% } %>
			<% if(gerouXML != null && gerouXML.equals("S")) { %>
			<tr>
				<td class="tdMedium">Arquivo:</td>
				<td colspan="3" class="tdLight">
				<%
					if(tipoGuia.equals("1"))
						out.println("<a title='Para abaixar o arquivo, botão direito e Salvar destino como...' href='xml/lote" + strcod + "_Consulta.xml'>/xml/lote" + strcod + "_Consulta.xml</a>");
					else if(tipoGuia.equals("2"))
						out.println("<a title='Para abaixar o arquivo, botão direito e Salvar destino como...' href='xml/lote" + strcod + "_SADT.xml'>/xml/lote" + strcod + "_SADT.xml</a>");
					else if(tipoGuia.equals("3"))
						out.println("<a title='Para abaixar o arquivo, botão direito e Salvar destino como...' href='xml/lote" + strcod + "_HonorarioIndividual.xml'>/xml/lote" + strcod + "_HonorarioIndividual.xml</a>");
					else if(tipoGuia.equals("4"))
						out.println("<a title='Para abaixar o arquivo, botão direito e Salvar destino como...' href='xml/lote" + strcod + "_ResumoInternacao.xml'>/xml/lote" + strcod + "_ResumoInternacao.xml</a>");
				%>
				</td>
			</tr>
            <tr>
            	<td class="tdMedium">Relatório:</td>
                <td class="tdLight" colspan="3">
                	Tipo de Relatório: 
					<select name="tiporel" id="tiporel" class="caixa">
						<option value="2">Cabeçalho + Listagem</option>
						<option value="1">Só cabeçalho</option>
					</select>
					&nbsp;&nbsp;&nbsp;&nbsp;
                	<button class="botao" type="button" onClick="gerarRelatorio()"><img src="images/print.gif">&nbsp;&nbsp;&nbsp;Imprimir</button>
                </td>
            </tr>
			<% } %>
          </table>
      </td>
    </tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
    <tr align="center" valign="top">
      <td width="100%">
            <table width="100%" border="0" cellpadding="0" cellspacing="0" class="table">
				<tr>
				<td class="tdMedium" style="text-align:center"><button name="exclui" id="exclui" type="button" class="botao" style="width:70px" onClick="botExcluir()"><img src="images/delete.gif">&nbsp;&nbsp;&nbsp;Excluir</button></td>
				<td class="tdMedium" style="text-align:center"><button name="salva" id="salva" type="button" class="botao" style="width:70px" onClick="botSalvar()"><img src="images/grava.gif">&nbsp;&nbsp;&nbsp;Salvar</button></td>
					<td class="tdMedium" style="text-align:left">
						<input type="text" name="pesq" id="pesq" class="caixa" value="<%= pesq %>" style="width:150px">&nbsp;
						<select name="tipo" id="tipo" class="caixa">
							<option value="1"<%= banco.getSel(tipo, 1)%>>Exata</option>
							<option value="2"<%= banco.getSel(tipo, 2)%>>Início</option>							
							<option value="3"<%= banco.getSel(tipo, 3)%>>Meio</option>
						</select>
						<button type="button" class="botao" style="width:80px" onClick="buscar('lotes');"><img src='images/busca.gif' height='17'>&nbsp;Consultar</button></td>
				</tr>
			</table>
	  </td>
    </tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
    <tr>
		<td width="100%" style="text-align:center">
			<table width="600px">
				<tr>
					<td width="40" class="tdDark">nº Lote</td>
		            <td width="80" class="tdDark">Data</td>
					<td width="100" class="tdDark">Tipo de Guia</td>
					<td class="tdDark">Convênio</td>
					<td width="40" class="tdDark" align="center">XML</td>
				</tr>
			</table>
			<div style="width:600; height:101; overflow: auto">
				<table width="100%">
				    <%
						String resp[] = lote.getLotes(pesq, "identificacao", ordem, numPag, 50, tipo, cod_empresa);
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
