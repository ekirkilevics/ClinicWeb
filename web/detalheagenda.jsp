<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.Agenda" id="agenda" scope="page"/>

<%
	//Mês a data do calendàrio a exibir
	int dia    = request.getParameter("dia") != null ? Integer.parseInt(request.getParameter("dia")) : 0;
	int mes    = request.getParameter("mes") != null ? Integer.parseInt(request.getParameter("mes")) : 0;
	int ano    = request.getParameter("ano") != null ? Integer.parseInt(request.getParameter("ano")) : 0;
	int cod    = request.getParameter("cod_proced") != null ? Integer.parseInt(request.getParameter("cod_proced")) : 0;

	//Sessão do reagendamento
	String reagendar = (String)session.getAttribute("reagendar");
	
	//Calcula data anterior e posterior
	int depois[] = agenda.navegaData(dia, mes, ano, 1);
	int antes[] = agenda.navegaData(dia, mes, ano, -1);

	//Captura o cód. do convênio e cód. do plano
	String codigo = !Util.isNull(request.getParameter("cod_plano")) ? request.getParameter("cod_plano") : "-1#-1";
	String cod_convenio = "";
	String cod_plano = "";
	try {
		cod_convenio = codigo.split("@")[0];
		cod_plano = codigo.split("@")[1];
	}
	catch(Exception e) { }
	
	//Se é reagendamento, pegar o convênio, plano e o procedimento da agenda
	if(!Util.isNull(reagendar)) {
		cod_convenio = banco.getValor("cod_convenio", "SELECT cod_convenio FROM agendamento WHERE agendamento_id=" + reagendar);
		cod_plano = banco.getValor("cod_plano", "SELECT cod_plano FROM agendamento WHERE agendamento_id=" + reagendar);
		cod = Integer.parseInt(banco.getValor("cod_proced", "SELECT cod_proced FROM agendamento WHERE agendamento_id=" + reagendar));
	}
	
	String nomeconvenio = "";
	String prof_reg = request.getParameter("prof_reg") != null ? request.getParameter("prof_reg") : "";

	//Pode vir sem paciente se quer apenas olhar a agenda
	int codcli;
	String dddcelular="", celular="";
	try { 
		
		//se tiver gente para reagendar, pegar da sessão 
		if(!Util.isNull(reagendar)) {
			codcli = Integer.parseInt(banco.getValor("codcli", "SELECT codcli FROM agendamento WHERE agendamento_id=" + reagendar));
		}
		else {
			codcli = Integer.parseInt(request.getParameter("codcli")); 
		}
		
		//Captura celular do paciente
		dddcelular = banco.getValor("paciente", "ddd_celular", cod_empresa, " AND codcli=" + codcli);
		celular    = banco.getValor("paciente", "tel_celular", cod_empresa, " AND codcli=" + codcli);
	}
	catch(Exception e) { codcli = -1; }
		
	String data = agenda.toString(dia, mes, ano);

	//Pega nome do procedimento
	rs = banco.getRegistro("grupoprocedimento","cod_grupoproced", cod );
	String procedimento = banco.getCampo("grupoproced", rs);

	String paciente = "";
	String dias_retorno = "";
	String consultas[] = null;
	String dataconsulta = "";
	String dataconsultafutura = "";

	//Se escolheu o paciente, buscar dados
	if(codcli > -1) {
		//Pega dados do paciente		
		rs = banco.getRegistro("paciente","codcli", codcli );
		paciente = banco.getCampo("nome", rs);

		//Pega os dados do convênio do paciente
		try {
			String conv[] = agenda.getDadosConvenio(cod_convenio);
			dias_retorno = conv[1];
			nomeconvenio = conv[0];
						
			//Recupera o último atendimento para o paciente e para o mesmo procedimento
			consultas = agenda.pegaConsultas( String.valueOf(codcli), data, String.valueOf(cod) );
			dataconsulta = consultas[0];
			dataconsultafutura = consultas[1];
		}
		catch(Exception e) {
			nomeconvenio = "Convênio não cadastrado";
			dias_retorno = "0";
			dataconsulta = "";
			dataconsultafutura = "";
		}
	}

	//Captura os parâmetros
	String query = request.getQueryString();
	String anterior = "", posterior = "";
	anterior = query.replace("dia=" + dia, "dia=" + antes[0]);
	anterior = anterior.replace("mes=" + mes, "mes=" + antes[1]);
	anterior = anterior.replace("ano=" + ano, "ano=" + antes[2]);
	posterior = query.replace("dia=" + dia, "dia=" + depois[0]);
	posterior = posterior.replace("mes=" + mes, "mes=" + depois[1]);
	posterior = posterior.replace("ano=" + ano, "ano=" + depois[2]);

	//Se veio das tela de próximas agendas
	String prox = !Util.isNull(request.getParameter("prox")) ? request.getParameter("prox") : "";

	//Tira o prox para não reagendar quando veio das próximas agenas
	int iprox = query.indexOf("&prox=");
	if(iprox > -1) query = query.substring(0, iprox);
	
