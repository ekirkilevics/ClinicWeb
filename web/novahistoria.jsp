<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.Historico" id="historico" scope="page"/>
<jsp:useBean class="recursos.Profissional" id="profissional" scope="page"/>
<jsp:useBean class="recursos.Paciente" id="paciente" scope="page"/>
<jsp:useBean class="recursos.Modelos" id="modelo" scope="page"/>

<%

//Captura código do paciente e seus dados
String codcli = request.getParameter("codcli") != null ? request.getParameter("codcli") : "";
String dadospaciente[] = paciente.getDadosPaciente(codcli);

//Captura dados do profissional logado
String proflogado[] = profissional.getProfissional((String)session.getAttribute("usuario"));

//alerta: qtde de alertas
String alerta = historico.getAlertas(codcli);

/* Retorna:  
[0]: Nome do paciente
[1]: Código do paciente
[2]: Nome do profissional
[3]: Registro do profissional
[4]: Data da Consulta
[5]: Hora da Consulta
[6]: História
[7]: Definitiva
[8]: História Resumo 
[9]: tipohistoria
*/
String historia[] = {"","","","","","","","","",""};
String mesmoprofissional = "";

try {
	historia[3] = proflogado[0];
	historia[2] = proflogado[1];
	
	//Se chegou um cód. de história, buscar os dados do histórico
    if(strcod != null) {
        historia = historico.getHistorico(strcod);

		//Pega o conteúdo da história formatado
		historia[6] = Util.freeRTE_Preload(historia[6]);
    }

	//Verifica se o profissional logado é o mesmo da história
	if(proflogado[0].equals(historia[3]) || Util.isNull(proflogado[0]))
		mesmoprofissional = "S";
	else
		mesmoprofissional = "N";
		
    
    //Se veio um codcli, buscar os alertas do paciente
	if( !Util.isNull(codcli) ){
        historia[1] = codcli;
        alerta = historico.getAlertas(codcli);
    }
} catch(Exception e) {
    out.println(e.toString());
}

//Verifica se usa história definitiva
String histdefinitiva = configuracao.getItemConfig("usardefinitivo", cod_empresa);

%>

