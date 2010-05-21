<%@page pageEncoding="UTF-8"%>
<%@page import="recursos.*" %>

<jsp:useBean class="recursos.Medicamento" id="medicamento" scope="page"/>

<%
    response.setHeader("Cache-Control", "no-cache");
    response.setHeader("Pragma", "no-cache");

	//Recebendo parâmetros
	String cod = request.getParameter("cod");
	String prof_reg = request.getParameter("prof_reg");
	out.clear();
	out.println(medicamento.getIndicacaoMedicamento(cod, prof_reg));	
%>