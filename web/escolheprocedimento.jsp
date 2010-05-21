<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.Agenda" id="agenda" scope="page"/>
<jsp:useBean class="recursos.Paciente" id="paciente" scope="page"/>
<%
	//Guarda os parâmetros originais para reenviar
	String querystring = request.getQueryString();
	String acao = request.getParameter("acao");

	String cod_plano = !Util.isNull(request.getParameter("cod_plano")) ? request.getParameter("cod_plano") : "-1";
	String cod_convenio = request.getParameter("cod_convenio");
	String cod_proced = request.getParameter("grupoproced");
	String codcli = request.getParameter("codcli");
	
	//Se clicou no botão atualizar plano, gravar com o novo cód. plano
	if(acao!=null && acao.equals("gravar")) {
		
		//Atualiza cadastro do paciente
		String sql = "UPDATE paciente_convenio SET cod_plano=" + cod_plano + ",num_associado_convenio='" + request.getParameter("num_associado_convenio");
		sql += "',validade_carteira='" + Util.formataDataInvertida(request.getParameter("validade_carteira")) + "' WHERE cod_convenio=" + cod_convenio;
		sql += " AND codcli=" + codcli;
		banco.executaSQL(sql);
		
		//Atualiza o agendamento
		sql  = "UPDATE agendamento SET cod_plano=" + cod_plano + " WHERE codcli=" + codcli + " AND data='";
		sql += Util.formataDataInvertida(request.getParameter("data")) + "' AND hora='";
		sql += Util.formataHora(request.getParameter("hora")) + "' AND ativo='S'";
		banco.executaSQL(sql);
		
	}
	
%>
<html>
<head>
<title>Escolhe Procedimento</title>
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
<script language="JavaScript">
	var qs = "<%= querystring %>";
	
	function escolheProcedimento(cod_proced, procedimento, valor) {
		var mainframe=window.opener.opener;
		var destino = "faturamentos.jsp?" + qs + "&procedimento=" + cod_proced + "&valor=" + valor;
		mainframe.location = destino;
		self.close();
	}
	
	function gravarplano() {
		var frm = cbeGetElementById("frmcadastrar");
		var jsplano = cbeGetElementById("cod_plano");
		if(jsplano.value == "-1" || jsplano.value == "") {
			alert("Selecione o plano para fazer o lançamento financeiro");
			return;
		}
		if(jsplano.value != "-2" && frm.validade_carteira.value == "") {
			alert("Preencha a validade da carteira do paciente");
			return;
		}
		//Tira o plano antigo ou o null
		qs = qs.replace("cod_plano=<%= cod_plano%>","cod_plano=" + jsplano.value);
		qs = qs.replace("cod_plano=null","cod_plano=" + jsplano.value);

		frm.action = "escolheprocedimento.jsp?acao=gravar&" + qs;
		frm.submit();
	}
	
	function iniciar() {
		var jsacao = "<%= acao%>";
		if(jsacao == "null")
			cbeGetElementById("cod_plano").value = "<%= cod_plano%>";
	}
</script>
</head>

<body onLoad="iniciar()">
	<form name="frmcadastrar" id="frmcadastrar" action="escolheprocedimento.jsp" method="post">
		<% if(Util.isNull(acao)) {%>
			<table cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td class="tdMedium">Convênio</td>
					<td class="tdLight"><%= banco.getValor("convenio", "descr_convenio", cod_empresa, "AND cod_convenio=" + cod_convenio) %></td>
					<td class="tdMedium">Plano</td>
					<td class="tdLight">
							<%= paciente.getPlanos(cod_convenio)%>
					</td>
				</tr>
				<tr>
					<td class="tdMedium">Núm. Associado</td>
					<td class="tdLight">
						<input name="num_associado_convenio" type="text" class="caixa" id="num_associado_convenio" size="10" maxlength="25" value="<%= banco.getValor("num_associado_convenio", "SELECT * FROM paciente_convenio WHERE codcli=" + codcli + " AND cod_convenio=" + cod_convenio) %>">
			  		</td>					
					<td class="tdMedium">Validade da Carteira</td>
					<td class="tdLight">
						<input name="validade_carteira" type="text" class="caixa" id="validade_carteira" size="10" maxlength="10" onKeyPress="formatar(this, event, '##/##/####'); " value="<%= Util.formataData(banco.getValor("validade_carteira", "SELECT * FROM paciente_convenio WHERE codcli=" + codcli + " AND cod_convenio=" + cod_convenio)) %>">
					</td>
				</tr>
				<tr>	
			      <td colspan="4" class="tdLight" align="center"><button name="button" type="button" class="botao" style="width:200px" onClick="gravarplano()"><img src="images/gravamini.gif">&nbsp;&nbsp;Salvar</button></td>
				</tr>
			</table>
		<% } else { %>

			<center><div class="tdMedium">Escolha um procedimento do Grupo</div></center>
			<%= agenda.getProcedimentos(cod_plano, cod_proced) %>
		
		<% } %>
	</form>
</body>
</html>
