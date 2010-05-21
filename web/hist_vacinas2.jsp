<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.Vacina" id="vacina" scope="page"/>
<jsp:useBean class="recursos.Paciente" id="paciente" scope="page"/>
<jsp:useBean class="recursos.Historico" id="historico" scope="page"/>

<%
	String data_aplicacao 	= "";
	String hora_aplicacao   = Util.getHora();
	String codcli     		= request.getParameter("codcli") !=null ? request.getParameter("codcli") : "";
	String nomepaciente   	= request.getParameter("nome") != null ? request.getParameter("nome") : "";	
	String foto 			= "";
	String nascimento 		= "";
	
	if(strcod != null && (inf==null || !inf.equals("5")) ) {
		rs = banco.getRegistro("vac_hist_vacinas","cod_hist_vacina", Integer.parseInt(strcod) );
		data_aplicacao = Util.formataData(banco.getCampo("data_recebimento", rs));
		codcli = banco.getCampo("codcli", rs);
	}
	else {
		data_aplicacao = Util.getData();
	}

	//Se escolheu o paciente, capturar os dados
	if(!codcli.equals("")) {
		String dadospaciente[] = paciente.getDadosPaciente(codcli);
		nascimento = dadospaciente[0];
		foto = dadospaciente[1];
		nomepaciente = dadospaciente[2];
	}

	if(Util.isNull(ordem)) ordem = "data_aplicacao DESC";
%>

<html>
<head>
<title>Histórico de Vacinas</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
<script language="JavaScript" src="js/ajax.js"></script>
<script language="JavaScript">
     //id
     var idReg = "<%= strcod%>";
	 //Informação vinda de gravar
	 var inf = "<%= inf%>";
	 //Nome dos campos
	 var nome_campos_obrigatorios = Array("Lote", "Data da aplicação", "Hora da Aplicação", "Dose", "Aplicador");
	 //Página a enviar o formulário
	 var page = "gravarhist_vacinas2.jsp";
     //Campos obrigatórios
	 var campos_obrigatorios = Array("lote", "data_aplicacao", "hora_aplicacao", "dose", "aplicador");

	 var xmlHttp, xmlHttp2, xmlHttp3;
	 
	function iniciar() {
		cbeGetElementById("cod_vacina").value = "<%= banco.getCampo("cod_vacina", rs) %>";
		cbeGetElementById("lote").value = "<%= banco.getCampo("cod_estoque", rs) %>";
		if(cbeGetElementById("dose"))
			cbeGetElementById("dose").value = "<%= banco.getCampo("dose", rs) %>";
		inicio();
		barrasessao();	
	}


	function abreAlertas() {
		displayPopup("editaralertas.jsp?codcli=<%=codcli%>", "alertas",300,500);
		barrasessao();
	}

	function buscaLotesVacina(cod_vacina) { 
	
			//Chama o Ajax para buscar o valor
			buscaValorVacinaConvenio(cod_vacina,cbeGetElementById('cod_convenio').value);
			
			//Busca as doses dessa vacina
			buscaDosesVacina(cod_vacina);
			
			//Página que vai buscar os dados
			var url = "carregalotesvacina.jsp?cod_vacina=" + cod_vacina;

			//Se for IE
			if (window.ActiveXObject) {
					xmlHttp = new ActiveXObject('Microsoft.XMLHTTP');
			}
			//Se for NETSCAPE
			else if (window.XMLHttpRequest) {
					xmlHttp = new XMLHttpRequest();
			}
			xmlHttp.open('GET', url, true);
			xmlHttp.onreadystatechange = carregacombolotes;
			xmlHttp.send(null);
	}
	
	function carregacombolotes() {
		if (xmlHttp.readyState == 4) {
			if (xmlHttp.status == 200) {
				xmlDoc = xmlHttp.responseText;
				cbeGetElementById("divlote").innerHTML = xmlDoc;
			}
		 }
	}
	
	function buscaValorVacinaConvenio(cod_vacina, cod_convenio) { 

			//Página que vai buscar os dados
			var url = "carregavalorvacinaconvenio.jsp?cod_vacina=" + cod_vacina + "&cod_convenio=" + cod_convenio;

			//Se for IE
			if (window.ActiveXObject) {
					xmlHttp2 = new ActiveXObject('Microsoft.XMLHTTP');
			}
			//Se for NETSCAPE
			else if (window.XMLHttpRequest) {
					xmlHttp2 = new XMLHttpRequest();
			}
			xmlHttp2.open('GET', url, true);
			xmlHttp2.onreadystatechange = carregavalorvacina;
			xmlHttp2.send(null);
	}
	
	function carregavalorvacina() {
		if (xmlHttp2.readyState == 4) {
			if (xmlHttp2.status == 200) {
				xmlDoc = xmlHttp2.responseText;
				cbeGetElementById("valor").value = xmlDoc;
			}
		 }
	}

	function buscaDosesVacina(cod_vacina) { 
	
			//Página que vai buscar os dados
			var url = "carregadosesvacina.jsp?cod_vacina=" + cod_vacina;

			//Se for IE
			if (window.ActiveXObject) {
					xmlHttp3 = new ActiveXObject('Microsoft.XMLHTTP');
			}
			//Se for NETSCAPE
			else if (window.XMLHttpRequest) {
					xmlHttp3 = new XMLHttpRequest();
			}
			xmlHttp3.open('GET', url, true);
			xmlHttp3.onreadystatechange = carregalotes;
			xmlHttp3.send(null);
	}
	
	function carregalotes() {
		if (xmlHttp3.readyState == 4) {
			if (xmlHttp3.status == 200) {
				xmlDoc = xmlHttp3.responseText;
				cbeGetElementById("divdose").innerHTML = xmlDoc;
			}
		 }
	}

	function novaHistVacina() {
		alert("Novos registros só podem ser inseridos pelo Lançamentos de Vacinas");
	}
	
	function excluirvacina() {
		alert("Registro de lançamento só pode ser excluído pelo Lançamento de Vacinas")
	}
	
	function gravarVacina() {
		if(idReg == "null")
			alert("Escolha um registro de lançamento de vacina para completar as informações.");
		else
			enviarAcao('inc');
	}

	//Sobrescrendo a função do AJAX
	function setar(chave, campo, valorchave, valorcampo) {
		cbeGetElementById(chave).value = valorchave;
		cbeGetElementById(campo).value = valorcampo;
		x.innerHTML = "";
		hide();
		
		cbeGetElementById("frmcadastrar").action = "hist_vacinas.jsp";
		cbeGetElementById("frmcadastrar").submit();
	}

	function clickBotaoNovo() {
		novaHistVacina();
	}
	
	function clickBotaoSalvar() {
		gravarVacina();
	}
	
	function clickBotaoExcluir() {
		excluirvacina();
	}	


