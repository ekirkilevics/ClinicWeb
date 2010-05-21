<%@page import="recursos.*" %>
<%@page import="java.sql.*" %>

<jsp:useBean class="recursos.Banco" id="banco" scope="page"/>
<jsp:useBean class="recursos.HonorarioIndividual" id="honorario" scope="page"/>

<%
	//Configuração
	String tabela = "honorarios";
	String chave = "cod_honorario";
	String pagina = "honorarioindividual.jsp";
	String ret = "";
	
	//Itens
	String cod_proced = request.getParameter("cod_proced");
	String qtde = request.getParameter("qtde");
	String valor = Util.trataNulo(request.getParameter("valor"),"").replace(",",".");
	String viaAcesso = request.getParameter("viaAcesso");
	String tipoProced = request.getParameter("tipoProced");
	String dataproced = request.getParameter("dataproced");

	//Parâmetros
	String acao = request.getParameter("acao");
	String id = request.getParameter("id");

	//Nome dos campos (form e tabela)
	String campos[]       = {"","codcli", "cod_convenio", "horainicial", "horafinal", "hospital", "guiaSolicitacao", "data", "prof_reg", "grauParticipacao", "tipoAcomodacao", "obs"};
    String campostabela[] = {"cod_honorario", "codcli", "cod_convenio", "horainicial", "horafinal", "cod_hospital", "guiaSolicitacao", "data", "prof_reg", "grauParticipacao", "tipoAcomodacao", "obs"};

	//Campos a validar
	int validar[] = {1,2,5,7,8};

	//Vetor de dados que vai ser preenchido
	String dados[] = new String[campos.length];

	//Captura os dados dos campos (exceto código que será auto-numérico)
	for(int i=1; i<campos.length; i++)	
		dados[i] = request.getParameter(campos[i]);
	
	//Captura o valor do próximo índice numérico e coloca no vetor de dados
	dados[0] = banco.getNext(tabela, chave );

	//Formata a data
	dados[7] = Util.formataDataInvertida(dados[7]);
	
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
					ret = honorario.insereItemHonorario(dados[0], dataproced, cod_proced, qtde, valor, viaAcesso, tipoProced);
					if(ret.equals("OK"))
						response.sendRedirect(pagina + "?inf=1&cod=" + dados[0]); //Inserido com sucesso
					else
						response.sendRedirect(pagina + "?cod=" + dados[0] + "&inf=" + ret); //Erro nas inserção
				}
				//Se não vier OK, devolver o erro
				else
				{
					response.sendRedirect(pagina + "?cod=" + dados[0] + "&inf=" + ret); //Erro nas inserção
				}
			}
		    //Senão, é alterar
		    else
			{
				ret = banco.alterarTabela(tabela, chave, id, dados, campostabela, (String)session.getAttribute("usuario"));
				if(ret.equals("OK")) {
					ret = honorario.insereItemHonorario(id, dataproced, cod_proced, qtde, valor, viaAcesso, tipoProced);
					if(ret.equals("OK"))
						response.sendRedirect(pagina + "?cod=" + id + "&inf=5"); //Alterado com sucesso
					else
						response.sendRedirect(pagina + "?inf=" + ret); //Erro na alteração
				}
				else
					response.sendRedirect(pagina + "?inf=" + ret); //Erro na alteração
			}
	}
	//é Excluir
	else
	{
		ret = banco.excluirTabela("honorario_item", "cod_honorario", id, (String)session.getAttribute("usuario"));
		ret = banco.excluirTabela(tabela, chave, id, (String)session.getAttribute("usuario"));
		if(ret.equals("OK"))
		   	response.sendRedirect(pagina + "?inf=3"); //Removido com sucesso
		else
			response.sendRedirect(pagina + "?inf=" + ret); //Erro na remoção
	}

%>

