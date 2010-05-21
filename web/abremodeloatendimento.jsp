<jsp:useBean class="recursos.Modelos" id="modelo" scope="page"/>
<%
	String codatend 		= request.getParameter("codatend");
	String cod_empresa 	= (String)session.getAttribute("codempresa");
	String cod_modelo = request.getParameter("modelos");
	String modelohtml 	= modelo.getModeloAtendimento(cod_modelo, codatend, cod_empresa);
	
	out.println(modelohtml);
%>
<html>
<title></title>
<script language="JavaScript">
	function iniciar() {
		self.resizeTo(500,600);
		self.print();
	}
</script>
<head>

</script>
</head>
<body onLoad="iniciar()"></body>
</html>