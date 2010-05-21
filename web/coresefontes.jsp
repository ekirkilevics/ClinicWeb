<%@include file="cabecalho.jsp" %>

<html>
<head>
<title>Cores e Fontes do Sistema</title>
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
<script language="JavaScript">
     //id do convênio
     var idReg = "1";
	 //Depois que voltou do gravar
	 var inf = "<%= inf%>";
	 //Nome dos campos
	 var nome_campos_obrigatorios = Array();
	 //Página a enviar o formulário
	 var page = "gravarcoresefontes.jsp";
     //Campos obrigatórios
	 var campos_obrigatorios = Array();

	 var campocor = "";

	 function setColor(cor)
	 {
		cbeGetElementById(campocor).value = cor;
		cbeGetElementById("ex" + campocor).style.backgroundColor = cor;
		cbeGetElementById("cp").style.visibility = 'hidden';
	 }


	 function abrirPaleta(campo, evento)
	 {
		campocor = campo;
	 	var paleta = cbeGetElementById("cp");
		paleta.style.left = evento.clientX;
		paleta.style.top = evento.clientY;
		paleta.style.visibility = 'visible';
	 }
	 
	 function voltarPadrao()
	 {
		 cbeGetElementById("tddark").value = "#94AED6";
		 cbeGetElementById("extddark").style.backgroundColor = "#94AED6";
		 cbeGetElementById("tdmedium").value = "#ACC1DF";
		 cbeGetElementById("extdmedium").style.backgroundColor = "#ACC1DF";
		 cbeGetElementById("tdlight").value = "#EDF1F8";
		 cbeGetElementById("extdlight").style.backgroundColor = "#EDF1F8";
		 cbeGetElementById("fundo").value = "#E8EFF7";
		 cbeGetElementById("exfundo").style.backgroundColor = "#E8EFF7";
		 cbeGetElementById("cortitulo").value = "#003366";
		 cbeGetElementById("excortitulo").style.backgroundColor = "#003366";
		 cbeGetElementById("corfonte").value = "#222222";
		 cbeGetElementById("excorfonte").style.backgroundColor = "#222222";
		 cbeGetElementById("cormsg").value = "#FF0000";
		 cbeGetElementById("excormsg").style.backgroundColor = "#FF0000";
		 cbeGetElementById("corcaixa").value = "#FFFFFF";
		 cbeGetElementById("excorcaixa").style.backgroundColor = "#FFFFFF";
	 }
	 
	 function iniciar()
	 {
		mensagem(inf,0);
		barraStatus();
		window.defaultStatus = "..:: Clinic Web ::.."	 	
	 }
	 
</script>
</head>

