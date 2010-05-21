<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.Vacina" id="vacina" scope="page"/>
<jsp:useBean class="recursos.Paciente" id="paciente" scope="page"/>
<jsp:useBean class="recursos.Historico" id="historico" scope="page"/>

<%
	String data_sugestao 	= "";
	String codcli     		= request.getParameter("codcli") !=null ? request.getParameter("codcli") : "";
	String nomepaciente   	= request.getParameter("nome") != null ? request.getParameter("nome") : "";	
	String foto 			= "";
	String nascimento 		= "";
	boolean consulta = false;
	boolean lancamento=false;
	
	if(strcod != null) {
		rs = banco.getRegistro("vac_prev_vacinas","cod_prev_vacina", Integer.parseInt(strcod) );
		data_sugestao = Util.formataData(banco.getCampo("data_sugestao", rs));
		codcli = banco.getCampo("cod_cliente", rs);
		consulta = true;
	}
	else {
        data_sugestao = "";
		String codClienteQueVeioDoLancamento = request.getParameter("codigo_paciente");
		if(codClienteQueVeioDoLancamento!=null && !codClienteQueVeioDoLancamento.equals("")){
			codcli = codClienteQueVeioDoLancamento;
			lancamento=true;
		}
	}

	//Se escolheu o paciente, capturar os dados
	if(!codcli.equals("")) {
		String dadospaciente[] = paciente.getDadosPaciente(codcli);
		nascimento = dadospaciente[0];
		foto = dadospaciente[1];
		nomepaciente = dadospaciente[2];
	}

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
	 var nome_campos_obrigatorios = Array("Paciente", "Vacina","Data de Sugestao", "Dose");
	 //Página a enviar o formulário
	 var page = "gravarprevisaovacinas.jsp";
     //Campos obrigatórios
	 var campos_obrigatorios = Array("codcli", "cod_vacina", "data_sugestao", "dose");

	 var xmlHttp, xmlHttp2, xmlHttp3;
	 
	function iniciar() {
		cbeGetElementById("cod_vacina").value = "<%= (lancamento)? request.getParameter("codigo_vacina") : banco.getCampo("cod_vacina", rs) %>";
		buscaLotesVacina(cbeGetElementById("cod_vacina").value);
		inicio();
		barrasessao();	
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
		botaoNovo();
		cbeGetElementById("data_aplicacao").value = "<%= Util.getData()%>";
		cbeGetElementById("data_recebimento").value = "<%= Util.getData()%>";
		cbeGetElementById("hora_aplicacao").value = "<%= Util.getHora()%>";
	}

	//Sobrescrendo a função do AJAX
	function setar(chave, campo, valorchave, valorcampo) {
		cbeGetElementById(chave).value = valorchave;
		cbeGetElementById(campo).value = valorcampo;
		x.innerHTML = "";
		hide();
		
		cbeGetElementById("frmcadastrar").action = "previsaovacinas.jsp";
		cbeGetElementById("frmcadastrar").submit();
	}

	function clickBotaoNovo() {
		novaHistVacina();
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
<%@include file="barraajax.jsp" %>
<form name="frmcadastrar" id="frmcadastrar" action="gravaprevisaovacinas.jsp" method="post">
  <!-- Campos Ocultos -->
  <input type="hidden" name="ordem" value="<%= ordem%>">
  <!-- Campos Ocultos -->
  <table width="600" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr>
      <td width="651" height="18" class="title">.: Previs&atilde;o de Vacinas 
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
          
        <table width="101%" border="0" cellpadding="0" cellspacing="0" class="table">
          <tr> 
            <td class="tdMedium" height="28"><a href="Javascript:pesquisapornascimento(2)" title="Pesquisa por nome">Paciente: 
              *</a>&nbsp;<a href="Javascript:pesquisapornascimento(1)" title="Pesquisa por data de nascimento"><img src="images/calendar.gif" border="0"></a></td>
            <td valign="middle" colspan="2" class="tdLight" nowrap> 
              <input type="hidden" name="codcli" id="codcli" value="<%= codcli %>">
              <input style="width:98%" class="caixa" type="text" name="nome" id="nome" onKeyUp="busca(this.value, 'codcli', 'nome','paciente')" value="<%= nomepaciente%>">
              <input size="10" class="caixa" type="text" name="pesqnascimento" id="pesqnascimento" onKeyPress="buscanascimento(this.value, event); return formatar(this, event, '##/##/####');" style="display: none">            </td>
              
              
              
            <td width="86" align="center" class="tdLight">
									<a href="Javascript:abreAlertas()" id="btnalerta" title="Alertas do Paciente">
										<% 
											String alerta = historico.getAlertas(codcli);
											if(alerta.equals("0")) { %>
											<img src="images/alertas.gif" border="0">
										<%} else { %>
											<img alt="<%= alerta%> alertas" src="images/alertapisc.gif" border="0">
										<%}%>
									</a>								</td>	
                                
                                
            <td width="83" rowspan="3" valign="top" class="tdLight" align="center"> 
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
            <td class="tdMedium" width="107" height="28">Vacina: *</td>
            <td width="205"  class="tdLight"> 
              <select name="cod_vacina" id="cod_vacina" class="caixa" onChange="buscaLotesVacina(this.value);">
                <option value=""></option>
                <%= vacina.getVacinas(cod_empresa)%> 
              </select>            </td>
            <td width="118" colspan="-1" valign="middle" class="tdMedium">Data Sugest&atilde;o: *</td>
            <td valign="middle" class="tdLight"> 
              <input name="data_sugestao" type="text" class="caixa" id="data_sugestao" value="<%= data_sugestao %>" onKeyPress="return formatar(this, event, '##/##/####');  " size="9" maxlength="10" onBlur=" ValidaData(this);">            </td>
            <td></td>
          </tr>
          <tr> 
            <td class="tdMedium" width="107" height="28">Dose: *</td>
				<td colspan="3" class="tdLight">
					<div id="divdose">&nbsp;
						<%
							if(strcod != null) {
								out.println(vacina.getDosesVacina(banco.getCampo("cod_vacina", rs)));
							}
						%>
					</div>
                    
                     
                <%if(consulta){%>
                <script language="javascript">
                    var obj = document.getElementById("dose");
                    var opcoes = obj.options;
                    for(var i=0; i<opcoes.length; i++){
                        if(opcoes[i].value=="<%=rs.getString("dose")%>"){
                            obj.selectedIndex = i; break;
                        }
                    }
                </script>
                <%}%>
                    
                    </td>
          </tr>
          <tr> 
            <td height="0"></td>
            <td></td>
            <td colspan="-1"></td>
            <td></td>
            <td></td>
            <td></td>
          </tr>
        </table>
      </td>
    </tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<%= Util.getBotoes("previsaovacinas", pesq, tipo) %>
	<tr>
		<td>&nbsp;</td>
	</tr>
    <tr>
		<td width="100%" style="text-align:center">
			<table width="600px">
				<tr>
					<td class="tdDark"><a title="Ordenar por Paciente" href="Javascript:ordenar('previsaovacinas','nome')">Paciente</a></td>
					<td width="250" class="tdDark"><a title="Ordenar por Vacina" href="Javascript:ordenar('previsaovacinas','descricao')">Vacina</a></td>
					<td width="80" class="tdDark"><a title="Ordenar por Data" href="Javascript:ordenar('previsaovacinas','data_sugestao')">Data</a></td>
				</tr>
			</table>
			<div style="width:600; height:101; overflow: auto">
				<table width="100%">
				    <%
						String resp[] = vacina.getPrevisaoVacinas(pesq, "nome", ordem, numPag, 50, tipo, cod_empresa);
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
