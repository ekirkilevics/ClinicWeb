<%@include file="cabecalho.jsp" %>
<%@page import="java.util.Vector" %>

<jsp:useBean class="recursos.Historico" id="historico" scope="page"/>
<jsp:useBean class="recursos.Paciente" id="paciente" scope="page"/>
<jsp:useBean class="recursos.Profissional" id="profissional" scope="page"/>

<%
	String codcli     		= request.getParameter("codcli") !=null ? request.getParameter("codcli") : "";
	String nomepaciente   	=  "";	
	String nascimento 		=  "";	
	String idade      		=  "";	
	String foto 			= "";	
	
	if(ordem == null) ordem = "DESC";

	//Se escolheu o paciente, capturar os dados
	if(!codcli.equals("")) {
		String dadospaciente[] = paciente.getDadosPaciente(codcli);
		foto = dadospaciente[1];
		nomepaciente = dadospaciente[2];
	}
	
	//Captura dados do profissional logado
	String proflogado[] = profissional.getProfissional((String)session.getAttribute("usuario"));
	
%>

<html>
<head>
<title>Histórico</title>
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
<script language="JavaScript" src="js/ajax.js"></script>
<script language="JavaScript">
     //código do paciente
     var codcli = "<%= codcli%>";
	 //Informação
	 var inf = "<%= inf%>";
	 //Nome dos campos
	 var nome_campos_obrigatorios = Array("");
	 //Página a enviar o formulário
	 var page = "gravarhistoricopac.jsp";
	 //Cod. da ajuda
	 cod_ajuda = 13;

     //Campos obrigatórios
	 var campos_obrigatorios = Array("");

	 //Ordem da data
	 var jsordem = "<%= ordem%>";
	 
	 //Profissional logado
	 var prof_reg = "<%= proflogado[0]%>";
	 
	function historia(codhist)	 
	{
		//Nova história, mandar cod. paciente
		if (codhist == -1) {
			codcli = getObj("","codcli").value;
			displayPopup("novahistoria.jsp?codcli=" + codcli , "historia",580,790, "yes");
		}
		else {
			displayPopup("novahistoria.jsp?cod=" + codhist + "&codcli=" + codcli , "historia"+codhist,580,790, "yes");
		}
		
		barrasessao();
	}
	
	function iniciar()
	{	
		var codcli = cbeGetElementById("codcli").value;
	
		if(codcli != "") {
			cbeGetElementById("novahistoria").disabled = false;
			cbeGetElementById("btnalerta").disabled = false;
			cbeGetElementById("btnexames").disabled = false;
			cbeGetElementById("btnimagem").disabled = false;
			cbeGetElementById("btndadospaciente").disabled = false;
			cbeGetElementById("btnprotocolo").disabled = false;
		}
		else {
			getObj("","novahistoria").disabled = true;
			cbeGetElementById("nome").focus();
		}

		<% if(!codcli.equals("")) {%>		
			try {
				closeAll();
				view(1);
			}
			catch(e) {}
		<% } %>
		hideAll();
	}
	
	function view(num)
	{
		eval("situacao=cbeGetElementById('tr"+num+"').style.display");
		if(situacao=="none") {
			eval("cbeGetElementById('tr"+num+"').style.display = 'block'");
			eval("cbeGetElementById('img"+num+"').src = 'images/minus.png'");
		}
		else {
			eval("cbeGetElementById('tr"+num+"').style.display = 'none'");
			eval("cbeGetElementById('img"+num+"').src = 'images/plus.png'");
		}
	}
	
	function closeAll()
	{
		var cont=1;
		var obj = null;
		var valor_total = getObj("","total").value;
		for(i=1; i<=valor_total; i++) {
			eval("cbeGetElementById('tr"+i+"').style.display = 'none'");
			eval("cbeGetElementById('img"+i+"').src = 'images/plus.png'");
		}
	}

	function openAll()
	{
		var cont=1;
		var obj = null;
		var valor_total = getObj("","total").value;
		for(i=1; i<=valor_total; i++) {
			eval("cbeGetElementById('tr"+i+"').style.display = 'block'");
			eval("cbeGetElementById('img"+i+"').src = 'images/minus.png'");
		}
	}
	
	function trocarordem()
	{
		var frm = cbeGetElementById("frmcadastrar");
		if(jsordem=="ASC") jsordem = "DESC";
		else if(jsordem=="DESC") jsordem = "ASC";
		frm.action += "?ordem=" + jsordem;
		frm.submit();
	}
	
	function mostraImagens()
	{
		displayPopup("imagens.jsp?codcli=" + codcli, "imagens", 270, 650);
	}
	
	function dadosPaciente() {
		displayPopup("dadospaciente.jsp?cod=" + codcli, "dadospaciemte", 250, 350);
	}
	
	function limparRegistro() {
		//Se já está escolhido paciente, apagar e começar novamente
		if(codcli != "") self.location = "historicopac.jsp";
	}
	
	function imprimirHist(codhist)
	{
		window.open('relhistorico2.jsp?cod=' + codhist,'relhistoria','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=auto,resizable=no,menubar=no,width=790,height=525,top=10,left=10');
		barrasessao();
	}
	
	function abreAlertas() {
		displayPopup("editaralertas.jsp?codcli=" + codcli, "alertas",300,500);
		barrasessao();
	}

	//Sobrescrendo a função do AJAX
	function setar(chave, campo, valorchave, valorcampo) {
		cbeGetElementById(chave).value = valorchave;
		cbeGetElementById(campo).value = valorcampo;
		x.innerHTML = "";
		hide();
		cbeGetElementById("frmcadastrar").submit();
	}
	
	function abreExames() {
		window.open('verexames.jsp?codcli=' + codcli + '&data=<%= Util.getData()%>','exames','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,menubar=no,width=650,height=450,top=10,left=10');
	}
	
	function pesquisarhistoricos() {
		window.open('buscarhistoricos.jsp','buscahistorico','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,menubar=no,width=620,height=280,top=10,left=10');	
	}
	
	function responderProtocolo() {
			window.open('aplicarprotocolo.jsp?codcli=' + codcli,'protocolos','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,menubar=no,width=650,height=450,top=10,left=10');			
	}
	
	

