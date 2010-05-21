<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.Backup" id="backup" scope="page"/>

<html>
<head>
<title>Backup</title>
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
<script language="JavaScript">
     //id do convênio
     var idReg = "1";
	 //Cod. da ajuda
	 cod_ajuda = 29;


	 //Depois que voltou do gravar
	 var inf = "<%= inf%>";
	
	var xmlHttp;
		function executaBackup() {
			alert("Nessa versão, o sistema somente vai gerar uma cópia local em uma pasta previamente configurada.\nPara o armazenamento remoto do Backup, <%= contato%>");
			cbeGetElementById("mensagem").innerHTML = "Backup sendo gerado. Isso pode levar alguns minutos, aguarde...";
			cbeGetElementById("gerar").disabled = true;
			cbeGetElementById("imagem").src = "images/criando.gif";
			
			//Página que vai buscar os dados do matriculado em AJAX
			var url = 'executabackup.jsp';

			//Se for IE
			if (window.ActiveXObject) {
					xmlHttp = new ActiveXObject('Microsoft.XMLHTTP');
			}
			//Se for NETSCAPE
			else if (window.XMLHttpRequest) {
					xmlHttp = new XMLHttpRequest();
			}
			xmlHttp.open('GET', url, true);
			xmlHttp.onreadystatechange = callback;
			xmlHttp.send(null);
		}
		
		function callback(){
			if (xmlHttp.readyState == 4) {
				if (xmlHttp.status == 200) {
					cbeGetElementById("newdata").innerHTML = "<%= Util.getData()%>";
					cbeGetElementById("newhora").innerHTML = getHora();
					cbeGetElementById("newlocal").innerHTML = "S";
					cbeGetElementById("newremoto").innerHTML = "N";
					cbeGetElementById("mensagem").innerHTML = "Backup gerado com sucesso!";
					cbeGetElementById("imagem").src = "images/backup.gif";
				}
			}
		}

	 
</script>
</head>

<body onLoad="barrasessao();">
<%@include file="barrasessao.jsp" %>
<form name="frmcadastrar" id="frmcadastrar" action="gravarmenu.jsp" method="post">
  <table width="600" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr>
      <td width="651" height="18" class="title">.: Backup do Sistema :.</td>
    </tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr style="height:25px">
		<td align="right"><span name='msg' id='msg' class="msg">&nbsp;</span></td>
	</tr>
	<tr>
		<td align="center"><img id="imagem" name="imagem" src="images/backup.gif" border="0"></td>
	</tr>
    <tr align="center" valign="top">
      <td>
			<div class="texto" id="mensagem">Clique no botão abaixo para realizar o backup do sistema</div>
      </td>
    </tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
    <tr align="center" valign="top">
      <td width="100%">
            <table width="100%" border="0" cellpadding="0" cellspacing="0" class="table">
				<tr>
					<td class="tdMedium" style="text-align:center"><button name="gerar" id="gerar" type="button" class="botao" style="width:100px" onClick="executaBackup();"><img src="images/14.gif">&nbsp;&nbsp;&nbsp;Gerar Backup</button></td>
				</tr>
			</table>
	  </td>
    </tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
  </table>
  <center>
  <table cellpadding="0" cellspacing="0" width="600" class="table">
	<tr>
		<td class="tdLight">
			O processo de Backup é constituído de 3 etapas:<br>
			1) Geração do Backup em uma pasta do servidor local (normalmente C:\BACKUP que pode ser configurado)<br>
			2) Compactação do arquivo do Backup local<br>
			3) Envio do arquivo compactado para um provedor seguro remoto, administrado pela KATU<br><br>
			
			O arquivo enviado ao provedor só é disponibilizado ao proprietário do mesmo, mediante solicitação por escrito.<br>
			Nossa política de armazenamento é manter os últimos 5 arquivos enviados; os demais são excluídos automaticamente.
			</td>
	</tr>
  </table>
  <br>
  <table border="0" cellpadding="0" cellspacing="0" class="table">
     <tr>
       <td class='tdMedium' align='center'>Data</td>
       <td class='tdMedium' align='center'>Hora</td>
       <td class='tdMedium' align='center'>Local</td>
       <td class='tdMedium' align='center'>Remoto</td>
     </tr>
     <tr>
       <td class='tdLight' align='center' id='newdata'></td>
       <td class='tdLight' align='center' id='newhora'></td>
       <td class='tdLight' align='center' id='newlocal'></td>
       <td class='tdLight' align='center' id='newremoto'></td>
     </tr>
  	 <%= backup.getBackups(cod_empresa)%>
  </table>
  </center>
</form>

</body>
</html>
