<%@include file="cabecalho.jsp" %>
<%@ page import="java.util.Vector" %>

<jsp:useBean class="recursos.Usuario" id="usuario" scope="page"/>

<html>
<head>
<link href="css/css.css" rel="stylesheet" type="text/css">
<META HTTP-EQUIV="expires" CONTENT="0">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
<script language="JavaScript">
	    var xmlHttp1, xmlHttp2, xmlHttp3;
		var taxaatualiza;
		var tmp;

		function atualizarItens() {
			atualizaUsuario();
			verificaAgendaPessoal();
			/*
			try {
				var frames = window.parent.frames;
				var jsdivmensagem = frames[2].document.getElementById("divmensagem");
				atualizaMensagens();
			}
			catch(e) { }
			*/
			taxaatualiza = setTimeout("atualizarItens()",2000);
		}	

		//Função para atualizar a lista de usuários
		function atualizaUsuario() {
				//Página que vai buscar os dados
				var url = "carregalistausuarios.jsp";
	
				//Se for IE
				if (window.ActiveXObject) {
						xmlHttp1 = new ActiveXObject('Microsoft.XMLHTTP');
				}
				//Se for NETSCAPE
				else if (window.XMLHttpRequest) {
						xmlHttp1 = new XMLHttpRequest();
				}
				xmlHttp1.open('GET', url, true);
				xmlHttp1.onreadystatechange = capturaeventos;
				xmlHttp1.send(null);
		}

		function capturaeventos(){
			//Carrega a lista com os resultados
			if (xmlHttp1.readyState == 4) {
				if (xmlHttp1.status == 200) {
					resposta = xmlHttp1.responseText;
					cbeGetElementById("listagem").innerHTML = resposta;
				}
			 }
		}

		//Função para verificar agendas pessoais
		function verificaAgendaPessoal() {
				//Página que vai buscar os dados
				var url = "carregaagendapessoaldia.jsp";
	
				//Se for IE
				if (window.ActiveXObject) {
						xmlHttp3 = new ActiveXObject('Microsoft.XMLHTTP');
				}
				//Se for NETSCAPE
				else if (window.XMLHttpRequest) {
						xmlHttp3 = new XMLHttpRequest();
				}
				xmlHttp3.open('GET', url, true);
				xmlHttp3.onreadystatechange = eventosagendapessoal;
				xmlHttp3.send(null);
		}

		function eventosagendapessoal(){
			//Carrega a lista com os resultados
			if (xmlHttp3.readyState == 4) {
				if (xmlHttp3.status == 200) {
					var agendasp = xmlHttp3.responseText;
					if(agendasp.indexOf("###") < 0) alert(agendasp);
				}
			 }
		}
		
		//Função que verifica se o usuário tem novas mensagens
		function atualizaMensagens() {
				//Página que vai buscar os dados
				var url = "carregamensagens.jsp";
	
				//Se for IE
				if (window.ActiveXObject) {
						xmlHttp2 = new ActiveXObject('Microsoft.XMLHTTP');
				}
				//Se for NETSCAPE
				else if (window.XMLHttpRequest) {
						xmlHttp2 = new XMLHttpRequest();
				}
				xmlHttp2.open('GET', url, true);
				xmlHttp2.onreadystatechange = atualizajanelamensagens;
				xmlHttp2.send(null);
		}

		function atualizajanelamensagens(){
			//Carrega a lista com os resultados
			if (xmlHttp2.readyState == 4) {
				if (xmlHttp2.status == 200) {
					lstmsg = xmlHttp2.responseText;
					//Se veio alguma informação, que não seja espaço em branco (mais de 5 caracteres)
					if(lstmsg.length > 5) {
						try {
							var frames = window.parent.frames;
							var jsdivmensagem = frames[2].document.getElementById("divmensagem");
							jsdivmensagem.innerHTML += lstmsg;
							rolarobj();
						}
						catch(e) { }
					}
				}
			 }
		}
		
		function rolarobj() {
			var frames = window.parent.frames;
			var obj = frames[2].document.getElementById("divmensagem");
			var jstop = parseInt(obj.style.top);
			if(jstop < 0) {
				obj.style.top = jstop + 10;
				tmp = setTimeout("rolarobj()", 10);
			}
			else
				clearTimeout(tmp);
		}
		
		
		function abrirChat() {
			rolarobj();
		}	

		function escondeUsuarios() {
				var objsFrameset=top.document.getElementsByTagName("frameset");
				var atual = objsFrameset[1].rows;
				
				//Sem frame do médico
				if(atual.indexOf("*") == -1) {	
					if(atual == "80%,20%") {
						objsFrameset[1].rows= "100%,30";
						cbeGetElementById("imglogados").src = "images/top.gif";
					}
					else {
						objsFrameset[1].rows="80%,20%";
						cbeGetElementById("imglogados").src = "images/down.gif";
					}
				}
				//Com frame do médico
				else {
					if(atual == "70%, *, 30") {
						objsFrameset[1].rows= "70%, *, 150";
						cbeGetElementById("imglogados").src = "images/top.gif";
					}
					else {
						objsFrameset[1].rows="70%, *, 30";
						cbeGetElementById("imglogados").src = "images/down.gif";
					}
				}
				
				
		}


</script>
</head>

<body onLoad="atualizarItens()" LEFTMARGIN=0 TOPMARGIN=0 MARGINWIDTH=0 MARGINHEIGHT=0 style="background-image:  url(images/fundomenu.jpg); overflow-x: 'hidden'">
<center>
<table width="95%" height="95%" style="border: 1px solid #E8EFF7" cellpadding="0" cellspacing="0">
	<tr>
		<td  height="20" class="texto" style="background-color:#E8EFF7" valign="middle">
			<a href="Javascript:escondeUsuarios()" title="Exibe/Oculta usuários logados"><img id="imglogados" src="images/top.gif" border="0" width="20"></a>
        </td>
        <td width="100%" class="texto" style="background-color:#E8EFF7; padding-left:4px" valign="middle">
            <b style="color:#009966; font-size:9px"> Usuários Logados</b>
		</td>
	</tr>
	<tr>
		<td colspan="2" height="100%" style="background-color:white" valign="top">
			<div id="listagem" class="texto">&nbsp;</div>
		</td>
	</tr>
</table>
</center>
</body>
</html>
