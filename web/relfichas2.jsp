<%@include file="cabecalho.jsp" %>
<%@page import="java.util.Vector" %>

<jsp:useBean class="recursos.FichaAtendimento" id="ficha" scope="page"/>
<jsp:useBean class="recursos.Paciente" id="paciente" scope="page"/>

<%			
	String info[] = new String[8];
	info[0] = request.getParameter("codcli");
	info[1] = request.getParameter("tipoficha");
	if(!Util.isNull(info[0])) {
		String dadospaciente[] = paciente.getDadosPaciente(info[0]);
		info[2] = dadospaciente[0];
	}
	info[3] = Util.getIdade(info[2]);
	info[4] = request.getParameter("data");
	info[5] = request.getParameter("codexame");
	info[6] = request.getParameter("dataexame");
	info[7] = cod_empresa;



%>
<html>
<head>
<title>Ficha de Atendimento</title>
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
<script language="JavaScript">
	var nascimento = "<%= info[2]%>";

	function setIdade()
	{	
		cbeGetElementById("idade").innerHTML = getIdade(nascimento);
	}
</script>

</head>

<body style="background-color:white" onLoad="setIdade()">
	<b><pre class="texto" style="text-align:center"><%= configuracao.getItemConfig("cabecalho", cod_empresa) %></pre></b>
	<br>
		<%= ficha.getFicha(info)%>
	<br>
</body>
</html>
