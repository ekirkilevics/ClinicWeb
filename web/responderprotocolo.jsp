<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.Paciente" id="paciente" scope="page"/>

<%
	//Se receber parâmetros, usá-los, senão, considerar vazio
	String nascimento     	= "";
	String idade     		= "";
	String codcli   		= request.getParameter("codcli") != null ? request.getParameter("codcli") : "";
	String nomepaciente 	= request.getParameter("nome") != null ? request.getParameter("nome") : "";

	//Se escolheu o paciente, capturar os dados
	if(!codcli.equals("")) {
		String dadospaciente[] = paciente.getDadosPaciente(codcli);
		nascimento = dadospaciente[0];
	}
	
%>

<html>
<head>
<title>Aplicar Protocolo</title>
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
<script language="JavaScript" src="js/ajax.js"></script>
<script language="JavaScript">
     //id
     var idReg= "<%= strcod%>";
	 //Informação vinda de gravar
	 var inf = "<%= inf%>";
	 //Nome dos campos
	 var nome_campos_obrigatorios = Array("Nome");
	 //Página a enviar o formulário
	 var page = "#";
	 //Cod. da ajuda
	 cod_ajuda = 12;
	 
	 var codcli = "<%= codcli%>";

     //Campos obrigatórios
	 var campos_obrigatorios = Array("cocli");

	//Sobrescrendo a função do AJAX
	function setar(chave, campo, valorchave, valorcampo) {
		cbeGetElementById(chave).value = valorchave;
		cbeGetElementById(campo).value = valorcampo;
		x.innerHTML = "";
		hide();
		cbeGetElementById("frmcadastrar").submit();
	}
	 
	 function iniciar() {
	 	barrasessao();
		cbeGetElementById("nome").focus();
		var jsnasc = "<%= nascimento%>";
		if(jsnasc != "") {
			cbeGetElementById("idade").value = getIdade(jsnasc);
		}
	 }
	 

	function limparRegistro() {
		//Se já está escolhido paciente, apagar e começar novamente
		if(codcli != "") self.location = "responderprotocolo.jsp";
	}
	
	function responderProtocolo() {
		if(codcli == "") {
			mensagem("Selecione o paciente", 2);
			return;
		}
	
		window.open('aplicarprotocolo.jsp?codcli=' + codcli,'protocolos','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,menubar=no,width=650,height=450,top=10,left=10');			
	}
	
	 
</script>
</head>

<body onLoad="iniciar();">
<%@include file="barrasessao.jsp" %>
<%@include file="barraajax.jsp" %>
<form name="frmcadastrar" id="frmcadastrar" action="responderprotocolo.jsp" method="post">
  <table width="600" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr>
      <td width="651" height="18" class="title">.: Aplicar Protocolo :.</td>
    </tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr style="height:25px">
		<td align="right"><span name='msg' id='msg' class="msg">&nbsp;</span></td>
	</tr>
    <tr align="center" valign="top">
      <td>
	  		<table width="100%" border="0" cellpadding="0" cellspacing="0" class="table">
				<tr>
					<td class="tdMedium"><a href="Javascript:pesquisapornascimento(2)" title="Pesquisa por nome">Paciente:</a>&nbsp;<a href="Javascript:pesquisapornascimento(1)" title="Pesquisa por data de nascimento"><img src="images/calendar.gif" border="0"></a></td>
					<td colspan="3" class="tdLight">
              			<input type="hidden" name="codcli" id="codcli" value="<%= codcli %>">			
						<input style="width:100%" class="caixa" type="text" name="nome" id="nome" onKeyUp="busca(this.value, 'codcli', 'nome','paciente')" value="<%= nomepaciente%>"  onClick="limparRegistro()">
						<input size="10" class="caixa" type="text" name="pesqnascimento" id="pesqnascimento" onKeyPress="buscanascimento(this.value, event); return formatar(this, event, '##/##/####');" style="display: none">						
					</td>
				</tr>
				<tr>
					<td class="tdMedium">Nascimento:</td>
					<td width="300" class="tdLight"><input type="text" class="caixa" name="nascimento" id="nascimento" onKeyPress="return false;" value="<%= nascimento%>"></td>
					<td class="tdMedium">Idade:</td>					
					<td class="tdLight">
						<input size="10" type="text" class="caixa" name="idade" id="idade" onKeyPress="return false;" value="<%= idade%>">
						<input type="hidden" name="convenio" id="convenio">
					</td>
				</tr>
                <tr>
                	<td colspan="4" align="right" class="tdMedium"><button class="botao" type="button" onClick="responderProtocolo()"><img src="images/26.gif">&nbsp;&nbsp;&nbsp;Aplicar Protocolo&nbsp;</button></td>
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
