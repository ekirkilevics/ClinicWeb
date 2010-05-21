<%@page import="recursos.*" %>
<%@page import="java.sql.*" %>

<jsp:useBean class="recursos.Banco" id="banco" scope="page"/>

<%
	String acao = request.getParameter("acao");
	String nomebanco = request.getParameter("banco");
	String agencia = request.getParameter("agencia");
	String conta = request.getParameter("conta");
	String id = request.getParameter("id");
	
	String pagina = "perfil.jsp";
	
	//Se for para incluir
	if(acao.equals("inc")) {
		String novo_cod = banco.getNext("bancos", "cod_banco" );
		String sql = "INSERT INTO bancos(cod_banco, cod_empresa, banco, agencia, conta) VALUES(" + novo_cod + "," + (String)session.getAttribute("codempresa");
		sql += ",'" + nomebanco + "','" + agencia + "','" + conta + "')";
		String ret = banco.executaSQL(sql);
		
		if(ret.equals("OK"))
			response.sendRedirect(pagina + "?inf=Banco%20Inserido%20com%20Sucesso"); //Sucesso
		else
			response.sendRedirect(pagina + "?inf=" + ret); //Erro nas inserção
		
	}
	//se for exclusão
	else if(acao.equals("exc")) {
		
		String sql = "DELETE FROM bancos WHERE cod_banco=" + id;
		String ret = banco.executaSQL(sql);

		if(ret.equals("OK"))
			response.sendRedirect(pagina + "?inf=Banco%20Removido%20com%20Sucesso"); //Sucesso
		else
			response.sendRedirect(pagina + "?inf=" + ret); //Erro nas inserção
	
	}
	
%>