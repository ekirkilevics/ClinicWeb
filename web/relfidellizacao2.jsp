<%@include file="cabecalho.jsp" %>
<%
	String de = request.getParameter("de");
	String ate = request.getParameter("ate");
	String grupoproced = request.getParameter("grupoproced");
	String qtde = request.getParameter("qtde");
%>

<jsp:useBean class="recursos.Relatorio" id="relatorio" scope="page"/>

<html>
<head>
<title>Relat�rio</title>
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
	<div class="texto"><b>Relat�rio: Fideliza��o</b><br>Per�odo de <%= de%> at� <%= ate%></div>
	<br>
	<div class="texto">Procedimento: <b><script>document.write(proced);</script></b></div>	
	<div class="texto">Frequ�ncia: >= <%= qtde%> consultas</div>
	<br>
	</center>
  <table width="600" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr align="center" valign="top">
      <td>
 		 <%
				
				//Se veio algum valor, fazer a consulta
				if(de != null && ate != null) {
					out.println("<table border='0' cellspading='0' cellspacing='0' width='100%'>");
					Vector resp = relatorio.getFidelizacao(de, ate, grupoproced, qtde, cod_empresa);
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
