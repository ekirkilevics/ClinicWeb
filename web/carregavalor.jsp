<%@page pageEncoding="UTF-8"%>

<jsp:useBean class="recursos.HonorarioIndividual" id="honorario" scope="page"/>

<%
    response.setHeader("Cache-Control", "no-cache");
    response.setHeader("Pragma", "no-cache");
	String cod_proced = request.getParameter("cod_proced");
	String cod_plano = request.getParameter("cod_plano");
	String gp = request.getParameter("gp"); //Grau de Participa��o
	String ta = request.getParameter("ta"); //Tipo de Acomoda��o
	String hi = request.getParameter("hi"); //Hora Inicial
	String tp = request.getParameter("tp"); //Tipo de procedimentp (Urg�ncia ou Eletivo)
	String dt = request.getParameter("dt"); //Data do procedimento
	String va = request.getParameter("va"); //Via de Acesso
	
	out.println(honorario.getValorProcedimento(cod_proced, cod_plano, gp, ta, hi, tp, dt, va));
%>