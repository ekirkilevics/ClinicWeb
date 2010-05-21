<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.Valor" id="valor" scope="page"/>

<%
	String nomeconvenio = "";
	if(strcod != null) {
		rs = banco.getRegistro("valorprocedimentos","cod_valorprocedimento", Integer.parseInt(strcod) );
		nomeconvenio = banco.getValor("descr_convenio", "SELECT descr_convenio FROM convenio WHERE cod_convenio=" + banco.getCampo("cod_convenio", rs));
	}
	if(ordem == null) ordem = "Procedimento";
	
	if(!Util.isNull(request.getParameter("nomeconvenio")))
		nomeconvenio = request.getParameter("nomeconvenio");
		
	String convenio_pesq = request.getParameter("convenio_pesq");
%>

<html>
<head>
<title>Valores</title>
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
	 var nome_campos_obrigatorios = Array("Procedimento","Convênio", "Tabela", "Valor");
	 //Página a enviar o formulário
	 var page = "gravarvaloresprocedimentos.jsp";
	 //Cod. da ajuda
	 cod_ajuda = 16;

     //Campos obrigatórios
	 var campos_obrigatorios = Array("procedimento","cod_convenio", "cod_tabela", "valor");

	function setarValores()
	{
		getObj("","procedimento").value = "<%= banco.getCampo("cod_proced", rs)%>";
		getObj("","cod_tabela").value = "<%= banco.getCampo("cod_tabela", rs)%>";
	}	 
	
	function iniciar() {
		inicio();
		setarValores();
		barrasessao();
	}

	//Sobrescrendo a função do AJAX
	function setar(chave, campo, valorchave, valorcampo) {
		cbeGetElementById(campo).value = valorcampo;
		cbeGetElementById(chave).value = valorchave;
		x.innerHTML = "";
		hide();

		buscaplanosconvenio(valorchave, "2");
		cbeGetElementById("planos").innerHTML = "";	
		
		return;
	}
	
	function salvarValor() {
		var jsplanos = cbeGetElementById("planos");
		
		if(jsplanos.length == 0) {
			mensagem("Escolha os planos para lançar o valor", 2);
			return;
		}	
		enviarAcao('inc');
	}
	
	function insereplano() {
		var combo = cbeGetElementById("cod_plano");
		
		for(i=0; i<combo.length; i++) {
			//Se estiver selecionado
			if( combo.options[i].selected == true ) {
				//Se não for a opção de Não Identificado
				if(combo.options[i].value != "-1") {
					insereCombo("planos", combo.options[i].value, combo.options[i].text);				
				}
			}
		}
	}
	
	function removeplano() {
		var combo = cbeGetElementById("planos");
		if(combo.selectedIndex >= 0) {
			combo.remove(combo.selectedIndex);
		}
	
	}

	function clickBotaoNovo() {
		botaoNovo();
	}
	
	function clickBotaoSalvar() {
		salvarValor();
	}
	
	function clickBotaoExcluir() {
		enviarAcao('exc');
	}
</script>
</head>

