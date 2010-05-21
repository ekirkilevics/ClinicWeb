<%@include file="cabecalho.jsp" %>
<%@page import="java.util.Vector" %>

<jsp:useBean class="recursos.Relatorio" id="relatorio" scope="page"/>

<%			
	String profissional  = request.getParameter("profissional");
	int tipomatch = Integer.parseInt(request.getParameter("tipo"));
	String especialidade = request.getParameter("especialidade");
	String locacao = request.getParameter("locacao");

		
%>
<html>
<head>
<title>Relatório de Profissionais</title>
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
<script language="JavaScript">
	function view(num)
	{
		eval("status=cbeGetElementById('tr"+num+"').style.display");
		if(status=="none") {
			eval("cbeGetElementById('tr"+num+"').style.display = 'block'");
			eval("cbeGetElementById('img"+num+"').src = 'images/minus.png'");
		}
		else {
			eval("cbeGetElementById('tr"+num+"').style.display = 'none'");
			eval("cbeGetElementById('img"+num+"').src = 'images/plus.png'");
		}
	}

	function closeAll()
	{
		var cont=1;
		var obj = null;
		var valor_total = cbeGetElementById("qtdetotal").value;
		for(i=1; i<valor_total; i++) {
			eval("cbeGetElementById('tr"+i+"').style.display = 'none'");
			eval("cbeGetElementById('img"+i+"').src = 'images/plus.png'");
		}
	}

	function openAll()
	{
		var cont=1;
		var obj = null;
		var valor_total = cbeGetElementById("qtdetotal").value;
		for(i=1; i<valor_total; i++) {
			eval("cbeGetElementById('tr"+i+"').style.display = 'block'");
			eval("cbeGetElementById('img"+i+"').src = 'images/minus.png'");
		}
	}
	

</script>
</head>

<body style="background-color:white" onLoad="closeAll()">
	<center>
	<b><pre class="texto" style="text-align:center"><%= configuracao.getItemConfig("cabecalho", cod_empresa) %></pre></b>
	<br>
	<div class="texto"><b>Relatório de Profissionais</b></div>	
	<div>
			<a title="Fechar todas" href="JavaScript:closeAll()"><img src="images/close.gif" border="0"></a>&nbsp;
			<a title="Abrir todas" href="Javascript:openAll()"><img src="images/open.gif" border="0"></a>&nbsp;
			<a title="Imprimir" href="Javascript:self.print()"><img src="images/botprint.gif" border="0"></a>&nbsp;
	</div>
	<br>
	<form name="frmcadastrar" id="frmcadastrar" action="#" method="post">
	<table width="98%" border="0" cellpadding="0" cellspacing="0" style="background-color:white;border: 0px;">
		<tr>
			<td width="100%">
	<%
		//out.println("Profissional=" + profissional + ", tipo=" + tipomatch + ", especialidade=" + especialidade + ", situacao=" + locacao);
		Vector resp = relatorio.getProfissionais(profissional, tipomatch, especialidade, locacao, cod_empresa);
		for(int i=0; i<resp.size(); i++)
			out.println(resp.get(i).toString());
	%>
			</td>
		</tr>
	</table>
	</form>
	<br>
	</center>
</body>
</html>
