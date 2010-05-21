<%@page import="recursos.*" %>
<%@page import="java.sql.*" %>

<jsp:useBean class="recursos.Banco" id="banco" scope="page"/>

<%
	//Configuração
	String tabela = "guiassadt";
	String chave = "codGuia";
	String pagina = "guiaspsadtform.jsp";
	String ret = ""; //Retorno

	//Parâmetros
	String acao = request.getParameter("acao");
	String id = request.getParameter("id");

	//Nome dos campos (form e tabela)
	String campos[]       = {"", "numeroGuiaPrestador",  "numeroGuiaPrincipal", "dataAutorizacao", "senhaAutorizacao", "validadeSenha", "dataEmissaoGuia",  "nomeProfissional", "siglaConselho", "numeroConselho", "ufConselho", "cbos", "dataHoraSolicitacao", "caraterAtendimento", "codigoDiagnostico", "indicacaoClinica", "nomeExecutanteC", "siglaConselhoC", "numeroConselhoC", "ufConselhoC", "codigoCBOSC",  "tipoAtendimento", "indicadorAcidente", "tipoSaida", "tipoDoenca", "valor", "unidadeTempo", "observacao", "servicosExecutados", "taxas", "materiais", "medicamentos", "diarias", "gases", "totalGeral", "contratadoSolicitante", "CNESSolicitante", "identificacaoContratado", "numeroCarteira"};
    String campostabela[] = {"codGuia", "numeroGuiaPrestador", "numeroGuiaPrincipal", "dataAutorizacao", "senhaAutorizacao", "validadeSenha", "dataEmissaoGuia", "nomeProfissional", "siglaConselho", "numeroConselho", "ufConselho", "cbos", "dataHoraSolicitacao", "caraterAtendimento", "codigoDiagnostico", "indicacaoClinica", "nomeExecutanteC", "siglaConselhoC", "numeroConselhoC", "ufConselhoC", "codigoCBOSC",  "tipoAtendimento", "indicadorAcidente", "tipoSaida", "tipoDoenca", "valor", "unidadeTempo", "observacao", "servicosExecutados", "taxas", "materiais", "medicamentos", "diarias", "gases", "totalGeral", "contratadoSolicitante", "CNESSolicitante", "identificacaoContratado", "numeroCarteira"};

	//Campos a validar
	int validar[] = {0};

	//Vetor de dados que vai ser preenchido
	String dados[] = new String[campos.length];

	//Captura os dados dos campos (exceto código que será auto-numérico)
	for(int i=1; i<campos.length; i++)	
		dados[i] = request.getParameter(campos[i]);
	
	//Captura o valor do próximo índice numérico e coloca no vetor de dados
	dados[0] = banco.getNext(tabela, chave );
	
	//Formatando Datas
	dados[3] = Util.formataDataInvertida(dados[3]);
	dados[5] = Util.formataDataInvertida(dados[5]);
	dados[6] = Util.formataDataInvertida(dados[6]);
	dados[12] = Util.formataDataInvertida(dados[12]);
	
	//Formata número da guia para 12 dígitos
	dados[1] =  Util.formataNumero(dados[1], 12);
	
	//Se não for exclusão, verificar se é registro duplicado
	if(!acao.equals("exc"))
	{
			ret = banco.alterarTabela(tabela, chave, id, dados, campostabela, (String)session.getAttribute("usuario"));
			if(ret.equals("OK"))
				response.sendRedirect(pagina + "?cod=" + id + "&inf=5"); //Alterado com sucesso
			else
				response.sendRedirect(pagina + "?inf=" + ret); //Erro na alteração
	}

%>
