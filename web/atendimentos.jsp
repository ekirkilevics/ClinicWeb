<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.Atendimento" id="atendimento" scope="page"/>
<jsp:useBean class="recursos.Paciente" id="paciente" scope="page"/>

<%
	String nomepaciente = "", nascimento = "";
	String codcli = "", foto = "";
	if(strcod != null) { 
		rs = banco.getRegistro("atendimentos","cod_atendimento", Integer.parseInt(strcod) );
		codcli = banco.getCampo("codcli", rs); 		
		String dadospaciente[] = paciente.getDadosPaciente(codcli);
		nascimento = dadospaciente[0];
		foto = dadospaciente[1];
		nomepaciente = dadospaciente[2];
	}

	String proxcod = Util.formataNumero(banco.getNext("atendimentos", "codigo"), 10);
	if(Util.isNull(ordem)) ordem = "codigo DESC";
	
%>

<html>
<head>
<title>Atendimentos</title>
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
	 var nome_campos_obrigatorios = Array("nº de atendimento", "Paciente", "Dia de Entrada", "Hora de Entrada", "Procedente");
	 //Página a enviar o formulário
	 var page = "gravaratendimento.jsp";
     //Campos obrigatórios
	 var campos_obrigatorios = Array("codigo", "codcli", "data_entrada", "hora_entrada", "procedente");
	 
	 function iniciar() {
		cbeGetElementById("procedente").value = "<%= banco.getCampo("procedente", rs) %>";
		cbeGetElementById("encaminhado").value = "<%= banco.getCampo("encaminhado", rs) %>";

		//Se não é edição, colocar data default
		if(idReg == "null") {
			cbeGetElementById("data_entrada").value = "<%= Util.getData()%>";
			cbeGetElementById("hora_entrada").value = "<%= Util.getHora()%>";
			cbeGetElementById("codigo").value = "<%= proxcod%>";
		}
	 	inicio();
		barrasessao();
	 }
	 
	 function novoAtendimento() {
		botaoNovo();
		cbeGetElementById("data_entrada").value = "<%= Util.getData()%>";
		cbeGetElementById("hora_entrada").value = "<%= Util.getHora()%>";
		cbeGetElementById("codigo").value = "<%= proxcod%>";
	 }
	 
	 function gravarAtendimento() {
		 var jsencaminhado = cbeGetElementById("encaminhado").value;
		 var jsdata_saida = cbeGetElementById("data_saida");
		 var jshora_saida = cbeGetElementById("hora_saida");
		 
		 //Se escolheu encaminhado, obrigar data e hora
		 if(jsencaminhado != "") {
		 	//Se faltou data e hora
			if(jsdata_saida.value == "") {
				mensagem("Preencha a data de saída do atendimento",2);
				setarObj(jsdata_saida);
				return;
			}
			if(jshora_saida.value == "") {
				mensagem("Preencha a hora de saída do atendimento",2);
				setarObj(jshora_saida);
				return;
			}
		 }
		 enviarAcao('inc');
	 }
	 
	function imprime() {
		if(idReg == "null") {
			alert("Salve o registro de atendimento para depois imprimir a ficha modelo");
			return;
		}
		displayPopup("escolhemodeloatendimento.jsp?codatend=" + idReg,'popup',120,500);
	}

	function clickBotaoNovo() {
		novoAtendimento();
	}
	
	function clickBotaoSalvar() {
		gravarAtendimento();
	}
	
	function clickBotaoExcluir() {
		enviarAcao('exc');
	}
	
	 

</script>
</head>

