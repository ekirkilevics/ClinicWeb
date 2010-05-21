<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.AgendaPessoal" id="agendapessoal" scope="page"/>

<%
	String data = Util.isNull(request.getParameter("data")) ? Util.getData() : request.getParameter("data");
	String hora = request.getParameter("hora");
	String horaalarme = request.getParameter("horaalarme");
	String descricao = request.getParameter("descricao");
	
	//Grava a agenda pessoal
	agendapessoal.gravarAgenda(usuario_logado, data, hora, horaalarme, descricao);	
	
	//Apaga agenda pessoal
	agendapessoal.excluirAgenda(request.getParameter("exc"));
%>

<html>
<head>
<title>Agenda Pessoal</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
<script language="JavaScript" src="js/calendar.js"></script>
<script language="JavaScript">

/*
Dynamic Calendar Script- By Constantin (http://212.1.77.9/)
Permission given to Dynamic Drive to include script in archive
For 1000's more DHTML scripts, visit http://dynamicdrive.com
*/

	var cal;
	function iniciar() {
		cal = new Calendar();
		setCurrentMonth();
		carregarAgendas("<%= data%>");
		pegarData("<%= Util.getDia(data)%>");
	}

	function pegarData(dia) {
		//Converte tudo para inteiro
		dia = parseInt(dia);
		nCurrentMonth = parseInt(nCurrentMonth);
		nCurrentYear = parseInt(nCurrentYear);

		//Pega as agendas do mês/ano
		carregarAgendasCadastradas(nCurrentMonth, nCurrentYear);
		
		//Tira as bordas de todos os dias
		for(i=1; i<=31; i++) {
			document.getElementById("idDate" + i).style.border = "0px solid #000000";
		}

		//Altera a cor do dia escolhido
		document.getElementById("idDate" + dia).style.border = "1px solid #000000";
	
	
		//Completa com zeros à esquerda
		if(dia<10) dia = "0" + dia;
		if(nCurrentMonth<10) nCurrentMonth = "0" + nCurrentMonth;
		
		//Coloca a data na caixa
		cbeGetElementById("data").value = dia + "/" + nCurrentMonth + "/" + nCurrentYear;

		//Altera o foco para a hora
		cbeGetElementById("hora").focus();

		
		carregarAgendas(dia + "/" + nCurrentMonth + "/" + nCurrentYear);
	}

	function salvarAgenda() {
		var frm = cbeGetElementById("frmcadastrar");
		
		if(frm.data.value == "") {
			mensagem("Data não preenchida",2);
			frm.data.focus();
			return;
		}
		if(frm.hora.value == "") {
			mensagem("Hora não preenchida",2);
			frm.hora.focus();
			return;
		}
		if(frm.descricao.value == "") {
			mensagem("Descrição do Compromisso não preenchido",2);
			frm.descricao.focus();
			return;
		}
		
		if(frm.chkalarme.checked) {
			if(frm.horaalarme.value == "") {
				mensagem("Preencha a hora do alarme");
				frm.horaalarme.focus();
				return;
			}
		}
		
		frm.submit();
	}

	var xmlHttp1, xmlHttp2;
	
	function carregarAgendas(data) {
			//Página que vai buscar os dados
			var url = "carregaragendapessoal.jsp?data=" + data;

			//Se for IE
			if (window.ActiveXObject) {
					xmlHttp1 = new ActiveXObject('Microsoft.XMLHTTP');
			}
			//Se for NETSCAPE
			else if (window.XMLHttpRequest) {
					xmlHttp1 = new XMLHttpRequest();
			}
			xmlHttp1.open('GET', url, true);
			xmlHttp1.onreadystatechange = eventosagenda;
			xmlHttp1.send(null);
	}

	function eventosagenda(){
		//Mostra imagem de carregando na caixa
		if (xmlHttp1.readyState == 1) {
			cbeGetElementById("imgagenda").src = "images/loading.gif";
		}
		//Carrega a lista com os resultados e volta o fundo da caixa pra branco
		if (xmlHttp1.readyState == 4) {
			if (xmlHttp1.status == 200) {
				cbeGetElementById("imgagenda").src = "images/17.gif";
				xmlDoc = xmlHttp1.responseText;
				cbeGetElementById("listaagenda").innerHTML = xmlDoc;
			}
		 }
	}

	function carregarAgendasCadastradas(mes, ano) {
			//Página que vai buscar os dados
			var url = "carregaragendascadastradas.jsp?mes=" + mes + "&ano=" + ano;

			//Se for IE
			if (window.ActiveXObject) {
					xmlHttp2 = new ActiveXObject('Microsoft.XMLHTTP');
			}
			//Se for NETSCAPE
			else if (window.XMLHttpRequest) {
					xmlHttp2 = new XMLHttpRequest();
			}
			xmlHttp2.open('GET', url, true);
			xmlHttp2.onreadystatechange = eventosagendascadastradas;
			xmlHttp2.send(null);
	}

	function eventosagendascadastradas(){
		//Carrega a lista com os resultados e volta o fundo da caixa pra branco
		if (xmlHttp2.readyState == 4) {
			if (xmlHttp2.status == 200) {
			   // Recebe o objeto XML
			   var xmlDoc = xmlHttp2.responseXML;
			   // Recupera todos os dias
			   for(i=1; i<=31; i++) {
    	            //Pega as respostas do XML
					var dia = xmlDoc.getElementsByTagName("idDate" + i)[0].childNodes[0].nodeValue;
					
					//Se achou agenda, trocar a cor
					if(dia == "S") {
						cbeGetElementById("idDate" + i).style.backgroundColor = "red";
					}
					else {
						cbeGetElementById("idDate" + i).style.backgroundColor = "#E8EFF7";
					}
			   }
			}
		 }
	}
	
	function excluiragenda(codagenda) {
		conf = confirm("Confirma exclusão do compromisso?");
		if(conf) {
			window.location = "agendapessoal.jsp?data=<%= data%>&exc=" + codagenda;
		}
	}
	
	function alarme(obj) {
		if(obj.checked) {
			cbeGetElementById("horaalarme").disabled = false;
			cbeGetElementById("horaalarme").focus();
		}
		else {
			cbeGetElementById("horaalarme").disabled = true;
			cbeGetElementById("horaalarme").value = "";
		}
	}


