<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.Especialidade" id="especialidade" scope="page"/>

<%
	if(strcod != null) rs = banco.getRegistro("especialidade","codesp", Integer.parseInt(strcod) );
	if(ordem == null) ordem = "descri";
%>

<html>
<head>
<title>Especialidades</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
<script language="JavaScript">
     //id do convênio
     var idReg = "<%= strcod%>";
	 //Informação vinda de gravarprocedimento
	 var inf = "<%= inf%>";
	 //Nome dos campos
	 var nome_campos_obrigatorios = Array("Profissão","Especialidade");
	 //Página a enviar o formulário
	 var page = "gravarespecialidade.jsp";
	 //Cod. da ajuda
	 cod_ajuda = 5;

     //Campos obrigatórios
	 var campos_obrigatorios = Array("profissao","especialidade");

	function setarProfissao()
	{
		var prof = "<%= banco.getCampo("cod_profis", rs)%>";
		getObj("","profissao").value = prof;
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

<body onLoad="inicio();setarProfissao();barrasessao();">
<%@include file="barrasessao.jsp" %>
<form name="frmcadastrar" id="frmcadastrar" action="gravarprocedimento.jsp" method="post">
  <!-- Campos Ocultos -->
  <input type="hidden" name="ordem" value="<%= ordem%>">
  <!-- Campos Ocultos -->
  <table width="600" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr>
      <td width="651" height="18" class="title">.: Especialidades :.</td>
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
    	        <td class="tdMedium">Profiss&atilde;o: *</td>
				<td class="tdLight">
					<select name="profissao" id="profissao" class="caixa" style="width:400px">
						<option value="0"></option>
						<%= especialidade.getProfissoes(cod_empresa)%>
					</select>
				</td>
		    </tr>
            <tr>
              <td class="tdMedium">Especialidade: *</td>
              <td class="tdLight"><input name="especialidade" type="text" class="caixa" id="especialidade" value="<%= banco.getCampo("descri", rs) %>" size="85" maxlength="100"></td>
            </tr>
          </table>
      </td>
    </tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<%= Util.getBotoes("especialidades", pesq, tipo) %>
	<tr>
		<td>&nbsp;</td>
	</tr>
    <tr>
		<td width="100%" style="text-align:center">
			<table width="600px">
				<tr>
					<td width="29%" class="tdDark"><a title="Ordenar por Profissão" href="Javascript:ordenar('especialidades','nome')">Profissão</a></td>
					<td width="71%" class="tdDark"><a title="Ordenar por Especialidade" href="Javascript:ordenar('especialidades','descri')">Especialidade</a></td>
				</tr>
			</table>
			<div style="width:600; height:101; overflow: auto">
				<table width="100%">
				    <%
						String resp[] = especialidade.getEspecialidades(pesq, "descri", ordem, numPag, 50, tipo, cod_empresa);
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
