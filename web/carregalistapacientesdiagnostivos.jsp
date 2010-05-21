<%@page contentType="text/xml"%>
<%@page pageEncoding="UTF-8"%>
<%@page import="recursos.*" %>
<%@page import="java.util.Vector" %>

<jsp:useBean class="recursos.Banco" id="banco" scope="page"/>

<%
    response.setHeader("Cache-Control", "no-cache");
    response.setHeader("Pragma", "no-cache");

	//Recebendo parâmetros
	String cod_diag = request.getParameter("cod_diag");
	String de  = request.getParameter("de");
	String ate = request.getParameter("ate");
		
	Vector resp = banco.getItensAjaxPacientesDiagnosticos(cod_diag, de, ate);
	for(int i=0; i<resp.size(); i++)
		out.println(resp.get(i).toString());
%>