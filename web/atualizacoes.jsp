<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.Atualizacao" id="atualizacao" scope="page"/>
<jsp:useBean class="recursos.FTP" id="ftp" scope="page"/>
<%
	String versao = request.getParameter("versao") != null ? request.getParameter("versao") : "";
	String boot = request.getParameter("boot");
	
%>

<html>
<head>
<title>Atualizações</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
<script language="JavaScript">
	function atualizar()
	{
		var frm = cbeGetElementById("frmcadastrar");
		frm.submit();
	}
	
	function setarCampos()
	{
		var versao = "<%= versao %>";
		
		if(versao != "") getObj("","versao").value = versao;
	}
	
	function boottomcat() {
			
		//Página que vai buscar os dados do matriculado em AJAX
		var url = 'boottomcat.jsp';

		//Se for IE
		if (window.ActiveXObject) {
				xmlHttp = new ActiveXObject('Microsoft.XMLHTTP');
		}
		//Se for NETSCAPE
		else if (window.XMLHttpRequest) {
				xmlHttp = new XMLHttpRequest();
		}
		xmlHttp.open('GET', url, true);
		xmlHttp.onreadystatechange = retornoboot;
		xmlHttp.send(null);
	}
		
	function retornoboot(){
		if (xmlHttp.readyState == 4) {
			if (xmlHttp.status == 200) {
				alert("Sistema Reiniciado");
			}
		}
	}
	
	function iniciar() {
		setarCampos();
		barrasessao();
		
		<%
			if(boot != null && boot.equals("yes")) {
		%>		
			boottomcat();
		<%
			}
		%>
	}
	
</script>
</head>


<body onLoad="iniciar()">
<%@include file="barrasessao.jsp" %>
<form name="frmcadastrar" id="frmcadastrar" action="atualizacoes.jsp" method="post">
  <table width="600" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr>
      <td height="18" class="title">.: Atualizações :.</td>
    </tr>
	<tr style="height:25px">
		<td align="right"><span name='msg' id='msg' class="msg">&nbsp;</span></td>
	</tr>
    <tr align="center" valign="top">
      <td>
         <table width="600" border="0" cellpadding="0" cellspacing="0" class="table">
            <tr>
              <td class="tdMedium">Versão - Data:</td>
              <td class="tdLight">
					<select name="versao" id="versao" class="caixa" style="width:300px" onChange="atualizar()">
						<%= atualizacao.getVersoes() %>
					</select>
			  </td>
            </tr>
          </table>
      </td>
    </tr>
	<tr>
		<td width="600">
			<%= atualizacao.getAtualizacoes(versao)%>
		</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
  </table>
</form>

</body>
</html>
