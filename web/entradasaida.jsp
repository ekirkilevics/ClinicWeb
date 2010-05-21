<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.Atendimento" id="atendimento" scope="page"/>

<%
	if(strcod != null) rs = banco.getRegistro("entradasaida","cod_entradasaida", Integer.parseInt(strcod) );
	if(Util.isNull(ordem)) ordem = "entradasaida";
%>

<html>
<head>
<title>Entradas e Saídas</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
<script language="JavaScript">
     //id
     var idReg = "<%= strcod%>";
	 //Informação vinda de gravar
	 var inf = "<%= inf%>";
	 //Nome dos campos
	 var nome_campos_obrigatorios = Array("Descrição", "Tipo");
	 //Página a enviar o formulário
	 var page = "gravarentradasaida.jsp";
     //Campos obrigatórios
	 var campos_obrigatorios = Array("entradasaida", "tipolocal");
	 
	 function iniciar() {
	 	cbeGetElementById("tipolocal").value = "<%= banco.getCampo("tipo", rs) %>";
		inicio();
		barrasessao();
	 }
	
	function clickBotaoNovo() {
		botaoNovo();
	}
	
	function clickBotaoSalvar() {
		enviarAcao('inc');
	}
	
	function clickBotaoExcluir() {
		enviarAcao('exc');
	}	 

</script>
</head>

<body onLoad="iniciar()">
<%@include file="barrasessao.jsp" %>
<form name="frmcadastrar" id="frmcadastrar" action="gravarentradasaida.jsp" method="post">
  <table width="600" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr>
      <td width="651" height="18" class="title">.: Entradas e Saídas :.</td>
    </tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td align="right"><span name='msg' id='msg' class="msg">&nbsp;</span></td>
	</tr>
    <tr align="center" valign="top">
      <td>
          <table width="100%" border="0" cellpadding="0" cellspacing="0" class="table">
            <tr>
	            <td class="tdMedium">Descrição: *</td>
              	<td class="tdLight"><input name="entradasaida" type="text" class="caixa" id="entradasaida" value="<%= banco.getCampo("entradasaida", rs) %>" size="85" maxlength="100"></td>
            </tr>
			<tr>
				<td class="tdMedium">Tipo: *</td>
				<td class="tdLight">
					<select name="tipolocal" id="tipolocal" class="caixa">
						<option value="P">Procedente</option>
						<option value="E">Encaminhado</option>
					</select>
				</td>
			</tr>
          </table>
      </td>
    </tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<%= Util.getBotoes("entradasaida", pesq, tipo) %>
	<tr>
		<td>&nbsp;</td>
	</tr>
    <tr>
		<td width="100%" style="text-align:center">
			<table width="600px">
				<tr>
					<td class="tdDark">Descrição</td>
					<td width="40" class="tdDark">Tipo</td>
				</tr>
			</table>
			<div style="width:600; height:101; overflow: auto">
				<table width="100%">
				    <%
						String resp[] = atendimento.getEntradasSaidas(pesq, "entradasaida", ordem, numPag, 50, tipo, cod_empresa);
						out.println(resp[0]);
					%>
				</table>
			</div>
			<table width="600px">
				<tr>
					<td colspan="2" class="tdMedium" style="text-align:right"><%= resp[1]%></td>
				</tr>
			</table>
		</td>
	</tr>
  </table>
</form>

</body>
</html>
