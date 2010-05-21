<%@page import="recursos.*" %>
<html>
<head>
<title>Fechar</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<style type="text/css">
.texto {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 11px;
	color: #666666;
}
</style>
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="javascript">
	var intervalo;
	function iniciar() {
		intervalo = window.setTimeout("fechar()", 5000);
	}

	function fechar() {
		window.close();
	}	
</script>
</head>

<body bgcolor="#D9ECFF" onLoad="iniciar()">
	<table cellpadding="0" cellspacing="0" width="100%" height="100%">
    	<tr>
        	<td class="texto" width="100%" height="100%" valign="middle">Para sair do sistema, prefira usar o ícone <img src="images/12.gif"><br><br>Usuário <b><%= (String)session.getAttribute("nomeusuario")%></b> foi deslogado automaticamente</td>
        </tr>
    </table>
</body>
</html>
<%
	//Se está na login, limpar sessão
	Util.removeUsuario((String)session.getAttribute("usuario"), application);
	session.setAttribute("usuario",null);
	session.invalidate();
%>