</script>
</head>

<body onLoad="iniciar()">
<%@include file="barrasessao.jsp" %>
<form name="frmcadastrar" id="frmcadastrar" action="gravarhist_vacinas2.jsp" method="post">
  <!-- Campos Ocultos -->
  <input type="hidden" name="ordem" value="<%= ordem%>">
  <!-- Campos Ocultos -->
  <table width="600" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr>
      <td width="651" height="18" class="title">.: Aplica&ccedil;&atilde;o de 
        Vacinas :.</td>
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
				<td class="tdMedium">Paciente:</td>
				<td colspan="2" class="tdLight" nowrap><%= nomepaciente%>&nbsp;</td>
				<td width="150" align="center" class="tdLight">
									<a href="Javascript:abreAlertas()" id="btnalerta" title="Alertas do Paciente">
										<% 
											String alerta = historico.getAlertas(codcli);
											if(alerta.equals("0")) { %>
											<img src="images/alertas.gif" border="0">
										<%} else { %>
											<img alt="<%= alerta%> alertas" src="images/alertapisc.gif" border="0">
										<%}%>
									</a>								</td>
				<td width="93" rowspan="3" class="tdLight" align="center">
				<% 
					if(Util.isNull(foto)) {
						out.println("<img src='images/photo.gif' border='0'>");
					}
					else {
						out.println("<a id='foto' name='foto' href=\"Javascript: mostraImagem('upload/" + foto + "')\"><img src='upload/" + foto + "' border=0 width=40 height=40></a>");
					}
				%>				</td>					
			</tr>
            <tr>
	            <td class="tdMedium" width="106">Vacina: *</td>
       	       	<td colspan="3" class="tdLight">
					<select name="cod_vacina" id="cod_vacina" class="caixa" disabled>
						<option value=""></option>
						<%= vacina.getVacinas(cod_empresa)%>
					</select>				</td>
            </tr>
            <tr>
	            <td class="tdMedium">Lote: *</td>
       	       	<td colspan="3" class="tdLight">
					<div id="divlote">
					<%
						if(!Util.isNull(strcod)) //Se escolheu o item, imprimir combo da vacina
							out.println(vacina.getLotesVacina(banco.getCampo("cod_vacina", rs)));
						else //Se não escolheu o item, imprimir combo vazia
							out.println(vacina.getLotesVacina(strcod)); 
					%>
					</div>				</td>
            </tr>
            <tr>
	            <td class="tdMedium">Data Aplicação: *</td>
       	       	<td width="146" class="tdLight"><input name="data_aplicacao" type="text" class="caixa" id="data_aplicacao" value="<%= data_aplicacao %>" onKeyPress="return formatar(this, event, '##/##/####'); " size="9" maxlength="10" onBlur="ValidaData(this);ValidaFuturo(this);"></td>
	            <td width="104" class="tdMedium">Hora aplicação: *</td>
       	       	<td colspan="2" class="tdLight"><input name="hora_aplicacao" type="text" class="caixa" id="hora_aplicacao" value="<%= hora_aplicacao %>" onKeyPress="return formatar(this, event, '##:##'); " size="5" maxlength="5" onBlur="ValidaHora(this);"></td>
            </tr>
			<tr>
				<td class="tdMedium">Dose: *</td>
				<td colspan="5" class="tdLight">
					<div id="divdose">&nbsp;
						<%
							if(strcod != null) {
								out.println(vacina.getDosesVacina(banco.getCampo("cod_vacina", rs)));
							}
						%>
					</div></td>
			</tr>
			<tr>
			  <td class="tdMedium">Local Aplica&ccedil;&atilde;o: </td>
			  <td class="tdLight">
                          <select name="local_aplicacao" id="local_aplicacao" class="caixa" >
                            <%= vacina.getLocalVacina(strcod)%>
                          </select></td>
			  <td class="tdMedium">Lado aplica&ccedil;&atilde;o: </td>
			  <td colspan="2" class="tdLight"><select name="lado_aplicacao" id="lado_aplicacao" class="caixa" > 
                             <%= vacina.getLadoVacina(strcod)%>
                            </select></td>
			</tr>
			<tr>
				<td class="tdMedium">Aplicador: *</td>
				<td class="tdLight" colspan="4"><input name="aplicador" type="text" class="caixa" id="data_aplicacao" value="<%= banco.getCampo("aplicador", rs) %>" size="80" maxlength="80"></td>
			</tr>
            <tr>
				<td class="tdMedium">Observações:</td>
				<td class="tdLight" colspan="4"><textarea name="observacao" id="observacao" class="caixa" style="width:95%" rows="3"><%= banco.getCampo("observacao", rs) %></textarea></td>
			</tr>
          </table>
      </td>
    </tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<%= Util.getBotoes("hist_vacinas2", pesq, tipo) %>
	<tr>
		<td>&nbsp;</td>
	</tr>
    <tr>
		<td width="100%" style="text-align:center">
			<table width="600px">
				<tr>
					<td class="tdDark"><a title="Ordenar por Paciente" href="Javascript:ordenar('hist_vacinas','nome')">Paciente</a></td>
					<td width="250" class="tdDark"><a title="Ordenar por Vacina" href="Javascript:ordenar('hist_vacinas','descricao')">Vacina</a></td>
					<td width="80" class="tdDark"><a title="Ordenar por Data" href="Javascript:ordenar('hist_vacinas','data_aplicacao')">Data</a></td>
				</tr>
			</table>
			<div style="width:600; height:101; overflow: auto">
				<table width="100%">
				    <%
						String resp[] = vacina.getHistVacinas2(pesq, "nome", ordem, numPag, 50, tipo, cod_empresa);
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
