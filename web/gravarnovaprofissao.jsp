<%@page import="recursos.*" %>
<%@page import="java.sql.*" %>

<jsp:useBean class="recursos.Paciente" id="paciente" scope="page"/>
<%
	String descr = request.getParameter("novaprofissao");
	String novocodigo = paciente.insereProfissao(descr, (String)session.getAttribute("codempresa"));
%>
<html>
<head>
<script language="JavaScript">
	var cod = "<%= novocodigo%>";
	var desc = "<%= descr%>";
	function iniciar() {
		window.parent.document.frmcadastrar.profissao.value = "(" + cod + ") " + desc
		window.parent.document.frmcadastrar.codCBOS.value = cod;
	}
</script>
</head>
<body onLoad="iniciar()">
</body>
</html>
