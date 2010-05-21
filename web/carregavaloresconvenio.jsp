<%@page contentType="text/xml"%>
<%@page pageEncoding="UTF-8"%>

<jsp:useBean class="recursos.HonorarioIndividual" id="honorario" scope="page"/>

<%
    response.setHeader("Cache-Control", "no-cache");
    response.setHeader("Pragma", "no-cache");
	out.println(honorario.getProcedimentos(request.getParameter("cod_plano")));
%>