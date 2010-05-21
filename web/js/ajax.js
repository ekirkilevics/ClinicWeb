//********************** FUN��ES PARA O AJAX ********************************//

		var xmlHttp;
	
		var x; 					//Vari�vel do lista combo
		var jsiframecombo; 		//iframe que vai embaixo do DIV
		var posleft, postop; 	//posi��o da caixa de texto da lista
		var nomecampo; 			//nome do campo

		//Pega posi��o da esquerda
		function findPosLeft(obj) {
			var curleft = 0;
			if (obj.offsetParent) {
				curleft = obj.offsetLeft
				while (obj = obj.offsetParent) {
					curleft += obj.offsetLeft
				}
			}
			return curleft;
		}

		//Pega posi��o do Topo
		function findPosTop(obj) {
			var curtop = 0;
			if (obj.offsetParent) {
				curtop = obj.offsetTop
				while (obj = obj.offsetParent) {
					curtop += obj.offsetTop
				}
			}
			return curtop;
		}

		/*
			query: string para o filtro da pesquisa
			chave: nome do campo que vai ser colocado como �ndice
			campo: nome do campo a ser listado e ordenado
			tabela: nome da tabela a procurar os campos
			complemento: 
		*/
		function busca(query, chave, campo, tabela, complemento) {
				//Captura o objeto do combo e o iframe que vai por baixo
				if(!x) x = cbeGetElementById("combo");
				if(!jsiframecombo) jsiframecombo = cbeGetElementById("iframecombo");

				//Define o campo da caixa (podem vir v�rios separados por #)
				if(campo.indexOf('#')>-1)
					nomecampo = campo.substring(0,campo.indexOf('#'));
				else
					nomecampo = campo;
				
				//Se a busca est� vazia, n�o exibir a lista
				if(query.length < 3) {
					hide();
					x.innerHTML = "";
					hideAll();
					return;
				}
				//Se n� veio complemento, zerar
				if(complemento == undefined) {
					complemento = "";
				}

				//P�gina que vai buscar os dados
				var url = "carregalista.jsp?q=" + query + "&key=" + chave + "&fld=" + campo + "&tbl=" + tabela + "&cpt=" + complemento;
	
				//Se for IE
				if (window.ActiveXObject) {
						xmlHttp = new ActiveXObject('Microsoft.XMLHTTP');
				}
				//Se for NETSCAPE
				else if (window.XMLHttpRequest) {
						xmlHttp = new XMLHttpRequest();
				}
				xmlHttp.open('GET', url, true);
				xmlHttp.onreadystatechange = capturaeventos;
				xmlHttp.send(null);
		}

		//Alterna entre busca por nome e busca por nascimento
		function pesquisapornascimento(tipo) {
			if(tipo == 1) {
				cbeGetElementById("nome").style.display = "none";
				cbeGetElementById("pesqnascimento").style.display = "block";
				cbeGetElementById("pesqnascimento").focus();
			}
			else {
				cbeGetElementById("nome").style.display = "block";
				cbeGetElementById("pesqnascimento").style.display = "none";
				cbeGetElementById("nome").focus();
			}
		}

		function buscanascimento(datanascimento, evento) {
				wTecla = evento.keyCode;

				//Captura o objeto do combo e o iframe que vai por baixo
				if(!x) x = cbeGetElementById("combo");
				if(!jsiframecombo) jsiframecombo = cbeGetElementById("iframecombo");
				
				//Se apertou ENTER
				if(wTecla == 13) {
	
					//P�gina que vai buscar os dados
					var url = "carregapacientes.jsp?data=" + datanascimento;
					
					//Nome do campo da busca
					nomecampo = "pesqnascimento";
		
					//Se for IE
					if (window.ActiveXObject) {
							xmlHttp = new ActiveXObject('Microsoft.XMLHTTP');
					}
					//Se for NETSCAPE
					else if (window.XMLHttpRequest) {
							xmlHttp = new XMLHttpRequest();
					}
					xmlHttp.open('GET', url, true);
					xmlHttp.onreadystatechange = capturaeventos;
					xmlHttp.send(null);
				}
				//se n�o for pra buscar, limpa
				else {
					hide();
					x.innerHTML = "";
					hideAll();
					return;
				}
		}

		/*
			query: string para o filtro da pesquisa
		*/
		function buscadiagnosticos(query, seq) {  //S� para disgn�sticos
				//Captura o objeto do combo e o iframe que vai por baixo
				if(!x) x = cbeGetElementById("combo");
				if(!jsiframecombo) jsiframecombo = cbeGetElementById("iframecombo");

				//Define o campo da caixa
				nomecampo = "DESCRICAO" + seq;
				
				//Se a busca est� vazia, n�o exibir a lista
				if(query.length < 3) {
					hide();
					x.innerHTML = "";
					return;
				}

				//P�gina que vai buscar os dados
				var url = "carregalistadiagnosticos.jsp?q=" + query + "&seq=" + seq;
	
				//Se for IE
				if (window.ActiveXObject) {
						xmlHttp = new ActiveXObject('Microsoft.XMLHTTP');
				}
				//Se for NETSCAPE
				else if (window.XMLHttpRequest) {
						xmlHttp = new XMLHttpRequest();
				}
				xmlHttp.open('GET', url, true);
				xmlHttp.onreadystatechange = capturaeventos;
				xmlHttp.send(null);
		}
		
		function buscaprocedimentos(query) {  //S� para disgn�sticos
				//Captura o objeto do combo e o iframe que vai por baixo
				if(!x) x = cbeGetElementById("combo");
				if(!jsiframecombo) jsiframecombo = cbeGetElementById("iframecombo");

				//Define o campo da caixa
				nomecampo = "Procedimento";
				
				//Se a busca est� vazia, n�o exibir a lista
				if(query.length < 3) {
					hide();
					x.innerHTML = "";
					return;
				}

				//P�gina que vai buscar os dados
				var url = "carregalistaprocedimentoscompleta.jsp?q=" + query;
	
				//Se for IE
				if (window.ActiveXObject) {
						xmlHttp = new ActiveXObject('Microsoft.XMLHTTP');
				}
				//Se for NETSCAPE
				else if (window.XMLHttpRequest) {
						xmlHttp = new XMLHttpRequest();
				}
				xmlHttp.open('GET', url, true);
				xmlHttp.onreadystatechange = capturaeventos;
				xmlHttp.send(null);
		}
		

		/*
			query: string para o filtro da pesquisa
		*/
		function buscaconvenios(query) {  //S� para conv�nios
				//Captura o objeto do combo e o iframe que vai por baixo
				if(!x) x = cbeGetElementById("combo");
				if(!jsiframecombo) jsiframecombo = cbeGetElementById("iframecombo");

				//Define o campo da caixa
				nomecampo = "descr_convenio";
				
				//Se a busca est� vazia, n�o exibir a lista
				if(query.length < 3) {
					hide();
					x.innerHTML = "";
					return;
				}

				//P�gina que vai buscar os dados
				var url = "carregalistaconvenios.jsp?q=" + query;
	
				//Se for IE
				if (window.ActiveXObject) {
						xmlHttp = new ActiveXObject('Microsoft.XMLHTTP');
				}
				//Se for NETSCAPE
				else if (window.XMLHttpRequest) {
						xmlHttp = new XMLHttpRequest();
				}
				xmlHttp.open('GET', url, true);
				xmlHttp.onreadystatechange = capturaeventos;
				xmlHttp.send(null);
		}

		/*
			query: string para o filtro da pesquisa
			cod_conv�nio para filtro
		*/
		function buscaprocedimento(query, cod_convenio) {  //S� para disgn�sticos
				//Captura o objeto do combo e o iframe que vai por baixo
				if(!x) x = cbeGetElementById("combo");
				if(!jsiframecombo) jsiframecombo = cbeGetElementById("iframecombo");

				//Define o campo da caixa
				nomecampo = "Procedimento";
				
				//Se a busca est� vazia, n�o exibir a lista
				if(query.length < 3) {
					hide();
					x.innerHTML = "";
					return;
				}

				//P�gina que vai buscar os dados
				var url = "carregalistaprocedimentos.jsp?q=" + query + "&cod_convenio=" + cod_convenio;
	
				//Se for IE
				if (window.ActiveXObject) {
						xmlHttp = new ActiveXObject('Microsoft.XMLHTTP');
				}
				//Se for NETSCAPE
				else if (window.XMLHttpRequest) {
						xmlHttp = new XMLHttpRequest();
				}
				xmlHttp.open('GET', url, true);
				xmlHttp.onreadystatechange = capturaeventos;
				xmlHttp.send(null);
		}
		
		/*
			query: string para o filtro da pesquisa
		*/
		function buscaprofissao(query) {  //S� para profiss�es
				//Captura o objeto do combo e o iframe que vai por baixo
				if(!x) x = cbeGetElementById("combo");
				if(!jsiframecombo) jsiframecombo = cbeGetElementById("iframecombo");

				//Define o campo da caixa
				nomecampo = "profissao";
				
				//Se a busca est� vazia, n�o exibir a lista
				if(query.length < 3) {
					hide();
					x.innerHTML = "";
					return;
				}

				//P�gina que vai buscar os dados
				var url = "carregalistaprofissoes.jsp?q=" + query;
	
				//Se for IE
				if (window.ActiveXObject) {
						xmlHttp = new ActiveXObject('Microsoft.XMLHTTP');
				}
				//Se for NETSCAPE
				else if (window.XMLHttpRequest) {
						xmlHttp = new XMLHttpRequest();
				}
				xmlHttp.open('GET', url, true);
				xmlHttp.onreadystatechange = capturaeventos;
				xmlHttp.send(null);
		}

		function capturaeventos(){
			//Mostra imagem de carregando na caixa
			if (xmlHttp.readyState == 1) {
				cbeGetElementById(nomecampo).style.background  = "#ffffff url(images/carregando.gif) no-repeat right";
			}
			//Carrega a lista com os resultados e volta o fundo da caixa pra branco
			if (xmlHttp.readyState == 4) {
				if (xmlHttp.status == 200) {
					carregaLista();
					cbeGetElementById(nomecampo).style.background  = "#ffffff";
				}
			 }
		}

		function carregaLista(){
			xmlDoc = xmlHttp.responseText;
			//S� exibe se voltou valores (m�o s� as tags de table e /table	
			if(xmlDoc.length>46) {
				show();
				x.innerHTML = xmlDoc;
			}
			else {
				hide();
				x.innerHTML = "";
			}
		}
				
		function setar(chave, campo, valorchave, valorcampo) {
			cbeGetElementById(chave).value = valorchave;
			cbeGetElementById(campo).value = valorcampo;
			x.innerHTML = "";
			hide();
		}

		function show(){
			//Exibe os objetos
			x.style.display = "block";
			jsiframecombo.style.display = "block";
			
			//Posiciona a lista embaixo da caixa
			posicionalista();

		}				

		function hideAll(){
			//Esconde os objetos
			try {
				cbeGetElementById("combo").style.display = "none";
				cbeGetElementById("iframecombo").style.display = "none";
			}
			catch(e) { }
		}


		function hide(){
			//Esconde os objetos
			x.style.display = "none";
			jsiframecombo.style.display = "none";
		}

		function posicionalista() {
			if(!x) x = cbeGetElementById("combo");
			if(!jsiframecombo) jsiframecombo = cbeGetElementById("iframecombo");

			//Captura a posi��o da caixa de digita��o para reposicionar o combo
			posleft = findPosLeft(cbeGetElementById(nomecampo));
			postop  = findPosTop(cbeGetElementById(nomecampo)) + 20;
			
			//S� reposiciona se estiver vis�vel
			if(x.style.display == 'block') {
				x.style.left = posleft;
				x.style.top = postop;
				jsiframecombo.style.left = posleft;
				jsiframecombo.style.top = postop;
			}
		}

		/*
			cod_conv�nio para filtro
		*/
		function buscaplanosconvenio(cod_convenio, tipo, cod_plano) { 
				//P�gina que vai buscar os dados
				var url = "carregaplanos.jsp?cod_convenio=" + cod_convenio + "&tipolista=" + tipo + "&cod_plano=" + cod_plano;
	
				//Se for IE
				if (window.ActiveXObject) {
						xmlHttp = new ActiveXObject('Microsoft.XMLHTTP');
				}
				//Se for NETSCAPE
				else if (window.XMLHttpRequest) {
						xmlHttp = new XMLHttpRequest();
				}
				xmlHttp.open('GET', url, true);
				xmlHttp.onreadystatechange = carregacomboplanos;
				xmlHttp.send(null);
		}
		
		function carregacomboplanos() {
			if (xmlHttp.readyState == 4) {
				if (xmlHttp.status == 200) {
					xmlDoc = xmlHttp.responseText;
					cbeGetElementById("listaplanos").innerHTML = xmlDoc;
				}
			 }
		}
		
		function pegaModelo(cod_modelo) {  //Busca o modelo

				//P�gina que vai buscar os dados
				var url = "pegamodelo.jsp?cod_modelo=" + cod_modelo;
	
				//Se for IE
				if (window.ActiveXObject) {
						xmlHttp = new ActiveXObject('Microsoft.XMLHTTP');
				}
				//Se for NETSCAPE
				else if (window.XMLHttpRequest) {
						xmlHttp = new XMLHttpRequest();
				}
				xmlHttp.open('GET', url, true);
				xmlHttp.onreadystatechange = atualizamodelo;
				xmlHttp.send(null);
		}
		
		function atualizamodelo() {
			if (xmlHttp.readyState == 4) {
				if (xmlHttp.status == 200) {
					xmlDoc = xmlHttp.responseText;
					insereHistoria(xmlDoc);
				}
			 }
		}
		

