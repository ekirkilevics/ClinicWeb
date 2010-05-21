<%@include file="cabecalho.jsp" %>

<%
	if(strcod != null) rs = banco.getRegistro("paciente","codcli", Integer.parseInt(strcod) );
%>

<html>
<head>
<title>Dados do Paciente</title>
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
	
</head>

<body>
	<center>
    <br>
	<table cellpadding="0" cellspacing="0" class="table"  width="95%">
		<tr>
			<td class="tdMedium" width="90">Paciente:</td>
            <td class="tdLight" style="color:#FF0000; background-color:#FFFFFF"><%= banco.getCampo("nome", rs) %>&nbsp;</td>
		</tr>
		<tr>
			<td class="tdMedium" width="90">nº registro:</td>
            <td class="tdLight" style="background-color:#FFFFFF"><%= Util.trataNulo(banco.getCampo("registro_hospitalar", rs),"N/C") %>&nbsp;</td>
		</tr>
		<tr>
			<td class="tdMedium" width="90">Nascimento:</td>
            <td class="tdLight" style="background-color:#FFFFFF"><%= Util.formataData(banco.getCampo("data_nascimento", rs)) %>&nbsp;</td>
		</tr>
		<tr>
			<td class="tdMedium">Idade:</td>
            <td class="tdLight" style="background-color:#FFFFFF"><%= Util.getIdade(Util.formataData(banco.getCampo("data_nascimento", rs))) %>&nbsp;</td>
		</tr>
		<tr>
			<td class="tdMedium">Tel. Residencial:</td>
            <td class="tdLight" style="background-color:#FFFFFF">(<%= Util.trataNulo(banco.getCampo("ddd_residencial", rs),"- -") %>) <%= Util.trataNulo(banco.getCampo("tel_residencial", rs),"") %></td>
		</tr>
		<tr>
			<td class="tdMedium">Tel. Celular:</td>
            <td class="tdLight" style="background-color:#FFFFFF">(<%= Util.trataNulo(banco.getCampo("ddd_celular", rs),"- -") %>) <%= Util.trataNulo(banco.getCampo("tel_celular", rs),"") %></td>
		</tr>
		<tr>
			<td class="tdMedium" width="90">Endereço:</td>
            <td class="tdLight" style="background-color:#FFFFFF"><%= Util.trataNulo(banco.getCampo("nome_logradouro", rs),"N/C") %>, <%= Util.trataNulo(banco.getCampo("numero", rs),"N/C") %></td>
		</tr>
		<tr>
			<td class="tdMedium" width="90">Bairro/Cidade:</td>
            <td class="tdLight" style="background-color:#FFFFFF"><%= Util.trataNulo(banco.getCampo("bairro", rs),"N/C") %>, <%= Util.trataNulo(banco.getCampo("cidade", rs),"N/C") %></td>
		</tr>
		<tr>
			<td class="tdMedium" width="90">e-mail:</td>
            <td class="tdLight" style="background-color:#FFFFFF"><%= Util.trataNulo(banco.getCampo("email", rs),"") %>&nbsp;</td>
		</tr>
		<tr>
			<td class="tdMedium" width="90">OBS:</td>
            <td class="tdLight" style="background-color:#FFFFFF"><%= Util.trataNulo(banco.getCampo("obs", rs),"") %>&nbsp;</td>
		</tr>
	</table>
    </center>
</body>
</html>
