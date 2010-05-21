<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.Feriado" id="feriado" scope="page"/>

<%
	if(strcod != null) rs = banco.getRegistro("feriados","cod_feriado", Integer.parseInt(strcod) );
	if(Util.isNull(ordem)) ordem = "datainicio";
	
	//Verifica se tem agenda no intervalo escolhido
	String temagenda = Util.isNull(request.getParameter("temagenda")) ? "" : request.getParameter("temagenda");
%>

<html>
<head>
<title>Feriados</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
<script language="JavaScript">
     //id
     var idReg = "<%= strcod%>";
	 //Informação vinda de gravar
	 var inf = "<%= inf%>";
	 //Nome dos campos
	 var nome_campos_obrigatorios = Array("Descrição", "Data Início", "Data Fim", "Profissioanal");
	 //Página a enviar o formulário
	 var page = "gravarferiado.jsp";
	 //Cod. da ajuda
	 cod_ajuda = 11;

     //Campos obrigatórios
	 var campos_obrigatorios = Array("descricao", "datainicio", "datafim", "prof_reg");

	function iniciar() {
		inicio();
		barrasessao();
		cbeGetElementById("prof_reg").value = "<%= banco.getCampo("prof_reg", rs)%>";
		var jddiatodo = "<%= banco.getCampo("diatodo", rs)%>";
		var jsdefinitivo = "<%= banco.getCampo("definitivo", rs)%>";
		var jspessoal = "<%= banco.getCampo("pessoal", rs)%>";
		var frmdiatodo = cbeGetElementById("diatodo");
		var jstemagenda = "<%= temagenda%>";
		
		if(jsdefinitivo == "S") {
			cbeGetElementById("definitivo").checked = true;
		}
		if(jspessoal == "S") {
			cbeGetElementById("pessoal").checked = true;
		}

		if(jddiatodo == "S") {
			frmdiatodo.checked = true;
			cbeGetElementById("hora_inicio").disabled = true;
			cbeGetElementById("hora_fim").disabled = true;
		}
		else frmdiatodo.checked = false;
		
		//Verifica se tem agenda no horário
		if(jstemagenda != "") {
			if(jstemagenda == "S")
				alert("Existe agendamento no horário gravado. \nOs pacientes não foram desmarcados.\nPara desagendar, entre na agenda e desmarque os pacientes");
		}

	}
	
	function salvarferiado() {
		if(cbeGetElementById("prof_reg").value != "todos") {
			if(cbeGetElementById("hora_inicio").value == "" || cbeGetElementById("hora_fim").value == "") {
				mensagem("Período não foi preenchido!",2);
				return;
			}
		}
		cbeGetElementById("prof_reg").disabled = false;
		enviarAcao('inc')
	}
	
	function chkDiaTodo(obj) {
		jshi = cbeGetElementById("hora_inicio");
		jshf = cbeGetElementById("hora_fim");
		
		if(obj.checked == true) {
			jshi.value = "00:00";
			jshi.disabled = true;
			jshf.value = "00:00";
			jshf.disabled = true;
		}
		else {
			jshi.value = "";
			jshi.disabled = false;
			jshf.value = "";
			jshf.disabled = false;
		}
	}
	
	function escolhedefinitivo(obj) {

		cbeGetElementById("diatodo").checked = obj.checked;
		cbeGetElementById("hora_inicio").disabled = obj.checked;
		cbeGetElementById("hora_fim").disabled = obj.checked;
		cbeGetElementById("prof_reg").value = "todos";
		cbeGetElementById("prof_reg").disabled = obj.checked;
		
		if(obj.checked == true) {
			cbeGetElementById("hora_inicio").value = "00:00";
			cbeGetElementById("hora_fim").value = "00:00";
			cbeGetElementById("datafim").value = cbeGetElementById("datainicio").value;
			cbeGetElementById("datafim").disabled = true;
		}
		else {
			cbeGetElementById("hora_inicio").value = "";
			cbeGetElementById("hora_fim").value = "";
			cbeGetElementById("datafim").disabled = false;
		}
	}
	
	function clickBotaoNovo() {
		botaoNovo();
	}
	
	function clickBotaoSalvar() {
		enviarAcao('inc');
	}
	
	function clickBotaoExcluir() {
		enviarAcao('exc');
	}	
	
