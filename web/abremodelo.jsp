<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.Modelos" id="modelo" scope="page"/>
<%
	String codcli 		= request.getParameter("codcli");
	String cod_modelo 	= request.getParameter("modelos");
	String nome 		= request.getParameter("nome");
	String modelohtml 	= Util.freeRTE_Preload(modelo.getModelo(cod_modelo, codcli, cod_empresa));
	String print = request.getParameter("print");
	

%>
<html>
<title></title>
<head>
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
<script src="js/richtext.js" type="text/javascript" language="javascript"></script>
<script src="js/config.js" type="text/javascript" language="javascript"></script>

<script language="JavaScript">

	var jsnovo = "<%= codcli%>";
	var jsnome = "<%= nome%>";

	function iniciar() {
	<%
		if(print != null && print.equals("S")) {
	%>
		var pai = window.opener;
		self.print();
		if(pai.document.title != "Pacientes") //Só atualiza a página pai se não for de pacientes
			pai.location = pai.location + "?codcli=" + jsnovo + "&nome=" + jsnome;

	<%
		} else {
	%>
		self.resizeTo(600,500);
	<%
		}
	%>
	}
	
	
	function imprimir() {
		var frm = cbeGetElementById("frmcadastrar");
		cbeGetElementById("modelohide").value = document.getElementById(rteName).contentWindow.document.body.innerHTML;		
		frm.action = "abremodelo.jsp?print=S";
		frm.submit();
	}

</script>
</head>
<body onLoad="iniciar()" style="background-color:white">
<%
	if(print != null && print.equals("S")) {
		out.println(request.getParameter("modelohide"));
	} else {
%>
	<form name="frmcadastrar"  id="frmcadastrar" method="post" action="#">
		<input type="hidden" name="modelohide" id="modelohide" value='<%= modelohtml%>'>
		<!-- AQUI Text Editor -->
		<script>
		initRTE('<%= modelohtml%>', 'css/example.css');
		</script>
		<center>
			<button class="botao" onClick="imprimir()" style="width:200px"><img src="images/print.gif"> Imprimir Modelo</button>
		</center>		
	</form>				
<%
	}
%>
</body>
</html>