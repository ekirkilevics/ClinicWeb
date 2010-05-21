<%@page import="recursos.*" %>
<%@page import="java.sql.*" %>

<jsp:useBean class="recursos.Banco" id="banco" scope="page"/>
<jsp:useBean class="recursos.Menu" id="menu" scope="page"/>

<%
	//Configuração
	String tabela = "menu";
	String chave = "menuId";
	String pagina = "configmenu.jsp";
	String ret = "";

	//Parâmetros
	String id = request.getParameter("id");

	//Nome dos campos (form e tabela)
	String campostabela[] = {"menuId","item","menuPai","ordem"};

	//Vetor de dados que vai ser preenchido
	String dados[] = new String[campostabela.length];

	dados[0] = id;
	dados[1] = request.getParameter("item" + id);
	dados[2] = request.getParameter("combopai" + id);
	dados[3] = request.getParameter("ordem" + id);
	
	ret = banco.alterarTabela(tabela, chave, id, dados, campostabela, (String)session.getAttribute("usuario"));
	if(ret.equals("OK"))
		response.sendRedirect(pagina + "?cod=" + id + "&inf=5"); //Alterado com sucesso
	else
		response.sendRedirect(pagina + "?inf=6"); //Erro na alteração

%>
