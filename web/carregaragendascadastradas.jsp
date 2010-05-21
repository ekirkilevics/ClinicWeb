<%@page contentType="text/xml"%>
<%@page pageEncoding="UTF-8"%>
<%@page import="recursos.*" %>

<jsp:useBean class="recursos.AgendaPessoal" id="agendapessoal" scope="page"/>

<%
    response.setHeader("Cache-Control", "no-cache");
    response.setHeader("Pragma", "no-cache");

	//Recebendo parâmetros
	String mes = request.getParameter("mes") != null ? request.getParameter("mes") : Util.getMes(Util.getData());
	String ano = request.getParameter("ano") != null ? request.getParameter("ano") : Util.getAno(Util.getData());
		
	out.println("<agendapessoal>");
	out.println(agendapessoal.getAgendasPessoaisCadastradas(mes, ano, (String)session.getAttribute("usuario")));
	out.println("</agendapessoal>");
%>