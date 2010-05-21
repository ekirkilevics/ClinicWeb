
<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.Vacina" id="vacina" scope="page"/>

<%
	String data 	= "";
	String qtde 	= "";
        boolean consulta=false;
	
	if(strcod != null) {
		rs = banco.getRegistro("vac_saidas","cod_saida", Integer.parseInt(strcod) );
		data = Util.formataData(banco.getCampo("data", rs));
		qtde = banco.getCampo("qtde", rs);
                //desabilita os campos
                consulta=true;
	}
	else {
		data = Util.getData();
	}


	if(Util.isNull(ordem)) ordem = "tipo_saida";
%>

<html>
<head>
<title>Histórico de Vacinas</title>
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
	 var nome_campos_obrigatorios = Array( "Data da aplicação",  "Qtde", "Vacina", "Saída", "Lote");
	 //Página a enviar o formulário
	 var page = "gravaremprestimovacinas.jsp";
     //Campos obrigatórios
	 var campos_obrigatorios = Array("data",  "qtde", "cod_vacina","tipo_saida", "lote");

	 var xmlHttp, xmlHttp2, xmlHttp3;
	 
	function iniciar() {
		
		inicio();
		barrasessao();
	}

	function buscaLotesVacina(cod_vacina) { 
			
			//Busca as doses dessa vacina
			buscaDosesVacina(cod_vacina);
			
			//Página que vai buscar os dados
			var url = "carregalotesvacina.jsp?cod_vacina=" + cod_vacina;

			//Se for IE
			if (window.ActiveXObject) {
					xmlHttp = new ActiveXObject('Microsoft.XMLHTTP');
			}
			//Se for NETSCAPE
			else if (window.XMLHttpRequest) {
					xmlHttp = new XMLHttpRequest();
			}
			xmlHttp.open('GET', url, true);
			xmlHttp.onreadystatechange = carregacombolotes;
			xmlHttp.send(null);
	}
	
	function carregacombolotes() {
		if (xmlHttp.readyState == 4) {
			if (xmlHttp.status == 200) {
				xmlDoc = xmlHttp.responseText;
				cbeGetElementById("divlote").innerHTML = xmlDoc;
				<%=(consulta)?"document.getElementById('lote').disabled=true;":""%>
			}
		 }
	}

	
	function novaHistVacina() {
		window.location = "emprestimovacinas.jsp";
	}
	
	function gravarVacina() {
		var jsqtdemax = cbeGetElementById("lote")[cbeGetElementById("lote").selectedIndex].text;
		var jsqtde = parseInt(cbeGetElementById("qtde").value);

		pos1 = jsqtdemax.indexOf('(');
		pos2 = jsqtdemax.indexOf(')');
		jsqtdemax = parseInt(jsqtdemax.substring(pos1+1, pos2));
		
		//Se quer gravar qtde maior do que a de estoque, bloquear
		if(jsqtde > jsqtdemax) {
			alert("Quantidade em estoque insuficiente. Valor máximo é " + jsqtdemax + ".");
		}
		else {
			enviarAcao('inc');
		}
	}
	
	function excluirvacina() {
                //alert("entrou");
		document.getElementById("qtde").disabled=false;
		document.getElementById("lote").disabled=false;
		enviarAcao('exc');
	}

	//Sobrescrendo a função do AJAX
	function setar(chave, campo, valorchave, valorcampo) {
		cbeGetElementById(chave).value = valorchave;
		cbeGetElementById(campo).value = valorcampo;
		x.innerHTML = "";
		hide();
		
		cbeGetElementById("frmcadastrar").action = "emprestimovacinas.jsp";
		cbeGetElementById("frmcadastrar").submit();
	}

        function buscaDosesVacina(cod_vacina) { 
	
			//Página que vai buscar os dados
			var url = "carregadosesvacina.jsp?cod_vacina=" + cod_vacina;

			//Se for IE
			if (window.ActiveXObject) {
					xmlHttp3 = new ActiveXObject('Microsoft.XMLHTTP');
			}
			//Se for NETSCAPE
			else if (window.XMLHttpRequest) {
					xmlHttp3 = new XMLHttpRequest();
			}
			xmlHttp3.open('GET', url, true);
			xmlHttp3.onreadystatechange = carregalotes;
			xmlHttp3.send(null);
	}
         
         function carregalotes() {
		if (xmlHttp3.readyState == 4) {
			if (xmlHttp3.status == 200) {
				xmlDoc = xmlHttp3.responseText;
				<%=(consulta)?"document.getElementById('lote').disabled=true;":""%>
			}
		 }
	}
	
	function clickBotaoNovo() {
		novaHistVacina();
	}
	
	function clickBotaoSalvar() {
		if(idReg == "null") gravarVacina();
	}
	
	function clickBotaoExcluir() {
		excluirvacina();
	}	
