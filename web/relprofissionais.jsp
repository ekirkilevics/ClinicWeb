<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.Relatorio" id="relatorio" scope="page"/>

<html>
<head>
<title>Fichas de Atendimento</title>
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
</head>

<body onLoad="barrasessao();">
<%@include file="barrasessao.jsp" %>
<form name="frmcadastrar" id="frmcadastrar" action="relprofissionais2.jsp" method="post" target="_blank">
  <table width="600" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr> 
      <td height="18" class="title">.: Relatório: Profissionais :.</td>
    </tr>
    <tr> 
      <td>&nbsp;</td>
    </tr>
    <tr style="height:25px"> 
      <td align="right"><span name='msg' id='msg' class="msg">&nbsp;</span></td>
    </tr>
    <tr align="center" valign="top"> 
      <td> <table width="600" border="0" cellpadding="0" cellspacing="0" class="table">
          <tr> 
            <td class="tdMedium">Nome do Profissional:</td>
            <td class="tdLight"><input type="text" class="caixa" name="profissional" id="profissional" size="40"></td>
			<td class="tdMedium">Tipo de Comparação:</td>
			<td class="tdLight">
				<select name="tipo" id="tipo" class="caixa">
					<option value="3">Meio</option>
					<option value="1">Exata</option>
					<option value="2">Início</option>							
				</select>
			</td>
          </tr>
		  <tr>
			<td class="tdMedium">Especialidade:</td>
			<td class="tdLight">
				<select name="especialidade" id="especialidade" class="caixa" style="width:220px">
					<option value="todos">Todas</option>
					<%= relatorio.getEspecialidades(cod_empresa) %>
				</select>
			</td>
			<td class="tdMedium">Situação:</td>
			<td class="tdLight">
				<select name="locacao" id="locacao" class="caixa">
					<option value="todos">Todas</option>
					<option value="interno">Interno</option>
					<option value="externo">Externo</option>
				</select>
			</td>
		 </tr>
		 <tr>
		  	<td colspan="5" class="tdMedium" style="text-align:right"><input type="submit" class="botao" value="Pesquisar">&nbsp;</td>
		  </tr>
        </table></td>
    </tr>
  </table>
</form>

</body>
</html>