%>

<html>
<head>
<title>..: Agendamento :..</title>
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
<script language="JavaScript" src="js/tootip.js"></script>
<script language="JavaScript">
	
	//Informação vinda de gravar
    var inf = "<%= inf%>";
	var jsprocedimento = "<%= procedimento%>";
	var jspaciente = "<%= paciente%>";
	var jsdata = "<%= data%>";
	var jshoje = "<%= Util.getData()%>";
	var jsdataconsulta = "<%= dataconsulta%>";
	var jsdatafutura = "<%= dataconsultafutura%>";
	var oldmedico = "";
	var prof_reg = "<%= prof_reg%>";
	var jsdias_retorno = parseInt("<%= dias_retorno%>");
	var horasenviosms = parseInt("<%= configuracao.getItemConfig("horasenviosms", cod_empresa)%>");
	var jsdddcelular = "<%= dddcelular%>";
	var jscelular = "<%= celular%>";
	var jsprox = "<%= prox%>";
	var autoriza_sms = "<%= (String)session.getAttribute("sms")%>";
	var jsreagendar = "<%= reagendar%>";
	var diaagenda = "<%= dia%>";
	var mes = "<%= mes%>";
	var ano = "<%= ano%>";

	function escolheProfissional(prof_reg)
	{
		//Se já havia escolhido um médico, esconder novamente
		if(oldmedico != "") {
			try {
				cbeGetElementById("medico" + oldmedico).style.display = 'none';
				cbeGetElementById("cabecalho" + oldmedico).style.backgroundColor = '<%= tdmedium%>';
			}
			catch(e) { }
		}
		
		//Exibir a agenda no médico escolhido
		try {
			cbeGetElementById("medico" + prof_reg).style.display = 'block';
			cbeGetElementById("cabecalho" + prof_reg).style.backgroundColor ='#FF9900';
		}
		catch(e) { }

		//Depois que exibiu, alterar o old médico para esconder na próxima escolha
		oldmedico = prof_reg;
	}	
	
	function bloquearagenda(prof_reg, hora) 
	{
		var jsdata = "<%= data%>";
		
		conf = confirm("Confirma bloqueio de horário para às " + hora + "?");
		if(conf) {
			var frm = cbeGetElementById("frmcadastrar");
			frm.action = "bloquearagenda.jsp?<%= query%>&prof_reg=" + prof_reg + "&data=" + jsdata + "&hora=" + hora;
			frm.submit();
		}
	}
	
	function desbloquearagenda(cod_bloqueio)
	{
		conf = confirm("Confirma desbloqueio do horário?");
		if(conf) {
			var frm = cbeGetElementById("frmcadastrar");
			frm.action = "bloquearagenda.jsp?<%= query%>&cod_bloqueio=" + cod_bloqueio;
			frm.submit();
		}
	}
	
	function agendar(prof_reg, hora)
	{
		var jsretorno = "N";
		var jsencaixe = cbeGetElementById("encaixe").value;

		//Se não tem permissão de incluir, bloquear
		if(incluir == "0" || alterar == "0") {
			alert("Usuário sem permissão para incluir agenda");
			return;
		}
		
		var h = hora.substring(0,2);
		var m = hora.substring(3);
		
		datahoje = new Date();
		dataagenda = new Date(ano, mes-1, diaagenda, h, m, 0);

		//Só verifica a hora se não for encaixe
		if(jsencaixe == "N") {
			//Não agendar em data/hora que já passou
			if(dataagenda.getTime() < datahoje.getTime()) {
				alert("Impossível realizar agendamento antes da data/hora atual");
				return;
			}
		}
		
		//Se não escolheu paciente ainda, dar mensagem
		if(jspaciente=="" && jsreagendar == "null") {
			alert("Você deve selecionar o paciente na Agenda do Paciente para marcar uma consulta.\nEssa janela será fechada para que possa escolher o paciente.")
			self.close();
			return;			
		}

		//Se a data do agendamento
		if(difDatas(jsdata,jsdataconsulta) < jsdias_retorno) {
			conf2 = confirm("Já existe uma agenda a menos de " + jsdias_retorno + " dias no dia " + jsdataconsulta + ".\nConfirma retorno de consulta antes do prazo do convênio?")			
			if(!conf2) return;
			else jsretorno = "S";
		}
		if(jsdatafutura != "") {
			conf3 = confirm("Já existe um agendamento para o paciente " + jspaciente + " em " + jsdatafutura + "\nConfirma a agenda mesmo assim?");
			if(!conf3) return;				
		}

		//Coloca informação se é retorno
		cbeGetElementById("retorno").value = jsretorno;
		
		//Exibir a caixa de agendamento
		jsdivsms = cbeGetElementById("divsms");
		jsdivsms.style.display = 'block';
		posicionacaixa();
		
		//Coloca a data e hora da agenda para confirmação
		cbeGetElementById("horaconsulta").innerHTML = hora;

		//Calcula a data e hora de envio do SMS
		dataagenda = new Date(ano, mes-1, diaagenda, h, m, 0);
		datasms = new Date();
		datasms = dataagenda;
		datasms.setHours(dataagenda.getHours() - horasenviosms);
		
		//Sugere a data e hora do envio do SMS
		cbeGetElementById("dataenviosms").value = formataData(datasms);
		cbeGetElementById("horaenviosms").value = formataHora(datasms);

		//Preenche os campos ocultos para o envio
		cbeGetElementById("prof_reg").value = prof_reg;
		cbeGetElementById("hora").value = hora;
	}
	
	function excluiragenda(id, prof_reg)
	{
		//Se usuário não tem permissão de excluir agenda
		if(excluir == "0") {
			alert("Usuário sem permissão para exclusão de agenda");
			return;
		}

		jsdddcelular = cbeGetElementById("dddcelular").value;
		jscelular = cbeGetElementById("celular").value;

		conf = confirm("Confirma exclusão de agendamento?")
		if(conf) {
			//Coloca como default, não enviar SMS
			cbeGetElementById("smsnao").checked = true;
		
			//Se paciente tiver dados de celular, perguntar se quer enviar SMS
		    if(jsdddcelular != "" && jscelular != "") {
				if(autoriza_sms == "S") {
					//Confirme envio de SMS para o paciente
					conf4 = confirm("Enviar SMS para avisar o paciente?")
					if(conf4) cbeGetElementById("smssim").checked = true;
				}
			}

			cbeGetElementById("frmcadastrar").target = "_self";
			cbeGetElementById("frmcadastrar").action = "gravaragenda.jsp?id=" + id + "&prof_reg=" + prof_reg;
			cbeGetElementById("frmcadastrar").submit();
		}
	}	
	
	function iniciar() {
		var jsprof_reg_unico = cbeGetElementById("prof_reg_unico");

		//Se já escolheu antes, manter aberto
		if(prof_reg!="")
			escolheProfissional(prof_reg);
		else {
			//Se só existe um médico, abrir ele
			if(jsprof_reg_unico.value != "" && jsprof_reg_unico != "undefined") {
				escolheProfissional(jsprof_reg_unico.value);
			}
	
		}
		//Se paciente não tem celular cadastrado, deixar como default não enviar
		if(jsdddcelular == "" || jscelular == "" || autoriza_sms == "N") {
			cbeGetElementById("smsnao").checked = true;
			cbeGetElementById("dataenviosms").disabled = true;
			cbeGetElementById("horaenviosms").disabled = true;
		}
		
		if(inf == "intervalo") {
			alert("Agenda não pode ser desbloqueada porque pertence a um intervalo");
		}
		else mensagem(inf,0);	

		//Se veio prox, veio da tela de próximas agendas
		if(jsprox != "") {
			agendar(prof_reg, jsprox);
		}
	}
	
	function alteraStatus(id) {
		
		//Se não tem permissão de alterar
		if(alterar == "0") {
			alert("Usuário sem permissão para alterar agenda");
			return;	
		}
	
		//Captura o formulário para submeter
		var frm = cbeGetElementById("frmcadastrar");
		//Captura a imagem para alternar
		var img = cbeGetElementById("img" + id);
		//Verifica a cor da imagem atual para trocar
		var status = img.src.substring(img.src.length-5, img.src.length-4);

		//Se o status estiver como atendido, não pode mudar
		if(status==9) {
			alert("Paciente já atendido\nStatus não pode ser alterado");
			return;
		}
		
		//Troca o destino para submeter no iframe e envia
		frm.target = "framestatus";
		frm.action = "atualizastatus.jsp?status=" + status + "&codag=" + id;
		frm.submit();
	}
	
	//Altera image do status
	function alteraImagemStatus(st, id) {
		//Captura a imagem para alternar
		var img = cbeGetElementById("img" + id);
		//Alterar a imagem do status
		img.src = "images/" + st + ".gif";
	}
	
	function irCadastro(codcli)
	{
		pai = window.opener;
		pai.location = "pacientes.jsp?cod=" + codcli;
	}
	
	function lancarProcedimento(data, hora, grupoproced, nomepaciente, codcli, executante, cod_convenio, cod_plano, cod_agenda)
	{
		//Captura a imagem de status
		var img 		= cbeGetElementById("img" + cod_agenda);
		var imgmoeda 	= cbeGetElementById("moeda" + cod_agenda);

		//Verifica a cor da imagem atual para trocar
		var status = img.src.substring(img.src.length-5, img.src.length-4);

		//Se o status estiver como atendido, não pode mudar
		if(status==3) {
			alert("Altere o status da agenda do paciente para fazer o Lançamento de Atendimento");
			return;
		}

		//Troca o ícone do cifrão
		imgmoeda.src = "images/moeda2.gif";
		
		//Abre janela para escolher procedimento
		displayPopup("escolheprocedimento.jsp?data=" + data + "&hora=" + hora + "&grupoproced=" + grupoproced + "&nome=" + nomepaciente + "&codcli=" + codcli + "&executante=" + executante + "&cod_convenio=" + cod_convenio + "&cod_plano=" + cod_plano,'popproced',300,500);
	}
	
	function verObs(cod_agenda, codcli) {
		if(pesquisar == 0) {
			alert("Usuário sem permissão para pesquisar");
			return;
		}
		displayPopup("obs.jsp?cod=" + cod_agenda + "&codcli=" + codcli,'popobs',130,300);	
	}
	
	function cancelar() {
		jsdivsms = cbeGetElementById("divsms");
		jsdivsms.style.display = 'none';
		cbeGetElementById("encaixe").value = "N";
	}
	
	function bloquear(obj) {
		var jsdata = cbeGetElementById("dataenviosms");
		var jshora = cbeGetElementById("horaenviosms");

		jsdddcelular = cbeGetElementById("dddcelular").value;
		jscelular = cbeGetElementById("celular").value;
		
		//Se clicou para enviar SMS
		if(obj.value == "S") {
			//Se não tiver permissão para envio de SMS
			if(autoriza_sms == "N") {
				alert("Cliente com SMS desabilitado!");
				cbeGetElementById("smsnao").checked = true;
				return;
			}

			//Se paciente não tiver dados de celular, emitir aviso
			if(jsdddcelular == "" || jscelular == "") {
				alert("Preencha o celular do paciente para o envio do SMS.");
				cbeGetElementById("smsnao").checked = true;
				return;
			}
			else {
				jsdata.disabled = false;
				jshora.disabled = false;
			}
		}
		else {
			jsdata.disabled = true;
			jshora.disabled = true;
		}
	}
	
	function enviarfrm() {
		var frm = cbeGetElementById("frmcadastrar");
		frm.submit();
	}
	
	function posicionacaixa() {
		var top = document.body.scrollTop + 250;
		jsdivsms = cbeGetElementById("divsms");
		jsdivsms.style.top = top;
	}
	
	function insereencaixe(prof_reg, nome) {
		
		displayPopup("encaixe.jsp?prof_reg=" + prof_reg + "&nome=" + nome + "&data=" + jsdata + "&paciente=" + jspaciente, "encaixe", 200, 400);
		
	}
	
	function navegaagenda(tipo) {
		//Verifica se é próximo
		var jsanterior = "<%= anterior%>";
		var jsposterior = "<%= posterior%>";
		
		if(tipo == 1) {
			if(jsposterior.indexOf("&prof_reg") > -1) {
				jsposterior = jsposterior.substring(0, jsposterior.indexOf("&prof_reg"));
			}
			window.location = "detalheagenda.jsp?" + jsposterior + "&prof_reg=" + oldmedico;
		}
		//Verifica se é anterior
		else {
			if(jsanterior.indexOf("&prof_reg") > -1) {
				jsanterior = jsanterior.substring(0, jsanterior.indexOf("&prof_reg"));
			}
			window.location = "detalheagenda.jsp?" + jsanterior + "&prof_reg=" + oldmedico;
		}
	}
	
	function reagendar(cod_agenda) {
		var frm = cbeGetElementById("frmcadastrar");
		frm.action = "inserirreagendamento.jsp?cod_agenda=" + cod_agenda;
		frm.target = "framestatus";
		alert("Agenda guardada na memória.\nSelecione a nova data para remarcação.\nEnquanto não escolher a data, a agenda não será apagada");
		frm.submit();
		frm.action = "detalheagenda.jsp?<%= query%>";
		frm.target = "_self";
		frm.submit();
	}
	
	function setarComoEncaixe() {
		cbeGetElementById("encaixe").value = "S";
	}

