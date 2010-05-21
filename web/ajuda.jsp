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
					<td colspan="2" class="tdDark" align="center"><b>Sequência de Configuração do Clinic Web</b></td>
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
						Cadastrar todos os grupos de procedimentos que são agendados na clínica/consultório. Esses grupos aparecerão para o agendamento de pacientes e agruparão  os procedimentos de pagamento.
						Adeque os nomes à necessidade da clínica/consultório						
					</td>
				</tr>
				<tr>
					<td class="tdMedium">Especialidades</td>
					<td class="tdLight">
						<b>Menu->Cadastros->Especialidades</b><br>
						Cadastrar as especialidades que a clínica/consultório possui.
					</td>
				</tr>
				<tr>
					<td class="tdMedium">Procedimetos</td>
					<td class="tdLight">
						<b>Menu->Cadastros->Procedimentos</b><br>
						Cadastrar os procedimentos que a clínica/consultório realiza. <br>
						Código: não use pontos ou espaços. Esse código será usado nas guias do TISS<br>
						Procedimento: é o nome do procedimento que é efetuado e será impresso nas guias do TISS. Não use nomes repetidos para não confundir em outros ocais do sistema<br>
						Especialidade: especialidade que o procedimento é vinculado<br>
						Grupo de Procedimento: escolha o grupo que esse procedimento pertence. Isso é importante para que a agenda consiga fazer o atendimento e geração das guias.<br>
						Tipo de Guia: guia que o procedimento gera<br>
						Gera Laudo: se esse procedimento gera algum tipo de laudo para consulta pela internet (sistema à parte)<br>
						Status: colocar como ativo se o procedimento ainda é executado ou inativo se não estiver mais sendo realizado
					</td>
				</tr>
				<tr>
					<td class="tdMedium">Planos de Convênios</td>
					<td class="tdLight">
						<b>Menu->Cadastros->Convênios</b><br>
						Para cada um dos convênios que a clínica/consultório atende, inserir quais os planos que atende. Esse procedimento é necessário para lançamentos dos valores
					</td>
				</tr>
				<tr>
					<td class="tdMedium">Profissionais</td>
					<td class="tdLight">
						<b>Menu->Cadastros->Profissionais</b><br>
						Cadastrar os profissionais que atendem na clínica. Nessa tela também podem ser cadastrados os médicos externos (solicitantes). 
					</td>
				</tr>
				<tr>
					<td class="tdMedium">Valores</td>
					<td class="tdLight">
						<b>Menu->Cadastros->Valores</b><br>
						Lançar os valores de cada procedimento para os planos dos convênios, assim como taxa de aluguel, materiais e medicamentos se for o caso.
					</td>
				</tr>
				<tr>
					<td class="tdMedium">Agenda do Médico</td>
					<td class="tdLight">
						<b>Menu->Cadastros->Configurar Agenda</b><br>
						Cadastrar os procedimentos e horários que cada médico atende na clínica/consultório. Esse procedimento é necessário para o agendamento dos pacientes.
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
