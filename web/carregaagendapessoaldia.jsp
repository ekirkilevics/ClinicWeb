<%@page pageEncoding="UTF-8"%>
<%@page import="recursos.*" %>

<jsp:useBean class="recursos.AgendaPessoal" id="agendapessoal" scope="page"/>

<%
    response.setHeader("Cache-Control", "no-cache");
    response.setHeader("Pragma", "no-cache");
	out.clear();
	out.println(agendapessoal.getAgendasPessoaisDia((String)session.getAttribute("usuario")));
%>