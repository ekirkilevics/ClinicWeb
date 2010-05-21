<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.AgendadoMedico" id="agenda" scope="page"/>
<jsp:useBean class="recursos.Paciente" id="paciente" scope="page"/>

<%
	//Se receber parâmetros, usá-los, senão, considerar vazio
	String Smes     = request.getParameter("mes") != null ? request.getParameter("mes") : "";
	String Sano     = request.getParameter("ano") != null ? request.getParameter("ano") : "";;
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
		
		//Se ainda não escolheu o médico, pegar o médico do paciente
		if(Util.isNull(prof_reg)) prof_reg = dadospaciente[3];
	}

	if(Smes.equals("") || Sano.equals(""))
	{
		GregorianCalendar hoje = new GregorianCalendar();
		mes = hoje.get(Calendar.MONTH)+1;
		ano = hoje.get(Calendar.YEAR);
	}
	else
	{
		mes = Integer.parseInt(Smes);
		ano = Integer.parseInt(Sano);
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
	 var nome_campos_obrigatorios = Array("Registro do Profissional");
	 //Página a enviar o formulário
	 var page = "gravaragendapaciente.jsp";
	 //Cod. da ajuda
	 cod_ajuda = 14;

     //Campos obrigatórios
	 var campos_obrigatorios = Array("prof_reg");
	 
	 var codcli = "<%= codcli%>";

	 function proximo()
	 {
		 var frm = cbeGetElementById("frmcadastrar");
		 var jsmes = "<%= mes+1%>";
 		 var jsano = "<%= ano%>";
		 if(jsmes=="13") { jsmes="1"; jsano=parseInt(jsano)+1; }
		 if(idReg=="null") idReg = "";
		 cbeGetElementById("mes").value = jsmes;
		 cbeGetElementById("ano").value = jsano;
		 frm.submit();
	 }

	 function anterior()
	 {
		 var frm = cbeGetElementById("frmcadastrar");
		 var jsmes = "<%= mes-1%>";
 		 var jsano = "<%= ano%>";
		 if(jsmes=="0") { jsmes="12"; jsano=parseInt(jsano)-1; }
		 if(idReg=="null") idReg = "";
		 cbeGetElementById("mes").value = jsmes;
		 cbeGetElementById("ano").value = jsano;
		 frm.submit();
	 }
	 
	 function detalheAgenda(d, m, a)
	 {
		 var proced = getObj("","procedimento").value;
		 var codpaci = getObj("","codcli").value;
		 var codplano = getObj("","cod_plano").value;
		 var jsprof_reg = getObj("", "prof_reg").value;
		
		 if(proced == "") {
		 	alert("Escolha o procedimento para visualizar a agenda");
			getObj("","procedimento").focus();
			return;
		 }

		 barrasessao();
		 eval("janela = window.open('detalheagenda.jsp?dia=" + d + "&mes=" + m + "&ano=" + a + "&codcli=" + codpaci + "&cod_proced=" + proced + "&cod_plano=" + codplano + "&prof_reg=" + jsprof_reg + "','popup"+d+m+a+"','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,menubar=no,width=500,height=540,top=5,left=10');")
	 }
	 
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

		 barrasessao();
		 eval("proximas = window.open('proximasagendas.jsp?abriu=yes&codcli=" + codpaci + "&cod_proced=" + proced + "&cod_plano=" + codplano + "','proximas','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,menubar=no,width=400,height=600,top=10,left=10');")
	}
	
	function verAgendasAnteriores() {
		if(codcli != "")
			displayPopup("agendasanteriores.jsp?codcli=" + codcli,"agendasanteriores",150,400);
		else
			alert("Selecione primeiro o paciente!");
	}

</script>
</head>

<body onLoad="iniciar();">
<%@include file="barrasessao.jsp" %>
<%@include file="barraajax.jsp" %>
<form name="frmcadastrar" id="frmcadastrar" action="agendapaciente.jsp" method="post">
	<!-- Campos ocultos para a data -->
	<input type="hidden" name="mes" id="mes" value="<%= mes%>">
	<input type="hidden" name="ano" id="ano" value="<%= ano%>">
	<!-- Campos ocultos para a data -->

  <table width="600" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr>
      <td width="100%" height="18" class="title">.: Agendar Paciente :.</td>
    </tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td width="100%">
        	<table cellpadding="0" cellspacing="0" width="100%">
            	<tr>
                    <td class="texto" width="33%">
						<font color="#999999">[Aguarda atendimento]</font><br>
                        <font color="green">[Já foi atendido]</font><br>
                  </td>
                  <td class="texto" align="left" width="33%">
	                    <font color="red">[N&atilde;o chegou]</font><br>
                        <font color="blue">[Agendas em aberto]</font><br>
                  </td>
                    <td class="texto">
                    	<img src="images/30.gif">Sem mais horários
                    </td>
                </tr>
            </table>	
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
						<select name="prof_reg" id="prof_reg" class="caixa" style="width:445px" onChange="Javascript:cbeGetElementById('frmcadastrar').submit();">
							<option value=""><-- Todos --></option>
							<%= agenda.getProfissionais( cod_empresa ) %>
						</select>
					</td>
				</tr>
			</table>
            <img src="images/page.gif" height="7px">
	  		<table width="100%" border="0" cellpadding="0" cellspacing="0" class="table">
				<tr>
					<td class="tdMedium" style="background-color:#DCE4F1" align="center"><a href="Javascript:anterior()" title="Mês Anterior"><img src="images/setaabre.gif" border="0"></a></td>
					<td class="tdMedium" style="background-color:#DCE4F1" align="center"><a href="Javascript:proximo()" title="Mês Posterior"><img src="images/setafecha.gif" border="0"></a></td>
					<td class="tdMedium" style="background-color:#DCE4F1" align="center"> <%= agenda.mesExtenso(mes)%>  /  <%= ano%></td>
                    <td class="tdMedium" style="background-color:#DCE4F1" align="center">
                    	<a href="Javascript:verAgendasAnteriores()" title="Agendas Anteriores"><img src="images/33.gif" border="0"></a>
                     </td>
					<td class="tdMedium" style="background-color:#DCE4F1" align="center">
						<a href="Javascript:proximasagendas()" title="Buscar Próximas Agendas"><img src="images/32.gif" border="0"></a>					
					</td>	
				</tr>
			</table>
            <img src="images/page.gif" height="7px">
	  		<table width="100%" border="0" cellpadding="0" cellspacing="0" class="table">
				<tr>
					<td colspan="5" class="tdLight">
						<%= agenda.montaCalendarioPaciente(mes, ano, "detalheagenda", prof_reg)%>
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

</body>
</html>
