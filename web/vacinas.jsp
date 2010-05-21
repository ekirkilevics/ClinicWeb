<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.Vacina" id="vacina" scope="page"/>

<%
	if(strcod != null) rs = banco.getRegistro("vac_vacinas","cod_vacina", Integer.parseInt(strcod) );
	if(Util.isNull(ordem)) ordem = "descricao";
	
	//Exclui dose de vacina
	vacina.excluirDose(request.getParameter("exc"));
%>

<html>
<head>
<title>Vacinas</title>
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
	 var nome_campos_obrigatorios = Array("Vacina", "Estoque Mínimo");
	 //Página a enviar o formulário
	 var page = "gravarvacinas.jsp";
     //Campos obrigatórios
	 var campos_obrigatorios = Array("descricao", "estoque_min");
	 
	 function excluirdose(cod_dose) {
	 	conf = confirm("Confirma exclusão do registro?");
		if(conf) {
		 	go('vacinas.jsp?cod=' + idReg + '&exc=' + cod_dose);
		}
	 }
	 
	 function inseredose() {
		var jsdose = cbeGetElementById("dose");
		var jsdescDose  = cbeGetElementById("descDose");
		
		if(jsdose.value == "") {
			alert("Preecha o nº da dose");
			jsdose.focus();
			return;
		}

		if(jsdescDose.value == "") {
			alert("Preecha a descrição da dose");
			jsmes.focus();
			return;
		}
		
		enviarAcao('inc');	 
	 }
	 
	 function novaVacina() {
	 	go('vacinas.jsp');
	 }
	 
	function clickBotaoNovo() {
		novaVacina();
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
<form name="frmcadastrar" id="frmcadastrar" action="gravarvacinas.jsp" method="post">
  <table width="600" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr>
      <td width="651" height="18" class="title">.: Vacinas :.</td>
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
       	       	<td class="tdLight"><input name="descricao" type="text" class="caixa" id="descricao" value="<%= banco.getCampo("descricao", rs) %>" size="80" maxlength="80"></td>
            </tr>
            <tr>
	            <td class="tdMedium">Estoque Mínimo: *</td>
       	       	<td class="tdLight"><input name="estoque_min" type="text" class="caixa" id="estoque_min" value="<%= banco.getCampo("estoque_min", rs) %>" size="20" maxlength="5" onKeyPress="Javascript:OnlyNumbers(this,event);"></td>
            </tr>
			<tr>
				<td colspan="2" width="100%">
					<table width="100%" border="0" cellpadding="0" cellspacing="0">
						<tr>
							<td width="20%"  align="center" class="tdMedium">Dose</td>
						  <td width="70%"  align="center" class="tdMedium">Descri&ccedil;&atilde;o</td>
						  <td width="10%" align="center"  class="tdMedium">Ação</td>
					  </tr>
						<tr>
							<td class="tdLight" align="center"><input type="text" class="caixa" name="dose" id="dose" size="10" maxlength="2" onKeyPress="Javascript:OnlyNumbersSemPonto(this,event);"></td>
							<td class="tdLight" align="center"><input type="text" class="caixa" name="descDose" id="descDose" size="76" ></td>
							<td class="tdLight" align="center"><a href="Javascript:inseredose()" title="Inserir Dose"><img src="images/add.gif" border="0"></a></td>
						</tr>
						<%= vacina.getDoses(strcod) %>
					</table>
				</td>
			</tr>
          </table>
      </td>
    </tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<%= Util.getBotoes("vacinas", pesq, tipo) %>
	<tr>
		<td>&nbsp;</td>
	</tr>
    <tr>
		<td width="100%" style="text-align:center">
			<table width="600px">
				<tr>
					<td width="100%" class="tdDark">Vacinas</td>
				</tr>
			</table>
			<div style="width:600; height:101; overflow: auto">
				<table width="100%">
				    <%
						String resp[] = vacina.getVacinas(pesq, "descricao", ordem, numPag, 50, tipo, cod_empresa);
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
