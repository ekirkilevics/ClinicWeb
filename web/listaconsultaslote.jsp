<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.Lote" id="lote" scope="page"/>

<%
	String codguia = request.getParameter("codguia");
	String gerouxml = request.getParameter("gerouxml");
	String tipoguia = request.getParameter("tipoguia");

	if(!Util.isNull(ordem)) ordem = "codGuia";
	
	if(codguia != null) {
		String sql = "";
		sql = "UPDATE " + lote.getNomeTabelaGuia(tipoguia) + " SET codLote=null WHERE codGuia=" + codguia;
		banco.executaSQL(sql);
	}
%>

<html>
<head>
<title>Guias</title>
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

	 var gerouxml = "<%= gerouxml%>";

	function iniciar() {
		barrasessao();
	}
	
	function excluirguia(codguia, tipoguia) {
		if(gerouxml == "S") {
			mensagem("Não é possível excluir Guia pois o Lote já gerou arquivo", 2);
			return;
		}
		window.location = "listaconsultaslote.jsp?cod=" + idReg + "&codguia=" + codguia + "&gerouxml=" + gerouxml + "&tipoguia=" + tipoguia;
	}
	
	function editarguia(codguia, tipoguia) {
		if(tipoguia == "1")
			window.location  = "frmguiaconsulta.jsp?cod=" + codguia + "&gerouxml=" + gerouxml;	
		else if(tipoguia == "2")
			window.location  = "frmguiasadt.jsp?cod=" + codguia + "&gerouxml=" + gerouxml;	
		else
			alert("Somente guias de consulta e SADT podem ser alteradas nesse item.");
	}
	
	function ordenarGuia(campo) {
		frm = cbeGetElementById("frmcadastrar");
		frm.action = "listaconsultaslote.jsp?cod=<%= strcod%>&gerouxml=<%= gerouxml%>&tipoguia=<%= tipoguia%>&ordem=" + campo;
		frm.submit();
	}
	

</script>
</head>

<body onLoad="iniciar()">
<%@include file="barrasessao.jsp" %>
<form name="frmcadastrar" id="frmcadastrar" action="gravarlotes.jsp" method="post">
  <table width="600" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr>
      <td width="651" height="18" class="title">.: Lista de Guias :.</td>
    </tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr>	
		<td align="right"><span name='msg' id='msg' class="msg">&nbsp;</span></td>
	</tr>
    <tr align="center" valign="top">
      <td>
		<%
			if(!Util.isNull(strcod)) {
				out.println(lote.getGuias(strcod, tipoguia, ordem));
			}	
		%>

      </td>
    </tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
  </table>
</form>

</body>
</html>
