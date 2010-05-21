<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.HonorarioIndividual" id="honorario" scope="page"/>
<jsp:useBean class="recursos.Paciente" id="paciente" scope="page"/>

<%
	String codcli     		= request.getParameter("codcli") !=null ? request.getParameter("codcli") : "";
	String nomepaciente   	=  "";	
	String nascimento 		=  "";	
	String idade      		=  "";	
	String foto 			=  "";
	String dataCons         = Util.getData();

	if(!Util.isNull(strcod)) {
		rs = banco.getRegistro("resumointernacao","cod_resumointernacao", Integer.parseInt(strcod));
		codcli = banco.getCampo("codcli", rs);
		dataCons = Util.formataData(banco.getCampo("data", rs));
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
	
	//Para excluir um item do do resumo de internação
	honorario.removeItemResumoInternacao(request.getParameter("exc"));

	//Para excluir um profisional da equipe do resumo de internação
	honorario.removeProfResumoInternacao(request.getParameter("excprof"));
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
	 var nome_campos_obrigatorios = Array("Paciente", "Data da Guia", "Data da Internação", "Hora da Internação", "Caráter Internação", "Tipo Acomodação","Tipo Internação", "Regime Internação", "CID Principal", "Motivo Saída", "Tipo de Faturamento");
     //Campos obrigatórios
	 var campos_obrigatorios = Array("codcli", "data", "dataInternacao", "horaInternacao", "caraterInternacao", "tipoAcomodacao", "tipoInternacao", "regimeInternacao", "diagnosticoPrincipal", "motivoSaidaInternacao", "tipoFaturamento");
	 //Página a enviar o formulário
	 var page = "gravarresumointernacao.jsp";
	 //Cod. da ajuda
	 cod_ajuda = -1;

	 
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

	function setarChk(nome, valor) {
		var obj = cbeGetElementById(nome);
		if(valor == "S") obj.checked = true;
	}


	function iniciar() {
		//Preeche Combos
		cbeGetElementById("caraterInternacao").value = "<%= banco.getCampo("caraterInternacao", rs) %>";
		cbeGetElementById("tipoAcomodacao").value = "<%= banco.getCampo("tipoAcomodacao", rs) %>";
		cbeGetElementById("tipoInternacao").value = "<%= banco.getCampo("tipoInternacao", rs) %>";
		cbeGetElementById("regimeInternacao").value = "<%= banco.getCampo("regimeInternacao", rs) %>";
		cbeGetElementById("obitoMulher").value = "<%= banco.getCampo("obitoMulher", rs) %>";
		cbeGetElementById("indicadorAcidente").value = "<%= banco.getCampo("indicadorAcidente", rs) %>";
		cbeGetElementById("motivoSaidaInternacao").value = "<%= banco.getCampo("motivoSaidaInternacao", rs) %>";
		cbeGetElementById("tipoFaturamento").value = "<%= banco.getCampo("tipoFaturamento", rs) %>";

		//Setar os checkbox
		setarChk("emGestacao", "<%= banco.getCampo("emGestacao", rs) %>");
		setarChk("aborto", "<%= banco.getCampo("aborto", rs) %>");
		setarChk("transtornoMaternoRelGravidez", "<%= banco.getCampo("transtornoMaternoRelGravidez", rs) %>");
		setarChk("complicacaoPeriodoPuerperio", "<%= banco.getCampo("complicacaoPeriodoPuerperio", rs) %>");
		setarChk("atendimentoRNSalaParto", "<%= banco.getCampo("atendimentoRNSalaParto", rs) %>");
		setarChk("complicacaoNeonatal", "<%= banco.getCampo("complicacaoNeonatal", rs) %>");
		setarChk("baixoPeso", "<%= banco.getCampo("baixoPeso", rs) %>");
		setarChk("partoCesareo", "<%= banco.getCampo("partoCesareo", rs) %>");
		setarChk("partoNormal", "<%= banco.getCampo("partoNormal", rs) %>");
		
		//Trava campos do procedimentos até escolher um
		//cbeGetElementById("qtde").disabled = true;
		//cbeGetElementById("valor").disabled = true;
		
		inicio();
		barrasessao();
	}	
	
	function salvarProcedimento() {

		//Valida os campos antes
		passou = validaCampos();

		//Se passou na validação anterior, verificar procedimentos
		if(passou) {
			//Se não é edição, obrigar procedimento novo
			if(idReg == "null") {
				var jsdataproced = cbeGetElementById("dataproced");
				var jsProced = cbeGetElementById("cod_proced");
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
		
		conf = confirm("Confirma exclusão do item do Resumo de Internação?");
		if(conf) {
			self.location = "resumointernacao.jsp?cod=" + idReg + "&exc=" + exc;
		}
	}

	function excluirProfItem(exc) {
		
		conf = confirm("Confirma exclusão do profissional da equipe do Resumo de Internação?");
		if(conf) {
			self.location = "resumointernacao.jsp?cod=" + idReg + "&excprof=" + exc;
		}
	}
	
	function gerarGuia(codHonorario) {
		window.open('guiaresumointernacaoform.jsp?cod=' + codHonorario,'popuptiss','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,width=750,height=500,top=100,left=100');
	}	
	
	function clickBotaoNovo() {
		novoHonorario();
	}
	
	function clickBotaoSalvar() {
		salvarProcedimento();
	}
	
	function clickBotaoExcluir() {
		enviarAcao('exc');
	}	
	 
	function mudarProcedimento(combo) { 
	
		//Verifica se existe algum campo não preenchido
		passou = validaCampos();
		
		if(passou) {
			//Capturar valores para envio
			var jsproced = combo.value;
			var jsplano = cbeGetElementById("cod_convenio").value;
			var jsgp = "00"; //Cirurgião para valor cheio
			var jsta = "1"; //Não aumenta por ser apto
			var jshi = ""; //sem validação de hora
			var jsdata = ""; //sem validação de data
			var jstipoProced = "E"; //Não é urgência para não aumentar o valor
			var jsva = "U"; //via de acesso de valor cheio
		
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
	
	function atualizar() {
	
	}

</script>
</head>

<body onLoad="iniciar()">
<%@include file="barrasessao.jsp" %>
<%@include file="barraajax.jsp" %>
<blockquote>
  <form name="frmcadastrar" id="frmcadastrar" action="resumointernacao.jsp" method="post">
    <table width="600" border="0" align="center" cellpadding="2" cellspacing="0">
      <tr>
        <td width="651" height="18" class="title">.: Resumo de Internação :.</td>
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
               <td class="tdMedium"><a href="Javascript:pesquisapornascimento(2)" title="Pesquisa por nome">Paciente: *</a>&nbsp;<a href="Javascript:pesquisapornascimento(1)" title="Pesquisa por data de nascimento"><img src="images/calendar.gif" border="0"></a>
               </td>
               <td colspan="3" class="tdLight" nowrap> 
	                <input type="hidden" name="codcli" id="codcli" value="<%= codcli %>">			
	                <input style="width:98%" class="caixa" type="text" name="nome" id="nome" onKeyUp="busca(this.value, 'codcli', 'nome','paciente')" value="<%= nomepaciente%>">
	                <input size="10" class="caixa" type="text" name="pesqnascimento" id="pesqnascimento" onKeyPress="buscanascimento(this.value, event); return formatar(this, event, '##/##/####');" style="display: none">                
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
              <td class="tdMedium">nº guia/senha solic.:</td>
			    <td class="tdLight">
				    <input type="text" class="caixa" size="20" maxlength="20" name="guiaSolicitacao" id="guiaSolicitacao" value="<%= banco.getCampo("guiaSolicitacao", rs) %>">
                </td>
			    <td class="tdMedium">Data da Guia *:</td>
                    <td class="tdLight"><input type="text" onKeyPress="return formatar(this, event, '##/##/####'); " class="caixa" size="10" name="data" id="data" maxlength="10" value="<%= dataCons%>" onBlur="ValidaData(this)"></td>
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
              <td class="tdMedium">Data Autorização: </td>
			  <td colspan="4">
				   <table width="100%" cellpadding="0" cellspacing="0">
				        <tr>
					        <td class="tdLight">
					          <input type="text" onKeyPress="return formatar(this, event, '##/##/####'); " class="caixa" size="10" name="dataAutorizacao" id="dataAutorizacao" maxlength="10" value="<%= Util.formataData(banco.getCampo("dataAutorizacao", rs))%>" onBlur="ValidaData(this)">
                             </td>
                            <td class="tdMedium">Senha:</td>
                            <td class="tdLight" colspan="2"><input type="text" class="caixa" size="15" name="senhaAutorizacao" id="senhaAutorizacao" maxlength="20" value="<%= banco.getCampo("senhaAutorizacao", rs)%>"></td>
                            <td class="tdMedium">Validade Senha:</td>
                            <td class="tdLight" colspan="2"><input type="text" onKeyPress="return formatar(this, event, '##/##/####'); " class="caixa" size="10" name="validadeSenha" id="validadeSenha" maxlength="10" value="<%= Util.formataData(banco.getCampo("validadeSenha", rs))%>" onBlur="ValidaData(this)">
                            </td>
                        </tr>
			       </table>                
              </td>
		    </tr>
            <tr>
              <td class="tdMedium">Dt/Hr. Internação: *</td>
		      <td class="tdLight">
		         <input type="text" onKeyPress="return formatar(this, event, '##/##/####'); " class="caixa" size="10" name="dataInternacao" id="dataInternacao" maxlength="10" value="<%= Util.formataData(banco.getCampo("dataInternacao", rs))%>" onBlur="ValidaData(this)">
              	<input type="text" onKeyPress="return formatar(this, event, '##:##'); " class="caixa" size="5" name="horaInternacao" id="horaInternacao" maxlength="5" value="<%= Util.formataHora(banco.getCampo("horaInternacao", rs))%>" onBlur="ValidaHora(this);">
               </td>
              <td class="tdMedium">Dt/Hr. Saída:</td>
		      <td class="tdLight" colspan="2">
		         <input type="text" onKeyPress="return formatar(this, event, '##/##/####'); " class="caixa" size="10" name="dataSaidaInternacao" id="dataSaidaInternacao" maxlength="10" value="<%= Util.formataData(banco.getCampo("dataSaidaInternacao", rs))%>" onBlur="ValidaData(this)">
              	<input type="text" onKeyPress="return formatar(this, event, '##:##'); " class="caixa" size="5" name="horaSaidaInternacao" id="horaSaidaInternacao" maxlength="5" value="<%= Util.formataHora(banco.getCampo("horaSaidaInternacao", rs))%>" onBlur="ValidaHora(this);">
               </td>
		    </tr>
            <tr>
              <td class="tdMedium">Caráter Internação: *</td>
			    <td class="tdLight">
				    <select name="caraterInternacao" id="caraterInternacao" class="caixa" style="width:110px">
				        <option value="E">Eletiva</option>
                        <option value="U">Urgência/Emergência</option>
			        </select>		        
                </td>
			    <td class="tdMedium">Tipo Acomodação: *</td>
			    <td class="tdLight" colspan="2">
				    <select name="tipoAcomodacao" id="tipoAcomodacao" class="caixa" style="width:170px">
				        <option value=""></option>
				        <%= honorario.getTiposAcomodacao()%>
			        </select>		       
                 </td>
			    </tr>
            <tr>
              <td class="tdMedium">Tipo Internação: *</td>
			    <td class="tdLight">
				    <select name="tipoInternacao" id="tipoInternacao" class="caixa">
						<%= honorario.getTiposInternacao() %>
			        </select>		        
                </td>
			    <td class="tdMedium">Regime Internação: *</td>
			    <td class="tdLight" colspan="2">
				    <select name="regimeInternacao" id="regimeInternacao" class="caixa" style="width:170px">
				        <option value="1">Hospitalar</option>
                        <option value="2">Hospital-Dia</option>
                        <option value="3">Domiciliar</option>
			        </select>		       
                 </td>
		    </tr>
            <tr>
              <td class="tdMedium">Intern. Obstétrica:</td>
			    <td class="tdLight" colspan="2">
					<input type="checkbox" name="emGestacao" id="emGestacao" value="S">Em gestação<br>
                    <input type="checkbox" name="aborto" id="aborto" value="S">Aborto<br>
                    <input type="checkbox" name="transtornoMaternoRelGravidez" id="transtornoMaternoRelGravidez" value="S">Transtorno materno rel. à gravidez<br>
                    <input type="checkbox" name="complicacaoPeriodoPuerperio" id="complicacaoPeriodoPuerperio" value="S">Complic. Puerpério<br>
                    <input type="checkbox" name="atendimentoRNSalaParto" id="atendimentoRNSalaParto" value="S">Atend. ao RN na sala de parto<br>
                </td>
			    <td class="tdLight" colspan="2">
                    <input type="checkbox" name="complicacaoNeonatal" id="complicacaoNeonatal" value="S">Complicação Neonatal<br>  
                    <input type="checkbox" name="baixoPeso" id="baixoPeso" value="S">Bx. Peso &lt;2,5 Kg.<br>  
                    <input type="checkbox" name="partoCesareo" id="partoCesareo" value="S">Parto Cesáreo<br>                
                    <input type="checkbox" name="partoNormal" id="partoNormal" value="S">Parto Normal<br>                
                 </td>
		    </tr>
            <tr>
              <td class="tdMedium">Óbito em mulher:</td>
			    <td class="tdLight" colspan="4">
                	<select name="obitoMulher" id="obitoMulher" class="caixa">
						<option value=""></option>
						<option value="1">Grávida</option>
                        <option value="2">até 42 dias após fim gestação</option>
                        <option value="3">de 43 dias a 12 meses após fim gestação</option>                    
                    </select>
                </td>
             </tr>
             <tr>
				<td class="tdMedium">Óbito neonatal: </td>
			    <td class="tdLight" colspan="2">
					<input type="text" class="caixa" name="qtdeobitoPrecoce" id="qtdeobitoPrecoce" size="2" maxlength="2" value="<%=  banco.getCampo("qtdeobitoPrecoce", rs)%>"> Óbito neonatal precoce
               </td>
                 <td class="tdLight" colspan="2">
                    <input type="text" class="caixa" name="qtdeobitoTardio" id="qtdeobitoTardio" size="2" maxlength="2" value="<%=  banco.getCampo("qtdeobitoTardio", rs)%>"> Óbito neonatal tardio
                 </td>
		    </tr>
            <tr>
              <td class="tdMedium"> Nº Decl. Nasc. Vivos:</td>
			    <td colspan="4" width="100%">
					<table width="100%" cellpadding="0" cellspacing="0">
                    	<tr>
                        	<td class="tdLight"><input type="text" name="declaracoesNascidosVivos" id="declaracoesNascidosVivos" class="caixa" size="1" maxlength="2" value="<%=  banco.getCampo("declaracoesNascidosVivos", rs)%>"></td>
                            <td class="tdMedium">NV a Termo:</td>
                            <td class="tdLight"><input type="text" name="qtdNascidosVivosTermo" id="qtdNascidosVivosTermo" class="caixa" size="1" maxlength="2" value="<%=  banco.getCampo("qtdNascidosVivosTermo", rs)%>"></td>
                            <td class="tdMedium">Nasc. Mortos:</td>
                            <td class="tdLight"><input type="text" name="qtdNascidosMortos" id="qtdNascidosMortos" class="caixa" size="1" maxlength="2" value="<%=  banco.getCampo("qtdNascidosMortos", rs)%>"></td>
                            <td class="tdMedium">NV Prematuro:</td>
                            <td class="tdLight"><input type="text" name="qtdVivosPrematuros" id="qtdVivosPrematuros" class="caixa" size="1" maxlength="2" value="<%=  banco.getCampo("qtdVivosPrematuros", rs)%>"></td>
                        </tr>
                    </table>                	
					
                </td>
		    </tr>
            <tr>
              <td class="tdMedium">CID Principal: *</td>
              <td colspan="4" width="100%">
              	<table width="100%" cellpadding="0" cellspacing="0">
                	<tr>
                        <td class="tdLight">
                            <input type="text" name="diagnosticoPrincipal" id="diagnosticoPrincipal" class="caixa" maxlength="5" size="5" value="<%=  banco.getCampo("diagnosticoPrincipal", rs)%>">
                        </td>
                        <td class="tdMedium">Indicador de acidente: </td>
                        <td class="tdLight" colspan="2">
                            <select class="caixa" name="indicadorAcidente" id="indicadorAcidente">
								<option value=""></option>
                                <option value="0">Acidente ou doença relacionado ao trabalho</option>
                                <option value="1">Trânsito</option>
                                <option value="2">Outros</option>
                            </select>
                         </td>
                    </tr>
                </table>
              </td>
		    </tr>
            <tr>
              <td class="tdMedium">Motivo Saída: *</td>
 		      <td colspan="4" class="tdLight">
                    <select class="caixa" name="motivoSaidaInternacao" id="motivoSaidaInternacao">
                        <option value="11">Alta Curado</option>
                        <option value="12">Alta Melhorado</option>
                        <option value="13">Alta da Puérpera e permanência do recém-nascido</option>
                        <option value="14">Alta a pedido</option>
                        <option value="15">Alta com previsão de retorno para acompanhamento do paciente</option>
                        <option value="16">Alta por Evasão</option>
                        <option value="17">Alta da Puérpera e recém-nascido</option>
                        <option value="18">Alta por Outros motivos</option>
                        <option value="21">Por características próprias da doença</option>
                        <option value="22">Por Intercorrência</option>
                        <option value="23">Por impossibilidade sócio-familiar</option>
                        <option value="24">Por Processo de doação de órgãos, tecidos e células - doador vivo</option>
                        <option value="25">Por Processo de doação de órgãos, tecidos e células - doador morto</option>
                        <option value="26">Por mudança de Procedimento</option>
                        <option value="27">Por reoperação</option>
                        <option value="28">Outros motivos</option>
                        <option value="31">Transferido para outro estabelecimento</option>
                        <option value="41">Com declaração de óbito fornecida pelo médico assistente</option>
                        <option value="42">Com declaração de Óbito fornecida pelo Instituto Médico Legal - IML </option>
                        <option value="43">Com declaração de Óbito fornecida pelo Serviço de Verificação de Óbito - SVO </option>
                        <option value="51">ENCERRAMENTO ADMINISTRATIVO</option>
                    </select>
                </td>
		    </tr>
             <tr>
                <td class="tdMedium">CID 10 Óbito:</td>
                <td class="tdLight"><input type="text" name="CID" id="CID" class="caixa" size="5" maxlength="5" value="<%=  banco.getCampo("CID", rs)%>"></td>
                <td class="tdMedium">Nº Declaração do Óbito:</td>
                <td class="tdLight" colspan="2"><input type="text" name="numeroDeclaracao" id="numeroDeclaracao" class="caixa" size="12" maxlength="12" value="<%=  banco.getCampo("numeroDeclaracao", rs)%>"></td>
            </tr>
             <tr>
                <td class="tdMedium">Tipo de Faturamento: *</td>
                <td class="tdLight" colspan="4">
                	<select name="tipoFaturamento" id="tipoFaturamento" class="caixa">
                    	<option value=""></option>
                        <option value="T">Total</option>
                        <option value="P">Parcial</option>
                    </select>	
                </td>
            </tr>
			<tr>
            	<td colspan="5" class="tdDark" align="center"><strong>Procedimentos e Exames Realizados</strong></td>
            </tr>
			<tr>
              <td colspan="5">
                <table cellpadding="0" cellspacing="0" width="100%">
                  <tr>
                    <td width="70" class="tdMedium">Data</td>
					  <td class='tdMedium'>Início</td>
					  <td class='tdMedium'>Fim</td>
                      <td class='tdMedium'>Acesso</td>
					  <td class="tdMedium">Procedimento</td>
					  <td class='tdMedium'>qtde</td>
					  <td class='tdMedium'>Valor</td>
					  <td class='tdMedium'>Ação</td>
				    </tr>
                  <tr>
                    <td class="tdLight" style="padding:2px">
                    	<input type="text" onKeyPress="return formatar(this, event, '##/##/####'); " class="caixa" size="9" name="dataproced" id="dataproced" maxlength="10" onBlur="ValidaData(this)" value="<%= Util.getData()%>"></td>
					  <td class="tdLight" style="padding:2px">
			              	<input type="text" onKeyPress="return formatar(this, event, '##:##'); " class="caixa" size="4" name="horaInicio" id="horaInicio" maxlength="5"  onBlur="ValidaHora(this);">
                      </td>	
					  <td class='tdLight' style="padding:2px">
			              	<input type="text" onKeyPress="return formatar(this, event, '##:##'); " class="caixa" size="4" name="horaFim" id="horaFim" maxlength="5"  onBlur="ValidaHora(this);">
                      </td>
                        <td class='tdLight' style="padding:2px">
                            <select name="viaAcesso" id="viaAcesso" class="caixa" style="width:40px">
                                <option value="U">U</option>
                                <option value="D">D</option>
                                <option value="M">M</option>
                            </select>
                        </td>
					  <td class="tdLight" style="padding:2px">
					      <div id="divprocedimentos">
							      <%= honorario.getProcedimentos(convenios[1])%>
                          </div>
                      </td>
					  <td class='tdLight' style="padding:2px"><input name="qtde" id="qtde" type="text" size="1" class="caixa" value="1"></td>
					  <td class='tdLight' style="padding:2px"><input name="valor" id="valor" type="text" size="6" class="caixa"></td>
					  <td class='tdLight' align="center" style="padding:2px"><a title="Adicionar Registro" href="Javascript:salvarProcedimento();"><img src="images/add.gif" border="0"></a></td>
				    </tr>
                  <%= honorario.getItensResumoInternacao( strcod, cod_empresa )%>
                  </table>			   
                 </td>				
			    </tr>
          <tr>
                <td colspan="5" class="tdDark" align="center"><strong>Identificação da Equipe</strong></td>
          </tr>
            <tr>
              <td colspan="5">
                <table cellpadding="0" cellspacing="0" width="100%">
                    <tr>
                      <td width="70" class="tdMedium">Gr. Part.</td>
                      <td class='tdMedium'>Profissional</td>
                      <td width="15%" class='tdMedium'>Ação</td>
                    </tr>
                    <tr>
                        <td class="tdLight">
                            <select name="grauParticipacao" id="grauParticipacao" class="caixa" style="width:130px">
                                <option value=""></option>
                                <%= honorario.getGrausdeParticipacao()%>
                            </select> 
                        </td>
                        <td class="tdLight">
                            <select name="prof_reg" id="prof_reg" class="caixa" style="width: 96%">
                                <option value=""></option>
                                <%= honorario.getProfissionais(cod_empresa) %>
                            </select>
                        </td>
                        <td class='tdLight' align="center"><a title="Adicionar Registro" href="Javascript:salvarProcedimento();"><img src="images/add.gif" border="0"></a></td>
                    </tr>
                    <%= honorario.getProfissionaisResumoInternacao( strcod )%>
                </table>
              </td>
             </tr>
                
            </table>
          </td>
      </tr>
      <tr>
        <td>&nbsp;</td>
	  </tr>
      <%= Util.getBotoes("resumointernacao", pesq, tipo) %>
      <tr>
        <td>&nbsp;</td>
	  </tr>
      <tr>
        <td width="100%" style="text-align:center">
          <table width="600px">
            <tr>
                <td width="70" class="tdDark"><a title="Ordenar por Data" href="Javascript:ordenar('resumointernacao','data')">Data</a></td>
			    <td class="tdDark"><a title="Ordenar por Paciente" href="Javascript:ordenar('resumointernacao','paciente.nome')">Paciente</a></td>
			  </tr>
            </table>
		    <div style="width:600; height:101; overflow: auto">
			    <table width="100%">
			      <%
						String resp[] = honorario.getResumosInternacao(pesq, ordem, numPag, 50, tipo, cod_empresa);
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
</blockquote>
</body>
</html>
