<%@page pageEncoding="UTF-8"%>
<%@page import="recursos.*" %>

<jsp:useBean class="recursos.AgendaPessoal" id="agendapessoal" scope="page"/>

<%
    response.setHeader("Cache-Control", "no-cache");
    response.setHeader("Pragma", "no-cache");

	//Recebendo parâmetros
	String data = request.getParameter("data") != null ? request.getParameter("data") : "";
		
	out.println(agendapessoal.getAgendasPessoais((String)session.getAttribute("usuario"), data));
%>