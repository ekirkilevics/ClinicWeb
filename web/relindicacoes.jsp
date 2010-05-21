<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.Relatorio" id="relatorio" scope="page"/>

<%			
	String de  = request.getParameter("de");
	String ate = request.getParameter("ate");
%>

<html>
<head>
<title>Indicações</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
<script language="JavaScript">
     //id 
     var idReg = "<%= strcod%>";
	
	 function validaForm() {
		var vde = getObj("","de");
		var vate = getObj("","ate");
	
		if(vde.value == "") {
			alert("Preencha data de início da pesquisa.");
			vde.focus();
			return false;
		}

		if(vate.value == "") {
			alert("Preencha data de fim da pesquisa.");
			vate.focus();
			return false;
		}

		barrasessao();
		return true;
	 }

</script>
</head>

<body onLoad="barrasessao();">
<%@include file="barrasessao.jsp" %>
<form name="frmcadastrar" id="frmcadastrar" action="relindicacoes.jsp" method="post" onSubmit="return validaForm()">
  <table width="600" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr>
      <td height="18" class="title">.: Relatório: Indicações :.</td>
    </tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr style="height:25px">
		<td align="right"><span name='msg' id='msg' class="msg">&nbsp;</span></td>
	</tr>
    <tr align="center" valign="top">
      <td>
         <table width="300" border="0" cellpadding="0" cellspacing="0" class="table">
		 	<tr>
				<td colspan="5" class="tdMedium" align="center"><b>Filtros</b></td>
			</tr>
			<tr>
				<td class="tdMedium">Data Início</td>
				<td class="tdLight"><input type="text" name="de" id="de" class="caixa" size="12" maxlength="10" onKeyPress="return formatar(this, event, '##/##/####');" value='01/<%= Util.getMes(Util.getData()) + "/" + Util.getAno(Util.getData())%>'></td>
				<td class="tdMedium">Data Fim</td>
				<td class="tdLight"><input type="text" name="ate" id="ate" class="caixa" size="12" maxlength="10" onKeyPress="return formatar(this, event, '##/##/####');" value="<%= Util.getData()%>"></td>
			</tr>
			<tr>
				<td colspan="4" class="tdMedium" align="right"><input type="submit" class="botao" value="Buscar"></td>
			</tr>
         </table>
		 <br>
		 <% if(!Util.isNull(de)) {%>
			<table width="500" border="0" cellpadding="0" cellspacing="0" class="table">
			<%
				out.println(relatorio.getRelIndicacoes(de, ate, cod_empresa));
			%>
			</table>		 
			<br>
			<table width="500" border="0" cellpadding="0" cellspacing="0" class="table">
				<tr>
					<td colspan="2" class="tdMedium" style="text-align:center"><strong>Outras Indicações</strong></td>
				</tr>
			<%
				out.println(relatorio.getRelIndicacoesOutros(de, ate, cod_empresa));
			%>
			</table>		 
		 <% }%>
      </td>
    </tr>
  </table>
</form>

</body>
</html>
