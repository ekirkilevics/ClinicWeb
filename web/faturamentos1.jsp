<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.Faturamento" id="faturamento" scope="page"/>
<jsp:useBean class="recursos.Paciente" id="paciente" scope="page"/>

<%
	String resp[] = {"","","",""};
	
	if(!Util.isNull(strcod)) {
		rs = banco.getRegistro("faturas","Numero", Integer.parseInt(strcod));

       //resp[0] = Nome do paciente
       //resp[1] = Data de Nascimento
	   //resp[2] = Solicitante
	   //resp[3] = Foto
	   resp = faturamento.getDados(strcod);
	}
	//Foto do paciente
	String foto = resp[3];
	
	if(ordem == null) ordem = "data_Lanca DESC";

	//Paciente
	String nomepaciente 	= "";
	String nascimento 		= "";
	String codcli 			= !Util.isNull(request.getParameter("codcli")) && Util.isNull(strcod) ? request.getParameter("codcli") : banco.getCampo("codcli", rs); 
	if(!Util.isNull(codcli)) {
		String dadospaciente[] = paciente.getDadosPaciente(codcli);
		nascimento = dadospaciente[0];
		foto = dadospaciente[1];
		nomepaciente = dadospaciente[2];
	}

	//Solicitante
	String nomesolicitante 	= !Util.isNull(request.getParameter("nomesolicitante")) && Util.isNull(strcod) ? request.getParameter("nomesolicitante") : resp[2];
	String prof_reg 		= !Util.isNull(request.getParameter("prof_reg")) && Util.isNull(strcod) ? request.getParameter("prof_reg") : banco.getCampo("prof_reg", rs);
	//Cód. do item incluído para abrir página de cheques ou cartão 
	String subitem	  		= !Util.isNull(request.getParameter("subitem")) ? request.getParameter("subitem") : ""; 
	//Valores que vem da agenda pelo atalho
	String executante		= !Util.isNull(request.getParameter("executante")) ? request.getParameter("executante") : banco.getCampo("prof_reg", rs);
	String valor			= !Util.isNull(request.getParameter("valor")) ? request.getParameter("valor") : "";
	String cod_proced		= !Util.isNull(request.getParameter("procedimento")) ? request.getParameter("procedimento") : "";
	
	String pagto	  		= !Util.isNull(request.getParameter("tipo_pagto")) ? request.getParameter("tipo_pagto") : ""; 
	String cod_plano 		= !Util.isNull(request.getParameter("cod_plano")) ? request.getParameter("cod_plano") : ""; 
	
	//Busca os Procedimentos do plano ou nada se não escolheu ainda
	String proced[] = faturamento.getProcedimentos(cod_plano);
	
	//Se escolheu edição, mostrar data do registro
	String dataCons = "";
	if(!Util.isNull(strcod))
		dataCons = Util.formataData(banco.getCampo("Data_lanca", rs)); 
	else 
		//Se está vindo da agenda, usar data da agenda
		if(!Util.isNull(request.getParameter("data")))
		 	dataCons = request.getParameter("data");
		//Se for registro novo, usar data do sistema
		else
			dataCons = Util.getData();

	String horaCons;
	if(!Util.isNull(strcod))
		horaCons = Util.formataHora(banco.getCampo("hora_lanca", rs)); 
	else 
		if(!Util.isNull(request.getParameter("hora")))
		 	horaCons = request.getParameter("hora");
		else
			horaCons = Util.getHora();

	//Se veio código de exclusão, excluir do banco de dados
	faturamento.removeFaturaItem(request.getParameter("exc"));
	
