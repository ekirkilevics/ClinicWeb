<%@include file="cabecalho.jsp" %>
<%
	String prof_logado = banco.getProfissional((String)session.getAttribute("usuario"));
	String tamanho = "";
	if(Util.isNull(prof_logado)) {
		tamanho = "100%,30";
	}
	else {
		tamanho = "70%, *, 30";
	}
%>
<html>
<head>
<title>..:: Clinic Web ::..</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="shortcut icon" href="images/cw.ico" />
<script Language="Javascript">
	window.onbeforeunload=fechouJanela;
	

	function fechouJanela() {
window.open('fechar.jsp','fechar','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,width=200,height=50,top=10,left=10');
	}

</script>
</head>

<frameset cols="150,*" frameborder="NO" border="0" framespacing="0">
  <frameset rows="<%= tamanho%>" frameborder="NO" border="0" framespacing="0">
    <frame src="menu.jsp" name="leftFrame" id="leftFrame" scrolling="AUTO" noresize>
    <%
         if(!Util.isNull(prof_logado)) {
    %>    
           <frame src="frameagenda.jsp" name="agenda" id="agenda" scrolling="AUTO" noresize>
    <%
         }
    %>
    <frame src="online.jsp" name="leftFrame" id="leftFrame" scrolling="AUTO" noresize>
  </frameset>
  <frame src="inicio.jsp" name="mainFrame" id="mainFrame">
</frameset>

<noframes>
<body>

</body></noframes>
</html>
