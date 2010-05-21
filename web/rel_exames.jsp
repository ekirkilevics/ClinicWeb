<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.FichaAtendimento" id="ficha" scope="page"/>
<jsp:useBean class="recursos.Paciente" id="paciente" scope="page"/>

<%			
	String codcli   = request.getParameter("codcli") != null ? request.getParameter("codcli") : "";
	String nomepaciente = request.getParameter("nome") != null ? request.getParameter("nome") : "";
	String nascimento = "";	

	//Se escolheu o paciente, capturar os dados
	if(!codcli.equals("")) {
		String dadospaciente[] = paciente.getDadosPaciente(codcli);
		nascimento = dadospaciente[0];
	}
	
%>

<html>
<head>
<title>Laudos de Exames</title>
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
<script language="JavaScript" src="js/ajax.js"></script>
<script language="JavaScript">
     //id do convênio
     var idReg = "<%= strcod%>";

	//Sobrescrendo a função do AJAX
	function setar(chave, campo, valorchave, valorcampo) {
		cbeGetElementById(chave).value = valorchave;
		cbeGetElementById(campo).value = valorcampo;
		x.innerHTML = "";
		hide();
		cbeGetElementById("frmcadastrar").submit();
	}
	
	function iniciar() {
		cbeGetElementById("idade").value = getIdade("<%= nascimento%>");
		barrasessao();
	}	 

</script>
</head>

<body onLoad="iniciar()">
<%@include file="barrasessao.jsp" %>
<%@include file="barraajax.jsp" %>
<form name="frmcadastrar" id="frmcadastrar" action="rel_exames.jsp" method="post">
  <table width="600" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr> 
      <td height="18" class="title">.: Relatório: Laudos de Exames :.</td>
    </tr>
    <tr> 
      <td>&nbsp;</td>
    </tr>
    <tr style="height:25px"> 
      <td align="right"><span name='msg' id='msg' class="msg">&nbsp;</span></td>
    </tr>
    <tr align="center" valign="top"> 
      <td> <table width="600" border="0" cellpadding="0" cellspacing="0" class="table">
				<tr>
					<td class="tdMedium">Paciente:</td>
					<td colspan="3" class="tdLight">
              			<input type="hidden" name="codcli" id="codcli" value="<%= codcli %>">			
						<input style="width:100%" class="caixa" type="text" name="nome" id="nome" onKeyUp="busca(this.value, 'codcli', 'nome','paciente')" value="<%= nomepaciente%>">
					</td>
				</tr>
				<tr>
		            <td height="22" class="tdMedium">Nascimento:</td>
					<td width="300" class="tdLight">
						<input type="text" class="caixa" name="nascimento" id="nascimento" value="<%= nascimento%>" onKeyPress="return false;" size="10" >
					</td>
					<td class="tdMedium">Idade:</td>					
					<td class="tdLight"><input size="10" type="text" class="caixa" name="idade" id="idade" value=" onKeyPress="return false;"></td>
				</tr>
	        </table>
	  </td>
    </tr>
    <tr> 
      <td>&nbsp;</td>
    </tr>
	<%
		if(!codcli.equals("")) {
	%>
	<tr>
		<td width="100%" align="center">
			<table border="0" cellpadding="0" cellspacing="0" class="table">
				<tr>
					<td class="tdMedium">Exame</td>
					<td class="tdMedium">Data</td>
					<td class="tdMedium">Protocolo</td>
					<td class="tdMedium">Senha</td>
					<td class="tdMedium">Link</td>
				</tr>
				<%= ficha.getLaudos(codcli)%>
			</table>	
		</td>
	</tr>
	<%
		}
	%>
  </table>
</form>

</body>
</html>
