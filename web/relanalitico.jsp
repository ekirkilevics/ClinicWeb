<%@include file="cabecalho.jsp" %>
<%@page import="java.util.Vector" %>

<jsp:useBean class="recursos.Relatorio" id="relatorio" scope="page"/>

<%
	String de  = !Util.isNull(request.getParameter("de")) ? request.getParameter("de") : "";
	String ate = !Util.isNull(request.getParameter("ate")) ? request.getParameter("ate") : "";
%>

<html>
<head>
<title>Relatorio Analítico</title>
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
<script language="JavaScript">
	function validaForm() {
		var de = cbeGetElementById("de").value;
		var ate = cbeGetElementById("ate").value;

		if(de == "" || ate == "") {
			alert("Preencha o período da consulta");
			return false;
		}
		return true;
	}
</script>
</head>

<body onLoad="barrasessao();">
<%@include file="barrasessao.jsp" %>
<form name="frmcadastrar" id="frmcadastrar" action="relanalitico.jsp" method="post" onSubmit="return validaForm()">
  <table width="600" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr> 
      <td height="18" class="title">.: Relatório Analítico :.</td>
    </tr>
    <tr> 
      <td>&nbsp;</td>
    </tr>
    <tr style="height:25px"> 
      <td align="right"><span name='msg' id='msg' class="msg">&nbsp;</span></td>
    </tr>
    <tr align="center" valign="top"> 
      <td> 
      <table width="400" border="0" cellpadding="0" cellspacing="0" class="table">
			<tr>
				<td class="tdMedium">Data Início</td>
				<td class="tdLight"><input type="text" name="de" id="de" class="caixa" size="12" maxlength="10" onKeyPress="return formatar(this, event, '##/##/####');" value='01/<%= Util.getMes(Util.getData()) + "/" + Util.getAno(Util.getData())%>'></td>
				<td class="tdMedium">Data Fim</td>
				<td class="tdLight"><input type="text" name="ate" id="ate" class="caixa" size="12" maxlength="10" onKeyPress="return formatar(this, event, '##/##/####');" value="<%= Util.getData()%>"></td>
			</tr>
          <tr> 
			<td colspan="4" align="right" class="tdMedium">&nbsp;<button type="submit" class="botao"><img src="images/print.gif">&nbsp;&nbsp;&nbsp;Pesquisar</button>&nbsp;</td>
		  </tr>
        </table></td>
    </tr>
  </table>
</form>
<%
	if(!de.equals("") && !ate.equals("")) {
		Vector resp = relatorio.getRelatorioAnalitico(de, ate, cod_empresa);
		for(int i=0; i<resp.size(); i++)
				out.println(resp.get(i).toString());
	}
%>

</body>
</html>
