<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.Protocolo" id="protocolo" scope="page"/>

<%
	if(strcod != null) rs = banco.getRegistro("prot_blocos","cod_bloco", Integer.parseInt(strcod) );
	if(Util.isNull(ordem)) ordem = "bloco";

	//Verifica se foi aplicado o protocolo
	String aplicado = protocolo.getProtocoloAplicado(strcod, "prot_bloco_protocolo.cod_bloco");
%>

<html>
<head>
<title>Blocos de questões</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
<script language="JavaScript">
     //id
     var idReg = "<%= strcod%>";
	 //Informação vinda de gravar
	 var inf = "<%= inf%>";
	 //Nome dos campos
	 var nome_campos_obrigatorios = Array("Bloco");
	 //Página a enviar o formulário
	 var page = "gravarblocos.jsp";
     //Campos obrigatórios
	 var campos_obrigatorios = Array("bloco");
	 //protocolo aplicado
	 var jsaplicado = "<%= aplicado%>";
	 
	 cod_ajuda = 33;

	function inserequestao() {
		var combo = cbeGetElementById("lstquestoes");
		
		for(i=0; i<combo.length; i++) {
			//Se estiver selecionado
			if( combo.options[i].selected == true ) {
				insereCombo("lstselecionada", combo.options[i].value, combo.options[i].text);				
			}
		}
	}
	
	function removequestao() {
		var combo = cbeGetElementById("lstselecionada");
		if(combo.selectedIndex >= 0) {
			combo.remove(combo.selectedIndex);
		}
	
	}
	
	function salvarBloco() {
		if(jsaplicado == "S") {
			alert("Bloco não pode ser alterado pois já foi aplicado em um protocolo");
		}
		else {
		
			var jsquestoes = cbeGetElementById("lstselecionada");
			
			if(jsquestoes.length == 0) {
				mensagem("Escolha pelo menos uma questão para compor o bloco", 2);
				return;
			}	
			
			enviarAcao('inc');
		}
	}
	
	function clickBotaoNovo() {
		self.location = "blocos.jsp";
	}
	
	function clickBotaoSalvar() {
		salvarBloco();
	}
	
	function clickBotaoExcluir() {
		if(jsaplicado == "S") {
			alert("Bloco não pode ser excluído pois já foi aplicado em um protocolo");
		}
		else {
			enviarAcao('exc');
		}
	}	 
	

</script>
</head>

<body onLoad="inicio();barrasessao();">
<%@include file="barrasessao.jsp" %>
<form name="frmcadastrar" id="frmcadastrar" action="gravarblocos.jsp" method="post">
  <table width="600" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr>
      <td width="651" height="18" class="title">.: Blocos de Questões :.</td>
    </tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td align="right"><span name='msg' id='msg' class="msg">&nbsp;</span></td>
	</tr>
    <tr align="center" valign="top">
      <td>
          <table width="100%" border="0" cellpadding="0" cellspacing="0" class="table">
            <tr>
	            <td class="tdMedium">Bloco: *</td>
    	        <td class="tdLight"><input name="bloco" type="text" class="caixa" id="bloco" value="<%= banco.getCampo("bloco", rs) %>" size="85" maxlength="100"></td>
            </tr>
            <tr>
	            <td colspan="2" width="100%">
					<table cellpadding="0" cellspacing="0" width="100%">
						<tr>
							<td class="tdMedium">Lista de Questões</td>
							<td class="tdMedium">&nbsp;</td>
							<td class="tdMedium" colspan="2">Questões Adicionadas</td>
						</tr>
						<tr>
							<td  class="tdLight">
								<select name="lstquestoes" id="lstquestoes" class="caixa" style="width:230px; height:100px" multiple>
									<%= protocolo.getQuestoes(cod_empresa)%>
								</select>
							</td>
							<td class="tdLight" align="center" valign="middle">
								<a href="Javascript:inserequestao()" title="Insere Questão"><img src="images/seta_dir.gif" border="0"></a><br><br>
								<a href="Javascript:removequestao()" title="Remove Questão"><img src="images/seta_esq.gif" border="0"></a><br>
							</td>
							<td class="tdLight">
								<select name="lstselecionada" id="lstselecionada" class="caixa" style="width:230px; height:100px" multiple>
									<%= protocolo.getQuestoesSelecionadas(strcod)%>
								</select>
                            </td>
                            <td class="tdLight" align="center">
                                <a title="Subir item" href="Javascript:move(this.form, cbeGetElementById('lstselecionada'), -1)"><img src="images/top.gif" border="0"></a><br><br>
                                <a title="Descer item" href="Javascript:move(this.form, cbeGetElementById('lstselecionada'), +1)"><img src="images/down.gif" border="0"></a>
							</td>
						</tr>
					</table>
				</td>
            </tr>
          </table>
      </td>
    </tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<%= Util.getBotoes("blocos", pesq, tipo) %>
	<tr>
		<td>&nbsp;</td>
	</tr>
    <tr>
		<td width="100%" style="text-align:center">
			<table width="600px">
				<tr>
					<td width="100%" class="tdDark">Questões</td>
				</tr>
			</table>
			<div style="width:600; height:101; overflow: auto">
				<table width="100%">
				    <%
						String resp[] = protocolo.getBlocos(pesq, "bloco", ordem, numPag, 50, tipo, cod_empresa);
						out.println(resp[0]);
					%>
				</table>
			</div>
			<table width="600px">
				<tr>
					<td colspan="2" class="tdMedium" style="text-align:right"><%= resp[1]%></td>
				</tr>
			</table>
		</td>
	</tr>
  </table>
</form>

</body>
</html>