</script>
</head>

<body onLoad="iniciar();">
<%@include file="barrasessao.jsp" %>
<form name="frmcadastrar" id="frmcadastrar" action="gravarferiado.jsp" method="post">
  <table width="600" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr>
      <td width="651" height="18" class="title">.: Bloquear Agenda :.</td>
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
	        	<td class="tdMedium">Descrição *:</td>
    	        <td colspan="3" class="tdLight"><input name="descricao" type="text" class="caixa" id="descricao" value="<%= banco.getCampo("descricao", rs) %>" size="85" maxlength="50"></td>
            </tr>
            <tr>
	        	<td class="tdMedium">Data Início *:</td>
    	        <td class="tdLight"><input name="datainicio" type="text" class="caixa" id="datainicio" value="<%= Util.formataData(banco.getCampo("datainicio", rs)) %>" size="12" maxlength="10" onKeyPress="return formatar(this, event, '##/##/####'); " onBlur="ValidaData(this);cbeGetElementById('datafim').value=this.value"></td>
	        	<td class="tdMedium">Data Fim *:</td>
    	        <td class="tdLight"><input name="datafim" type="text" class="caixa" id="datafim" value="<%= Util.formataData(banco.getCampo("datafim", rs)) %>" size="12" maxlength="10" onKeyPress="return formatar(this, event, '##/##/####'); " onBlur="ValidaData(this);"></td>
			</tr>
            <tr>
	        	<td class="tdMedium">Profissional *:</td>
    	        <td colspan="3" class="tdLight">
					<select name="prof_reg" id="prof_reg" class="caixa">
						<option value=""><-- Selecione o Profissional --></option>
						<option value="todos"><-- TODOS --></option>
						<%= feriado.getProfissionais(cod_empresa)%>
					</select>
				</td>
            </tr>
			<tr>
				<td class="tdMedium">Período:</td>	
				<td class="tdLight">
					de  <input type="text" class="caixa" name="hora_inicio" id="hora_inicio" size="6" maxlength="5" onKeyPress="formatar(this, event, '##:##'); " value="<%= Util.formataHora(banco.getCampo("hora_inicio", rs)) %>">
					até <input type="text" class="caixa" name="hora_fim" id="hora_fim" size="6" maxlength="5" onKeyPress="formatar(this, event, '##:##'); " value="<%= Util.formataHora(banco.getCampo("hora_fim", rs)) %>">
				</td>
				<td colspan="2" class="tdMedium">
					<input type="checkbox" name="diatodo" id="diatodo" onClick="chkDiaTodo(this)" value="S"> Dia Todo&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<input type="checkbox" name="definitivo" id="definitivo" onClick="escolhedefinitivo(this)" value="S"> Definitivo
				</td>				
			</tr>
          </table>
      </td>
    </tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<%= Util.getBotoes("feriados", pesq, tipo) %>
	<tr>
		<td>&nbsp;</td>
	</tr>
    <tr>
		<td width="100%" style="text-align:center">
			<table width="600px">
				<tr>
					<td width="100" class="tdDark"><a title="Ordenar por Data de Início" href="Javascript:ordenar('feriados','datainicio')">Data de Início</a></td>
					<td width="200" class="tdDark"><a title="Ordenar por Descrição" href="Javascript:ordenar('feriados','descricao')">Descrição</a></td>
					<td class="tdDark"><a title="Ordenar por Profissional" href="Javascript:ordenar('feriados','nome')">Profissional</a></td>
				</tr>
			</table>
			<div style="width:600; height:101; overflow: auto">
				<table width="100%">
				    <%
						String resp[] = feriado.getFeriados(pesq, ordem, numPag, 50, tipo, cod_empresa);
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
