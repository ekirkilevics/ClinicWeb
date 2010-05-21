<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.HonorarioIndividual" id="honorario" scope="page"/>
<jsp:useBean class="recursos.Paciente" id="paciente" scope="page"/>

<%
	String codcli     		= request.getParameter("codcli") !=null ? request.getParameter("codcli") : "";
	String nomepaciente   	=  "";	
	String nascimento 		=  "";	
	String idade      		=  "";	
	String foto 			=  "";
	String dataCons			=  "";
	String horaInicial		=  "";
	String horaFinal		=  "";

	if(!Util.isNull(strcod)) {
		rs = banco.getRegistro("honorarios","cod_honorario", Integer.parseInt(strcod));
		codcli = banco.getCampo("codcli", rs);
		dataCons = Util.formataData(banco.getCampo("data", rs));
		horaInicial = Util.formataHora(banco.getCampo("horainicial", rs));
		horaFinal = Util.formataHora(banco.getCampo("horafinal", rs));
	}
	
	if(ordem == null) ordem = "data DESC";

	//Se escolheu o paciente, capturar os dados
	if(!codcli.equals("")) {
		String dadospaciente[] = paciente.getDadosPaciente(codcli);
		nascimento = dadospaciente[0];
		foto = dadospaciente[1];
		nomepaciente = dadospaciente[2];
		idade = Util.getIdade(nascimento);
	}
	
	//Pega os convênios do paciente
	String convenios[] = paciente.getConveniosRadio(codcli, "radioconvenio", strcod);
	
	//Para excluir um item do honorário
	honorario.removeItemHonorario(request.getParameter("exc"));
%>

