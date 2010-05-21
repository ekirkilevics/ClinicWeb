<%@page import="recursos.*" %>

<jsp:useBean class="recursos.Autentica" id="autentica" scope="session"/>

<%
		 response.addHeader("P3P","CP=\"CAO PSA OUR\"");
		 String login = request.getParameter("txtlogin");
		 String senha = request.getParameter("txtsenha");
		 String validacao  = autentica.validaLogin(login, senha, request);

		 //Se retornou algum erro, voltar ao login
		 if(Integer.parseInt(validacao) < 0) {
			 response.sendRedirect("index.jsp?erro=" + validacao); 
		 }
		 //Se é a primeira vez no programa
		 else if(Integer.parseInt(validacao) == 0) {
			response.sendRedirect("setarempresa.jsp"); 		 
		 }
		 //Se login foi sucesso
		 else {
			 //Insere o usuário na application
			 Util.insereUsuario(validacao, application);
		 
			 response.sendRedirect("principal.jsp"); 
		 }
%>
