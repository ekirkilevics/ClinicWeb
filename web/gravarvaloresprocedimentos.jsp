<%@page import="recursos.*" %>
<%@page import="java.sql.*" %>

<jsp:useBean class="recursos.Banco" id="banco" scope="page"/>

<%
	//Configuração
	String tabela = "valorprocedimentos";
	String chave = "cod_valorprocedimento";
	String pagina = "valoresprocedimentos.jsp";
	String ret = "";

	//Parâmetros
	String acao = request.getParameter("acao");
	String id = request.getParameter("id");

	//Nome dos campos (form e tabela)
	String campos[]       = {"","procedimento","cod_convenio", "valor", "cod_tabela"};
	String campostabela[] = {"cod_valorprocedimento","cod_proced","cod_convenio", "valor", "cod_tabela"};

	//Vetor de dados que vai ser preenchido
	String dados[] = new String[campos.length];

	//Captura os dados dos campos (exceto código que será auto-numérico)
	for(int i=1; i<campos.length; i++)	
		dados[i] = request.getParameter(campos[i]);
	
	//Se não for exclusão, verificar se é registro duplicado
	if(!acao.equals("exc"))
	{

		//Pega a lista de especialidades do profissional
		String lista[] = request.getParameterValues("planos");

		//Se não veio vazia
		if(lista != null)
		{
			//Inserir um registro para cada plano
			for(int i=0; i<lista.length; i++) 
			{
				//Excluir o valor do plano anterior
				banco.executaSQL("DELETE FROM valorprocedimentos WHERE cod_plano=" + lista[i] + " AND cod_proced='" + dados[1] + "'");

				//Captura o valor do próximo índice numérico e coloca no vetor de dados
				dados[0] = banco.getNext(tabela, chave );
				String aux1[] = {dados[0], dados[1], dados[2], lista[i], dados[3], dados[4]};
				String aux2[] = {"cod_valorprocedimento", "cod_proced", "cod_convenio", "cod_plano", "valor", "cod_tabela"};
				
				ret = banco.gravarDados("valorprocedimentos", aux1, aux2, (String)session.getAttribute("usuario") );
			}
		}
		
		//Se deu tudo certo
		if(ret.equals("OK")) {
			//Se a ação for incluir
			if(acao.equals("inc"))
				response.sendRedirect(pagina + "?inf=1"); //Inserido com sucesso
			//Senão, é alterar
			else
				response.sendRedirect(pagina + "?cod=" + dados[0] + "&inf=5"); //Alterado com sucesso
		}
		else {
			response.sendRedirect(pagina + "?cod=" + dados[0] + "&inf=" + ret); //erro ao gravar
		}
	}
	//é Excluir
	else
	{
		//Pega a lista de planos
		String lista[] = request.getParameterValues("planos");

		//Se não veio vazia
		if(lista != null)
		{
			//Inserir um registro para cada especialidade
			for(int i=0; i<lista.length; i++) 
			{
				//Excluir o valor do plano anterior
				ret = banco.executaSQL("DELETE FROM valorprocedimentos WHERE cod_plano=" + lista[i] + " AND cod_proced='" + dados[1] + "'");
			}
		}

		if(ret.equals("OK"))
			response.sendRedirect(pagina + "?inf=3"); //Removido com sucesso
		else
			response.sendRedirect(pagina + "?inf=" + ret); //Erro ao remover
			
	}

%>
