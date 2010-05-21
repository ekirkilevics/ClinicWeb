<%@include file="cabecalho.jsp" %>
<%@page import="java.util.Vector" %>

<jsp:useBean class="recursos.Relatorio" id="relatorio" scope="page"/>

<%			
	String de  = request.getParameter("de");
	String ate  = request.getParameter("ate");
	String cod_comercial  = request.getParameter("cod_comercial");
%>
<html>
<head>
<title>Relatório de Medicamentos</title>
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
<script language="javascript">
	function verHistorias(codcli) {
		parent.location = "historicopac.jsp?codcli=" + codcli;
	}
</script>
</head>

<body>
<center>		
	<table width="500" border="0" cellpadding="0" cellspacing="0" class="table">
		<tr>
        	<td class="tdDark">Paciente</td>
            <td width="50" class="tdDark" align="center">Qtde.</td>
        </tr>
	<%
		if(de != null && ate != null && cod_comercial != null) {
			Vector resp = relatorio.getRelMedicamentos(de, ate, cod_comercial);
			for(int i=0; i<resp.size(); i++)
				out.println(resp.get(i).toString());
		}
	%>
	</table>
</center>
</body>
</html>
