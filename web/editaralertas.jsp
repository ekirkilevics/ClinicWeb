<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.Alerta" id="alerta" scope="page"/>

<%
	String codcli = request.getParameter("codcli");
	String opcao = request.getParameter("opcao");
	String excluir = request.getParameter("excluir");
	String de = request.getParameter("de");
	String ate = request.getParameter("ate");
	
	//se veio excluir, excluir o registro de alerta
	if(excluir != null) {
		banco.excluirTabela("alerta_paciente", "cod_alerta_paci", excluir, (String)session.getAttribute("usuario"));
	}

	//Se vai inserir via combo
	if(opcao != null && opcao.equals("1")) {
		alerta.insereAlertaCombo(codcli, request.getParameter("alerta"), de, ate);
	}
	//Se foi item novo
	if(opcao != null && opcao.equals("2")) {
		alerta.insereAlertaNovo(codcli, request.getParameter("novoalerta"), de, ate, cod_empresa);
	}
	
%>

<html>
<head>
<title>..:Alertas:..</title>
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
<script language="JavaScript">

	function habilitar(num) {
		if(num==1) {
			cbeGetElementById("alerta").disabled = false;
			cbeGetElementById("novoalerta").disabled = true;
		}
		else {
			cbeGetElementById("alerta").disabled = true;
			cbeGetElementById("novoalerta").disabled = false;
		}
	}
	
	function insereItem() {
		var sel = cbeGetElementById("opcao1").checked;
		var vde = cbeGetElementById("de");
		var frm = cbeGetElementById("frmcadastrar");
		
		if(vde.value == "") {
			alert("Preencha a data de início do alerta");
			vde.focus();
			return;
		}		
		
		if(sel) { //Escolheu da combo
			frm.action = "editaralertas.jsp?codcli=<%= codcli%>&opcao=1";
		}
		else {	//Escolheu item novo
			//Verificar se a caixa está em branco
			if(frm.novoalerta.value == "") {
				alert("Digite um alerta para associar ao paciente.");
				frm.novoalerta.focus();
				return;
			}
			frm.action = "editaralertas.jsp?codcli=<%= codcli%>&opcao=2";
		}
		
		frm.submit();
	}
	
	function excluiralerta(cod_alerta) {
		var frm = cbeGetElementById("frmcadastrar");
		frm.action = "editaralertas.jsp?codcli=<%= codcli%>&excluir=" + cod_alerta;
		frm.submit();
	}
	
</script>
</head>

<body>
<form name="frmcadastrar" id="frmcadastrar" action="#" method="post">
  <table name="tabela" id="tabela" width="100%" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr>
      <td width="100%" height="18" class="title">.: Alertas :.</td>
    </tr>
	<tr style="height:30px">
		<td align="right"><span name='msg' id='msg' class="msg">&nbsp;</span></td>
	</tr>
    <tr>
		<td width="100%">
			<table cellpadding="0" cellspacing="0" width="100%" class="table">
				<tr>
					<td class="tdMedium"><input type="radio" name="opcao" id="opcao1" onClick="habilitar(1)" checked> Alerta:</td>
					<td class="tdLight">
						<select name="alerta" id="alerta" class="caixa">
							<%= alerta.getAlertas(cod_empresa)%>
						</select>
					</td>
				</tr>
				<tr>
          			 <td height="24" class="tdMedium">
						<input type="radio" name="opcao" id="opcao2" onClick="habilitar(2)"> Novo Alerta:</td>
					<td class="tdLight"><input type="text" name="novoalerta" id="novoalerta" class="caixa" size="30" maxlength="50" disabled></td>
				</tr>
				<tr>
				  <td colspan="2" class="tdLight">
				  	Início: <input name="de" id="de" type="text" class="caixa" size="10" onKeyPress="return formatar(this, event, '##/##/####'); " maxlength="10">
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				  	Fim: <input name="ate" id="ate" type="text" class="caixa" size="10" onKeyPress="return formatar(this, event, '##/##/####'); " maxlength="10">
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<input type="button" class="botao" value="  Inserir  " onClick="Javascript: insereItem()">
				  </td>
				</tr>
			</table>
		</td>
	</tr>
	<tr align="center" valign="top">
      <td width="100%">
			<%= alerta.getAlertasPaciente(codcli)%>
	  </td>
    </tr>
  </table>
</form>

</body>
</html>
