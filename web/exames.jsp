<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.Exame" id="exame" scope="page"/>

<%
	if(strcod != null) rs = banco.getRegistro("exames","cod_exame", Integer.parseInt(strcod) );
	if(Util.isNull(ordem)) ordem = "exame";
%>

<html>
<head>
<title>Exames</title>
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
	 var nome_campos_obrigatorios = Array("Exame");
	 //Página a enviar o formulário
	 var page = "gravarexame.jsp";
     //Campos obrigatórios
	 var campos_obrigatorios = Array("exame");

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
<form name="frmcadastrar" id="frmcadastrar" action="gravarexame.jsp" method="post">
  <table width="600" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr>
      <td width="651" height="18" class="title">.: Exames :.</td>
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
            	<td class="tdMedium">Exame: *</td>
              	<td colspan="3" class="tdLight"><input name="exame" type="text" class="caixa" id="exame" value="<%= banco.getCampo("exame", rs) %>" size="60" maxlength="50"></td>
            </tr>
            <tr>
            	<td class="tdMedium">Unidade: </td>
              	<td class="tdLight"><input name="unidade" type="text" class="caixa" id="unidade" value="<%= banco.getCampo("unidade", rs) %>" size="12" maxlength="10"></td>
            	<td class="tdMedium">Faixa de Normalidade entre</td>
              	<td class="tdLight">
					<input name="minimo" type="text" class="caixa" id="minimo" value="<%= banco.getCampo("minimo", rs) %>" size="12" maxlength="10" onKeyPress="Javascript:OnlyNumbers(this,event);"> e
              		<input name="maximo" type="text" class="caixa" id="maximo" value="<%= banco.getCampo("maximo", rs) %>" size="12" maxlength="10" onKeyPress="Javascript:OnlyNumbers(this,event);">
				</td>
            </tr>
            <tr>
            	<td class="tdMedium">Página: </td>
              	<td colspan="3" class="tdLight"><input name="pagina" type="text" class="caixa" id="pagina" value="<%= Util.trataNulo(banco.getCampo("pagina", rs),"") %>" size="60" maxlength="50" onKeyPress="return false"></td>
            </tr>
          </table>
      </td>
    </tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<%= Util.getBotoes("exames", pesq, tipo) %>
	<tr>
		<td>&nbsp;</td>
	</tr>
    <tr>
		<td width="100%" style="text-align:center">
			<table width="600px">
				<tr>
					<td width="100%" class="tdDark">Exames</td>
				</tr>
			</table>
			<div style="width:600; height:101; overflow: auto">
				<table width="100%">
				    <%
						String resp[] = exame.getExames(pesq, "exame", ordem, numPag, 50, tipo, cod_empresa);
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
