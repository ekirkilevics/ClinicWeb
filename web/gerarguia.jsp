<%@include file="cabecalho.jsp" %>
<jsp:useBean class="recursos.TISS" id="tiss" scope="page"/>

<%
	String codcli = request.getParameter("codcli");
	String data = request.getParameter("data");
%>


<html>
<head>
<title>Faturamento</title>
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
</head>
<body>
	<%
		if(!Util.isNull(codcli) && !Util.isNull(data)) 
			out.println(tiss.getGuias(codcli, data, cod_empresa, nome_usuario));
		else
			out.println(tiss.getGuias(strcod, cod_empresa, nome_usuario));
	%>
</body>
</html>
