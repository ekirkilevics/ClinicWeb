<%@page import="recursos.*" %>
<%@page import="java.sql.*" %>

<jsp:useBean class="recursos.Banco" id="banco" scope="page"/>

<%
	//Configuração
	String tabela = "hospitais";
	String chave = "cod_hospital";
	String pagina = "hospitais.jsp";
	String ret = "";

	//Parâmetros
	String acao = request.getParameter("acao");
	String id = request.getParameter("id");

	//Nome dos campos (form e tabela)
	String campos[]       = {"","descricao", "cnpj", "cnes", "tipoLogradouro", "logradouro", "numero", "uf", "cep", "codigoIBGEMunicipio", "cod_empresa"};
    String campostabela[] = {"cod_hospital","descricao", "cnpj", "cnes", "tipoLogradouro", "logradouro", "numero", "uf", "cep", "codigoIBGEMunicipio", "cod_empresa"};

	//Campos a validar
	int validar[] = {2};

	//Vetor de dados que vai ser preenchido
	String dados[] = new String[campos.length];

	//Captura os dados dos campos (exceto código que será auto-numérico)
	for(int i=1; i<campos.length; i++)	
		dados[i] = request.getParameter(campos[i]);
	
	//Captura o valor do próximo índice numérico e coloca no vetor de dados
	dados[0] = banco.getNext(tabela, chave );

	//Coloca o código da empresa da sessão no último campo
	dados[dados.length-1] = (String)session.getAttribute("codempresa");
	
%>

<%@include file="gravar_modelo.jsp" %>
