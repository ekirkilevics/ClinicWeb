<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.Protocolo" id="protocolo" scope="page"/>

<%
	if(strcod != null) rs = banco.getRegistro("prot_questoes","cod_questao", Integer.parseInt(strcod) );
	if(Util.isNull(ordem)) ordem = "pergunta";
	
	//Faz a exclusão de itens
	protocolo.excluirItem(request.getParameter("exc"));
	
	//Verifica se foi aplicado o protocolo
	String aplicado = protocolo.getProtocoloAplicado(strcod, "prot_questao_bloco.cod_questao");
%>

<html>
<head>
<title>Questões</title>
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
	 var nome_campos_obrigatorios = Array("Descrição", "Tipo Resposta");
	 //Página a enviar o formulário
	 var page = "gravarquestoes.jsp";
     //Campos obrigatórios
	 var campos_obrigatorios = Array("pergunta", "tipo_resposta");
	 //protocolo aplicado
	 var jsaplicado = "<%= aplicado%>";

	 cod_ajuda = 32;

	 
	 function excluiritem(cod_item) {
	 	conf = confirm("Confirma exclusão do registro?");
		if(conf) {
		 	go('questoes.jsp?cod=' + idReg + '&exc=' + cod_item);
		}
	 }
	 
	 function insereitem() {
		var jsitem = cbeGetElementById("item");
		var jscodigo = cbeGetElementById("codigo");
		
		if(jscodigo.value == "") {
			mensagem("Preencha o código referente ao item");
			jscodigo.focus();
			return;
		}

		if(jsitem.value == "") {
			mensagem("Preencha a descrição do item");
			jsdose.focus();
			return;
		}
		
		enviarAcao('inc');	 
	 }
	 
	 function trocaTipo(valor) {
	 	var jsdivopcoes = cbeGetElementById("divopcoes");
		
		if(valor == "1" || valor == "2")
			jsdivopcoes.style.display = "block";
		else
			jsdivopcoes.style.display = "none";
	 }
	 
	 
	 function iniciar() {
			inicio();
			barrasessao();
		 	cbeGetElementById("tipo_resposta").value = "<%= banco.getCampo("tipo_resposta", rs) %>";
			trocaTipo("<%= banco.getCampo("tipo_resposta", rs) %>");
	 }
	 
	 
	function clickBotaoNovo() {
		go('questoes.jsp');
	}
	
	function clickBotaoSalvar() {
		if(jsaplicado == "S") {
			alert("Questão não pode ser alterada pois já foi aplicada em um protocolo");
		}
		else {
			enviarAcao('inc');
		}
	}
	
	function clickBotaoExcluir() {
		if(jsaplicado == "S") {
			alert("Questão não pode ser excluída pois já foi aplicada em um protocolo");
		}
		else {
			enviarAcao('exc');
		}
	}	 


</script>
</head>

<body onLoad="iniciar()">
<%@include file="barrasessao.jsp" %>
<form name="frmcadastrar" id="frmcadastrar" action="gravarvacinas.jsp" method="post">
  <table width="600" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr>
      <td width="651" height="18" class="title">.: Questões :.</td>
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
	            <td class="tdMedium">Descrição: *</td>
       	       	<td class="tdLight"><input name="pergunta" type="text" class="caixa" id="pergunta" value="<%= banco.getCampo("pergunta", rs) %>" size="80" maxlength="100"></td>
            </tr>
            <tr>
	            <td class="tdMedium">Tipo resposta: *</td>
       	       	<td class="tdLight">
                	<select name="tipo_resposta" id="tipo_resposta" class="caixa" onChange="trocaTipo(this.value)">
						<option value=""></option>
                    	<option value="1">Caixa de Seleção</option>
                        <option value="2">Seleção de Opções</option>
                        <option value="3">Texto curto</option>
                        <option value="4">Texto longo</option>
                    </select>
                </td>
            </tr>
			<tr>
				<td colspan="2" width="100%">
                	<div id="divopcoes" style="display:none">
					<table width="100%" border="0" cellpadding="0" cellspacing="0">
						<tr>
						  <td width="10%" class="tdMedium">Código</td>
                          <td width="70%" class="tdMedium">Descri&ccedil;&atilde;o</td>
						  <td width="20%" align="center"  class="tdMedium">Ação</td>
					  </tr>
						<tr>
							<td class="tdLight"><input type="text" class="caixa" name="codigo" id="codigo" size="20" maxlength="10" ></td>
                            <td class="tdLight"><input type="text" class="caixa" name="item" id="item" size="70" maxlength="50" ></td>
							<td class="tdLight" align="center"><a href="Javascript:insereitem()" title="Inserir Item"><img src="images/add.gif" border="0"></a></td>
						</tr>
						<%= protocolo.getItens(strcod) %>
					</table>
                    </div>
				</td>
			</tr>
          </table>
      </td>
    </tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<%= Util.getBotoes("questoes", pesq, tipo) %>
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
						String resp[] = protocolo.getQuestoes(pesq, "pergunta", ordem, numPag, 50, tipo, cod_empresa);
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
