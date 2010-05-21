<%@include file="cabecalho.jsp" %>
<jsp:useBean class="recursos.Audiometria" id="audiometria" scope="page"/>

<%
	String codcli = request.getParameter("codcli");
	String nomepaciente = new Banco().getValor("nome", "SELECT nome FROM paciente WHERE codcli=" + codcli);
	String data = Util.getData();

	if(strcod != null) {
		rs = banco.getRegistro("audiometria","cod_audiometria", Integer.parseInt(strcod) );
		data = Util.formataData(banco.getCampo("data", rs));
	}
	if(Util.isNull(ordem)) ordem = "data DESC";
%>

<html>
<head>
<title>Gráfico</title>
<link href="css/css.css" rel="stylesheet" type="text/css">
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
<script language="JavaScript">
     //id
     var idReg = "<%= strcod%>";
	 //Informação vinda de gravar
	 var inf = "<%= inf%>";
	 //Nome dos campos
	 var nome_campos_obrigatorios = Array("Data");
	 //Página a enviar o formulário
	 var page = "gravaraudiometria.jsp";
     //Campos obrigatórios
	 var campos_obrigatorios = Array("data");
	 
 	function clickBotaoNovo() {
		self.location = "audiometria.jsp?codcli=<%= codcli%>";
	}
	
	function clickBotaoSalvar() {
		enviarAcao('inc');
	}
	
	function clickBotaoExcluir() {
		enviarAcao('exc');
	}
	
	function mostrarGrafico() {
		if(idReg == "null") {
			alert("Salve primeiro os dados para exibir o gráfico do Audiômetro");
			return;
		}
		else {
			displayPopup("graficoaudiometria.jsp?cod=" + idReg, "graficoaudiometria",300,640);
		}
	}	
	 

</script>
</head>

