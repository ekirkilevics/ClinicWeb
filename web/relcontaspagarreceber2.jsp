<%@include file="cabecalho.jsp" %>
<%@page import="java.util.Vector" %>

<jsp:useBean class="recursos.Conta" id="conta" scope="page"/>

<%			
	String de  = request.getParameter("de");
	String ate = request.getParameter("ate");
	String cp_pagar = request.getParameter("cp_pagar");
	String cp_pagos = request.getParameter("cp_pagos");
	String cr_receber = request.getParameter("cr_receber");
	String cr_recebidos = request.getParameter("cr_recebidos");
	
	if(Util.isNull(ordem)) ordem = "data";
%>
<html>
<head>
<title>Relatório de Fluxo de Caixa</title>
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
</head>

<body style="background-color:white">
	<center>
	<b><pre class="texto" style="text-align:center"><%= configuracao.getItemConfig("cabecalho", cod_empresa) %></pre></b>
	<br>
	<div class="texto"><b>Fluxo de Caixa</b><br>Período de <%= de%> até <%= ate%></div>	
	<br>
	<form name="frmcadastrar" id="frmcadastrar" action="relagenda2.jsp" method="post">
		<input type="hidden" name="de" value="<%= de%>">
		<input type="hidden" name="ate" value="<%= ate%>">
		<input type="hidden" name="cp_pagar" value="<%= cp_pagar%>">
		<input type="hidden" name="cp_pagos" value="<%= cp_pagos%>">
        <input type="hidden" name="cr_receber" value="<%= cr_receber%>">
		<input type="hidden" name="cr_recebidos" value="<%= cr_recebidos%>">
		
	<table width="98%" border="0" cellpadding="0" cellspacing="0" style="background-color:white;border: 0px; border-top: 1px solid #CCCCCC;	border-left: 1px solid #CCCCCC;">
	<%
		if(de != null && ate != null) {
			Vector resp = conta.getRelFluxoCaixa(de, ate, cp_pagar, cp_pagos, cr_receber, cr_recebidos, ordem);
			for(int i=0; i<resp.size(); i++)
				out.println(resp.get(i).toString());
		}
	%>
	</table>
	</form>
	<br>
	</center>
    
<%@include file="tamanhofontes.jsp" %>
</body>
</html>