</script>
</head>

<body onLoad="iniciar();barrasessao();">
<%@include file="barrasessao.jsp" %>
<%@include file="barraajax.jsp" %>
<form name="frmcadastrar" id="frmcadastrar" action="historicopac.jsp" method="post">
  <table width="600" border="0" align="center" cellpadding="0" cellspacing="0">
    <tr>
      <td height="18" class="title"><a name="topo" class="title">.: Histórico do Paciente :.</a></td>
    </tr>
	<tr style="height:25px">
		<td align="right"><span name='msg' id='msg' class="msg">&nbsp;</span></td>
	</tr>
    <tr align="center" valign="top">
      <td>
	  		<table width="100%" border="0" cellpadding="0" cellspacing="0" class="table">
				<tr>
					<td class="tdMedium" width="80"><a href="Javascript:pesquisapornascimento(2)" title="Pesquisa por nome">Paciente:</a>&nbsp;<a href="Javascript:pesquisapornascimento(1)" title="Pesquisa por data de nascimento"><img src="images/calendar.gif" border="0"></a></td>
		            <td class="tdLight" nowrap width="100%"> 
              			<input type="hidden" name="codcli" id="codcli" value="<%= codcli %>">			
						<input style="width:98%" class="caixa" type="text" name="nome" id="nome" onKeyUp="busca(this.value, 'codcli', 'nome','paciente')" value="<%= nomepaciente%>" onClick="limparRegistro()">
						<input size="10" class="caixa" type="text" name="pesqnascimento" id="pesqnascimento" onKeyPress="buscanascimento(this.value, event); return formatar(this, event, '##/##/####');" style="display: none">
					</td>
					<td class="tdLight" align="center" width="50">
						<a href="Javascript: cadastrorapido()"><img src="images/raio.gif" border="0" alt="Cadastro Rápido"></a>
					</td>
					<td class="tdMedium" width="90"><button class="botao" name="novahistoria" id="novahistoria" onClick="historia(-1);"><img src="images/24.gif"> Nova</button></td>
					<td rowspan="3" class="tdLight">
					<% 
						if(Util.isNull(foto)) {
							out.println("<img src='images/photo.gif' border='0'>");
						}
						else {
							out.println("<a id='foto' name='foto' href=\"Javascript: mostraImagem('upload/" + foto + "')\"><img src='upload/" + foto + "' border=0 width=40 height=40></a>");
						}
					%>
					</td>					
				</tr>
				<tr>
		            <td height="22" class="tdMedium">Convênio:</td>
					<td colspan="3" width="300" class="tdLight">
						<select name="cod_plano" id="cod_plano" class="caixa" style="width:450px">
							<%= paciente.getConveniosCombo(codcli)%>
						</select>
					</td>
				</tr>
				<tr>
					<td colspan="4">
						<table width="100%" cellpadding="0" cellspacing="0">
							<tr>
								<td class="tdMedium" align="center">
									<button style="width:50; height:28" type="button" onClick="abreAlertas()" id="btnalerta" title="Alertas do Paciente" disabled>
										<% 
											String alerta = historico.getAlertas(codcli);
											if(alerta.equals("0")) { %>
											<img src="images/alertas.gif" border="0">
										<%} else { %>
											<img alt="<%= alerta%> alertas" src="images/alertapisc.gif" border="0">
										<%}%>
									</button>
								</td>								
								<td class="tdMedium" align="center"><button style="width:50; height:28" type="button" id="btnimagem" onClick="mostraImagens()" title="Imagens do Paciente" disabled><img src="images/palette.gif" border="0"></button></td>
								<td class="tdMedium" align="center"><button style="width:50; height:28" type="button" id="btnexames" onClick="abreExames()" title="Exames" disabled><img src="images/exames.gif" border="0" width="20"></button></td>
								<td class="tdMedium" align="center"><button style="width:50; height:28" type="button" id="btndadospaciente" title="Dados do Paciente" onClick="dadosPaciente()" disabled><img src="images/28.gif" border="0"></button></td>
								<td class="tdMedium" align="center"><button style="width:50; height:28" type="button" id="btnprotocolo" title="Protocolos do Paciente" onClick="responderProtocolo()" disabled><img src="images/26.gif" border="0"></button></td>
								<td class="tdMedium" align="center"><button style="width:50; height:28" type="button" title="Pesquisar Históricos por Período" onClick="pesquisarhistoricos()"><img src="images/busca.gif" border="0"></button></td>
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
 </table>
