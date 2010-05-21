<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.Relatorio" id="relatorio" scope="page"/>

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
		var jsexecutante = cbeGetElementById("executante").value;
		var jssolicitante = cbeGetElementById("prof_reg").value;
	
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
		
		if(jsexecutante == jssolicitante) {
			alert("Executante não pode ser igual ao solicitante");
			return false;
		}

		barrasessao();
		return true;
	 }


</script>
</head>

<body onLoad="barrasessao();">
<%@include file="barrasessao.jsp" %>
<%@include file="barraajax.jsp" %>
<form name="frmcadastrar" id="frmcadastrar" action="rellancamentos2.jsp" target="_blank" method="post" onSubmit="return validaForm()">
  <table width="600" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr>
      <td height="18" class="title">.: Relatório Analítico Financeiro :.</td>
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
				<td class="tdMedium">Data Início</td>
				<td class="tdLight"><input type="text" name="de" id="de" class="caixa" size="12" maxlength="10" onKeyPress="return formatar(this, event, '##/##/####');" value='01/<%= Util.getMes(Util.getData()) + "/" + Util.getAno(Util.getData())%>'></td>
				<td class="tdMedium">Data Fim</td>
				<td class="tdLight"><input type="text" name="ate" id="ate" class="caixa" size="12" maxlength="10" onKeyPress="return formatar(this, event, '##/##/####');" value="<%= Util.getData()%>"></td>
			</tr>
			<tr>
				<td class="tdMedium">Executante</td>
				<td colspan="3" class="tdLight">
					<select name="executante" id="executante" class="caixa" style="width: 300px">
						<option value="todos">Todos</option>
						<%= relatorio.getProfissionais(cod_empresa) %>
					</select>
				</td>
			</tr>
			<tr>
				<td class="tdMedium">Solicitante</td>
				<td colspan="3" class="tdLight">
					<input type="hidden" name="prof_reg" id="prof_reg">			
					<input style="width:100%" class="caixa" type="text" name="profissional.nome" id="profissional.nome" onKeyUp="busca(this.value, 'prof_reg', 'profissional.nome','profissional')">
				</td>
			</tr>
			<tr>
				<td class="tdMedium">Tipo Solicitante</td>
				<td colspan="3" class="tdLight">
					<select name="tiposolicitante" id="tiposolicitante" class="caixa" style="width:200px">
						<option value="todos">Todos</option>
						<option value="interno">Interno</option>
						<option value="externo">Externo</option>
					</select>
				</td>
			</tr>
			<tr>
				<td class="tdMedium">Paciente</td>
				<td colspan="3" class="tdLight">
             			<input type="hidden" name="codcli" id="codcli">			
						<input style="width:100%" class="caixa" type="text" name="nome" id="nome" onKeyUp="busca(this.value, 'codcli', 'nome','paciente')">
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
				<td class="tdMedium">Especialidade</td>
				<td colspan="3" class="tdLight">
					<select name="especialidade" id="especialidade" class="caixa" style="width:200px">
						<option value="todos">Todos</option>
						<%= relatorio.getEspecialidades(cod_empresa)%>
					</select>
				</td>
			</tr>
			<tr>
				<td class="tdMedium">Grupo de<br>Procedimento</td>
				<td colspan="3" class="tdLight">
					<select name="grupoproced" id="grupoproced" class="caixa" style="width:200px">
						<option value="todos">Todos</option>
						<%= relatorio.getGruposProcedimentos(cod_empresa)%>
					</select>
				</td>
			</tr>
			<tr>
				<td class="tdMedium">Procedimento</td>
				<td colspan="3" class="tdLight">
              			<input type="hidden" name="COD_PROCED" id="COD_PROCED">			
						<input style="width:100%" class="caixa" type="text" name="Procedimento" id="Procedimento" onKeyUp="buscaprocedimentos(this.value)">
				</td>
			</tr>
			<tr>
				<td class="tdMedium">Convênio</td>
				<td colspan="3" class="tdLight">
              			<input type="hidden" name="cod_convenio" id="cod_convenio">			
						<input style="width:100%" class="caixa" type="text" name="descr_convenio" id="descr_convenio" onKeyUp="busca(this.value, 'cod_convenio', 'descr_convenio','convenio')">
				</td>
			</tr>
		 	<tr>
				<td colspan="4" class="tdMedium" align="center"><b>Totais</b></td>
			</tr>
			<tr>
				<td class="tdMedium">Agrupar por</td>
				<td colspan="4" class="tdLight">
					<select name="agrupar" id="agrupar" class="caixa">
						<option value="Executante.nome">Executante</option>
						<option value="Solicitante.nome">Solicitante</option>
						<option value="faturas.Data_Lanca">Data</option>
						<option value="paciente.nome">Paciente</option>
						<option value="procedimentos.Procedimento">Procedimento</option>
						<option value="especialidade.descri">Especialidade</option>
						<option value="convenio.descr_convenio">Convênio</option>
					</select>
				</td>
			</tr>
			<tr>
				<td colspan="4" class="tdMedium" align="right"><button type="submit" class="botao"><img src="images/print.gif">&nbsp;&nbsp;&nbsp;Buscar</button></td>
			</tr>
         </table>
      </td>
    </tr>
  </table>
</form>

</body>
</html>
