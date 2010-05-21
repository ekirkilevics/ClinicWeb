<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.Medicamento" id="medicamento" scope="page"/>

<%
	if(strcod != null) rs = banco.getRegistro("medicamentos","cod_comercial", Integer.parseInt(strcod) );
	if(ordem == null) ordem = "comercial";
%>

<html>
<head>
<title>Diagnósticos</title>
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
	 var nome_campos_obrigatorios = Array("Nome Comercial","Apresentação","Usual");
	 //Página a enviar o formulário
	 var page = "gravarmedicamento.jsp";
	 //Cod. da ajuda
	 cod_ajuda = 23;

     //Campos obrigatórios
	 var campos_obrigatorios = Array("comercial","apresentacao","flag");

	function setarCampos() {
		getObj("","flag").value = "<%= banco.getCampo("flag", rs) %>";
	}
	
	function iniciar() {
		inicio();
		setarCampos();
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
<form name="frmcadastrar" id="frmcadastrar" action="gravarmedicamento.jsp" method="post">
  <!-- Campos Ocultos -->
  <input type="hidden" name="ordem" value="<%= ordem%>">
  <!-- Campos Ocultos -->
  <table width="600" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr>
      <td width="651" height="18" class="title">.: Medicamentos :.</td>
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
              
            <td width="150" class="tdMedium">Nome Comercial: *</td>
              <td colspan="3" class="tdLight"><input name="comercial" type="text" class="caixa" id="comercial" value="<%= banco.getCampo("comercial", rs) %>" maxlength="50" size="50"></td>
            </tr>
            <tr>
   	          <td class="tdMedium">Fármaco:</td>
              <td colspan="3" class="tdLight">
				  	<textarea name="farmaco" id="farmaco" class="caixa" rows="3" style="width:100%"><%= banco.getCampo("farmaco", rs) %></textarea>
			  </td>
            </tr>
            <tr>
	            <td class="tdMedium">Apresentação: *</td>
                <td colspan="3" class="tdLight"><input name="apresentacao" type="text" class="caixa" id="apresentacao" value="<%= banco.getCampo("apresentacao", rs) %>" maxlength="55" size="55"></td>
   	        </tr>
			<tr>
              <td class="tdMedium">Uso Contínuo: *</td>
              <td colspan="3" class="tdLight">
					<select name="flag" id="flag" class="caixa">
						<option value="">&nbsp;</option>
						<option value="0">-Não-</option>
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
	<%= Util.getBotoes("medicamentos", pesq, tipo) %>
	<tr>
		<td>&nbsp;</td>
	</tr>
    <tr>
		<td width="100%" style="text-align:center">
			<table width="600px">
				<tr>
					<td width="48%" class="tdDark"><a title="Ordenar pelo nome comercial" href="Javascript:ordenar('medicamentos','comercial')">Nome Comercial</a></td>
					<td class="tdDark"><a title="Ordenar pela apresentação" href="Javascript:ordenar('medicamentos','apresentacao')">Apresentação</a></td>
				</tr>
			</table>
			<div style="width:600; height:101; overflow: auto">
				<table width="100%">
				    <%
						String resp[] = medicamento.getMedicamentos(pesq, "comercial", ordem, numPag, 50, tipo, cod_empresa);
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
