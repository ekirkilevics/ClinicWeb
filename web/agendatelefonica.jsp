<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.AgendaTelefonica" id="agenda" scope="page"/>

<%
	if(strcod != null) rs = banco.getRegistro("agendatelefonica","cod_agenda", Integer.parseInt(strcod) );
	if(Util.isNull(ordem)) ordem = "nome";
%>

<html>
<head>
<title>Agenda Telefônica</title>
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
	 var nome_campos_obrigatorios = Array("Nome", "DDD", "Telefone");
	 //Página a enviar o formulário
	 var page = "gravaragendatelefonica.jsp";
     //Campos obrigatórios
	 var campos_obrigatorios = Array("nome", "ddd1", "tel1");
	 
 	function clickBotaoNovo() {
		botaoNovo();
	}
	
	function clickBotaoSalvar() {
		enviarAcao('inc');
	}
	
	function clickBotaoExcluir() {
		enviarAcao('exc');
	}
	 

</script>
</head>

<body onLoad="inicio();">
<form name="frmcadastrar" id="frmcadastrar" action="gravaragendatelefonica.jsp" method="post">
  <table width="600" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr>
      <td width="651" height="18" class="title">.: Agenda Telefônica :.</td>
    </tr>
	<tr>
		<td align="right"><span name='msg' id='msg' class="msg">&nbsp;</span></td>
	</tr>
    <tr align="center" valign="top">
      <td>
          <table width="100%" border="0" cellpadding="0" cellspacing="0" class="table">
            <tr>
	            <td class="tdMedium">Nome: *</td>
              	<td class="tdLight" colspan="3"><input name="nome" type="text" class="caixa" id="nome" value="<%= banco.getCampo("nome", rs) %>" size="102" maxlength="80"></td>
            </tr>
            <tr>
	            <td class="tdMedium">Rua: </td>
              	<td class="tdLight" colspan="3"><input name="logradouro" type="text" class="caixa" id="logradouro" value="<%= banco.getCampo("logradouro", rs) %>" size="102" maxlength="100"></td>
            </tr>
            <tr>
	            <td class="tdMedium">Número: </td>
              	<td class="tdLight"><input name="numero" type="text" class="caixa" id="numero" value="<%= banco.getCampo("numero", rs) %>" size="10" maxlength="10"></td>
	            <td class="tdMedium">Bairro: </td>
              	<td class="tdLight"><input name="bairro" type="text" class="caixa" id="bairro" value="<%= banco.getCampo("bairro", rs) %>" size="66" maxlength="50"></td>
            </tr>
            <tr>
	            <td class="tdMedium">CEP: </td>
              	<td class="tdLight"><input name="cep" onKeyPress="return formatar(this, event, '########');" type="text" class="caixa" id="cep" value="<%= banco.getCampo("cep", rs) %>" size="10" maxlength="8"></td>
              	<td class="tdMedium">Complemento: </td>
              	<td class="tdLight"><input name="complemento" type="text" class="caixa" id="complemento" value="<%= banco.getCampo("complemento", rs) %>" size="66" maxlength="50"></td>
            </tr>
            <tr>
	            <td class="tdMedium">Estado: </td>
              	<td class="tdLight"><%= Util.getUF(banco.getCampo("estado", rs))  %></td>
	            <td class="tdMedium">Cidade: </td>
              	<td class="tdLight"><input name="cidade" type="text" class="caixa" id="cidade" value="<%= banco.getCampo("cidade", rs) %>" size="66" maxlength="50"></td>
            </tr>
            <tr>
	            <td class="tdMedium">e-mail: </td>
              	<td class="tdLight" colspan="3"><input name="email" type="text" class="caixa" id="email" value="<%= banco.getCampo("email", rs) %>" size="102" maxlength="80"></td>
            </tr>
            <tr>
	            <td class="tdMedium">DDD: *</td>
            	<td colspan="3">
                	<table cellpadding="0" cellspacing="0" width="100%">
                    	<tr>
                            <td class="tdLight"><input name="ddd1" type="text" class="caixa" id="ddd1" value="<%= banco.getCampo("ddd1", rs) %>" size="2" maxlength="2" onKeyPress="Javascript:OnlyNumbers(this,event);"></td>
                            <td class="tdMedium" width="100">Telefone: *</td>
                            <td class="tdLight"><input name="tel1" type="text" class="caixa" id="tel1" value="<%= banco.getCampo("tel1", rs) %>" size="8" maxlength="8" onKeyPress="Javascript:OnlyNumbers(this,event);"></td>
                            <td class="tdMedium">Contato:</td>
                            <td class="tdLight"><input name="contato1" type="text" class="caixa" id="contato1" value="<%= banco.getCampo("contato1", rs) %>" size="40" maxlength="50"></td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
	            <td class="tdMedium">DDD:</td>
            	<td colspan="3">
                	<table cellpadding="0" cellspacing="0" width="100%">
                    	<tr>
                            <td class="tdLight"><input name="ddd2" type="text" class="caixa" id="ddd2" value="<%= banco.getCampo("ddd2", rs) %>" size="2" maxlength="2" onKeyPress="Javascript:OnlyNumbers(this,event);"></td>
                            <td class="tdMedium" width="100">Telefone:</td>
                            <td class="tdLight"><input name="tel2" type="text" class="caixa" id="tel2" value="<%= banco.getCampo("tel2", rs) %>" size="8" maxlength="8" onKeyPress="Javascript:OnlyNumbers(this,event);"></td>
                            <td class="tdMedium">Contato:</td>
                            <td class="tdLight"><input name="contato2" type="text" class="caixa" id="contato2" value="<%= banco.getCampo("contato2", rs) %>" size="40" maxlength="50"></td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
	            <td class="tdMedium">DDD:</td>
            	<td colspan="3">
                	<table cellpadding="0" cellspacing="0" width="100%">
                    	<tr>
                            <td class="tdLight"><input name="ddd3" type="text" class="caixa" id="ddd3" value="<%= banco.getCampo("ddd3", rs) %>" size="2" maxlength="2" onKeyPress="Javascript:OnlyNumbers(this,event);"></td>
                            <td class="tdMedium" width="100">Telefone:</td>
                            <td class="tdLight"><input name="tel3" type="text" class="caixa" id="tel3" value="<%= banco.getCampo("tel3", rs) %>" size="8" maxlength="8" onKeyPress="Javascript:OnlyNumbers(this,event);"></td>
                            <td class="tdMedium">Contato:</td>
                            <td class="tdLight"><input name="contato3" type="text" class="caixa" id="contato3" value="<%= banco.getCampo("contato3", rs) %>" size="40" maxlength="50"></td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
	            <td class="tdMedium">OBS: </td>
              	<td class="tdLight" colspan="3"><textarea name="obs" id="obs" class="caixa" rows="3" style="width:100%"><%= banco.getCampo("obs", rs) %></textarea></td>
            </tr>
          </table>
      </td>
    </tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<%= Util.getBotoes("agendatelefonica", pesq, tipo) %>
	<tr>
		<td>&nbsp;</td>
	</tr>
    <tr>
		<td width="100%" style="text-align:center">
			<table width="600px">
				<tr>
					<td width="100%" class="tdDark">Nomes</td>
				</tr>
			</table>
			<div style="width:600; height:101; overflow: auto">
				<table width="100%">
				    <%
						String resp[] = agenda.getAgendas(pesq, ordem, numPag, 50, tipo, cod_empresa);
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