<%
	if(!codcli.equals("")) {
%>
 <table width="600" border="0" align="center" cellpadding="0" cellspacing="0">
 	<tr>
		<td><%= historico.getTiposHistoriaView( cod_empresa )%><td>
		<td align="right">
			<a title="Fechar todas as Histórias" href="JavaScript:closeAll()"><img src="images/close.gif" border="0"></a>&nbsp;
			<a title="Abrir todas as Histórias" href="Javascript:openAll()"><img src="images/open.gif" border="0"></a>&nbsp;
			<a title="Trocar ordem de Data" href="Javascript:trocarordem()"><img src="images/botordem.gif" border="0"></a>&nbsp;
			<a title="Desce" href="#baixo"><img src="images/down.gif" border="0" style="cursor:hand"></a>&nbsp;
			<a title="Sobe" href="#topo"><img src="images/top.gif" border="0" style="cursor:hand"></a>
		</td>
	</tr>
 </table>
 <table width="100%" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr>
		<td width="100%" align="center">
		<%
			Vector resp = historico.getHistorias(codcli, ordem, tddark);
			for(int i=0; i<resp.size(); i++)
				out.println(resp.get(i).toString());

		%>
		</td>
	</tr>
  </table>
 <table width="600" border="0" align="center" cellpadding="0" cellspacing="0">
 	<tr>
		<td align="right">
			<a title="Fechar todas as Histórias" href="JavaScript:closeAll()"><img src="images/close.gif" border="0"></a>&nbsp;
			<a title="Abrir todas as Histórias" href="Javascript:openAll()"><img src="images/open.gif" border="0"></a>&nbsp;
			<a title="Trocar ordem de Data" href="Javascript:trocarordem()"><img src="images/botordem.gif" border="0"></a>&nbsp;
			<a title="Desce" href="#baixo"><img src="images/down.gif" border="0" style="cursor:hand"></a>&nbsp;
			<a title="Sobe" href="#topo"><img src="images/top.gif" border="0" style="cursor:hand"></a>
		</td>
	</tr>
 </table>
<%
	} //Fim do If se não selecionou usuário ainda
%>

 <a name="baixo">&nbsp;</a>
</form>

</body>
</html>