<html>
<head>
<title>Honorário Individual</title>
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
	 var nome_campos_obrigatorios = Array("Paciente", "Hora Inicial", "Hora Final", "Hospital", "nº da Guia/Senha", "Data", "Executante", "Grau de Participação", "Tipo de Acomodação");
	 //Página a enviar o formulário
	 var page = "gravarhonorarioindividual.jsp";
	 //Cod. da ajuda
	 cod_ajuda = 28;

     //Campos obrigatórios
	 var campos_obrigatorios = Array("codcli", "horainicial", "horafinal", "hospital", "guiaSolicitacao", "data", "prof_reg", "grauParticipacao", "tipoAcomodacao");
	 
	//Sobrescrendo a função do AJAX
	function setar(chave, campo, valorchave, valorcampo) {
		cbeGetElementById(chave).value = valorchave;
		cbeGetElementById(campo).value = valorcampo;
		x.innerHTML = "";
		hide();
		cbeGetElementById("frmcadastrar").submit();
	}
	
	 
	function escolheConvenio(cod_plano) { 
		//Coloca o valor no campo oculto
		cbeGetElementById("cod_convenio").value = cod_plano;
		
		//Página que vai buscar os dados
		var url = "carregavaloresconvenio.jsp?cod_plano=" + cod_plano;

		//Se for IE
		if (window.ActiveXObject) {
				xmlHttp = new ActiveXObject('Microsoft.XMLHTTP');
		}
		//Se for NETSCAPE
		else if (window.XMLHttpRequest) {
				xmlHttp = new XMLHttpRequest();
		}
		xmlHttp.open('GET', url, true);
		xmlHttp.onreadystatechange = carregacombovalores;
		xmlHttp.send(null);
		
	}
	
	function carregacombovalores() {
		if (xmlHttp.readyState == 4) {
			if (xmlHttp.status == 200) {
				xmlDoc = xmlHttp.responseText;
				cbeGetElementById("divprocedimentos").innerHTML = xmlDoc;
			}
		 }
	}
	
	function mudarProcedimento(combo) { 
	
		//Verifica se existe algum campo não preenchido
		passou = validaCampos();
		
		if(passou) {
			//Capturar valores para envio
			var jsproced = combo.value;
			var jsplano = cbeGetElementById("cod_convenio").value;
			var jsgp = cbeGetElementById("grauParticipacao").value;
			var jsta = cbeGetElementById("tipoAcomodacao").value;
			var jshi = cbeGetElementById("horainicial").value;
			var jsdata = cbeGetElementById("data").value;	
			var jstipoProced = cbeGetElementById("tipoProced");
			var jsva = cbeGetElementById("viaAcesso").value;
		
			//Verifica se o campo tipo de procedimentos foi escolhido
			if(jstipoProced.value == "") {
				mensagem("Escolha o tipo de procedimento antes de escolher o procedimento",2);
				combo.value = "";
				jstipoProced.focus();
				return;
			}
		
			//Página que vai buscar os dados
			var url = "carregavalor.jsp?cod_proced=" + jsproced + "&cod_plano=" + jsplano + "&gp=" + jsgp + "&ta=" + jsta + "&hi=" + jshi + "&tp=" + jstipoProced.value + "&dt=" + jsdata + "&va=" + jsva;
	
			//Se for IE
			if (window.ActiveXObject) {
					xmlHttp = new ActiveXObject('Microsoft.XMLHTTP');
			}
			//Se for NETSCAPE
			else if (window.XMLHttpRequest) {
					xmlHttp = new XMLHttpRequest();
			}
			xmlHttp.open('GET', url, true);
			xmlHttp.onreadystatechange = carregavalor;
			xmlHttp.send(null);

		}
		else combo.value = "";		
	}	
	
	function carregavalor() {
		if (xmlHttp.readyState == 4) {
			if (xmlHttp.status == 200) {
				xmlDoc = xmlHttp.responseText;
				cbeGetElementById("valor").value = xmlDoc;

				//Destrava campos do procedimentos após escolher um
				cbeGetElementById("qtde").disabled = false;
				cbeGetElementById("valor").disabled = false;
			}
		 }
	}	

	function iniciar() {
		//Preeche Combos
		cbeGetElementById("hospital").value = "<%= banco.getCampo("cod_hospital", rs) %>";
		cbeGetElementById("prof_reg").value = "<%= banco.getCampo("prof_reg", rs) %>";
		cbeGetElementById("grauParticipacao").value = "<%= banco.getCampo("grauParticipacao", rs) %>";
		cbeGetElementById("tipoAcomodacao").value = "<%= banco.getCampo("tipoAcomodacao", rs) %>";
		
		//Trava campos do procedimentos até escolher um
		cbeGetElementById("qtde").disabled = true;
		cbeGetElementById("valor").disabled = true;
		
		inicio();
		barrasessao();
	}	
	
	function salvarHonorario() {

		//Valida os campos antes
		passou = validaCampos();

		//Se passou na validação anterior, verificar procedimentos
		if(passou) {
			//Se não é edição, obrigar procedimento novo
			if(idReg == "null") {
				var jsdataproced = cbeGetElementById("dataproced");
				var jsProced = cbeGetElementById("cod_proced");
				var jsviaAcesso = cbeGetElementById("viaAcesso");
				var jsqtde = cbeGetElementById("qtde");
				var jsvalor = cbeGetElementById("valor");
				if(jsdataproced.value == "") {
					mensagem("Selecione a data do procedimento", 2);
					jsdataproced.focus();
					return;
				}
				if(jsProced.value == "") {
					mensagem("Selecione um procedimento", 2);
					jsProced.focus();
					return;
				}
				if(jsviaAcesso.value == "") {
					mensagem("Selecione uma via de Acesso", 2);
					jsviaAcesso.focus();
					return;
				}
				if(jsqtde.value == "") {
					mensagem("Selecione uma quantidade", 2);
					jsqtde.focus();
					return;
				}
				if(jsvalor.value == "") {
					mensagem("Selecione um Valor", 2);
					jsvalor.focus();
					return;
				}
			}
			enviarAcao('inc');
		}
	}
	
	function novoHonorario() {
		self.location = "honorarioindividual.jsp";
	}
	
	function excluirItem(exc) {
		
		conf = confirm("Confirma exclusão do item no Honorário Individual?");
		if(conf) {
			self.location = "honorarioindividual.jsp?cod=" + idReg + "&exc=" + exc;
		}
	}
	
	function gerarGuia(codHonorario) {
		window.open('guiahonorarioform.jsp?cod=' + codHonorario,'popuptiss','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,width=750,height=500,top=100,left=100');
	}	
	
	function atualizar() {
		//NADA (só para aproveitar da tela de lançamentos funanceiros)
	}
	
	function zerarProcedimento() {
		cbeGetElementById("cod_proced").value = "";
		cbeGetElementById("valor").value = "";
		cbeGetElementById("qtde").disabled = true;
		cbeGetElementById("valor").disabled = true;
	}
	
	function clickBotaoNovo() {
		novoHonorario();
	}
	
	function clickBotaoSalvar() {
		salvarHonorario();
	}
	
	function clickBotaoExcluir() {
		enviarAcao('exc');
	}	
	 