<body onLoad="iniciar()">
<%@include file="barrasessao.jsp" %>
<%@include file="barraajax.jsp" %>
<form name="frmcadastrar" id="frmcadastrar" action="gravaratendimento.jsp" method="post">
  <table width="600" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr>
      <td width="651" height="18" class="title">.: Registro de Entrada e Saída :.</td>
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
		            <td class="tdMedium">nº de atendimento:</td>
					<td colspan="5" class="tdLight"><input type="text" size="20" class="caixa" name="codigo" id="codigo" value="<%= banco.getCampo("codigo", rs) %>" onKeyPress="Javascript:OnlyNumbersSemPonto(this,event);" maxlength="10"></td>
					<td rowspan="2" class="tdLight" align="center">
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
					<td class="tdMedium"><a href="Javascript:pesquisapornascimento(2)" title="Pesquisa por nome">Paciente:</a>&nbsp;<a href="Javascript:pesquisapornascimento(1)" title="Pesquisa por data de nascimento"><img src="images/calendar.gif" border="0"></a></td>
		            <td colspan="4" class="tdLight" nowrap> 
              			<input type="hidden" name="codcli" id="codcli" value="<%= codcli %>">			
						<input style="width:95%" class="caixa" type="text" name="nome" id="nome" onKeyUp="busca(this.value, 'codcli', 'nome','paciente')" value="<%= nomepaciente%>">
						<input size="10" class="caixa" type="text" name="pesqnascimento" id="pesqnascimento" onKeyPress="buscanascimento(this.value, event); return formatar(this, event, '##/##/####');" style="display: none">						
					</td>
					<td class="tdLight" align="center">
						<a href="Javascript: cadastrorapido()"><img src="images/raio.gif" border="0" alt="Cadastro Rápido"></a>
					</td>
				</tr>
				<tr>
		            <td class="tdMedium">Entrada:</td>
					<td class="tdLight"><input type="text" size="10" class="caixa" name="data_entrada" id="data_entrada" value="<%= Util.formataData(banco.getCampo("data_entrada", rs)) %>" onKeyPress="return formatar(this, event, '##/##/####'); " maxlength="10" onBlur="ValidaData(this);ValidaFuturo(this);" ></td>
					<td class="tdMedium">Hora:</td>					
					<td class="tdLight"><input type="text" size="5" class="caixa" name="hora_entrada" id="hora_entrada" value="<%= Util.formataHora(banco.getCampo("hora_entrada", rs)) %>" onKeyPress="return formatar(this, event, '##:##'); " maxlength="5" onBlur="ValidaHora(this);" ></td>
					<td class="tdMedium">Procedente:</td>
					<td colspan="2" class="tdLight">
						<select name="procedente" id="procedente" class="caixa" style="width:150px">
							<option value=""></option>
							<%= atendimento.getEntradasSaidas("P", cod_empresa) %>
						</select>
					</td>
				</tr>
				<tr>
		            <td class="tdMedium">Saída:</td>
					<td class="tdLight"><input type="text" size="10" class="caixa" name="data_saida" id="data_saida" value="<%= Util.formataData(banco.getCampo("data_saida", rs)) %>" onKeyPress="return formatar(this, event, '##/##/####'); " maxlength="10" onBlur="ValidaData(this);ValidaFuturo(this);" ></td>
					<td class="tdMedium">Hora:</td>					
					<td class="tdLight"><input type="text" size="5" class="caixa" name="hora_saida" id="hora_saida" value="<%= Util.formataHora(banco.getCampo("hora_saida", rs)) %>" onKeyPress="return formatar(this, event, '##:##'); " maxlength="5" onBlur="ValidaHora(this);" ></td>
					<td class="tdMedium">Encaminhado:</td>
					<td colspan="2" class="tdLight">
						<select name="encaminhado" id="encaminhado" class="caixa" style="width:150px">
							<option value=""></option>
							<%= atendimento.getEntradasSaidas("E", cod_empresa) %>
						</select>
					</td>
				</tr>
				<tr>
					<td class="tdMedium">Observação:</td>
					<td colspan="6" class="tdLight">
						<textarea name="obs" id="obs" class="caixa" cols="85" rows="3"><%= banco.getCampo("obs", rs) %></textarea>
					</td>
				</tr>
          </table>
      </td>
    </tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<%= Util.getBotoes("atendimentos", pesq, tipo) %>    
	<tr>
		<td>&nbsp;</td>
	</tr>
    <tr>
		<td width="100%" style="text-align:center">
			<table width="600px">
				<tr>
					<td width="70" class="tdDark"><a title="Ordenar por nº de Atendimento" href="Javascript:ordenar('atendimentos','codigo')">Atendimento</a></td>
					<td class="tdDark"><a title="Ordenar por Paciente" href="Javascript:ordenar('atendimentos','paciente.nome')">Paciente</a></td>
					<td width="100" class="tdDark"><a title="Ordenar por Entrada" href="Javascript:ordenar('atendimentos','data_entrada DESC, hora_entrada DESC')">Entrada</a></td>
					<td width="100" class="tdDark"><a title="Ordenar por Saída" href="Javascript:ordenar('atendimentos','data_saida DESC, hora_saida DESC')">Saída</a></td>
				</tr>
			</table>
			<div style="width:600; height:101; overflow: auto">
				<table width="100%">
				    <%
						String resp[] = atendimento.getAtendimentos(pesq, "nome", ordem, numPag, 50, tipo, cod_empresa);
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
