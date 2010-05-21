<%@page import="recursos.*" %>
<% 
	response.setHeader("Cache-Control", "no-cache");
    response.setHeader("Pragma", "no-cache");
%>

<jsp:useBean class="recursos.Atualizacao" id="atualizacao" scope="page"/>

<%
	//Se está na login, limpar sessão
	Util.removeUsuario((String)session.getAttribute("usuario"), application);
	session.setAttribute("usuario",null);
	session.invalidate();

	//Recebe código de erro do conflogin.jsp
	String erro = request.getParameter("erro");
	String msg = "&nbsp";
	if(erro != null)
		if( erro.equals("-1"))
			msg = "Sem autenticação com Web";
		else if( erro.equals("2"))
			msg = "Usuário sem sessão";
		else if( erro.equals("-2"))
			msg = "Usuário ou senha incorretos";
		else if( erro.equals("-3"))
			msg = "Erro ao conectar Banco de Dados";
		else if( erro.equals("-4"))
			msg = "Validade Expirada";
		else
			msg = erro;
			

	String versao[] = atualizacao.getUltimaVersao();
	
	if(versao[0].length() > 11)
		response.sendRedirect("index.jsp");
%>

<html>
<head>
<TITLE>..:: Clinic Web ::..</TITLE>
<link href="css/css.css" rel="stylesheet" type="text/css">
<link rel="shortcut icon" href="images/cw.ico" />
<style type="text/css">
.caixa {
	border: 1px solid #000000;
	font-family: tahoma;
	font-size: 11px;
	color: #222222;
	background-color: #FFFFFF;
}

.msg {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 11px;
	color: #FF0000;
	font-weight: bold;
}

.texto {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 11px;
	color: #666666;
}

.title {
	font: bold 25px Tahoma, Verdana, Arial, Helvetica;
	color: #3F9B20;
	padding: 5px;
	padding-left: 10px;
	padding-right: 10px;
	white-space: nowrap;
}

.tdDark {
	border: 0px;
	border-bottom: 1px solid #2F7317;
	border-right: 1px solid #2F7317;
	font: 11px Tahoma, Verdana, Arial, Helvetica;
	color: #000000;
	padding: 3px 10px;
	white-space: nowrap;
	background: #8EE272; 
}

.tdMedium {
	border: 0px;
	border-bottom: 1px solid #2F7317;
	border-right: 1px solid #2F7317;
	font: 11px Tahoma, Verdana, Arial, Helvetica;
	color: #000000;
	padding: 1px 10px;
	white-space: nowrap;
}

.tdLight {
	border: 0px;
	border-bottom: 1px solid #2F7317;
	border-right: 1px solid #2F7317;
	font: 11px Tahoma, Verdana, Arial, Helvetica;
	color: #000000;
	padding: 1px 10px;
}

</style>
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
<script language="Javascript">

	function inicio() {
		document.frmlogin.txtlogin.focus();
	}
	
	function verifica() {
		var login = document.getElementById("txtlogin");
		var senha = document.getElementById("txtsenha");
		var mensag = document.getElementById("msg");

		if(login.value == "")
		{
			mensag.innerHTML = "Usuário em branco!";
			login.focus();
			return false;
		}

		else if(senha.value == "")
		{
			mensag.innerHTML = "Senha em branco!";
			senha.focus();
			return false;
		}
		
		return true;

	}
	
	function logar() {
		var frm = cbeGetElementById("frmlogin");
		
		if(verifica()) {
			frm.submit();
		}
	}
	
	function verificaEnter(e) {
		//Se for ENTER, mandar submit
		if(e.keyCode == 13) logar();
	}
	
	//Troca imagens do botão dando efeito
	function trocar(tipo) {
		if(tipo =='on') 
			cbeGetElementById("botentrar").src = "images/botentrar.gif";
		else		
		   cbeGetElementById("botentrar").src = "images/botentrar2.gif";
	}
		

</script>

</head>

<BODY LEFTMARGIN=0 TOPMARGIN=0 MARGINWIDTH=0 MARGINHEIGHT=0 bgcolor="#EFEFEF" onLoad="inicio()">
<form action="conflogin.jsp" method="post" name="frmlogin" id="frmlogin" onSubmit="return verifica();">
<center>
<table width="600" height="400" style="height:400px; background-image:url(images/fundologin.gif)" cellpadding="0" cellspacing="0">
	<tr>
		<td height="90">&nbsp;</td>
	</tr>
	<tr> 
      <td width="100%" height="80" valign="top" class="texto" style="padding-left: 10px">&nbsp;</td>
	</tr>
	<tr> 
      <td align="right" width="100%" height="35" valign="bottom">
	  	<table width="100%" cellpadding="0" cellspacing="0">
			<tr>
				<td width="350">&nbsp;</td>
				<td align="center"><b><span name="msg" id="msg" class="msg"><%= msg %></span></b></td>
				<td width="45">&nbsp;</td>
			</tr>
		</table>
	  </td>
	</tr>
	<tr> 
      <td height="25" align="right" style="padding-right:60px" class="texto"><strong>Usuário:</strong> <input name="txtlogin" type="text" class="caixa" id="txtlogin" size="18" maxlength="30" onKeyPress="verificaEnter(event)"></td>
	</tr>
	<tr> 
      <td height="25" align="right" style="padding-right:60px" class="texto"><strong>Senha:</strong> <input name="txtsenha" type="password" class="caixa" id="txtsenha" size="18" maxlength="30" onKeyPress="verificaEnter(event)"></td>
	</tr>
	<tr> 
      <td height="35" align="right" style="padding-right:60px"><a href="Javascript: logar()" title="Entrar no Sistema"><img src="images/botentrar.gif" border="0" id="botentrar" onMouseOut="trocar('on')" onMouseOver="trocar('off')" ></a></td>
	</tr>
	<tr>
    	<td width="100%" valign="bottom">
        	<table border="0" cellpadding="0" cellspacing="0" width="100%">
            	<tr>
                  <td align="left" style="padding-left:10px"><a href="http://www.katusis.com.br" title="Acesso o site da KATU" target="_blank"><img src="images/logokatu.gif" border="0"></a></td>
                  <td align="right" style="padding: 10px" class="texto" valign="bottom">Versão <%= versao[0] %> de <%= versao[1] %></td>
                </tr>
            </table>
        </td>
	</tr>
</table>
</center>
</form>
</body>
</html>
