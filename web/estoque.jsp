<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.Estoque" id="estoque" scope="page"/>
<jsp:useBean class="recursos.Vacina" id="vacina" scope="page" />

<%
	String data_entrada = "";
	String validade = "";
        boolean consulta=false;
	if(strcod != null) {
		rs = banco.getRegistro("vac_estoque","cod_estoque", Integer.parseInt(strcod) );
		data_entrada = Util.formataData(banco.getCampo("data_entrada", rs));
		validade = Util.formataData(banco.getCampo("validade", rs));
                consulta=true;
	}
	else {
		data_entrada = Util.getData();
	}
	if(Util.isNull(ordem)) ordem = "descricao";
%>

<html>
<head>
<title>Estoque</title>
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
<script language="JavaScript">
     //id
     var idReg = "<%= strcod%>";
	 //Informação vinda de gravar
	 var inf = "<%= inf%>";
	 //Nome dos campos
	 var nome_campos_obrigatorios = Array("Vacina", "Laboratório", "Origem", "Lote", "Data de Entrada", "Validade", "Qtde. Entrada", "Valor Total");
	 //Página a enviar o formulário
	 var page = "gravarestoque.jsp";
     //Campos obrigatórios
	 var campos_obrigatorios = Array("cod_vacina", "cod_laboratorio", "origem", "lote", "data_entrada", "validade", "qtde_compra", "valor");

	function iniciar() {
		cbeGetElementById("cod_vacina").value = "<%= banco.getCampo("cod_vacina", rs) %>";
		cbeGetElementById("cod_laboratorio").value = "<%= banco.getCampo("cod_laboratorio", rs) %>";
		cbeGetElementById("origem").value = "<%= banco.getCampo("origem", rs) %>";
		
		//Se for edição, bloquear qtde. em estoque
		if(idReg != "null") cbeGetElementById("qtde_compra").disabled = true;
		
		inicio();
		barrasessao();	
	}
	
	function novoEstoque() {
		botaoNovo();
		cbeGetElementById("data_entrada").value = getHoje();
		cbeGetElementById("qtde_compra").disabled = false;
	}
	
	function gravarEstoque() {
		cbeGetElementById("qtde_compra").disabled = false;
		enviarAcao('inc');
	}
	
	function clickBotaoNovo() {
		novoEstoque();
	}
	
	function clickBotaoSalvar() {
		gravarEstoque();
	}
	
	function clickBotaoExcluir() {
		enviarAcao('exc');
	}	
	
</script>
</head>

<body onLoad="iniciar()">
<%@include file="barrasessao.jsp" %>
<form name="frmcadastrar" id="frmcadastrar" action="gravarestoque.jsp" method="post">
  <!-- Campos Ocultos -->
  <input type="hidden" name="ordem" value="<%= ordem%>">
  <!-- Campos Ocultos -->
  <table width="600" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr>
      <td width="651" height="18" class="title">.: Estoque :.</td>
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
	            <td class="tdMedium" width="79">Vacina: *</td>
       	       	<td colspan="3" class="tdLight">
					<select name="cod_vacina" id="cod_vacina" class="caixa">
						<option value=""></option>
						<%= estoque.getVacinas(cod_empresa)%>
					</select>				</td>
            </tr>
            <tr>
	            <td class="tdMedium" width="79">Laboratório: *</td>
       	       	<td class="tdLight">
					<select name="cod_laboratorio" id="cod_laboratorio" class="caixa">
						<option value=""></option>
						<%= estoque.getLaboratorios(cod_empresa)%>
					</select>				</td>
                <td class="tdMedium">Origem: *</td>
			    <td class="tdLight" colspan="3">
                
                <select name="origem" id="origem" class="caixa">
                  <%= "<option value='Compra'> Compra </option>"+vacina.getTodasUnidades()%>
                </select>
                
                
                <%if(consulta){%>
                <script language="javascript">
                    var obj = document.getElementById("origem");
                    var opcoes = obj.options;
                    for(var i=0; i<opcoes.length; i++){
                        if(opcoes[i].value=="<%=rs.getString("origem")%>"){
                            obj.selectedIndex = i; break;
                        }
                    }
                </script>
                <%}%>
                
                </td>
            </tr>
            <tr>
	            <td class="tdMedium">Lote: *</td>
       	       	<td class="tdLight"><input name="lote" type="text" class="caixa" id="lote" value="<%= banco.getCampo("lote", rs) %>" size="20" maxlength="20"></td>
				<td class="tdMedium">Valor Unitário: *</td>
				<td class="tdLight" colspan="3"><input type="text" name="valor" id="valor" class="caixa" size="10"  onkeypress="Javascript:OnlyNumbers(this,event);" value="<%= banco.getCampo("valor", rs) %>"></td>
            </tr>
            <tr>
	            <td class="tdMedium">Data Entrada: *</td>
       	       	<td width="169" class="tdLight"><input name="data_entrada" type="text" class="caixa" id="data_entrada" value="<%= data_entrada %>" onKeyPress="return formatar(this, event, '##/##/####'); " size="9" maxlength="10" onBlur="ValidaData(this);ValidaFuturo(this);"></td>
	            <td width="219" class="tdMedium">Validade: *</td>
       	       	<td width="132" class="tdLight"><input name="validade" type="text" class="caixa" id="validade" value="<%= validade %>" onKeyPress="return formatar(this, event, '##/##/####'); " size="9" maxlength="10" onBlur="ValidaData(this);"></td>
            </tr>
            <tr>
	            <td class="tdMedium">Qtde. Compra: *</td>
       	       	<td class="tdLight"><input name="qtde_compra" type="text" class="caixa" id="qtde_compra" value="<%= banco.getCampo("qtde_compra", rs) %>" size="10" maxlength="10" onKeyPress="Javascript:OnlyNumbers(this,event);"></td>
	            <td class="tdMedium">Qtde. Estoque:</td>
       	       	<td class="tdLight"><%= vacina.getQuantidadeEstoque(strcod, Util.getData()) %>&nbsp;</td>
            </tr>
          </table>
      </td>
    </tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<%= Util.getBotoes("estoque", pesq, tipo) %>
	<tr>
		<td>&nbsp;</td>
	</tr>
    <tr>
		<td width="100%" style="text-align:center">
			<table width="600px">
				<tr>
					
            <td width="250" height="21" class="tdDark"><a title="Ordenar por Vacina" href="Javascript:ordenar('estoque','descricao')">Vacina</a></td>
					<td class="tdDark"><a title="Ordenar por Laboratório" href="Javascript:ordenar('estoque','laboratorio')">Laboratório</a></td>
					<td width="50" class="tdDark"><a title="Ordenar por Lote" href="Javascript:ordenar('estoque','lote')">Lote</a></td>
					<td width="80" class="tdDark"><a title="Ordenar por Validade" href="Javascript:ordenar('estoque','validade')">Validade</a></td>
					<td width="60" class="tdDark">Estoque</td>
				</tr>
			</table>
			<div style="width:600; height:101; overflow: auto">
				<table width="100%">
				    <%
						String resp[] = estoque.getEstoques(pesq, ordem, numPag, 50, tipo, cod_empresa);
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