<body onLoad="inicio();">
<form name="frmcadastrar" id="frmcadastrar" action="gravaraudiometria.jsp" method="post">
	<center>
    <input type="hidden" name="codcli" id="codcli" value="<%= codcli%>">
	<table cellpadding="0" cellspacing="0" width="600">
        <tr>
            <td align="right"><span name='msg' id='msg' class="msg">&nbsp;</span></td>
        </tr>
		<tr>
			<td>
            	<table cellpadding="0" cellspacing="0" width="100%" class="table">
                	<tr>
                    	<td class="tdMedium" width="80">Paciente</td>
                        <td class="tdLight" colspan="2"><%= nomepaciente%>&nbsp;</td>
                    </tr>
                	<tr>
                    	<td class="tdMedium">Data</td>
                        <td class="tdLight"><input name="data" id="data" type="text" class="caixa" size="10" maxlength="10" onKeyPress="return formatar(this, event, '##/##/####'); " value="<%= data%>"></td>
                        <td class="tdMedium"  width="180" align="center"><button type="button" class="botao" onClick="mostrarGrafico()"><img src="images/31.gif">&nbsp;&nbsp;&nbsp;Mostrar Gráfico</button></td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td><img src="images/page.gif" height="5"></td>
        </tr>
    	<tr>
        	<td align="center">
            	<table cellpadding="0" cellspacing="0" width="100%" class="table">
					<tr>
                    	<td colspan="10" class="tdDark" style="color:#000000"><b>Orelha Direita</b></td>
                    </tr>
                	<tr>
                    	<td colspan="2" class="tdMedium">Frequ&ecirc;ncia (kHz)</td>
						<td class="tdLight" align="center">0.25</td>
						<td class="tdLight" align="center">0.5</td>
						<td class="tdLight" align="center">1</td>
						<td class="tdLight" align="center">2</td>
						<td class="tdLight" align="center">3</td>
						<td class="tdLight" align="center">4</td>
						<td class="tdLight" align="center">6</td>
						<td class="tdLight" align="center">8</td>
                    </tr>
					<tr>
                    	<td rowspan="2" class="tdMedium">Intensidade (dB)</td>
                        <td class="tdMedium">Via a&eacute;rea</td>
                        <td class="tdLight" align="center"><input type="text" class="caixa" maxlength="3" size="3" name="d_a_025" id="d_a_025" onKeyPress="return somenteNumerosSemPonto(event)" value="<%= banco.getCampo("d_a_025", rs) %>"></td>
                        <td class="tdLight" align="center"><input type="text" class="caixa" maxlength="3" size="3" name="d_a_050" id="d_a_050" onKeyPress="return somenteNumerosSemPonto(event)" value="<%= banco.getCampo("d_a_050", rs) %>"></td>
                        <td class="tdLight" align="center"><input type="text" class="caixa" maxlength="3" size="3" name="d_a_1" id="d_a_1" onKeyPress="return somenteNumerosSemPonto(event)" value="<%= banco.getCampo("d_a_1", rs) %>"></td>
                        <td class="tdLight" align="center"><input type="text" class="caixa" maxlength="3" size="3" name="d_a_2" id="d_a_2" onKeyPress="return somenteNumerosSemPonto(event)" value="<%= banco.getCampo("d_a_2", rs) %>"></td>
                        <td class="tdLight" align="center"><input type="text" class="caixa" maxlength="3" size="3" name="d_a_3" id="d_a_3" onKeyPress="return somenteNumerosSemPonto(event)" value="<%= banco.getCampo("d_a_3", rs) %>"></td>
                        <td class="tdLight" align="center"><input type="text" class="caixa" maxlength="3" size="3" name="d_a_4" id="d_a_4" onKeyPress="return somenteNumerosSemPonto(event)" value="<%= banco.getCampo("d_a_4", rs) %>"></td>
                        <td class="tdLight" align="center"><input type="text" class="caixa" maxlength="3" size="3" name="d_a_6" id="d_a_6" onKeyPress="return somenteNumerosSemPonto(event)" value="<%= banco.getCampo("d_a_6", rs) %>"></td>
                        <td class="tdLight" align="center"><input type="text" class="caixa" maxlength="3" size="3" name="d_a_8" id="d_a_8" onKeyPress="return somenteNumerosSemPonto(event)" value="<%= banco.getCampo("d_a_8", rs) %>"></td>
                    </tr>
					<tr>
                    	<td class="tdMedium">Via &oacute;ssea</td>
                        <td class="tdLight" align="center">&nbsp;</td>
                        <td class="tdLight" align="center"><input type="text" class="caixa" maxlength="3" size="3" name="d_o_050" id="d_o_050" onKeyPress="return somenteNumerosSemPonto(event)" value="<%= banco.getCampo("d_o_050", rs) %>"></td>
                        <td class="tdLight" align="center"><input type="text" class="caixa" maxlength="3" size="3" name="d_o_1" id="d_o_1" onKeyPress="return somenteNumerosSemPonto(event)" value="<%= banco.getCampo("d_o_1", rs) %>"></td>
                        <td class="tdLight" align="center"><input type="text" class="caixa" maxlength="3" size="3" name="d_o_2" id="d_o_2" onKeyPress="return somenteNumerosSemPonto(event)" value="<%= banco.getCampo("d_o_2", rs) %>"></td>
                        <td class="tdLight" align="center"><input type="text" class="caixa" maxlength="3" size="3" name="d_o_3" id="d_o_3" onKeyPress="return somenteNumerosSemPonto(event)" value="<%= banco.getCampo("d_o_3", rs) %>"></td>
                        <td class="tdLight" align="center"><input type="text" class="caixa" maxlength="3" size="3" name="d_o_4" id="d_o_4" onKeyPress="return somenteNumerosSemPonto(event)" value="<%= banco.getCampo("d_o_4", rs) %>"></td>
                        <td class="tdLight" align="center">&nbsp;</td>
                        <td class="tdLight" align="center">&nbsp;</td>
                    </tr>
                </table>
				<table cellpadding="0" cellspacing="0">
                    <tr>
                        <td><img src="images/page.gif" height="5"></td>
                    </tr>
                </table>
            	<table cellpadding="0" cellspacing="0" width="100%" class="table">
					<tr>
                    	<td colspan="10" class="tdDark" style="color:#000000"><b>Orelha Esquerda</b></td>
                    </tr>
                	<tr>
                    	<td colspan="2" class="tdMedium">Frequ&ecirc;ncia (kHz)</td>
						<td class="tdLight" align="center">0.25</td>
						<td class="tdLight" align="center">0.5</td>
						<td class="tdLight" align="center">1</td>
						<td class="tdLight" align="center">2</td>
						<td class="tdLight" align="center">3</td>
						<td class="tdLight" align="center">4</td>
						<td class="tdLight" align="center">6</td>
						<td class="tdLight" align="center">8</td>
                    </tr>
					<tr>
                    	<td rowspan="2" class="tdMedium">Intensidade (dB)</td>
                        <td class="tdMedium">Via a&eacute;rea</td>
                        <td class="tdLight" align="center"><input type="text" class="caixa" maxlength="3" size="3" name="e_a_025" id="e_a_025" onKeyPress="return somenteNumerosSemPonto(event)" value="<%= banco.getCampo("e_a_025", rs) %>"></td>
                        <td class="tdLight" align="center"><input type="text" class="caixa" maxlength="3" size="3" name="e_a_050" id="e_a_050" onKeyPress="return somenteNumerosSemPonto(event)" value="<%= banco.getCampo("e_a_050", rs) %>"></td>
                        <td class="tdLight" align="center"><input type="text" class="caixa" maxlength="3" size="3" name="e_a_1" id="e_a_1" onKeyPress="return somenteNumerosSemPonto(event)" value="<%= banco.getCampo("e_a_1", rs) %>"></td>
                        <td class="tdLight" align="center"><input type="text" class="caixa" maxlength="3" size="3" name="e_a_2" id="e_a_2" onKeyPress="return somenteNumerosSemPonto(event)" value="<%= banco.getCampo("e_a_2", rs) %>"></td>
                        <td class="tdLight" align="center"><input type="text" class="caixa" maxlength="3" size="3" name="e_a_3" id="e_a_3" onKeyPress="return somenteNumerosSemPonto(event)" value="<%= banco.getCampo("e_a_3", rs) %>"></td>
                        <td class="tdLight" align="center"><input type="text" class="caixa" maxlength="3" size="3" name="e_a_4" id="e_a_4" onKeyPress="return somenteNumerosSemPonto(event)" value="<%= banco.getCampo("e_a_4", rs) %>"></td>
                        <td class="tdLight" align="center"><input type="text" class="caixa" maxlength="3" size="3" name="e_a_6" id="e_a_6" onKeyPress="return somenteNumerosSemPonto(event)" value="<%= banco.getCampo("e_a_6", rs) %>"></td>
                        <td class="tdLight" align="center"><input type="text" class="caixa" maxlength="3" size="3" name="e_a_8" id="e_a_8" onKeyPress="return somenteNumerosSemPonto(event)" value="<%= banco.getCampo("e_a_8", rs) %>"></td>
                    </tr>
					<tr>
                    	<td class="tdMedium">Via &oacute;ssea</td>
                        <td class="tdLight" align="center">&nbsp;</td>
                        <td class="tdLight" align="center"><input type="text" class="caixa" maxlength="3" size="3" name="e_o_050" id="e_o_050" onKeyPress="return somenteNumerosSemPonto(event)" value="<%= banco.getCampo("e_o_050", rs) %>"></td>
                        <td class="tdLight" align="center"><input type="text" class="caixa" maxlength="3" size="3" name="e_o_1" id="e_o_1" onKeyPress="return somenteNumerosSemPonto(event)" value="<%= banco.getCampo("e_o_1", rs) %>"></td>
                        <td class="tdLight" align="center"><input type="text" class="caixa" maxlength="3" size="3" name="e_o_2" id="e_o_2" onKeyPress="return somenteNumerosSemPonto(event)" value="<%= banco.getCampo("e_o_2", rs) %>"></td>
                        <td class="tdLight" align="center"><input type="text" class="caixa" maxlength="3" size="3" name="e_o_3" id="e_o_3" onKeyPress="return somenteNumerosSemPonto(event)" value="<%= banco.getCampo("e_o_3", rs) %>"></td>
                        <td class="tdLight" align="center"><input type="text" class="caixa" maxlength="3" size="3" name="e_o_4" id="e_o_4" onKeyPress="return somenteNumerosSemPonto(event)" value="<%= banco.getCampo("e_o_4", rs) %>"></td>
                        <td class="tdLight" align="center">&nbsp;</td>
                        <td class="tdLight" align="center">&nbsp;</td>
                    </tr>
                </table>
                <br>
                <table cellpadding="0" cellspacing="0" width="600">
					<%= Util.getBotoes("audiometria", pesq, tipo) %>
                <tr>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td width="100%" style="text-align:center">
                        <table width="600px">
                            <tr>
                                <td width="100%" class="tdDark">Datas dos Exames</td>
                            </tr>
                        </table>
                        <div style="width:600; height:101; overflow: auto">
                            <table width="100%">
                                <%
                                    String resp[] = audiometria.getAudiometrias(pesq, "data", ordem, numPag, 50, tipo, cod_empresa, codcli);
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
            </td>
        </tr>
    </table>
    </center>
</form>
</body>
</html>
