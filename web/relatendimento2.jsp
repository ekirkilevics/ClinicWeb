<%@include file="cabecalho.jsp" %>
<%@page import="java.util.Vector" %>

<jsp:useBean class="recursos.Relatorio" id="relatorio" scope="page"/>

<%			
	String de  = request.getParameter("de");
	String ate = request.getParameter("ate");
	String agrupar = request.getParameter("agrupar");

	/*
	 * 	filtros[0]= Executante
	 *	filtros[1]= Solicitante
	 *	filtros[2]= Paciente
	 *  filtros[3]= Especialidade
	 *	filtros[4]= Convênio
	 *  filtros[5] = Tipo de Solicitante
	 *  filtros[6] = Procedimento
	*/
	String filtros[] = new String[7];
	filtros[0] = request.getParameter("executante");
	filtros[1] = !Util.isNull(request.getParameter("prof_reg")) ? request.getParameter("prof_reg") : "todos";
	filtros[2] = !Util.isNull(request.getParameter("codcli")) ? request.getParameter("codcli") : "todos";
	filtros[3] = request.getParameter("especialidade");
	filtros[4] = !Util.isNull(request.getParameter("cod_convenio")) ? request.getParameter("cod_convenio") : "todos";
	filtros[5] = request.getParameter("tiposolicitante");
	filtros[6] = !Util.isNull(request.getParameter("COD_PROCED")) ? request.getParameter("COD_PROCED") : "todos";

	String nome_relatorio = "";
	
	//Verifica o nome do relatório pelo campo a agrupar
	if(agrupar.equals("Executante.nome")) nome_relatorio = "Relatório por Executante";
	if(agrupar.equals("Solicitante.nome")) nome_relatorio = "Relatório por Solicitante";
	if(agrupar.equals("faturas.Data_Lanca,faturas.hora_lanca")) nome_relatorio = "Relatório por Data";
	if(agrupar.equals("paciente.nome")) nome_relatorio = "Relatório por Paciente";
	if(agrupar.equals("procedimentos.Procedimento")) nome_relatorio = "Relatório por Procedimento";
	if(agrupar.equals("especialidade.descri")) nome_relatorio = "Relatório por Especialidade";
	if(agrupar.equals("convenio.descr_convenio")) nome_relatorio = "Relatório por Convênio";
		
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
	<table width="98%" border="0" cellpadding="0" cellspacing="0" style="background-color:white;border: 0px; border-top: 1px solid #CCCCCC;	border-left: 1px solid #CCCCCC;">
	<%
		if(de != null && ate != null) {
			Vector resp = relatorio.getAtendimentos(de, ate, agrupar, filtros);
			for(int i=0; i<resp.size(); i++)
				out.println(resp.get(i).toString());
		}
	%>
	</table>
	<br>
	</center>
</body>
</html>
