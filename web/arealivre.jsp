<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.Historico" id="historico" scope="page"/>
<%
	String codhist = request.getParameter("codhist");
%>

<html>
<head>
<title>Área de Desenho</title>
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
</head>

<body>
<form name="frmcadastrar" id="frmcadastrar" action="#" method="post">
  <table width="100%" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr align="center" valign="top">
      <td>
	  		<table width="100%" border="0" cellpadding="0" cellspacing="0" class="table">
				<tr>
					<td colspan="4" class="tdLight">
						<applet code="prancheta.class" cabbase="prancheta.class" width=100% height="500">
			               <param name="width" value="250">
						   <param name="height" value="430">
						   <param name="ipserver" value="<%= Propriedade.getCampo("ipServer")%>">
						   <param name="codhist" value="<%= codhist%>">
						   <param name="cod_empresa" value="<%= cod_empresa%>">
						</applet>
					</td>
				</tr>
			</table>
	  </td>
    </tr>
  </table>
</form>

</body>
</html>
