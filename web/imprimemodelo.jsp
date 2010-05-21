<jsp:useBean class="recursos.Modelos" id="modelo" scope="page"/>
<%
	String modelohtml = request.getParameter("modelohide");
	String cod_hist = request.getParameter("cod_hist");
	String tipomodelo = request.getParameter("tipomodelo");
	String retorno = modelo.atualizaTexto(modelohtml, cod_hist, tipomodelo);
	out.println(modelohtml);
%>
<html>
<title></title>
<head>
<body onLoad="self.print()"></body>
</html>