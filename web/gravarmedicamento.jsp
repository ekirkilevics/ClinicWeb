<%@page import="recursos.*" %>
<%@page import="java.sql.*" %>

<jsp:useBean class="recursos.Banco" id="banco" scope="page"/>

<%
	//Configuração
	String tabela = "medicamentos";
	String chave = "cod_comercial";
	String pagina = "medicamentos.jsp";
	String ret = "";

	//Parâmetros
	String acao = request.getParameter("acao");
	String id = request.getParameter("id");

	//Nome dos campos (form e tabela)
	String campos[]       = {"","comercial","farmaco","apresentacao","flag","cod_empresa"};
    String campostabela[] = {"cod_comercial","comercial","farmaco","apresentacao","flag","cod_empresa"};

	//Campos a validar
	int validar[] = {1,5};

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
		//Verifica registro duplicado
        boolean passou = banco.validaRegistro(tabela, chave, id, dados, campostabela, validar );

		//Se tiver, voltar com erro
		if(!passou) 
			response.sendRedirect(pagina + "?inf=7"); //Registro Duplicado
		else

		    //Se a ação for incluir
		    if(acao.equals("inc"))
			{
				ret = banco.gravarDados(tabela, dados, campostabela, (String)session.getAttribute("usuario"));
				if(ret.equals("OK"))
					response.sendRedirect(pagina + "?inf=1"); //Inserido com sucesso
				else
					response.sendRedirect(pagina + "?inf=" + ret); //Erro nas inserção
			}
		    //Senão, é alterar
		    else
			{
				ret = banco.alterarTabela(tabela, chave, id, dados, campostabela, (String)session.getAttribute("usuario"));
				if(ret.equals("OK"))
					response.sendRedirect(pagina + "?cod=" + id + "&inf=5"); //Alterado com sucesso
				else
					response.sendRedirect(pagina + "?inf=" + ret); //Erro na alteração
			}
	}
	else
	{
		ret = banco.excluirTabela(tabela, chave, id, (String)session.getAttribute("usuario"));
		if(ret.equals("OK"))
		   	response.sendRedirect(pagina + "?inf=3"); //Removido com sucesso
		else
			response.sendRedirect(pagina + "?inf=" + ret); //Erro na remoção
	}
%>
