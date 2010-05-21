<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.Grupo" id="grupo" scope="page"/>

<%
	if(strcod != null) rs = banco.getRegistro("t_grupos","grupo_id", Integer.parseInt(strcod) );
	if(ordem == null) ordem = "grupo";
%>

<html>
<head>
<title>Grupos</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
<script language="JavaScript">
     //id do registro
     var idReg = "<%= strcod%>";
	 //Informação vinda de gravar
	 var inf = "<%= inf%>";
	 //Nome dos campos
	 var nome_campos_obrigatorios = Array("Nome do Grupo", "Tempo de Sessão");
	 //Página a enviar o formulário
	 var page = "gravargrupo.jsp";
     //Campos obrigatórios
	 var campos_obrigatorios = Array("grupo", "sessao");
	
	function setarHorizontal(obj, num)
	{
		novo = obj.checked;
		
		eval("getObj('','incluir" + num + "').checked = " + novo);
		eval("getObj('','excluir" + num + "').checked = " + novo);
		eval("getObj('','alterar" + num + "').checked = " + novo);
		eval("getObj('','pesquisar" + num + "').checked = " + novo);
	}
	
	function setarVertical(obj, tipo)
	{
		var total = getObj("","totalmenu").value;
		var novo = obj.checked;
		for(i=1; i<=total; i++) {
			eval("getObj('','" + tipo + i + "').checked = " + novo);
		}
	}
	
	function setarTudo(obj)
	{
		var total = getObj("","totalmenu").value;
		var novo = obj.checked;
		for(i=1; i<=total; i++) {
			eval("getObj('','incluir" + i + "').checked = " + novo);
			eval("getObj('','excluir" + i + "').checked = " + novo);
			eval("getObj('','alterar" + i + "').checked = " + novo);
			eval("getObj('','pesquisar" + i + "').checked = " + novo);
			eval("getObj('','horizontal" + i + "').checked = " + novo);
		}
		getObj("","totincluir").checked = novo;
		getObj("","totexcluir").checked = novo;
		getObj("","totalterar").checked = novo;
		getObj("","totpesquisar").checked = novo;		
	}
	
	function iniciar() {
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
<form name="frmcadastrar" id="frmcadastrar" action="gravargrupo.jsp" method="post">
  <table width="600" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr>
      <td width="651" height="18" class="title">.: Grupos :.</td>
    </tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr style="height:25px">
		<td align="right"><span name='msg' id='msg' class="msg">&nbsp;</span></td>
	</tr>
    <tr align="center" valign="top">
      <td>
          <table width="100%" border="0" cellpadding="0" cellspacing="0" class="table">
            <tr>
              <td width="150" class="tdMedium">Grupo: *</td>
              <td class="tdLight"><input name="grupo" type="text" class="caixa" id="grupo" value="<%= banco.getCampo("grupo", rs) %>" size="40" maxlength="30"></td>
            </tr>
            <tr>
              <td width="150" class="tdMedium">Tempo da sessão: *</td>
              <td class="tdLight"><input name="sessao" type="text" class="caixa" id="sessao" value="<%= banco.getCampo("temposessao", rs) %>" size="3" maxlength="3" onKeyPress="Javascript:OnlyNumbers(this,event);"> minutos</td>
            </tr>
            <tr>
				<td colspan="2" width="100%">
					<table width="100%" border="0" cellpadding="0" cellspacing="0">
						<%= grupo.getItensMenu(strcod,  cod_empresa)%>
					</table>
				</td>
            </tr>
          </table>
      </td>
    </tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<%= Util.getBotoes("grupos", pesq, tipo) %>
	<tr>
		<td>&nbsp;</td>
	</tr>
    <tr>
		<td width="100%" style="text-align:center">
			<table width="600px">
				<tr>
					<td width="100%" class="tdDark">Grupos</td>
				</tr>
			</table>
			<div style="width:600; height:101; overflow: auto">
				<table width="100%">
				    <%
						String resp[] = grupo.getGrupos(pesq, "grupo", ordem, numPag, 10, tipo, cod_empresa);
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
