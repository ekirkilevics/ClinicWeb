<%@page import="recursos.*" %>
<%@page import="java.sql.*" %>
<%@page import="java.util.*" %>

<jsp:useBean class="recursos.Configuracao" id="configuracao" scope="page"/>
<jsp:useBean class="recursos.Banco" id="banco" scope="page"/>

<%
	//N�o grava as p�ginas em cache
    response.setHeader("Cache-Control", "no-cache");
    response.setHeader("Pragma", "no-cache");
	//Mantem pol�tica para cria��o de sess�o mesmo se chamado de outro server (para IE)
	response.addHeader("P3P","CP=\"CAO PSA OUR\"");

	String contato = "entre em contato com a KATU pelo n�mero (11)3294-6268";

	String pesq, strtipo, strcod, inf, ordem, aba, sms;
	int numPag;

	//Vetor de autoriza��es 0-incluir, 1-excluir, 2-alterar,  3-pesquisar
	String autorizado[] = new String[4];

	//Captura a URL da p�gina atual para validar permiss�o do usu�rio para a p�gina
	String paginaatual = request.getRequestURI();

	//Captura o caminho real da aplica��o WEB (diret�rio aplica��o no TomCat)
	String caminhoreal = getServletContext().getRealPath("/");

	//Cores para o site
	String tdlight="", tdmedium="", tddark="", fundo="", cortitulo="", corfonte="", cormsg="", corcaixa="";

	//Captura conte�do das sess�es
	String usuario_logado = (String)session.getAttribute("usuario");
	String nome_usuario = (String)session.getAttribute("nomeusuario");
	String cod_empresa = (String)session.getAttribute("codempresa");

	//Se n�o estiver logado, redirecionar
	if(Util.isNull(usuario_logado))	{
		out.println("<script>parent.location='index.jsp?erro=2';</script>");
	}
	else {
		//Captura as autoriza��es do usu�rio para a p�gina
		autorizado = banco.autorizado(usuario_logado, paginaatual, cod_empresa);

		//Se entrou na p�gina pelo link, validar se tem alguma permisss�o, se n�o tiver, redirecionar
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

	
	//Captura se o cliente tem permiss�o de enviar SMS (capturado ao logar em in�cio.jsp)
	sms = (String)session.getAttribute("sms");
	
	//Captura o n�mero da aba que se encontra, ou a primeira como default
	aba = !Util.isNull(request.getParameter("numeroaba")) ? request.getParameter("numeroaba") : "1";
	
	//Tipo de pesquisa 1-Exata, 2-Inicial, 3-Meio
	int tipo;
	ResultSet rs = null;
	
    //Par�metros que recebe
	pesq    = request.getParameter("pesq");	//Valor a pesquisar
	strtipo = request.getParameter("tipo"); //Tipo de pesquisa (1-exata, 2-in�cio, 3-meio)
	strcod  = request.getParameter("cod");  //C�digo do registro quando consultou
	inf     = request.getParameter("inf");  //Informa��o vinda da p�gina de gravar
	ordem   = request.getParameter("ordem");  //Ordem da lista
	numPag  = Util.isNull(request.getParameter("numPag")) ? 1 : Integer.parseInt(request.getParameter("numPag")); //N�mero da p�gina para a pagina��o
	
	//Se recebeu o tipo de pesquisa, transformar em int, sen�o, usar default 3 (pesquisa no meio)
	if(strtipo != null) tipo = Integer.parseInt(strtipo);
	else tipo = 2;
	
	//Se n�o veio pesquisa, usar vazio
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
	//Vari�veis globais para capturar as permisss�es
	var incluir,  excluir, alterar,  pesquisar;

	incluir = "<%= autorizado[0] %>";
	excluir = "<%= autorizado[1] %>";
	alterar = "<%= autorizado[2] %>";
	pesquisar = "<%= autorizado[3] %>";

	//Vari�veis globais para cortes
	var tdlight, tdmedium, tddark, fundo;
	tdlight  = "<%= tdlight%>";
	tdmedium = "<%= tdmedium%>";
	tddark   = "<%= tddark%>";
	fundo    = "<%= fundo%>";
	
	//vari�vel que vai capturar o cod_ajuda da tela (por default -1)
	var cod_ajuda = -1;
	
</script>
