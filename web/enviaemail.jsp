<%@page import="recursos.*" %>
<%@page import="java.sql.*" %>

<jsp:useBean class="recursos.Email" id="email" scope="page"/>

<%
   		boolean resp = email.sendMail("amiltonmartha@katusis.com.br", "Aviso Automático: Exclusão de Agenda (médico)","teste de mensagem");
		out.println(resp);
%>