</script>
</head>

<body onLoad="iniciar()">
<%@include file="barrasessao.jsp" %>
<form name="frmcadastrar" id="frmcadastrar" action="gravaremprestimovacinas.jsp" method="post">
  <!-- Campos Ocultos -->
  <input type="hidden" name="ordem" value="<%= ordem%>">
  <!-- Campos Ocultos -->
  <table width="600" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr>
      <td width="651" height="18" class="title">.: Saída de Vacinas :.</td>
    </tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr style="height:25px">
	   <td class="texto"> Os campos com asterisco s&atilde;o de preenchimento  obrigat&oacute;rio !</td>
	</tr>
	<tr>
		<td align="right"><span name='msg' id='msg' class="msg">&nbsp;</span></td>
	</tr>
    <tr align="center" valign="top">
      <td>
          <table width="100%" border="0" cellpadding="0" cellspacing="0" class="table">
			<tr>
				<td class="tdMedium">Saída: *</td>
				<td colspan="4" class="tdLight" nowrap>
                                     <select name="tipo_saida" id="tipo_saida" class="caixa" <%=(consulta)? "disabled":""%>>
                  <%= (consulta)? 
                      "<option value='"+rs.getString("tipo_saida")+"'> "+rs.getString("tipo_saida")+" </option>\n":
                      vacina.getTodasUnidades()+"<option value='Doses Perdidas'> Doses Perdidas </option>"%>
                </select></td>
			</tr>
            <tr>
	            <td class="tdMedium" width="100">Vacina: *</td>
       	       	<td colspan="4" class="tdLight">
					<select name="cod_vacina" id="cod_vacina" class="caixa"  <%=(consulta)?"disabled":"onChange=\"buscaLotesVacina(this.value);\" "%>>
                  <%= (consulta)? 
                      vacina.getNomeVacina(rs.getString("cod_vacina")):
                      "<option value=\"\"></option>"+vacina.getVacinas(cod_empresa)%>
					</select>				</td>
            </tr>
            <tr>
	            <td class="tdMedium">Lote: *</td>
       	       	<td colspan="4" class="tdLight">
					<div id="divlote">
					<%
						if(!consulta && !Util.isNull(strcod)) //Se escolheu o item, imprimir combo da vacina
							out.println(vacina.getLotesVacina(banco.getCampo("cod_vacina", rs)));
						else //Se não escolheu o item, imprimir combo vazia
							out.println(vacina.getLotesVacina(strcod, consulta)); 
					%>
					</div>				
				</td>
            </tr>
            <tr>
	            <td class="tdMedium">Data: *</td>
       	       	<td class="tdLight"><input name="data" type="text" class="caixa" id="data" value="<%= data %>" onKeyPress="return formatar(this, event, '##/##/####'); " size="9" maxlength="10" onBlur="ValidaData(this);ValidaFuturo(this);"  <%=(consulta)? "disabled":""%>></td>
	            <td class="tdMedium">Quantidade: *</td>
       	       	<td colspan="2" class="tdLight"><input name="qtde" type="text" class="caixa" id="qtde" value="<%= qtde %>" size="5" maxlength="5" onKeyPress="return OnlyNumbers(this,event);"></td>
            </tr>
          </table>
      </td>
    </tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<%= Util.getBotoes("emprestimovacinas", pesq, tipo) %>
	<tr>
		<td>&nbsp;</td>
	</tr>
    <tr>
		<td width="100%" style="text-align:center">
			<table width="600px">
				<tr>
					<td class="tdDark"><a title="Ordenar por Saida" href="Javascript:ordenar('emprestimovacinas','tipo_saida')">Sa&iacute;da</a></td>
					<td width="250" class="tdDark"><a title="Ordenar por Vacina" href="Javascript:ordenar('emprestimovacinas','descricao6')">Vacina</a></td>
					<td width="80" class="tdDark"><a title="Ordenar por Data" href="Javascript:ordenar('emprestimovacinas','data')">Data</a></td>
				</tr>
			</table>
			<div style="width:600; height:101; overflow: auto">
				<table width="100%">
				    <%
						String resp[] = vacina.getSaidaVacinas(pesq, ordem, numPag, 50, tipo, cod_empresa);
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
