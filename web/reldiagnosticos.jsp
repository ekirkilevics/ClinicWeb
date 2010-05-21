<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.Relatorio" id="relatorio" scope="page"/>

<%
	String cod_diag1 = request.getParameter("cod_diag1");
	String cod_diag2 = request.getParameter("cod_diag2");
	String descricao1 = request.getParameter("DESCRICAO1") == null ? "" : request.getParameter("DESCRICAO1");
	String descricao2 = request.getParameter("DESCRICAO2") == null ? "" : request.getParameter("DESCRICAO2");
	
	String de = request.getParameter("de") == null ? "01/" + Util.getMes(Util.getData()) + "/" + Util.getAno(Util.getData()) : request.getParameter("de");
	String ate = request.getParameter("ate") == null ? Util.getData() : request.getParameter("ate");
%>

<html>
<head>
<title>Relatório</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
<script language="JavaScript" src="js/ajax.js"></script>
<script language="JavaScript">
	
	 //Cod. da ajuda
	 cod_ajuda = 19;

	 function validaForm() {
		var vde = getObj("","de");
		var vate = getObj("","ate");
	
		if(vde.value == "") {
			alert("Preencha data de início da pesquisa.");
			vde.focus();
			return false;
		}

		if(vate.value == "") {
			alert("Preencha data de fim da pesquisa.");
			vate.focus();
			return false;
		}
		
		barrasessao();
		return true;
	 }
	 
	 function carregaListaCID(cod_diag) {  //Busca Ajax para os CIDs
				//Página que vai buscar os dados
				var url = "carregalistapacientesdiagnostivos.jsp?cod_diag=" + cod_diag + "&de=<%= de%>&ate=<%= ate%>";
	
				//Se for IE
				if (window.ActiveXObject) {
						xmlHttp = new ActiveXObject('Microsoft.XMLHTTP');
				}
				//Se for NETSCAPE
				else if (window.XMLHttpRequest) {
						xmlHttp = new XMLHttpRequest();
				}
				xmlHttp.open('GET', url, true);
				xmlHttp.onreadystatechange = eventos;
				xmlHttp.send(null);
		}

		function eventos(){
			var jslista = cbeGetElementById("listapacientes");
		
			//Mostra imagem de carregando na caixa
			if (xmlHttp.readyState == 1) {
				jslista.innerHTML = "Carregando lista de pacientes. Aguarde...";
			}
			//Carrega a lista com os resultados e volta o fundo da caixa pra branco
			if (xmlHttp.readyState == 4) {
				if (xmlHttp.status == 200) {
					xmlDoc = xmlHttp.responseText;
					jslista.innerHTML = xmlDoc;
				}
			 }
		}

</script>
</head>

<body onLoad="barrasessao();">
<%@include file="barrasessao.jsp" %>
<%@include file="barraajax.jsp" %>
<form name="frmcadastrar" id="frmcadastrar" action="reldiagnosticos.jsp" method="post" onSubmit="return validaForm()">
  <table width="600" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr>
      <td height="18" class="title">.: Pesquisa de Pacientes por Diagnósticos :.</td>
    </tr>
	<tr style="height:25px">
		<td align="right"><span name='msg' id='msg' class="msg">&nbsp;</span></td>
	</tr>
    <tr align="center" valign="top">
      <td>
         <table width="400" border="0" cellpadding="0" cellspacing="0" class="table">
		 	<tr>
	            <td height="21" colspan="5" align="center" class="tdMedium"><b>Filtros</b></td>
			</tr>
			<tr>
				<td class="tdMedium">Data Início: </td>
				<td class="tdLight"><input type="text" name="de" id="de" class="caixa" size="12" maxlength="10" onKeyPress="return formatar(this, event, '##/##/####');" value="<%= de%>"></td>
				<td class="tdMedium">Data Fim: </td>
				<td class="tdLight"><input type="text" name="ate" id="ate" class="caixa" size="12" maxlength="10" onKeyPress="return formatar(this, event, '##/##/####');" value="<%= ate%>"></td>
			</tr>
			<tr>
				<td class="tdMedium">CID Inicial: </td>
				<td colspan="3" class="tdLight">
						<input type="hidden" name="cod_diag1" id="cod_diag1" value="<%= cod_diag1%>">			
						<input style="width:100%" class="caixa" type="text" name="DESCRICAO1" id="DESCRICAO1" value="<%= descricao1%>" onKeyUp="buscadiagnosticos(this.value, 1)">
				</td>
			</tr>
			<tr>
				<td class="tdMedium">CID Final: </td>
				<td colspan="3" class="tdLight">
						<input type="hidden" name="cod_diag2" id="cod_diag2" value="<%= cod_diag2%>">			
						<input style="width:100%" class="caixa" type="text" name="DESCRICAO2" id="DESCRICAO2" value="<%= descricao2%>" onKeyUp="buscadiagnosticos(this.value, 2)">
				</td>
			</tr>
			<tr>
				<td colspan="4" class="tdMedium" align="right"><button type="submit" class="botao"><img src="images/busca.gif">&nbsp;&nbsp;&nbsp;Buscar</button></td>
			</tr>
         </table>
      </td>
    </tr>
  </table>
</form>
<center>
<%
	//Se já escolheu itens
	if(!Util.isNull(cod_diag1) && !Util.isNull(cod_diag2)) {
		out.println(relatorio.relResumoDiagnosticos(de, ate, cod_diag1, cod_diag2));
	
	}
%>
<br>
<div id="listapacientes" class="texto">&nbsp;</div>
</center>
</body>
</html>
