<%@page import="recursos.*" %>
<%@page import="java.sql.*" %>

<jsp:useBean class="recursos.Banco" id="banco" scope="page"/>

<%
	//Configuração
	String tabela = "configuracoes";
	String chave = "config_id";
	String pagina = "coresefontes.jsp";
	String ret = "";

	//Parâmetros
	String acao = request.getParameter("acao");
	String id = request.getParameter("id");

	//Nome dos campos (form e tabela)
	String campos[]       = {"","tdlight","tdmedium","tddark","fundo", "cortitulo","corfonte","cormsg","corcaixa","cod_empresa"};
    String campostabela[] = {"config_id","tdlight","tdmedium","tddark","fundo", "cortitulo","corfonte","cormsg", "corcaixa","cod_empresa"};

	//Vetor de dados que vai ser preenchido
	String dados[] = new String[campos.length];

	//Captura os dados dos campos (exceto código que será auto-numérico)
	for(int i=1; i<campos.length; i++)	
		dados[i] = request.getParameter(campos[i]);
	
	//Captura o valor do próximo índice numérico e coloca no vetor de dados
	dados[0] = banco.getNext(tabela, chave );
	
	//Coloca o código da empresa da sessão no último campo
	dados[dados.length-1] = (String)session.getAttribute("codempresa");

	//Se não for exclusão, verificar se é registro duplicado
	if(!acao.equals("exc"))
	{
			ret = banco.alterarTabela(tabela, chave, id, dados, campostabela, (String)session.getAttribute("usuario"));
			if(ret.equals("OK"))
	    		response.sendRedirect(pagina + "?cod=" + id + "&inf=5"); //Alterado com sucesso
			else
				response.sendRedirect(pagina + "?inf=" + ret); //Erro na alteração
	}
%>
