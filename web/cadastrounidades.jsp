<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.Vacina" id="vacina" scope="page"/>

<%
	if(strcod != null) rs = banco.getRegistro("vac_unidades","cod_unidade", Integer.parseInt(strcod) );
	if(Util.isNull(ordem)) ordem = "nome";
%>

<html>
<head>
<title>Cadastro de Unidades</title>
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
	 var nome_campos_obrigatorios = Array("Nome");
	 //Página a enviar o formulário
	 var page = "gravarunidade.jsp";
     //Campos obrigatórios
	 var campos_obrigatorios = Array("nome");

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

<body onLoad="inicio();barrasessao();">
<%@include file="barrasessao.jsp" %>
<form name="frmcadastrar" id="frmcadastrar" action="gravarunidade.jsp" method="post">
  <table width="600" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr>
      <td width="651" height="18" class="title">.: Cadastro de Unidades :.</td>
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
	            <td class="tdMedium">Nome: *</td>
   	       	  <td colspan="3" class="tdLight"><input name="nome" type="text" class="caixa" id="nome" value="<%= banco.getCampo("nome", rs) %>" size="80" maxlength="80"></td>
            </tr>
            
            <tr>
	            <td class="tdMedium">Telefone: </td>
       	       	<td class="tdLight"><input name="telefone" type="text" class="caixa" id="telefone" value="<%= banco.getCampo("telefone", rs) %>" size="14" maxlength="12"></td>
	            <td class="tdMedium">Contato: </td>
       	       	<td class="tdLight"><input name="contato" type="text" class="caixa" id="contato" value="<%= banco.getCampo("contato", rs) %>" size="30" maxlength="50"></td>
            </tr>
            <tr>
	            <td class="tdMedium">Observa&ccedil;&atilde;o: </td>
       	       	<td colspan="3" class="tdLight"><input name="observacao" type="text" class="caixa" id="observacao" value="<%= banco.getCampo("observacao", rs) %>" size="90" maxlength="200"></td>
            </tr>
          </table>
      </td>
    </tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<%= Util.getBotoes("cadastrounidades", pesq, tipo) %>
	<tr>
		<td>&nbsp;</td>
	</tr>
    <tr>
		<td width="100%" style="text-align:center">
			<table width="600px">
				<tr>
					<td width="100%" class="tdDark">Unidades</td>
				</tr>
			</table>
			<div style="width:600; height:101; overflow: auto">
				<table width="100%">
				    <%
						String resp[] = vacina.getUnidade(pesq, "nome", ordem, numPag, 50, tipo, cod_empresa);
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