//********************** FUN��ES PARA O AUTO-COMPLETE DO AJAX ********************************//		

		function verificaLimiteAgendamento(cod_convenio, cod_plano, cod_proced) { 
				//P�gina que vai buscar os dados
				var url = "validalimiteagendamento.jsp?cod_convenio=" + cod_convenio + "&cod_plano=" + cod_plano + "&cod_proced=" + cod_proced;
	
				//Se for IE
				if (window.ActiveXObject) {
						xmlHttp = new ActiveXObject('Microsoft.XMLHTTP');
				}
				//Se for NETSCAPE
				else if (window.XMLHttpRequest) {
						xmlHttp = new XMLHttpRequest();
				}
				xmlHttp.open('GET', url, true);
				xmlHttp.onreadystatechange = carregarespostavalidaagendamento;
				xmlHttp.send(null);
		}
		
		function carregarespostavalidaagendamento() {
			if (xmlHttp.readyState == 4) {
				if (xmlHttp.status == 200) {
					xmlDoc = xmlHttp.responseText;
					alert(xmlDoc);
				}
			 }
		}
		
	
		//Busca a �ltima indica��o do medicamento
		function buscaIndicacao(cod, prof_reg) {

				//P�gina que vai buscar os dados
				var url = "buscaindicacaomedicamento.jsp?cod=" + cod + "&prof_reg=" + prof_reg;
	
				//Se for IE
				if (window.ActiveXObject) {
						xmlHttp = new ActiveXObject('Microsoft.XMLHTTP');
				}
				//Se for NETSCAPE
				else if (window.XMLHttpRequest) {
						xmlHttp = new XMLHttpRequest();
				}
				xmlHttp.open('GET', url, true);
				xmlHttp.onreadystatechange = atualizaindicacao;
				xmlHttp.send(null);
		}
		
		function atualizaindicacao() {
			if (xmlHttp.readyState == 4) {
				if (xmlHttp.status == 200) {
					xmlDoc = xmlHttp.responseText;
					cbeGetElementById("indicacao").value = xmlDoc;
				}
			 }
		}
		
