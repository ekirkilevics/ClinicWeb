<%@page import="recursos.*" %>
<%@page import="java.sql.*" %>

<jsp:useBean class="recursos.Banco" id="banco" scope="page"/>
<jsp:useBean class="recursos.Convenio" id="convenio" scope="page"/>

<%
	String acao = request.getParameter("acao");
	String id = request.getParameter("id");
	String cod_convenio = request.getParameter("cod");
	String plano = request.getParameter("plano");
	String aba = request.getParameter("numeroaba");
	String pagina = "convenios.jsp?numeroaba=" + aba + "&cod=" + cod_convenio;
	
	//Se for para incluir
	if(acao.equals("inc")) {
		String novo_cod_plano = banco.getNext("planos", "cod_plano" );
		String sql = "INSERT INTO planos(cod_plano, cod_convenio, plano) VALUES(" + novo_cod_plano + "," + cod_convenio + ",'" + plano + "')";
		String ret = banco.executaSQL(sql);
		
		if(ret.equals("OK"))
			response.sendRedirect(pagina + "&inf=Plano%20Inserido%20com%20Sucesso"); //Sucesso
		else
			response.sendRedirect(pagina + "&inf=" + ret); //Erro nas inserção
		
	}
	//se for exclusão
	else if(acao.equals("exc")) {
		
		//Inativa os planos
		String sql = "UPDATE planos SET ativo='N' WHERE cod_plano=" + id;
		banco.executaSQL(sql);
		
		//Apaga os valores para esse plano
		sql = "DELETE FROM valorprocedimentos WHERE cod_plano=" + id;
		banco.executaSQL(sql);

		//Tira o plano dos pacientes colocando 'não definido'
		sql = "UPDATE paciente_convenio SET cod_plano=-1 WHERE cod_plano=" + id;
		String ret = banco.executaSQL(sql);

		if(ret.equals("OK"))
			response.sendRedirect(pagina + "&inf=Plano%20Removido%20com%20Sucesso"); //Sucesso
		else
			response.sendRedirect(pagina + "&inf=" + ret); //Erro nas inserção
		
	}
	
%>