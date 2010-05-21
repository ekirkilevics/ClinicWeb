<%@page import="recursos.*" %>
<%@page import="java.sql.*" %>

<jsp:useBean class="recursos.Lote" id="lote" scope="page"/>

<%
	String de = request.getParameter("de");
	String ate = request.getParameter("ate");
	
	String ret = lote.sincronizaGuias(de, ate, (String)session.getAttribute("codempresa"));
	
	if(ret.equals("OK"))
		response.sendRedirect("sincronizarguias.jsp?inf=Guias%20Sincronizadas%20com%20Sucesso");
	else
		response.sendRedirect("sincronizarguias.jsp?inf=Erro%20no%20Sincronismo&detalhes=" + ret);
		
%>
