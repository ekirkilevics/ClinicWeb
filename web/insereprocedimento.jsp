<%@page import="recursos.*" %>
<%@page import="java.sql.*" %>

<jsp:useBean class="recursos.Banco" id="banco" scope="page"/>

<%
	//Configuração
	String tabela = "procedimentossadt";
	String chave = "codProcedimentoSADT";
	String pagina = "guiaspsadtform.jsp";
	String ret = ""; //Retorno

	//Parâmetros
	String acao = request.getParameter("acao");
	String id = request.getParameter("id");
	String codGuia = request.getParameter("cod");

	//Nome dos campos (form e tabela)
	String campos[]       = {"","codguia","codigo", "tipoTabela", "descricao", "data", "horaInicio", "horaFim", "quantidadeRealizada", "viaAcesso", "reducaoAcrescimo", "valor", "valorTotal"};
    String campostabela[] = {"codProcedimentoSADT","codguia","codigo", "tipoTabela", "descricao", "data", "horaInicio", "horaFim", "quantidadeRealizada", "viaAcesso", "reducaoAcrescimo", "valor", "valorTotal"};

	//Campos a validar
	int validar[] = {2,3};

	//Vetor de dados que vai ser preenchido
	String dados[] = new String[campos.length];

	//Captura os dados dos campos (exceto código que será auto-numérico)
	for(int i=1; i<campos.length; i++)	
		dados[i] = request.getParameter(campos[i]);
	
	//Captura o valor do próximo índice numérico e coloca no vetor de dados
	dados[0] = banco.getNext(tabela, chave );
	
	//Coloca o código da guia
	dados[1] = codGuia;

	//Formata a data
	dados[5] = Util.formataDataInvertida(dados[5]);
	
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
					response.sendRedirect(pagina + "?cod=" + codGuia + "&inf=Procedimento%20Inserido%20com%20Sucesso"); //Sucesso
				}
				//Se não vier OK, devolver o erro
				else
				{
					response.sendRedirect(pagina + "?cod=" + codGuia + "&inf=" + ret); //Erro nas inserção
				}
			}
	}
	//é Excluir
	else
	{
		ret = banco.excluirTabela(tabela, chave, id, (String)session.getAttribute("usuario"));
		if(ret.equals("OK"))
		   response.sendRedirect(pagina + "?cod=" + codGuia + "&inf=Procedimento%20Removido%20com%20Sucesso"); //Sucesso
		else
			response.sendRedirect(pagina + "?cod=" + codGuia + "&inf=" + ret); //Erro nas inserção
	}

%>
