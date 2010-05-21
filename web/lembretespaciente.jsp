<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.Lembrete" id="lembrete" scope="page"/>
<jsp:useBean class="recursos.Paciente" id="paciente" scope="page"/>

<%
	if(strcod != null) rs = banco.getRegistro("lembretes","cod_lembrete", Integer.parseInt(strcod) );
	if(Util.isNull(ordem)) ordem = "data DESC";

	String codcli = Util.isNull(request.getParameter("codcli")) ? banco.getCampo("codcli", rs) : request.getParameter("codcli");
	String celular = paciente.getCelularPaciente(codcli);
%>

<html>
<head>
<title>..:Lembretes:..</title>
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
	 var nome_campos_obrigatorios = Array("Data", "Hora", "Mensagem");
	 //Página a enviar o formulário
	 var page = "gravarlembretes.jsp";
     //Campos obrigatórios
	 var campos_obrigatorios = Array("data", "hora", "lembrete");
	 
	 //Dados para SMS
	 var jscelular = "<%= celular%>";
   	 var autoriza_sms = "<%= (String)session.getAttribute("sms")%>";

	 
	 function iniciar() {
		//Se não tem celular
		if(jscelular == "") {
			alert("Paciente não possui celular cadastrado para envio de Lembretes");
			self.close();
		}
		inicio();
	 }
	 
	 function gravarLembrete() {
		//Se não tem permissão para SMS
		if(autoriza_sms == "N") {
			alert("Cliente com SMS desabilitado!");
			return;
		}
	 
	    enviarAcao('inc')
	 }

</script>

</head>

<body onLoad="iniciar()">
<form name="frmcadastrar" id="frmcadastrar" action="gravarlembretes.jsp" method="post">
  <input type="hidden" name="codcli" id="codcli" value="<%= codcli%>">
  <table width="600" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr>
      <td width="651" height="18" class="title">.: Lembretes :.</td>
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
	            <td class="tdMedium">Data: *</td>
                <td class="tdLight"><input name="data" type="text" class="caixa" id="data" onKeyPress="return formatar(this, event, '##/##/####'); " value="<%= Util.formataData(banco.getCampo("data", rs)) %>" size="9" maxlength="10" onBlur="ValidaData(this);ValidaPassado(this);"></td>
	            <td class="tdMedium">Hora: *</td>
                <td class="tdLight"><input name="hora" type="text" class="caixa" id="hora" onKeyPress="return formatar(this, event, '##:##'); " value="<%= Util.formataHora(banco.getCampo("hora", rs)) %>" size="5" maxlength="5" onBlur="ValidaHora(this);"></td>
            </tr>
			<tr>
				<td class="tdMedium">Mensagem: *</td>
				<td class="tdLight" colspan="3"><input type="text" name="lembrete" id="lembrete" class="caixa" maxlength="140" size="85" value="<%= banco.getCampo("lembrete", rs)%>"></td>
			</tr>
          </table>
      </td>
    </tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
    <tr align="center" valign="top">
      <td width="100%">
            <table width="100%" border="0" cellpadding="0" cellspacing="0" class="table">
				<tr>
					<td class="tdMedium" style="text-align:center"><button name="salvar" id="salvar" type="button" class="botao" style="width:70px" onClick="gravarLembrete()"><img src="images/grava.gif">&nbsp;&nbsp;&nbsp;&nbsp;Salvar</button></td>
					<td class="tdMedium" style="text-align:left">
						<input type="text" name="pesq" id="pesq" class="caixa" value="<%= pesq %>" style="width:150px">&nbsp;
						<select name="tipo" id="tipo" class="caixa">
							<option value="1"<%= banco.getSel(tipo, 1)%>>Exata</option>
							<option value="2"<%= banco.getSel(tipo, 2)%>>Início</option>							
							<option value="3"<%= banco.getSel(tipo, 3)%>>Meio</option>
						</select>
						<button type="button" class="botao" style="width:80px" onClick="buscar('lembretes');"><img src='images/busca.gif' height='17'>&nbsp;Consultar</button></td>
				</tr>
			</table>
	  </td>
    </tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
    <tr>
		<td width="100%" style="text-align:center">
			<table width="600px">
				<tr>
					<td width="80" class="tdDark">Dt.Cadastro</td>
					<td width="80" class="tdDark">Dt.Envio</td>
					<td width="60" class="tdDark">Hora</td>
					<td class="tdDark">Mensagem</td>
				</tr>
			</table>
			<div style="width:600; height:101; overflow: auto">
				<table width="100%">
				    <%
						String resp[] = lembrete.getLembretes(pesq, "lembrete", numPag, 50, tipo, codcli);
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