</script>
</head>

<body onLoad="iniciar()">
<form name="frmcadastrar" id="frmcadastrar" action="agendapessoal.jsp" method="post">
  <table width="600" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr>
      <td width="651" height="18" class="title">.: Agenda Pessoal :.</td>
    </tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td align="right"><span name='msg' id='msg' class="msg">&nbsp;</span></td>
	</tr>
    <tr align="center" valign="top">
      <td>
		<table cellpadding="0" cellspacing="0" width="100%">
			<tr>		
				<td><div id="divcalendar"></div></td>            
                <td width="100%" style="padding-left:20px">
                	<table cellpadding="0" cellspacing="0" width="100%" class="table">
                    	<tr>
                        	<td class="tdMedium" width="100">Usuário:</td>
                            <td class="tdLight" colspan="2"><%= nome_usuario%>&nbsp;</td>
                        </tr>
                    	<tr>
                        	<td class="tdMedium">Data:</td>
                            <td class="tdLight" colspan="2"><input type="text" onKeyPress="return formatar(this, event, '##/##/####'); " class="caixa" size="10" name="data" id="data" maxlength="10" value="<%= data%>"></td>
                        </tr>
                    	<tr>
                        	<td class="tdMedium">Hora:</td>
                            <td nowrap class="tdLight">
                       	    <input type="text" onKeyPress="return formatar(this, event, '##:##'); " class="caixa" size="6" name="hora" id="hora" maxlength="5" onBlur="ValidaHora(this)">
                                <input type="checkbox" id="chkalarme" onClick="alarme(this)"> Alarme
                          </td>
                          <td width="250" class="tdLight">Hora do Alarme:
                          <input type="text" onKeyPress="return formatar(this, event, '##:##'); " class="caixa" size="6" name="horaalarme" id="horaalarme" maxlength="5" onBlur="ValidaHora(this)" disabled></td>
                      </tr>
                    	<tr>
                        	<td class="tdMedium">Compromisso:</td>
                            <td class="tdLight" colspan="2"><textarea name="descricao" id="descricao" class="caixa" cols="50" rows="4"></textarea></td>
                        </tr>
                        <tr>
							  <td colspan="3" class="tdMedium" align="center"><button type="button" class="botao" onClick="salvarAgenda()"><img src="images/gravamini.gif">&nbsp;&nbsp;&nbsp;Salvar Compromisso</button></td>                      	
                        </tr>
                    </table>
                </td>
            </table>
           </tr>
            <tr>
                <td colspan="2">&nbsp;</td>
            </tr>
			<tr>
            	<td class="tdDark" align="left" colspan="2"><img name="imgagenda" id="imgagenda" src="images/17.gif"><b> &nbsp;&nbsp;Compromissos do Dia </b></td>
            </tr>
            <tr>
            	<td colspan="2">
                	<table cellpadding="0" cellspacing="0" width="100%">
                    	<td width="100%"><div id="listaagenda"></div></td>
                    </table>
                </td>
            </tr>
      </td>
    </tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
  </table>
</form>

</body>
</html>
