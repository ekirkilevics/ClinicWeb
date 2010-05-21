<%@include file="cabecalho.jsp" %>
<%
	String de = request.getParameter("de");
	String ate = request.getParameter("ate");
	String grupoproced = request.getParameter("grupoproced");
%>

<jsp:useBean class="recursos.Relatorio" id="relatorio" scope="page"/>

<html>
<head>
<title>Relatório</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
<script language="JavaScript">
	
	var frm = window.opener.document.frmcadastrar;
	var proced = frm.grupoproced[frm.grupoproced.selectedIndex].text;

</script>
</head>

<body style="background-color:white">
	<center>
	<b><pre class="texto" style="text-align:center"><%= configuracao.getItemConfig("cabecalho", cod_empresa) %></pre></b>
	<br>
	<div class="texto"><b>Relatório: Atendimento Único</b><br>Período de <%= de%> até <%= ate%></div>
	<br>
	<div class="texto">Procedimento: <b><script>document.write(proced);</script></b></div>	
	<br>
	</center>
  <table width="600" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr align="center" valign="top">
      <td>
 		 <%
				
				//Se veio algum valor, fazer a consulta
				if(de != null && ate != null) {
					out.println("<table border='0' cellspading='0' cellspacing='0' width='100%'>");
					Vector resp = relatorio.getPacientesPrimeiraConsulta(de, ate, grupoproced, cod_empresa);
					for(int i=0; i<resp.size(); i++)
						out.println(resp.get(i).toString());
					out.println("</table>");
				}
		 %>
      </td>
    </tr>
  </table>

</body>
</html>
