<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.Imagem" id="imagem" scope="page"/>

<%
	String codcli = request.getParameter("codcli");
%>

<html>
<head>
<title>..:: Insere Imagem ::..</title>
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>

<script language="JavaScript">
    //id do convênio
     var idReg = "<%= strcod%>";
	 //Informação vinda de gravarconvenio
	 var inf = "<%= inf%>";
	 //Nome dos campos
	 var nome_campos_obrigatorios = Array("Imagem");
	 //Página a enviar o formulário
	 var page = "gravarimagem.jsp";
     //Campos obrigatórios
	 var campos_obrigatorios = Array("imagem");

	function iniciar() {
		alteraraba('1',2, tdmedium, tddark);
	}
	 
</script>
</head>

<body onLoad="iniciar()">
<form name="frmcadastrar" id="frmcadastrar" action="gravarimagem.jsp" method="post">
  <table width="500" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr>
      <td width="100%" height="18" class="title">.: Acompanhamento de Imagens :.</td>
    </tr>
	<tr style="height:25px">
		<td align="right"><span name='msg' id='msg' class="msg">&nbsp;</span></td>
	</tr>
	<tr>
		<td align="right"><input type="button" class="botao" value="Fechar" onClick="self.close()"></td>
	</tr>
  </table>
<!-- MENU -->
  <div id="menuabas" style="width:300px; background-color:<%= fundo%>; position: absolute; left:0px; top:80px; overflow: auto">
		<input type="hidden" name="numeroaba" id="numeroaba" value="<%= aba%>">
		<table cellpadding="0" cellspacing="0" class="table">
			<tr>
				<td id="tdaba1" class="tdMedium" onClick="Javascript:alteraraba('1',2, tdmedium, tddark)"> Imagens </td>
				<td id="tdaba2" class="tdMedium" onClick="Javascript:alteraraba('2',2, tdmedium, tddark)"> Prancheta </td>
			</tr>
		</table>
  </div>
<!-- MENU -->

 <!-- BARRA DE IMAGENS DO UPLOAD -->
	<div id="aba1" style="width:650px; height:170px; background-color:<%= fundo%>; position: absolute; left:0px; top:100px; z-index:2; overflow: auto">
		<div style="width:650; height:150; overflow-x: auto">
			<%= imagem.getImagensPaciente(codcli) %>
		</div>
	</div>
 <!-- BARRA DE IMAGENS DO UPLOAD -->
 
 <!-- BARRA DE IMAGENS DA PRANCHETA -->
	<div id="aba2" style="width:650px; height:170px; background-color:<%= fundo%>; position: absolute; left:0px; top:100px; z-index:1; overflow: auto">
		<div style="width:650; height:150; overflow-x: auto">
			<%= imagem.getImagensPrancheta(codcli) %>
		</div>
	</div>
 <!-- BARRA DE IMAGENS DA PRANCHETA -->
 </form>
</body>
</html>
