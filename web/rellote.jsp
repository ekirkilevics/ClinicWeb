<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.Lote" id="lote" scope="page"/>

<html>
<head>
<title>Relatório</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
<script type="text/javascript" src="js/calendarDateInput.js"></script>
<script language="JavaScript">
     //id do convênio
     var idReg = "<%= strcod%>";

	function gerarLista() {
		var frm = cbeGetElementById("frmcadastrar");
		frm.action = "relprevisao.jsp";
		frm.target = "_blank";
		frm.submit();
	}

</script>
</head>

<body onLoad="barrasessao();">
<%@include file="barrasessao.jsp" %>
<form name="frmcadastrar" id="frmcadastrar" action="#" method="post">
  <table width="600" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr>
      <td height="18" class="title">.: Relatório de Previsão Mensal :.</td>
    </tr>
	<tr style="height:25px">
		<td align="right"><span name='msg' id='msg' class="msg">&nbsp;</span></td>
	</tr>
    <tr align="center" valign="top">
      <td>
         <table width="300" border="0" cellpadding="0" cellspacing="0" class="table">
            <tr>
                <td class="tdMedium" width="80">Data Início:</td>
                <td class="tdLight"><script>DateInput('datainicio', true, 'DD/MM/YYYY','<%= Util.getData()%>')</script></td>
            </tr>
            <tr>
                <td class="tdMedium" width="80">Data Fim:</td>
                <td class="tdLight"><script>DateInput('datafim', true, 'DD/MM/YYYY','<%= Util.getData()%>')</script></td>
            </tr>
			<tr>
				<td colspan="2" class="tdMedium" align="center"><button type="button" class="botao" onClick="Javascript:gerarLista()"><img src="images/print.gif">&nbsp;&nbsp;&nbsp;Imprimir</button></td>
			</tr>
         </table>
      </td>
    </tr>
  </table>
</form>

</body>
</html>
