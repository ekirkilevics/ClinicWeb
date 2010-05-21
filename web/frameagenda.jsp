<%@include file="cabecalho.jsp" %>
<%@ page import="java.util.Vector" %>

<jsp:useBean class="recursos.Agenda" id="agenda" scope="page"/>

<%
	String prof_logado = banco.getProfissional((String)session.getAttribute("usuario"));
%>

<html>
<head>
<link href="css/css.css" rel="stylesheet" type="text/css">
<META HTTP-EQUIV="Refresh" CONTENT="10">
<META HTTP-EQUIV="expires" CONTENT="0">

<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
<script language="javascript">

		 var prof_logado = "<%= prof_logado%>";
		 function abrirAgendaMedico() {
			 if(prof_logado != "") {
				hoje = new Date();
				d = hoje.getDate();
				m = hoje.getMonth() + 1;
				a = hoje.getFullYear();

				eval("ppagendamedico = window.open('detalheagendamedico.jsp?dia=" + d + "&mes=" + m + "&ano=" + a + "&prof_reg=" + prof_logado + "','ppagendamedico','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,menubar=no,width=650,height=420,top=50,left=50');")
			}
		 }

		function verHistoricos(codcli, cod_balcao) {
			var frames = window.parent.frames;
			alert(frames.title);
			pai.location = "historicopac.jsp?codcli=" + codcli + "&cod_balcao=" + cod_balcao;
		}			

</script>

</head>

<body LEFTMARGIN=0 TOPMARGIN=0 MARGINWIDTH=0 MARGINHEIGHT=0 style="background-image:  url(images/fundomenu.jpg); overflow-x: 'hidden'">
<center>
<table width="95%" height="95%" style="border: 1px solid #E8EFF7" cellpadding="0" cellspacing="0">
	<tr>
		<td  height="20" class="texto" style="background-color:#E8EFF7" valign="middle">
			<a href="Javascript:abrirAgendaMedico()" title="Abre agenda do médico em nova janela"><img id="agendamedico" src="images/17.gif" border="0" width="20"></a>
        </td>
        <td width="100%" class="texto" style="background-color:#E8EFF7; padding-left:4px" valign="middle">
            <b style="color:#009966; font-size:9px"> Agenda do Dia</b>
		</td>
	</tr>
	<tr>
		<td colspan="2" height="100%" style="background-color:white" valign="top">
			<%= agenda.montaAgendaMedicoFrame(prof_logado)%>
		</td>
	</tr>
</table>
</center>
</body>
</html>
