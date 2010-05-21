<%@include file="cabecalho.jsp" %>
<%@page import="java.util.Vector" %>

<jsp:useBean class="recursos.Conta" id="conta" scope="page"/>
<%
	String de = !Util.isNull(request.getParameter("de")) ? request.getParameter("de") : "01/" + Util.getMes(Util.getData()) + "/" + Util.getAno(Util.getData());
	String ate = !Util.isNull(request.getParameter("ate")) ? request.getParameter("ate") : Util.getData();
	String convenio = Util.isNull(request.getParameter("cod_convenio")) ? "" : request.getParameter("cod_convenio");
	String descr_convenio = Util.isNull(request.getParameter("descr_convenio")) ? "" : request.getParameter("descr_convenio");
	String lote = Util.isNull(request.getParameter("lote")) ? "" : request.getParameter("lote");
	String clicou = request.getParameter("clicou");
	if(Util.isNull(ordem)) ordem = "Data_Lanca";
%>

<html>
<head>
<title>Contas a Receber</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
<script language="JavaScript" src="js/ajax.js"></script>
<script language="JavaScript">
     //id do convênio
     var idReg = "<%= strcod%>";
 	 //Informação vinda de gravar
	 var inf = "<%= inf%>";
	
	 function marcarRecebeu(chk) {
		//Se checou, colocar valor, data
		if(chk.checked) {
			cbeGetElementById("valor" + chk.id).disabled = false;
			cbeGetElementById("valor" + chk.id).value = formatCurrency(cbeGetElementById("vlr" + chk.id).value);
			cbeGetElementById("data" + chk.id).disabled = false;
			cbeGetElementById("data" + chk.id).value = cbeGetElementById("datarecebimento").value;
			cbeGetElementById("operacao" + chk.id).disabled = false;
			cbeGetElementById("operacao" + chk.id).value = cbeGetElementById("operacao").value;
			cbeGetElementById("banco" + chk.id).disabled = false;
			cbeGetElementById("banco" + chk.id).value = cbeGetElementById("banco").value;
			cbeGetElementById("obs" + chk.id).disabled = false;
		}
		else {
			cbeGetElementById("valor" + chk.id).value = "";
			cbeGetElementById("valor" + chk.id).disabled = true;
			cbeGetElementById("data" + chk.id).value = "";
			cbeGetElementById("data" + chk.id).disabled = true;
			cbeGetElementById("operacao" + chk.id).value = "";
			cbeGetElementById("operacao" + chk.id).disabled = true;
			cbeGetElementById("banco" + chk.id).value = "";
			cbeGetElementById("banco" + chk.id).disabled = true;
			cbeGetElementById("obs" + chk.id).value = "";
			cbeGetElementById("obs" + chk.id).disabled = true;
		}
	 }

	 function validaForm() {
		var vde = getObj("","de");
		var vate = getObj("","ate");
	
		if(vde.value == "") {
			alert("Preencha data de início da pesquisa.");
			vde.focus();
			return false;
		}

		if(vate.value == "") {
			alert("Preencha data de fim da pesquisa.");
			vate.focus();
			return false;
		}
		
		cbeGetElementById("frmcadastrar").action = "contasreceber.jsp?clicou=yes";
		barrasessao();
		return true;
	 }
	 
	 function salvarContas() {
	 	var frm = cbeGetElementById("frmcadastrar");
		if(validarCamposContas()) {
			frm.action = "gravarcontasreceber.jsp";
			frm.submit();
		}
	 }
	 
	function todos(estado) {
		var obj;
		//Captura o formulário (sempre terá o mesmo nome)
		var frm = cbeGetElementById('frmcadastrar');

		//Varre todos os elementos, limpandos o conteúdo (exceto de botões)
		for(i=0; i<frm.elements.length; i++) {
			//Pega objeto por objeto do formulário
			obj = frm[i];
			//Se o tipo for botão, não limpar
			if(obj.type == "checkbox"){
				obj.checked = estado;
				if(obj.id != "chktodos") {
					marcarRecebeu(obj);
				}
			}
		}
		atualizarvalor();
	}

	function atualizarvalor() {
		var obj2;
		//Captura o formulário (sempre terá o mesmo nome)
		var frm2 = cbeGetElementById('frmcadastrar');
		var soma = 0;

		//Varre todos os elementos, limpandos o conteúdo (exceto de botões)
		for(i=0; i<frm2.elements.length; i++) {
			//Pega objeto por objeto do formulário
			obj2 = frm2[i];

			//Se o tipo for botão, não limpar
			if(obj2.type == "text" && obj2.id.indexOf("valor") >=0 && obj2.value != ""){
				soma += parseFloat(toMoney(obj2.value));
			}
		}
		cbeGetElementById("valorrecebido").innerHTML = "R$ " + formatCurrency(soma);
	}
	
	function toMoney(valor) {
		resp = valor.replace(".","");
	 	resp = resp.replace(",",".");
		return resp;	
	 }

	function validarCamposContas() {
		var obj;
		//Captura o formulário (sempre terá o mesmo nome)
		var frm = cbeGetElementById('frmcadastrar');

		//Varre todos os elementos, limpandos o conteúdo (exceto de botões)
		for(i=0; i<frm.elements.length; i++) {
			//Pega objeto por objeto do formulário
			obj = frm[i];
			//Se o tipo for checkbox e tiver checado e não for o check todos
			if(obj.type == "checkbox" && obj.checked && obj.id != "chktodos"){
				//Captura os campos para validar
				jsvalor = cbeGetElementById("valor" + obj.id);
				jsdata = cbeGetElementById("data" + obj.id);
				jsbanco = cbeGetElementById("banco" + obj.id);
				jsoperacao = cbeGetElementById("operacao" + obj.id);
				
				//Valida
				if(jsdata.value == "") {
					alert("Preencha data recebida");
					jsdata.focus();
					return false;
				}
				if(jsoperacao.value == "") {
					alert("Preencha operação recebida");
					jsoperacao.focus();
					return false;
				}
				if(jsbanco.value == "") {
					alert("Preencha banco recebido");
					jsbanco.focus();
					return false;
				}
				if(jsvalor.value == "") {
					alert("Preencha valor recebido");
					jsvalor.focus();
					return false;
				}
			}
		}
		return true;
	}
	
	function iniciar() {
		if(inf != "null") {
			if(inf == "OK") {
				mensagem("Contas Registradas com sucesso", 1);
			}
			else {
				mensagem(inf, 2);
			}
		}
		barrasessao();	
	}

	 