<body onLoad="iniciar()">
<%@include file="barrasessao.jsp" %>
<%@include file="barraajax.jsp" %>
<form name="frmcadastrar" id="frmcadastrar" action="gravarvaloresprocedimentos.jsp" method="post">
  <!-- Campos Ocultos -->
  <input type="hidden" name="ordem" value="<%= ordem%>">
  <!-- Campos Ocultos -->
  <table width="600" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr>
      <td height="18" class="title">.: Valores :.</td>
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
              <td width="150" class="tdMedium">Procedimento: *</td>
              <td colspan="3" class="tdLight">
			  		<select name="procedimento" id="procedimento" class="caixa" style="width:100%">
						<option value=""></option>
						<%= valor.getProcedimentos( cod_empresa ) %>
					</select>
			  </td>
            </tr>
            <tr>
	          <td class="tdMedium">Conv&ecirc;nio: *</td>
              <td colspan="3" class="tdLight">
					<input type="hidden" name="cod_convenio" id="cod_convenio" value="<%= banco.getCampo("cod_convenio", rs) %>">			
					<input style="width:100%" class="caixa" type="text" name="descr_convenio" id="descr_convenio" onKeyUp="busca(this.value, 'cod_convenio', 'descr_convenio','convenio','AND ativo=\'S\'')" value="<%= nomeconvenio%>">
			  </td>
            </tr>
            <tr>
              <td width="150" class="tdMedium">Tabela: *</td>
              <td colspan="3" class="tdLight">
			  		<select name="cod_tabela" id="cod_tabela" class="caixa" style="width:100%">
						<option value=""></option>
						<%= valor.getTabelas( cod_empresa ) %>
					</select>
			  </td>
            </tr>
			<tr>
				<td class="tdMedium">Plano: *</td>
				<td class="tdLight">
					<div id="listaplanos">
						<%= valor.getPlanos(banco.getCampo("cod_convenio", rs),"2") %>
					</div>
				</td>
				<td class="tdLight" align="center">
                    <a href="Javascript:insereplano()" title="Insere Plano"><img src="images/seta_dir.gif" border="0"></a><br><br>
                    <a href="Javascript:removeplano()" title="Remove Plano"><img src="images/seta_esq.gif" border="0"></a><br>
				</td>
				<td class="tdLight">
					<select name="planos" id="planos" class="caixa" style="width:170px; height:100px" multiple>
						<%= valor.getPlano(strcod)%>
					</select>
				</td>
			</tr>
            <tr>
	          <td class="tdMedium">Valor: *</td>
              <td colspan="3" class="tdLight"><input onKeyPress="return somenteNumeros(event)" name="valor" type="text" class="caixa" id="valor" value="<%= banco.getCampo("valor", rs) %>" size="30" maxlength="10"> Ex.: 34.57</td>
            </tr>
          </table>
      </td>
    </tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
        <tr align='center' valign='top'>
         <td width='100%'>
          <table width='100%' border='0' cellpadding='0' cellspacing='0' class='table'>
           <tr>
            <td class='tdMedium' style='text-align:center'>
                <button type='button' name='novo' id='novo' class='botao' style='width:70px' onClick='clickBotaoNovo()'><img src='images/16.gif' height='17'>&nbsp;&nbsp;&nbsp;&nbsp;Novo</button>
            </td>
            <td class='tdMedium' style='text-align:center'>
                <button type='button' name='salvar' id='salvar' class='botao' style='width:70px' onClick='clickBotaoSalvar()'><img src='images/gravamini.gif' height='17'>&nbsp;&nbsp;&nbsp;&nbsp;Salvar</button>
            </td>
            <td class='tdMedium' style='text-align:center'>
                   <button type='button' name='exclui' id='exclui' class='botao' style='width:70px' onClick='clickBotaoExcluir()'><img src='images/delete.gif' width='13' height='17'>&nbsp;&nbsp;&nbsp;&nbsp;Excluir</button>
             </td>
             <td class='tdMedium' style='text-align:left'>
            	   <input type='text' name='pesq' id='pesq' class='caixa' value='<%= pesq %>' style='width:70px' onKeyPress="buscarEnter(event, 'valoresprocedimentos');">&nbsp;
                   <select name="convenio_pesq" id="convenio_pesq" class="caixa" style="width:70px">
                   		<option value="">Convênio</option>
						<%= valor.getConvenios(convenio_pesq)%>
                   </select>
                   <select name='tipo' id='tipo' class='caixa'>
                <option value='1' <%= banco.getSel(tipo, 1) %>>Exata</option>
                <option value='2' <%= banco.getSel(tipo, 2) %>>Início</option>
                <option value='3' <%= banco.getSel(tipo, 3) %>>Meio</option>
                </select>
                <button type='button' class='botao' style='width:80px' onClick="buscar('valoresprocedimentos');">
               <img src='images/busca.gif' height='17'>&nbsp;Consultar</button>
              </td>
           </tr>
          </table>
         </td>
        </tr>
             
	<tr>
		<td>&nbsp;</td>
	</tr>
    <tr>
		<td width="100%" style="text-align:center">
			<table width="600px">
				<tr>
					<td width="30%" class="tdDark"><a title="Ordenar por Procedimento" href="Javascript:ordenar('valoresprocedimentos','Procedimento')">Procedimento</a></td>
					<td width="30%" class="tdDark"><a title="Ordenar por Convênio" href="Javascript:ordenar('valoresprocedimentos','descr_convenio')">Convênio</a></td>					
					<td width="20%" class="tdDark"><a title="Ordenar por Plano" href="Javascript:ordenar('valoresprocedimentos','plano')">Plano</a></td>					
					<td class="tdDark"><a title="Ordenar por Valor" href="Javascript:ordenar('valoresprocedimentos','VALOR')">Valor</a></td>
				</tr>
			</table>
			<div style="width:600; height:101; overflow: auto">
				<table width="100%">
				    <%
						String resp[] = valor.getValores(pesq,  convenio_pesq, ordem, numPag, 50, tipo, cod_empresa);
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
