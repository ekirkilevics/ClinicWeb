<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.Vacina" id="vacina" scope="page"/>
<jsp:useBean class="recursos.Paciente" id="paciente" scope="page"/>
<jsp:useBean class="recursos.Historico" id="historico" scope="page"/>

<%
	String data_aplicacao 	= "";
    String data_recebimento = "";
	String hora_aplicacao 	= "";
	String codcli     		= request.getParameter("codcli") !=null ? request.getParameter("codcli") : "";
	String nomepaciente   	= request.getParameter("nome") != null ? request.getParameter("nome") : "";	
	String foto 			= "";
	String nascimento 		= "";
    String desconto = "";
		
	if(strcod != null) {
		rs = banco.getRegistro("vac_hist_vacinas","cod_hist_vacina", Integer.parseInt(strcod) );
		data_aplicacao = Util.formataData(banco.getCampo("data_aplicacao", rs));
        data_recebimento = Util.formataData(banco.getCampo("data_recebimento", rs));
		hora_aplicacao = Util.formataHora(banco.getCampo("hora_aplicacao", rs));
		codcli = banco.getCampo("codcli", rs);
        desconto = banco.getCampo("valor_desc", rs);
    }
	else {
		data_aplicacao = Util.getData();
        data_recebimento = Util.getData();
		hora_aplicacao = Util.getHora();
	}

	String codConvenio = banco.getCampo("cod_convenio", rs);
	String codVacina = banco.getCampo("cod_vacina", rs);
	String tipoPagto = banco.getCampo("tipo_pagto", rs);
	
	
	//Se escolheu o paciente, capturar os dados
	if(!codcli.equals("")) {
		String dadospaciente[] = paciente.getDadosPaciente(codcli);
		nascimento = dadospaciente[0];
		foto = dadospaciente[1];
		nomepaciente = dadospaciente[2];
	}

	if(Util.isNull(ordem)) ordem = "data_aplicacao DESC, hora_aplicacao DESC";
	
	
		boolean podeMudarValor = false;
		
		try{
			String valorCaixinha = banco.getCampo("valor", rs);
			if(valorCaixinha!=null && !valorCaixinha.equals("")){
				float valorNumerico = Float.parseFloat(valorCaixinha);
				if(valorNumerico == 0) podeMudarValor=true;
			}
			else{
				podeMudarValor=true;
			}
		}
		catch(Exception ex){}
		
		boolean foiAplicado = false;
		String aplicador = banco.getCampo("aplicador", rs);
		if(aplicador!=null && !aplicador.equals("")) foiAplicado=true;


		//Exclui forma de pagamento
		vacina.excluirPagamento(request.getParameter("exc"));			
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
	 var nome_campos_obrigatorios = Array("Paciente", "Vacina","Data de Recebimento", "Valor", "Tipo de Pagamento");
	 //Página a enviar o formulário
	 var page = "gravarhist_vacinas.jsp";
     //Campos obrigatórios
	 var campos_obrigatorios = Array("codcli", "cod_vacina", "data_recebimento", "valor", "tipo_pagto");

	 var xmlHttp, xmlHttp2, xmlHttp3;
	 
	function iniciar() {
		cbeGetElementById("<%=(podeMudarValor && !foiAplicado)? "cod_vacina":"cod_vacina_disabled"%>").value = "<%= codVacina %>";
		cbeGetElementById("<%=(podeMudarValor)? "cod_convenio":"cod_convenio_disabled"%>").value = "<%= codConvenio %>";
		inicio();
		barrasessao();	
        //Verificando se tem desconto
		var desconto =	cbeGetElementById("valor_desc").value;
        if (desconto == "0" || desconto == "" || desconto == 0){
            	cbeGetElementById("desc").checked = false;
                verificaDesconto();
		}
        else {
            	cbeGetElementById("desc").checked = true;
                verificaDesconto();
		}
                
		//Se é edição, não mostrar previsão de vacinas
		if(idReg != "null") {
			cbeGetElementById("divprevisao").style.display = 'none';
		}
	}
	
	
	function abreAlertas() {
		displayPopup("editaralertas.jsp?codcli=<%=codcli%>", "alertas",300,500);
		barrasessao();
	}

	function buscaLotesVacina(cod_vacina) { 
	
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
				cbeGetElementById("valor").value = trim(xmlDoc);
				cbeGetElementById("valor_desc").value = trim(xmlDoc);
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
		botaoNovo();
		cbeGetElementById("data_aplicacao").value = "<%= Util.getData()%>";
		cbeGetElementById("data_recebimento").value = "<%= Util.getData()%>";
		cbeGetElementById("hora_aplicacao").value = "<%= Util.getHora()%>";
		cbeGetElementById("divprevisao").style.display = 'block';
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
         
	
	function verificaDesconto(){
		if (cbeGetElementById("desc").checked==true){
			cbeGetElementById("valor_desc").style.visibility= "visible";
		}
		else{
			cbeGetElementById("valor_desc").style.visibility= "hidden";
			cbeGetElementById("valor_desc").value="";
		}
		
		
	}
	
	function salvarLancamento() {
		var jstemprevisao = cbeGetElementById("chkprevisao");
		var jsdata_previsao = cbeGetElementById("data_previsao");
		var jscod_vacina_previsao = cbeGetElementById("cod_vacina_previsao");
		var jscod_dose = cbeGetElementById("dose");

		//Se clicou que não tem previsão, não validar outros campos
		if(!jstemprevisao.checked && idReg == "null") {
			if(jsdata_previsao.value == "") {
				mensagem("Preencha data de previsão da próxima vacina", 2);
				jsdata_previsao.focus();
				return;
			}
			if(jscod_vacina_previsao.value == "") {
				mensagem("Preencha a vacina da previsão", 2);
				jscod_vacina_previsao.focus();
				return;
			}
			if(jscod_dose.value == "") {
				mensagem("Escolha a dose", 2);
				jscod_dose.focus();
				return;
			}
		}
		
		//atualiza valor do desc
		atualizaDesc();

		enviarAcao('inc');
	}
	
	function funcChkPrevisao(obj) {
		cbeGetElementById("data_previsao").disabled = obj.checked;	
	}
	
	function excluirpagto(cod_pgto) {
		conf = confirm("Confirma exclusão do pagamento?");
		if(conf) {
			self.location = "hist_vacinas.jsp?cod=" + idReg + "&exc=" + cod_pgto;
		}
	}
	
	function adicionarpagto() {
		var jsdata = cbeGetElementById("data_pagamento");
		var jsvalor = cbeGetElementById("valorpagto");
		var jstotal = cbeGetElementById("total"); //Soma dos pagamentos
		var jsvalortotal = cbeGetElementById("valor_desc"); //Valor total da vacina

		if(jsdata.value == "") {
			mensagem("Entre com a data do pagamento", 2);
			jsdata.focus();
			return;
		}
		
		if(jsvalor.value == "") {
			mensagem("Entre com o valor do pagamento", 2);
			jsvalor.focus();
			return;
		}
		
		//Converte em float
		var fjsvalortotal = parseFloat(jsvalortotal.value);
		var fjstotal = parseFloat(jstotal.value);
		var fjsvalor = parseFloat(jsvalor.value);

		//Se o valor que está sendo lançado mais o valor acumulado for maior que o total, mensagem
		if(fjsvalortotal < (fjstotal + fjsvalor)) {
			alert("Soma dos pagamentos não pode ser maior que valor da vacina\nSoma deu " + formatCurrency(fjstotal + fjsvalor) + ", porém a soma não pode passar de " + formatCurrency(fjsvalortotal));
			return;
		}
	
		salvarLancamento();
	}
	
	function atualizaDesc() {
		var jsvalor = cbeGetElementById("valor");
		var jsvalordesc = cbeGetElementById("valor_desc");

		//Se o desconto já estiver preeenchido, não pegar o valor total
		if(jsvalordesc.value == "") {
			jsvalordesc.value = jsvalor.value;
		}
		
		//Se zerou o valor de pagamento, zera o desconto tb
		if(parseFloat(jsvalor.value) == 0) {
			jsvalordesc.value = "0";
		}
		
	}
	
	function clickBotaoNovo() {
		novaHistVacina();
	}
	
	function clickBotaoSalvar() {
		salvarLancamento();
	}
	
	function clickBotaoExcluir() {
		enviarAcao('exc');
	}	
	
</script>
</head>

<body onLoad="iniciar()">
<%@include file="barrasessao.jsp" %>
<%@include file="barraajax.jsp" %>
            
<form name="frmcadastrar" id="frmcadastrar" action="gravarhist_vacinas.jsp" method="post">
  <!-- Campos Ocultos -->
  <input type="hidden" name="ordem" value="<%= ordem%>">
  <!-- Campos Ocultos -->
  <table width="600" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr>
      <td width="651" height="18" class="title">.: Lan&ccedil;amento de Vacinas 
        :.</td>
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
            <td class="tdMedium" height="28"><a href="Javascript:pesquisapornascimento(2)" title="Pesquisa por nome">Paciente: 
              *</a>&nbsp;<a href="Javascript:pesquisapornascimento(1)" title="Pesquisa por data de nascimento"><img src="images/calendar.gif" border="0"></a></td>
            <td valign="middle" colspan="4" class="tdLight" nowrap> 
              <input type="hidden" name="codcli" id="codcli" value="<%= codcli %>">
              <input style="width:98%" class="caixa" type="text" name="nome" id="nome" onKeyUp="busca(this.value, 'codcli', 'nome','paciente')" value="<%= nomepaciente%>">
              <input size="10" class="caixa" type="text" name="pesqnascimento" id="pesqnascimento" onKeyPress="buscanascimento(this.value, event); return formatar(this, event, '##/##/####');" style="display: none">            </td>
            <td class="tdLight" align="center">
					<a href="Javascript: cadastrorapido()"><img src="images/raio.gif" border="0" alt="Cadastro Rápido"></a>&nbsp;&nbsp;
									<a href="Javascript:abreAlertas()" id="btnalerta" title="Alertas do Paciente">
										<% 
											String alerta = historico.getAlertas(codcli);
											if(alerta.equals("0")) { %>
											<img src="images/alertas.gif" border="0">
										<%} else { %>
											<img alt="<%= alerta%> alertas" src="images/alertapisc.gif" border="0">
										<%}%>
									</a>
			</td>	
            <td width="58" rowspan="3" valign="middle" class="tdLight" align="center"> 
            <% 
					if(Util.isNull(foto)) {
						out.println("<img src='images/photo.gif' border='0'>");
					}
					else {
						out.println("<a id='foto' name='foto' href=\"Javascript: mostraImagem('upload/" + foto + "')\"><img src='upload/" + foto + "' border=0 width=40 height=40></a>");
					}
				%>            </td>
            <td width="1"></td>
          </tr>
          <tr> 
            <td class="tdMedium" height="28">Convênio (Plano):</td>
            <td colspan="3" class="tdLight"> 
             <%
			
                 if(podeMudarValor){
			
			%>
              <select name="cod_convenio" id="cod_convenio" class="caixa" style="width:220px" onChange="buscaValorVacinaConvenio(cbeGetElementById('cod_vacina').value, this.value)">
                <option value=""><-- Selecione o plano --></option>
                <%= vacina.getConvenios(codcli)%> 
              </select>
              
            <%  
            
                }else{
            
            %>
            
            
            <select name="cod_convenio_disabled" id="cod_convenio_disabled" class="caixa" style="width:220px" onChange="buscaValorVacinaConvenio(cbeGetElementById('cod_vacina').value, this.value)" disabled>
                <option value=""><-- Selecione o plano --></option>
                <%= vacina.getConvenios(codcli)%> 
              </select>
              
              <input name="cod_convenio" id="cod_convenio" type="hidden" value="<%= codConvenio %>" >
            
            <%  
            
                }
            
            %>
            
            </td>
            <td width="122" valign="middle" class="tdMedium">Nascimento:</td>
            <td valign="middle" width="96" class="tdLight"> 
              <input size="10" type="text" class="caixa" name="nascimento" id="nascimento" value="<%= nascimento%>" onKeyPress="return false;" >
              <input type="hidden" name="idade" id="idade">            </td>
            <td></td>
          </tr>
          <tr> 
            <td class="tdMedium" width="107" height="28">Vacina: *</td>
            <td colspan="3" class="tdLight"> 
            
            <%
			
                 if(podeMudarValor && !foiAplicado){
			
			%>
            
              <select name="cod_vacina" id="cod_vacina" class="caixa" onChange="buscaValorVacinaConvenio(this.value,  cbeGetElementById('cod_convenio').value)">
                <option value=""></option>
                <%= vacina.getVacinas(cod_empresa)%> 
              </select>
            
            <%  
            
                }else{
            
            %>
               <select name="cod_vacina_disabled" id="cod_vacina_disabled" class="caixa" onChange="buscaDosesVacina(this.value);" disabled>
                <option value=""></option>
                <%= vacina.getVacinas(cod_empresa)%> 
              </select>
              	<% if(foiAplicado) out.println("&nbsp;&nbsp;J&aacute; aplicada"); %>
              
              <input name="cod_vacina" id="cod_vacina" type="hidden" value="<%= codVacina %>" >
              
            <%  
            
                }
            
            %>
            </td>
            <td valign="middle" class="tdMedium">Data Registro: *</td>
            <td valign="middle" class="tdLight"> 
            
            <%
			
                 if(podeMudarValor){
			
			%>
              <input name="data_recebimento" type="text" class="caixa" id="data_recebimento" value="<%= data_recebimento %>" onKeyPress="return formatar(this, event, '##/##/####');  " size="9" maxlength="10" onBlur=" ValidaData(this);">
              
              
            <%  
            
                }else{
            
            %>
              
              <input name="data_recebimento_disabled" type="text" class="caixa" id="data_recebimento_disabled" value="<%= data_recebimento %>" onKeyPress="return formatar(this, event, '##/##/####');  " size="9" maxlength="10" onBlur=" ValidaData(this);" disabled>
              <input name="data_recebimento" id="data_recebimento" type="hidden" value="<%= data_recebimento %>" >
              
            <%  
            
                }
            
            %>
              
              <input name="data_aplicacao" type="hidden" class="caixa" id="data_aplicacao" value="<%= data_aplicacao %>">
              <input name="hora_aplicacao" type="hidden" class="caixa" id="hora_aplicacao" value="<%= hora_aplicacao %>" ></td>
          </tr>
          <tr> 
            <td class="tdMedium" height="28">Valor: *</td>
            <td width="63" class="tdLight"> 
            
            <%
			
                 if(podeMudarValor){
			
			%>
            <input name="valor" type="text" class="caixa" id="valor" onKeyPress="return OnlyNumbers(this,event);" value="<%= banco.getCampo("valor", rs) %>" onBlur="atualizaDesc()" size="8">            </td>
            
            <%  
            
                }else{
            
            %>
            <input name="valor" type="hidden" class="caixa" id="valor" onKeyPress="return OnlyNumbers(this,event);" value="<%= banco.getCampo("valor", rs) %>" size="8"> 
            <input name="valor_disabled" type="text" class="caixa" id="valor" onKeyPress="return OnlyNumbers(this,event);" value="<%= banco.getCampo("valor", rs) %>" size="8" disabled>         <!--   </td> -->
            

            <%  
            
                }
            
            %>
            <td width="100" height="28" valign="top" class="tdMedium">Desconto
                
            
    <input type="checkbox" name="desc" id="desc" onClick="verificaDesconto();" value="1"
       <%=(desconto.equals(""))? "":"checked"%> >                </td>
            <td width="82" class="tdLight" height="28" colspan="5">&nbsp;
            <input name="valor_desc" type="text" class="caixa" id="valor_desc" onKeyPress="return OnlyNumbers(this,event);" size="8" value=<%=desconto%>></td>
          </tr>
            <tr>
				<td class="tdMedium">Observações:</td>
				<td class="tdLight" colspan="7"><textarea name="observacao" id="observacao" class="caixa" style="width:95%" rows="3"><%= banco.getCampo("observacao", rs) %></textarea></td>
			</tr>
            <tr>
				<td class="tdDark" colspan="8" align="center">Formas de Pagamento</td>
			</tr>
			<tr>
				<td colspan="7" width="100%">
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr>
							<td class="tdMedium">Data</td>
							<td class="tdMedium">Tipo</td>
							<td class="tdMedium">Valor</td>
							<td class="tdMedium" align="center">Pago</td>
							<td class="tdMedium" align="center">Ação</td>
						</tr>
						<tr>
							<td class="tdLight"><input name="data_pagamento" type="text" class="caixa" id="data_pagamento" onKeyPress="return formatar(this, event, '##/##/####');  " size="9" maxlength="10" onBlur=" ValidaData(this);" value="<%= Util.getData()%>"></td>
							<td class="tdLight">
								<select name="tipo_pagto" id="tipo_pagto" class="caixa">
									<%= vacina.getTiposPagto()%>
				                </select>
							</td>
							<td class="tdLight"><input name="valorpagto" type="text" maxlength="8" class="caixa" id="valorpagto" onKeyPress="return OnlyNumbers(this,event);" size="8"> </td>
							<td class="tdLight" align="center"><input type="checkbox" name="pago" id="pago" value="S"></td>
							<td class="tdLight" align="center"><a href="Javascript:adicionarpagto()" title="Adicionar Pagamento"><img src="images/add.gif" border="0"></a></td>
						</tr>
						<%= vacina.getPagamentos( strcod )%>
					</table>
				</td> 
			</tr>
	</table>
		<br>
		<div id="divprevisao">
		<table width="100%" border="0" cellpadding="0" cellspacing="0" class="table">
			<tr>
				<td class="tdDark" colspan="8" align="center">Previsão Próxima Dose</td>
			</tr>
			<tr>
				<td class="tdMedium">Data Previsão: *</td>
				<td colspan="7" class="tdLight">
					<input name="data_previsao" type="text" class="caixa" id="data_previsao"  onKeyPress="return formatar(this, event, '##/##/####');  " size="9" maxlength="10" onBlur=" ValidaData(this);">
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" name="chkprevisao" id="chkprevisao" onClick="funcChkPrevisao(this)"> Não gravar previsão
				</td>
			</tr>
			<tr>
				<td class="tdMedium">Vacina: *</td>
				<td class="tdLight">
				  <select name="cod_vacina_previsao" id="cod_vacina_previsao" class="caixa" onChange="buscaDosesVacina(this.value);">
					<option value=""></option>
					<%= vacina.getVacinas(cod_empresa)%> 
				  </select>
				</td>				
			</tr>
			<tr>
				<td class="tdMedium">Dose: *</td>
				<td colspan="7" class="tdLight">
					<div id="divdose">&nbsp;</div>
				</td>
			</tr>
        </table>
		</div>
      </td>
    </tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<%= Util.getBotoes("hist_vacinas", pesq, tipo) %>
	<tr>
		<td>&nbsp;</td>
	</tr>
    <tr>
		<td width="100%" style="text-align:center">
			<table width="600px">
				<tr>
					<td class="tdDark"><a title="Ordenar por Paciente" href="Javascript:ordenar('hist_vacinas','nome')">Paciente</a></td>
					<td width="250" class="tdDark"><a title="Ordenar por Vacina" href="Javascript:ordenar('hist_vacinas','descricao')">Vacina</a></td>
				</tr>
			</table>
			<div style="width:600; height:101; overflow: auto">
				<table width="100%">
				    <%
						String resp[] = vacina.getHistVacinas(pesq, "nome", ordem, numPag, 50, tipo, cod_empresa);
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
