<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.Vacina" id="vacina" scope="page"/>

<%
	String nomeconvenio = "";
	if(strcod != null) {
		rs = banco.getRegistro("vac_valor_vacinas","cod_valor_vacina", Integer.parseInt(strcod) );
		nomeconvenio = banco.getValor("descr_convenio", "SELECT descr_convenio FROM convenio WHERE cod_convenio=" + banco.getCampo("cod_convenio", rs) );
	}
	if(Util.isNull(ordem)) ordem = "descricao";
%>

<html>
<head>
<title>Valor das Vacinas</title>
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
<script language="JavaScript" src="js/ajax.js"></script>
<script language="JavaScript">
     //id
     var idReg = "<%= strcod%>";
	 //Informação vinda de gravar
	 var inf = "<%= inf%>";
	 //Nome dos campos
	 var nome_campos_obrigatorios = Array("Vacina", "Convênio", "Valor");
	 //Página a enviar o formulário
	 var page = "gravarvalorvacinas.jsp";
     //Campos obrigatórios
	 var campos_obrigatorios = Array("cod_vacina", "cod_convenio", "valor");

	function iniciar() {
		cbeGetElementById("cod_vacina").value = "<%= banco.getCampo("cod_vacina", rs) %>";
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
<%@include file="barraajax.jsp" %>
<form name="frmcadastrar" id="frmcadastrar" action="gravarvalorvacinas.jsp" method="post">
  <table width="600" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr>
      <td width="651" height="18" class="title">.: Valores das Vacinas :.</td>
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
				<td class="tdMedium">Convênio: *</td>
				<td class="tdLight">
					<input type="hidden" name="cod_convenio" id="cod_convenio" value="<%= banco.getCampo("cod_convenio", rs) %>"">			
					<input value="<%= nomeconvenio %>" size="60" class="caixa" type="text" name="descr_convenio" id="descr_convenio" onKeyUp="busca(this.value, 'cod_convenio', 'descr_convenio','convenio','AND ativo=\'S\'')">
				</td>
			</tr>
            <tr>
	            <td class="tdMedium" width="79">Vacina: *</td>
       	       	<td class="tdLight">
					<select name="cod_vacina" id="cod_vacina" class="caixa">
						<option value=""></option>
						<%= vacina.getVacinas(cod_empresa)%>
					</select>
				</td>
            </tr>
            <tr>
				<td class="tdMedium">Valor: *</td>
				<td class="tdLight"><input type="text" name="valor" id="valor" class="caixa" size="10"  onkeypress="Javascript:OnlyNumbers(this,event);" value="<%= banco.getCampo("valor", rs) %>"></td>
            </tr>
          </table>
      </td>
    </tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<%= Util.getBotoes("valorvacinas", pesq, tipo) %>
	<tr>
		<td>&nbsp;</td>
	</tr>
    <tr>
		<td width="100%" style="text-align:center">
			<table width="600px">
				<tr>
					<td width="250" class="tdDark"><a title="Ordenar por Vacina" href="Javascript:ordenar('valorvacinas','descricao')">Vacina</a></td>
					<td class="tdDark"><a title="Ordenar por Convênio" href="Javascript:ordenar('valorvacinas','descr_convenio')">Convênio</a></td>
					<td width="60" class="tdDark">Valor</td>
				</tr>
			</table>
			<div style="width:600; height:101; overflow: auto">
				<table width="100%">
				    <%
						String resp[] = vacina.getValorVacinas(pesq, ordem, numPag, 50, tipo, cod_empresa);
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
