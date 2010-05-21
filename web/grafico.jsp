<%@page import="recursos.*" %>
<%@page import="java.lang.*" %>
<%
    String codcli = request.getParameter("codcli");
    String cod_exame = request.getParameter("cod_exame");

	Grafico graf = new Grafico();
	byte[] bytes = graf.gerarGrafico(cod_exame, codcli, response, 580, 300);
	response.setContentLength(bytes.length);  
	response.getOutputStream().write(bytes);  
	response.getOutputStream().flush();  
	response.getOutputStream().close();  
%>

