<%@page import="recursos.*" %>
<%@page import="java.sql.*" %>

<jsp:useBean class="recursos.Banco" id="banco" scope="page"/>
<jsp:useBean class="recursos.Feriado" id="feriado" scope="page"/>

<%
	//Configura��o
	String tabela = "feriados";
	String chave = "cod_feriado";
	String pagina = "feriados.jsp";
	String ret = ""; //Retorno

	//Par�metros
	String acao = request.getParameter("acao");
	String id = request.getParameter("id");

	//Nome dos campos (form e tabela)
	String campos[]       = {"","descricao","datainicio", "datafim", "prof_reg", "hora_inicio", "hora_fim", "diatodo", "definitivo", "cod_empresa"};
    String campostabela[] = {"cod_feriado","descricao","datainicio", "datafim", "prof_reg", "hora_inicio", "hora_fim", "diatodo", "definitivo", "cod_empresa"};

	//Campos a validar
	int validar[] = {2,4,5};

	//Vetor de dados que vai ser preenchido
	String dados[] = new String[campos.length];

	//Captura os dados dos campos (exceto c�digo que ser� auto-num�rico)
	for(int i=1; i<campos.length; i++)	
		dados[i] = request.getParameter(campos[i]);
	
	//Captura o valor do pr�ximo �ndice num�rico e coloca no vetor de dados
	dados[0] = banco.getNext(tabela, chave );
	
	//Formata a data
	dados[2] = Util.formataDataInvertida(dados[2]);
	dados[3] = Util.formataDataInvertida(dados[3]);

	//Se os hor�rios n�o vierem, colocar 00:00
	if(Util.isNull(dados[5])) dados[5] = "00:00";
	if(Util.isNull(dados[6])) dados[6] = "00:00";

	//Se n�o n�o vier valor do check, setar como N
	if(Util.isNull(dados[7])) dados[7] = "N";
	if(Util.isNull(dados[8])) dados[8] = "N";
	
	//Se escolheu definitivo, � sempre todos e dia todo
	if(dados[8].equals("S")) {
		dados[7] = "S";
		dados[4] = "todos";
		dados[5] = "00:00";
		dados[6] = "00:00";
	}

	//Coloca o c�digo da empresa da sess�o no �ltimo campo
	dados[dados.length-1] = (String)session.getAttribute("codempresa");

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
				String temAgenda = feriado.existeAgendaPeriodo(dados);
				ret = banco.gravarDados(tabela, dados, campostabela, (String)session.getAttribute("usuario"));

				//Se retornou OK, efetuado com sucesso
				if(ret.equals("OK"))
				{
					response.sendRedirect(pagina + "?inf=1&temagenda=" + temAgenda); //Inserido com sucesso
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
				String temAgenda = feriado.existeAgendaPeriodo(dados);
				ret = banco.alterarTabela(tabela, chave, id, dados, campostabela, (String)session.getAttribute("usuario"));
				if(ret.equals("OK"))
					response.sendRedirect(pagina + "?cod=" + id + "&inf=5&temagenda=" + temAgenda); //Alterado com sucesso
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
