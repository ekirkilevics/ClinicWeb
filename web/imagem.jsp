<%@include file="cabecalho.jsp" %>
<%
	String img = request.getParameter("img");
%>
<html>
<head>
<title>Imagem</title>
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
<script language="JavaScript">

	function redimensiona(valor)
	{
		var img = cbeGetElementById("imagem").style;

		if(valor == "outro") {
			cbeGetElementById("idcustomzoom").style.visibility = 'visible';
		}
		else {
			cbeGetElementById("idcustomzoom").style.visibility = 'hidden';
			cbeGetElementById("customzoom").value = "";
			img.width = valor + "%";
		}
	}
	
	function iniciar()
	{
		 var img = cbeGetElementById("imagem").style;
		self.resizeTo(700,500);			  
	}
	
	function ajusta(valor)
	{
		var img = cbeGetElementById("imagem").style;
		var customzoom = cbeGetElementById("customzoom").value;
		
		img.width = customzoom + "%";
	}
</script>
</head>
<body onLoad="iniciar()">
	<table width="100%" cellpadding="0" cellspacing="0" class="table">
		<tr>
			<td class="tdMedium">Zoom (%):</td>
			<td class="tdLight">
				<select name="zoom" id="zoom" class="caixa" onChange="redimensiona(this.value)">
					<option value="25">25%</option>
					<option value="50">50%</option>
					<option value="75">75%</option>
					<option value="100" selected>100%</option>
					<option value="150">150%</option>
					<option value="200">200%</option>
					<option value="outro">Outro</option>
				</select>			
				<span id="idcustomzoom" style="visibility:hidden">
					<input type="text" name="customzoom" id="customzoom" class="caixa" size="3" maxlength="3">
					<input type="button" class="botao" value="OK" onClick="ajusta()">
				</span>
			</td>
		</tr>
	</table>

	<center>
		<img name="imagem" id="imagem" src="<%= img%>" border="0" width="100%">
	</center>
</body>
</html>
