<%@page import="recursos.*" %>
<%@page import="java.sql.*" %>

<jsp:useBean class="recursos.Banco" id="banco" scope="page"/>

<%
	//Configura��o
	String tabela = "links";
	String chave = "cod_link";
	String pagina = "links.jsp";
	String ret = "";

	//Par�metros
	String acao = request.getParameter("acao");
	String id = request.getParameter("id");

	//Nome dos campos (form e tabela)
	String campos[]       = {"","assunto","titulo","descricao", "link"};
    String campostabela[] = {"cod_link","cod_assunto","titulo", "descricao", "link"};

	//Campos a validar
	int validar[] = {4};

	//Vetor de dados que vai ser preenchido
	String dados[] = new String[campos.length];

	//Captura os dados dos campos (exceto c�digo que ser� auto-num�rico)
	for(int i=1; i<campos.length; i++)	
		dados[i] = request.getParameter(campos[i]);
	
	//Captura o valor do pr�ximo �ndice num�rico e coloca no vetor de dados
	dados[0] = banco.getNext(tabela, chave );

%>

<%@include file="gravar_modelo.jsp" %>