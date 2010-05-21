<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.Lote" id="lote" scope="page"/>

<%
	String chks[] = request.getParameterValues("chk");
	String cod_convenio = request.getParameter("cod_convenio");
	String tipoguia = request.getParameter("tipoGuia");
	String ret = "";
	
	//Se vier mais de 100 guias, voltar com erro
	if(chks != null && chks.length > 100) {
		response.sendRedirect("carregarlotes.jsp?inf=Mais%20de%20100%20guias%20selecionadas");		
	}
	else {
		ret = lote.gravarLote(chks, cod_convenio, tipoguia, cod_empresa);
		
		if(ret.equals("OK"))
			response.sendRedirect("lotes.jsp");
		else
			out.println(ret);
	}

%>