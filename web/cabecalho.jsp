<%@page import="recursos.*" %>
<%@page import="java.sql.*" %>
<%@page import="java.util.*" %>

<jsp:useBean class="recursos.Configuracao" id="configuracao" scope="page"/>
<jsp:useBean class="recursos.Banco" id="banco" scope="page"/>

<%
	//Não grava as páginas em cache
    response.setHeader("Cache-Control", "no-cache");
    response.setHeader("Pragma", "no-cache");
	//Mantem política para criação de sessão mesmo se chamado de outro server (para IE)
	response.addHeader("P3P","CP=\"CAO PSA OUR\"");

	String contato = "entre em contato com a KATU pelo número (11)3294-6268";

	String pesq, strtipo, strcod, inf, ordem, aba, sms;
	int numPag;

	//Vetor de autorizações 0-incluir, 1-excluir, 2-alterar,  3-pesquisar
	String autorizado[] = new String[4];

	//Captura a URL da página atual para validar permissão do usuário para a página
	String paginaatual = request.getRequestURI();

	//Captura o caminho real da aplicação WEB (diretório aplicação no TomCat)
	String caminhoreal = getServletContext().getRealPath("/");

	//Cores para o site
	String tdlight="", tdmedium="", tddark="", fundo="", cortitulo="", corfonte="", cormsg="", corcaixa="";

	//Captura conteúdo das sessões
	String usuario_logado = (String)session.getAttribute("usuario");
	String nome_usuario = (String)session.getAttribute("nomeusuario");
	String cod_empresa = (String)session.getAttribute("codempresa");

	//Se não estiver logado, redirecionar
	if(Util.isNull(usuario_logado))	{
		out.println("<script>parent.location='index.jsp?erro=2';</script>");
	}
	else {
		//Captura as autorizações do usuário para a página
		autorizado = banco.autorizado(usuario_logado, paginaatual, cod_empresa);

		//Se entrou na página pelo link, validar se tem alguma permisssão, se não tiver, redirecionar
		if(autorizado[0].equals("0") && autorizado[1].equals("0") && autorizado[2].equals("0") && autorizado[3].equals("0"))
			response.sendRedirect("erro.jsp");
		else if(autorizado[0].length() > 1 || autorizado[1].length() > 1) {
			out.println("SQL:" + autorizado[0] + "<br>");
			out.println("ERRO: " + autorizado[1] + "<br>");
		}
			

		//Captura as cores
		tdlight   = configuracao.getItemConfig("tdlight", cod_empresa);
		tdmedium  = configuracao.getItemConfig("tdmedium", cod_empresa);
		tddark    = configuracao.getItemConfig("tddark", cod_empresa);
		fundo     = configuracao.getItemConfig("fundo", cod_empresa);
		cortitulo = configuracao.getItemConfig("cortitulo", cod_empresa);
		corfonte  = configuracao.getItemConfig("corfonte", cod_empresa);
		cormsg    = configuracao.getItemConfig("cormsg", cod_empresa);
		corcaixa  = configuracao.getItemConfig("corcaixa", cod_empresa);
	}

	
	//Captura se o cliente tem permissão de enviar SMS (capturado ao logar em início.jsp)
	sms = (String)session.getAttribute("sms");
	
	//Captura o número da aba que se encontra, ou a primeira como default
	aba = !Util.isNull(request.getParameter("numeroaba")) ? request.getParameter("numeroaba") : "1";
	
	//Tipo de pesquisa 1-Exata, 2-Inicial, 3-Meio
	int tipo;
	ResultSet rs = null;
	
    //Parâmetros que recebe
	pesq    = request.getParameter("pesq");	//Valor a pesquisar
	strtipo = request.getParameter("tipo"); //Tipo de pesquisa (1-exata, 2-início, 3-meio)
	strcod  = request.getParameter("cod");  //Código do registro quando consultou
	inf     = request.getParameter("inf");  //Informação vinda da página de gravar
	ordem   = request.getParameter("ordem");  //Ordem da lista
	numPag  = Util.isNull(request.getParameter("numPag")) ? 1 : Integer.parseInt(request.getParameter("numPag")); //Número da página para a paginação
	
	//Se recebeu o tipo de pesquisa, transformar em int, senão, usar default 3 (pesquisa no meio)
	if(strtipo != null) tipo = Integer.parseInt(strtipo);
	else tipo = 2;
	
	//Se não veio pesquisa, usar vazio
	if(pesq == null) pesq = "";
	
%>
<style type="text/css">

.caixa {
	border: 1px solid #000000;
	font-family: tahoma;
	font-size: 11px;
	color: <%= corfonte%>;
	background-color: <%= corcaixa%>;
}

.msg {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 11px;
	color: <%= cormsg%>;
	font-weight: bold;
}

.texto {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 11px;
	color: <%= corfonte%>;
}

.title {
	font: bold 25px Tahoma, Verdana, Arial, Helvetica;
	color: <%= cortitulo%>;
	padding: 5px;
	padding-left: 10px;
	padding-right: 10px;
	white-space: nowrap;
}

.tdDark {
	border: 0px;
	border-bottom: 1px solid #111111;
	border-right: 1px solid #111111;
	font: 11px Tahoma, Verdana, Arial, Helvetica;
	color: <%= corfonte%>;
	padding: 3px 10px;
	white-space: nowrap;
	background: <%= tddark %>; 
}

.tdMedium {
	border: 0px;
	border-bottom: 1px solid #111111;
	border-right: 1px solid #111111;
	font: 11px Tahoma, Verdana, Arial, Helvetica;
	color: <%= corfonte%>;
	padding: 1px 10px;
	white-space: nowrap;
	background: <%= tdmedium %>;
}

.tdLight {
	border: 0px;
	border-bottom: 1px solid #111111;
	border-right: 1px solid #111111;
	font: 11px Tahoma, Verdana, Arial, Helvetica;
	color: <%= corfonte%>;
	padding: 1px 10px;
	background: <%= tdlight %>;
}

BODY  {
	 background: <%= fundo %>;
	 scrollbar-face-color: <%= tddark %>;
	 scrollbar-track-color: <%= tdlight %>; 
	 scrollbar-arrow-color: #FFFFFF;
 	 scrollbar-shadow-color: <%= fundo %>;
	 scrollbar-highlight-color: #CCCCCC;
	 scrollbar-3dlight-color: <%= tdmedium %>;
	 scrollbar-darkshadow-color: <%= tddark %>;	 
}

</style>
<script language="JavaScript">
	//Variáveis globais para capturar as permisssões
	var incluir,  excluir, alterar,  pesquisar;

	incluir = "<%= autorizado[0] %>";
	excluir = "<%= autorizado[1] %>";
	alterar = "<%= autorizado[2] %>";
	pesquisar = "<%= autorizado[3] %>";

	//Variáveis globais para cortes
	var tdlight, tdmedium, tddark, fundo;
	tdlight  = "<%= tdlight%>";
	tdmedium = "<%= tdmedium%>";
	tddark   = "<%= tddark%>";
	fundo    = "<%= fundo%>";
	
	//variável que vai capturar o cod_ajuda da tela (por default -1)
	var cod_ajuda = -1;
	
</script>
