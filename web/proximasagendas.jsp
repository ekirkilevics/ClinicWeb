<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.Agenda" id="agenda" scope="page"/>
<jsp:useBean class="recursos.AgendadoMedico" id="agendadomedico" scope="page"/>
<jsp:useBean class="recursos.AgendaMedico" id="agendamedico" scope="page"/>

<%!
	public String getItem(String  periodo, String abriu) {
		//Se veio nulo, retornar vazio
		if(periodo == null) 
			if(abriu == null) return "";
			else return "checked";
		
		//Verificar se o índice existe
		if(periodo.equals("OK")) return "checked";
		return "";
	}
	
	public String verificaCheck(String item, String vetor[]) {
		if(vetor == null) return "checked";

		if(new Banco().pertence(item, vetor))
			return "checked";
		else
			return "";
	}
%>

<%
	String codcli = request.getParameter("codcli");
	String cod_proced = request.getParameter("cod_proced");
	String cod_plano = !Util.isNull(request.getParameter("cod_plano")) ? request.getParameter("cod_plano") : "-1#-1";
	String paciente = "";
	String semanas[] = request.getParameterValues("semana");
	String abriu = request.getParameter("abriu");
	
	//Pega a data depois do retorno
	String datas[] = agenda.proxData(codcli, cod_proced, cod_plano);

	//Se escolheu o paciente
	if(!Util.isNull(codcli)) {
		//Pega dados do paciente		
		rs = banco.getRegistro("paciente","codcli", Integer.parseInt(codcli) );
		paciente = banco.getCampo("nome", rs);
	}
	
	//Formulários
	String botao = request.getParameter("botao");
	String profissional = !Util.isNull(request.getParameter("profissional")) ? request.getParameter("profissional") : "todos";
	String manha = request.getParameter("manha");
	String tarde = request.getParameter("tarde");
	String data = Util.isNull(request.getParameter("data")) ? datas[1] : request.getParameter("data");

%>
<html>
<head>
<title>..: Próximas Agendas :..</title>
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
<script language="Javascript">
	var oldmedico = "";
	var codcli = "<%= codcli%>";
	var cod_proced = "<%= cod_proced%>";
	var cod_plano = "<%= cod_plano%>";
	var jsprofissional = "<%= profissional%>";

	function iniciar() {
		cbeGetElementById("cod_proced").value = "<%= cod_proced%>";
		cbeGetElementById("profissional").value = "<%= profissional%>";
		
		//Se escolheu algum profissioal, deixar aberto
		if(jsprofissional != "todos") {
			escolheProfissional(jsprofissional);
		}
	}	
	
	function buscaragendas() {
		var frm = cbeGetElementById("frmcadastrar");
		
		if(frm.manha.checked == false && frm.tarde.checked == false) {
			alert("Escolha o período para pesquisar agendas livres");
			return false;
		}
		
		return true;
	}
	
	function escolheProfissional(prof_reg)
	{
		//Se já havia escolhido um médico, esconder novamente
		if(oldmedico != "") {
			cbeGetElementById("medico" + oldmedico).style.display = 'none';
			cbeGetElementById("cabecalho" + oldmedico).style.backgroundColor = '<%= tdmedium%>';
		}
		
		//Exibir a agenda no médico escolhido
		try {
			cbeGetElementById("medico" + prof_reg).style.display = 'block';
			cbeGetElementById("cabecalho" + prof_reg).style.backgroundColor ='<%= tddark%>';
		}
		catch(e) { }

		//Depois que exibiu, alterar o old médico para esconder na próxima escolha
		oldmedico = prof_reg;
	}	
	
	function agendar(d, m, a, prof_reg, hora) {
		if(codcli == "") {
			alert("Selecione o paciente para realizar o agendamento.");
			self.close();
		}
		else {
			this.resizeTo(520,620);
			this.location = "detalheagenda.jsp?dia=" + d + "&mes=" + m + "&ano=" + a + "&codcli=" + codcli + "&cod_proced=" + cod_proced + "&cod_plano=" + cod_plano + "&prof_reg=" + prof_reg + "&prox=" + hora;
		}
	}
	
</script>

</head>

