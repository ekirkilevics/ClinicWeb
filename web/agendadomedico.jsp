<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.AgendadoMedico" id="agenda" scope="page"/>

<%
	//Se receber parâmetros, usá-los, senão, considerar vazio
	String Smes = request.getParameter("mes") != null ? request.getParameter("mes") : "";
	String Sano = request.getParameter("ano") != null ? request.getParameter("ano") : "";
	String prof_reg_logado = banco.getProfissional((String)session.getAttribute("usuario"));
	String prof_reg = request.getParameter("prof_reg") != null ? request.getParameter("prof_reg") : prof_reg_logado;
	String profissional = request.getParameter("profissional") != null ? request.getParameter("profissional") : "";	
	int mes, ano;
	
	if(Smes.equals("") || Sano.equals(""))
	{
		GregorianCalendar hoje = new GregorianCalendar();
		mes = hoje.get(Calendar.MONTH)+1;
		ano = hoje.get(Calendar.YEAR);
	}
	else
	{
		mes = Integer.parseInt(Smes);
		ano = Integer.parseInt(Sano);
	}

%>

<html>
<head>
<title>Agenda</title>
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
<script language="JavaScript">

     //id
     var idReg = "<%= strcod%>";
	 //Informação vinda de gravarprocedimento
	 var inf = "<%= inf%>";
	 //Nome dos campos
	 var nome_campos_obrigatorios = Array("Registro do Profissional");
	 //Página a enviar o formulário
	 var page = "gravaragendadomedico.jsp";
	 //Cod. da ajuda
	 cod_ajuda = 18;

     //Campos obrigatórios
	 var campos_obrigatorios = Array("prof_reg");

	 function proximo()
	 {
		 var frm = cbeGetElementById("frmcadastrar");
		 mes = "<%= mes+1%>";
 		 ano = "<%= ano%>";
		 if(mes=="13") { mes="1"; ano=parseInt(ano)+1; }
		 if(idReg=="null") idReg = "";
		 frm.action = "agendadomedico.jsp?mes=" + mes + "&ano=" + ano;
		 frm.submit();
	 }

	 function anterior()
	 {
		 var frm = cbeGetElementById("frmcadastrar");
		 mes = "<%= mes-1%>";
 		 ano = "<%= ano%>";
		 if(mes=="0") { mes="12"; ano=parseInt(ano)-1; }
		 if(idReg=="null") idReg = "";
		 frm.action = "agendadomedico.jsp?mes=" + mes + "&ano=" + ano;
		 frm.submit();
	 }
	 
	 function detalheAgenda(d, m, a)
	 {
		 var cod_prof = getObj("","prof_reg").value;
		 if(cod_prof == "")
		 	alert("Selecione o Profissional para abrir sua agenda");
		 else
			eval("window.open('detalheagendamedico.jsp?dia=" + d + "&mes=" + m + "&ano=" + a + "&prof_reg=" + cod_prof + "','popup','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,menubar=no,width=650,height=420,top=50,left=50');")
	 }
	 
	 function recarregar()
	 {
	 	var frm = cbeGetElementById("frmcadastrar");
		frm.submit();
	 }
	 
	 function setarValores()
	 {
	 	getObj("","prof_reg").value = "<%= prof_reg%>";
	 }
	 
	 function iniciar() {
	 	setarValores();
		barrasessao();
	 }

</script>
</head>

<body onLoad="iniciar()">
<%@include file="barrasessao.jsp" %>
<form name="frmcadastrar" id="frmcadastrar" action="agendadomedico.jsp" method="post">
  <table width="600" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr>
      <td width="651" height="18" class="title">.: Agenda do Médico :.</td>
    </tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td width="100%">
        	<table cellpadding="0" cellspacing="0" width="100%">
            	<tr>
                    <td class="texto" width="33%">
						<font color="#999999">[Aguarda atendimento]</font><br>
                        <font color="green">[Já foi atendido]</font><br>
                  </td>
                  <td class="texto" align="left" width="33%">
	                    <font color="red">[N&atilde;o chegou]</font><br>
                        <font color="blue">[Agendas em aberto]</font><br>
                  </td>
                    <td class="texto">
                    	<img src="images/30.gif">Sem mais horários
                    </td>
                </tr>
            </table>	
	</tr>
    <tr align="center" valign="top">
      <td>
	  		<table width="100%" border="0" cellpadding="0" cellspacing="0" class="table">
				<tr>
					<td width="100" class="tdMedium">Profissional:</td>
					<td colspan="2" class="tdLight">
						<select name="prof_reg" id="prof_reg" class="caixa" style="width:250px" onChange="recarregar()">
							<option value=""></option>
							<%= agenda.getProfissionais(cod_empresa)%>
						</select>
					</td>
				</tr>
				<tr>
					<td width="100" class="tdLight" align="center"><a href="Javascript:anterior()" title="Mês Anterior"><img src="images/setaabre.gif" border="0"></a></td>
					<td width="400" class="tdLight" align="center"> <%= agenda.mesExtenso(mes)%>  /  <%= ano%></td>
					<td width="100" class="tdLight" align="center"><a href="Javascript:proximo()" title="Mês Posterior"><img src="images/setafecha.gif" border="0"></a></td>
				</tr>
				<tr>
					<td colspan="3" class="tdLight">
						<%= agenda.montaCalendario(mes, ano, "detalheagenda", prof_reg)%>
					</td>
				</tr>
			</table>
	  </td>
    </tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
  </table>
</form>

</body>
</html>
