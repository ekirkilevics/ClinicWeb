<%@page contentType="text/xml"%>
<%@page pageEncoding="UTF-8"%>
<%@page import="recursos.*" %>

<jsp:useBean class="recursos.Protocolo" id="protocolo" scope="page"/>

<%
    response.setHeader("Cache-Control", "no-cache");
    response.setHeader("Pragma", "no-cache");

	//Recebendo parâmetros
	String cod_protocolo = request.getParameter("cod_protocolo");
	String codcli = request.getParameter("codcli");
		
	//Imprime resposta
	out.println(protocolo.getDatasProtocolo(cod_protocolo, codcli));
%>