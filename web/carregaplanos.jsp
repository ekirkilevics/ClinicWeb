<%@page contentType="text/xml"%>
<%@page pageEncoding="UTF-8"%>

<jsp:useBean class="recursos.Paciente" id="paciente" scope="page"/>

<%
    response.setHeader("Cache-Control", "no-cache");
    response.setHeader("Pragma", "no-cache");
	out.println(paciente.getPlanos(request.getParameter("cod_convenio"), request.getParameter("cod_plano"), request.getParameter("tipolista")));
%>