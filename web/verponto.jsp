<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.Ponto" id="ponto" scope="page"/>

<%
	String usuario = usuario_logado;
	String mes = request.getParameter("mes") != null ? request.getParameter("mes") : Integer.parseInt(Util.getMes(Util.getData())) + "";
	String ano = request.getParameter("ano") != null ? request.getParameter("ano") : Util.getAno(Util.getData());
%>
<html>
<head>
<title>Relatório</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
<script language="JavaScript">
     //id do convênio
     var idReg = "<%= strcod%>";
	
	 function validaForm() {
		barrasessao();
		return true;
	 }
	 
	 function iniciar() {
	 	cbeGetElementById("mes").value = "<%= mes%>";
	 }

</script>
</head>

<body onLoad="iniciar();">
<form name="frmcadastrar" id="frmcadastrar" action="verponto.jsp" method="post" onSubmit="return validaForm()">
  <table width="600" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr>
      <td height="18" class="title">.: Relatório: Ponto :.</td>
    </tr>
	<tr style="height:25px">
		<td align="right"><span name='msg' id='msg' class="msg">&nbsp;</span></td>
	</tr>
    <tr align="center" valign="top">
      <td>
         <table width="300" border="0" cellpadding="0" cellspacing="0" class="table">
		 	<tr>
				<td colspan="5" class="tdMedium" align="center"><b>Pesquisa de Lançamentos</b></td>
			</tr>
			<tr>
				<td class="tdMedium">Mês</td>
				<td class="tdLight">
					<select name="mes" id="mes" class="caixa">
						<option value="1">Janeiro</option>
						<option value="2">Fevereiro</option>
						<option value="3">Março</option>
						<option value="4">Abril</option>
						<option value="5">Maio</option>
						<option value="6">Junho</option>
						<option value="7">Julho</option>
						<option value="8">Agosto</option>
						<option value="9">Setembro</option>
						<option value="10">Outubro</option>
						<option value="11">Novembro</option>
						<option value="12">Dezembro</option>
					</select>
				</td>
				<td class="tdMedium">Ano</td>
				<td class="tdLight">
					<input type="text" name="ano" id="ano" class="caixa" size="7" maxlength="4" onKeyPress="return formatar(this, event, '####');" value="<%= ano%>">
				</td>
			</tr>
			<tr>
				<td colspan="4" class="tdMedium" align="right"><button type="submit" class="botao"><img src="images/16.gif">&nbsp;&nbsp;&nbsp;Buscar</button></td>
			</tr>
         </table>
      </td>
    </tr>
  </table>
</form>

<% 
	if(usuario != null) { 
%>
	<center>
	<table class='table' cellspacing=0 cellpadding=0 width="600">
<%
		Vector resp = ponto.getLancamentosIndividual(usuario, mes, ano);
		for(int i=0; i<resp.size(); i++)
			out.println(resp.get(i));
%>
	</table>
	</center>
<%	} %>

</body>
</html>
