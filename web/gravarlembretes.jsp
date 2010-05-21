<%@page import="recursos.*" %>
<%@page import="java.sql.*" %>

<jsp:useBean class="recursos.Banco" id="banco" scope="page"/>
<jsp:useBean class="recursos.Paciente" id="paciente" scope="page"/>

<%
	//Configuração
	String tabela = "lembretes";
	String chave = "cod_lembrete";
	String pagina = "lembretespaciente.jsp";
	String ret = "";

	//Parâmetros
	String acao = request.getParameter("acao");
	String id = request.getParameter("id");
	String cod_empresa = (String)session.getAttribute("codempresa");

	//Nome dos campos (form e tabela)
	String campos[]       = {"","lembrete", "codcli", "data", "datacadastro", "hora"};
    String campostabela[] = {"cod_lembrete","lembrete", "codcli", "data", "datacadastro", "hora"};

	//Campos a validar
	int validar[] = {0};

	//Vetor de dados que vai ser preenchido
	String dados[] = new String[campos.length];

	//Captura os dados dos campos (exceto código que será auto-numérico)
	for(int i=1; i<campos.length; i++)	
		dados[i] = request.getParameter(campos[i]);
	
	//Captura o valor do próximo índice numérico e coloca no vetor de dados
	dados[0] = banco.getNext(tabela, chave );
	
	//Formata a data
	dados[3] = Util.formataDataInvertida(dados[3]);
	dados[4] = Util.formataDataInvertida(Util.getData());

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
					out.println(sms.sendSMS("CLINIC WEB: ", paciente.getCelularPaciente(dados[2]), dados[1], Util.formataData(dados[3]), dados[5], cod_empresa, "3"));
					response.sendRedirect(pagina + "?inf=1&codcli=" + dados[2]); //Inserido com sucesso
				}
				//Se não vier OK, devolver o erro
				else
				{
					response.sendRedirect(pagina + "?codcli=" + dados[2] + "&inf=" + ret); //Erro nas inserção
				}
			}
	}

%>