</script>
</head>

<body onLoad="iniciar()">
<%@include file="barrasessao.jsp" %>
<%@include file="barraajax.jsp" %>
<form name="frmcadastrar" id="frmcadastrar" action="honorarioindividual.jsp" method="post">
  <table width="600" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr>
      <td width="651" height="18" class="title">.: Honorário Individual :.</td>
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
		            <td class="tdMedium"><a href="Javascript:pesquisapornascimento(2)" title="Pesquisa por nome">Paciente: *</a>&nbsp;<a href="Javascript:pesquisapornascimento(1)" title="Pesquisa por data de nascimento"><img src="images/calendar.gif" border="0"></a></td>
		            <td colspan="2" class="tdLight" nowrap> 
              			<input type="hidden" name="codcli" id="codcli" value="<%= codcli %>">			
						<input style="width:98%" class="caixa" type="text" name="nome" id="nome" onKeyUp="busca(this.value, 'codcli', 'nome','paciente')" value="<%= nomepaciente%>">
						<input size="10" class="caixa" type="text" name="pesqnascimento" id="pesqnascimento" onKeyPress="buscanascimento(this.value, event); return formatar(this, event, '##/##/####');" style="display: none">
					</td>
					<td class="tdLight" align="center">
						<a href="Javascript: cadastrorapido()"><img src="images/raio.gif" border="0" alt="Cadastro Rápido"></a>
					</td>
					<td rowspan="3" class="tdLight" align="center">
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
		            <td class="tdMedium">Nascimento:</td>
					<td class="tdLight"><%= nascimento%>&nbsp;</td>								
					<td class="tdMedium">Idade:</td>					
					<td class="tdLight"><%= idade%>&nbsp;</td>
				</tr>
				<tr>
		            <td class="tdMedium">Convênio:</td>
					<td colspan="3" width="300" class="tdLight"><%= convenios[0]%>&nbsp;</td>
				</tr>
				<tr>
				  <td class="tdMedium">Hora Inicial: *</td>
				  <td class="tdLight"><input type="text" onKeyPress="return formatar(this, event, '##:##'); " class="caixa" size="6" name="horainicial" id="horainicial" maxlength="5" value="<%= horaInicial%>" onBlur="ValidaHora(this);"></td>
				  <td class="tdMedium">Hora Final: *</td>
				  <td class="tdLight"><input type="text" onKeyPress="return formatar(this, event, '##:##'); " class="caixa" size="6" name="horafinal" id="horafinal" maxlength="5" value="<%= horaFinal%>" onBlur="ValidaHora(this);"></td>
				  <td class="tdMedium" style="padding:0px" align="center">
					<%
						if(!Util.isNull(strcod))
							out.println("<a title='Imprimir Guia do TISS' href=\"Javascript:gerarGuia(" + strcod + ")\"><img src='images/tiss.jpg' width='60' border='0'></a>");
						else
							out.println("&nbsp;");
					%>
				  </td>
				</tr>
				<tr>
					<td class="tdMedium">Hospital: *</td>
					<td colspan="4" class="tdLight">
						<select name="hospital" id="hospital" class="caixa" style="width:400px">
							<option value=""></option>
							<%= honorario.getHospitais( cod_empresa )%>
						</select>
					</td>
				</tr>
				<tr>
					<td class="tdMedium">nº guia/senha solic.: *</td>
					<td class="tdLight">
						<input type="text" class="caixa" size="20" maxlength="20" name="guiaSolicitacao" id="guiaSolicitacao" value="<%= banco.getCampo("guiaSolicitacao", rs) %>">
					</td>
					<td class="tdMedium">Data da Guia *:</td>
					<td class="tdLight" colspan="2"><input type="text" onKeyPress="return formatar(this, event, '##/##/####'); " class="caixa" size="10" name="data" id="data" maxlength="10" value="<%= dataCons%>" onBlur="ValidaData(this)"></td>
				</tr>
				<tr>
				  <td class="tdMedium">Executante:</td>
				  <td colspan="4" class="tdLight">
					<select name="prof_reg" id="prof_reg" class="caixa" style="width: 400px">
						<option value=""></option>
						<%= honorario.getProfissionais(cod_empresa) %>
					</select>
				  </td>
				</tr>
				<tr>
					<td class="tdMedium">Grau de Part.: *</td>
					<td class="tdLight">
						<select name="grauParticipacao" id="grauParticipacao" class="caixa" style="width:130px" onChange="zerarProcedimento()">
							<option value=""></option>
							<%= honorario.getGrausdeParticipacao()%>
						</select> 
					</td>
					<td class="tdMedium">Tipo Acomodação: *</td>
					<td class="tdLight" colspan="2">
						<select name="tipoAcomodacao" id="tipoAcomodacao" class="caixa" style="width:170px" onChange="zerarProcedimento()">
							<option value=""></option>
							<%= honorario.getTiposAcomodacao()%>
						</select>
					</td>
				</tr>
				<tr>
					<td class="tdMedium">OBS:</td>
					<td colspan="4" class="tdLight">
						<textarea name="obs" id="obs" class="caixa" cols="80" rows="3"><%= banco.getCampo("obs", rs) %></textarea>
					</td>
				</tr>
				<tr>
					<td colspan="5">
						<table cellpadding="0" cellspacing="0" width="100%">
							<tr>
								<td width="70" class="tdMedium">Data</td>
								<td class="tdMedium">Tipo</td>
								<td width="20%" class='tdMedium'>Acesso</td>
								<td width="37%" class="tdMedium">Procedimento</td>
								<td width="12%" class='tdMedium'>qtde</td>
								<td width="16%" class='tdMedium'>Valor</td>
								<td width="15%" class='tdMedium'>Ação</td>
							</tr>
							<tr>
								<td class="tdLight"><input type="text" onKeyPress="return formatar(this, event, '##/##/####'); " class="caixa" size="9" name="dataproced" id="dataproced" maxlength="10" onBlur="ValidaData(this)" value="<%= Util.getData()%>"></td>
								<td class="tdLight">
									<select name="tipoProced" id="tipoProced" class="caixa" onChange="zerarProcedimento()" style="width:60px">
										<option value=""></option>
										<option value="U">Urgente</option>
										<option value="E">Eletivo</option>
									</select>
								</td>	
								<td class='tdLight'>
									<select name="viaAcesso" id="viaAcesso" class="caixa" onChange="zerarProcedimento()">
										<option value="U">U</option>
										<option value="D">D</option>
										<option value="M">M</option>
									</select>
								</td>
								<td class="tdLight">
									<div id="divprocedimentos">
											<%= honorario.getProcedimentos(convenios[1])%>
									</div>
								</td>
								<td class='tdLight'><input name="qtde" id="qtde" type="text" size="1" class="caixa" value="1"></td>
								<td class='tdLight'><input name="valor" id="valor" type="text" size="6" class="caixa"></td>
								<td class='tdLight' align="center"><a title="Adicionar Registro" href="Javascript:salvarHonorario();"><img src="images/add.gif" border="0"></a></td>
							</tr>
							<%= honorario.getItensHonorario( strcod )%>
						</table>
					</td>				
				</tr>
          </table>
      </td>
    </tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<%= Util.getBotoes("honorarioindividual", pesq, tipo) %>
	<tr>
		<td>&nbsp;</td>
	</tr>
    <tr>
		<td width="100%" style="text-align:center">
			<table width="600px">
				<tr>
					<td width="70" class="tdDark"><a title="Ordenar por Data" href="Javascript:ordenar('honorarioindividual','data')">Data</a></td>
					<td width="170" class="tdDark"><a title="Ordenar por Paciente" href="Javascript:ordenar('honorarioindividual','paciente.nome')">Paciente</a></td>
					<td width="170" class="tdDark"><a title="Ordenar por Profissional" href="Javascript:ordenar('honorarioindividual','profissional.nome')">Profissional</a></td>
					<td class="tdDark"><a title="Ordenar por Paciente" href="Javascript:ordenar('honorarioindividual','descricao')">Hospital</a></td>
				</tr>
			</table>
			<div style="width:600; height:101; overflow: auto">
				<table width="100%">
				    <%
						String resp[] = honorario.getHonorarios(pesq, ordem, numPag, 50, tipo, cod_empresa);
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
