<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.Usuario" id="usuario" scope="page"/>

<%
	String senhaatual = request.getParameter("senhaatual");
	String novasenha = request.getParameter("novasenha");
	String resp = "";
	
	if(senhaatual != null && novasenha != null) {
		resp = usuario.alteraSenha(usuario_logado, senhaatual, novasenha);
	}
%>

<html>
<head>
<title>..:: Alteração de Senha ::..</title>
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>

<script language="JavaScript">
	var resp = "<%= resp %>";

	function iniciar() {
		if(resp != "") {
			alert(resp)
			self.close();
		}
	}
	
	function temLetra( palavra ) {
		achou = false;
		for(i=0; i<palavra.length; i++) {
			if(palavra.charAt(i) >='a' && palavra.charAt(i) <='z') achou = true;
			if(palavra.charAt(i) >='A' && palavra.charAt(i) <='Z') achou = true;
		}
		return achou;
	}
	
	
	function enviar() {
		var frm = cbeGetElementById("frmcadastrar");
		
		if(frm.senhaatual.value == "") {
			alert("Preencha senha atual para a troca");
			frm.senhaatual.focus();
			return;
		}
		if(frm.novasenha.value == "") {
			alert("Nova senha não pode estar em branco");
			frm.novasenha.focus();
			return;
		}
		//Verifica se tem pelo menos 8 caracteres
		if(frm.novasenha.value.length < 8) {
			alert("Senha deve ter pelo menos 8 caracteres");
			frm.novasenha.focus();
			return;
		}
		
		//Verifica se tem pelo menos uma letra
		if(!temLetra(frm.novasenha.value)) {
			alert("Senha deve ter pelo menos 1 letra");
			frm.novasenha.focus();
			return;
		}

		if(frm.novasenha.value != frm.confirma.value) {
			alert("Nova senha não confere com senha de confirmação");
			frm.novasenha.focus();
			return;
		}
		
		frm.submit();

	}
	
</script>
</head>

<body onLoad="iniciar()">
<form name="frmcadastrar" id="frmcadastrar" action="alterarsenha.jsp" method="post">
  <table width="100%" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr>
      <td width="100%" height="18" class="title">.: Alterar Senha :.</td>
    </tr>
	<tr style="height:25px">
		<td align="right"><span name='msg' id='msg' class="msg">&nbsp;</span></td>
	</tr>
    <tr align="center" valign="top">
      <td width="100%">
	  	<table cellpadding="0" cellspacing="0" class="table" width="100%">
			<tr>
				<td width="100" class="tdMedium" align="center">Senha Atual</td>
				<td class="tdLight"><input name="senhaatual" id="senhaatual" type="password" class="caixa" size="15" maxlength="10"></td>
			</tr>
			<tr>
				<td class="tdMedium" align="center">Nova Senha</td>
				<td class="tdLight"><input name="novasenha" id="novasenha" type="password" class="caixa" size="15" maxlength="10" onKeyDown="TestaSenha(this.value);"><span id="seguranca" class="texto">&nbsp;</span></td>
			</tr>
			<tr>
				<td class="tdMedium" align="center">Confirma Senha</td>
				<td class="tdLight"><input name="confirma" id="confirma" type="password" class="caixa" size="15" maxlength="10"></td>
			</tr>
			<tr>
				<td colspan="2" class="tdMedium" align="center">
						<button type="button" name="salvar" id="salvar" class="botao" style="width:70px" onClick="enviar()"><img src="images/gravamini.gif" height="17">&nbsp;&nbsp;&nbsp;&nbsp;Salvar</button>
				</td>
			</tr>
		</table>
	  </td>
    </tr>
  </table>
 </form>
</body>
</html>
