<%@page import="recursos.*" %>
<%@page import="java.sql.*" %>

<jsp:useBean class="recursos.Banco" id="banco" scope="page"/>
<jsp:useBean class="recursos.Grupo" id="grupo" scope="page"/>

<%
	//Configura��o
	String tabela = "t_grupos";
	String chave = "grupo_id";
	String pagina = "grupos.jsp";
	String retorno = pagina;
	String incluir="0", excluir="0", alterar="0", pesquisar="0";
	String ret = "";
	
	//Par�metros
	String acao = request.getParameter("acao");
    String id 	= request.getParameter("id");

	//Nome dos campos da tabela de permiss�o
    String campostabela2[] = {"permissao_id","grupoId","menuId","incluir","excluir","alterar","pesquisar"};
	String dados2[] = new String[campostabela2.length];
	int cont = 1;

	//Nome dos campos (form e tabela)
	String campos[]       = {"","grupo","sessao",""};
    String campostabela[] = {"grupo_id","grupo","temposessao","cod_empresa"};

	//Campos a validar
	int validar[] = {1,3};

	//Vetor de dados que vai ser preenchido
	String dados[] = new String[campos.length];

	//Captura os dados dos campos (exceto c�digo que ser� auto-num�rico)
	for(int i=1; i<campos.length; i++)	
		dados[i] = request.getParameter(campos[i]);
	
	//Captura o valor do pr�ximo �ndice num�rico e coloca no vetor de dados
	dados[0] = banco.getNext(tabela, chave );

	//Coloca o c�digo da empresa da sess�o no �ltimo campo
	dados[dados.length-1] = (String)session.getAttribute("codempresa");

	//Apaga as permiss�es para inserir novamente
	banco.excluirTabela("t_permissao", "grupoId", id, (String)session.getAttribute("usuario"));

	//Se n�o for exclus�o, verificar se � registro duplicado
	if(!acao.equals("exc"))
	{
		//Verifica registro duplicado
	     boolean passou = banco.validaRegistro(tabela, chave, id, dados, campostabela, validar );

		//Se tiver, voltar com erro
		if(!passou) 
			retorno = pagina + "?inf=7"; //Registro Duplicado
		else
			
		    //Se a a��o for incluir
		    if(acao.equals("inc"))
			{
				ret = banco.gravarDados(tabela, dados, campostabela, (String)session.getAttribute("usuario"));
				if(ret.equals("OK"))
					retorno = pagina + "?inf=1"; //Inserido com sucesso
				else
					retorno = pagina + "?inf=" + ret; //Erro nas inser��o
			}
		    //Sen�o, � alterar
		    else
			{
				ret = banco.alterarTabela(tabela, chave, id, dados, campostabela, (String)session.getAttribute("usuario"));
				if(ret.equals("OK"))
						retorno = pagina + "?cod=" + id + "&inf=5"; //Alterado com sucesso
				else
						retorno = pagina + "?inf=" + ret; //Erro na altera��o
			}
			//Sendo inclus�o ou altera��o, vai incluir as permiss�es
			try {
				ResultSet rsItensMenu = grupo.getRSItensMenu((String)session.getAttribute("codempresa"));
				while(rsItensMenu.next()) {
						//Se vier com par�metro 1, ,ent�o estar checado, gravar como 1, sen�o, gravar como zero (0)
						incluir 	= request.getParameter("incluir"+cont) == null ? "0" : "1";
						excluir 	= request.getParameter("excluir"+cont) == null ? "0" : "1";
						alterar 	= request.getParameter("alterar"+cont) == null ? "0" : "1";
						pesquisar 	= request.getParameter("pesquisar"+cont) == null ? "0" : "1";

						//Captura o valor do pr�ximo �ndice num�rico e coloca no vetor de dados
						dados2[0] = banco.getNext("t_permissao", "permissao_id" );
						dados2[1] = acao.equals("inc") ? dados[0] : id;
						dados2[2] = rsItensMenu.getString("menuId");
						dados2[3] = incluir;
						dados2[4] = excluir;
						dados2[5] = alterar;
						dados2[6] = pesquisar;
		
						banco.gravarDados("t_permissao", dados2, campostabela2, (String)session.getAttribute("usuario"));
						cont++;
						
				}
				rsItensMenu.close();
				
			}
			catch(SQLException e) {
				out.println(e.toString());
			}
				
	}
	else
	{
		ret = banco.excluirTabela(tabela, chave, id, (String)session.getAttribute("usuario"));
		if(ret.equals("OK"))
		   	retorno = pagina + "?inf=3"; //Removido com sucesso
		else
			retorno = pagina + "?inf=4"; //Erro na remo��o
	}
	response.sendRedirect(retorno); //Volta para a p�gina
%>
