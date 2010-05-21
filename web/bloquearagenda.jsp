<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.Feriado" id="feriado" scope="page"/>

<%
	//Parêmetros
	String prof_reg = request.getParameter("prof_reg");
	String data = request.getParameter("data");
	String hora = request.getParameter("hora");
	String ret = "";
	String cod_bloqueio = request.getParameter("cod_bloqueio");
	String qs = request.getQueryString();
	int pos = 0;
	pos = qs.indexOf("&inf");
	if(pos > 0) qs = qs.substring(0, pos);

	
	if(!Util.isNull(cod_bloqueio)) {
		ret = feriado.removeBloqueio( cod_bloqueio );
		pos = qs.indexOf("&cod_bloqueio");
		if(pos > 0) qs = qs.substring(0, pos);
	}
	else {
		ret = feriado.insereBloqueio(prof_reg, data, hora, cod_empresa);
		pos = qs.indexOf("&prof_reg");
		if(pos > 0) qs = qs.substring(0, pos);
	}
	
	if(ret.equals("OK"))
		response.sendRedirect("detalheagenda.jsp?" + qs);
	else if(ret.equals("intervalo"))
		response.sendRedirect("detalheagenda.jsp?" + qs + "&inf=intervalo");
	else
		out.println(ret);
%>
