<%@include file="cabecalho.jsp" %>
<jsp:useBean class="recursos.Faturamento" id="faturamento" scope="page"/>
<%
	String cod 		= request.getParameter("cod") != null ? request.getParameter("cod") : ""; 
	String qtde 	= request.getParameter("qtde") != null ? request.getParameter("qtde") : "0"; 
	String gravar 	= request.getParameter("gravar") != null ? request.getParameter("gravar") : "0"; 
	
	if(!cod.equals("")) rs = faturamento.getCheques(cod);
	
	if(gravar.equals("sim")) {
		//Configuração
		String tabela = "faturas_chq";
		String chave  = "cod_cheque";
	
		//Nome dos campos (form e tabela)
		String campostabela[] = {"cod_cheque","cod_subitem","Banco","Cheque","Data_Cheque","Valor","Comp", "ordem"};

		//Vetor de dados que vai ser preenchido
		String dados[] = new String[campostabela.length];
		
		//Remove todos os cheques para inserir novamente
		banco.excluirTabela("faturas_chq", "cod_subitem", cod);

		//Primeiro Looping para ler todos os cheques
		for(int i=1; i<=Integer.parseInt(qtde); i++) {

			//Código do cheque é sequencial
			dados[0] = banco.getNext(tabela, chave );

			//Dados dos campos
			dados[1] = cod;
			dados[2] = request.getParameter("banco"+i);
			dados[3] = request.getParameter("num"+i);
			dados[4] = Util.formataDataInvertida(request.getParameter("data"+i));
			dados[5] = request.getParameter("valor"+i);
			dados[6] = request.getParameter("comp"+i) != null ? request.getParameter("comp"+i) : "false";
			dados[7] = request.getParameter("ordem"+i);

			//Grava os dados do Cheque
			gravar = banco.gravarDados(tabela, dados, campostabela);
		}
	}
%>
<html>
<head>
<title>..:Cheques:..</title>
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
<script language="JavaScript">
	var vgravar = "<%= gravar%>";
	var valortotal;
	var qtde;
	
	function fecharTodas() {
		for(i=1; i<=12; i++) {
			eval("cbeGetElementById('tr" + i + "').style.display='none'");
		}
	}

	//Fecha todos os cheques
	function inicializar() {
		if(vgravar == "OK") {
			alert("Dados salvos com sucesso!")
			self.close();
		}

		<% 
			int cont=0;
			if(rs != null) { 
				 while(rs.next()) {
				 	cont++;
		%>
			cbeGetElementById("banco<%= cont%>").value = "<%= rs.getString("Banco")%>";
			cbeGetElementById("num<%= cont%>").value = "<%= rs.getString("Cheque")%>";
			cbeGetElementById("data<%= cont%>").value = "<%= Util.formataData(rs.getString("Data_Cheque"))%>";
			cbeGetElementById("valor<%= cont%>").value = "<%= rs.getString("Valor")%>";
			cbeGetElementById("comp<%= cont%>").checked = <%= rs.getString("Comp")%>;
			cbeGetElementById("ordem<%= cont%>").value = "<%= rs.getString("ordem")%>";
		<%}
			out.println("fecharTodas()");
			//Habilita a quantidade de caixas necessárias
			out.println("enviar("+cont+");");
			//Seta a quantidade na combo
			out.println("cbeGetElementById('qtde').value = " + cont + ";");
		}%>
		
	}


	function enviar(total) {
		//Coloca na variável global a quantidade
		qtde = total;
		
		//Se não escolheu a quantidade de cheques, desabilitar botão de salvar
		if(qtde=="") {
			cbeGetElementById("botSalvar").disabled = true;
			return;
		}

		//Habilitar botão de salvar
		cbeGetElementById("botSalvar").disabled = false;

		//Fecha todos para abrir novamente
		fecharTodas();
		
		//Abre a quantidade solicitada
		for(i=1; i<=total; i++) {
			eval("cbeGetElementById('tr" + i + "').style.display='block'");
		}

	}
	
	function salvar() {
		var frm = cbeGetElementById("frmcadastrar");
		
		var vbanco, vcheque, vdata, vvalor;
		
		for(i=1; i<=parseInt(qtde); i++) {
			eval("vbanco = cbeGetElementById('banco"+i+"')");
			eval("vcheque = cbeGetElementById('num"+i+"')");
			eval("vdata = cbeGetElementById('data"+i+"')");
			eval("vvalor = cbeGetElementById('valor"+i+"')");
			
			if(vbanco.value == "") {
				alert("Digite o número do banco do " + i + "º cheque.");
				vbanco.focus();
				return;
			}

			if(vcheque.value == "") {
				alert("Digite o número do " + i + "º cheque.");
				vcheque.focus();
				return;
			}

			if(vdata.value == "") {
				alert("Digite a data do " + i + "º cheque.");
				vdata.focus();
				return;
			}

			if(vvalor.value == "") {
				alert("Digite o valor do " + i + "º cheque.");
				vvalor.focus();
				return;
			}
			
		}
		
		frm.action += "&gravar=sim";
		frm.submit();
	}
