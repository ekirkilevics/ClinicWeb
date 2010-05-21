<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.AgendaMedico" id="agenda" scope="page"/>

<%
	if(ordem == null) ordem = "vigencia DESC, nome";
	
	//Recupera dados para edição
	String prof_reg = Util.isNull(request.getParameter("prof_reg")) ? "null" : request.getParameter("prof_reg");
	String data = Util.isNull(request.getParameter("data")) ? Util.getData() : request.getParameter("data");

	//Em modo de edição, atribui strcod
	strcod = prof_reg;

	String horarios[];

	String inicio_atendimento = Util.formataHora(configuracao.getItemConfig("inicio_atendimento", cod_empresa));
	String fim_atendimento = Util.formataHora(configuracao.getItemConfig("fim_atendimento", cod_empresa));
%>

<html>
<head>
<title>Configurar Agenda do Médico</title>
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
<script type="text/javascript" src="js/calendarDateInput.js"></script>
<script language="JavaScript">
     //id
     var idReg = "<%= strcod%>";
	 //Informação vinda de gravarprocedimento
	 var inf = "<%= inf%>";
	 //Nome dos campos
	 var nome_campos_obrigatorios = Array("Registro do Profissional", "Data de Vigência");
	 //Página a enviar o formulário
	 var page = "gravaragendamedico.jsp";
	 //Cod. da ajuda
	 cod_ajuda = 10;

     //Campos obrigatórios
	 var campos_obrigatorios = Array("prof_reg", "vigencia");
	 
	 var jsinicio_atendimento = "<%= inicio_atendimento%>";
	 var jsfim_atendimento = "<%= fim_atendimento%>";

	function removeProcedimento(diasemana)
	{
		var espec = getObj("",diasemana);
		if(espec.selectedIndex >= 0) {
			conf = confirm("Excluir o item da lista?","Confirmação");
			if(conf) {
				espec.remove(espec.selectedIndex);
			}
		}
	}

	function incluiProcedimento(diasemana)
	{
		
		var proced = getObj("","procedimento");
		var texto = proced[proced.selectedIndex].text;
		var valor = proced[proced.selectedIndex].value;

		insereCombo(diasemana, valor, texto);
	}

	//Insere o procedimento em todos os dias da semana
	function inserirTodosDias()
	{
		for(i=1; i<=7; i++)
			incluiProcedimento("diasemana"+i);
	}
	
	function setarValores()
	{
		cbeGetElementById("prof_reg").value = "<%= prof_reg%>";
	}
	
	function validahorario(obj) {
		
		if(obj.value != "") {
	
			var hi = jsinicio_atendimento.substring(0,2);
			var mi = jsinicio_atendimento.substring(3);
			var hf = jsfim_atendimento.substring(0,2);
			var mf = jsfim_atendimento.substring(3);
			var hd = obj.value.substring(0,2);
			var md = obj.value.substring(3);
	
			inicio = new Date(1,1,1,hi, mi, 0);
			fim    = new Date(1,1,1,hf, mf, 0); 
			digitada = new Date(1,1,1,hd, md, 0);
	
			//Se for a caixa de até, validar se é maior que caixa de
			if(obj.id.substring(3,6) == "ate") {
				caixade = cbeGetElementById("diade" + obj.id.substring(6,7));
				diade = new Date(1,1,1,caixade.value.substring(0,2), caixade.value.substring(3), 0);
	
				if(digitada.getTime() <= diade.getTime()) {
					alert("Horário de Fim é menor ou igual ao Horário do começo.\nHorário deve ser maior que " + caixade.value + "!");
					obj.value = "";
					obj.focus();
					return;
				}
			}
	
			//Se horário estiver fora do intervalod a clínica, avisar
			if(digitada.getTime() < inicio.getTime() || digitada.getTime() > fim.getTime()) {
				alert("Horário do médico deve estar dentro do horário da clínica\nDas " + jsinicio_atendimento + " às " + jsfim_atendimento);
				obj.value = "";
				obj.focus();
				return;
			}
		}
	}
	
	function salvarHorario() {
		
		//Varre as listas e verifica se a lista tem algo e o horário não está
		for(i=1; i<=7; i++) {
			//Captura os objetos de tela
			jslista = cbeGetElementById("diasemana" + i);
			jsde = cbeGetElementById("diade" + i);
			jsate = cbeGetElementById("diaate" + i);
			//Coloca as caixas em branco
			jsde.style.backgroundColor = '#FFFFFF';
			jsate.style.backgroundColor = '#FFFFFF';

			//Se tiver pelo menos 1 item na lista, verificar o horário
			if(jslista.length > 0) {
				if(jsde.value == "") {
					alert("Preecha o horário de início de atendimento");
					jsde.style.backgroundColor = '#FF8080';
					jsde.focus();
					return;
				}
				if(jsate.value == "") {
					alert("Preecha o horário de fim de atendimento");
					jsate.style.backgroundColor = '#FF8080';
					jsate.focus();
					return;
				}
			}
		}

		enviarAcao('inc');
	}
	
	function iniciar() {
		inicio();
		setarValores();
		barrasessao();
	}
	
	function clickBotaoNovo() {
		self.location = "agendamedico.jsp";
	}
	
	function clickBotaoSalvar() {
		salvarHorario();
	}
	
	function clickBotaoExcluir() {
		enviarAcao('exc');
	}
	
	function salvarComo() {
		idReg = "null";
		salvarHorario();
	}
	

