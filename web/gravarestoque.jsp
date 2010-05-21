<%@page import="recursos.*" %>
<%@page import="java.sql.*" %>

<jsp:useBean class="recursos.Banco" id="banco" scope="page"/>
<jsp:useBean class="recursos.Vacina" id="vacina" scope="page"/>

<%
	//Configuração
	String tabela = "vac_estoque";
	String chave = "cod_estoque";
	String pagina = "estoque.jsp";
	String ret = ""; //Retorno

	//Parâmetros
	String acao = request.getParameter("acao");
	String id = request.getParameter("id");

	//Nome dos campos (form e tabela)
	String campos[]       = {"","cod_vacina", "cod_laboratorio", "lote", "data_entrada", "validade", "qtde_compra", "qtde_estoque", "valor","origem"};
    String campostabela[] = {"cod_estoque","cod_vacina", "cod_laboratorio", "lote", "data_entrada", "validade", "qtde_compra", "qtde_estoque", "valor", "origem"};

	//Campos a validar
	int validar[] = {0};

	//Vetor de dados que vai ser preenchido
	String dados[] = new String[campos.length];

	//Captura os dados dos campos (exceto código que será auto-numérico)
	for(int i=1; i<campos.length; i++)	
		dados[i] = request.getParameter(campos[i]);
	
	//Captura o valor do próximo índice numérico e coloca no vetor de dados
	dados[0] = banco.getNext(tabela, chave );

	//Formata Datas
	dados[4] = Util.formataDataInvertida(dados[4]);
	dados[5] = Util.formataDataInvertida(dados[5]);

	//Copia quantidade de entrada para estoque
	dados[7] = dados[6];
	
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
					response.sendRedirect(pagina + "?inf=1"); //Inserido com sucesso
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
				if(ret.equals("OK"))
					response.sendRedirect(pagina + "?cod=" + id + "&inf=5"); //Alterado com sucesso
				else
					response.sendRedirect(pagina + "?inf=" + ret); //Erro na alteração
			}
	}
	//é Excluir
	else
	{
		String existelancamento = vacina.verificaLancamentoEstoque(id);
		if(existelancamento.equals("1"))
			response.sendRedirect(pagina + "?inf=Existe%20Lançamento%20para%20esse%20lote"); //Existe lançamento
		else if(existelancamento.equals("2"))
			response.sendRedirect(pagina + "?inf=Existe%20Saídas%20para%20esse%20lote"); //Existe lançamento
		else {
			ret = banco.excluirTabela(tabela, chave, id, (String)session.getAttribute("usuario"));
			if(ret.equals("OK"))
				response.sendRedirect(pagina + "?inf=3"); //Removido com sucesso
			else
				response.sendRedirect(pagina + "?inf=" + ret); //Erro na remoção
		}
	}

%>