</script>
</head>

<body onLoad="inicializar()">
<form name="frmcadastrar" id="frmcadastrar" action="cheques.jsp?cod=<%= cod%>" method="post">
  <table name="tabela" id="tabela" width="100%" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr>
      <td width="100%" height="18" class="title">.: Controle de Cheques :.</td>
    </tr>
	<tr style="height:30px">
		<td align="right"><span name='msg' id='msg' class="msg">&nbsp;</span></td>
	</tr>
    <tr align="center" valign="top">
      <td width="100%">
		<table cellpadding="0" cellspacing="0" width="90%" class="table">
			<tr>
				<td class="tdMedium">Qtde de cheques</td>
				<td class="tdLight">
					<select name="qtde" id="qtde" class="caixa" onChange="enviar(this.value)">
						<option value=""></option>
						<option value="1">1</option>
						<option value="2">2</option>
						<option value="3">3</option>
						<option value="4">4</option>
						<option value="5">5</option>
						<option value="6">6</option>
						<option value="7">7</option>
						<option value="8">8</option>
						<option value="9">9</option>
						<option value="10">10</option>
						<option value="11">11</option>
						<option value="12">12</option>
					</select>
				</td>
				<td class="tdMedium"><button name="botSalvar" id="botSalvar" type="button" class="botao" onClick="salvar()" disabled><img src="images/gravamini.gif">&nbsp;&nbsp;Salvar</button></td>
				<td class="tdMedium"><button type="button" class="botao" onClick="Javascript:self.close()"><img src="images/excluir.gif">&nbsp;&nbsp;&nbsp;Fechar</button></td>
			</tr>
		</table>
		<br>
		<table width="100%" cellpadding="0" cellspacing="0" class="table">
			<tr>
				<td width="46" class="tdMedium">Banco</td>
				<td width="40" class="tdMedium">Ordem</td>
				<td width="71" class="tdMedium">nº do cheque</td>
				<td width="76" class="tdMedium">Data</td>
				<td width="63" class="tdMedium">Valor</td>
				<td class="tdMedium">Comp.</td>
			</tr>
		</table>
		<%
				for(int i=1; i <= 12; i++) {
		%>
		<div id="tr<%= i%>" style="display:'none'">
		<table width="100%" cellpadding="0" cellspacing="0" class="table">			
			<tr>
				<td width="42" class="tdLight"><input type="text" name="banco<%= i%>" id="banco<%= i%>" class="caixa" size="5" maxlength="3"></td>
				<td width="38" class="tdLight"><input type="text" name="ordem<%= i%>" id="ordem<%= i%>" class="caixa" size="4" maxlength="5"></td>
				<td width="70" class="tdLight"><input type="text" name="num<%= i%>" id="num<%= i%>" class="caixa" size="9" maxlength="8"></td>
				<td width="75" class="tdLight"><input type="text" name="data<%= i%>" id="data<%= i%>" class="caixa" size="10" onKeyPress="return formatar(this, event, '##/##/####'); " maxlength="10"></td>
				<td width="70" class="tdLight"><input type="text" name="valor<%= i%>" id="valor<%= i%>" class="caixa" size="8" onKeyPress="return somenteNumeros(event)"></td>
				<td class="tdLight" align="center"><input type="checkbox" name="comp<%= i%>" id="comp<%= i%>" value="true"></td>
			</tr>
		</table>
		</div>
		<%
			}
		%>
		</table>
	  </td>
    </tr>
  </table>
</form>

</body>
</html>
