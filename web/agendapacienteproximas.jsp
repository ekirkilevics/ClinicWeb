<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.AgendadoMedico" id="agenda" scope="page"/>
<jsp:useBean class="recursos.Paciente" id="paciente" scope="page"/>

<%
	//Se receber parâmetros, usá-los, senão, considerar vazio
	String codcli   = request.getParameter("codcli") != null ? request.getParameter("codcli") : "";
	String nomepaciente = request.getParameter("nome") != null ? request.getParameter("nome") : "";
	String cod_plano = request.getParameter("cod_plano") != null ? request.getParameter("cod_plano") : "-1";
	String prof_reg = request.getParameter("prof_reg") != null ? request.getParameter("prof_reg") : "";
	String procedimento = request.getParameter("procedimento");
	String nascimento = "", foto = "";	
	int mes, ano;

	//Se escolheu o paciente, capturar os dados
	if(!codcli.equals("")) {
		String dadospaciente[] = paciente.getDadosPaciente(codcli);
		nascimento = dadospaciente[0];
		foto = dadospaciente[1];
	}

%>

<html>
<head>
<title>Agenda</title>
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
<script language="JavaScript" src="js/ajax.js"></script>
<script language="JavaScript">
     //id
     var idReg= "<%= strcod%>";
	 //Informação vinda de gravar
	 var inf = "<%= inf%>";
	 //Nome dos campos
	 var nome_campos_obrigatorios = Array();
	 //Página a enviar o formulário
	 var page = "#";
	 //Cod. da ajuda
	 cod_ajuda = 14;

     //Campos obrigatórios
	 var campos_obrigatorios = Array();
	 
	 var codcli = "<%= codcli%>";

	 function iniciar() {
	 	barrasessao();
		cbeGetElementById("nome").focus();
		var jsnasc = "<%= nascimento%>";
		if(jsnasc != "") {
			cbeGetElementById("idade").value = getIdade(jsnasc);
		}
		cbeGetElementById("procedimento").value = "<%= procedimento%>";
		cbeGetElementById("prof_reg").value = "<%= prof_reg%>";
	 }
	 
	//Sobrescrendo a função do AJAX
	function setar(chave, campo, valorchave, valorcampo) {
		cbeGetElementById(chave).value = valorchave;
		cbeGetElementById(campo).value = valorcampo;
		x.innerHTML = "";
		hide();
		
		if(campo=="nome") {
			cbeGetElementById("frmcadastrar").action = "agendapacienteproximas.jsp";
			cbeGetElementById("frmcadastrar").target = "_self";
			cbeGetElementById("frmcadastrar").submit();
		}
	}
	
	function limparRegistro() {
		//Se já está escolhido paciente, apagar e começar novamente
		if(codcli != "") self.location = "agendapaciente.jsp";
	}	
	
	function proximasagendas() {
		 var proced = getObj("","procedimento").value;
		 var codpaci = getObj("","codcli").value;
		 var codplano = getObj("","cod_plano").value;
		 var frm = cbeGetElementById("frmcadastrar");
		 frm.action = "proximasagendas.jsp?abriu=yes&codcli=" + codpaci + "&cod_proced=" + proced + "&cod_plano=" + codplano;
		 frm.target = "iframeproximasagendas";
		 frm.submit();

		 barrasessao();
	}

	 function detalheAgenda()
	 {
		 var proced = getObj("","procedimento").value;
		 var jsprof_reg = getObj("", "prof_reg").value;
		 var d = "<%= Util.getDia(Util.getData())%>";
		 var m = "<%= Util.getMes(Util.getData())%>";
		 var a = "<%= Util.getAno(Util.getData())%>";
		
		 if(proced == "") {
		 	alert("Escolha o procedimento para visualizar a agenda");
			getObj("","procedimento").focus();
			return;
		 }

		 barrasessao();
		 eval("janela = window.open('detalheagenda.jsp?dia=" + d + "&mes=" + m + "&ano=" + a + "&cod_proced=" + proced + "&prof_reg=" + jsprof_reg + "','popup"+d+m+a+"','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,menubar=no,width=500,height=540,top=5,left=10');")
	 }
	

