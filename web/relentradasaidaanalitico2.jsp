<%@include file="cabecalho.jsp" %>
<%@page import="java.util.Vector" %>

<jsp:useBean class="recursos.Atendimento" id="atendimento" scope="page"/>
<%
	String de = request.getParameter("de");
	String ate = request.getParameter("ate");
	if(Util.isNull(ordem)) ordem = "codigo";
%>

<html>
<head>
<title>Relatório</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
<script language="JavaScript" src="js/ajax.js"></script>
<script language="JavaScript">
	function ordenar(campo) {
		var frm = cbeGetElementById("frmcadastrar");
		
		frm.action += "?ordem=" + campo;
		frm.submit();
	}
	
</script>

</head>

<body>
	<form name="frmcadastrar" id="frmcadastrar" action="relentradasaidaanalitico2.jsp" method="post">
	  <input type="hidden" name="de" value="<%= de%>">
	  <input type="hidden" name="ate" value="<%= ate%>">
      <div class="title">.: Relatório de Atendimentos Analítico:.</div>
		<center>
	  	<table cellpadding="0" cellspacing="0" width="100%">
		<%
			Vector resp = atendimento.getRelAtendimentosAnalitico(de, ate, ordem);
			for(int i=0; i<resp.size(); i++)
				out.println(resp.get(i).toString());
		%>
		</table>
		</center>
	</form>
</body>
</html>
