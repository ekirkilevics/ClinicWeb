<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.FichaAtendimento" id="ficha" scope="page"/>

<%			
	String codcli   = request.getParameter("codcli") != null ? request.getParameter("codcli") : "";
	String nomepaciente = request.getParameter("nome") != null ? request.getParameter("nome") : "";
	String nascimento = "";	
	String dataexame 	= request.getParameter("dataexame") != null ? request.getParameter("dataexame") : "";	
	String tipoficha 	= request.getParameter("tipoficha") != null ? request.getParameter("tipoficha") : "";
	String codfatura	= request.getParameter("codfatura") != null ? request.getParameter("codfatura") : "";	
%>

<html>
<head>
<title>Fichas de Atendimento</title>
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
<script language="JavaScript" src="js/ajax.js"></script>
<script language="JavaScript">
     //id do convênio
     var idReg = "<%= strcod%>";

	 function enviarForm() {
		var frm = cbeGetElementById("frmcadastrar");
		frm.action = "relfichas.jsp";
		frm.target = "_self";
		frm.submit();
	 }
	 
	 function iniciar()
	 {
	 	getObj("","dataexame").value = "<%= dataexame%>";
		getObj("","tipoficha").value = "<%= tipoficha%>";
		getObj("","codexame").value = "<%= codfatura%>";
		hideAll();
	 }
	 
	 function imprimeficha()
	 {
		var frm = cbeGetElementById("frmcadastrar");
		var cod_exame = cbeGetElementById("codexame").value;
		
		if(cod_exame != "")
		{
			if(frm.tipoficha.value == "") {
				mensagem("Tipo de Ficha não selecionado",2);
				frm.tipoficha.focus();
				return;
			}

			frm.action = "relfichas2.jsp";
			frm.target = "_blank";
			barrasessao();
			frm.submit();
			frm.action = "relfichas.jsp";
			frm.target = "_self";
		}
		else
		{
			mensagem("Nenhum exame escolhido",2);
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

<body onLoad="barrasessao();iniciar();">
<%@include file="barrasessao.jsp" %>
<%@include file="barraajax.jsp" %>
<form name="frmcadastrar" id="frmcadastrar" action="relfichas.jsp" method="post">
  <table width="600" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr> 
      <td height="18" class="title">.: Relatório: Fichas de Atendimento :.</td>
    </tr>
    <tr> 
      <td>&nbsp;</td>
    </tr>
    <tr style="height:25px"> 
      <td align="right"><span name='msg' id='msg' class="msg">&nbsp;</span></td>
    </tr>
    <tr align="center" valign="top"> 
      <td> <table width="600" border="0" cellpadding="0" cellspacing="0" class="table">
          <tr> 
            <td class="tdMedium">Paciente:</td>
            <td colspan="3" class="tdLight">
					<input type="hidden" name="codcli" id="codcli" value="<%= codcli %>">			
					<input style="width:100%" class="caixa" type="text" name="nome" id="nome" onKeyUp="busca(this.value, 'codcli', 'nome','paciente')" value="<%= nomepaciente%>">
			 </td>
          </tr>
          <tr> 
            <td class="tdMedium">Tipo:</td>
            <td colspan="3" class="tdLight"> 
				<select name="tipoficha" id="tipoficha" class="caixa" style="width:200px">
                	<option value=""></option>
	                <%= ficha.getFichas(cod_empresa)%> 
				</select> 
			</td>
          </tr>
          <tr> 
            <td class="tdMedium">Data do Procedimento:</td>
            <td class="tdLight"> 
				<select name="dataexame" id="dataexame" class="caixa" onChange="enviarForm()">
                	<option value=""></option>
                	<%= ficha.getDatas(codcli)%> 
				</select> 
			</td>
            <td class="tdMedium">Data Entrega Exame:</td>
            <td class="tdLight"><input type="text" name="data" id="data" class="caixa" size="10" maxlength="10" onKeyPress="return formatar(this, event, '##/##/####'); " onBlur="ValidaData(this)"></td>
          </tr>
          <tr> 
            <td class="tdMedium">Procedimento:</td>
            <td colspan="3" class="tdLight"> 
				<select name="codexame" id="codexame" class="caixa">
                	<%= ficha.getProcedimentos(codcli, dataexame)%> 
				</select> 
			</td>
          </tr>
          <tr> 
            <td colspan="4" class="tdMedium" align="right"><input name="btnimprimir" id="btnimprimir" type="button" class="botao" value="Imprimir Ficha" onClick="imprimeficha()"></td>
          </tr>
        </table></td>
    </tr>
  </table>
</form>

</body>
</html>
