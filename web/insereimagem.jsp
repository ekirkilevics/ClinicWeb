<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.Imagem" id="imagem" scope="page"/>

<%
	String cod_hist = request.getParameter("codhist");
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

	function excluirImagem(cod_imagem, imagem, tipo)
	{
		conf = confirm("Confirma exclusão da imagem?");
		if(!conf) return;
		window.location = "gravarimagem.jsp?id=" + cod_imagem + "&img=" + imagem + "&codhist=<%= cod_hist%>" + "&acao=exc&tipo=" + tipo;
	}	
	
	function iniciar()
	{
		mensagem(inf);
		alteraraba('1',2, tdmedium, tddark);
	}
	
	function enviarForm() {
		var frm = cbeGetElementById("frmcadastrar");
		if(frm.imagem.value == "") {
			alert("Escolha a imagem a ser enviada");
			frm.imagem.focus();
			return;
		}
		frm.action += "?acao=inc";
		frm.submit();
	}
	
	function verTexto(cod_imagem) {
		displayPopup("textoimagem.jsp?cod="+cod_imagem,'poptextoimagem',130,255);	
	}
	
	
</script>
</head>

<body onLoad="iniciar()">
<form name="frmcadastrar" id="frmcadastrar" action="gravarimagem.jsp" method="post" ENCTYPE="multipart/form-data">
  <table width="500" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr>
      <td width="100%" height="18" class="title">.: Imagens :.</td>
    </tr>
	<tr style="height:25px">
		<td align="right"><span name='msg' id='msg' class="msg">&nbsp;</span></td>
	</tr>
    <tr align="center" valign="top">
      <td>
			<input type="hidden" name="cod_hist" id="cod_hist" value="<%= cod_hist%>">
	  		<table width="100%" border="0" cellpadding="0" cellspacing="0" class="table">
				<tr>
					<td class="tdMedium">Imagem</td>
					<td class="tdLight"><input type="file" class="caixa" name="imagem" id="imagem" size="60"></td>
				</tr>
				<tr>
					<td class="tdMedium">Descrição</td>
					<td class="tdLight"><textarea name="descricao" id="descricao" class="caixa" cols="67" rows="3"></textarea></td>
				</tr>
				<tr>
					<td class="tdMedium">Acompanhar?</td>
					<td class="tdLight">
						<select name="acompanha" id="acompanha" class="caixa">
							<option value="1">Sim</option>
							<option value="0">Não</option>
						</select>
					</td>
				</tr>
				<tr>
					<td colspan="2" class="tdMedium" align="right">
						<input type="button" class="botao" value="Enviar" onClick="enviarForm()">
					</td>
				</tr>
			</table>
	  </td>
    </tr>
  </table>
<!-- MENU -->
  <div id="menuabas" style="width:300px; background-color:<%= fundo%>; position: absolute; left:50px; top:230px; overflow: auto">
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
	<div id="aba1" style="width:500px; height:170px; background-color:<%= fundo%>; position: absolute; left:50px; top:250px; z-index:2; overflow: auto">
		<div style="width:450; height:150; overflow-x: auto">
			<%= imagem.getImagens(cod_hist) %>
		</div>
	</div>
 <!-- BARRA DE IMAGENS DO UPLOAD -->
 
 <!-- BARRA DE IMAGENS DA PRANCHETA -->
	<div id="aba2" style="width:500px; height:170px; background-color:<%= fundo%>; position: absolute; left:50px; top:250px; z-index:1; overflow: auto">
		<div style="width:450; height:150; overflow-x: auto">
			<%= imagem.getPranchetaHistoria(cod_hist) %>
		</div>
	</div>
 <!-- BARRA DE IMAGENS DA PRANCHETA -->

 </form>
</body>
</html>
