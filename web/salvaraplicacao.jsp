<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.Protocolo" id="protocolo" scope="page"/>

<%
	String resp = protocolo.gravaRespostasProtocolo(request, nome_usuario);
%>
<html>
	<head>
    	<title>Protocolos</title>
        <script language="Javascript">
		
		var jsresp = "<%= resp%>";
		
		function iniciar() {
			if(jsresp == "OK") {
				alert("Protocolo salvo com sucesso");
				self.close();
			}
			else
				alert(jsresp);
		}
		</script>
    </head>
    <body onLoad="iniciar()"></body>
</html>
