<%@page import="recursos.*" %>
<%@page import="java.sql.*" %>

<jsp:useBean class="recursos.Banco" id="banco" scope="page"/>
<jsp:useBean class="recursos.OutrasDespesas" id="outrasdespesas" scope="page"/>

<%
	//Configuração
	String tabela = "outrasdespesas";
	String chave = "cod_outrasdespesas";
	String pagina = "outrasdespesas.jsp";
	String ret = "";

	//Parâmetros
	String acao = request.getParameter("acao");
	String id = request.getParameter("id");

	//Nome dos campos (form e tabela)
	String campos[]       = {"","procedimento","cod_convenio", "cod_empresa"};
    String campostabela[] = {"cod_outrasdespesas", "cod_proced", "cod_convenio", "cod_empresa"};

	//Campos a validar
	int validar[] = {1,2};

	//Vetor de dados que vai ser preenchido
	String dados[] = new String[campos.length];

	//Captura os dados dos campos (exceto código que será auto-numérico)
	for(int i=1; i<campos.length; i++)	
		dados[i] = request.getParameter(campos[i]);
	
	//Captura o valor do próximo índice numérico e coloca no vetor de dados
	dados[0] = banco.getNext(tabela, chave );

	//Coloca o código da empresa da sessão no último campo
	dados[dados.length-1] = (String)session.getAttribute("codempresa");
	
	//Itens de outras despesas
	String cd = request.getParameter("cd");
	String cod_tabela = request.getParameter("tabela");
	String cod_item = request.getParameter("codigoitem");
	String descricao = request.getParameter("descricao");
	String valor = request.getParameter("valor");
	
	//Se não for exclusão, verificar se é registro duplicado
	if(!acao.equals("exc"))
	{
		//Verifica registro duplicado
        boolean passou = banco.validaRegistro(tabela, chave, id, dados, campostabela, validar);

		//Se tiver registro duplicado, voltar com erro
		if(!passou) 
			response.sendRedirect(pagina + "?inf=7"); //Registro Duplicado
		else

		    //Se a ação for incluir
		    if(acao.equals("inc"))
			{
				ret = banco.gravarDados(tabela, dados, campostabela, (String)session.getAttribute("usuario"));

				//Se retornou OK, efetuado com sucesso
				if(ret.equals("OK"))
				{
					outrasdespesas.insereItem(dados[0], cd, cod_tabela, cod_item, descricao, valor);
					response.sendRedirect(pagina + "?inf=1&cod=" + dados[0]); //Inserido com sucesso
				}
				//Se não vier OK, devolver o erro
				else
				{
					response.sendRedirect(pagina + "?inf=" + ret); //Erro nas inserção
				}
			}
		    //Senão, é alterar
		    else
			{
				ret = banco.alterarTabela(tabela, chave, id, dados, campostabela, (String)session.getAttribute("usuario"));
				if(ret.equals("OK")) {
					outrasdespesas.insereItem(id, cd, cod_tabela, cod_item, descricao, valor);
					response.sendRedirect(pagina + "?cod=" + id + "&inf=5"); //Alterado com sucesso
				}
				else
					response.sendRedirect(pagina + "?inf=" + ret); //Erro na alteração
			}
	}
	//é Excluir
	else
	{
		ret = banco.excluirTabela(tabela, chave, id, (String)session.getAttribute("usuario"));
		if(ret.equals("OK"))
		   	response.sendRedirect(pagina + "?inf=3"); //Removido com sucesso
		else
			response.sendRedirect(pagina + "?inf=" + ret); //Erro na remoção
	}

%>
