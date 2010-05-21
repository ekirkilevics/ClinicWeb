<%@page import="recursos.*" %>
<%@page import="java.sql.*" %>

<jsp:useBean class="recursos.Banco" id="banco" scope="page"/>

<%
	//Configuração
	String tabela = "vac_valor_vacinas";
	String chave = "cod_valor_vacina";
	String pagina = "valorvacinas.jsp";
	String ret = "";

	//Parâmetros
	String acao = request.getParameter("acao");
	String id = request.getParameter("id");

	//Nome dos campos (form e tabela)
	String campos[]       = {"","cod_convenio","cod_vacina", "valor"};
    String campostabela[] = {"cod_valor_vacina","cod_convenio","cod_vacina", "valor"};

	//Campos a validar
	int validar[] = {1,2};

	//Vetor de dados que vai ser preenchido
	String dados[] = new String[campos.length];

	//Captura os dados dos campos (exceto código que será auto-numérico)
	for(int i=1; i<campos.length; i++)	
		dados[i] = request.getParameter(campos[i]);
	
	//Captura o valor do próximo índice numérico e coloca no vetor de dados
	dados[0] = banco.getNext(tabela, chave );
	
%>

<%@include file="gravar_modelo.jsp" %>
