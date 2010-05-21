<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.Historico" id="historico" scope="page"/>

<%  
   /* Retorna:  [0]: Nome do paciente
                [1]: Código do paciente
                [2]: Nome do profissional
                [3]: Registro do profissional
                [4]: Data da Consulta
                [5]: Hora da Consulta
                [6]: História
				[7]: Definitiva
				[8]: História Resumo 
	*/
	String historia[] = {"","","","","","","","",""};
	String endereco = "";
	
	try {
		if(strcod != null) {
				historia = historico.getHistorico(strcod);
				endereco = banco.getValor("endereco", "SELECT CONCAT(if(nome_logradouro IS NULL, '', nome_logradouro), ', ', if(numero IS NULL,' ', numero), ', ', if(complemento IS NULL, ' ', complemento), ', ', if(bairro IS NULL, ' ', bairro), ', ', if(cidade IS NULL, ' ', cidade)) AS endereco FROM paciente WHERE codcli=" + historia[1]);
		}
	}
	catch(Exception e) {
		out.println(e.toString());
	}

%>

<html>
<head>
<title>..:: História do Paciente ::..</title>
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
<script language="JavaScript" type="text/javascript" src="js/html2xhtml.js"></script>
<script language="JavaScript" type="text/javascript" src="js/richtext.js"></script>

<script language="JavaScript">
     //id
     var idReg = "<%= strcod%>";
	 //Informação vinda de gravarprocedimento
	 var inf = "<%= inf%>";
	 //Nome dos campos
	 var page = "gravarhistoricopac.jsp";
     //Campos obrigatórios
	 var campos_obrigatorios = Array("solicitante", "data","hora");
	 
	 var nome, idade, nascimento, convenio;
	 
	 var msgbtn;
	 
	function travar()
	{
		barraStatus();
		window.defaultStatus = "..:: Clinic Web ::.."
		
		//Valores da tela debaixo
		nome = window.opener.document.frmcadastrar.nome.value;
		idade = window.opener.document.frmcadastrar.idade.value;		
		nascimento = window.opener.document.frmcadastrar.nascimento.value;
		convenio = window.opener.document.frmcadastrar.nomeconvenio.value;
		
		cbeGetElementById("nome").innerHTML = nome + " ( " + nascimento + " ) - " + idade;
		cbeGetElementById("convenio").innerHTML = convenio;

	}
	
	function imprimir()
	{
		self.print();
		self.close();
	}
</script>
</head>

<body onLoad="travar();" style='background-color:white'>
<form name="frmcadastrar" id="frmcadastrar" action="gravarhistoricopac.jsp" method="post">
  <input type="hidden" name="codcli" id="codcli" value="<%= historia[1]%>">
  <table width="780" border="0" align="center" cellpadding="0" cellspacing="0">
    <tr align="center" valign="top">
      <td>
	  		<table width="100%" border="0" cellpadding="0" cellspacing="0" class="table">
				<tr>
					<td class="tdMedium">Paciente: </td>
					<td class="tdLight"><b><%= historia[0]%></b></td>
					<td colspan="2" align="right" class="tdMedium"><a href="Javascript:imprimir()"><img src="images/print.gif" border="0"></a></td>
				</tr>
				<tr>
					<td class="tdMedium">Endereço:</td>
					<td colspan="3" class="tdLight"><%= endereco%>&nbsp;</td>
				</tr>
				<tr>
					<td class="tdMedium">Data:</td>
					<td class="tdLight"><%= historia[4]%></td>
					<td class="tdMedium">Hora:</td>
					<td class="tdLight"><%= historia[5]%></td>
				</tr>
				<tr>
					<td class="tdMedium">Profissional:</td>
					<td colspan="3" class="tdLight"><%= historia[2]%></td>
				</tr>
				<tr>
					<td colspan="4" width="100%">
						<table width="100%" border="0" cellpadding="0" cellspacing="0">
							<tr>
								<td class="tdMedium">Diagnósticos:</td>
								<td class="tdMedium">Procedimentos:</td>
								<td class="tdMedium">Medicamentos:</td>
							</tr>
							<tr>
								<td class="tdLight">
										<%= historico.getDiagnosticos(strcod, historia[1], 2) %>
								</td>
								<td class="tdLight">
									<%= historico.getProcedimentos(strcod,2) %>
								</td>
								<td  class="tdLight">
										<%= historico.getMedicamentos(strcod, historia[1], 2) %>
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td colspan="4" class="tdMedium" style="text-align:center">História</td>
				</tr>
			</table>
			<table width="100%" cellpadding="0" cellspacing="0">
				<tr>
					<td width="100%" class='texto'><%= historia[6]%></td>
				</tr>
			</table>			
	  </td>
    </tr>
  </table>
</form>

</body>
</html>
