<%@include file="cabecalho.jsp" %>
<%@page import="java.util.Vector" %>

<jsp:useBean class="recursos.Conta" id="conta" scope="page"/>
<%
	String de = "01/" + Util.getMes(Util.getData()) + "/" + Util.getAno(Util.getData());
	String ate = Util.getData();
%>

<html>
<head>
<title>Fluxo de Caixa</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
<script language="JavaScript" src="js/ajax.js"></script>
<script language="JavaScript">
     //id do convênio
     var idReg = "<%= strcod%>";
 	 //Informação vinda de gravar
	 var inf = "<%= inf%>";
	
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

	function iniciar() {
		barrasessao();	
	}

	 

</script>
</head>

<body onLoad="iniciar()">
<%@include file="barrasessao.jsp" %>
<form name="frmcadastrar" id="frmcadastrar" action="relcontaspagarreceber2.jsp" method="post" onSubmit="return validaForm()" target="_blank">
  <table width="600" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr>
      <td height="18" class="title">.: Fluxo de Caixa :.</td>
    </tr>
	<tr style="height:25px">
		<td align="right"><span name='msg' id='msg' class="msg">&nbsp;</span></td>
	</tr>
    <tr align="center" valign="top">
      <td>
         <table width="500" border="0" cellpadding="0" cellspacing="0" class="table">
		 	<tr>
              <td height="21" colspan="4" align="center" class="tdMedium"><b>Filtros</b></td>
			</tr>
			<tr>
				<td class="tdMedium" width="25%">Data Início</td>
				<td class="tdLight" width="25%"><input type="text" name="de" id="de" class="caixa" size="12" maxlength="10" onKeyPress="return formatar(this, event, '##/##/####');" value='<%= de%>'></td>
				<td class="tdMedium" width="25%">Data Fim</td>
				<td class="tdLight" width="25%"><input type="text" name="ate" id="ate" class="caixa" size="12" maxlength="10" onKeyPress="return formatar(this, event, '##/##/####');" value="<%= ate%>"></td>
			</tr>
			<tr>
            	<td colspan="2" class="tdMedium" align="center">Contas a Pagar</td>
                <td colspan="2" class="tdMedium" align="center">Contas a Receber</td>
            </tr>
            <tr>
            	<td class="tdLight"><input type="checkbox" name="cp_pagar" id="cp_pagar" value="S" checked>A pagar</td>
            	<td class="tdLight"><input type="checkbox" name="cp_pagos" id="cp_pagos" value="S" checked>Pagos</td>
            	<td class="tdLight"><input type="checkbox" name="cr_receber" id="cr_receber" value="S" checked>A receber</td>
            	<td class="tdLight"><input type="checkbox" name="cr_recebidos" id="cr_recebidos" value="S" checked>Recebidos</td>
            </tr>
			<tr>
				<td colspan="4" class="tdMedium" align="right"><button type="submit" class="botao" name="botao" value="OK"><img src="images/print.gif">&nbsp;&nbsp;&nbsp;Imprimir</button></td>
			</tr>
         </table>
      </td>
    </tr>
  </table>
  </center>
</form>

</body>
</html>
