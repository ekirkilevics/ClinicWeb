<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.Imagem" id="imagem" scope="page"/>

<%
	String codcli = request.getParameter("codcli");
%>

<html>
<head>
<title>..:: Insere Foto ::..</title>
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
<script language="javascript">
	function camera() {
		var appletcamera = "<applet code='Executavel.class' cabbase='Executavel.class' width='0' height='0'>";
		appletcamera += "<param name='programa' value='c:/Windows/System32/calc.exe'>";
		appletcamera += "</applet>";

		cbeGetElementById("webcam").innerHTML = appletcamera;
	}
</script>

</head>

<body>
<form name="frmcadastrar" id="frmcadastrar" action="gravarfoto.jsp?codcli=<%= codcli%>" method="post" ENCTYPE="multipart/form-data">
  <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
    <tr align="center" valign="top">
      <td>
			<input type="hidden" name="codcli" id="codcli" value="<%= codcli%>">
	  		<table width="100%" border="0" cellpadding="0" cellspacing="0" class="table">
				<tr>
					<td colspan="2" class="tdLight">&nbsp;</td>
				</tr>
				<tr>
					<td width="40" class="tdMedium">Foto:</td>
					<td class="tdLight"><input type="file" class="caixa" name="imagem" id="imagem" style="width:100%"></td>
				</tr>
				<tr>
					<td colspan="2" class="tdMedium" align="center">
						<input type="submit" class="botao" value="Enviar">
                        <input type="button" class="botao" value="Camera" onClick="Javascript:camera()">
					</td>
				</tr>
			</table>
	  </td>
    </tr>
  </table>
  <div id="webcam" style="width:200px; height:200px">
<applet code='Executavel.class' cabbase='Executavel.class' width='200' height='200'>
<param name='programa' value='c:/Windows/System32/calc.exe'>
</applet>
  
  </div>

 </form>
</body>
</html>