</script>
</head>

<body onLoad="iniciar()">
<%@include file="barrasessao.jsp" %>
<form name="frmcadastrar" id="frmcadastrar" action="agendamedico.jsp" method="post">
  <table width="600" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr>
      <td width="651" height="18" class="title">.: Configurar Agenda :.</td>
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
					<td class="tdMedium">Profissional:</td>
					<td colspan="3" class="tdLight">
                    	<select name="prof_reg" id="prof_reg" class="caixa">
                        	<option value=""></option>
                            <%= agenda.getProfissionais( cod_empresa )%>
                        </select>					</td>
				</tr>
                <tr>
                	<td class="tdMedium">Data de Vigência:</td>
                    <td class="tdLight" colspan="3"><script>DateInput('vigencia', true, 'DD/MM/YYYY','<%= data%>')</script></td>
                </tr>
				<tr>
					<td class="tdMedium">Procedimento:</td>
					<td colspan="3" class="tdLight">
						<select name="procedimento" id="procedimento" class="caixa" style="width:300px">
							<option value="">&nbsp;</option>
							<%= agenda.getProcedimentos(cod_empresa) %>
						</select>
						<input type="button" value="Semana Toda" style="width:100px" class="botao" onClick="inserirTodosDias()">					</td>
				</tr>
				<tr>
					<td class="tdDark" align="center">Domingo</td>
					<td class="tdDark" align="center">Segunda</td>
					<td class="tdDark" align="center">Terça</td>
					<td class="tdDark" align="center">Quarta</td>
				</tr>				
				<tr>
					<td class="tdLight" align="center">
						<select multiple name="diasemana1" id="diasemana1" class="caixa" style="width:120px; height:66px"><%= agenda.getProcedimentosSemana(1, prof_reg, data)%></select>
					<br><button title="Insere Procedimento no dia da semana" type="button" style="width:30px" onClick="incluiProcedimento('diasemana1')"><img src="images/add.gif"></button>
					      <button title="Remove Procedimento do dia da semana" type="button" style="width:30px" onClick="removeProcedimento('diasemana1')"><img src="images/delete.gif"></button>					</td>
					<td class="tdLight" align="center">
						<select multiple name="diasemana2" id="diasemana2" class="caixa" style="width:120px; height:66px"><%= agenda.getProcedimentosSemana(2, prof_reg, data)%></select>
					<br><button title="Insere Procedimento no dia da semana" type="button" style="width:30px" onClick="incluiProcedimento('diasemana2')"><img src="images/add.gif"></button>
					      <button title="Remove Procedimento do dia da semana" type="button" style="width:30px" onClick="removeProcedimento('diasemana2')"><img src="images/delete.gif"></button>					</td>
					<td class="tdLight" align="center">
						<select multiple name="diasemana3" id="diasemana3" class="caixa" style="width:120px; height:66px"><%= agenda.getProcedimentosSemana(3, prof_reg, data)%></select>
					<br><button title="Insere Procedimento no dia da semana" type="button" style="width:30px" onClick="incluiProcedimento('diasemana3')"><img src="images/add.gif"></button>
					      <button title="Remove Procedimento do dia da semana" type="button" style="width:30px" onClick="removeProcedimento('diasemana3')"><img src="images/delete.gif"></button>					</td>
					<td class="tdLight" align="center">
						<select multiple name="diasemana4" id="diasemana4" class="caixa" style="width:120px; height:66px"><%= agenda.getProcedimentosSemana(4, prof_reg, data)%></select>
					<br><button title="Insere Procedimento no dia da semana" type="button" style="width:30px" onClick="incluiProcedimento('diasemana4')"><img src="images/add.gif"></button>
					      <button title="Remove Procedimento do dia da semana" type="button" style="width:30px" onClick="removeProcedimento('diasemana4')"><img src="images/delete.gif"></button>					</td>
				</tr>				
				<tr>
					<td class="tdMedium"><% horarios = agenda.getHorario(prof_reg, data, 1 );%>
						<img src="images/34.gif">&nbsp;<input value="<%= horarios[0]%>" type="text" name="diade1" id="diade1" class="caixa" size="5" maxlength="5" onBlur="ValidaHora(this); validahorario(this)" onKeyPress="formatar(this, event, '##:##'); " onKeyUp="mudaFoco(this, 5, 'diaate1')">
						às<input value="<%= horarios[1]%>" type="text" name="diaate1" id="diaate1" class="caixa" size="5" maxlength="5" onBlur="ValidaHora(this); validahorario(this)" onKeyPress="formatar(this, event, '##:##'); " onKeyUp="mudaFoco(this, 5, 'almocode1')">					</td>
					<td class="tdMedium"><% horarios = agenda.getHorario(prof_reg, data, 2 );%>
						<img src="images/34.gif">&nbsp;<input value="<%= horarios[0]%>" type="text" name="diade2" id="diade2" class="caixa" size="5" maxlength="5" onBlur="ValidaHora(this); validahorario(this)" onKeyPress="formatar(this, event, '##:##'); " onKeyUp="mudaFoco(this, 5, 'diaate2')">
						às<input value="<%= horarios[1]%>" type="text" name="diaate2" id="diaate2" class="caixa" size="5" maxlength="5" onBlur="ValidaHora(this); validahorario(this)" onKeyPress="formatar(this, event, '##:##'); " onKeyUp="mudaFoco(this, 5, 'almocode2')">					</td>
					<td class="tdMedium"><% horarios = agenda.getHorario(prof_reg, data, 3 );%>
						<img src="images/34.gif">&nbsp;<input value="<%= horarios[0]%>" type="text" name="diade3" id="diade3" class="caixa" size="5" maxlength="5" onBlur="ValidaHora(this); validahorario(this)" onKeyPress="formatar(this, event, '##:##'); " onKeyUp="mudaFoco(this, 5, 'diaate3')">
						às<input value="<%= horarios[1]%>" type="text" name="diaate3" id="diaate3" class="caixa" size="5" maxlength="5" onBlur="ValidaHora(this); validahorario(this)" onKeyPress="formatar(this, event, '##:##'); " onKeyUp="mudaFoco(this, 5, 'almocode3')">					</td>
					<td class="tdMedium"><% horarios = agenda.getHorario(prof_reg, data, 4 );%>
						<img src="images/34.gif">&nbsp;<input value="<%= horarios[0]%>" type="text" name="diade4" id="diade4" class="caixa" size="5" maxlength="5" onBlur="ValidaHora(this); validahorario(this)" onKeyPress="formatar(this, event, '##:##'); " onKeyUp="mudaFoco(this, 5, 'diaate4')">
						às<input value="<%= horarios[1]%>" type="text" name="diaate4" id="diaate4" class="caixa" size="5" maxlength="5" onBlur="ValidaHora(this); validahorario(this)" onKeyPress="formatar(this, event, '##:##'); " onKeyUp="mudaFoco(this, 5, 'almocode4')">					</td>
				</tr>				
				<tr>
					<td class="tdMedium"><% horarios = agenda.getHorarioAlmoco(prof_reg, data, 1 );%>					  
                    <img src="images/35.gif">&nbsp;<input value="<%= horarios[0]%>" type="text" name="almocode1" id="almocode1" class="caixa" size="5" maxlength="5" onBlur="ValidaHora(this); validahorario(this)" onKeyPress="formatar(this, event, '##:##'); " onKeyUp="mudaFoco(this, 5, 'almocoate1')">
						às<input value="<%= horarios[1]%>" type="text" name="almocoate1" id="almocoate1" class="caixa" size="5" maxlength="5" onBlur="ValidaHora(this); validahorario(this)" onKeyPress="formatar(this, event, '##:##'); " onKeyUp="mudaFoco(this, 5, 'diade2')">
                    </td>
                    <td class="tdMedium"><% horarios = agenda.getHorarioAlmoco(prof_reg, data, 2 );%>
						<img src="images/35.gif">&nbsp;<input value="<%= horarios[0]%>" type="text" name="almocode2" id="almocode2" class="caixa" size="5" maxlength="5" onBlur="ValidaHora(this); validahorario(this)" onKeyPress="formatar(this, event, '##:##'); " onKeyUp="mudaFoco(this, 5, 'almocoate2')">
						às<input value="<%= horarios[1]%>" type="text" name="almocoate2" id="almocoate2" class="caixa" size="5" maxlength="5" onBlur="ValidaHora(this); validahorario(this)" onKeyPress="formatar(this, event, '##:##'); " onKeyUp="mudaFoco(this, 5, 'diade3')">
					</td>
					<td class="tdMedium"><% horarios = agenda.getHorarioAlmoco(prof_reg, data, 3 );%>
						<img src="images/35.gif">&nbsp;<input value="<%= horarios[0]%>" type="text" name="almocode3" id="almocode3" class="caixa" size="5" maxlength="5" onBlur="ValidaHora(this); validahorario(this)" onKeyPress="formatar(this, event, '##:##'); " onKeyUp="mudaFoco(this, 5, 'almocoate3')">
						às<input value="<%= horarios[1]%>" type="text" name="almocoate3" id="almocoate3" class="caixa" size="5" maxlength="5" onBlur="ValidaHora(this); validahorario(this)" onKeyPress="formatar(this, event, '##:##'); " onKeyUp="mudaFoco(this, 5, 'diade4')">					</td>
					<td class="tdMedium"><% horarios = agenda.getHorarioAlmoco(prof_reg, data, 4 );%>
						<img src="images/35.gif">&nbsp;<input value="<%= horarios[0]%>" type="text" name="almocode4" id="almocode4" class="caixa" size="5" maxlength="5" onBlur="ValidaHora(this); validahorario(this)" onKeyPress="formatar(this, event, '##:##'); " onKeyUp="mudaFoco(this, 5, 'almocoate4')">
						às<input value="<%= horarios[1]%>" type="text" name="almocoate4" id="almocoate4" class="caixa" size="5" maxlength="5" onBlur="ValidaHora(this); validahorario(this)" onKeyPress="formatar(this, event, '##:##'); " onKeyUp="mudaFoco(this, 5, 'diade5')">					</td>
				</tr>				
				<tr>
					<td class="tdDark" align="center">Quinta</td>
					<td class="tdDark" align="center">Sexta</td>
					<td class="tdDark" align="center">Sábado</td>
					<td class="tdDark" align="center">&nbsp;</td>
				</tr>				
				<tr>
					<td class="tdLight" align="center">
						<select multiple name="diasemana5" id="diasemana5" class="caixa" style="width:120px; height:66px"><%= agenda.getProcedimentosSemana(5, prof_reg, data)%></select>
					<br><button title="Insere Procedimento no dia da semana" type="button" style="width:30px" onClick="incluiProcedimento('diasemana5')"><img src="images/add.gif"></button>
					      <button title="Remove Procedimento do dia da semana" type="button" style="width:30px" onClick="removeProcedimento('diasemana5')"><img src="images/delete.gif"></button>						</td>
					<td class="tdLight" align="center">
						<select multiple name="diasemana6" id="diasemana6" class="caixa" style="width:120px; height:66px"><%= agenda.getProcedimentosSemana(6, prof_reg, data)%></select>
					<br><button title="Insere Procedimento no dia da semana" type="button" style="width:30px" onClick="incluiProcedimento('diasemana6')"><img src="images/add.gif"></button>
					      <button title="Remove Procedimento do dia da semana" type="button" style="width:30px" onClick="removeProcedimento('diasemana6')"><img src="images/delete.gif"></button>						</td>
					<td class="tdLight" align="center">
						<select multiple name="diasemana7" id="diasemana7" class="caixa" style="width:120px; height:66px"><%= agenda.getProcedimentosSemana(7, prof_reg, data)%></select>
					<br><button title="Insere Procedimento no dia da semana" type="button" style="width:30px" onClick="incluiProcedimento('diasemana7')"><img src="images/add.gif"></button>
					      <button title="Remove Procedimento do dia da semana" type="button" style="width:30px" onClick="removeProcedimento('diasemana7')"><img src="images/delete.gif"></button>					</td>
					<td class="tdLight" valign="middle" align="center"><button type="button" style="width:100px" class="botao" onClick="salvarComo()" title="Salva essa configuração com outra data"><img src="images/gravamini.gif"><br>Salvar como...</button></td>
				</tr>				
				<tr>
					<td class="tdMedium"><% horarios = agenda.getHorario(prof_reg, data, 5 );%>
						<img src="images/34.gif">&nbsp;<input value="<%= horarios[0]%>" type="text" name="diade5" id="diade5" class="caixa" size="5" maxlength="5" onBlur="ValidaHora(this); validahorario(this)" onKeyPress="formatar(this, event, '##:##'); " onKeyUp="mudaFoco(this, 5, 'diaate5')">
						às<input value="<%= horarios[1]%>" type="text" name="diaate5" id="diaate5" class="caixa" size="5" maxlength="5" onBlur="ValidaHora(this); validahorario(this)" onKeyPress="formatar(this, event, '##:##'); " onKeyUp="mudaFoco(this, 5, 'almocode5')">					</td>
					<td class="tdMedium"><% horarios = agenda.getHorario(prof_reg, data, 6 );%>
						<img src="images/34.gif">&nbsp;<input value="<%= horarios[0]%>" type="text" name="diade6" id="diade6" class="caixa" size="5" maxlength="5" onBlur="ValidaHora(this); validahorario(this)" onKeyPress="formatar(this, event, '##:##'); " onKeyUp="mudaFoco(this, 5, 'diaate6')">
						às<input value="<%= horarios[1]%>" type="text" name="diaate6" id="diaate6" class="caixa" size="5" maxlength="5" onBlur="ValidaHora(this); validahorario(this)" onKeyPress="formatar(this, event, '##:##'); " onKeyUp="mudaFoco(this, 5, 'almocode6')">					</td>
					<td class="tdMedium"><% horarios = agenda.getHorario(prof_reg, data, 7 );%>
						<img src="images/34.gif">&nbsp;<input value="<%= horarios[0]%>" type="text" name="diade7" id="diade7" class="caixa" size="5" maxlength="5" onBlur="ValidaHora(this); validahorario(this)" onKeyPress="formatar(this, event, '##:##'); " onKeyUp="mudaFoco(this, 5, 'diaate7')">
						às<input value="<%= horarios[1]%>" type="text" name="diaate7" id="diaate7" class="caixa" size="5" maxlength="5" onBlur="ValidaHora(this); validahorario(this)" onKeyPress="formatar(this, event, '##:##'); " onKeyUp="mudaFoco(this, 5, 'almocode7')">					</td>
					<td class="tdMedium">&nbsp;</td>
				</tr>				
				<tr>
					<td class="tdMedium"><% horarios = agenda.getHorarioAlmoco(prof_reg, data, 5 );%>
						<img src="images/35.gif">&nbsp;<input value="<%= horarios[0]%>" type="text" name="almocode5" id="almocode5" class="caixa" size="5" maxlength="5" onBlur="ValidaHora(this); validahorario(this)" onKeyPress="formatar(this, event, '##:##'); " onKeyUp="mudaFoco(this, 5, 'almocoate5')">
						às<input value="<%= horarios[1]%>" type="text" name="almocoate5" id="almocoate5" class="caixa" size="5" maxlength="5" onBlur="ValidaHora(this); validahorario(this)" onKeyPress="formatar(this, event, '##:##'); " onKeyUp="mudaFoco(this, 5, 'diade6')">					</td>
					<td class="tdMedium"><% horarios = agenda.getHorarioAlmoco(prof_reg, data, 6 );%>
						<img src="images/35.gif">&nbsp;<input value="<%= horarios[0]%>" type="text" name="almocode6" id="almocode6" class="caixa" size="5" maxlength="5" onBlur="ValidaHora(this); validahorario(this)" onKeyPress="formatar(this, event, '##:##'); " onKeyUp="mudaFoco(this, 5, 'almocoate6')">
						às<input value="<%= horarios[1]%>" type="text" name="almocoate6" id="almocoate6" class="caixa" size="5" maxlength="5" onBlur="ValidaHora(this); validahorario(this)" onKeyPress="formatar(this, event, '##:##'); " onKeyUp="mudaFoco(this, 5, 'diade7')">					</td>
					<td class="tdMedium"><% horarios = agenda.getHorarioAlmoco(prof_reg, data, 7 );%>
						<img src="images/35.gif">&nbsp;<input value="<%= horarios[0]%>" type="text" name="almocode7" id="almocode7" class="caixa" size="5" maxlength="5" onBlur="ValidaHora(this); validahorario(this)" onKeyPress="formatar(this, event, '##:##'); " onKeyUp="mudaFoco(this, 5, 'almocoate7')">
						às<input value="<%= horarios[1]%>" type="text" name="almocoate7" id="almocoate7" class="caixa" size="5" maxlength="5" onBlur="ValidaHora(this); validahorario(this)" onKeyPress="formatar(this, event, '##:##'); ">					</td>
					<td class="tdMedium">&nbsp;</td>
				</tr>				
			</table>
	  </td>
    </tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<%= Util.getBotoes("agendamedico", pesq, tipo) %>
	<tr>
		<td>&nbsp;</td>
	</tr>
    <tr>
		<td width="100%" style="text-align:center">
			<table width="600px">
				<tr>
					<td width="29%" class="tdDark"><a title="Ordenar por Registro" href="Javascript:ordenar('agendamedico','vigencia DESC, nome')">Vigência</a></td>
					<td width="71%" class="tdDark"><a title="Ordenar por Nome" href="Javascript:ordenar('agendamedico','nome, vigencia DESC')">Nome</a></td>
				</tr>
			</table>
			<div style="width:600; height:101; overflow: auto">
				<table width="100%">
				    <%
						String resp[] = agenda.getConfigAgendas(pesq, "nome", ordem, numPag, 30, tipo);
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
