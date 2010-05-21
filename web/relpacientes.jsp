<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.FichaAtendimento" id="ficha" scope="page"/>
<jsp:useBean class="recursos.Paciente" id="paciente" scope="page"/>

<html>
<head>
<title>Fichas de Atendimento</title>
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
<script language="JavaScript" src="js/ajax.js"></script>
</head>

<body onLoad="barrasessao();">
<%@include file="barrasessao.jsp" %>
<%@include file="barraajax.jsp" %>
<form name="frmcadastrar" id="frmcadastrar" action="relpacientes2.jsp" method="post" target="_blank">
  <table width="600" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr> 
      <td height="18" class="title">.: Relatório: Pacientes :.</td>
    </tr>
    <tr> 
      <td>&nbsp;</td>
    </tr>
    <tr style="height:25px"> 
      <td align="right"><span name='msg' id='msg' class="msg">&nbsp;</span></td>
    </tr>
    <tr align="center" valign="top"> 
      <td> <table width="600" border="0" cellpadding="0" cellspacing="0" class="table">
		  <tr>
		  	<td class="tdDark" colspan="4" align="center"><strong>Filtros</strong></td>
		  </tr>
          <tr> 
            <td class="tdMedium">Nome do Paciente:</td>
            <td class="tdLight"><input type="text" class="caixa" name="paciente" id="paciente" size="40"></td>
			<td class="tdMedium">Tipo de Comparação:</td>
			<td class="tdLight">
				<select name="tipo" id="tipo" class="caixa">
					<option value="3">Meio</option>
					<option value="1">Exata</option>
					<option value="2">Início</option>							
				</select>
			</td>
          </tr>
		  <tr>
		  	<td class="tdMedium">Status:</td>
			<td class="tdLight" colspan="3">
				<select name="status" id="status" class="caixa">
					<option value="todos">Todos</option>
					<option value="0">Ativo</option>
					<option value="1">Inativo</option>
					<option value="2">Falecido</option>
				</select>
			</td>
		  </tr>
		  <tr>
		  	<td class="tdMedium">Profissional Responsável:</td>
			<td colspan="3" class="tdLight">
				<select name="prof_reg" id="prof_reg" class="caixa">
					<option value="">Todos</option>
					<%= paciente.getProfissionais( cod_empresa)%>
				</select>
			</td>
		  </tr>
		  <tr>
				<td class="tdMedium">Convênio:</td>
				<td class="tdLight" colspan="3">
					<input type="hidden" name="cod_convenio" id="cod_convenio">			
					<input style="width:100%" class="caixa" type="text" name="descr_convenio" id="descr_convenio" onKeyUp="buscaconvenios(this.value)">
				</td>
		  <tr>		  
		  <tr>
		  	<td class="tdMedium">Data de Cadastro</td>
			<td class="tdLight" colspan="3">
				Entre <input type="text" name="de" id="de" class="caixa" size="10" maxlength="10" onKeyPress="return formatar(this, event, '##/##/####'); " onBlur="ValidaData(this);">
				&nbsp;&nbsp;e&nbsp;&nbsp; <input type="text" name="ate" id="ate" class="caixa" size="10" maxlength="10" onKeyPress="return formatar(this, event, '##/##/####'); " onBlur="ValidaData(this);">
			</td>
		  </tr>
          <tr>
				<td  width="50" class="tdMedium">Mês de Nascimento:</td>
				<td class="tdLight" colspan="3">
					<select name="mes" id="mes" class="caixa">
						<option value="">Todos</option>
                        <option value="1">Janeiro</option>
						<option value="2">Fevereiro</option>
						<option value="3">Março</option>
						<option value="4">Abril</option>
						<option value="5">Maio</option>
						<option value="6">Junho</option>
						<option value="7">Julho</option>
						<option value="8">Agosto</option>
						<option value="9">Setembro</option>
						<option value="10">Outubro</option>
						<option value="11">Novembro</option>
						<option value="12">Dezembro</option>
					</select>
				</td>
          </tr>
		  <tr>
			<td colspan="4" align="center" class="tdMedium">&nbsp;<button type="submit" class="botao"><img src="images/print.gif">&nbsp;&nbsp;&nbsp;Listar</button></td>
          </tr>
        </table>
       </td>
    </tr>
  </table>
</form>

</body>
</html>
