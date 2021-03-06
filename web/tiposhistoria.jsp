<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.Historico" id="historico" scope="page"/>

<%
	if(strcod != null) rs = banco.getRegistro("tiposhistoria","cod_tipohistoria", Integer.parseInt(strcod) );
	if(Util.isNull(ordem)) ordem = "descricao";
%>

<html>
<head>
<title>Alertas</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
<script language="JavaScript">
     //id
     var idReg = "<%= strcod%>";
	 //Informa��o vinda de gravar
	 var inf = "<%= inf%>";
	 //Nome dos campos
	 var nome_campos_obrigatorios = Array("Descric�o", "Cor");
	 //P�gina a enviar o formul�rio
	 var page = "gravartiposhistoria.jsp";
     //Campos obrigat�rios
	 var campos_obrigatorios = Array("descricao", "cor");
	 
 	 function setColor(cor)
	 {
		cbeGetElementById(campocor).value = cor;
		cbeGetElementById("ex" + campocor).style.backgroundColor = cor;
		cbeGetElementById("cp").style.visibility = 'hidden';
	 }


	 function abrirPaleta(campo, evento)
	 {
		campocor = campo;
	 	var paleta = cbeGetElementById("cp");
		paleta.style.left = evento.clientX;
		paleta.style.top = evento.clientY;
		paleta.style.visibility = 'visible';
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

<body onLoad="inicio();barrasessao();">
<%@include file="barrasessao.jsp" %>
<form name="frmcadastrar" id="frmcadastrar" action="gravartiposhistoria.jsp" method="post">
  <table width="600" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr>
      <td width="651" height="18" class="title">.: Tipos de Hist�ria :.</td>
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
              <td class="tdMedium">Descri��o: *</td>
              <td class="tdLight"><input name="descricao" type="text" class="caixa" id="descricao" value="<%= banco.getCampo("descricao", rs) %>" size="50" maxlength="50"></td>
            </tr>
            <tr>
              <td class="tdMedium">Cor: *</td>
              <td class="tdLight">
			  	<input name="cor" type="text" class="caixa" id="cor" size="7" maxlength="7" value="<%= banco.getCampo("cor", rs) %>">
				<span id="excor" style="border:1px solid #000000; height:16px; width:18px; background-color:<%= banco.getCampo("cor", rs) %>">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
				&nbsp;&nbsp;<button type="button" style="background-color:white; border:1px solid #000000" onClick="abrirPaleta('cor', event)"><img src="images/palette.gif"></button>
			  </td>
            </tr>
          </table>
      </td>
    </tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<%= Util.getBotoes("tiposhistoria", pesq, tipo) %>
	<tr>
		<td>&nbsp;</td>
	</tr>
    <tr>
		<td width="100%" style="text-align:center">
			<table width="600px">
				<tr>
					<td width="100%" class="tdDark">Tipos</td>
				</tr>
			</table>
			<div style="width:600; height:101; overflow: auto">
				<table width="100%">
				    <%
						String resp[] = historico.getTiposHistoria(pesq, "descricao", ordem, numPag, 50, tipo, cod_empresa);
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
  <iframe width="154" height="104" id="cp" name="cp" src="palette.htm" marginwidth="0" marginheight="0" scrolling="no" style="visibility:hidden; position: absolute; top: 100; left: 100"></iframe>

</form>

</body>
</html>
