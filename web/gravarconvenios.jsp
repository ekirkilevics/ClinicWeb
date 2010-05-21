<%@page import="recursos.*" %>
<%@page import="java.sql.*" %>

<jsp:useBean class="recursos.Banco" id="banco" scope="page"/>

<%
	String acao = request.getParameter("acao");
	String id = request.getParameter("id");
	String codcli = request.getParameter("codcli");
	String aba = request.getParameter("numeroaba");
	
	String pagina = "pacientes.jsp?numeroaba=" + aba + "&cod=" + codcli;
	
	//se for exclusão
	if(acao.equals("exc")) {
		
		String sql = "DELETE FROM paciente_convenio WHERE cod_pac_conv=" + id;
		String ret = banco.executaSQL(sql);

		if(ret.equals("OK"))
			response.sendRedirect(pagina + "&inf=Convenio%20Removido%20com%20Sucesso"); //Sucesso
		else
			response.sendRedirect(pagina + "&inf=" + ret); //Erro nas inserção
	
	}
	
%>