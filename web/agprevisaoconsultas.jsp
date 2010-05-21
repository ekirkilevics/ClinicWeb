<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.Cliente68" id="cliente68" scope="page"/>

<html>
<head>
<title>Relatório</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
<script language="JavaScript" src="js/ajax.js"></script>
<script language="javascript">
	function iniciar() {
		cbeGetElementById("mes").value = "<%= Util.getMes(Util.getData())%>";
		cbeGetElementById("ano").value = "<%= Util.getAno(Util.getData())%>";
		barrasessao();
	}
	
	function imprimir() {
		cbeGetElementById('iframeagenda').contentWindow.focus();
		cbeGetElementById('iframeagenda').contentWindow.print();
	}
	
</script>
</head>	

<body onLoad="iniciar()">
<%@include file="barrasessao.jsp" %>
<form name="frmcadastrar" id="frmcadastrar" action="agprevisaoconsultas2.jsp" target="iframeagenda" method="post">
  <table width="600" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr>
      <td height="18" class="title">.: Relatório de Previsão de Faturamento :.</td>
    </tr>
	<tr style="height:25px">
		<td align="right"><span name='msg' id='msg' class="msg">&nbsp;</span></td>
	</tr>
    <tr align="center" valign="top">
      <td>
         <table width="300" border="0" cellpadding="0" cellspacing="0" class="table">
			<tr>
				<td class="tdMedium">Mês: *</td>
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
                <td class="tdMedium">Ano: *</td>
                <td class="tdLight"><input type="text" name="ano" id="ano" class="caixa" size="4" maxlength="4" onKeyPress="Javascript:OnlyNumbersSemPonto(this,event);"></td>
			</tr>
            <tr>
            	<td class="tdMedium">Profissional:</td>
                <td colspan="3" class="tdLight">
                	<select name="prof_reg" id="prof_reg" class="caixa">
                        <%= cliente68.getProfissionais( cod_empresa)%>
                    </select>
                </td>
            </tr>
			<tr>
				<td colspan="4" class="tdMedium" align="right"><button type="submit" class="botao"><img src="images/busca.gif">&nbsp;&nbsp;&nbsp;Buscar</button></td>
			</tr>
            <tr>
         </table>
      </td>
    </tr>
  </table>
  <center>
  <div align="right" style="width:95%"><a href="Javascript:imprimir()" title="Imprimir Relatório"><img src="images/print.gif" border="0"></a></div>
  </center>
</form>

<center>
  <iframe name="iframeagenda" id="iframeagenda" width="620" height="400" scrolling="auto" frameborder="0"></iframe>
</center>
</body>
</html>
