<%@include file="cabecalho.jsp" %>
<%@page import="java.util.Vector" %>

<jsp:useBean class="recursos.Historico" id="historico" scope="page"/>
<jsp:useBean class="recursos.Paciente" id="paciente" scope="page"/>

<%
	String codcli1 = request.getParameter("codcli1");
	String codcli2 = request.getParameter("codcli2");
	
	String ret = banco.transfereDados(codcli1, codcli2);
%>

<html>
<head>
<title>Histórico</title>
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
<script language="JavaScript" src="js/ajax.js"></script>
<script language="JavaScript">

	var ret = "<%= ret%>";

	function iniciar() {
		barrasessao();
		if(ret != "") {
			if(ret == "OK") {
				alert("Informações transferidos com sucesso!");
			}
			else {
				alert(ret);
			}
		}
	}
	
	function buscarPaciente(num) {
		displayPopup("escolhepaciente.jsp?num=" + num,'popuppaciente',150,500);
	}
	
	function executar() {
		var frm = cbeGetElementById("frmcadastrar");
		if(frm.codcli1.value == "") {
			mensagem("Selecione o paciente 1",2);
			return;
		}
		if(frm.codcli2.value == "") {
			mensagem("Selecione o paciente 2",2);
			return;
		}
		frm.submit();
	}
	
</script>
</head>

<body onLoad="iniciar();">
<%@include file="barrasessao.jsp" %>
<form name="frmcadastrar" id="frmcadastrar" action="juntaduplicados.jsp" method="post">
  <table width="600" border="0" align="center" cellpadding="0" cellspacing="0">
    <tr>
      <td height="18" class="title">.: Remove Duplicidade :.</td>
    </tr>
	<tr style="height:25px">
		<td align="right"><span name='msg' id='msg' class="msg">&nbsp;</span></td>
	</tr>
    <tr align="center" valign="top">
      <td>
	  		<table width="100%" border="0" cellpadding="0" cellspacing="0" class="table">
				<tr>
		            <td width="100" class="tdMedium">Paciente que será apagado:</td>
		            <td class="tdLight" nowrap> 
              			<input type="hidden" name="codcli1" id="codcli1">			
						<input style="width:98%" class="caixa" type="text" name="nome1" id="nome1" onKeyPress="return false;">
					</td>
					<td class="tdMedium" width="80" align="center"><button type="button" class="botao" onClick="buscarPaciente(1)"><img src="images/busca.gif">&nbsp;&nbsp;Escolher</button></td>
				</tr>
				<tr>
		            <td width="100" class="tdMedium">Paciente que será mantido:</td>
		            <td class="tdLight" nowrap> 
              			<input type="hidden" name="codcli2" id="codcli2">			
						<input style="width:98%" class="caixa" type="text" name="nome2" id="nome2"  onKeyPress="return false;">
					</td>
					<td class="tdMedium" width="80" align="center"><button type="button" class="botao" onClick="buscarPaciente(2)"><img src="images/busca.gif">&nbsp;&nbsp;Escolher</button></td>
				</tr>
				<tr>
					<td colspan="3" class="tdMedium" align="center"><button type="button" class="botao" onClick="executar()"><img src="images/4.gif">&nbsp;&nbsp;&nbsp;Transferir</button></td>
				</tr>
			</table>
	  </td>
    </tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
</table>

</form>

</body>
</html>
