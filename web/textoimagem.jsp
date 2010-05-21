<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.Imagem" id="imagem" scope="page"/>
<%
	String cod_imagem = request.getParameter("cod");
	String texto = request.getParameter("texto");
	String gravou = "false";
	
	if(texto != null) {
		imagem.setTexto(cod_imagem, texto);
		gravou = "true";
	}
	else texto = imagem.getTexto(cod_imagem);
%>

<html>
<head>
<title>Texto da Imagem</title>
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
<script language="JavaScript">
	var gravou = "<%= gravou%>";
	function iniciar() {
		if(gravou=="true") self.close();
	}
</script>
	
</head>

<body onLoad="iniciar()">
<form name="frmcadastrar" action="textoimagem.jsp?cod=<%= cod_imagem%>" method="post">
	<table cellpadding="0" cellspacing="0" class="table"  width="100%">
		<tr>
			<td class="tdMedium" align="center">Texto da Imagem</td>
		</tr>
		<tr>
			<td class="tdLight"><textarea name="texto" id="texto" class="caixa" cols="45" rows="6"><%= texto%></textarea></td>
		</tr>
		<tr>
			<td class="tdMedium" align="center"><input type="submit" class="botao" value="Salvar"></td>
		</tr>
	</table>
</form>
</body>
</html>
