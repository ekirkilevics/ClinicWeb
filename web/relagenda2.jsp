<%@include file="cabecalho.jsp" %>
<%@page import="java.util.Vector" %>

<jsp:useBean class="recursos.Relatorio" id="relatorio" scope="page"/>

<%			
	String de  = request.getParameter("de");
	String ate = request.getParameter("ate");
	String prof_reg = request.getParameter("prof_reg");
	String procedimento = request.getParameter("procedimento");
	String cod_convenio = request.getParameter("cod_convenio");
	String statusagenda = request.getParameter("statusagenda");
	String camposAgenda[] = request.getParameterValues("campos");
	String cabecalho = request.getParameter("cabecalho");
	String primeiravez = request.getParameter("primeiravez");

	//Se escolheu os campos da agenda, guardar na sessão
	if(camposAgenda != null) {
	
		//Guarda na sessão
		session.setAttribute("camposAgenda", camposAgenda);
	
		//Criar cookie com a escolha de campos para a próxima vez
		Cookie c = new Cookie("camposRelAgenda", Util.vetorToString(camposAgenda));
		//Cookie expira em 1 ano
		c.setMaxAge(365*24*60*60);
		//Guarda o cookie
		response.addCookie(c);
	}
	else {
		//Se for refresh, recuperar os campos da sessão
		camposAgenda = (String[])session.getAttribute("camposAgenda");
	}
	
	if(Util.isNull(ordem))
		ordem = "data ASC, hora ASC";

%>
<html>
<head>
<title>Relatório de Agendamentos</title>
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
</head>

<body style="background-color:white">
	<center>
	<b><pre class="texto" style="text-align:center"><%= configuracao.getItemConfig("cabecalho", cod_empresa) %></pre></b>
	<br>
	<div class="texto"><b>Relatório de Agendamentos</b><br>Período de <%= de%> até <%= ate%></div>	
	<br>
	<form name="frmcadastrar" id="frmcadastrar" action="relagenda2.jsp" method="post">
		<input type="hidden" name="de" value="<%= de%>">
		<input type="hidden" name="ate" value="<%= ate%>">
		<input type="hidden" name="prof_reg" value="<%= prof_reg%>">
		<input type="hidden" name="procedimento" value="<%= procedimento%>">
        <input type="hidden" name="cod_convenio" value="<%= cod_convenio%>">
		<input type="hidden" name="statusagenda" value="<%= statusagenda%>">
        <input type="hidden" name="cabecalho" value="<%= cabecalho%>">
        <input type="hidden" name="primeiravez" value="<%= primeiravez%>">
		
	<table width="98%" border="0" cellpadding="0" cellspacing="0" style="background-color:white;border: 0px; border-top: 1px solid #CCCCCC;	border-left: 1px solid #CCCCCC;">
	<%
		if(de != null && ate != null) {
			Vector resp = relatorio.getRelatorioAgendamentos(de, ate, prof_reg, procedimento, statusagenda, ordem, camposAgenda, cod_convenio, cabecalho, primeiravez);
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
