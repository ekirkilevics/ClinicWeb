<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.Profissao" id="profissao" scope="page"/>

<%
	if(strcod != null) rs = banco.getRegistro("profissao","cod_profis", Integer.parseInt(strcod) );
	if(ordem == null) ordem = "nome";
%>

<html>
<head>
<title>Profissões</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
<script language="JavaScript">
     //id do convênio
     var idReg = "<%= strcod%>";
	 //Informação vinda de gravardiagnostico
	 var inf = "<%= inf%>";
	 //Nome dos campos
	 var nome_campos_obrigatorios = Array("Nome da Profissão", "Conselho Profissional");
	 //Página a enviar o formulário
	 var page = "gravarprofissao.jsp";
	 //Cod. da ajuda
	 cod_ajuda = 9;
	 
     //Campos obrigatórios
	 var campos_obrigatorios = Array("profissao", "registro");

	 function iniciar() {
	 	inicio();
	 	cbeGetElementById("registro").value = "<%= banco.getCampo("tipo_registro", rs) %>";
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

<body onLoad="iniciar();">
<%@include file="barrasessao.jsp" %>
<form name="frmcadastrar" id="frmcadastrar" action="gravardiagnostico.jsp" method="post">
  <!-- Campos Ocultos -->
  <input type="hidden" name="ordem" value="<%= ordem%>">
  <!-- Campos Ocultos -->
  <table width="600" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr>
      <td width="651" height="18" class="title">.: Profiss&otilde;es :.</td>
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
	          <td class="tdMedium">Nome da Profiss&atilde;o: *</td>
              <td class="tdLight"><input name="profissao" type="text" class="caixa" id="profissao" value="<%= banco.getCampo("nome", rs) %>" size="85" maxlength="100"></td>
            </tr>
            <tr>
	          <td class="tdMedium">Conselho Profissional: *</td>
              <td class="tdLight">
			  	<select name="registro" id="registro" class="caixa">
					<option value=""></option>
					<option value="CRAS">CRAS - Conselho Regional de Assistência Social</option>
					<option value="COREN">COREN - Conselho Federal de Enfermagem</option>
					<option value="CRF">CRF - Conselho Regional de Farmácia </option>
					<option value="CRFA">CRFA - Conselho Regional de Fonoaudiologia</option>
					<option value="CREFITO">CREFITO - Conselho Regional de Fisioterapia e Terapia Ocupacional</option>
					<option value="CRM">CRM - Conselho Regional de Medicina</option>
					<option value="CRV">CRV - Conselho Regional de Medicina Veterinária</option>
					<option value="CRN">CRN - Conselho Regional de Nutrição</option>
					<option value="CRO">CRO - Conselho Regional de Odontologia</option>
					<option value="CRP">CRP - Conselho Regional de Psicologia</option>
					<option value="OUT">OUT - Outros Conselhos</option>
				</select>
			  </td>
            </tr>
            <tr>
	          <td class="tdMedium">Cód. CBOS:</td>
              <td class="tdLight"><input name="codCBOS" type="text" class="caixa" id="codCBOS" value="<%= banco.getCampo("codCBOS", rs) %>" size="7" maxlength="7"></td>
            </tr>
          </table>
      </td>
    </tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<%= Util.getBotoes("profissoes", pesq, tipo) %>
	<tr>
		<td>&nbsp;</td>
	</tr>
    <tr>
		<td width="100%" style="text-align:center">
			<table width="600px">
				<tr>
					<td width="100%" class="tdDark">Profissão</td>
				</tr>
			</table>
			<div style="width:600; height:101; overflow: auto">
				<table width="100%">
				    <%
						String resp[] = profissao.getProfissoes(pesq, "nome", ordem, numPag, 30, tipo, cod_empresa);
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
