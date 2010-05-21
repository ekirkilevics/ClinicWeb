<%@page import="recursos.*" %>
<%@page import="java.sql.*" %>

<jsp:useBean class="recursos.Conta" id="conta" scope="page"/>

<%
	String chks[] = request.getParameterValues("chk");
	String resp = conta.gravarContasReceber(chks, request);
	
	response.sendRedirect("contasreceber.jsp?inf=" + resp);
%>