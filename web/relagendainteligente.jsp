<%@include file="cabecalho.jsp" %>
<%@page import="java.util.Vector" %>

<jsp:useBean class="recursos.AgendaInteligente" id="agenda" scope="page"/>

<%
	String de  = !Util.isNull(request.getParameter("de")) ? request.getParameter("de") : "";
	String ate = !Util.isNull(request.getParameter("ate")) ? request.getParameter("ate") : "";
	String cod_proced = !Util.isNull(request.getParameter("cod_proced")) ? request.getParameter("cod_proced") : "";
%>

<html>
<head>
<title>Agenda Inteligente</title>
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
<script language="JavaScript">
	function validaForm() {
		var de = cbeGetElementById("de");
		var ate = cbeGetElementById("ate");
		var jscod_proced = cbeGetElementById("cod_proced");

		if(de.value == "") {
			mensagem("Preencha o início do período de consulta",2);
			de.focus();
			return false;
		}
		if(ate.value == "") {
			mensagem("Preencha o fim do período de consulta",2);
			ate.focus();
			return false;
		}
		if(jscod_proced.value == "") {
			mensagem("Escolha o procedimento a ser analisado",2);
			jscod_proced.focus();
			return false;
		}
		
		return true;
	}
	
	function iniciar() {
		var jscod_proced = cbeGetElementById("cod_proced");
		jscod_proced.value = "<%= cod_proced%>";
		SomarTotais();
		barrasessao();
	}
	
	function recalcular(obj) {
		//Id do convênio
		var jsnum = obj.id.substring(4);
		
		//Campos a alterar
		var jsabsproj = cbeGetElementById("absproj"+jsnum);
		var jsvalorproj = cbeGetElementById("valorproj"+jsnum);
		var jsporcproj = cbeGetElementById("porcproj"+jsnum);
		
		//Valores atuais para calcular
		var jsabsatua = cbeGetElementById("absatua"+jsnum).innerHTML;
		var jsporcorig = cbeGetElementById("orig" + jsnum).innerHTML;
		var jsvalor = cbeGetElementById("valor" + jsnum).innerHTML;

		//Novos valores
		var jsnovoabsoluto = (parseFloat(jsabsatua) * parseFloat(obj.value)) / parseFloat(jsporcorig);
		var jsnovovalor = parseFloat(jsvalor) * jsnovoabsoluto;

		//Atualizando tela
		jsabsproj.innerHTML = parseInt(jsnovoabsoluto);
		jsvalorproj.value = "R$ " + formatCurrency(jsnovovalor);

		SomarTotais();
		
		//Captura o valor total projetado
		var jsvalortotalproj = cbeGetElementById("totalvalor").value;
		jsvalortotalproj = jsvalortotalproj.substring(3);
		jsvalortotalproj = jsvalortotalproj.replace(".","");
		jsvalortotalproj = jsvalortotalproj.replace(",",".");
	
		//Calcula porcentagem atual do valor e atualiza tela
		var jsnovaporc = 100*parseFloat(jsnovovalor) /jsvalortotalproj;
		jsporcproj.innerHTML = arredondar(jsnovaporc,2);
		
	}
	
	function SomarTotais() {
		var frm = cbeGetElementById("frmcadastrar");
		var tam = frm.elements.length;
		var obj;
		var somaPorc = 0;
		var somaValor = 0;

		//Varre todos os itens do formulário 
    	for(var i=0;i<tam;i++)
		{
			//Pega objeto por objeto do formulário
			obj = frm[i];
			
			//Pega somente as porcentagens
			if(obj.id.length > 4 && obj.id.substring(0,4) == "porc")
			{
				somaPorc += parseFloat(obj.value);
			}
			//Pega somente os valores
			if(obj.id.length > 9 && obj.id.substring(0,9) == "valorproj")
			{
				//Pega valor sem cifrão
				auxvalor = obj.value.substring(3);
				
				//Tira o ponto de milhar
				auxvalor = auxvalor.replace(".","");
				
				//Troca a vírgula por ponto
				auxvalor = auxvalor.replace(",",".");
				
				somaValor += parseFloat(auxvalor);
			}
			
		}
		cbeGetElementById("totalporc").value = arredondar(somaPorc,2);
		cbeGetElementById("totalvalor").value = "R$ " + formatCurrency(somaValor);
		
	}	
	
	function salvarParametros() {
		alert("Ainda não implementado");
	}
</script>
</head>

<body onLoad="iniciar();">
<%@include file="barrasessao.jsp" %>
<form name="frmcadastrar" id="frmcadastrar" action="relagendainteligente.jsp" method="post" onSubmit="return validaForm()">
  <table width="600" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr> 
      <td height="18" class="title">.: Relatório Analítico :.</td>
    </tr>
    <tr style="height:25px"> 
      <td align="right"><span name='msg' id='msg' class="msg">&nbsp;</span></td>
    </tr>
    <tr align="center" valign="top"> 
      <td> 
	  	<table width="600" border="0" cellpadding="0" cellspacing="0" class="table">
          <tr>
		  	<td colspan="2" class="tdDark" align="center">Filtros</td>
		  </tr>
		  <tr> 
            <td class="tdMedium">Período:</td>
			<td class="tdLight">
				de <input type="text" name="de" id="de" class="caixa" value="<%= de %>" size="10" maxlength="10" onKeyPress="return formatar(this, event, '##/##/####'); " onBlur="ValidaData(this);">
				&nbsp;&nbsp;até&nbsp;&nbsp; <input type="text" name="ate" id="ate" class="caixa" value="<%= ate%>" size="10" maxlength="10" onKeyPress="return formatar(this, event, '##/##/####'); " onBlur="ValidaData(this);">
			</td>
		   </tr>
		   <tr>
		   		<td class="tdMedium">Grupo de Procedimento: *</td>
				<td class="tdLight">
					<select name="cod_proced" id="cod_proced" class="caixa">
						<option value=""></option>
						<%= agenda.getProcedimentos( cod_empresa )%>
					</select>
				</td>
		   </tr>
		   <tr>
			<td colspan="2" align="center" class="tdMedium">&nbsp;<input type="submit" class="botao" value="Pesquisar">&nbsp;</td>
		  </tr>
        </table></td>
    </tr>
  </table>
  <br>
	
<%
	if(!de.equals("") && !ate.equals("") && !Util.isNull(cod_proced)) {
		Vector resp = agenda.getValoresIntervalo(de, ate, cod_proced, cod_empresa);
		for(int i=0; i<resp.size(); i++)
				out.println(resp.get(i).toString());
	}
%>
</form>

</body>
</html>
