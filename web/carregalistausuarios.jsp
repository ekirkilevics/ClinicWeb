<%@page contentType="text/xml"%>
<%@page pageEncoding="UTF-8"%>
<%@page import="recursos.*" %>
<%@page import="java.util.Vector" %>

<jsp:useBean class="recursos.Usuario" id="usuario" scope="page"/>

<%
    response.setHeader("Cache-Control", "no-cache");
    response.setHeader("Pragma", "no-cache");

    Vector lista = (Vector)application.getAttribute("codigos");
	out.println(usuario.getUsuariosLogados(lista));
%>