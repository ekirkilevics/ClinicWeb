<%@page import="recursos.*" %>
<%@page import="java.sql.*" %>

<jsp:useBean class="recursos.Banco" id="banco" scope="page"/>
<jsp:useBean class="recursos.Usuario" id="usuario" scope="page"/>

<%
	//Configura��o
	String tabela = "t_usuario";
	String chave  = "cd_usuario";
	String pagina = "usuarios.jsp";
	String ret = "";

	//Par�metros
	String acao = request.getParameter("acao");
	String id 	= request.getParameter("id");

	//Nome dos campos (form e tabela)
	String campos[]       = {"","nome","login","senha","grupo", "barras", "prof_reg","ativo", "dataalteracao"};
    String campostabela[] = {"cd_usuario","ds_nome","ds_login","ds_senha","ds_grupo","cod_barra", "prof_reg", "ativo", "dataalteracao"};

	//Campos a validar
	int validar[] = {2,3};

	//Campos a criptografar
	int criptografar[] = {3};

	//Vetor de dados que vai ser preenchido
	String dados[] = new String[campos.length];

	//Captura os dados dos campos (exceto c�digo que ser� auto-num�rico)
	for(int i=1; i<campos.length; i++)	
		dados[i] = request.getParameter(campos[i]);
	
	//Captura o valor do pr�ximo �ndice num�rico e coloca no vetor de dados
	dados[0] = banco.getNext(tabela, chave );
	
	//Colocar como ativo
	dados[7] = "S";
	
	//Coloca a data de altera��o de senha atual
	dados[8] = Util.formataDataInvertida(Util.getData());

	//Atualiza dados no banco usuarios (para parceiros indiq)
	String cod_empresa = (String)session.getAttribute("codempresa");
	usuario.atualizaUsuarios((String)session.getAttribute("parceiro"), acao, dados, id, cod_empresa);

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
				ret = banco.gravarDados(tabela, dados, campostabela, criptografar, (String)session.getAttribute("usuario"));

				//Se retornou OK, efetuado com sucesso
				if(ret.equals("OK"))
				{
					response.sendRedirect(pagina + "?inf=1"); //Inserido com sucesso
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
				//Se a senha estiver em branco, n�o alterar a data de altera��o da senha
				if(Util.isNull(dados[3])) campostabela[8] = "idemx";
				
				ret = banco.alterarTabela(tabela, chave, id, dados, campostabela, criptografar, (String)session.getAttribute("usuario"));
				if(ret.equals("OK"))
					response.sendRedirect(pagina + "?cod=" + id + "&inf=5"); //Alterado com sucesso
				else
					response.sendRedirect(pagina + "?inf=" + ret); //Erro na altera��o
			}
	}
	//� Excluir
	else
	{
		ret = banco.excluirTabela(tabela, chave, id, (String)session.getAttribute("usuario"));
		if(ret.equals("OK"))
		   	response.sendRedirect(pagina + "?inf=3"); //Removido com sucesso
		else
			response.sendRedirect(pagina + "?inf=" + ret); //Erro na remo��o
	}

%>

