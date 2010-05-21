<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.Links" id="links" scope="page"/>

<%
	if(strcod != null) rs = banco.getRegistro("links","cod_link", Integer.parseInt(strcod) );
	if(ordem == null) ordem = "titulo";
%>

<html>
<head>
<title>Links</title>
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
	 var nome_campos_obrigatorios = Array("Assunto","Link");
	 //Página a enviar o formulário
	 var page = "gravarlink.jsp";
     //Campos obrigatórios
	 var campos_obrigatorios = Array("assunto","link");

	function setarCampos()
	{
		var ass = "<%= banco.getCampo("cod_assunto", rs)%>";
		getObj("","assunto").value = ass;
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

<body onLoad="inicio();setarCampos();barrasessao();">
<%@include file="barrasessao.jsp" %>
<form name="frmcadastrar" id="frmcadastrar" action="gravarlink.jsp" method="post">
  <table width="600" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr>
      <td width="651" height="18" class="title">.: Links :.</td>
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
    	        <td class="tdMedium">Assunto:</td>
				<td class="tdLight">
					<select name="assunto" id="assunto" class="caixa" style="width:300px">
						<option value=""></option>
						<%= links.getAssuntosCombo(cod_empresa)%>
					</select>
				</td>
		    </tr>
            <tr>
              <td class="tdMedium">Título:</td>
              <td class="tdLight"><input name="titulo" type="text" class="caixa" id="titulo" value="<%= banco.getCampo("titulo", rs) %>" size="85" maxlength="150"></td>
            </tr>
            <tr>
              <td class="tdMedium">Descrição:</td>
              <td class="tdLight">
			  	<textarea name="descricao" id="descricao" class="caixa" rows="3" cols="85"><%= banco.getCampo("descricao", rs) %></textarea>
			  </td>
            </tr>
            <tr>
              <td class="tdMedium">Link:</td>
              <td class="tdLight"><input name="link" type="text" class="caixa" id="link" value="<%= banco.getCampo("link", rs) %>" size="85" maxlength="100"></td>
            </tr>
          </table>
      </td>
    </tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<%= Util.getBotoes("links", pesq, tipo) %>
	<tr>
		<td>&nbsp;</td>
	</tr>
    <tr>
		<td width="100%" style="text-align:center">
			<table width="600px">
				<tr>
					<td width="100%" class="tdDark"><a title="Ordenar por Título" href="Javascript:ordenar('links','titulo')">Título</a></td>
				</tr>
			</table>
			<div style="width:600; height:101; overflow: auto">
				<table width="100%">
				    <%
						String resp[] = links.getLinks(pesq, "titulo", ordem, numPag, 10, tipo, cod_empresa);
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
