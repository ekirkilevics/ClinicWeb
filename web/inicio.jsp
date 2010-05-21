<%@include file="cabecalho.jsp" %>

<%
	String atualizacoes[] = Util.verificaAtualizacoes();
	String atual[] = new Atualizacao().getUltimaVersao();
	atualizacoes[0] = atualizacoes[0].replace(",", ".");
	
	//Guarda o controle de SMS e o parceiro em uma sessão
	session.setAttribute("sms", "N");
	session.setAttribute("parceiro", "0");
	
	//Dados da expiração da senha
	String qtdediasexpira = configuracao.getItemConfig("qtdediasexpirasenha", cod_empresa);
	String datasenha = Util.formataData(banco.getValor("dataalteracao", "SELECT dataalteracao FROM t_usuario WHERE cd_usuario=" + usuario_logado));
	String dataexpirasenha = Util.addDias(datasenha, Integer.parseInt(qtdediasexpira));

%>
<html>
<head>
<title>Início</title>
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
<script language="JavaScript">
	var xmlDoc = "";
	cod_ajuda = -1;

	//Função que calcula a diferença em dias de duas datas
	function difDatas(data1, data2)
	{
		//Separa dia, mês e ano
		d1 = data1.substring(0,2);
		m1 = data1.substring(3,5);
		a1 = data1.substring(6);

		//Separa dia,  mês e ano
		d2 = data2.substring(0,2);
		m2 = data2.substring(3,5);
		a2 = data2.substring(6);
			
		//Converte em objeto date
		data1 = new Date(a1,m1-1,d1);
		data2 = new Date(a2,m2-1,d2);
	
		//Calcula a diferença em dias
		var dif = (data2.getTime() - data1.getTime()) / (3600*24*1000);		

		return dif;
	}


	function iniciar() {
		var jsiframemensagem = cbeGetElementById("iframemensagem");

		//Verifica expiração da senha
		verificaExpiracaoSenha();
		
		//Inicia a barra de sessão
		barrasessao();

	}
	
	function atualizar() {
		alert("Para atualizar o sistema, o cliente precisa participar do 'Programa de Apoio' da KATU.\nPara ter acesso às atualizações, <%= contato%>");
	}


	function verificaExpiracaoSenha() {
		var dataexpirasenha = "<%= dataexpirasenha%>";
		var diferenca = parseInt(difDatas("<%= Util.getData()%>", dataexpirasenha));

		//Se tiver menos de 10 dias pra vencer, pop up
		if(diferenca <=10) {
			displayPopup("senhaexpirada.jsp?qtde=" + diferenca,"senhaexpirada",180,400);	
		}
	}
	
	
</script>

</head>

<body onLoad="iniciar()">
<bgsound src="sounds/bemvindo.wav">
<%@include file="barrasessao.jsp" %>
<br>
<br>
<center><img src="images/logo.gif"></center>
<form name="frmcadastrar" id="frmcadastrar" method="post" action="#">
	<center>
	<table cellpadding="0" cellspacing="0" border="0" class="table" width="600">
		<tr>
			<td colspan="2" class="tdDark" align="center"><b>Dados do Cliente</b></td>
		</tr>
		<tr>
			<td width="200" class="tdMedium">Cliente:</td>
			<td class="tdLight"><div id="nome">Open Source</div></td>
		</tr>
		<tr>
			<td class="tdMedium">Versão do Sistema:</td>
			
        <td class="tdLight"><%= atual[0]%></td>
		</tr>
		<tr>
			<td class="tdMedium">Validade da Licença:</td>
			<td class="tdLight"><div id="validade">Licença Open Source</div></td>
		</tr>
		<tr>
			<td class="tdMedium">Status do Envio de SMS:</td>
			<td class="tdLight"><div id="validade">Desabilitado</div></td>
		</tr>
		<tr>
			<td class="tdMedium">Contato:</td>
			<td class="tdLight">KATU - (11)3294-6268</td>
		</tr>
	</table>
	
	<br>
<%
	if(!atualizacoes[0].equals("no")) {
%>
		<table border="0" cellpadding="0" cellspacing="0" class="table" width="500">
			<tr>
				<td class="tdDark" colspan="3" align="center" style="background-color:#FF6464"><strong>Nova Versão Disponível</strong></td>
			</tr>
			<tr>
				<td width="200" class="tdMedium" style="background-color:#FFCCCC">Versão:</td>
				<td class="tdLight" style="background-color:#FFEAEA"><%= atualizacoes[0]%></td>
				<td rowspan="2" class="tdMedium" style="background-color:#FF6464" align="center" valign="middle"><button id="botAtualizar" name="botAtualizar" type="button" class="botao" onClick="atualizar()"><img src="images/4.gif">&nbsp;&nbsp;&nbsp;Atualizar</button></td>
			</tr>
			<tr>
				<td class="tdMedium" style="background-color:#FFCCCC">Data:</td>
				<td class="tdLight" style="background-color:#FFEAEA"><%= atualizacoes[1]%></td>
			</tr>
		</table>
		<br>
		<center><div id='imagem'>&nbsp;</div></center>
<%	
	}

%>
	<iframe id="iframemensagem" src="http://www.katusis.com.br/mensagem.asp" marginheight="0" marginwidth="0" frameborder="0" width="600" height="600"></iframe>
	</center>
</form> 

</body>
</html>