</script>
</head>

<body onLoad="iniciar()">
<%@include file="barrasessao.jsp" %>
<%@include file="barraajax.jsp" %>
<form name="frmcadastrar" id="frmcadastrar" action="contasreceber.jsp" method="post" onSubmit="return validaForm()">
  <input type="hidden" name="clicou" id="clicou" value="<%= clicou%>">
  <table width="600" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr>
      <td height="18" class="title">.: Contas a Receber :.</td>
    </tr>
	<tr style="height:25px">
		<td align="right"><span name='msg' id='msg' class="msg">&nbsp;</span></td>
	</tr>
    <tr align="center" valign="top">
      <td>
         <table width="500" border="0" cellpadding="0" cellspacing="0" class="table">
		 	<tr>
              <td height="21" colspan="4" align="center" class="tdMedium"><b>Filtros</b></td>
			</tr>
			<tr>
				<td class="tdMedium">Data Início</td>
				<td class="tdLight"><input type="text" name="de" id="de" class="caixa" size="12" maxlength="10" onKeyPress="return formatar(this, event, '##/##/####');" value='<%= de%>'></td>
				<td class="tdMedium">Data Fim</td>
				<td class="tdLight"><input type="text" name="ate" id="ate" class="caixa" size="12" maxlength="10" onKeyPress="return formatar(this, event, '##/##/####');" value="<%= ate%>"></td>
			</tr>
			<tr>
				<td class="tdMedium">Convênio</td>
				<td class="tdLight">
              			<input type="hidden" name="cod_convenio" id="cod_convenio" value="<%= convenio%>">			
						<input style="width:100%" class="caixa" type="text" name="descr_convenio" id="descr_convenio" onKeyUp="busca(this.value, 'cod_convenio', 'descr_convenio','convenio')" value="<%= descr_convenio%>">
				</td>
            	<td class="tdMedium">Lote</td>
                <td class="tdLight"><input type="text" name="lote" id="lote" class="caixa" maxlength="4" size="3" value="<%= lote%>"></td>
            </tr>
			<tr>
				<td colspan="4" class="tdMedium" align="right"><button type="submit" class="botao" name="botao" value="OK"><img src="images/38.gif">&nbsp;&nbsp;&nbsp;Buscar</button></td>
			</tr>
         </table>
      </td>
    </tr>
  </table>
  <br>
  <center>
  <%
		if(!Util.isNull(clicou)) {
			String datarecebimento = conta.getDataRecebimento(lote);
			String bancopagto = conta.getBancoLote(lote, convenio);
  %>
  		<table cellpadding="0" cellspacing="0" width="500" class="table">
        	<tr>
            	<td class="tdMedium" width="90">Data Recebimento:</td>
                <td class="tdLight"><input type="text" name="datarecebimento" id="datarecebimento" class="caixa" size="12" maxlength="10" onKeyPress="return formatar(this, event, '##/##/####');" value="<%= datarecebimento%>"></td>
            	<td class="tdMedium">Operação:</td>
                <td class="tdLight">
                	<select name="operacao" id="operacao" class="caixa">
						<option value=""></option>
						<option value="1">Dinheiro</option>
						<option value="2">Cheque</option>
						<option value="3">Cartão</option>
						<option value="4">Internet</option>
						<option value="5">Débito Automático</option>
						<option value="6">Depósito</option>
                    </select>
                </td>
            </tr>
            <tr>
            	<td class="tdMedium">Banco:</td>
                <td colspan="3" class="tdLight">
                	<select name="banco" id="banco" class="caixa">
							<option value=""></option>
          					<%= conta.getBancos(cod_empresa, bancopagto)%>
                    </select>
                </td>
            </tr>
        </table>
        <br>
      <table width="90%" border="0" align="center" cellpadding="0" cellspacing="0" class="table">
      <%
                Vector resp = conta.getRelContasReceber(de, ate, convenio, lote, ordem, cod_empresa);
                for(int i=0; i<resp.size(); i++)
                    out.println(resp.get(i).toString());
    
            }
      %>
      </table>
  </center>
</form>

</body>
</html>
