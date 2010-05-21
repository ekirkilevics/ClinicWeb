<%@include file="cabecalho.jsp" %>
<%
	Sincronismo sincronismo = new Sincronismo("");
%>

<html>
<head>
<title>Relatório</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
<script language="JavaScript">
		function sincronizar() {
			alert("Sincronismo desativado para esse cliente. Para ativar o sincronismo, <%= contato%>");
		}


	function todos(estado) {
		var obj;
		//Captura o formulário (sempre terá o mesmo nome)
		var frm = cbeGetElementById('frmcadastrar');

		//Varre todos os elementos, limpandos o conteúdo (exceto de botões)
		for(i=0; i<frm.elements.length; i++) {
			//Pega objeto por objeto do formulário
			obj = frm[i];

			//Se o tipo for botão, não limpar
			if(obj.type == "checkbox"){
				obj.checked = estado;
			}
		}
	}

	function pegarChecados() {
		var resp = "";
		var obj;
		//Captura o formulário (sempre terá o mesmo nome)
		var frm = cbeGetElementById('frmcadastrar');

		//Varre todos os elementos
		for(i=0; i<frm.elements.length; i++) {
			//Pega objeto por objeto do formulário
			obj = frm[i];

			//Se for checkbox, verificar se checado
			if(obj.type == "checkbox" && obj.name != 'todas'){
				if(obj.checked == true)
					resp += obj.value + ",";
			}
		}
		
		return resp;
	}
	
</script>
</head>

<body onLoad="barrasessao();">
<%@include file="barrasessao.jsp" %>
<form name="frmcadastrar" id="frmcadastrar" action="#" target="_blank" method="post" onSubmit="return validaForm()">
  <table width="600" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr>
      <td height="18" class="title">.: Sincronização de Tabelas :.</td>
    </tr>
	<tr style="height:25px">
		<td align="right"><span name='msg' id='msg' class="msg">&nbsp;</span></td>
	</tr>
    <tr align="center" valign="top">
      <td>
         <table width="400" border="0" cellpadding="0" cellspacing="0" class="table">
			<tr>
				<td class="tdDark">Tabelas</td>
				<td class="tdDark"><input type="checkbox" onClick="todos(this.checked)" id="todas" name="todas"> Todas</td>
			</tr>
			<%= sincronismo.getItensSincronismo() %>
			<tr>
				<td class="tdMedium" colspan="2" align="center"><button type="button" class="botao" onClick="sincronizar()"><img src="images/4.gif">&nbsp;Sincronizar</button></td>
			</tr>
         </table>
		 <br>
		 <div id="imagem" class="texto" style="color:red">&nbsp;</div>
      </td>
    </tr>
  </table>
</form>

</body>
</html>
