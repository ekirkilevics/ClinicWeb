<%@page import="recursos.*" %>
<%@page import="java.sql.*" %>

<jsp:useBean class="recursos.Banco" id="banco" scope="page"/>

<%
	//Configuração
	String tabela = "geapppvm";
	String chave = "geapppvm_id";
	String pagina = "protocologeap.jsp";
	String ret = "";

	//Parâmetros
	String acao = request.getParameter("acao");
	String id = request.getParameter("id");

	//Nome dos campos (form e tabela)
	String campos[]       = {"",		   "dataAtendimento", "numeroCartao", "numeroContratado", "cid", "numeroAvaliacao", "statusFumante", "valorMassaCorporea", "statusAtividadeFisica", "statusAlimentacaoAdequada", "statusDeambulacao", "statusExFumante", "valorEstatura", "dataAlta", "observacao", "motivoAlta", "tipoModalidade", "cod_hist", "numeroOcorrencia", "tipoExame", "descricaoOcorrencia", "numeroEspecialidade", "dataAtualizacao"};
    String campostabela[] = {"geapppvm_id","dataAtendimento", "numeroCartao", "numeroContratado", "cid", "numeroAvaliacao", "statusFumante", "valorMassaCorporea", "statusAtividadeFisica", "statusAlimentacaoAdequada", "statusDeambulacao", "statusExFumante", "valorEstatura", "dataAlta", "observacao", "motivoAlta", "tipoModalidade", "cod_hist", "numeroOcorrencia", "tipoExame", "descricaoOcorrencia", "numeroEspecialidade", "dataAtualizacao"};

	//Campos a validar
	int validar[] = {0};

	//Vetor de dados que vai ser preenchido
	String dados[] = new String[campos.length];

	//Captura os dados dos campos (exceto código que será auto-numérico)
	for(int i=1; i<campos.length; i++)	
		dados[i] = request.getParameter(campos[i]);
	
	//Captura o valor do próximo índice numérico e coloca no vetor de dados
	dados[0] = banco.getNext(tabela, chave );

	//Formatar Datas
	dados[dados.length-1] = Util.formataDataInvertida(Util.getData());
	dados[1] = Util.formataDataInvertida(dados[1]);
	dados[13] = Util.formataDataInvertida(dados[13]);
	
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
					response.sendRedirect(pagina + "?inf=1&cod=" + dados[17]); //Inserido com sucesso
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
				ret = banco.alterarTabela(tabela, "cod_hist", id, dados, campostabela, (String)session.getAttribute("usuario"));
				if(ret.equals("OK"))
					response.sendRedirect(pagina + "?cod=" + id + "&inf=5"); //Alterado com sucesso
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
