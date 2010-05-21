<%@include file="cabecalho.jsp" %>
<%
	String numeroGuia = request.getParameter("numeroGuiaPrestador");
	String tipoGuia = request.getParameter("tipoGuia");
	
	//Se for honorário individual
	if(tipoGuia.equals("3")) {
		String sql = "UPDATE guiashonorarioindividual SET numeroGuiaPrestador=" + numeroGuia + " WHERE cod_honorario=" + strcod;
		out.println(banco.executaSQL(sql));
	}
	//Senão, é resumo de internação
	else {
		String sql = "UPDATE guiasresumointernacao SET numeroGuiaPrestador=" + numeroGuia + " WHERE cod_resumointernacao=" + strcod;
		out.println(banco.executaSQL(sql));
	}
%>