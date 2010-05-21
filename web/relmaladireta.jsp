<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.Relatorio" id="relatorio" scope="page"/>


<html>
<head>
<title>Mala Direta</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
<script language="JavaScript" src="js/ajax.js"></script>
<script language="JavaScript">
     //id do convênio
     var idReg = "<%= strcod%>";

	 function enviarForm(tipo) {
		var frm = cbeGetElementById("frmcadastrar");
		frm.action += "?forma=" + tipo;
		
		if(tipo == "1")
			alert("As etiquetas serão geradas para pacientes que possuem endereço completo");
		else if(tipo == "2")
			alert("Os e-mails só serão enviados para os pacientes que possuem e-mail cadastrado corretamente");
		else if(tipo == "3")
			alert("As mensagens só serão enviadas para os pacientes que possuem número de celular cadastrado, incluindo DDD");

		barrasessao();	
		frm.submit();
	 }

</script>
</head>

<body onLoad="barrasessao();hideAll();">
<%@include file="barrasessao.jsp" %>
<%@include file="barraajax.jsp" %>
<form name="frmcadastrar" id="frmcadastrar" action="relmaladireta2.jsp" method="post" target="_blank">
  <table width="600" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr>
      <td height="18" class="title">.: Relatório: Mala Direta:.</td>
    </tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr style="height:25px">
		<td align="right"><span name='msg' id='msg' class="msg">&nbsp;</span></td>
	</tr>
    <tr align="center" valign="top">
      <td>
         <table width="500" border="0" cellpadding="0" cellspacing="0" class="table">
			<tr>
            	<td colspan="2" class="tdMedium" align="center"><strong>Filtros</strong></td>
            </tr>
			<tr>
				<td  width="50" class="tdMedium">Mês de Nascimento:</td>
				<td class="tdLight">
					<select name="mes" id="mes" class="caixa">
						<option value="">Todos</option>
						<option value="1">Janeiro</option>
						<option value="2">Fevereiro</option>
						<option value="3">Março</option>
						<option value="4">Abril</option>
						<option value="5">Maio</option>
						<option value="6">Junho</option>
						<option value="7">Julho</option>
						<option value="8">Agosto</option>
						<option value="9">Setembro</option>
						<option value="10">Outubro</option>
						<option value="11">Novembro</option>
						<option value="12">Dezembro</option>
					</select>
				</td>
			</tr>
			<tr>
				<td class="tdMedium">Última Consulta:</td>
				<td class="tdLight">
					Últimos <input type="text" class="caixa" name="meses" id="meses" value="6" size="5"> meses
				</td>
			</tr>
	       <tr>
              <td class="tdMedium">Convênio:</td>
              <td class="tdLight">
					<input type="hidden" name="cod_convenio" id="cod_convenio">			
					<input style="width:300" class="caixa" type="text" name="descr_convenio" id="descr_convenio" onKeyUp="busca(this.value, 'cod_convenio', 'descr_convenio','convenio','AND ativo=\'S\'')">
 			  </td>
            </tr>
	       <tr>
              <td class="tdMedium">Diagnóstico:</td>
              <td class="tdLight">
					<input type="hidden" name="cod_diag" id="cod_diag">			
					<input style="width:100%" class="caixa" type="text" name="DESCRICAO" id="DESCRICAO" onKeyUp="buscadiagnosticos(this.value, '')">
 			  </td>
            </tr>
	       <tr>
              <td class="tdMedium">Médico Responsável:</td>
              <td class="tdLight">
				<select name="prof_reg" id="prof_reg" class="caixa">
					<option value="">Todos</option>
					<%= relatorio.getProfissionais( cod_empresa)%>
				</select>
 			  </td>
            </tr>
			<tr>
				<td colspan="3" align="right">
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr>
							<td class="tdMedium" align="center"><button style="width:100px" type="button" class="botao" onClick="enviarForm(1)"><img src="images/5.gif">&nbsp;&nbsp;&nbsp;Mala Direta</button></td>
						</tr>
					</table>
				</td>
			</tr>
          </table>
		  <br>
		  <table width="500" cellpadding="0" cellspacing="0" class="table">
		  	<tr>
				<td class="tdMedium" width="100%">
					Configurações de Impressão das Etiquetas
				</td>
			</tr>
			<tr>
				<td class="tdLight">
					<li>Etiqueta padrão PIMACO 6180 (25,4 x 66,7 mm)</li>
					<li>10 linhas x 3 colunas = 30 etiquetas por página</li>
					<li>Margem superior: 12,5</li>
					<li>Margem inferior: 4,61</li>
					<li>Margem direita: 5</li>
					<li>Margem esquerda: 5</li>
					<li>Remover cabeçalho e rodapé</li>
				</td>
			</tr>
		  </table>
      </td>
    </tr>
  </table>
</form>

</body>
</html>
