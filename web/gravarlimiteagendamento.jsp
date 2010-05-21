<%@page import="recursos.*" %>
<%@page import="java.sql.*" %>

<jsp:useBean class="recursos.Banco" id="banco" scope="page"/>

<%
	//Configura��o
	String tabela = "limite_agendamento";
	String chave = "cod_limite";
	String pagina = "limiteagendamento.jsp";
	String ret = "";

	//Par�metros
	String acao = request.getParameter("acao");
	String id = request.getParameter("id");

	//Nome dos campos (form e tabela)
	String campos[]       = {"","procedimento", "cod_convenio", "cod_plano", "limite", "cod_empresa"};
    String campostabela[] = {"cod_limite","cod_grupoproced", "cod_convenio", "cod_plano", "limite", "cod_empresa"};

	//Campos a validar
	int validar[] = {1,2,3};

	//Vetor de dados que vai ser preenchido
	String dados[] = new String[campos.length];

	//Captura os dados dos campos (exceto c�digo que ser� auto-num�rico)
	for(int i=1; i<campos.length; i++)	
		dados[i] = request.getParameter(campos[i]);
	
	//Captura o valor do pr�ximo �ndice num�rico e coloca no vetor de dados
	dados[0] = banco.getNext(tabela, chave );

	//Coloca o c�digo da empresa da sess�o no �ltimo campo
	dados[dados.length-1] = (String)session.getAttribute("codempresa");
	
%>

<%@include file="gravar_modelo.jsp" %>
