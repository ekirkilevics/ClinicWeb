<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.Protocolo" id="protocolo" scope="page"/>
<jsp:useBean class="recursos.Paciente" id="paciente" scope="page"/>

<%
	String codcli = request.getParameter("codcli");
	String cod_protocolo = request.getParameter("protocolo");
	String dadospaciente[] = paciente.getDadosPaciente(codcli);
	String data = Util.isNull(request.getParameter("data")) ? "" : request.getParameter("data");
%>

<html>
<head>
<title>Protocolos - Aplicação</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
<script language="JavaScript">
	function buscarProtocolo() {
		var frm = cbeGetElementById("frmcadastrar");
			
		if(frm.protocolo == "") {
			alert("Selecione um protocolo para ser respondido");
			return;
		}

		frm.submit();
	}
	
	function gravarProtocolo() {
		var frm = cbeGetElementById("frmcadastrar");
		frm.action = "salvaraplicacao.jsp?codcli=<%= codcli%>";
		frm.submit();
	}
	
	function iniciar() {
		cbeGetElementById("protocolo").value = "<%= cod_protocolo%>";
	}
	
	var xmlHttp;
	function buscarDatasProtocolo(cod_protocolo) { 
			if(cod_protocolo == "") return;

			//Página que vai buscar os dados
			var url = "carregalistadatasprotocolo.jsp?cod_protocolo=" + cod_protocolo + "&codcli=<%= codcli%>";

			//Se for IE
			if (window.ActiveXObject) {
					xmlHttp = new ActiveXObject('Microsoft.XMLHTTP');
			}
			//Se for NETSCAPE
			else if (window.XMLHttpRequest) {
					xmlHttp = new XMLHttpRequest();
			}
			xmlHttp.open('GET', url, true);
			xmlHttp.onreadystatechange = capturaresposta;
			xmlHttp.send(null);
	}

	function capturaresposta(){
		//Carrega a lista com os resultados e volta o fundo da caixa pra branco
		if (xmlHttp.readyState == 4) {
			if (xmlHttp.status == 200) {
				cbeGetElementById("divdata").innerHTML = xmlHttp.responseText;
			}
		 }
	}	
	
	function setarData(valor) {
		var frm = cbeGetElementById("frmcadastrar");
		frm.data.value = valor;
		frm.submit();
	}
</script>
</head>

<body onLoad="iniciar()">
<form name="frmcadastrar" id="frmcadastrar" action="aplicarprotocolo.jsp" method="post">
  <table width="600" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr align="center" valign="top">
      <td>
          <table width="100%" border="0" cellpadding="0" cellspacing="0" class="table">
            <tr>
	              <td width="100" class="tdMedium">Paciente: </td>
    	          <td class="tdLight">
					<input type="hidden" name="codcli" id="codcli" value="<%= codcli%>">
                    <%= dadospaciente[2] %>
                  </td>
            </tr>
            <tr>
	              <td class="tdMedium">Protocolo: </td>
    	          <td class="tdLight">
                  	<select name="protocolo" id="protocolo" class="caixa" onChange="buscarDatasProtocolo(this.value)">
                    	<option value=""></option>
                        <%= protocolo.getProtocolos( cod_empresa )%>
                    </select>
                  </td>
            </tr>
            <tr>
	              <td class="tdMedium">Data: </td>
    	          <td class="tdLight"><span id="divdata"><input type="hidden" name="data" value="<%= data%>"><%= data%>&nbsp;</span></td>
            </tr>
          </table>
      </td>
    </tr>
	<tr>
		<td>
        	<%
				if(!Util.isNull(cod_protocolo)) {
					out.println(protocolo.getQuestoesProtocolo(cod_protocolo, codcli, data));
			%>
            	<table cellspacing="0" cellpadding="0" width="600">
                	<tr>
                    	<td class="tdMedium" align="center"><button type="button" class="botao" onClick="gravarProtocolo()"><img src="images/gravamini.gif">&nbsp;&nbsp;&nbsp;Gravar</button></td>
                    </tr>
                </table>
            <%
				}
			%>
        </td>
	</tr>
  </table>
</form>

</body>
</html>
