<%@page import="recursos.*" %>
<%@page import="java.sql.*" %>

<jsp:useBean class="recursos.Banco" id="banco" scope="page"/>

<%
	//Configuração
	String tabela = "atendimentos";
	String chave = "cod_atendimento";
	String pagina = "atendimentos.jsp";
	String ret = "";

	//Parâmetros
	String acao = request.getParameter("acao");
	String id = request.getParameter("id");

	//Nome dos campos (form e tabela)
	String campos[]       = {"","codcli","codigo", "data_entrada", "hora_entrada", "data_saida", "hora_saida", "procedente", "encaminhado", "obs"};
    String campostabela[] = {"cod_atendimento", "codcli", "codigo", "data_entrada", "hora_entrada", "data_saida", "hora_saida", "procedente", "encaminhado", "obs"};

	//Campos a validar
	int validar[] = {2};

	//Vetor de dados que vai ser preenchido
	String dados[] = new String[campos.length];

	//Captura os dados dos campos (exceto código que será auto-numérico)
	for(int i=1; i<campos.length; i++)	
		dados[i] = request.getParameter(campos[i]);
	
	//Formata das datas
	dados[3] = Util.formataDataInvertida(dados[3]);
	dados[5] = Util.formataDataInvertida(dados[5]);
	
	//Captura o valor do próximo índice numérico e coloca no vetor de dados
	dados[0] = banco.getNext(tabela, chave );
	
	//Formata para 10 casas
	dados[2] = Util.formataNumero(dados[2], 10);


%>

<%@include file="gravar_modelo.jsp" %>
