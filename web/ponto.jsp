<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.Ponto" id="ponto" scope="page"/>

<%
	String barra = request.getParameter("barra");
	String lancou = "";
	String agora = Util.getHora();
	
	//Se já clicou no Lançar
	if(barra != null)
	{
			//gravar
			lancou = ponto.registraPonto(barra, usuario_logado);
	}
%>

<html>
<head>
<title>..:: Registro de Ponto ::..</title>
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>

<script language="JavaScript">

	 function iniciar()
	 {
	 	var lancou = "<%= lancou%>";
		cbeGetElementById("barra").focus();
		if(lancou != "")
		{
			alert(lancou)
			self.close();
		}
	 }
	
</script>
</head>

<body onLoad="iniciar()">
<form name="frmcadastrar" id="frmcadastrar" action="ponto.jsp" method="post">
  <table width="100%" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr>
      <td width="100%" height="18" class="title">.: Registro de Ponto :.</td>
    </tr>
	<tr style="height:25px">
		<td align="right"><span name='msg' id='msg' class="msg">&nbsp;</span></td>
	</tr>
	<tr>
	  	<td width="100%">
			<table cellpadding="0" cellspacing="0" class="table" width="100%">
				<tr>
					<td align="center" class="tdMedium">Horário no servidor: <b><%= agora%></b></td>
				</tr>
			</table>
		</td>	
	</tr>
    <tr align="center" valign="top">
      <td width="100%">
	  	<table cellpadding="0" cellspacing="0" class="table" width="100%">
			<tr>
				<td class="tdMedium" align="center">Código de Barras</td>
			</tr>
			<tr>
				<td class="tdLight" align="center">
						<input type="password" class="caixa" name="barra" id="barra" size="10" maxlength="10" style="color:red; font-size:30px; font-weigh:bold">
				</td>
			</tr>
			<tr>
				<td class="tdMedium" align="center">Passe o crachá para registrar o ponto</td>
			</tr>
		</table>
	  </td>
    </tr>
  </table>
 </form>
</body>
</html>
