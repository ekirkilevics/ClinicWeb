<%@include file="cabecalho.jsp" %>

<html>
<head>
<title>Ajuda</title>
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
</head>

<body onload="barrasessao();">
<%@include file="barrasessao.jsp" %>
<form name="frmcadastrar" id="frmcadastrar" action="gravarmenu.jsp" method="post">
  <table width="600" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr>
      <td width="651" height="18" class="title">.: Ajuda :.</td>
    </tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr style="height:25px">
		<td align="right"><span name='msg' id='msg' class="msg">&nbsp;</span></td>
	</tr>
    <tr align="center" valign="top">
      <td width="100%" align="center">
			<table width="80%" cellpadding="0" cellspacing="0" class="table">
				<tr>
					<td colspan="2" class="tdDark" align="center"><b>Sequ�ncia de Configura��o do Clinic Web</b></td>
				</tr>
				<tr>
					<td class="tdMedium">Perfil da Empresa</td>
					<td class="tdLight">
						<b>Menu->Sistemas->Perfil da Empresa</b><br>
						Alterar os dados da empresa
					</td>
				</tr>
				<tr>
					<td class="tdMedium">Grupo de Procedimentos</td>
					<td class="tdLight">
						<b>Menu->Cadastros->Grupo de Procedimentos</b><br>
						Cadastrar todos os grupos de procedimentos que s�o agendados na cl�nica/consult�rio. Esses grupos aparecer�o para o agendamento de pacientes e agrupar�o  os procedimentos de pagamento.
						Adeque os nomes � necessidade da cl�nica/consult�rio						
					</td>
				</tr>
				<tr>
					<td class="tdMedium">Especialidades</td>
					<td class="tdLight">
						<b>Menu->Cadastros->Especialidades</b><br>
						Cadastrar as especialidades que a cl�nica/consult�rio possui.
					</td>
				</tr>
				<tr>
					<td class="tdMedium">Procedimetos</td>
					<td class="tdLight">
						<b>Menu->Cadastros->Procedimentos</b><br>
						Cadastrar os procedimentos que a cl�nica/consult�rio realiza. <br>
						C�digo: n�o use pontos ou espa�os. Esse c�digo ser� usado nas guias do TISS<br>
						Procedimento: � o nome do procedimento que � efetuado e ser� impresso nas guias do TISS. N�o use nomes repetidos para n�o confundir em outros ocais do sistema<br>
						Especialidade: especialidade que o procedimento � vinculado<br>
						Grupo de Procedimento: escolha o grupo que esse procedimento pertence. Isso � importante para que a agenda consiga fazer o atendimento e gera��o das guias.<br>
						Tipo de Guia: guia que o procedimento gera<br>
						Gera Laudo: se esse procedimento gera algum tipo de laudo para consulta pela internet (sistema � parte)<br>
						Status: colocar como ativo se o procedimento ainda � executado ou inativo se n�o estiver mais sendo realizado
					</td>
				</tr>
				<tr>
					<td class="tdMedium">Planos de Conv�nios</td>
					<td class="tdLight">
						<b>Menu->Cadastros->Conv�nios</b><br>
						Para cada um dos conv�nios que a cl�nica/consult�rio atende, inserir quais os planos que atende. Esse procedimento � necess�rio para lan�amentos dos valores
					</td>
				</tr>
				<tr>
					<td class="tdMedium">Profissionais</td>
					<td class="tdLight">
						<b>Menu->Cadastros->Profissionais</b><br>
						Cadastrar os profissionais que atendem na cl�nica. Nessa tela tamb�m podem ser cadastrados os m�dicos externos (solicitantes). 
					</td>
				</tr>
				<tr>
					<td class="tdMedium">Valores</td>
					<td class="tdLight">
						<b>Menu->Cadastros->Valores</b><br>
						Lan�ar os valores de cada procedimento para os planos dos conv�nios, assim como taxa de aluguel, materiais e medicamentos se for o caso.
					</td>
				</tr>
				<tr>
					<td class="tdMedium">Agenda do M�dico</td>
					<td class="tdLight">
						<b>Menu->Cadastros->Configurar Agenda</b><br>
						Cadastrar os procedimentos e hor�rios que cada m�dico atende na cl�nica/consult�rio. Esse procedimento � necess�rio para o agendamento dos pacientes.
					</td>
				</tr>
			</table>
      </td>
    </tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
  </table>
</form>

</body>
</html>