%>
<html>
<head>
<title>Faturamento</title>
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
<script language="JavaScript" src="js/ajax.js"></script>
<script language="JavaScript">
     //id do registro
     var idReg = "<%= strcod%>";
	 //Informação vinda de gravar
	 var inf = "<%= inf%>";
	 //Nome dos campos
	 var nome_campos_obrigatorios = Array("Paciente","Convênio (plano)","Executante","Data");
	 //Página a enviar o formulário
	 var page = "gravarfaturamento3.jsp";
	 //Cod. da ajuda
	 cod_ajuda = 8;

     //Campos obrigatórios
	 var campos_obrigatorios = Array("codcli","cod_plano","executante","data");
	 
	 var tipo_pagto_ret = "<%= pagto%>";

	 var vetCodProced = Array(<%= proced[0]%>);
	 var vetProced 	  = Array(<%= proced[1]%>);
	 var vetValor     = Array(<%= proced[2]%>);

	 var jsbloquearcarteiravencida = "<%= configuracao.getItemConfig("bloquearcarteiravencida", cod_empresa)%>";

	function carregarProcedimentos()
	{
		for(i=0; i < vetCodProced.length; i++)
			insereCombo("procedimento", vetCodProced[i], vetProced[i]); 
	}
	
	function mudarProcedimento(combo)
	{
		var pos = combo.selectedIndex;
		cbeGetElementById("valor").value = formatCurrency(vetValor[pos]);
	}


	 function setarCampos()
	 {
		cbeGetElementById("executante").value = "<%= executante%>";
		cbeGetElementById("cod_plano").value = "<%= cod_plano %>";
		cbeGetElementById("procedimento").value = "<%= cod_proced %>";

		//Atualiza total de procedimentos
		atualizar();
		
		//Chama as janelas de tipo de pagamento
		detalhesPagamento("<%= pagto%>", "<%= subitem %>");
		
		barrasessao();
	 }
	 
	 function submitar()
	 {
	 	var frm = cbeGetElementById("frmcadastrar");
		frm.submit();
	 }

	function bloqueiaCarteiraVencida() {
		var obj = cbeGetElementById("cod_plano");
		var opt = obj[obj.selectedIndex];	
	
		//Se estiver ativado para bloquear carteira vencida
		if(jsbloquearcarteiravencida == "S") {
			//Se estiver vencida a carteira e não for particular
			if(opt.value != "-1" && opt.style.color == "red") {
				alert("Carteira do paciente vencida.")
				return true;
			}
		}
		
		return false;
	}
	 
	 function excluirProcedimento(cod)
	 {
	 	var frm = cbeGetElementById("frmcadastrar");
		conf = confirm("Confirma exclusão desse procedimento?");
		if(!conf) return;
		frm.action += "&exc=" + cod;
		frm.submit();
	 }
	 
	 function inserirProcedimento()
	 {
	 	var frm = cbeGetElementById("frmcadastrar");
	    var vproced = frm.procedimento;	
	    var vqtde = frm.qtde;	
		var vvalor = frm.valor;
		
		if(vproced.value == "") {
			alert("Procedimento não pode estar vazio para a inserção do item");
			vproced.focus();
			return;
		}
		
		if(vqtde.value == "" || parseFloat(vqtde.value) <=0) {
			alert("Quantidade deve ser positiva");
			vqtde.focus();
			return;
		}
		
		if(vvalor.value == "") {
			alert("Valor deve ser positivo")
			vvalor.focus();
			return;
		}
		
		gravar();

	 }

	 function toMoney(valor)
	 {
	 	resp = valor.replace(",",".");
		return resp;	
	 }
	 
	 function atualizar()
	 {
	 	var vqtde = getObj("","qtde").value;
		var vvalor = getObj("","valor").value.replace(".","");
		vvalor = vvalor.replace(",",".");
		var vsubtotal = cbeGetElementById("subtotal").value;
		var vtotal = cbeGetElementById("total");
		var vtotalgeral = cbeGetElementById("totalgeral");

		vtotal.value = formatCurrency(vqtde * vvalor);
		var subtotal = (vqtde * vvalor) + parseFloat(vsubtotal);
		vtotalgeral.innerHTML = formatCurrency(subtotal);

		//Preenche campo hidden para gravar total
		cbeGetElementById("valortotal").value = subtotal;
		
		//Se for mais de um item, colocar como default via de acesso D
		if(vqtde != "1") {
			cbeGetElementById("viaAcesso").value = "D";
		}
	 }
	 
	 function novoLocal() {
		window.location = 'faturamentos.jsp';
	 }

	function detalhesPagamento(tipo_pagto, cod_subitem) {

		//Verifica tipo de pagamento para cadastro de cheques ou cartão
		 if(tipo_pagto == "2") {// Cheque
			barrasessao();
			displayPopup("cheques.jsp?cod=" + cod_subitem ,"popup",450,450);
		}
		else if(tipo_pagto == "3") {// Cartão
			barrasessao();
 		    displayPopup("cartao.jsp?cod=" + cod_subitem ,"cartao",250,450);
		}
	}	 

	function fichaatendimento(_codcli, _paciente, _data, _nascimento, _codfatura)
	{
		window.location = "relfichas.jsp?codcli=" + _codcli + "&paciente=" + _paciente + "&dataexame=" + _data + "&nascimento=" + _nascimento + "&codfatura=" + _codfatura;
	}
	
	function limparRegistro() {
		if(idReg != "null") novoLocal();
	}
	
	//Sobrescrendo a função do AJAX
	function setar(chave, campo, valorchave, valorcampo) {
		cbeGetElementById(chave).value = valorchave;
		cbeGetElementById(campo).value = valorcampo;
		x.innerHTML = "";
		hide();
		
		//Só atualiza se for paciente
		if(chave == "codcli") cbeGetElementById("frmcadastrar").submit();
	}
	
	//a função do AJAX
	function setarprocedimento(cod_proced, proced, valor) {
		cbeGetElementById("COD_PROCED").value = cod_proced;
		cbeGetElementById("Procedimento").value = proced;
		cbeGetElementById("valor").value = valor;
		atualizar();
		x.innerHTML = "";
		hide();
	}
	
	function gravar() {
		//Se não bloquear a carteira, gravar
		if(!bloqueiaCarteiraVencida())
			enviarAcao('inc');
	}
	
	function iniciar() {
		inicio();

		//Carrega a combo de procedimentos
		carregarProcedimentos();
		
		//formata valor
		var jsvalor = cbeGetElementById("valor");
		if(jsvalor.value != "")
			jsvalor.value = formatCurrency(jsvalor.value);			

		setarCampos();
		
	}
	
	function gerarGuia(codFatura) {
		
			window.open('gerarguia.jsp?cod=' + idReg,'popuptiss','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,width=750,height=500,top=100,left=100');
	}	
	
	function clickBotaoNovo() {
		novoLocal();
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
<%@include file="barraajax.jsp" %>
<form name="frmcadastrar" id="frmcadastrar" action="faturamentos1.jsp?cod=<%= strcod%>" method="post">
  <table width="600" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr>
      <td height="18" class="title">.: Lançar Procedimentos :.</td>
    </tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
    <tr align="center" valign="top">	<tr style="height:25px">
		<td align="right"><span name='msg' id='msg' class="msg">&nbsp;</span></td>
	</tr>

      <td>
         <table width="600" border="0" cellpadding="0" cellspacing="0" class="table">
          <tr>
              <td class="tdMedium"><a href="Javascript:pesquisapornascimento(2)" title="Pesquisa por nome">Paciente:</a>&nbsp;<a href="Javascript:pesquisapornascimento(1)" title="Pesquisa por data de nascimento"><img src="images/calendar.gif" border="0"></a></td>
              <td colspan="3" class="tdLight">
					<input type="hidden" name="codcli" id="codcli" value="<%= codcli %>">			
					<input style="width:100%" class="caixa" type="text" name="nome" id="nome" onKeyUp="busca(this.value, 'codcli', 'nome','paciente')" value="<%= nomepaciente%>">
					<input size="10" class="caixa" type="text" name="pesqnascimento" id="pesqnascimento" onKeyPress="buscanascimento(this.value, event); return formatar(this, event, '##/##/####');" style="display: none">
			  </td>
			<td rowspan="3" class="tdLight">
			<% 
				if(Util.isNull(foto)) {
					out.println("<img src='images/photo.gif' border='0'>");
				}
				else {
					out.println("<a id='foto' name='foto' href=\"Javascript: mostraImagem('upload/" + foto + "')\"><img src='upload/" + foto + "' border=0 width=40 height=40></a>");
				}
			%>
			</td>
            </tr>
			<tr>
				<td class="tdMedium">Convênio (Plano):</td>
				<td class="tdLight" width="200">
					<select name="cod_plano" id="cod_plano" class="caixa" style="width:220px" onChange="submitar()">
						<option value=""><-- Selecione o plano --></option>
						<%= paciente.getConveniosPlanos(codcli)%>
					</select>
				</td>
				<td class="tdMedium">Nascimento:</td>
				<td class="tdLight">
					<input size="10" type="text" class="caixa" name="nascimento" id="nascimento" value="<%= nascimento%>" onKeyPress="return false;" >
					<input type="hidden" name="idade" id="idade">
				</td>
			</tr>
            <tr>
              <td class="tdMedium">Executante:</td>
              <td colspan="3" class="tdLight">
			  	<select name="executante" id="executante" class="caixa" style="width: 400px">
					<option value=""></option>
					<%= faturamento.getProfissionais(cod_empresa) %>
				</select>
			  </td>
			</tr>
			<tr>
			  <td class="tdMedium">Data:</td>
			  <td class="tdLight"><input type="text" onKeyPress="return formatar(this, event, '##/##/####'); " class="caixa" size="10" name="data" id="data" maxlength="10" value="<%= dataCons%>" onBlur="ValidaData(this)"></td>
			  <td class="tdMedium">Hora:</td>
			  <td class="tdLight"><input type="text" onKeyPress="return formatar(this, event, '##:##'); " class="caixa" size="6" name="hora" id="hora" maxlength="5" value="<%= horaCons%>" onBlur="ValidaHora(this);"></td>
			  <td class="tdMedium" style="padding:0px">
			  	<%
					if(!Util.isNull(strcod))
						out.println("<a title='Imprimir Guia do TISS' href=\"Javascript:gerarGuia(" + strcod + ")\"><img src='images/tiss.jpg' width='60' border='0'></a>");
					else
						out.println("&nbsp;");
				%>
			  </td>
            </tr>
            <tr>
              <td class="tdMedium">Solicitante:</td>
              <td colspan="4" class="tdLight">
					<input type="hidden" name="prof_reg" id="prof_reg" value="<%= prof_reg %>">			
					<input style="width:100%" class="caixa" type="text" name="profissional.nome" id="profissional.nome" onKeyUp="busca(this.value, 'prof_reg', 'profissional.nome','profissional')" value="<%= nomesolicitante%>">
			  </td>
            </tr>
			<tr>
				<td colspan="5" width="100%">
					<table width='100%' border='0' cellpadding='0' cellspacing='0'>
						<tr>
							<td class='tdMedium'>Procedimento</td>
							<td class='tdMedium'>Acesso</td>
							<td class='tdMedium'>qtde</td>
							<td class='tdMedium'>Valor</td>
							<td class='tdMedium'>Total</td>
							<td class='tdMedium'>Tipo de Pagto</td>
							<td class='tdMedium'>Ação</td>
                            <td class='tdMedium'>Ficha</td>
						</tr>
						<tr>
							<td class='tdLight'>
								<select name="procedimento" id="procedimento" class="caixa" style="width:150px" onChange="mudarProcedimento(this); atualizar();">
									
								</select>
							</td>
							<td class='tdLight'>
								<select name="viaAcesso" id="viaAcesso" class="caixa">
									<option value="U">U</option>
									<option value="D">D</option>
									<option value="M">M</option>
								</select>
							</td>
							<td class='tdLight'><input name="qtde" id="qtde" type="text" size="2" class="caixa" onBlur="atualizar()" value="1"></td>
							<td class='tdLight'><input name="valor" id="valor" type="text" size="6" class="caixa" onBlur="atualizar()" value="<%= valor%>"></td>
							<td class='tdLight'><input type="text" name="total" id="total" class="caixa" size="6" onKeyPress="return false"></td>
							<td class='tdLight'>
								<select name="pagto" id="pagto" class="caixa">
									<option value="4">Convênio</option>
									<option value="1">Dinheiro</option>
									<option value="2">Cheque</option>
									<option value="3">Cartão</option>
								</select>
							</td>
							<td class='tdLight' align="center"><a title="Adicionar Registro" href="Javascript:inserirProcedimento();"><img src="images/add.gif" border="0"></a></td>
                            <td class="tdLight">&nbsp;</td>
						</tr>
							<%= faturamento.getItensFatura1(strcod) %>
						<tr>
							<td colspan='4' class='tdMedium' style='text-align:right'>Total=></td>
							<td colspan="4" class='tdMedium'>
								R$ <span id='totalgeral'>&nbsp;</span>
								<input type="hidden" name="valortotal" id="valortotal">
							</td>
						</tr>
					</table>
				</td>
			</tr>
          </table>
      </td>
    </tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<%= Util.getBotoes("faturamentos1", pesq, tipo) %>
	<tr>
		<td>&nbsp;</td>
	</tr>
    <tr>
		<td width="100%" align="center">
			<table width="600px">
				<tr>
					<td class="tdDark"><a title="Ordenar por Paciente" href="Javascript:ordenar('faturamentos1','paciente.nome')">Paciente</a></td>
					<td width="115" class="tdDark"><a title="Ordenar por Executante" href="Javascript:ordenar('faturamentos1','Executante.nome')">Executante</a></td>
					<td width="112" class="tdDark"><a title="Ordenar por Solicitante" href="Javascript:ordenar('faturamentos1','Solicitante.nome')">Solicitante</a></td>
					<td width="65" class="tdDark"><a title="Ordenar por Data Decrescente" href="Javascript:ordenar('faturamentos1','data_Lanca DESC')">Data</a></td>
					<td width="77" class="tdDark">Valor</td>
				</tr>
			</table>
			<div style="width:600; height:101; overflow: auto">
				<table width="100%">
				    <%
						String faturas[] = faturamento.getFaturamento(pesq, "paciente.nome", ordem, numPag, 50, tipo, cod_empresa, paginaatual);
						out.println(faturas[0]);
					%>
				</table>
			</div>
			<table width="600px">
				<tr>
					<td colspan="2" class="tdMedium" style="text-align:right"><%= faturas[1]%></td>
				</tr>
			</table>
		</td>
	</tr>
  </table>
</form>

</body>
</html>
