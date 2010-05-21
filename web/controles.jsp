<html>
<head>
<title>Controles</title>
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
<script language="JavaScript" src="js/ajax.js"></script>
<script language="JavaScript">
	
	function gravar() {
		guia = parent.frames[1];
		guia.gravarGuia();
	}
	
</script>
</head>

<body bgcolor="#CCCCCC">
	<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
		<tr>
			<td align="center" valign="middle"><button type="button" style="width: 150px" class="botao" onClick="Javascript:gravar()"><img src="images/print.gif">&nbsp;&nbsp;&nbsp;Salvar e Imprimir</button></td>
		</tr>
	</table>
</body>
</html>
