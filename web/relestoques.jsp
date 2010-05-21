<%@include file="cabecalho.jsp" %>
<%@page import="java.util.Vector" %>

<jsp:useBean class="recursos.Vacina" id="vacina" scope="page"/>

<%
	String data = Util.isNull(request.getParameter("data")) ? Util.getData() : request.getParameter("data");
%>

<html>
<head>
<title>Relatório</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
<script language="JavaScript" src="js/ajax.js"></script>
<script language="JavaScript">
     //id do convênio
     var idReg = "<%= strcod%>";
	
	 function validaForm() {
		var vde = getObj("","data");
	
		if(vde.value == "") {
			alert("Preencha a data limite de pesquisa");
			vde.focus();
			return false;
		}
		
		return true;
	 }


</script>
</head>

<body onLoad="barrasessao();">
<%@include file="barrasessao.jsp" %>
<form name="frmcadastrar" id="frmcadastrar" action="relestoques.jsp" method="post" onSubmit="return validaForm()">
  <table width="600" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr>
      <td height="18" class="title">.: Relatório de Estoque de Vacinas :.</td>
    </tr>
	<tr style="height:25px">
		<td align="right"><span name='msg' id='msg' class="msg">&nbsp;</span></td>
	</tr>
    <tr align="center" valign="top">
      <td>
		<table cellpadding="0" cellspacing="0" width="100%" class="table">
			<tr>
				<td class="tdMedium">Data Consulta:</td>
				<td class="tdLight"><input type="text" name="data" id="data" class="caixa" size="12" maxlength="10" onKeyPress="return formatar(this, event, '##/##/####');" value='<%= data%>'></td>
				<td class="tdMedium" align="center"><input type="submit" value="Pesquisar" class="botao"></td>
			</tr>
		</table>
	  </td>
	</tr>
	<tr>
	<td>&nbsp;</td>
	</tr>
	<tr>
	  <td>
	  	<table cellpadding="0" cellspacing="0" width="100%">
		<%
			Vector resp = vacina.getRelEstoque(cod_empresa, data);
			for(int i=0; i<resp.size(); i++)
				out.println(resp.get(i).toString());
		%>
		</table>
      </td>
    </tr>
  </table>
</form>

</body>
</html>
