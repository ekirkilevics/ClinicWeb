<%@page import="recursos.*" %>
<%@page import="java.lang.*" %>
<%
    String cod_audiometria = request.getParameter("cod");
	GraficoAudiometria graf = new GraficoAudiometria();
	byte[] bytes = graf.gerarGrafico(cod_audiometria, "E", response, 300, 250);
	response.setContentLength(bytes.length);  
	response.getOutputStream().write(bytes);  
	response.getOutputStream().flush();  
	response.getOutputStream().close();  
%>