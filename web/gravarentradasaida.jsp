<%@page import="recursos.*" %>
<%@page import="java.sql.*" %>

<jsp:useBean class="recursos.Banco" id="banco" scope="page"/>

<%
	//Configuração
	String tabela = "entradasaida";
	String chave = "cod_entradasaida";
	String pagina = "entradasaida.jsp";
	String ret = "";

	//Parâmetros
	String acao = request.getParameter("acao");
	String id = request.getParameter("id");

	//Nome dos campos (form e tabela)
	String campos[]       = {"","entradasaida","ativo","tipolocal", "cod_empresa"};
    String campostabela[] = {"cod_entradasaida", "entradasaida", "ativo", "tipo", "cod_empresa"};

	//Campos a validar
	int validar[] = {1,3};

	//Vetor de dados que vai ser preenchido
	String dados[] = new String[campos.length];

	//Captura os dados dos campos (exceto código que será auto-numérico)
	for(int i=1; i<campos.length; i++)	
		dados[i] = request.getParameter(campos[i]);
	
	//Captura o valor do próximo índice numérico e coloca no vetor de dados
	dados[0] = banco.getNext(tabela, chave );

	//Sempre ativo
	dados[2] = "S";
	
	//Coloca o código da empresa da sessão no último campo
	dados[dados.length-1] = (String)session.getAttribute("codempresa");
	
%>

<%@include file="gravar_modelo.jsp" %>