<body onLoad="iniciar()">
<form name="frmcadastrar" id="frmcadastrar" action="proximasagendas.jsp" method="post" onSubmit="return buscaragendas()">
<center>
<!-- Dados do formulário -->
<input type="hidden" name="codcli" value="<%= codcli%>">
<input type="hidden" name="cod_plano" value="<%= cod_plano%>">
<!-- Dados do formulário -->

<table border="0" cellpadding="0" cellspacing="0" width="95%">
    <tr>
      <td colspan="2" width="100%" height="18" class="title">.: Próximas Agendas :.</td>
    </tr>
	<tr>
		<td colspan="2">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="2" class="tdDark" align="center">..: Filtros :..</td>
	</tr>
	<tr>
		<td colspan="2" width="100%">
			<table border="0" cellpadding="0" cellspacing="0" class="table" width="100%">
				<tr>
					<td class="tdMedium">Data Inicial:</td>
					<td class="tdLight">
						<input type="text" class="caixa" name="data" id="data" value="<%= data%>" size="10" maxlength="10" onKeyPress="return formatar(this, event, '##/##/####'); " onBlur="ValidaData(this);">
						&nbsp;&nbsp;&nbsp;&nbsp; Última Consulta: <%= datas[0]%>
					</td>
				</tr>
				<tr>
					<td class="tdMedium">Profissional:</td>
					<td class="tdLight">
						<select name="profissional" id="profissional" class="caixa">
							<option value="todos"><-- Todos --></option>
							<%= agendadomedico.getProfissionais(cod_empresa)%>
						</select>
					</td>
				</tr>
				<tr>
					<td class="tdMedium">Período:</td>
					<td class="tdLight">
						<input type="checkbox" name="manha" id="manha" value="OK" <%= getItem(manha, abriu)%>> Manhã&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<input type="checkbox" name="tarde" id="tarde" value="OK" <%= getItem(tarde, abriu)%>> Tarde
					</td>
				</tr>
				<tr>
					<td class="tdMedium">Procedimento:</td>
					<td class="tdLight">
						<select name="cod_proced" id="cod_proced" class="caixa">
							<%= agendamedico.getProcedimentos(cod_empresa)%>
						</select>
					</td>
				</tr>
				<tr>
					<td class="tdMedium">Paciente:</td>
					<td class="tdLight"><% if(Util.isNull(paciente)) out.println("Não selecionado"); else out.println(paciente);%></td>
				</tr>
				<tr>
					<td colspan="2" class="tdMedium">Dias da Semana</td>
				</tr>
				<tr>
					<td class="tdLight" colspan="2">
						<table cellpadding="0" cellspacing="0" width="100%" border="0">
							<tr>
								<td class="texto"><input type="checkbox" name="semana" value="1" <%= verificaCheck("1", semanas) %>>Domingo</td>
								<td class="texto"><input type="checkbox" name="semana" value="2" <%= verificaCheck("2", semanas) %>>Segunda</td>
								<td class="texto"><input type="checkbox" name="semana" value="3" <%= verificaCheck("3", semanas) %>>Terça</td>
								<td class="texto"><input type="checkbox" name="semana" value="4" <%= verificaCheck("4", semanas) %>>Quarta</td>
							</tr>
							<tr>
								<td class="texto"><input type="checkbox" name="semana" value="5" <%= verificaCheck("5", semanas) %>>Quinta</td>
								<td class="texto"><input type="checkbox" name="semana" value="6" <%= verificaCheck("6", semanas) %>>Sexta</td>
								<td class="texto"><input type="checkbox" name="semana" value="7" <%= verificaCheck("7", semanas) %>>Sábado</td>
								<td>&nbsp;</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td colspan="2" class="tdMedium" align="right"><button type="submit" class="botao" name="botao" id="botao"><img src="images/busca.gif">&nbsp;&nbsp;&nbsp;&nbsp;Buscar</button></td>
				</tr>
			</table>
		</td>
</table>
<br>
<%
	if(botao != null) {
		out.println(agenda.getProximasAgendas(semanas, data, profissional, manha, tarde, cod_proced, cod_empresa));
	}
%>
</center>
</form>
</body>
</html>