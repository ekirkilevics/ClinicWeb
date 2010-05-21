<%@include file="cabecalho.jsp" %>


<jsp:useBean class="recursos.Links" id="links" scope="page"/>
<%
	String assunto = request.getParameter("assunto") != null ? request.getParameter("assunto") : "";

%>

<html>
<head>
<title>Links Úteis</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
<script language="JavaScript">

	 //Cod. da ajuda
	 cod_ajuda = 30;

	function atualizar()
	{
		var frm = cbeGetElementById("frmcadastrar");
		frm.action = "linksuteis.jsp";
		frm.target = "_self";
		frm.submit();
	}
	
	function selecionaAssunto(cod_assunto) {
		self.location = "linksuteis.jsp?assunto=" + cod_assunto;
	}
</script>
</head>


<body onLoad="barrasessao();">
<%@include file="barrasessao.jsp" %>
<form name="frmcadastrar" id="frmcadastrar" action="linksuteis.jsp" method="post">
  <table width="600" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr>
      <td height="18" class="title">.: Links Úteis :.</td>
    </tr>
	<tr style="height:25px">
		<td align="right"><span name='msg' id='msg' class="msg">&nbsp;</span></td>
	</tr>
    <tr align="center" valign="top">
      <td>
         <table width="600" border="0" cellpadding="0" cellspacing="0" class="table">
            <tr>
    	        <td class="tdMedium"><b>Links Úteis por Assunto:</b></td>
			</tr>
			<tr>
				<td class="tdLight">
						<%= links.getAssuntos(cod_empresa)%>
				</td>
            </tr>
          </table>
      </td>
    </tr>
	<tr>
		<td>
			<%= links.getLinks(assunto)%>
		</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td width="100%">
			<table width="600" border="0" cellpadding="0" cellspacing="0" class="table">
				<tr>
					<td class="tdMedium"><b>Últimos Links Acessados</b></td>				
				</tr>
				<tr>
					<td class="tdLight">
						<%
							Cookie listaPossiveisCookies[] = request.getCookies();
							if (listaPossiveisCookies != null) {
								int numCookies = listaPossiveisCookies.length;
								String c="";
								for (int i = 0 ; i < numCookies ; ++i)  {
									c = listaPossiveisCookies[i].getName();
									if (c.equals("cookie1") || c.equals("cookie2") || c.equals("cookie3") || c.equals("cookie4") || c.equals("cookie5"))
										out.println(listaPossiveisCookies[i].getValue().replace('"',' ') + "<br>");
								}
							}
						%>		
					</td>
				</tr>
			</table>
		</td>
	</tr>
  </table>
<input type="hidden" name="link">
<input type="hidden" name="titulo">
</form>

</body>
</html>
