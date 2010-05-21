<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.Ajuda" id="ajuda" scope="page"/>

<html>
<head>
<title>Ajuda</title>
<link href="css/css.css" rel="stylesheet" type="text/css">
	
</head>

<body bgcolor="#FFFFFF">
	<%= ajuda.getAjuda(strcod)%>
</body>
</html>
