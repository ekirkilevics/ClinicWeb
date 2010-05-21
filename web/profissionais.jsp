<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.Profissional" id="profissional" scope="page"/>

<%
	if(strcod != null) rs = banco.getRegistro("profissional","cod", Integer.parseInt(strcod) );
	if(ordem == null) ordem = "nome";
%>

<html>
<head>
<title>Profissionais</title>
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
<script language="JavaScript">
     //id do convênio
     var idReg = "<%= strcod%>";
	 //Informação vinda de gravarprocedimento
	 var inf = "<%= inf%>";
	 //Nome dos campos
	 var nome_campos_obrigatorios = Array("Registro Profissional","UF do Conselho", "Nome", "Externo/Interno", "Status");
	 //Página a enviar o formulário
	 var page = "gravarprofissional.jsp";
	 //Cod. da ajuda
	 cod_ajuda = 15;

     //Campos obrigatórios
	 var campos_obrigatorios = Array("registro", "ufConselho", "nome", "locacao", "exibir");

	function excluiItem()
	{
		var espec = getObj("","especialidade");
		if(espec.selectedIndex >= 0) {
			conf = confirm("Excluir o item da lista?","Confirmação");
			if(conf) {
				espec.remove(espec.selectedIndex);
			}
		}
	}

	function incluiEspecialidade()
	{
		var combo = getObj("","lista");
		insereCombo("especialidade", combo.options[combo.selectedIndex].value, combo.options[combo.selectedIndex].text);

	}
	
	function setarValores()
	{
		getObj("","locacao").value = "<%= banco.getCampo("locacao", rs)%>";
		getObj("","exibir").value = "<%= banco.getCampo("exibir", rs)%>";
		getObj("","ufConselho").value = "<%= banco.getCampo("ufConselho", rs)%>";
	}
 
 
 function salvarregistro()
 {
	//Se for médico interno, solicitar tempo de consulta e UF do conselho
    if(cbeGetElementById("locacao").value == "interno") {
		var jstempo = cbeGetElementById("tempoconsulta");
		var jsufConselho = cbeGetElementById("ufConselho");
		var jsespecialidades = cbeGetElementById("especialidade");
		if(jstempo.value == "") {
			mensagem("Preencha o tempo de consulta para médico interno", 2);
			jstempo.focus();
			return;
		}
		if(jsufConselho.value == "") {
			mensagem("Preencha a UF do Conselho do Profissional", 2);
			jsufConselho.focus();	
		}
		if(jsespecialidades.length ==0 ) {
			mensagem("Escolha pelo menos uma especialidade para o profissional", 2);
			return;
		}
		
	}
	
	enviarAcao('inc');
 }
 
	function clickBotaoNovo() {
		botaoNovo();
	}
	
	function clickBotaoSalvar() {
		salvarregistro();
	}
	
	function clickBotaoExcluir() {
		enviarAcao('exc');
	} 

</script>
</head>

