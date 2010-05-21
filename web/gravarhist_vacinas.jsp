<%@page import="recursos.*" %>
<%@page import="java.sql.*" %>

<jsp:useBean class="recursos.Banco" id="banco" scope="page"/>
<jsp:useBean class="recursos.Vacina" id="vacina" scope="page"/>

<%
	//Configuração
	String tabela = "vac_hist_vacinas";
	String chave = "cod_hist_vacina";
	String pagina = "hist_vacinas.jsp";
	String ret = ""; //Retorno

	//Parâmetros
	String acao = request.getParameter("acao");
	String id = request.getParameter("id");

	//Nome dos campos (form e tabela)
	String campos[]       = {"","codcli", "cod_vacina", "cod_convenio", "data_recebimento", "valor", "valor_desc", "observacao"};
    String campostabela[] = {"cod_hist_vacina","codcli", "cod_vacina", "cod_convenio", "data_recebimento", "valor", "valor_desc", "observacao"};

	//Campos a validar
	int validar[] = {1,2,4};

	//Vetor de dados que vai ser preenchido
	String dados[] = new String[campos.length];

	//Captura os dados dos campos (exceto código que será auto-numérico)
	for(int i=1; i<campos.length; i++)	
		dados[i] = request.getParameter(campos[i]);
	
	//Captura o valor do próximo índice numérico e coloca no vetor de dados
	dados[0] = banco.getNext(tabela, chave );

	//Formata Datas
	dados[4] = Util.formataDataInvertida(dados[4]);
		
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
					//Dados do pagto da vacina
					String datapagto = request.getParameter("data_pagamento");
					String valorpagto = request.getParameter("valorpagto");
					String tipopagto = request.getParameter("tipo_pagto");
					String pagopagto = request.getParameter("pago");
					vacina.inserePagamento(dados[0], datapagto, valorpagto, tipopagto, pagopagto);

					//Captura dados da previsão da vacina
					String dataprevisao = request.getParameter("data_previsao");
					String cod_dose = request.getParameter("dose");
					String cod_vacina_previsao = request.getParameter("cod_vacina_previsao");
					
					//Grava dados da previsao
					vacina.gravarPrevisaoVacina(dataprevisao, dados[1], cod_dose, cod_vacina_previsao);
					
					response.sendRedirect(pagina + "?inf=1&cod=" + dados[0]); //Inserido com sucesso
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
					//Dados do pagto da vacina
					String datapagto = request.getParameter("data_pagamento");
					String valorpagto = request.getParameter("valorpagto");
					String tipopagto = request.getParameter("tipo_pagto");
					String pagopagto = request.getParameter("pago");
					ret = vacina.inserePagamento(id, datapagto, valorpagto, tipopagto, pagopagto);

					response.sendRedirect(pagina + "?cod=" + id + "&inf=5"); //Alterado com sucesso
				}
				else
					response.sendRedirect(pagina + "?cod=" + id + "&inf=" + ret); //Erro na alteração
			}
	}
	//é Excluir
	else
	{
		banco.excluirTabela("vac_pagamentos", "vac_hist_vacinas", id, (String)session.getAttribute("usuario"));
		ret = banco.excluirTabela(tabela, chave, id, (String)session.getAttribute("usuario"));
		if(ret.equals("OK")) {
		   	response.sendRedirect(pagina + "?inf=3"); //Removido com sucesso
		}
		else
			response.sendRedirect(pagina + "?inf=" + ret); //Erro na remoção
	}

%>
