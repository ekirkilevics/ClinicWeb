<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.Relatorio" id="relatorio" scope="page"/>
<jsp:useBean class="recursos.Profissional" id="profissional" scope="page"/>

<%
	String proflogado[] = profissional.getProfissional((String)session.getAttribute("usuario"));
%>

<html>
<head>
<title>Relat�rio</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
<script language="JavaScript" src="js/ajax.js"></script>
<script language="JavaScript">
     //id do conv�nio
     var idReg = "<%= strcod%>";
	
	 function validaForm() {
		var vde = getObj("","de");
		var vate = getObj("","ate");
	
		if(vde.value == "") {
			alert("Preencha data de in�cio da pesquisa.");
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
		//Captura o formul�rio (sempre ter� o mesmo nome)
		var frm = cbeGetElementById('frmcadastrar');
		//contador de itens cadastrados
		cont=0;

		//Varre todos os elementos, limpandos o conte�do (exceto de bot�es)
		for(i=0; i<frm.elements.length; i++) {
			//Pega objeto por objeto do formul�rio
			obj = frm[i];

			//Se o tipo for bot�o, n�o limpar
			if(obj.type == "checkbox"){
				//Se estiver checado
				if(obj.checked) cont++;
			}
		}
		return cont;
	}
	
	function buscarAgenda() {
		if(verificaCheck() == 0) {
			alert("Escolhe pelo menos um campo a ser exibido no relat�rio");
			return;
		}
		
		var jscabecalho = cbeGetElementById("cabecalho");
		//Verifica se escolheu cabe�alho
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
			//Se for conv�nio
			if(jscabecalho.value == "4") {
				if(cbeGetElementById("cod_convenio").value == "") {
					alert("Selecione o conv�nio");
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
				<td width="92" class="tdMedium">Data In�cio</td>
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
                <td class="tdMedium">Conv�nio: </td>
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
						<option value="3">N�o compareceu</option>
						<option value="9">Atendido</option>
					</select>
				</td>
			</tr>
            <tr>
            	<td class="tdMedium">Cabe�alho: </td>
                <td class="tdLight" colspan="3">
                	<select name="cabecalho" id="cabecalho" class="caixa">
                    	<option value="">Nenhum</option>
                        <option value="1">Profissional</option>
                        <option value="2">Procedimento</option>
                        <option value="4">Conv�nio</option>
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
