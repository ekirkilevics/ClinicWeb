<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.Relatorio" id="relatorio" scope="page"/>
<jsp:useBean class="recursos.Profissional" id="profissional" scope="page"/>

<%
	String proflogado[] = profissional.getProfissional((String)session.getAttribute("usuario"));
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
     //id do convênio
     var idReg = "<%= strcod%>";
	
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
	 
	function verificaCheck() {
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
				//Se estiver checado
				if(obj.checked) cont++;
			}
		}
		return cont;
	}
	
	function buscarAgenda() {
		if(verificaCheck() == 0) {
			alert("Escolhe pelo menos um campo a ser exibido no relatório");
			return;
		}
		
		var jscabecalho = cbeGetElementById("cabecalho");
		//Verifica se escolheu cabeçalho
		if(jscabecalho.value != "") {
			//Se for profissional
			if(jscabecalho.value == "1") {
				if(cbeGetElementById("prof_reg").value == "") {
					alert("Selecione o profissional");
					cbeGetElementById("prof_reg").focus();
					return;
				}	
			}
			//Se for procedimento
			if(jscabecalho.value == "2") {
				if(cbeGetElementById("procedimento").value == "") {
					alert("Selecione o procedimento");
					cbeGetElementById("procedimento").focus();
					return;
				}	
			}
			//Se for status
			if(jscabecalho.value == "3") {
				if(cbeGetElementById("statusagenda").value == "") {
					alert("Selecione o status");
					cbeGetElementById("statusagenda").focus();
					return;
				}	
			}
			//Se for convênio
			if(jscabecalho.value == "4") {
				if(cbeGetElementById("cod_convenio").value == "") {
					alert("Selecione o convênio");
					cbeGetElementById("descr_convenio").focus();
					return;
				}	
			}
		}
		
		cbeGetElementById("frmcadastrar").submit();
			
	}
	 


</script>
</head>

<body onLoad="barrasessao();hideAll();">
<%@include file="barrasessao.jsp" %>
<%@include file="barraajax.jsp" %>
<form name="frmcadastrar" id="frmcadastrar" action="relagenda2.jsp" target="_blank" method="post" onSubmit="return validaForm()">
  <table width="600" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr>
      <td height="18" class="title">.: Imprimir Agenda :.</td>
    </tr>
	<tr style="height:25px">
		<td align="right"><span name='msg' id='msg' class="msg">&nbsp;</span></td>
	</tr>
    <tr align="center" valign="top">
      <td>
         <table width="300" border="0" cellpadding="0" cellspacing="0" class="table">
		 	<tr>
				
            <td height="21" colspan="5" align="center" class="tdMedium"><b>Filtros</b></td>
			</tr>
			<tr>
				<td width="92" class="tdMedium">Data Início</td>
				<td width="73" class="tdLight"><input type="text" name="de" id="de" class="caixa" size="12" maxlength="10" onKeyPress="return formatar(this, event, '##/##/####');" value='<%= Util.getData()%>'></td>
				<td width="58" class="tdMedium">Data Fim</td>
				<td width="76" class="tdLight"><input type="text" name="ate" id="ate" class="caixa" size="12" maxlength="10" onKeyPress="return formatar(this, event, '##/##/####');" value="<%= Util.getData()%>"></td>
			</tr>
			<tr>
				<td class="tdMedium">Profissional</td>
				<td colspan="3" class="tdLight">
				<%
					if(!Util.isNull(proflogado[0])) {
						out.println("<input type='hidden' name='prof_reg' id='prof_reg' value='" + proflogado[0] + "'>");
						out.println("<div class='texto'>" + proflogado[1] + "</div>\n");
					}
					else {
				%>
					<select name="prof_reg" id="prof_reg" class="caixa">
						<option value=""><-- Todos --></option>
						<%= relatorio.getProfissionais( cod_empresa )%>
					</select>
				<%
					}
				%>
				</td>
			</tr>
			<tr>
				<td class="tdMedium">Procedimento:</td>
				<td class="tdLight" colspan="3">
					<select name="procedimento" id="procedimento" class="caixa">
						<option value=""><-- Todos --></option>
						<%= relatorio.getGruposProcedimentos( cod_empresa )%>
					</select>
				</td>
			</tr>
            <tr>
                <td class="tdMedium">Convênio: </td>
                <td class="tdLight" colspan="3">
                    <input type="hidden" name="cod_convenio" id="cod_convenio">			
                    <input style="width:100%" class="caixa" type="text" name="descr_convenio" id="descr_convenio" onKeyUp="buscaconvenios(this.value)">
                </td>
            </tr>
			<tr>
            	<td class="tdMedium">Tipo Paciente:</td>
				<td class="tdLight" colspan="3">
					<select name="primeiravez" id="primeiravez" class="caixa">
						<option value=""><-- Todos --></option>
						<option value="S">Paciente de Primeira Vez</option>
					</select>
				</td>
            </tr>
			<tr>
				<td class="tdMedium">Status:</td>
				<td class="tdLight" colspan="3">
					<select name="statusagenda" id="statusagenda" class="caixa">
						<option value=""><-- Todos --></option>
						<option value="1">Aguardando atendimento</option>
						<option value="3">Não compareceu</option>
						<option value="9">Atendido</option>
					</select>
				</td>
			</tr>
            <tr>
            	<td class="tdMedium">Cabeçalho: </td>
                <td class="tdLight" colspan="3">
                	<select name="cabecalho" id="cabecalho" class="caixa">
                    	<option value="">Nenhum</option>
                        <option value="1">Profissional</option>
                        <option value="2">Procedimento</option>
                        <option value="4">Convênio</option>
                        <option value="3">Status</option>
                	</select>
                 </td>
            </tr>
			<tr>
				<td colspan="4" class="tdDark" align="center">Campos a Exibir</td>
			</tr>
			<tr>
				<td colspan="4">
					<table cellpadding="0" cellspacing="0" width="100%" border="0">
						<%= relatorio.getCamposRelAgenda(request) %>
					</table>
				</td>
			</tr>
			<tr>
				<td colspan="4" class="tdMedium" align="right"><button type="button" class="botao" onClick="buscarAgenda()"><img src="images/busca.gif">&nbsp;&nbsp;&nbsp;Buscar</button></td>
			</tr>
         </table>
      </td>
    </tr>
  </table>
</form>
</body>
</html>
