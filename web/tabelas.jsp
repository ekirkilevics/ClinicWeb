<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.Tabela" id="tabela" scope="page"/>

<%
	if(strcod != null) rs = banco.getRegistro("tabelas","cod_tabela", Integer.parseInt(strcod) );
	if(ordem == null) ordem = "tabela";
%>

<html>
<head>
<title>Tabelas</title>
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
	 var nome_campos_obrigatorios = Array("Tabela","Código TISS", "Tipo de Moeda");
	 //Página a enviar o formulário
	 var page = "gravartabela.jsp";
     //Campos obrigatórios
	 var campos_obrigatorios = Array("tabela","codTISS", "tipomoeda");

 	function setarCampos()
	{
		getObj("","tipomoeda").value = "<%= banco.getCampo("tipo", rs)%>";
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

<body onLoad="inicio();setarCampos();barrasessao();">
<%@include file="barrasessao.jsp" %>
<form name="frmcadastrar" id="frmcadastrar" action="gravartabela.jsp" method="post">
  <table width="600" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr>
      <td width="651" height="18" class="title">.: Tabelas :.</td>
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
              <td width="100" class="tdMedium">Tabela: * </td>
              <td colspan="3" class="tdLight"><input name="tabela" type="text" class="caixa" id="tabela" value="<%= banco.getCampo("tabela", rs) %>" size="80" maxlength="100"></td>
            </tr>
			<tr>
				<td class="tdMedium">Código TISS: *</td>
				<td class="tdLight"><input type="text" name="codTISS" id="codTISS" value="<%= banco.getCampo("cod_tiss", rs) %>" class="caixa" size="10" maxlength="2"></td>
	            <td class="tdMedium">Tipo de Moeda: *</td>
				<td class="tdLight">
					<select name="tipomoeda" id="tipomoeda" class="caixa">
						<option value=""></option>
						<option value="1">Valor em Real</option>
						<option value="2">Valor em CH</option>
					</select>
				</td>
		    </tr>
           </table>
      </td>
    </tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<%= Util.getBotoes("tabelas", pesq, tipo) %>
	<tr>
		<td>&nbsp;</td>
	</tr>
    <tr>
		<td width="100%" style="text-align:center">
			<table width="600px">
				<tr>
					<td class="tdDark"><a title="Ordenar por Tabela" href="Javascript:ordenar('tabelas','tabela')">Tabelas</a></td>
				</tr>
			</table>
			<div style="width:600; height:101; overflow: auto">
				<table width="100%">
				    <%
						String resp[] = tabela.getTabelas(pesq, "tabela", ordem, numPag, 50, tipo, cod_empresa);
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
