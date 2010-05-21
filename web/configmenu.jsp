<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.Menu" id="menu" scope="page"/>
<%

%>
<html>
<head>
<title>Email</title>
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
<script language="JavaScript">
     //id do convênio
     var idReg = "1";
	 //Depois que voltou do gravar
	 var inf = "<%= inf%>";
	 //Nome dos campos

	function voltarPadrao()
	{
		window.location = "gravarmenu.jsp?id=-1";
	}
	
	function alteraitem(cod)
	{
		if(alterar != "1") {
			alert("Usuário sem permissão para alterar o menu!");
			return;
		}
		else {
			var frm = cbeGetElementById("frmcadastrar");
			frm.action += "?id=" + cod;
			frm.submit();
		}
	}
	
	function iniciar()
	{
		mensagem(inf,0);
		barraStatus();
		window.defaultStatus = "..:: Clinic Web ::.."
	}
	 
</script>
</head>

<body onload="iniciar();barrasessao();">
<%@include file="barrasessao.jsp" %>
<form name="frmcadastrar" id="frmcadastrar" action="gravarmenu.jsp" method="post">
  <table width="600" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr>
      <td width="651" height="18" class="title">.: Configuração do Menu :.</td>
    </tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr style="height:25px">
		<td align="right"><span name='msg' id='msg' class="msg">&nbsp;</span></td>
	</tr>
    <tr align="center" valign="top">
      <td>
		<%= menu.montaMenuEdit(cod_empresa) %>
      </td>
    </tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
  </table>
</form>

</body>
</html>
