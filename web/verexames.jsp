<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.Exame" id="exame" scope="page"/>

<%
	//Dados do paciente
	String codcli = request.getParameter("codcli");
	String nomepaciente = new Banco().getValor("nome", "SELECT nome FROM paciente WHERE codcli=" + codcli);

	//Exame selecionado
	String cod_exame = request.getParameter("cod_exame") !=null ? request.getParameter("cod_exame") : "";
	String unidade = "", nomeexame = "", paginaexame = "";
	if(!Util.isNull(cod_exame)) {
		unidade = banco.getValor("unidade", "SELECT unidade FROM exames WHERE cod_exame=" + cod_exame);
		nomeexame = banco.getValor("exame", "SELECT exame FROM exames WHERE cod_exame=" + cod_exame);
		paginaexame = banco.getValor("pagina", "SELECT pagina FROM exames WHERE cod_exame=" + cod_exame);
	}

	//Se tem página específica, redirecionar
	if(!Util.isNull(paginaexame)) response.sendRedirect(paginaexame + "?codcli=" + codcli);

	//Valores a gravar
	String valor = request.getParameter("valor");
	String data = request.getParameter("data");
	String obs = request.getParameter("obs");
	String ret = "";
	String qs = request.getQueryString();
	int posexc = qs.indexOf("&exc=");
	if(posexc > -1) qs = qs.substring(0,posexc);
	String exc = request.getParameter("exc");
	
	//Se selecionou o exame, gravar
	if(!Util.isNull(valor) && !Util.isNull(data)) {
		ret = exame.gravarExame(codcli, cod_exame, valor, data, obs);
	}
	
	//Se chegou cód. para excluir
	if(!Util.isNull(exc)) {
		banco.excluirTabela("resultados", "cod_resultado", exc, usuario_logado);
	}
%>

<html>
<head>
<title>..:Exames:..</title>
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
<script type="text/javascript" src="js/tootip.js"></script>
<script language="JavaScript" src="js/ajax.js"></script>
<script language="JavaScript">

	var jsret = "<%= ret%>";
	var codcli = "<%= codcli%>";

	function incluirexame() {
		var jscodexame = cbeGetElementById("exame");
		var jsvalor = cbeGetElementById("valor");
		var jsdata = cbeGetElementById("data");
		
		if(jscodexame.value == "") {
			alert("Selecione o exame a registrar.");
			jscodexame.focus();
			return;
		}
		if(jsvalor.value == "") {
			alert("Preencha o valor do exame.");
			jsvalor.focus();
			return;
		}
		if(jsdata.value == "") {
			alert("Preencha a data do exame.");
			jsdata.focus();
			return;
		}
		
		cbeGetElementById("frmcadastrar").submit();
	}

	function iniciar() {
		if(jsret == "OK") {
			alert("Exame cadastrado com sucesso.");
		}
	}
	
	function excluiresultado(cod_resultado) {
		conf = confirm("Confirma exclusão do resultado do exame?");
		if(conf) {
	 		window.location = "verexames.jsp?<%= qs%>&exc=" + cod_resultado;
		}
	}
	
	function verGrafico(cod_exame) {
		window.open('grafico.jsp?codcli=' + codcli + '&cod_exame=' + cod_exame ,'grafico','toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=no, menubar=no,width=630,height=350,top=10,left=10');
	}
	
	//Sobrescrendo a função do AJAX
	function setar(chave, campo, valorchave, valorcampo) {
		cbeGetElementById(chave).value = valorchave;
		cbeGetElementById(campo).value = valorcampo;
		x.innerHTML = "";
		hide();
		cbeGetElementById("frmcadastrar").submit();
	}
	
</script>

</head>

<body onLoad="iniciar()">
<%@include file="barraajax.jsp" %>
<form name="frmcadastrar" id="frmcadastrar" action="verexames.jsp?codcli=<%=codcli%>" method="post">
	<table border="0" cellpadding="0" cellspacing="0" width="100%">
		<tr>
		  <td width="100%" height="18" class="title">.: Exames :.</td>
		</tr>
		<tr style="height:25px">
			<td align="right"><span name='msg' id='msg' class="msg">&nbsp;</span></td>
		</tr>
		<tr>
			<td><div class="title"><%= nomepaciente%></div></td>
		</tr>
		<tr>
			<td width="100%" align="center">
				<table width="95%" cellpadding="0" cellspacing="0" class="table">
					<tr>
						<td class="tdMedium">Exame</td>
						<td class="tdMedium" align="center">Valor</td>
						<td class="tdMedium" align="center">Data</td>
						<td width="20" class="tdMedium" align="center">Ação</td>
					</tr>
					<tr>
						<td class="tdLight">
              			<input type="hidden" name="cod_exame" id="cod_exame" value="<%= cod_exame %>">			
						<input style="width:98%" class="caixa" type="text" name="exame" id="exame" onKeyUp="busca(this.value, 'cod_exame', 'exame','exames')" value="<%= nomeexame%>">
						</td>
						<td class="tdLight" align="center"><input name="valor" id="valor" type="text" class="caixa" size="10" maxlength="10" onKeyPress="Javascript:OnlyNumbers(this,event);"> <%= unidade%></td>
						<td class="tdLight" align="center"><input name="data" id="data" type="text" class="caixa" size="10" maxlength="10" onKeyPress="return formatar(this, event, '##/##/####'); " value="<%= data%>"></td>
						<td rowspan="2" class="tdLight" align="center"><a href="Javascript:incluirexame()" title="Incluir Exame"><img src="images/add.gif" border="0"></a></td>
					</tr>
					<tr>
						<td class="tdMedium" align="center">Observação</td>
						<td colspan="2" class="tdLight" align="center"><input type="text" name="obs" id="obs" maxlength="100" style="width:95%" class="caixa"></td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td align="right">&nbsp;</td>
		</tr>
		<tr>
			<td width="100%" align="center">
				<%= exame.listaExames(codcli)%>
			</td>
		</tr>	
	</table>

</form>
</body>
</html>