<body onLoad="inicio();setarValores();barrasessao();">
<%@include file="barrasessao.jsp" %>
<form name="frmcadastrar" id="frmcadastrar" action="gravarprocedimento.jsp" method="post">
  <!-- Campos Ocultos -->
  <input type="hidden" name="ordem" value="<%= ordem%>">
  <!-- Campos Ocultos -->
  <table width="600" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr>
      <td width="100%" height="18" class="title">.: Profissionais :.</td>
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
              
            <td width="150" class="tdMedium">Registro Profissional: * </td>
              <td class="tdLight">
			  	<input name="registro" type="text" class="caixa" id="registro" value="<%= banco.getCampo("reg_prof", rs) %>" size="10" maxlength="11">
	  		    <input name="prof_reg" type="hidden" value="<%= banco.getCampo("prof_reg", rs) %>">
			  </td>
			  <td class="tdMedium">UF do Conselho: *</td>
			  <td class="tdLight">
					<select name="ufConselho" class="caixa" id="ufConselho">
						<option value="" ></option>
						<option value=AC >AC </option>
						<option value=AL >AL </option>
						<option value=AM >AM </option>
						<option value=AP >AP </option>
						<option value=BA >BA </option>
						<option value=CE >CE </option>
						<option value=DF >DF </option>
						<option value=ES >ES </option>
						<option value=GO >GO </option>
						<option value=MA >MA </option>
						<option value=MG >MG </option>
						<option value=MS >MS </option>
						<option value=MT >MT </option>
						<option value=PA >PA </option>
						<option value=PB >PB </option>
						<option value=PE >PE </option>
						<option value=PI >PI </option>
						<option value=PR >PR </option>
						<option value=RJ >RJ </option>
						<option value=RN >RN </option>
						<option value=RO >RO </option>
						<option value=RR >RR </option>
						<option value=RS >RS </option>
						<option value=SC >SC </option>
						<option value=SE >SE </option>
						<option value=SP SELECTED>SP </option>
						<option value=TO >TO </option>
				   </select>
			  
			  </td>
            </tr>
            <tr>
              <td width="150" class="tdMedium">Nome: *</td>
              <td colspan="3" class="tdLight"><input name="nome" type="text" class="caixa" id="nome" value="<%= banco.getCampo("nome", rs) %>" style="width:100%" maxlength="50"></td>
            </tr>
			<tr>
				<td class="tdMedium">Profissão/Especialidade:</td>
				<td colspan="3">
					<table cellspacing="0" cellpadding="0" width="100%">
						<tr>
							<td class="tdLight">
								<select name="lista" id="lista" class="caixa" style="width:390">
									<option value="0"></option>
									<%= profissional.getEspecialidadesAll(cod_empresa)%>
								</select>
							</td>
							<td width="40" class="tdLight" align="center"><a href="Javascript:incluiEspecialidade()"><img src="images/add.gif" border="0"></a></td>
						</tr>
					</table>
				</td>
		    </tr>
			<tr>
				<td class="tdMedium">Especialidades:</td>
				<td colspan="3">
					<table cellpadding="0" cellspacing="0" width="100%">
						<tr>
							<td class="tdLight">
								<select multiple name="especialidade" id="especialidade" class="caixa" style="width:390px; height:66px">
									<%= profissional.getEspecialidades( banco.getCampo("prof_reg", rs))%>
								</select>
							</td>
							<td width="40" class="tdLight" align="center"><a href="Javascript:excluiItem()"><img src="images/delete.gif" border="0"></a></td>													
						</tr>
					</table>
				</td>
		    </tr>
            <tr>
              <td class="tdMedium">Endereço:</td>
              <td colspan="3" class="tdLight"><input name="endereco" type="text" class="caixa" id="endereco" value="<%= banco.getCampo("nome_logradouro", rs) %>" style="width:100%" maxlength="50"></td>
            </tr>
            <tr>
              <td class="tdMedium">Tel. Residencial:</td>
              <td class="tdLight">
				<input name="dddres" onKeyPress="OnlyNumbers(this,event);" type="text" class="caixa" id="dddres" value="<%= banco.getCampo("ddd_residencial", rs) %>" size="4" maxlength="2">
			  	<input name="telresidencial" onKeyPress="OnlyNumbers(this,event);" type="text" class="caixa" id="telresidencial" value="<%= banco.getCampo("tel_residencial", rs) %>" size="8" maxlength="8"></td>
              <td class="tdMedium">Tel. Celular:</td>
              <td class="tdLight">
				<input name="dddcel" onKeyPress="OnlyNumbers(this,event);" type="text" class="caixa" id="dddcel" value="<%= banco.getCampo("ddd_celular", rs) %>" size="4" maxlength="2">
			  	<input name="celular" onKeyPress="OnlyNumbers(this,event);" type="text" class="caixa" id="celular" value="<%= banco.getCampo("tel_celular", rs) %>" size="8" maxlength="8"></td>
            </tr>
            <tr>
              <td class="tdMedium">e-mail:</td>
              <td colspan="3" class="tdLight"><input name="email" type="text" class="caixa" id="email" value="<%= banco.getCampo("email", rs) %>" style="width:100%" maxlength="50" onBlur="validaemail(this);"></td>
            </tr>
            <tr>
 	        	<td class="tdMedium">Externo/Interno: *</td>
    	        <td class="tdLight">
			  	<select name="locacao" id="locacao" class="caixa" style="width:150px">
					<option value="externo">Externo</option>
					<option value="interno">Interno</option>
				</select>
			  </td>
        	  <td class="tdMedium">Status: *</td>
    	      <td class="tdLight">
			  	<select name="exibir" id="exibir" class="caixa" style="width:150px">
					<option value="S">Ativo</option>
					<option value="N">Inativo</option>
				</select>
			  </td>
            </tr>
            <tr>
              <td class="tdMedium">Tempo de Consulta:</td>
              <td colspan="3" class="tdLight"><input name="tempoconsulta" type="text" class="caixa" id="tempoconsulta" value="<%= banco.getCampo("tempoconsulta", rs) %>"  size="3" maxlength="3" onKeyPress="return formatar(this, event, '###'); "></td>
            </tr>
          </table>
      </td>
    </tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<%= Util.getBotoes("profissionais", pesq, tipo) %>
	<tr>
		<td>&nbsp;</td>
	</tr>
    <tr>
		<td width="100%" style="text-align:center">
			<table width="600px">
				<tr>
					<td width="29%" class="tdDark"><a title="Ordenar por Registrro" href="Javascript:ordenar('profissionais','reg_prof')">Registro</a></td>
					<td width="71%" class="tdDark"><a title="Ordenar por Nome" href="Javascript:ordenar('profissionais','nome')">Nome</a></td>
				</tr>
			</table>
			<div style="width:600; height:101; overflow: auto">
				<table width="100%">
				    <%
						String resp[] = profissional.getProfissionais(pesq, "nome", ordem, numPag, 50, tipo, cod_empresa);
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
