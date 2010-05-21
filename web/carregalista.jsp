<%@page contentType="text/xml"%>
<%@page pageEncoding="UTF-8"%>
<%@page import="recursos.*" %>
<%@page import="java.util.Vector" %>

<jsp:useBean class="recursos.Banco" id="banco" scope="page"/>
<jsp:useBean class="recursos.Profissional" id="profissional" scope="page"/>

<%
    response.setHeader("Cache-Control", "no-cache");
    response.setHeader("Pragma", "no-cache");

	//Recebendo parâmetros
	String query = request.getParameter("q") != null ? request.getParameter("q") : "";
	String chave = request.getParameter("key") != null ? request.getParameter("key") : "";
	String campo = request.getParameter("fld") != null ? request.getParameter("fld") : "";
	String tabela = request.getParameter("tbl") != null ? request.getParameter("tbl") : "";
	String complemento = request.getParameter("cpt") != null ? request.getParameter("cpt") : "";
	
	//Captura dados do profissional logado
	String proflogado[] = profissional.getProfissional((String)session.getAttribute("usuario"));	
		
	Vector resp = banco.getItensAjax(query, chave, campo, tabela, (String)session.getAttribute("codempresa"), complemento, proflogado[0]);
	for(int i=0; i<resp.size(); i++)
		out.println(resp.get(i).toString());
%>