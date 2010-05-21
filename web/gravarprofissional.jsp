<%@page import="recursos.*" %>
<%@page import="java.sql.*" %>

<jsp:useBean class="recursos.Banco" id="banco" scope="page"/>

<%
	//Configura��o
	String tabela = "profissional";
	String chave = "cod";
	String pagina = "profissionais.jsp";
	String ret = "";

	//Par�metros
	String acao = request.getParameter("acao");
	String id = request.getParameter("id");

	//Nome dos campos (form e tabela)
	String campos[]       = {"","registro","prof_reg","nome","endereco","dddres","telresidencial","dddcel","celular","email","locacao","exibir", "ufConselho", "tempoconsulta", "ativo", "cod_empresa"};
   	String campostabela[] = {"cod","reg_prof","prof_reg","nome","nome_logradouro","ddd_residencial","tel_residencial","ddd_celular","tel_celular","email","locacao", "exibir", "ufConselho", "tempoconsulta", "ativo", "cod_empresa"};

	//Campos a validar
	int validar[] = {1,14};

	//Vetor de dados que vai ser preenchido
	String dados[] = new String[campos.length];

	//Captura os dados dos campos (exceto c�digo que ser� auto-num�rico)
	for(int i=1; i<campos.length; i++)
		dados[i] = request.getParameter(campos[i]);

	//Captura o valor do pr�ximo �ndice num�rico e coloca no vetor de dados
	dados[0] = banco.getNext(tabela, chave );
	
	//Coloca o c�digo da empresa da sess�o no �ltimo campo
	dados[dados.length-1] = (String)session.getAttribute("codempresa");

	//Na inser��o ou atualiza��o, Ativo ser� 'S'
	dados[dados.length-2] = "S";

	//Se for inclus�o, alterar o prof_reg para o reg_prof
	if(acao.equals("inc"))
		dados[2] = dados[1];
	else
		campostabela[2] = "idemx";

	//Se n�o for exclus�o, verificar se � registro duplicado
	if(!acao.equals("exc"))
	{
		//Verifica registro duplicado
	    boolean passou = banco.validaRegistro(tabela, chave, id, dados, campostabela, validar );

		//Se tiver, voltar com erro
		if(!passou)
			response.sendRedirect(pagina + "?inf=7"); //Registro Duplicado
		else
		{
		    //Se a a��o for incluir
		    if(acao.equals("inc"))
		    {
				ret = banco.gravarDados(tabela, dados, campostabela, (String)session.getAttribute("usuario"));
				if(ret.equals("OK"))
				{
					//Pega a lista de especialidades do profissional
					String lista[] = request.getParameterValues("especialidade");

					//Apaga a lista atual de especialidades do profissional
					banco.excluirTabela("prof_esp", "prof_reg", dados[2], (String)session.getAttribute("usuario"));

					//Se n�o veio vazia
					if(lista != null)
                                        {
						//Inserir um registro para cada especialidade
						for(int i=0; i<lista.length; i++) 
						{
							String aux1[] = {dados[2],  lista[i]};
							String aux2[] = {"prof_reg","codesp"};
							banco.gravarDados("prof_esp", aux1, aux2, (String)session.getAttribute("usuario") );
						}
					}
					response.sendRedirect(pagina + "?inf=1"); //Inserido com sucesso
				}
				else
					response.sendRedirect(pagina + "?inf=" + ret); //Erro nas inser��o
        	}
		    //Sen�o, � alterar
		    else
			{
				ret = banco.alterarTabela(tabela, chave, id, dados, campostabela, (String)session.getAttribute("usuario"));
				if(ret.equals("OK"))
				{
					//Pega a lista de especialidades do profissional
					String lista[] = request.getParameterValues("especialidade");

					//Apaga a lista atual de especialidades do profissional
					banco.excluirTabela("prof_esp", "prof_reg", dados[2], (String)session.getAttribute("usuario"));

					//Se n�o veio vazia
					if(lista != null) 
					{
						//Inserir um registro para cada especialidade
						for(int i=0; i<lista.length; i++) 
						{
							String aux1[] = {dados[2], lista[i]};
							String aux2[] = {"prof_reg","codesp"};
							banco.gravarDados("prof_esp", aux1, aux2, (String)session.getAttribute("usuario") );
						}
					}
			    		response.sendRedirect(pagina + "?cod=" + id + "&inf=5"); //Alterado com sucesso
			    	}
			    	else
				    	response.sendRedirect(pagina + "?inf=" + ret); //Erro na altera��o
				}
		 }
	}
	//Sen�o
	else
	{
		//Apaga a lista atual de especialidades do profissional
		banco.excluirTabela("prof_esp", "prof_reg", dados[2], (String)session.getAttribute("usuario"));

		ret = banco.excluirTabela(tabela, chave, id, (String)session.getAttribute("usuario"));
		if(ret.equals("OK"))
		   	response.sendRedirect(pagina + "?inf=3"); //Removido com sucesso
		else
			response.sendRedirect(pagina + "?inf=" + ret); //Erro na remo��o
	}
%>

