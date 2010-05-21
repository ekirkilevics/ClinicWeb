<%@page import="recursos.*" %>
<%@page import="java.sql.*" %>

<jsp:useBean class="recursos.Banco" id="banco" scope="page"/>
<jsp:useBean class="recursos.Vacina" id="vacina" scope="page"/>

<%
	//Configura��o
	String tabela = "vac_saidas";
	String chave = "cod_saida";
	String pagina = "emprestimovacinas.jsp";
	String ret = ""; //Retorno

	//Par�metros
	String acao = request.getParameter("acao");
	String id = request.getParameter("id");

	//Nome dos campos (form e tabela)
	String campos[]       = {"", "data", "qtde", "lote",  "tipo_saida", "cod_vacina"};
    String campostabela[] = {"cod_saida", "data", "qtde", "lote",  "tipo_saida","cod_vacina"};

	//Campos a validar
	int validar[] = {0};

	//Vetor de dados que vai ser preenchido
	String dados[] = new String[campos.length];

	//Captura os dados dos campos (exceto c�digo que ser� auto-num�rico)
	for(int i=1; i<campos.length; i++)	
		dados[i] = request.getParameter(campos[i]);
	
	//Captura o valor do pr�ximo �ndice num�rico e coloca no vetor de dados
	dados[0] = banco.getNext(tabela, chave );

	//Formata Datas
	dados[1] = Util.formataDataInvertida(dados[1]);

	//Se n�o for exclus�o, verificar se � registro duplicado
	if(!acao.equals("exc"))
	{
		//Verifica registro duplicado
         boolean passou = banco.validaRegistro(tabela, chave, id, dados, campostabela, validar);

		//Se tiver registro duplicado, voltar com erro
		if(!passou) 
			response.sendRedirect(pagina + "?inf=7"); //Registro Duplicado
		else

		    //Se a a��o for incluir
		    if(acao.equals("inc"))
			{
				ret = banco.gravarDados(tabela, dados, campostabela, (String)session.getAttribute("usuario"));

				//Se retornou OK, efetuado com sucesso
				if(ret.equals("OK"))
				{
						response.sendRedirect(pagina + "?inf=1&cod=" + dados[0]); //Inserido com sucesso
				}
				//Se n�o vier OK, devolver o erro
				else
				{
					response.sendRedirect(pagina + "?inf=" + ret); //Erro nas inser��o
				}
			}
		    //Sen�o, � alterar
		    else
			{
				//Subtrai do estoque antes de alterar o conte�do (quando n�o tem aplicador ainda)
				//String retestoque = vacina.diminuiEstoque(dados[1], id);
                                
				ret = banco.alterarTabela(tabela, chave, id, dados, campostabela, (String)session.getAttribute("usuario"));
				if(ret.equals("OK")) {
					response.sendRedirect(pagina + "?inf=1&cod=" + dados[0]);
				}
				else {
					//retestoque = vacina.aumentaEstoque(id, true);
					response.sendRedirect(pagina + "?inf=" + ret + "&cod=" + dados[0]); //Erro na altera��o
				}
			}
	}
	//� Excluir
	else
	{
		ret = banco.excluirTabela(tabela, chave, id, (String)session.getAttribute("usuario"));
		if(ret.equals("OK")) {
		   	response.sendRedirect(pagina + "?inf=3"); //Removido com sucesso
		}
		else
			response.sendRedirect(pagina + "?inf=" + ret); //Erro na remo��o
	}

%>
