<%@page import="recursos.*" %>
<%@page import="java.sql.*" %>

<jsp:useBean class="recursos.Email" id="email" scope="page"/>

<%
   		boolean resp = email.sendMail("amiltonmartha@katusis.com.br", "Aviso Autom�tico: Exclus�o de Agenda (m�dico)","teste de mensagem");
		out.println(resp);
%>
