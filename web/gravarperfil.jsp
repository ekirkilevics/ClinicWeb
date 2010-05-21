<%@page import="recursos.*" %>
<%@page import="java.sql.*" %>

<jsp:useBean class="recursos.Banco" id="banco" scope="page"/>

<%
	//Configuração
	String tabela = "configuracoes";
	String chave = "config_id";
	String pagina = "perfil.jsp";
	String ret = ""; //Retorno

	//Parâmetros
	String acao = request.getParameter("acao");
	String id = request.getParameter("id");

	//Nome dos campos (form e tabela)
	String campos[]       = {"","cabecalho","site","inicio","fim","rodape","cidade","nomeContratado","cod_operadora","codCNES","tipoLogradouro","logradouro","numero","complemento","uf","cep", "codigoIBGEMunicipio", "telefone", "horasenviosms", "nomeFantasia", "usardefinitivo", "qtdediasexpirasenha", "bloquearcarteiravencida", "cod_empresa"};
    String campostabela[] = {"config_id","cabecalho","site","inicio_atendimento","fim_atendimento","rodape","cidade","nomeContratado","cod_operadora","codCNES","tipoLogradouro","logradouro","numero","complemento","uf","cep", "codigoIBGEMunicipio","telefone", "horasenviosms", "nomeFantasia", "usardefinitivo", "qtdediasexpirasenha", "bloquearcarteiravencida", "cod_empresa"};

	//Campos a validar
	int validar[] = {0};

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
