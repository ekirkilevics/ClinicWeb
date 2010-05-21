<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.AgendaInteligente" id="agenda" scope="page"/>

<%
	String nomeconvenio = "", cod_convenio = "";
	if(strcod != null) {
		rs = banco.getRegistro("limite_agendamento","cod_limite", Integer.parseInt(strcod) );
		cod_convenio = banco.getCampo("cod_convenio", rs);
		nomeconvenio = banco.getValor("descr_convenio", "SELECT descr_convenio FROM convenio WHERE cod_convenio=" + cod_convenio);
	}
	if(Util.isNull(ordem)) ordem = "descr_convenio";
%>

<html>
<head>
<title>Limite de Agenda</title>
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
	 var nome_campos_obrigatorios = Array("Procedimento", "Convênio", "Plano", "Limite Mensal");
	 //Página a enviar o formulário
	 var page = "gravarlimiteagendamento.jsp";
     //Campos obrigatórios
	 var campos_obrigatorios = Array("procedimento", "cod_convenio", "cod_plano", "limite");
	 
 	function clickBotaoNovo() {
		self.location = "limiteagendamento.jsp";
	}
	
	function clickBotaoSalvar() {
		enviarAcao('inc');
	}
	
	function clickBotaoExcluir() {
		enviarAcao('exc');
	}
	
	function iniciar() {
		inicio();
		barrasessao();	
		
		cont=0;
	
		//Se escolheu registro, buscar os planos
		if(idReg != "null") {
			buscaplanosconvenio('<%= cod_convenio %>', 1, '<%= banco.getCampo("cod_plano", rs) %>');
		}
		
		cbeGetElementById("procedimento").value = "<%= banco.getCampo("cod_grupoproced", rs) %>";
	}

	//Sobrescrendo a função do AJAX
	function setar(chave, campo, valorchave, valorcampo, mascara) {
		cbeGetElementById(campo).value = valorcampo;
		cbeGetElementById(chave).value = valorchave;
		x.innerHTML = "";
		hide();
	
		buscaplanosconvenio(valorchave);
		
		return;
	}
	
	 

</script>
</head>

<body onLoad="iniciar()">
<%@include file="barrasessao.jsp" %>
<%@include file="barraajax.jsp" %>
<form name="frmcadastrar" id="frmcadastrar" action="gravaralerta.jsp" method="post">
  <table width="600" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr>
      <td width="651" height="18" class="title">.: Limite de Agendamento :.</td>
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
				<td class="tdMedium">Procedimento: *</td>
                <td class="tdLight">
                    <select name="procedimento" id="procedimento" class="caixa" style="width:445px">
                        <%= agenda.getProcedimentos( cod_empresa ) %>
                    </select>
				</td>            
            </tr>
            <tr>
                <td class="tdMedium">Convênio: *</td>
                <td class="tdLight">
                    <input type="hidden" name="cod_convenio" id="cod_convenio" value="<%= banco.getCampo("cod_convenio", rs) %>">			
                    <input style="width:100%" class="caixa" type="text" name="descr_convenio" id="descr_convenio" onKeyUp="buscaconvenios(this.value)" value="<%= nomeconvenio%>">
                </td>
            </tr>
            <tr>
                <td class="tdMedium">Plano: *</td>
                <td class="tdLight">
                    <div id="listaplanos">
                        <select name="cod_plano" id="cod_plano" class="caixa" style="width:120px">
                            <option value=""></option>
                        </select>
                    </div>
                </td>
            </tr>
            <tr>
            	<td class="tdMedium">Limite Mensal: *</td>
                <td class="tdLight"><input type="text" name="limite" id="limite" class="caixa" size="4" maxlength="4" value="<%= banco.getCampo("limite", rs) %>"></td>
            </tr>
          </table>
      </td>
    </tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<%= Util.getBotoes("limiteagendamento", pesq, tipo) %>
	<tr>
		<td>&nbsp;</td>
	</tr>
    <tr>
		<td width="100%" style="text-align:center">
			<table width="600px">
				<tr>
					<td width="40%" class="tdDark"><a title="Ordenar por Grupo de Procedimento" href="Javascript:ordenar('limiteagendamento','grupoproced')">Procedimento</a></td>
					<td width="40%" class="tdDark"><a title="Ordenar por Convênio" href="Javascript:ordenar('limiteagendamento','descr_convenio')">Convênio</a></td>
					<td class="tdDark">Plano</td>
				</tr>
			</table>
			<div style="width:600; height:101; overflow: auto">
				<table width="100%">
				    <%
						String resp[] = agenda.getLimitesAgendamento(pesq, ordem, numPag, 50, tipo, cod_empresa);
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