</script>
</head>

<body onLoad="iniciar();">
<%@include file="barrasessao.jsp" %>
<%@include file="barraajax.jsp" %>
<form name="frmcadastrar" id="frmcadastrar" action="agendapaciente.jsp" method="post">

  <table width="600" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr>
      <td width="100%" height="18" class="title">.: Agendar Paciente :.</td>
    </tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr style="height:25px">
		<td align="right"><span name='msg' id='msg' class="msg">&nbsp;</span></td>
	</tr>
    <tr align="center" valign="top">
      <td>
	  		<table width="100%" border="0" cellpadding="0" cellspacing="0" class="table">
				<tr>
					<td class="tdMedium"><a href="Javascript:pesquisapornascimento(2)" title="Pesquisa por nome">Paciente:</a>&nbsp;<a href="Javascript:pesquisapornascimento(1)" title="Pesquisa por data de nascimento"><img src="images/calendar.gif" border="0"></a></td>
		            <td colspan="2" class="tdLight" nowrap> 
              			<input type="hidden" name="codcli" id="codcli" value="<%= codcli %>">			
						<input style="width:95%" class="caixa" type="text" name="nome" id="nome" onKeyUp="busca(this.value, 'codcli', 'nome','paciente')" value="<%= nomepaciente%>" onClick="limparRegistro()">
						<input size="10" class="caixa" type="text" name="pesqnascimento" id="pesqnascimento" onKeyPress="buscanascimento(this.value, event); return formatar(this, event, '##/##/####');" style="display: none">						
					</td>
					<td class="tdLight" align="center">
						<a href="Javascript: cadastrorapido()"><img src="images/raio.gif" border="0" alt="Cadastro Rápido"></a>
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
		            <td height="22" class="tdMedium">Nascimento:</td>
					<td width="300" class="tdLight">
						<input type="text" class="caixa" name="nascimento" id="nascimento" value="<%= nascimento%>" onKeyPress="return false;" size="10" >
					</td>
					<td class="tdMedium">Idade:</td>					
					<td class="tdLight"><input size="10" type="text" class="caixa" name="idade" id="idade" onKeyPress="return false;"></td>
				</tr>
				<tr>
		            <td height="22" class="tdMedium">Convênio:</td>
					<td colspan="3" width="300" class="tdLight">
						<select name="cod_plano" id="cod_plano" class="caixa" style="width:445px">
							<%= paciente.getConveniosCombo(codcli)%>
						</select>
					</td>
				</tr>
				<tr>
					<td class="tdMedium">Procedimentos:</td>
					<td colspan="4" class="tdLight">
						<select name="procedimento" id="procedimento" class="caixa" style="width:445px">
							<%= agenda.getProcedimentosAgenda( cod_empresa ) %>
						</select>
					</td>
				</tr>
				<tr>
					<td class="tdMedium">Profissional:</td>
					<td colspan="4" class="tdLight">
						<select name="prof_reg" id="prof_reg" class="caixa" style="width:445px">
							<option value=""><-- Todos --></option>
							<%= agenda.getProfissionais( cod_empresa ) %>
						</select>
					</td>
				</tr>
				<tr>
					<td class="tdMedium" align="center" colspan="6">
                    		<button type="button" class="botao" onClick="Javascript:proximasagendas()" style="width:180px"><img src="images/busca.gif" border="0">&nbsp;&nbsp;&nbsp;Buscar Próximas Agendas</button>&nbsp;&nbsp;&nbsp;
                            <button type="button" class="botao" onClick="Javascript:detalheAgenda()" style="width:180px"><img src="images/13.gif" border="0">&nbsp;&nbsp;&nbsp;Agenda do Dia</button>					
					</td>					
				</tr>
			</table>
	  </td>
    </tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
  </table>
</form>

<center>
<iframe name="iframeproximasagendas" id="iframeproximasagendas" width="600" height="100%" marginheight="0" marginwidth="0" frameborder="0"></iframe>
</center>
</body>
</html>
