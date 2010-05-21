<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.Lote" id="lote" scope="page"/>

<%
	String de = Util.trataNulo(request.getParameter("de"), "01/" + Util.getMes(Util.getData()) + "/" + Util.getAno(Util.getData()) );
	String ate = Util.trataNulo(request.getParameter("ate"), Util.getData());
	String guiainicial = Util.trataNulo(request.getParameter("guiainicial"), "");
	String guiafinal = Util.trataNulo(request.getParameter("guiafinal"), "");
	String cod_convenio = Util.trataNulo(request.getParameter("cod_convenio"), "");
	String tipoGuia = Util.trataNulo(request.getParameter("tipoGuia"), "1");
	String nomeconvenio = Util.trataNulo(request.getParameter("descr_convenio"), "");
	String tipoConsulta = request.getParameter("tipoconsulta");
	
	if(Util.isNull(ordem)) ordem = "codGuia";	
%>

<html>
<head>
<title>Lotes</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
<script language="JavaScript" src="js/ajax.js"></script>
<script language="JavaScript">
     //id
     var idReg = "<%= strcod%>";
	 //Informação vinda de gravar
	 var inf = "<%= inf%>";
	 //Nome dos campos
	 var nome_campos_obrigatorios = Array("Convênio", "Tipo de Guias");
	 //Página a enviar o formulário
	 var page = "carregarlotes.jsp";
	 //Cod. da ajuda
	 cod_ajuda = 24;

     //Campos obrigatórios
	 var campos_obrigatorios = Array("cod_convenio", "tipoGuia");

	function iniciar() {
		cbeGetElementById("tipoGuia").value = "<%= tipoGuia%>";
		tipoC = "<%= tipoConsulta%>";
		
		if(tipoC != "intervalo") {
			cbeGetElementById("tipoconsulta1").checked = true;
			trocaOpcao("periodo");
		}
		else {
			cbeGetElementById("tipoconsulta2").checked = true;
			trocaOpcao("intervalo");
		}
		
		barrasessao();
	}
	
	function buscarGuias() {
		//Verifica qual filtro está usando
		//Se estiver checado o primeiro, é por periodo senão será por número de guias		
		if(cbeGetElementById("tipoconsulta1").checked) {
			jsde = cbeGetElementById("de");
			jsate = cbeGetElementById("ate");
			if(jsde.value == "") {
				mensagem("Preencha o valor de início da pesquisa",2);
				jsde.focus();
				return;
			}
			if(jsate.value == "") {
				mensagem("Preencha o valor de fim da pesquisa",2);
				jsate.focus();
				return;
			}
		}
		else {
			jsde = cbeGetElementById("guiainicial");
			jsate = cbeGetElementById("guiafinal");
			if(jsde.value == "") {
				mensagem("Preencha o valor de início da pesquisa",2);
				jsde.focus();
				return;
			}
			if(jsate.value == "") {
				mensagem("Preencha o valor de fim da pesquisa",2);
				jsate.focus();
				return;
			}
		}
		enviarAcao('inc');
	}
	
	function gerarlote() {
		var frm = cbeGetElementById("frmcadastrar");
		var tam = frm.elements.length;
		var obj;
		var selecionou = false;
		var cont = 0;

		//Varre todos os itens do formulário para encontrar as combos
    	for(var i=0;i<tam;i++)
		{
			//Pega objeto por objeto do formulário
			obj = frm[i];
			
			//Se achar uma combo, verificar se está marcada e contar
			if(obj.type == "checkbox" && obj.id != "chktodos") {
				if(obj.checked == true) {
					selecionou = true;
					cont++;
				}
			}
		}

		//Se não escolheu nenhuma
		if(!selecionou) {
			alert("Selecione pelo menos uma guia para entrar no lote");
			return;
		}
		
		//Se selecionou mais de 100
		if(cont>100) {
			alert("Foram selecionadas " + cont + " guias.\nO limite de guias por lote é 100");
			return;
		}
		frm.action = "carregarlotes2.jsp";
		frm.submit();
	}
	
	function todos(estado) {
		var obj;
		//Captura o formulário (sempre terá o mesmo nome)
		var frm = cbeGetElementById('frmcadastrar');
		//contador de itens cadastrados
		cont=0;

		//Varre todos os elementos, limpandos o conteúdo (exceto de botões)
		for(i=0; i<frm.elements.length; i++) {
			//Pega objeto por objeto do formulário
			obj = frm[i];

			//Se o tipo for botão, não limpar
			if(obj.type == "checkbox"){
				//Se for para checkar, verifica o valor máximo
				if(estado == true && cont > 100) {
					alert("Número máximo de guias por lote é 100.\nForam selecionadas as 100 primeiras guias");
					i = frm.elements.length;
				} 
				else {
					obj.checked = estado;
					cont++;
				}
			}
		}
	}
	
	function ordenarGuia(campo) {
		frm = cbeGetElementById("frmcadastrar");
		frm.action = "carregarlotes.jsp?ordem=" + campo;
		frm.submit();
	}	
	
	function editarguia(codguia, tipoguia) {
		if(tipoguia == "1")
			displayPopup("frmguiaconsulta.jsp?cod=" + codguia,'guiaconsulta',600,790);	
		else
			displayPopup("frmguiasadt.jsp?cod=" + codguia,'guiasadt',600,790);
	}
	
	function trocaOpcao(valor) {
		if(valor == "periodo") {
			cbeGetElementById("de").disabled = false;
			cbeGetElementById("ate").disabled = false;
			cbeGetElementById("guiainicial").disabled = true;
			cbeGetElementById("guiafinal").disabled = true;
		}
		else {
			cbeGetElementById("de").disabled = true;
			cbeGetElementById("ate").disabled = true;
			cbeGetElementById("guiainicial").disabled = false;
			cbeGetElementById("guiafinal").disabled = false;
		}
	}
	
