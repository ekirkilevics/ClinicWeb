<%@page pageEncoding="UTF-8"%>
<%@page import="recursos.*" %>

<jsp:useBean class="recursos.Ajuda" id="ajuda" scope="page"/>

<%
    response.setHeader("Cache-Control", "no-cache");
    response.setHeader("Pragma", "no-cache");

	//Recebendo parâmetros
	String cod_ajuda = request.getParameter("cod_ajuda") != null ? request.getParameter("cod_ajuda") : "";
		
	//Imprime a ajuda na tela
	out.println(ajuda.getAjuda(cod_ajuda));
%>