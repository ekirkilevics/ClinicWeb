<%@page contentType="text/xml"%>
<%@page pageEncoding="UTF-8"%>
<%@page import="recursos.*" %>
<%@page import="java.util.Vector" %>

<jsp:useBean class="recursos.Mensagem" id="mensagem" scope="page"/>

<%
    response.setHeader("Cache-Control", "no-cache");
    response.setHeader("Pragma", "no-cache");
	out.clear();
	out.println(mensagem.getMensagens((String)session.getAttribute("usuario")));
%>