</script>
</head>

<body>
<form name="frmcadastrar" id="frmcadastrar" action="gravaragenda.jsp" method="post">
  <!-- Campos hidden para enviar os valores por POST -->
  <input type="hidden" name="codcli" id="codcli" value="<%= codcli %>">
  <input type="hidden" name="cod_proced" id="cod_proced" value="<%= cod %>">
  <input type="hidden" name="prof_reg" id="prof_reg">
  <input type="hidden" name="cod_plano" id="cod_plano" value="<%= cod_plano%>">
  <input type="hidden" name="cod_convenio" id="cod_convenio" value="<%= cod_convenio%>">
  <input type="hidden" name="data" id="data" value="<%= data%>">
  <input type="hidden" name="hora" id="hora">
  <input type="hidden" name="query" id="query" value="<%= query%>">
  <input type="hidden" name="retorno" id="retorno">
  <input type="hidden" name="encaixe" id="encaixe" value="N">
  
  <center>
  <table width="95%" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr>
      <td width="100%" class="title">.: <%= Util.getDiaSemana(dia, mes, ano) %> - <%= data  %>:.</td>
    </tr>
	<tr>
		<td align="center">
			<a href="Javascript:navegaagenda(-1)" title="Dia Anterior"><img src="images/setaabre.gif" border="0"></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<a href="Javascript:navegaagenda(1)" title="Dia Seguinte"><img src="images/setafecha.gif" border="0"></a> 
		</td>
	</tr>
	<tr style="height:25px">
		<td align="center"><span name='msg' id='msg' class="msg">&nbsp;</span></td>
	</tr>
