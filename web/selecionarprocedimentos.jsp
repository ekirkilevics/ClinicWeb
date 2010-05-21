<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.Historico" id="historico" scope="page"/>

<html>
<head>
<title>Selecionar Procedimentos</title>
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
<script language="javascript">
	function solicitaSADT() {
		var frm = cbeGetElementById('frmcadastrar');
		var selecionou = false;	
	

		//Varre todos os elementos, limpandos o conteúdo (exceto de botões)
		for(i=0; i<frm.elements.length; i++) {
			//Pega objeto por objeto do formulário
			obj = frm[i];

			//Se o tipo for botão, não limpar
			if(obj.type == "checkbox" && obj.id != "todos"){
				if(obj.checked == true) selecionou = true;
			}
		}

		if(!selecionou) {
			alert("Selecione pelo menos um procedimento para imprimir a Guia de Solicitação");
			return;
		}
		else {
			self.resizeTo(750,500);	
			frm.action = "guiaspsadtsolicitacao.jsp?cod=<%= strcod%>";
			frm.submit();
		}
	}
	
	function checktodos(estado) {
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
	
	function iniciar() {
		checktodos(true);
	}
	

</script>
	
</head>

<body onLoad="iniciar()">
<form name="frmcadastrar" id="frmcadastrar" action="guiaspsadtsolicitacao" method="post">
	<div class="title">Procedimentos</div>
	<center>
	<table cellpadding="0" cellspacing="0" class="table"  width="90%">
		<tr>
			<td class="tdMedium" align="center"><input type="checkbox" onClick="checktodos(this.checked)" name="todos" id="todos">Todos</td>
            <td class="tdMedium">Procedimento</td>
		</tr>
        <%= historico.getProcedimentosHistoria(strcod)%>
        <tr>
        	<td colspan="2" class="tdMedium" align="center"><button class="botao" type="button" onClick="solicitaSADT()"><img src="images/print.gif">&nbsp;&nbsp;&nbsp;Imprimir</button></td>
        </tr>
	</table>
    </center>
</form>
</body>
</html>
