<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.Modelos" id="modelo" scope="page"/>

<%
	if(strcod != null) rs = banco.getRegistro("modelos","cod_modelo", Integer.parseInt(strcod) );
	if(ordem == null) ordem = "descricao";
	String jsTexto = Util.freeRTE_Preload(banco.getCampo("modelo", rs));

%>

<html>
<head>
<title>Cadastro de Modelos de Textos</title>
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
<script src="js/richtext.js" type="text/javascript" language="javascript"></script>
<script src="js/config.js" type="text/javascript" language="javascript"></script>

<script language="JavaScript">
     //id
     var idReg = "<%= strcod%>";
	 //Informação vinda de gravar
	 var inf = "<%= inf%>";
	 //Nome dos campos
	 var nome_campos_obrigatorios = Array("Nome do Modelo", "Tipo de Modelo");
	 //Página a enviar o formulário
	 var page = "gravarmodelo.jsp";
	 //Cod. da ajuda
	 cod_ajuda = 17;

     //Campos obrigatórios
	 var campos_obrigatorios = Array("descricao", "tipomodelo");

	function iniciar() {
		barrasessao();
		inicio();
		cbeGetElementById("tipomodelo").value = "<%= banco.getCampo("tipomodelo", rs) %>";
	}

	function insereItem() {
		var obj = cbeGetElementById("tipocampo");
		var jsitem = obj[obj.selectedIndex].value;
		rteInsertHTML(jsitem);
	}
	
	function gravar() {
		cbeGetElementById("texto").value = document.getElementById(rteName).contentWindow.document.body.innerHTML;
		enviarAcao('inc');
	}
	
	function clickBotaoNovo() {
		self.location='modelos.jsp';
	}
	
	function clickBotaoSalvar() {
		gravar();
	}
	
	function clickBotaoExcluir() {
		enviarAcao('exc');
	}	
</script>
</head>

<body onLoad="iniciar()">
<%@include file="barrasessao.jsp" %>
<form name="frmcadastrar" id="frmcadastrar" action="gravarmodelo.jsp" method="post">
  <table width="600" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr>
      <td width="651" height="18" class="title">.: Cadastro de Modelos de Textos :.</td>
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
	              <td width="150" class="tdMedium">Nome do modelo: * </td>
    	          <td width="450" class="tdLight"><input name="descricao" type="text" class="caixa" id="descricao" value="<%= banco.getCampo("descricao", rs) %>" maxlength="30" size="30"></td>
            </tr>
            <tr>
              <td class="tdMedium">Campos Disponíveis: </td>
              <td class="tdLight"> 
				  <select name="tipocampo" id="tipocampo" class="caixa">
					<option value="#registro_paciente#">#registro_paciente#</option>
					<option value="#nome_paciente#">#nome_paciente#</option>
					<option value="#convenio_paciente#">#convenio_paciente#</option>
					<option value="#numero_carteirinha#">#numero_carteirinha#</option>
					<option value="#nascimento_paciente#">#nascimento_paciente#</option>
					<option value="#idade_paciente#">#idade_paciente#</option>
					<option value="#endereco_paciente#">#endereco_paciente#</option>
					<option value="#numero_paciente#">#numero_paciente#</option>
					<option value="#complemento_paciente#">#complemento_paciente#</option>
					<option value="#estadocivil_paciente#">#estadocivil_paciente#</option>
					<option value="#cidade_paciente#">#cidade_paciente#</option>
					<option value="#estado_paciente#">#estado_paciente#</option>
					<option value="#obs_paciente#">#obs_paciente#</option>
					<option value="#cartao_sus#">#cartao_sus#</option>
					<option value="#mãe_paciente#">#mãe_paciente#</option>
					<option value="#pai_paciente#">#pai_paciente#</option>
					<option value="#sexo_paciente#">#sexo_paciente#</option>
					<option value="#cor_paciente#">#cor_paciente#</option>
					<option value="#profissao_paciente#">#profissao_paciente#</option>
					<option value="#email_paciente#">#email_paciente#</option>
					<option value="#fonecomercial_paciente#">#fonecomercial_paciente#</option>
					<option value="#responsavel_paciente#">#responsavel_paciente#</option>
                    <option value="#data_cadastro#">#data_cadastro#</option>
					<option value="#indicado_por#">#indicado_por#</option>
					<option value="#bairro_paciente#">#bairro_paciente#</option>
					<option value="#cep_paciente#">#cep_paciente#</option>
					<option value="#cpf_paciente#">#cpf_paciente#</option>
					<option value="#rg_paciente#">#rg_paciente#</option>
					<option value="#religião_paciente#">#religião_paciente#</option>
					<option value="#fone_paciente#">#fone_paciente#</option>
					<option value="#celular_paciente#">#celular_paciente#</option>
					<option value="#cabeçalho#">#cabeçalho#</option>
					<option value="#rodapé#">#rodapé#</option>
					<option value="#local#">#local#</option>
					<option value="#data_atual#">#data_atual#</option>
					<option value="#profissional_atendeu#">#profissional_atendeu#</option>
					<option value="#profissional_responsavel#">#profissional_responsavel#</option>
					<option value="#registro_profissional#">#registro_profissional#</option>
					<option value="#endereco_clinica#">#endereco_clinica#</option>
					<option value="#medicamentos#">#medicamentos#</option>
				    <option value="#procedimentos#">#procedimentos#</option>
					<option value="#diagnosticos#">#diagnosticos#</option>
				  </select> 
				  <input type="button" class="botao" value="Inserir" onClick="insereItem()">
			  </td>
            </tr>
			<tr>
				<td class="tdMedium">Tipo de Modelo: *</td>
				<td class="tdLight">
					<select name="tipomodelo" id="tipomodelo" class="caixa">
						<option value="G">Geral</option>
						<option value="P">Protocolo de Atendimento</option>
						<option value="R">Receita</option>
						<option value="E">Solicitação de Exames</option>
					</select>
				</td>
			</tr>
            <tr>
   	          <td colspan="2" class="tdMedium" align="center">Modelo</td>
            </tr>
			<tr>
              <td colspan="2" class="tdLight">
			  		<input type="hidden" name="texto" id="texto" value='<%= jsTexto%>' class="caixa">
					<!-- AQUI Text Editor -->
					<script>
					initRTE('<%= jsTexto%>', 'css/example.css');
					</script>
			  </td>
			</tr>
          </table>
      </td>
    </tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<%= Util.getBotoes("modelos", pesq, tipo) %>
	<tr>
		<td>&nbsp;</td>
	</tr>
    <tr>
		<td width="100%" style="text-align:center">
			<table width="600px">
				<tr>
					<td class="tdDark">Modelos</td>
				</tr>
			</table>
			<div style="width:600; height:101; overflow: auto">
				<table width="100%">
				    <%
						String resp[] = modelo.getModelos(pesq, "descricao", ordem, numPag, 10, tipo, cod_empresa);
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