<html>
    <head>
        <title>..:: História do Paciente ::..</title>
        <link href="css/css.css" rel="stylesheet" type="text/css">
        <script language="Javascript" src="CBE/cbe_core.js"></script>
        <script language="JavaScript" src="js/scriptsform.js"></script>
		<script src="js/richtext.js" type="text/javascript" language="javascript"></script>
		<script src="js/config.js" type="text/javascript" language="javascript"></script>
		<script language="JavaScript" src="js/ajax.js"></script>
        <script language="JavaScript">
		 //id
		 var idReg = "<%= strcod%>";
		 //Informação vinda de gravar
		 var inf = "<%= inf%>";
		 //Nome dos campos
		 var nome_campos_obrigatorios = Array();
		 //Página a enviar o formulário
		 var page = "gravarhistoricopac.jsp";
		 //Campos obrigatórios
		 var campos_obrigatorios = Array();
		 
		 //Mesmo profissional
		 var jsmesmoprofissional = "<%= mesmoprofissional%>";
		 
		 var nome, idade, nascimento;
		 
		 var qtdealertas = parseInt("<%= alerta%>");
		 var codcli = "<%= historia[1]%>";
		 var msgbtn;
		 
		 function getHistoria()
		 {
			var textohist = cbeGetElementById("historiahid").value;
			if(textohist.length == 0) {
				textohist = "<font face=Verdana, Arial, Helvetica, sans-serif size=2></font>";
			}
			return textohist;
		 }
		 
		function removeItem(tipo)
		{
			var obj = getObj("","lst"+tipo);
			var pos = obj.selectedIndex;
			if(pos >= 0) {
				conf = confirm("Excluir o item da lista?","Confirmação");
				if(conf) {
					//Se o tipo for medicamento, remover a indicação também
					if(tipo == "medicamento") {
						cbeGetElementById("lstindicacao").remove(pos);
					}
					obj.remove(pos);
				}
			}
		}
		
		function travar()
		{
			var frm = cbeGetElementById("frmcadastrar");	
			frm.tipohistoria.value = "<%= historia[9]%>";		
			//Se a história for definitiva, travar botões
			<% if( historia[7].equals("S") ) {%>
				frm.salvar.disabled = true;
				frm.salvarfechar.disabled = true;
				frm.exclui.disabled = true;
				cbeGetElementById("profissional.nome").disabled = true;
				frm.data.disabled = true;
				frm.hora.disabled = true;
				frm.definitivo.checked = true;
				frm.definitivo.disabled = true;
				frm.resumo.disabled = true;
			<% } %>
			
			//Se está no perfil como usar somente história definitiva
			<% if(histdefinitiva.equals("S")) { %>
				frm.definitivo.checked = true;
				frm.definitivo.disabled = true;
			<% } %>
	
			//Se for história nova, não habilitar excluir e colocar data e hora
			if(idReg == "null") {
				frm.exclui.disabled = true;
				frm.data.value = getHoje();
				frm.hora.value = getHora();
			}

			//Mostra os alertas
			if(qtdealertas == 0) msgbtn = "Sem alertas";
			else if(qtdealertas == 1) msgbtn = "1 alerta";
			else msgbtn = qtdealertas + " alertas";
			cbeGetElementById("btnalerta").title = msgbtn;
	
		}
		
		function fechar()
		{
			try {
				var page = window.opener.document;
				page.frmcadastrar.submit();
			} catch(e) {}
			self.close();
		}
		
		function sair() {
			conf = confirm("Tem certeza que deseja fechar a janela?")
			if(conf) fechar();
		}
		
		function travaDefinitiva(obj)
		{
			//Só altera o status da definitiva se ela não estiver travada
			if(cbeGetElementById("definitivo").disabled == false)
				cbeGetElementById("definitivo").checked = obj.checked;
		}
		
		function verificaResumo(obj) {
			if(cbeGetElementById("resumo").checked == true)
				obj.checked = true;
		}
		
		function mostraImagens()
		{
			if(idReg == "null")
				alert("Salve a história antes de inserir imagens")
			else
				displayPopup("insereimagem.jsp?codhist=" + idReg, "imagens", 450, 600);
		}
		
		function abreAlertas() {
			displayPopup("editaralertas.jsp?codcli=" + codcli, "alertas",300,500);
		}

		function mostrarLembretes() {
			displayPopup("lembretespaciente.jsp?codcli=" + codcli, "lembretes",400,610);
		}

		function abreExames() {
			var jsdata = cbeGetElementById("data");
			window.open('verexames.jsp?codcli=' + codcli + '&data=' + jsdata.value,'exames','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,menubar=no,width=650,height=450,top=10,left=10');			
		}
		
		function solicitaSADT() {
			if(idReg == "null") {
				alert("Salve a história antes de abrir a guia de solicitação de exames");
				return;
			}
			else {	
			window.open("selecionarprocedimentos.jsp?cod=" + idReg,"guiasadt","toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,menubar=no,width=400,height=250,top=20,left=30");			
			}

		}
		
		function responderProtocolo() {
			window.open('aplicarprotocolo.jsp?codcli=' + codcli,'protocolos','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,menubar=no,width=650,height=450,top=10,left=10');			
		}

	//Sobrescrendo a função do AJAX
	function setar(chave, campo, valorchave, valorcampo) {
		
		//Preeche a combo correta
		if(campo == "DESCRICAO")
			insereCombo("lstdiagnostico", valorchave, valorcampo);
		else if(campo == "Procedimento")
			insereCombo("lstprocedimento", valorchave, valorcampo);
		else if(campo == "comercial") {
			exibeIndicacao(true);
			insereCombo("lstmedicamento", valorchave, valorcampo);
			buscaIndicacao(valorchave, cbeGetElementById("prof_reg").value);
		}
		else if(campo == "profissional.nome") {
			cbeGetElementById(campo).value = valorcampo;
			cbeGetElementById(chave).value = valorchave;
			x.innerHTML = "";
			hide();
			return;
		}

		//Limpa campo
		cbeGetElementById(campo).value = "";
		x.innerHTML = "";
		hide();
	}
	
	function salvarhistoria(tiposalvar) {
		var jsdata = cbeGetElementById("data");
		var jshora = cbeGetElementById("hora");
		var jsprof_reg = cbeGetElementById("prof_reg");
		
		//Se for outro profissional, não permitir alterar
		if(jsmesmoprofissional == "N") {
			alert("Não é possível alterar a história de outro profissional.");
			return;
		}

		//Valida Preenchimento dos campos obrigatórios
		if(jsdata.value == "") {
			alert("Forneça a data da história!")
			jsdata.focus();
			return;
		}
		if(jshora.value == "") {
			alert("Forneça a hora da história!")
			jshora.focus();
			return;
		}
		if(jsprof_reg.value == "") {
			alert("Forneça o nome do profissional!")
			cbeGetElementById("profissional.nome").focus();
			return;
		}
		cbeGetElementById("tiposalvar").value = tiposalvar;
	
		//Coloca o conteúdo do Rich Text na caixa oculta
		cbeGetElementById("historiahid").value = document.getElementById(rteName).contentWindow.document.body.innerHTML;
		enviarAcao('inc');
	}
	
	function imprimir(tipo) {
		//Se for história nova, gravar antes de imprimir
		if(idReg == "null") {
			alert("Salve a história antes de imprimir");
		}
		else { //Se for edição, apenas imprimir
			var jsprof_reg = cbeGetElementById("prof_reg").value;
			displayPopup("receita.jsp?codcli=" + codcli + "&prof_reg=" + jsprof_reg + "&cod_hist=" + idReg + "&tipomodelo=" + tipo, "receita", 450, 600);
		}
	}
	
	function abreprancheta() {
		if(idReg == "null") {
			alert("Salve a história para habilitar o uso da Prancheta.")
			return;
		}
		else {
			window.open("arealivre.jsp?codhist=" + idReg);
		}
	}
	
	function abrirguia() {
		var jsdata = cbeGetElementById("data").value;
		eval("window.open('gerarguia.jsp?codcli=" + codcli + "&data=" + jsdata + "','popuptiss','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,width=750,height=500,top=0,left=0')");
	}

	function insereHistoria(texto) {
		rteInsertHTML(texto);
	}
	
	function carregamodelo () {
		var jscodmodelo = cbeGetElementById("modelohistoria")[cbeGetElementById("modelohistoria").selectedIndex].value;

		//Se não selecionou o modelo, avidar
		if(jscodmodelo == "")
			alert("Selecione o modelo para usá-lo como Protocolo");
		else
			pegaModelo(jscodmodelo);
	}
	
	function atualizarId(novo_id, tiposalvar) {
		idReg = novo_id;
		var frm = cbeGetElementById("frmcadastrar");
		
		//Se está no perfil como usar somente história definitiva
		<% if(histdefinitiva.equals("S")) { %>
			frm.definitivo.checked = true;
			frm.definitivo.disabled = true;
		<% } %>

		//Se escolher salvar e fechar, sair da tela
		if(tiposalvar == "2")
			fechar();
		else {
			try {
				var page = window.opener.document;
				page.frmcadastrar.submit();
			} catch(e) {}
			alert("História salva com sucesso");
		}
		
	}
	
	//Exibe ou esconde a caixa de inserção de indicação do medicamento
	function exibeIndicacao(exibir) {
		if(exibir) {
			cbeGetElementById("iframemedicamento").style.display = "block";
			cbeGetElementById("divmedicamento").style.display = "block";
		} else {
			cbeGetElementById("iframemedicamento").style.display = "none";
			cbeGetElementById("divmedicamento").style.display = "none";
		}
	}
	
	function insereIndicacao() {
		var jsIndicacao = cbeGetElementById("indicacao");
		
		if(jsIndicacao.value == "") {
			alert("Preencha a indicação do medicamento");
			jsIndicacao.focus();
			return;
		}
		else {
			insereCombo("lstindicacao", jsIndicacao.value, jsIndicacao.value);
			jsIndicacao.value = "";		
			exibeIndicacao(false);
		}
		
	}
	
	//Caso queira sair da indicação sem escrever nada, remover o medicamento da lista (último)
	function removeItemIndicacao() {
		var jslstmedicamento = cbeGetElementById("lstmedicamento");
		jslstmedicamento.remove(jslstmedicamento.length-1);
		exibeIndicacao(false);
	}

		
    </script>
    </head>
    <body onLoad="travar();">
	<%@include file="barraajax.jsp" %>
        <form name="frmcadastrar" id="frmcadastrar" action="gravarhistoricopac.jsp" method="post" target="iframehistoria">
            <input type="hidden" name="codcli" id="codcli" value="<%= historia[1]%>">
			<input type="hidden" name="tiposalvar" id="tiposalvar">
			<center>
            <table width="95%" border="0" align="center" cellpadding="2" cellspacing="0">
                <tr>
					<td  width="100%">
						<table cellpadding="0" cellspacing="0" class="table" width="100%">
							<tr>
								<td width="70" class="tdMedium">Paciente:</td>
			                    <td class="tdLight"><b style="color:red"><%= dadospaciente[2] %> ( <%= dadospaciente[0] %> ) - <%= Util.getIdade(dadospaciente[0], historia[4]) %></b></td>
							</tr>
						</table>
					</td>
                </tr>
                <tr align="center" valign="top">
                    <td>
                        <table width="100%" border="0" cellpadding="0" cellspacing="0" class="table">
                            <tr>
                                <td class="tdMedium">Data:</td>
                                <td colspan="3">
									<table cellpadding="0" cellspacing="0" width="100%">
										<tr>
											<td class="tdLight">
												<input type="text" onKeyPress="return formatar(this, event, '##/##/####'); " class="caixa" size="10" name="data" id="data" maxlength="10" value="<%= historia[4]%>" onBlur="ValidaData(this);ValidaFuturo(this)">
											 </td>
											<td class="tdMedium">Hora:</td>
											<td class="tdLight"><input type="text" onKeyPress="return formatar(this, event, '##:##'); " class="caixa" size="6" name="hora" id="hora" maxlength="5" value="<%= historia[5]%>" onBlur="ValidaHora(this)"></td>
											 <td class="tdMedium" align="center">
											 	<a href="Javascript:abreExames()"  title="Exames"><img src="images/exames.gif" border="0"></a>
											 </td>
											 <td class="tdMedium" align="center">
											 	<a href="Javascript:solicitaSADT()"  title="Solicitação de Exames"><img src="images/25.gif" border="0"></a>
											 </td>
											 <td class="tdMedium" align="center">
											 	<a href="Javascript:responderProtocolo()"  title="Responder Protocolo"><img src="images/26.gif" border="0"></a>
											 </td>
											 <td class="tdMedium" align="center">
											 	<a href="Javascript:abreAlertas()" id="btnalerta" title="Alertas do Paciente">
													<% 
														if(alerta.equals("0")) { %>
														<img src="images/alertas.gif" border="0">
													<%} else { %>
														<img alt="<%= alerta%> alertas" src="images/alertapisc.gif" border="0">
													<%}%>
												</a>
											 </td>
											 <td class="tdMedium" align="center">
												<spam id="btnimagem"><a href="Javascript:mostraImagens()" title="Imagens do Paciente"><img src="images/palette.gif" border="0"></a></spam>
											 </td>
											 <td class="tdMedium" align="center">
												<a href="Javascript:mostrarLembretes()" title="Lembretes"><img src="images/postit.gif" border="0"></a>
											 </td>
											 <td class="tdMedium" align="center">
												 <a title="Prancheta" href="Javascript:abreprancheta()"><img src="images/prancheta.gif" border="0"></a>
											 </td>
											 <td class="tdMedium" align="center">
												 <a title="Guias do TISS" href="Javascript:abrirguia()"><img src="images/tiss.jpg" border="0"></a>
											 </td>
										</tr>
									</table>
								</td>
                            </tr>
                            <tr>
                                <td class="tdMedium">Profissional:</td>
								<td colspan="3">
									<table cellpadding="0" cellspacing="0" width="100%">
										<tr>
											<td class="tdLight">
												<input type="hidden" name="prof_reg" id="prof_reg" value="<%= historia[3] %>">
												<% if(Util.isNull(historia[2]) || historia[7].equals("S")) { %>			
													<input style="width:250" class="caixa" type="text" name="profissional.nome" id="profissional.nome" value="<%= historia[2] %>" onKeyUp="busca(this.value, 'prof_reg', 'profissional.nome','profissional')">
												<% } else { %>	
													<input type="hidden" name="profissional.nome" id="profissional.nome">
													<%= historia[2] %>
												<% } %>
											</td>
											<td class="tdLight" nowrap>
												Tipo: <select name="tipohistoria" id="tipohistoria" style="width:100px" class="caixa">
                                                	<option value="-1">Padrão</option>
                                                    <%= historico.getTiposHistoria(cod_empresa)%>
                                                </select><br>
												Definitivo: <img src="images/cadeado.gif"> <input type="checkbox" name="definitivo" id="definitivo" value="S" onClick="verificaResumo(this)">
											</td>
											<td class="tdMedium">Modelo</td>
											<td class="tdLight" nowrap>
												<select name="modelohistoria" id="modelohistoria" class="caixa" style="width:120px">
													<option value=""></option>
													<%= modelo.getModelos("P", cod_empresa)%>
												</select>
												<a href="Javascript:carregamodelo()" title="Carregar Modelo"><img src="images/copy.gif" border="0"></a>
											</td>
										</tr>
									</table>
								</td>
                            </tr>
                            <tr>
                                <td colspan="4" width="100%">
                                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td class="tdMedium">Diagnósticos:</td>
                                            <td class="tdMedium">Procedimentos:</td>
                                            <td class="tdMedium">Medicamentos:</td>
                                        </tr>
                                       <tr>
                                            <td class="tdLight">
												<input type="hidden" name="cod_diag" id="cod_diag">			
												<input style="width:100%" class="caixa" type="text" name="DESCRICAO" id="DESCRICAO" onKeyUp="buscadiagnosticos(this.value, '')">
                                            </td>
                                            <td class="tdLight">
												<input type="hidden" name="COD_PROCED" id="COD_PROCED">			
												<input style="width:100%" class="caixa" type="text" name="Procedimento" id="Procedimento" onKeyUp="buscaprocedimentos(this.value)">
                                             </td>
                                            <td class="tdLight">
 												<input type="hidden" name="cod_comercial" id="cod_comercial">			
												<input style="width:100%" class="caixa" type="text" name="comercial" id="comercial" onKeyUp="busca(this.value, 'cod_comercial', 'comercial','medicamentos')">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="tdLight">
                                                <table cellpadding="0" cellspacing="0" width="100%" border="0">
                                                    <tr>
                                                        <td>
                                                            <select name="lstdiagnostico" id="lstdiagnostico" class="caixa" multiple style="height:50px; width:210px">
                                                                <%= historico.getDiagnosticosHist(strcod, codcli) %>
                                                            </select>
                                                        </td>
                                                        <td>
                                                            <a href="Javascript:removeItem('diagnostico')" title="Excluir Diagnóstico"><img src="images/delete.gif" border="0"></a>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td class="tdLight">
                                                <table cellpadding="0" cellspacing="0" width="100%" border="0">
                                                    <tr>
                                                        <td>
                                                            <select name="lstprocedimento" id="lstprocedimento" class="caixa" multiple style="height:50px; width:210px">
                                                                <%= historico.getProcedimentosHist(strcod) %>
                                                            </select>
                                                        </td>
                                                        <td>
                                                            <a href="Javascript:removeItem('procedimento')" title="Excluir Procedimento"><img src="images/delete.gif" border="0"></a><br>
															<a href="Javascript:imprimir('procedimentos')" title="Imprimir Solicitação de Procedimentos"><img src="images/print.gif" border="0"></a>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td  class="tdLight">
                                                <table cellpadding="0" cellspacing="0" width="100%" border="0">
                                                    <tr>
                                                        <td>
                                                            <select name="lstmedicamento" id="lstmedicamento" class="caixa" multiple style="height:50px; width:210px">
                                                                <%= historico.getMedicamentosHist(strcod, codcli) %>
                                                            </select>
															<span style="display:'none'">
																<select name="lstindicacao" id="lstindicacao" multiple style="display: none">
																	<%= historico.getIndicacoesMedicamentos( strcod, codcli) %>
																</select>
															</span>
															
                                                         </td>
                                                        <td>
                                                            <a href="Javascript:removeItem('medicamento')" title="Excluir Medicamento"><img src="images/delete.gif" border="0"></a><br>
															<a href="Javascript:imprimir('receita')" title="Imprimir Receita"><img src="images/print.gif" border="0"></a>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="4" class="tdLight" valign="top" style="background-color:white">
                                    <input type="hidden" name="historiahid" id="historiahid" value=''>
	                                   
										<% 
											if( historia[7].equals("S")) { 
												out.println(historia[6]);
											} else { 
												out.println("<script>");
												out.println("initRTE('" + historia[6] + "', 'css/example.css');");
												out.println("</script>");
											}
										%>
                                    
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr align="center" valign="top">
                    <td width="100%">
                        <table width="100%" border="0" cellpadding="0" cellspacing="0" class="table">
                            <tr>
                                <td class="tdMedium" style="text-align:center"><button name="salvar" id="salvar" type="button" value="Salvar" class="botao" style="width:120px" onClick="salvarhistoria(1)"><img src="images/gravamini.gif">  Salvar</button></td>
                                <td class="tdMedium" style="text-align:center"><button name="salvarfechar" id="salvarfechar" type="button" value="Salvar" class="botao" style="width:120px" onClick="salvarhistoria(2)"><img src="images/14.gif">  Salvar e Fechar</button></td>
                                <td class="tdMedium" style="text-align:center"><button name="exclui" id="exclui" type="button" value="Excluir" class="botao" style="width:120px" onClick="enviarAcao('exc')"><img src="images/delete.gif" height="15">  Excluir</button></td>
                                <td class="tdMedium" style="text-align:center"><button name="fechar" id="fechar" type="button" value="Fechar" class="botao" style="width:120px" onClick="sair()"><img src="images/excluir.gif">  Fechar</button></td>					
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
			</center>
			
			<!-- Observação do Medicamento -->
			<iframe id="iframemedicamento" style="position:absolute; top: 100; left: 400; display: none; width: 300px; height:90px; border: 0px"></iframe>
			<div id="divmedicamento" style="position:absolute; top: 100; left: 400; display: none; width: 300px; height:90px">
				<table cellpadding="0" cellspacing="0" class="table" width="100%">
					<tr>
						<td class="tdDark" align="center">..: Posologia ::.</td>
					</tr>
					<tr>
						<td class="tdLight">
							<textarea name="indicacao" id="indicacao" class="caixa" rows="3" style="width:100%"></textarea>
						</td>
					</tr>
					<tr>
						<td class="tdMedium" align="center">
							<input type="button" class="botao" value="  Salvar  " onClick="insereIndicacao()">&nbsp;&nbsp;&nbsp;
							<input type="button" class="botao" value="  Fechar  " onClick="removeItemIndicacao()">
						</td>
					</tr>
				</table>
			</div>
			<!-- Observação do Medicamento -->
        </form>
    </body>

<!-- IFRAME PARA SALVAR A HISTÓRIA -->
<iframe id="iframehistoria" name="iframehistoria" width="0" height="0"></iframe>
<!-- IFRAME PARA SALVAR A HISTÓRIA -->

</html>
