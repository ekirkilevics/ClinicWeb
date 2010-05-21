<%@page import="recursos.*" %>
<%@page import="java.sql.*" %>

<jsp:useBean class="recursos.Banco" id="banco" scope="page"/>

<%
	//Configuração
	String tabela = "configuracoes";
	String chave = "config_id";
	String pagina = "email.jsp";
	String ret = "";

	//Parâmetros
	String acao = request.getParameter("acao");
	String id = request.getParameter("id");

	//Nome dos campos (form e tabela)
	String campos[]       = {"","smtp","usuario","senha", "emailorigem", "nomeorigem", "aut"};
    String campostabela[] = {"config_id","smtp","usuarioemail","senhaemail", "emailorigem", "nomeorigem","autenticacao"};

	//Vetor de dados que vai ser preenchido
	String dados[] = new String[campos.length];

	//Captura os dados dos campos (exceto código que será auto-numérico)
	for(int i=1; i<campos.length; i++)	
		dados[i] = request.getParameter(campos[i]);
	
	if(dados[6] == null || dados[6].equals("")) dados[6] = "0";

	//Captura o valor do próximo índice numérico e coloca no vetor de dados
	dados[0] = banco.getNext(tabela, chave );
	
	//Se não for exclusão, verificar se é registro duplicado
	if(!acao.equals("exc"))
	{
			ret = banco.alterarTabela(tabela, chave, id, dados, campostabela,  (String)session.getAttribute("usuario"));
			if(ret.equals("OK"))
	    		response.sendRedirect(pagina + "?cod=" + id + "&inf=5"); //Alterado com sucesso
			else
				response.sendRedirect(pagina + "?inf=" + ret); //Erro na alteração
	}
%>
