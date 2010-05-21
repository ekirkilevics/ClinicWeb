<%@include file="cabecalho.jsp" %>
<%@page import="java.util.Vector" %>

<jsp:useBean class="recursos.Historico" id="historico" scope="page"/>
<jsp:useBean class="recursos.Paciente" id="paciente" scope="page"/>

<%
	String codcli   = request.getParameter("codcli") != null ? request.getParameter("codcli") : "";
	String nomepaciente = request.getParameter("nome") != null ? request.getParameter("nome") : "";
	String nascimento = "";	
	String resumo     = request.getParameter("resumo") != null ? request.getParameter("resumo") : "0";	

	if(ordem == null) ordem = "DTACON";

	//Se escolheu o paciente, capturar os dados
	if(!codcli.equals("")) {
		String dadospaciente[] = paciente.getDadosPaciente(codcli);
		nascimento = dadospaciente[0];
	}

	String alerta = historico.getAlertas(codcli);
%>

<html>
<head>
<title>Histórico</title>
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
<script language="JavaScript" src="js/ajax.js"></script>

<script language="JavaScript">
     //código do paciente
     var codcli = "<%= codcli%>";
	 //Informação vinda de gravarprocedimento
	 var inf = "<%= inf%>";
	 //Nome dos campos
	 var nome_campos_obrigatorios = Array();
	 //Página a enviar o formulário
	 var page = "gravarhistoricopac.jsp";
     //Campos obrigatórios
	 var campos_obrigatorios = Array();

	//Quantidade de alertas
	var qtdealertas = parseInt("<%= alerta%>");
	var msgbtn;
	 
	function imprimirHist(codhist)
	{
		displayPopup("relhistorico2.jsp?cod=" + codhist, "historia",525,790);
		barrasessao();
	}
	
	function iniciar()
	{	
		barrasessao();
		jsnascimento = "<%= nascimento%>";
		if(jsnascimento != "")
			cbeGetElementById("idade").value = getIdade(jsnascimento);
		hideAll();
	}
	
	function view(num)
	{
		eval("status=cbeGetElementById('tr"+num+"').style.display");
		if(status=="none") {
			eval("cbeGetElementById('tr"+num+"').style.display = 'block'");
			eval("cbeGetElementById('img"+num+"').src = 'images/minus.png'");
		}
		else {
			eval("cbeGetElementById('tr"+num+"').style.display = 'none'");
			eval("cbeGetElementById('img"+num+"').src = 'images/plus.png'");
		}
	}
	
	//Sobrescrendo a função do AJAX
	function setar(chave, campo, valorchave, valorcampo) {
		cbeGetElementById(chave).value = valorchave;
		cbeGetElementById(campo).value = valorcampo;
		x.innerHTML = "";
		hide();
		cbeGetElementById("frmcadastrar").submit();
	}
	
</script>
</head>

<body onLoad="iniciar();">
<%@include file="barrasessao.jsp" %>
<%@include file="barraajax.jsp" %>
<form name="frmcadastrar" id="frmcadastrar" action="relhistorico.jsp" method="post">
  <table width="600" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr>
      <td height="18" class="title"><a name="topo" class="title">.: Relatório de Histórico do Paciente :.</a></td>
    </tr>
	<tr style="height:25px">
		<td align="right"><span name='msg' id='msg' class="msg">&nbsp;</span></td>
	</tr>
    <tr align="center" valign="top">
      <td>
	  		<table width="100%" border="0" cellpadding="0" cellspacing="0" class="table">
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
					<td class="tdLight"><input size="10" type="text" class="caixa" name="idade" id="idade" value="" onKeyPress="return false;"></td>
				</tr>
				<tr>
		            <td height="22" class="tdMedium">Convênio:</td>
					<td colspan="3" width="300" class="tdLight">
						<select name="cod_plano" id="cod_plano" class="caixa" style="width:450px">
							<%= paciente.getConveniosCombo(codcli)%>
						</select>
					</td>
				</tr>
			</table>
	  </td>
    </tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
 </table>
<%
	if(!codcli.equals("")) {
%>
 <table width="600" border="0" align="center" cellpadding="0" cellspacing="0">
 	<tr>
		<td>
			<table border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td class="texto">Tipo de História&nbsp;&nbsp;</td>
					<td bgcolor="#FFCC99" height="10" width="20" style="border: 1px solid #000000">&nbsp;</td>
					<td class="texto">&nbsp;&nbsp;Resumo&nbsp;&nbsp;</td>
					<td bgcolor="#94AED6" height="10" width="20" style="border: 1px solid #000000">&nbsp;</td>
					<td class="texto">&nbsp;&nbsp;Temporária&nbsp;&nbsp;</td>
					<td bgcolor="#CCFFFF" height="10" width="20" style="border: 1px solid #000000">&nbsp;</td>
					<td class="texto">&nbsp;&nbsp;Definitiva&nbsp;&nbsp;</td>
				</tr>
			</table>
		</td>
	</tr>
 </table>
 <table width="100%" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr>
		<td width="100%" align="center">
		<%
			Vector resp = historico.getHistoriasRel(codcli, resumo);
			for(int i=0; i<resp.size(); i++)
				out.println(resp.get(i).toString());

		%>
		</td>
	</tr>
  </table>
<%
	} //Fim do If se não selecionou usuário ainda
%>

</form>

</body>
</html>
