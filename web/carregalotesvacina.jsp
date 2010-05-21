<%@page contentType="text/xml"%>
<%@page pageEncoding="UTF-8"%>

<jsp:useBean class="recursos.Vacina" id="vacina" scope="page"/>

<%
    response.setHeader("Cache-Control", "no-cache");
    response.setHeader("Pragma", "no-cache");
	out.println(vacina.getLotesVacina(request.getParameter("cod_vacina")));
%>