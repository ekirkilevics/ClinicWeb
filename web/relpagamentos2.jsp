<%@include file="cabecalho.jsp" %>
<%@page import="java.util.Vector" %>

<jsp:useBean class="recursos.Relatorio" id="relatorio" scope="page"/>

<%			
	String de  = request.getParameter("de");
	String ate = request.getParameter("ate");
	String tipopagto = request.getParameter("tipopagto");
	String cheque = request.getParameter("cheque");

	String nome_relatorio = "";
	
	//Verifica o nome do relatório 
	if(tipopagto.equals("todos")) nome_relatorio = "Recebimentos de Particulares";
	if(tipopagto.equals("1")) nome_relatorio = "Recebimentos de Particulares (Dinheiro)";
	if(tipopagto.equals("2")) nome_relatorio = "Recebimentos de Particulares (Cheque)";
	if(tipopagto.equals("3")) nome_relatorio = "Recebimentos de Particulares (Cartão)";
	if(tipopagto.equals("4")) nome_relatorio = "Recebimentos de Particulares (Convênios)";
		
%>
<html>
<head>
<title>Lançamentos Financeiros</title>
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
</head>

<body style="background-color:white">
	<center>
	<b><pre class="texto" style="text-align:center"><%= configuracao.getItemConfig("cabecalho", cod_empresa) %></pre></b>
	<br>
	<div class="texto"><b><%= nome_relatorio%></b><br>Período de <%= de%> até <%= ate%></div>	
	<br>
	<%
		if(de != null && ate != null) {
			Vector resp = relatorio.getPagamentos(de, ate, tipopagto, cheque, cod_empresa);
			for(int i=0; i<resp.size(); i++)
				out.println(resp.get(i).toString());
		}
	%>
	<br>
	</center>
</body>
</html>
