<%@page import="recursos.*" %>
<%@page import="java.sql.*" %>

<jsp:useBean class="recursos.Banco" id="banco" scope="page"/>

<%
	//Configura��o
	String tabela = "audiometria";
	String chave = "cod_audiometria";
	String pagina = "audiometria.jsp";
	String ret = "";

	//Par�metros
	String acao = request.getParameter("acao");
	String id = request.getParameter("id");

	//Nome dos campos (form e tabela)
	String campos[]       = {"","codcli", "data", "d_a_025", "d_a_050", "d_a_1", "d_a_2", "d_a_3", "d_a_4", "d_a_6", "d_a_8", "d_o_050", "d_o_1", "d_o_2", "d_o_3", "d_o_4", "e_a_025", "e_a_050", "e_a_1", "e_a_2", "e_a_3", "e_a_4", "e_a_6", "e_a_8", "e_o_050", "e_o_1", "e_o_2", "e_o_3", "e_o_4", "cod_empresa"};
    String campostabela[] = {"cod_audiometria","codcli", "data", "d_a_025", "d_a_050", "d_a_1", "d_a_2", "d_a_3", "d_a_4", "d_a_6", "d_a_8", "d_o_050", "d_o_1", "d_o_2", "d_o_3", "d_o_4", "e_a_025", "e_a_050", "e_a_1", "e_a_2", "e_a_3", "e_a_4", "e_a_6", "e_a_8", "e_o_050", "e_o_1", "e_o_2", "e_o_3", "e_o_4", "cod_empresa"};

	//Campos a validar
	int validar[] = {1,2};

	//Vetor de dados que vai ser preenchido
	String dados[] = new String[campos.length];

	//Captura os dados dos campos (exceto c�digo que ser� auto-num�rico)
	for(int i=1; i<campos.length; i++)	
		dados[i] = request.getParameter(campos[i]);
		
	//Formata a data
	dados[2] = Util.formataDataInvertida(dados[2]);
	
	//Captura o valor do pr�ximo �ndice num�rico e coloca no vetor de dados
	dados[0] = banco.getNext(tabela, chave );

	//Coloca o c�digo da empresa da sess�o no �ltimo campo
	dados[dados.length-1] = (String)session.getAttribute("codempresa");
	
	//Se n�o for exclus�o, verificar se � registro duplicado
	if(!acao.equals("exc"))
	{
		//Verifica registro duplicado
        boolean passou = banco.validaRegistro(tabela, chave, id, dados, campostabela, validar);

		//Se tiver registro duplicado, voltar com erro
		if(!passou) 
			response.sendRedirect(pagina + "?inf=7&codcli=" + dados[1]); //Registro Duplicado
		else

		    //Se a a��o for incluir
		    if(acao.equals("inc"))
			{
				ret = banco.gravarDados(tabela, dados, campostabela, (String)session.getAttribute("usuario"));

				//Se retornou OK, efetuado com sucesso
				if(ret.equals("OK"))
				{
					response.sendRedirect(pagina + "?inf=1&cod=" + dados[0] + "&codcli=" + dados[1]); //Inserido com sucesso
				}
				//Se n�o vier OK, devolver o erro
				else
				{
					response.sendRedirect(pagina + "?inf=" + ret + "&codcli=" + dados[1]); //Erro nas inser��o
				}
			}
		    //Sen�o, � alterar
		    else
			{
				ret = banco.alterarTabela(tabela, chave, id, dados, campostabela, (String)session.getAttribute("usuario"));
				if(ret.equals("OK"))
					response.sendRedirect(pagina + "?cod=" + id + "&inf=5&codcli=" + dados[1]); //Alterado com sucesso
				else
					response.sendRedirect(pagina + "?inf=" + ret + "&codcli=" + dados[1]); //Erro na altera��o
			}
	}
	//� Excluir
	else
	{
		ret = banco.excluirTabela(tabela, chave, id, (String)session.getAttribute("usuario"));
		if(ret.equals("OK"))
		   	response.sendRedirect(pagina + "?inf=3&codcli=" + dados[1]); //Removido com sucesso
		else
			response.sendRedirect(pagina + "?inf=" + ret + "&codcli=" + dados[1]); //Erro na remo��o
	}

%>
