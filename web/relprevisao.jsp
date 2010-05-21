<%@include file="cabecalho.jsp" %>
<%@page import="java.util.Vector" %>

<jsp:useBean class="recursos.Relatorio" id="relatorio" scope="page"/>

<%			
	String datainicio  = request.getParameter("datainicio");
	String datafim = request.getParameter("datafim");
%>
<html>
<head>
<title>Relatório de Previsão Mensal</title>
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
</head>

<body style="background-color:white">
	<br>
	<center>
	<b><pre class="texto" style="text-align:center"><%= configuracao.getItemConfig("cabecalho", cod_empresa) %></pre></b>
	<br>
	<div class="texto"><b>Relatório de Previsão Mensal</b><br>Período de <%= datainicio%> até <%= datafim%></div>	
	<br>

    <table cellpadding="0" cellspacing="0" width="100%">
        <tr>
          <td class='tblrel' align='center' style="background:black; color: white" width="30"><strong>Lote</strong></td>
          <td class='tblrel' style="background-color:black; color: white" width="150"><strong>Tipo de Guia</strong></td>
          <td class='tblrel' style="background-color:black; color: white" width="80"><strong>Data do Lote</strong></td>
          <td class='tblrel' style="background-color:black; color: white" width="80"><strong>Previsão de Pagto</strong></td>
          <td class='tblrel' style="background-color:black; color: white"><strong>Convênio</strong></td>
          <td class='tblrel' style="background-color:black; color: white" width="140"><strong>Valor</strong></td>
          <td class='tblrel' style="background-color:black; color: white" width="80"><strong>N.F.</strong></td>
          <td class='tblrel' style="background-color:black; color: white"><strong>Banco</strong></td>
          <td class='tblrel' style="background-color:black; color: white"><strong>Observações</strong></td>
        </tr>
	<%
		Vector resp = relatorio.getRelPrevisaoMensal(datainicio, datafim);
		for(int i=0; i<resp.size(); i++)
			out.println(resp.get(i).toString());
	%>
    </table>
    </center>
	<br>
<%@include file="tamanhofontes.jsp" %>    
</body>
</html>
