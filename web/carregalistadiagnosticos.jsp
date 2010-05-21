<%@page contentType="text/xml"%>
<%@page pageEncoding="UTF-8"%>
<%@page import="recursos.*" %>
<%@page import="java.util.Vector" %>

<jsp:useBean class="recursos.Banco" id="banco" scope="page"/>

<%
    response.setHeader("Cache-Control", "no-cache");
    response.setHeader("Pragma", "no-cache");

	//Recebendo parâmetros
	String query = request.getParameter("q") != null ? request.getParameter("q") : "";
	String seq = request.getParameter("seq") != null ? request.getParameter("seq") : "";
		
	Vector resp = banco.getItensAjaxDiagnosticos(query, seq, (String)session.getAttribute("codempresa"));
	for(int i=0; i<resp.size(); i++)
		out.println(resp.get(i).toString());
%>