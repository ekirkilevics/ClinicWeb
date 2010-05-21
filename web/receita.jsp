<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.Modelos" id="modelo" scope="page"/>
<%
	/*
	 *	param[0] = codcli
	 *	param[1] = prof_reg
	 *	param[2] = cod_hist
	 *  param[3] = tipomodelo
	 *  param[4] = cod_modelo
	*/
	//Parâmetros que vieram da história
	String param[] = new String[5];
	param[0] = request.getParameter("codcli");
	param[1] = request.getParameter("prof_reg");
	param[2] = request.getParameter("cod_hist");
	param[3] = request.getParameter("tipomodelo");
	param[4]  = request.getParameter("modelos");

	//Guarda os parâmetros originais para reenviar
	String querystring = request.getQueryString();
	String cod_hist = param[2];
	
	String htmlmodelo = Util.freeRTE_Preload(modelo.getModelo(param, cod_empresa));


%>

<html>
<head>
<title>..:: Receita ::..</title>
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
<script src="js/richtext.js" type="text/javascript" language="javascript"></script>
<script src="js/config.js" type="text/javascript" language="javascript"></script>

<script language="JavaScript">
    //id do convênio
     var idReg = "<%= strcod%>";
	 //Informação vinda de gravarconvenio
	 var inf = "<%= inf%>";
	 
	 function abrirmodelo() {
	 	var frm = cbeGetElementById("frmcadastrar");
 	    var jsmodelo = cbeGetElementById("modelos").value;
		
		if(jsmodelo == "") {
			alert("Escolha um modelo para impressão.");
			return;
		}
		
		frm.action = "receita.jsp?<%= querystring%>&cod_modelo=" + jsmodelo;
		frm.submit();
	 }

	function imprimir() {
		var frm = cbeGetElementById("frmcadastrar");
		cbeGetElementById("modelohide").value = document.getElementById(rteName).contentWindow.document.body.innerHTML;
		frm.action = "imprimemodelo.jsp?cod_hist=<%= param[2]%>";
		frm.submit();
	}
	
	function iniciar() {
		cbeGetElementById("modelos").value = "<%= param[4]%>";;
	}

	 
</script>
</head>

<body style="background-color: white" onLoad="iniciar()">
<form name="frmcadastrar" id="frmcadastrar" action="#" method="post">
	<input type="hidden" name="tipomodelo" id="tipomodelo" value="<%= param[3]%>">
	<table width="100%" cellpadding="0" cellspacing="0">
		<tr>
			<td class="tdMedium">Modelo:</td>
			<td class="tdLight">
				<select name="modelos" id="modelos" class="caixa">
					<%= modelo.getListaModelos(cod_hist, param[3], cod_empresa)%>
				</select>
			</td>
			<td class="tdMedium"><input type="button" class="botao" value="OK" onClick="abrirmodelo()"></td>
		</tr>
	</table>
	<br>
	<% 
		if(!Util.isNull(param[4])) { 
	%>
					<input type="hidden" name="modelohide" id="modelohide" value='<%= htmlmodelo%>'>
					<!-- AQUI Text Editor -->
					<script>
					initRTE('<%= htmlmodelo%>', 'css/example.css');
					</script>
		<br>
		<button type="button" class="botao" onClick="imprimir()"><img src="images/10.gif">&nbsp;&nbsp;&nbsp;Imprimir</button>
	
	<% } %>
</form>
</body>
</html>
