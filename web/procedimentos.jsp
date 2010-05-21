<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.Procedimento" id="procedimento" scope="page"/>

<%
	if(strcod != null) rs = banco.getRegistro("procedimentos","COD_PROCED", Integer.parseInt(strcod) );
	if(ordem == null) ordem = "Procedimento";
%>

<html>
<head>
<title>Procedimentos</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
<script language="JavaScript">
     //id
     var idReg = "<%= strcod%>";
	 //Informação vinda de gravarprocedimento
	 var inf = "<%= inf%>";
	 //Nome dos campos
	 var nome_campos_obrigatorios = Array("Código","Procedimento", "Especialidade", "Grupo de Procedimento", "Tipo de Guia", "Gera Laudo", "Usual");
	 //Página a enviar o formulário
	 var page = "gravarprocedimento.jsp";
	 //Cod. da ajuda
	 cod_ajuda = 7;

     //Campos obrigatórios
	var campos_obrigatorios = Array("codigo","procedimento", "codesp", "grupoproced", "tipoGuia", "laudo","flag");

 	function setarCampos()
	{
		getObj("","flag").value = "<%= banco.getCampo("flag", rs) %>";
		getObj("","laudo").value = "<%= banco.getCampo("laudo", rs) %>";
		getObj("","grupoproced").value = "<%= banco.getCampo("grupoproced", rs) %>";
		getObj("","codesp").value = "<%= banco.getCampo("codesp", rs) %>";
		getObj("","tipoGuia").value = "<%= banco.getCampo("tipoGuia", rs) %>";
	}
	
	function iniciar() {
		inicio();
		setarCampos();
		barrasessao();
	}
	
	function validaCodProcedimento(obj) {
		if(obj.value.length < 8) {
			mensagem("Cód. de Procedimento deve ter no mínimo 8 dígitos.",2);
			obj.focus();
			return false;
		}
		return true;
	}
	
	function gravarProcedimento() {
		if(validaCodProcedimento(cbeGetElementById("codigo")))
			enviarAcao('inc');
	}
	
	function clickBotaoNovo() {
		botaoNovo();
	}
	
	function clickBotaoSalvar() {
		gravarProcedimento();
	}
	
	function clickBotaoExcluir() {
		confi = confirm("Ao excluir o procedimento, também excluirá os valores cadastrados para planos e convênios.\nConfirmar?");
		if(confi) enviarAcao('exc');
	}	

</script>
</head>

<body onLoad="iniciar()">
<%@include file="barrasessao.jsp" %>
<form name="frmcadastrar" id="frmcadastrar" action="gravarprocedimento.jsp" method="post">
  <!-- Campos Ocultos -->
  <input type="hidden" name="ordem" value="<%= ordem%>">
  <!-- Campos Ocultos -->
  <table width="600" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr>
      <td width="651" height="18" class="title">.: Procedimentos :.</td>
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
              <td width="100" class="tdMedium">Código: * </td>
              
            <td colspan="3" class="tdLight"><input name="codigo" type="text" class="caixa" id="codigo" value="<%= banco.getCampo("CODIGO", rs) %>" size="20" maxlength="10" onKeyPress="return somenteNumerosSemPonto(event)" onBlur="Javascript:validaCodProcedimento(this)"></td>
            </tr>
            <tr>
				<td class="tdMedium">Procedimento: *</td>
				<td colspan="3" class="tdLight"><input name="procedimento" type="text" class="caixa" id="procedimento" value="<%= banco.getCampo("Procedimento", rs) %>" size="85" maxlength="100"></td>
			</tr>
            <tr>
				<td class="tdMedium">Especialidade: *</td>
				<td colspan="3" class="tdLight">
					<select name="codesp" id="codesp" class="caixa">
						<option value=""></option>
						<%= procedimento.getEspecialidades(cod_empresa) %>						
					</select>
				</td>
			</tr>
            <tr>
			  <td class="tdMedium">Grupo de Procedimento: *</td>
			  <td class="tdLight">
					<select name="grupoproced" id="grupoproced" class="caixa">
						<option value="-1">Nenhum Grupo</option>
				  		<%= procedimento.getGruposProcecimentos(cod_empresa) %>
					</select>	
			  </td>
			  <td class="tdMedium">Tipo de Guia: *</td>
			  <td class="tdLight">
			  	<select name="tipoGuia" id="tipoGuia" class="caixa">
					<option value=""></option>
					<option value="1">Guia de Consulta</option>
					<option value="2">Guia SP/SADT</option>
					<option value="3">Guia de Honorário Individual</option>
				</select>
			  </td>
			</tr>
			<tr>
   	          <td class="tdMedium">Gera Laudo: *</td>
              <td width="150" class="tdLight">
					<select name="laudo" id="laudo" class="caixa">
						<option value="">&nbsp;</option>
						<option value="0">-Não-</option>
						<option value="1">-Sim-</option>
					</select>				  	
			  </td>
   	          <td class="tdMedium">Status: *</td>
              <td width="199" class="tdLight">
					<select name="flag" id="flag" class="caixa">
						<option value="">&nbsp;</option>
						<option value="0">Inativo</option>
						<option value="1">Ativo</option>
					</select>				  	
			  </td>
            </tr>
          </table>
      </td>
    </tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<%= Util.getBotoes("procedimentos", pesq, tipo) %>
	<tr>
		<td>&nbsp;</td>
	</tr>
    <tr>
		<td width="100%" style="text-align:center">
			<table width="600px">
				<tr>
					<td width="100" class="tdDark"><a title="Ordenar por Código" href="Javascript:ordenar('procedimentos','CODIGO')">Código</a></td>
					<td class="tdDark"><a title="Ordenar por Procedimento" href="Javascript:ordenar('procedimentos','Procedimento')">Procedimento</a></td>
				</tr>
			</table>
			<div style="width:600; height:101; overflow: auto">
				<table width="100%">
				    <%
						String resp[] = procedimento.getProcedimentos(pesq, ordem, numPag, 50, tipo, cod_empresa);
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
