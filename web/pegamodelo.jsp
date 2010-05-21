<%@page pageEncoding="UTF-8"%>
<%@page import="recursos.*" %>

<jsp:useBean class="recursos.Banco" id="banco" scope="page"/>

<%
    response.setHeader("Cache-Control", "no-cache");
    response.setHeader("Pragma", "no-cache");

	//Recebendo parâmetros
	String cod_modelo = request.getParameter("cod_modelo");
	String modelo = Util.freeRTE_Preload(banco.getValor("modelo", "SELECT modelo FROM modelos WHERE cod_modelo=" + cod_modelo));
	out.clear();
	out.println(modelo);	
%>