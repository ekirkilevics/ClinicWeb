<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.Diagnostico" id="diagnostico" scope="page"/>

<%
	if(strcod != null) rs = banco.getRegistro("diagnosticos","cod_diag", Integer.parseInt(strcod) );
	if(Util.isNull(ordem)) ordem = "DESCRICAO";

%>

<html>
<head>
<title>Diagn�sticos</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
<script language="JavaScript">
     //id do conv�nio
     var idReg = "<%= strcod%>";
	 //Informa��o vinda de gravardiagnostico
	 var inf = "<%= inf%>";
	 //Nome dos campos
	 var nome_campos_obrigatorios = Array("CID","Descri��o","Usual");
	 //P�gina a enviar o formul�rio
	 var page = "gravardiagnostico.jsp";
     //Campos obrigat�rios
	 var campos_obrigatorios = Array("cid","descricao","flag");

	function setarCampos()
	{
		getObj("","flag").value = "<%= banco.getCampo("flag", rs) %>";
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

<body onLoad="setarCampos();">
<%@include file="barrasessao.jsp" %>
<form name="frmcadastrar" id="frmcadastrar" action="gravardiagnostico.jsp" method="post">
  <!-- Campos Ocultos -->
  <input type="hidden" name="ordem" value="<%= ordem%>">
  <!-- Campos Ocultos -->
  <table width="600" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr>
      <td width="651" height="18" class="title">.: Diagn&oacute;sticos :.</td>
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
              <td width="150" class="tdMedium">CID: * </td>
              <td colspan="3" class="tdLight"><input name="cid" type="text" class="caixa" id="cid" value="<%= banco.getCampo("CID", rs) %>"></td>
            </tr>
            <tr>
   	          
            <td class="tdMedium">Descri&ccedil;&atilde;o: *</td>
              <td colspan="3" class="tdLight"><input name="descricao" type="text" class="caixa" id="descricao" value="<%= banco.getCampo("DESCRICAO", rs) %>" size="85" maxlength="100"></td>
            </tr>
			<tr>
   	          <td class="tdMedium">Cr�nico: *</td>
              <td colspan="3" class="tdLight">
					<select name="flag" id="flag" class="caixa">
						<option value="">&nbsp;</option>
						<option value="0">-N�o-</option>
						<option value="1">-Sim-</option>
					</select>				  	
			  </td>
			</tr>
          </table>
      </td>
    </tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<%= Util.getBotoes("diagnosticos", pesq, tipo) %>
	<tr>
		<td>&nbsp;</td>
	</tr>
    <tr>
		<td width="100%" style="text-align:center">
			<table width="600px">
				<tr>
					<td width="29%" class="tdDark"><a title="Ordenar pelo CID" href="Javascript:ordenar('diagnosticos','CID')">CID</a></td>
					<td class="tdDark"><a title="Ordenar por Descri��o" href="Javascript:ordenar('diagnosticos','DESCRICAO')">Descri��o</a></td>
				</tr>
			</table>
			<div style="width:600; height:101; overflow: auto">
				<table width="100%">
				    <%
						String resp[] = diagnostico.getDiagnosticos(pesq, "DESCRICAO", ordem, numPag, 50, tipo, cod_empresa);
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