<%
	if(!Util.isNull(paciente)) {
%>
	<tr>
		<td width="100%">
			<table width="100%" border="0" cellpadding="0" cellspacing="0" class="table">
				<tr>
					<td width="100" class="tdMedium">Procedimento: </td>
					<td colspan="3" class="tdLight"><%= procedimento %></td>
				</tr>
				<tr>
					<td class="tdMedium">Paciente: </td>
					<td colspan="3" class="tdLight"><%= paciente %></td>
				</tr>
				<tr>
					<td class="tdMedium">Convênio: </td>
					<td class="tdLight"><%= nomeconvenio %></td>
					<td class="tdMedium">Retorno de Consulta:</td>
					<td class="tdLight">&nbsp;<%= dias_retorno%>&nbsp;dias</td>
				</tr>
				<tr>
					<td class="tdMedium">Data Última Consulta:</td>
					<td colspan="3" class="tdLight"><%= dataconsulta%>&nbsp;</td>
				</tr>
			</table>
		</td>
	</tr>
<%
	}
%>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td class="texto">
			<table cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td class="texto">
						<img src="images/3.gif">Paciente não chegou<br>
						<img src="images/1.gif">Paciente aguarda atendimento<br>
						<img src="images/9.gif">Paciente já foi atendido
					</td>
					<td class="texto">
						<b>Negrito</b>: encaixe<br>
						<span style="background-color:#FFFF99">Fundo Amarelo</span>: retorno de consulta<br>
                        <span style="background-color:#CEFFCE">Fundo Verde</span>: paciente de primeira vez<br>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td>
		    <%= agenda.montaAgendaPaciente(dia, mes, ano, codcli+"", cod,  cod_empresa)%>
		</td>
	</tr>
  </table>
  <br>
  </center>

	<iframe name="framestatus" id="framestatus" src="#" width="0" height="0">
	</iframe>
	