<body onLoad="iniciar();barrasessao();">
<%@include file="barrasessao.jsp" %>
<form name="frmcadastrar" id="frmcadastrar" action="gravarcoresefontes.jsp" method="post">
  <table width="600" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr>
      <td width="651" height="18" class="title">.: Cores :.</td>
    </tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr style="height:25px">
		<td align="right"><span name='msg' id='msg' class="msg">&nbsp;</span></td>
	</tr>
    <tr align="center" valign="top">
      <td>
          <table width="100%" border="0" cellpadding="0" cellspacing="0" class="table">
            <tr>
              <td width="100" class="tdMedium">Tonalidade Forte: </td>
              <td class="tdLight">
			  	<input name="tddark" type="text" class="caixa" id="tddark" size="7" maxlength="7" value="<%= tddark%>">
				<span id="extddark" style="border:1px solid #000000; height:16px; width:18px; background-color:<%= tddark%>">&nbsp;</span>
				&nbsp;&nbsp;<button type="button" style="background-color:white; border:1px solid #000000" onClick="abrirPaleta('tddark', event)"><img src="images/palette.gif"></button>
			  </td>
              <td width="100" class="tdMedium">Tonalidade Média: </td>
              <td class="tdLight">
			  	<input name="tdmedium" type="text" class="caixa" id="tdmedium" size="7" maxlength="7" value="<%= tdmedium%>">
				<span id="extdmedium" style="border:1px solid #000000; height:16px; width:18px; background-color:<%= tdmedium%>">&nbsp;</span>
				&nbsp;&nbsp;<button type="button" style="background-color:white; border:1px solid #000000" onClick="abrirPaleta('tdmedium', event)"><img src="images/palette.gif"></button>
			  </td>
            </tr>
			<tr>
              <td class="tdMedium">Tonalidade Fraca: </td>
              <td class="tdLight">
			  	<input name="tdlight" type="text" class="caixa" id="tdlight" size="7" maxlength="7" value="<%= tdlight%>">
				<span id="extdlight" style="border:1px solid #000000; height:16px; width:18px; background-color:<%= tdlight%>">&nbsp;</span>
				&nbsp;&nbsp;<button type="button" style="background-color:white; border:1px solid #000000" onClick="abrirPaleta('tdlight', event)"><img src="images/palette.gif"></button>
			  </td>
              <td class="tdMedium">Cor do Fundo: </td>
              <td class="tdLight">
			  	<input name="fundo" type="text" class="caixa" id="fundo" size="7" maxlength="7" value="<%= fundo%>">
				<span id="exfundo" style="border:1px solid #000000; height:16px; width:18px; background-color:<%= fundo%>">&nbsp;</span>
				&nbsp;&nbsp;<button type="button" style="background-color:white; border:1px solid #000000" onClick="abrirPaleta('fundo', event)"><img src="images/palette.gif"></button>
			  </td>
			</tr>
			<tr>
              <td class="tdMedium">Cor do Título: </td>
              <td class="tdLight">
			  	<input name="cortitulo" type="text" class="caixa" id="cortitulo" size="7" maxlength="7" value="<%= cortitulo%>">
				<span id="excortitulo" style="border:1px solid #000000; height:16px; width:18px; background-color:<%= cortitulo%>">&nbsp;</span>
				&nbsp;&nbsp;<button type="button" style="background-color:white; border:1px solid #000000" onClick="abrirPaleta('cortitulo', event)"><img src="images/palette.gif"></button>
			  </td>
              <td class="tdMedium">Cor da Fonte: </td>
              <td class="tdLight">
			  	<input name="corfonte" type="text" class="caixa" id="corfonte" size="7" maxlength="7" value="<%= corfonte%>">
				<span id="excorfonte" style="border:1px solid #000000; height:16px; width:18px; background-color:<%= corfonte%>">&nbsp;</span>
				&nbsp;&nbsp;<button type="button" style="background-color:white; border:1px solid #000000" onClick="abrirPaleta('corfonte', event)"><img src="images/palette.gif"></button>
			  </td>
			</tr>
			<tr>
              <td class="tdMedium">Cor da Mensagem: </td>
              <td class="tdLight">
			  	<input name="cormsg" type="text" class="caixa" id="cormsg" size="7" maxlength="7" value="<%= cormsg%>">
				<span id="excormsg" style="border:1px solid #000000; height:16px; width:18px; background-color:<%= cormsg%>">&nbsp;</span>
				&nbsp;&nbsp;<button type="button" style="background-color:white; border:1px solid #000000" onClick="abrirPaleta('cormsg', event)"><img src="images/palette.gif"></button>
			  </td>
              <td class="tdMedium">Cor do Fundo das Caixas: </td>
              <td class="tdLight">
			  	<input name="corcaixa" type="text" class="caixa" id="corcaixa" size="7" maxlength="7" value="<%= corcaixa%>">
				<span id="excorcaixa" style="border:1px solid #000000; height:16px; width:18px; background-color:<%= corcaixa%>">&nbsp;</span>
				&nbsp;&nbsp;<button type="button" style="background-color:white; border:1px solid #000000" onClick="abrirPaleta('corcaixa', event)"><img src="images/palette.gif"></button>
			  </td>
			</tr>
          </table>
      </td>
    </tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
    <tr align="center" valign="top">
      <td width="100%">
            <table width="100%" border="0" cellpadding="0" cellspacing="0" class="table">
				<tr>
					<td class="tdMedium" style="text-align:center"><button name="salvar" id="salvar" type="button" class="botao" style="width:100px" onClick="enviarAcao('inc')"><img src="images/grava.gif" height="17">&nbsp;&nbsp;&nbsp;&nbsp;Salvar</button></td>
					<td class="tdMedium" style="text-align:center"><button name="exclui" id="exclui" type="button" class="botao" style="width:100px" onClick="voltarPadrao()"><img src="images/19.gif" height="17">&nbsp;&nbsp;&nbsp;&nbsp;Voltar Padrão</button></td>
				</tr>
			</table>
	  </td>
    </tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
  </table>
  <iframe width="154" height="104" id="cp" name="cp" src="palette.htm" marginwidth="0" marginheight="0" scrolling="no" style="visibility:hidden; position: absolute; top: 100; left: 100"></iframe>
</form>

</body>
</html>
