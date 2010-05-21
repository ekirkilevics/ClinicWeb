<%@include file="cabecalho.jsp" %>

<%
	int qtde =  Integer.parseInt(request.getParameter("qtde"));
	String mensagem = "";
	
	if(qtde > 0) mensagem = "Sua senha expira em " + qtde + " dia(s).";
	else if(qtde == 0) mensagem = "Sua senha expira hoje!";
	else mensagem = "Sua senha expirou a " + (-qtde) + " dia(s).";
	
%>

<html>
<head>
<title>..:: Expiração de Senha ::..</title>
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
<script language="javascript">
	function trocarsenha() {
		self.location = "alterarsenha.jsp";
	}
	
	function depois() {
		self.close();
	}
</script>
</head>

<body>
<form name="frmcadastrar" id="frmcadastrar" action="#" method="post">
  <table width="100%" border="0" align="center" cellpadding="2" cellspacing="0" height="100%">
    <tr align="center" valign="top">
      <td width="100%" height="100%">
	  	<table cellpadding="0" cellspacing="0" width="100%" height="100%">
            <tr>
            	<td class="title" style="font-size:20px; color:red" align="center"><%= mensagem%></td>
            </tr>
            <tr>
            	<td align="center">
                	<button type="button" onClick="trocarsenha()" class="botao"><img src="images/15.gif">&nbsp;&nbsp;&nbsp;Trocar Senha</button>
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <button type="button" class="botao"onClick="depois()"><img src="images/17.gif">&nbsp;&nbsp;&nbsp;Depois eu faço...</button>
            </tr>
		</table>
	  </td>
    </tr>
  </table>
 </form>
</body>
</html>