<!-- Caixa para confirmação de envio de SMS -->
<div id="divsms" style="position: absolute; top:300; left:100; width: 300; height: 200; display:none; background-color:#<%= tdlight%>">
	<table border="0" cellpadding="0" cellspacing="0" class="table" width="100%">
		<tr>
			<td colspan="2" class="tdDark" align="center"><strong>Confirmação</strong></td>
		</tr>
		<tr>
			<td class="tdMedium">Data da Consulta:</td>
			<td class="tdLight"><%= data%></td>
		</tr>
		<tr>
			<td class="tdMedium">Hora da Consulta:</td>
			<td class="tdLight"><div id="horaconsulta"></div></td>
		</tr>
		<tr>
	       <td height="23" colspan="2" align="center" class="tdDark"><strong>Enviar SMS</strong></td>
		</tr>
		<tr>
			<td class="tdMedium">Data:</td>
			<td class="tdLight"><input name="dataenviosms" id="dataenviosms" type="text" class="caixa" size="10" maxlength="10" onKeyPress="return formatar(this, event, '##/##/####'); " onBlur="ValidaData(this);"></td>
		</tr>
		<tr>
			<td class="tdMedium">Hora:</td>
			<td class="tdLight"><input name="horaenviosms" id="horaenviosms" type="text" class="caixa" size="10" maxlength="5" onKeyPress="formatar(this, event, '##:##'); "></td>
		</tr>
		<tr>
			<td class="tdMedium">Celular:</td>
			<td class="tdLight">
				<input name="dddcelular" id="dddcelular" type="text" class="caixa" size="2" maxlength="2" onKeyPress="OnlyNumbers(this,event);" value="<%= dddcelular%>">&nbsp;
				<input name="celular" id="celular" type="text" class="caixa" size="8" maxlength="8" onKeyPress="OnlyNumbers(this,event);" value="<%= celular%>">
			</td>
		</tr>
		<tr>
			<td class="tdMedium"><input type="radio" name="sms" id="smssim" value="S" checked onClick="bloquear(this)">Enviar</td>
			<td class="tdMedium"><input type="radio" name="sms" id="smsnao" value="N" onClick="bloquear(this)">Não Enviar</td>
		</tr>
		<tr>
			<td class="tdDark" align="center"><input type="button" class="botao" value="Confirmar" onClick="enviarfrm()"></td>
			<td class="tdDark" align="center"><input type="button" class="botao" value="Cancelar" onClick="cancelar()"></td>
		</tr>
	</table>
</div>

<!-- Caixa para confirmação de envio de SMS -->

</form>

<script language="JavaScript">
	iniciar();
</script>

</body>
</html>