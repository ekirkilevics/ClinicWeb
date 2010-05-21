<%@page import="recursos.*" %>
<%@page import="java.sql.*" %>

<jsp:useBean class="recursos.Banco" id="banco" scope="page"/>

<%
	String codag  = request.getParameter("codag");
	out.println("Cod. Agenda:" + codag);
	String sql = "";
	
	//Verifica o status atual
	String statusatual = banco.getValor("status", "SELECT status FROM agendamento WHERE agendamento_id=" + codag);
	
	//Só altera se não foi atendido ainda
	if(!statusatual.equals("9")) {
		
		//Se estiver não chegou, colocar atendido
		if(statusatual.equals("3"))
			sql = "UPDATE agendamento set status=1 WHERE agendamento_id=" + codag;
		else
			sql = "UPDATE agendamento set status=3 WHERE agendamento_id=" + codag;
		
		out.println("Atualilza Status:" + banco.executaSQL(sql));
	}
	

	//Se ainda não tinha chegado, colocar a hora de chegada
	if(statusatual.equals("3")) {
		sql = "UPDATE agendamento set obs=CONCAT_WS('',obs, ' - Hora de Chegada: " + Util.getHora() + "') WHERE agendamento_id=" + codag;
		out.println("Atualiza hora:" + banco.executaSQL(sql));
	}
%>
<html>
<head>
<script language="javascript">


	function iniciar() {
		
		var jsstatusatual = "<%= banco.getValor("status", "SELECT status FROM agendamento WHERE agendamento_id=" + codag) %>";
		var id = "<%= codag %>";
		parent.alteraImagemStatus(jsstatusatual, id);

	}

</script>
</head>
<body onLoad="iniciar()">
</body>
</html>
