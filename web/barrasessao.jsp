<%
	int tempo;
	tempo = Integer.parseInt(configuracao.getTempoSessao(usuario_logado)) * 60;
	
	//Define o tempo de sessão com 2 minutos a mais
	session.setMaxInactiveInterval(tempo+120);
%>
	<style type="text/css">
		.drag{
			position:relative;
			cursor:hand;
			z-index: 100;
		}	
	</style>
    <link href="css/css.css" rel="stylesheet" type="text/css">
	<script language="JavaScript" src="js/scriptsform.js"></script>
    <script language="JavaScript">
        var cod_usuario = "<%= (String)session.getAttribute("usuario")%>";
    </script>
    
    <script type="text/javascript" src="js/scripts.js"></script>

	<script language="Javascript">
		var tempo = parseInt("<%= tempo%>");
		var barra;	    //Barra de tempo
		var maximo;	    //Tamanho máximo
		var dateAux;	//Data contadora
		var porcentagem; //Porcentagem atual do tamanho
		var cont = 1;    //Contador de segundos
		var temporizador; //Controla o looping do relógio
		var cod_usuario = "<%= (String)session.getAttribute("usuario")%>";

		function sessao_expirada(obj) {
			var nome_usuario = "<%= nome_usuario%>";
			alert(" # # SESSÃO EXPIRADA # #\n\nA sessão do usuário " + nome_usuario + " expirou.\nO tempo limite de inatividade dessa página foi excedido\nSua página será redirecionada para o login. ")
			parent.location = "index.jsp?erro=2";
		}

		function sair() {
			conf = confirm("Deseja sair do Clinic Web?")
			if(conf)
				parent.location='index.jsp';
		}
		
		function porcTotal(segundos)
		{
			var resp;
			resp = (100.0 * segundos / tempo) * maximo / 100;
			return resp;
		}

		function barrasessao()
		{
			hh = tempo / 3600;
			mm = (tempo%3600) / 60;
			ss = (tempo%3600) % 60;
			barra = cbeGetElementById("sessionMeter");
			maximo = parseInt(cbeGetElementById("sessionBar").style.width);
			dateAux = new Date(0,1,1,hh,mm,ss);
			cont=1;
			barra.style.width = porcTotal(cont);
			clearTimeout(temporizador);
			correrbarra();
		}

		function correrbarra()
		{
			tamanho = parseInt(barra.style.width);
			if(cont <= tempo) {
				barra.style.width = porcTotal(cont);
				dateAux.setSeconds(dateAux.getSeconds()-1);
				h = dateAux.getHours() < 10 ? "0" + dateAux.getHours() : dateAux.getHours();
				m = dateAux.getMinutes() < 10 ? "0" + dateAux.getMinutes() : dateAux.getMinutes();
				s = dateAux.getSeconds() < 10 ? "0" + dateAux.getSeconds() : dateAux.getSeconds();
				cbeGetElementById("tempo").innerHTML = h + ":" + m + ":" + s;
				cont++;
				
				//Se o tempo for menos de 60 segundos, trocar cor da barra
				if(tempo-cont < 60) {
					if(cont%2==0)
						cbeGetElementById("sessionBar").style.backgroundColor = 'red';
					else
						cbeGetElementById("sessionBar").style.backgroundColor = 'white';
				}
				temporizador = setTimeout("correrbarra()",1000);
			}
			else {
				barra.style.width = maximo-2;
				dateAux.setSeconds(dateAux.getSeconds()+1);
				m = dateAux.getMinutes() < 10 ? "0" + dateAux.getMinutes() : dateAux.getMinutes();
				s = dateAux.getSeconds() < 10 ? "0" + dateAux.getSeconds() : dateAux.getSeconds();
				cbeGetElementById("tempo").innerHTML =  m + ":" + s;
				clearTimeout(tempo);
				sessao_expirada(this);
			}
		}
		
		function efeitomenu() {
				var objsFrameset=top.document.getElementsByTagName("frameset");
				var atual = objsFrameset[0].cols;
				
				if(atual == "150,*") {
					objsFrameset[0].cols= "0,*";
					cbeGetElementById("imgmenu").src = "images/setafecha.gif";
				}
				else {
					objsFrameset[0].cols="150,*";
					cbeGetElementById("imgmenu").src = "images/setaabre.gif";
				}
				
		}
		
		function chamarAjuda() {
			//Não definiu o cod_ajuda
			if(cod_ajuda == "-1") {
				alert("Essa tela ainda não possui ajuda");
			}
			else {
				buscaTextoAjuda(cod_ajuda);
				cbeGetElementById("divajuda").style.top = "20px";
				cbeGetElementById("divajuda").style.display = "block";
				cbeGetElementById("iframeajuda").style.top = "30px";
				cbeGetElementById("iframeajuda").style.display = "block";
			}
		}
		
		function buscaTextoAjuda(cod_ajuda) {  //Só para a ajuda
				//Página que vai buscar os dados
				var url = "carregaajuda.jsp?cod_ajuda=" + cod_ajuda;
	
				//Se for IE
				if (window.ActiveXObject) {
						xmlHttp = new ActiveXObject('Microsoft.XMLHTTP');
				}
				//Se for NETSCAPE
				else if (window.XMLHttpRequest) {
						xmlHttp = new XMLHttpRequest();
				}
				xmlHttp.open('GET', url, true);
				xmlHttp.onreadystatechange = carregaTextoAjuda;
				xmlHttp.send(null);
		}	
		
		function carregaTextoAjuda(){
			//Carregando
			if (xmlHttp.readyState == 1) {
				cbeGetElementById("textoajuda").innerHTML = "<br><img src='images/loading.gif'> <span class='texto'>Carregando texto da ajuda. Aguarde...</span>";
			}

			//Mostra o texto quando terminar de carregar
			if (xmlHttp.readyState == 4) {
				if (xmlHttp.status == 200) {
					xmlDoc = xmlHttp.responseText;
					cbeGetElementById("textoajuda").innerHTML = xmlDoc;
				}
			 }
		}
		
		function fecharAjuda() {
			cbeGetElementById("divajuda").style.top = "-700px";
			cbeGetElementById("iframeajuda").style.top = "-700px";
		}
		
			
	</script>
	
	<script type="text/javascript">
	
	/***********************************************
	* Drag and Drop Script: © Dynamic Drive (http://www.dynamicdrive.com)
	* This notice MUST stay intact for legal use
	* Visit http://www.dynamicdrive.com/ for this script and 100s more.
	***********************************************/
	
	var dragobject={
		z: 0, x: 0, y: 0, offsetx : null, offsety : null, targetobj : null, dragapproved : 0,
		initialize:function(){
			document.onmousedown=this.drag
			document.onmouseup=function(){this.dragapproved=0}
		},
		drag:function(e){
			var evtobj=window.event? window.event : e
			this.targetobj=window.event? event.srcElement : e.target
			if (this.targetobj.className=="drag"){
				this.dragapproved=1
				if (isNaN(parseInt(this.targetobj.style.left))){this.targetobj.style.left=0}
				if (isNaN(parseInt(this.targetobj.style.top))){this.targetobj.style.top=0}
				this.offsetx=parseInt(this.targetobj.style.left)
				this.offsety=parseInt(this.targetobj.style.top)
				this.x=evtobj.clientX
				this.y=evtobj.clientY
				if (evtobj.preventDefault)
				evtobj.preventDefault()
				document.onmousemove=dragobject.moveit
			}
		},
		moveit:function(e){
			var evtobj=window.event? window.event : e
			if (this.dragapproved==1){
				this.targetobj.style.left=this.offsetx+evtobj.clientX-this.x+"px"
				cbeGetElementById("iframeajuda").style.left=((this.offsetx+evtobj.clientX-this.x)+10)+"px";
				this.targetobj.style.top=this.offsety+evtobj.clientY-this.y+"px"
				cbeGetElementById("iframeajuda").style.top=((this.offsety+evtobj.clientY-this.y)+10)+"px"
				return false
			}
		}
	}
	
	dragobject.initialize()
	
	
	</script>	
	<center>
	<table width="600" border='0' cellpadding='0' cellspacing='0'>
		<tr>
			<td width="400" class='tdMedium' style="border-left:1px solid #000000">Usuário: <%= nome_usuario%>
			<td class="tdLight">
				<div style='height: 4px; width: 300px; border: 1px solid #FF9900; background-color:<%= tddark%>' align='left' id='sessionBar' name='sessionBar'>
					<div id="sessionMeter" style="background-color:<%= fundo%>; height:4px; width:1px"></div>
				</div>
			</td>
			<td width="45" align='center' class="tdMedium"><div id='tempo' name='tempo'>00:00</div></td>
		</tr>
        <tr>
        	<td colspan="3">
            	<table cellpadding="0" cellspacing="0" width="100%">
                	<tr>
	 	  	 			<td class="tdLight" align="center" style="border-left: 1px solid #111111"><a href="Javascript:efeitomenu()" title="Abre e fecha o menu lateral"><img id="imgmenu" src="images/setaabre.gif" border="0"></a></td>
						<td class="tdLight" align="center"><a href="inicio.jsp" target="mainFrame" title="Voltar à página inicial"><img src='images/36.gif' border="0"></a></td>
						<td class="tdLight" align="center"><a href="javascript:verponto()" target="mainFrame" title="Ver Ponto"><img src='images/16.gif' border="0"></a></td>
						<td class="tdLight" align="center"><a href="Javascript:cadastraPonto();" title="Registrar Ponto"><img src='images/37.gif' border="0"></a></td>
						<td class="tdLight" align="center"><a href="Javascript:agendatelefonica()" title="Agenda Telefônica"><img src='images/29.gif' border="0"></a></td>
						<td class="tdLight" align="center"><a href="Javascript:agendapessoal()" title="Agenda Pessoal"><img src='images/17.gif' border="0"></a></td>
						<td class="tdLight" align="center"><a href="Javascript:alterarSenha();" title="Alterar Senha"><img src='images/15.gif' border="0"></a></td>
						<td class="tdLight" align="center"><a title="Ajuda" href="Javascript:chamarAjuda()"><img src="images/11.gif" border="0"></a></td>
						<td class="tdLight" align="center"><a title="Sair do Sistema" href="Javascript:sair()"><img src="images/12.gif" border="0"></a></td>
                        
                    </tr>
                </table>
            </td>
        </tr>
	</table>
	</center>
	<div id="divmensagem" style="position:absolute; left:100; top:-100; background-color:'#FFFFCC'; width:400; height: 0"></div>

<!-- DIV para a HELP -->
<div class="drag" id="divajuda" style="padding-left:25px; padding-right:80px; padding-top:60px; padding-bottom:30px; position: absolute; left:400px; top:-500px; width:400; height:380; display: 'none'; z-index:401; background-image:url(images/notepad.gif);background-repeat: no-repeat; ">
	<span id="home" style="position:relative; left:300px"><a href="Javascript:chamarAjuda()" title="Voltar à ajuda inicial"><img src="images/home.gif" border="0"></a></span>
	<span id="fechar" style="position:relative; left:300px"><a href="Javascript:fecharAjuda()" title="Fechar Ajuda"><img src="images/excluir.gif" border="0"></a></span>
	<div id="textoajuda" style="overflow: auto; width:346; height:350px "></div>
</div>

<iframe class="drag" id="iframeajuda" style="position: absolute; left:410px; top:-500px; width:370; height:380; display: 'none'; z-index:400; border-style: none"></iframe>
<!-- -->
