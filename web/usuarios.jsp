<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.Usuario" id="usuario" scope="page"/>

<%
	if(strcod != null) rs = banco.getRegistro("t_usuario","cd_usuario", Integer.parseInt(strcod) );
	if(ordem == null) ordem = "ds_nome";
%>

<html>
<head>
<title>Usuários</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
<script language="JavaScript">
     //id do convênio
     var idReg = "<%= strcod%>";
	 //Informação vinda de gravarprocedimento
	 var inf = "<%= inf%>";
	 //Nome dos campos
	 var nome_campos_obrigatorios = Array("Nome do Usuário","Login", "Grupo");
	 //Página a enviar o formulário
	 var page = "gravarusuario.jsp";
     //Campos obrigatórios
	 var campos_obrigatorios = Array("nome","login","grupo");

	function setarValores()	{
		getObj("","grupo").value = "<%= banco.getCampo("ds_grupo", rs)%>";
		getObj("","prof_reg").value = "<%= banco.getCampo("prof_reg", rs)%>";
	}	 
	
	function temLetra( palavra ) {
		achou = false;
		for(i=0; i<palavra.length; i++) {
			if(palavra.charAt(i) >='a' && palavra.charAt(i) <='z') achou = true;
			if(palavra.charAt(i) >='A' && palavra.charAt(i) <='Z') achou = true;
		}
		return achou;
	}
 
 	function confirmaSenha() {
		var se1 = cbeGetElementById("senha");
		var se2 = cbeGetElementById("confsenha");
	
		//Se a senha estiver em branco, é pq não vai ser alterada
		if(se1.value != "") {

			//Verifica se tem pelo menos 8 caracteres
			if(se1.value.length < 8) {
				mensagem("Senha deve ter pelo menos 8 caracteres com pelo menos 1 letra", 2);
				se1.focus();
				return;
			}
			
			//Verifica se tem pelo menos uma letra
			if(!temLetra(se1.value)) {
				mensagem("Senha deve ter pelo menos 8 caracteres com pelo menos 1 letra", 2);
				se1.focus();
				return;
			}
	
			//Verifica se senha e confirmação batem
			if(se1.value != "" && se1.value != se2.value) {
				mensagem("Senha e confirmação não batem!",2);
				return;
			}

		}
		enviarAcao('inc');
		
	}
	
	function iniciar() {
		inicio();
		setarValores();
		barrasessao();
	}
	
	function clickBotaoNovo() {
		botaoNovo();
	}
	
	function clickBotaoSalvar() {
		confirmaSenha();
	}
	
	function clickBotaoExcluir() {
		enviarAcao('exc');
	}

</script>
</head>

<body onLoad="iniciar()">
<%@include file="barrasessao.jsp" %>
<form name="frmcadastrar" id="frmcadastrar" action="gravarprocedimento.jsp" method="post">
  <table width="600" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr>
      <td width="651" height="18" class="title">.: Usu&aacute;rios :.</td>
    </tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr style="height:25px">
		<td align="right"><span name='msg' id='msg' class="msg">&nbsp;</span></td>
	</tr>
    <tr align="center" valign="top">
      <td>
          <table width="100%" border="0" cellpadding="0" cellspacing="0" class="table">
            <tr>
              <td width="150" class="tdMedium">Nome: *</td>
              <td class="tdLight"><input name="nome" type="text" class="caixa" id="nome" value="<%= banco.getCampo("ds_nome", rs) %>" size="40" maxlength="30"></td>
            </tr>
			<tr>
			  <td class="tdMedium">Login: *</td>
              <td class="tdLight"><input name="login" type="text" class="caixa" id="login" size="30" maxlength="30" value="<%= banco.getCampo("ds_login", rs) %>"></td>
		    </tr>
			<tr>
			  <td class="tdMedium">Senha:</td>
              <td class="tdLight">
              	<input name="senha" type="password" class="caixa" id="senha" size="30" maxlength="30" onKeyDown="TestaSenha(this.value);"> 
              	<span id="seguranca" class="texto">&nbsp;</span>
              </td>
		    </tr>
			<tr>
			  <td class="tdMedium">Confirma Senha:</td>
              <td class="tdLight"><input name="confsenha" type="password" class="caixa" id="confsenha" size="30" maxlength="30"></td>
		    </tr>
            <tr>
              <td class="tdMedium">Grupo: *</td>
              <td class="tdLight">
			  	<select name="grupo" id="grupo" class="caixa" style="width:150px">
					<option value=""></option>
					<%= usuario.getGrupos(cod_empresa) %>
				</select>
			  </td>
            </tr>
			<tr>
			  <td class="tdMedium">Código de Barras:</td>
              <td class="tdLight"><input name="barras" type="text" class="caixa" id="barras" size="20" maxlength="10" value="<%= banco.getCampo("cod_barra", rs)%>"></td>
		    </tr>
			<tr>
			  <td class="tdMedium">Médico:</td>
              <td class="tdLight">
			  		<select name="prof_reg" id="prof_reg" class="caixa">
						<option value="-1">Não se aplica</option>
						<%= usuario.getProfissionais(cod_empresa) %>
					</select>
			  </td>
		    </tr>
          </table>
      </td>
    </tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<%= Util.getBotoes("usuarios", pesq, tipo) %>
	<tr>
		<td>&nbsp;</td>
	</tr>
    <tr>
		<td width="100%" style="text-align:center">
			<table width="600px">
				<tr>
					<td width="100%" class="tdDark">Nome do Usuário</td>
				</tr>
			</table>
			<div style="width:600; height:101; overflow: auto">
				<table width="100%">
				    <%
						String resp[] = usuario.getUsuarios(pesq, "ds_nome", ordem, numPag, 10, tipo, cod_empresa);
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
