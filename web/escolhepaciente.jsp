<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.Paciente" id="paciente" scope="page"/>

<%
	String num = request.getParameter("num");
%>

<html>
<head>
<title>Escolhe Paciente</title>
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
<script language="JavaScript" src="js/ajax.js"></script>
<script language="JavaScript">

    var codcli = "codcli<%= num%>";
	var nome   = "nome<%= num%>";

	//Sobrescrendo a função do AJAX
	function setar(chave, campo, valorchave, valorcampo) {
		cbeGetElementById(chave).value = valorchave;
		cbeGetElementById(campo).value = valorcampo;
		x.innerHTML = "";
		
		setarCampoPai(codcli, valorchave);
		setarCampoPai(nome, valorcampo);
		
		self.close();
	}

</script>
</head>

<body>
<%@include file="barraajax.jsp" %>
<form name="frmcadastrar" id="frmcadastrar" action="#" method="post">
  <table width="500" border="0" align="center" cellpadding="0" cellspacing="0">
    <tr>
      <td height="18" class="title">.: Escolher Paciente :.</td>
    </tr>
    <tr align="center" valign="top">
      <td>
	  		<table width="100%" border="0" cellpadding="0" cellspacing="0" class="table">
				<tr>
		            <td width="80" class="tdMedium">Paciente:</td>
		            <td class="tdLight"> 
              			<input type="hidden" name="codcli" id="codcli">			
						<input class="caixa" size="70" type="text" name="nome" id="nome" onKeyUp="busca(this.value, 'codcli', 'nome','paciente')">
					</td>
				</tr>
			</table>
	  </td>
    </tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
 </table>

</form>

</body>
</html>