</script>
</head>

<body onLoad="iniciar()">
<%@include file="barrasessao.jsp" %>
<%@include file="barraajax.jsp" %>
<form name="frmcadastrar" id="frmcadastrar" action="carregarlotes.jsp" method="post">
  <table width="600" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr>
      <td width="651" height="18" class="title">.: Gerar Lotes :.</td>
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
				<td class="tdMedium" width="80"><input type="radio" name="tipoconsulta" id="tipoconsulta1" value="periodo" onClick="trocaOpcao(this.value)"> Período: </td>
				<td class="tdMedium">Data Início: *</td>
				<td class="tdLight"><input type="text" name="de" id="de" class="caixa" size="12" maxlength="10" onKeyPress="return formatar(this, event, '##/##/####');" value="<%= de%>"></td>
				<td class="tdMedium">Data Fim: *</td>
				<td class="tdLight"><input type="text" name="ate" id="ate" class="caixa" size="12" maxlength="10" onKeyPress="return formatar(this, event, '##/##/####');" value="<%= ate%>"></td>
			</tr>
			<tr>
				<td class="tdMedium" width="80"><input type="radio" name="tipoconsulta" id="tipoconsulta2" value="intervalo" onClick="trocaOpcao(this.value)"> Intervalo: </td>
				<td class="tdMedium">Guia Inicial: *</td>
				<td class="tdLight"><input type="text" name="guiainicial" id="guiainicial" class="caixa" size="12" maxlength="10" onKeyPress="return soNumeros(event)" value="<%= guiainicial%>"></td>
				<td class="tdMedium">Guia Final: *</td>
				<td class="tdLight"><input type="text" name="guiafinal" id="guiafinal" class="caixa" size="12" maxlength="10" onKeyPress="return soNumeros(event)" value="<%= guiafinal%>"></td>
			</tr>
			<tr>
				<td colspan="2" class="tdMedium">Convênio: *</td>
				<td colspan="3" class="tdLight">
					<input type="hidden" name="cod_convenio" id="cod_convenio" value="<%= cod_convenio%>">			
					<input style="width:100%" class="caixa" type="text" name="descr_convenio" id="descr_convenio" onKeyUp="busca(this.value, 'cod_convenio', 'descr_convenio','convenio','AND ativo=\'S\'')" value="<%= nomeconvenio%>">
				</td>
			</tr>
			<tr>
	            <td colspan="2" class="tdMedium">Tipo de Guias: *</td>
	            <td colspan="3" class="tdLight"> 
				<select name="tipoGuia" id="tipoGuia" class="caixa">
					<option value="1">Guia de Consulta</option>
					<option value="2">Guia SP/SADT</option>
					<option value="3">Guia de Honorário Individual</option>
                    <option value="4">Guia de Resumo de Internação</option>
              	</select></td>
			</tr>					  		
		  </table>
      </td>
    </tr>
	<tr>
		<td height="6"></td>
	</tr>
	<tr>
		<td width="100%" align="center">
			<table cellpadding="0" cellspacing="0" class="table" width="100%">
				<tr>
					<td width="100%" class="tdMedium" align="right"><button type="button" class="botao" onClick="buscarGuias()"><img src="images/busca.gif">&nbsp;&nbsp;Buscar Guias</button></td>
			  </tr>
			</table>
	  </td>	
	</tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td width="30" style="border: 1px solid #CCCCCC; background-color:#FF6F6F">&nbsp;</td>
					<td class="texto"> Guia Incompleta</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td width="100%">
			<%= lote.getGuias(de, ate, cod_convenio, tipoGuia, ordem, tipoConsulta, guiainicial, guiafinal, cod_empresa)%>
		</td>
	</tr>
  </table>
</form>

</body>
</html>
