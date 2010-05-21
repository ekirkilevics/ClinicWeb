/* Arquivos de Funções Javascript
 ******* LISTA DE PROTÓTIPOS
 * 1) ObjDecrypt(id, data, delay) 	 	- Cria efeito na barra de Status
 * 2) barraStatus()						- Chama o procedimentos anterior para iniciar efeit
 * 3) protegercodigo()					- Intercepta botão do mouse e não permite exibir fonte
 * 4) inicio()							- Função chamada sempre no Onload do body
 * 5) botaoNovo()						- Click do botão novo das páginas (limpa formulário)
 * 6) validaCampos()					- Verifica se existe algum campo obrigatório que não foi preenchido
 * 7) botoes(tipo)						- Habilita e desabilita botões conforme ação (tipo)
 * 8) mensagem(inf, icon)				- Exibe uma mensagem com um ícone (icon 1-Correto, 2-Incorreto)
 * 9) limpaForm()						- Limpa os campos do formulário
 * 10) selecionaCombo(frm)				- Seleciona todos os itens da combo para fazer o submit
 * 11) getObj(frm, campo)				- Captura o objeto a partir do nome do formulário e nome do campo
 * 12) buscar(page)						- Redireciona o action do formulário para outrta página (page)
 * 13) enviarAcao(tipo)					- Trata o click do botão salvar e excluir, verificando se é inc, exc, alt
 * 14) validaemail(obj)					- Valida o e-mail
 * 15) formatar(src, evt, mask)			- Cria máscara de entrada somente para números
 * 16) trocaCor(objTR, tipo)			- Troca a cor da linha da tabela (usado no OnMouseOver)
 * 17) go(link)							- Vai para uma página, substituindo a atual
 * 18) ordenar(page,campo)				- Reenvia o formulário por submit, enviando o campo a ordenar a pesquisa
 * 19) insereCombo(nomecombo, valor, texto) - Insere itens em uma combo (select-multiple)
 * 20) existeValor(combo, valor)		- Verifica se um item já existe na lista, se existir, retorna true
 * 21) OnlyNumbers(pCampo,pTeclaPres)	- Só permite a digitação de números no campo
 * 22) janela(pagina, larg, alt, id, parametro) - Abre uma janela popup com determinada largura, altura, um valor a ser enviado e nome do parâmetro por GET
 * 23) setarCampoPai(campo, valor)		- Seta um valor de um campo que se encontra na janela pai (que abriu a atual)
 * 24) fecharJanelaeAtualizar()			- Atualiza a janela pai e fecha a atual
 * 25) valida_cpf_cnpj(obj)				- Valida CPF ou CNPJ
 * 26) cgc(pcgc)						- Valida o CNPJ (retorna true ou false)
 * 27) cpf(pcpf)						- Valida o CPF (retorna true ou false)
 * 28) ValidaData(pCampo)				- Verifica se é uma data válida
 * 29) ValidaFuturo(pCampo)				- Verifica se a data digitada é maior que a data atual (se sim,  erro)
 * 30) ValidaHora(pCampo)				- Verifica se a hora digitada é válida (se não for, erro)
 * 31) getHoje()						- Devolve a data atual dd/mm/aaaa
 * 32) formatCurrency(num) 				- Tranforma no formato moeda
 * 33) displayPopup(url,name,height,width) - Exibe janela centralizada
 * 34) setarDadosPaciente(codigo, paciente, nascimento, cod_convenio, descr_convenio) - Preeche dados do paciente no histórico		
 * 35) getHora()						- Devolve a hora atual no formato hh:mm
 * 36) getDias(mes, ano)				- Devolve a quantidade de dias de um mês
 * 37) getIdade(nascimento)				- Devolve o tempo de vida da pessoa em anos, meses e dias
 * 38) mostraImagem(caminho, ev)		- Exibe uma imagem no tamanho real perto de onde o mouse está (recebe event)
 * 39) navegacao(numPag)				- Navegacao entre as páginas
 * 40) toInt(valor)						- Tranforma um valor em String para int
 * 41) abreLink(links, titulo)			- Abre um link na página e grava cookie
 * 42) difDatas(data1, data2)  			- Retorna a diferença entre datas em dias
 * 43) ValidaPassado(pCampo)			- Verifica se a data digitada é menor que a data atual (se sim,  erro)
 * 44) cadastrorapido()					- Abre o cadastro rápido de pacientes
 * 45) formataData(data)				- Formata um objeto Date() para o formato dd/mm/aaaa
 * 46) formataHora(data)				- Formata um objeto Date() para o formato hh:mm
 * 47) centralizar(obj, opc)			- Centraliza objeto na tela, Horizontal e/ou vertical
 * 48) alteraraba(numero, qtd, corantes, cordepois) - alterna as abas
 * 49) centralizarabas(qtd)				- Centraliza as abas da janela
 * 50) OnlyNumbersSemPonto(pCampo,pTeclaPres) - Exemplo: onkeypress="Javascript:OnlyNumbers(this,event);"
 * 51) setarObj(obj)					- Coloca o foco no objeto e muda de cor
 * 52) fecharJanela()					- captura o evento de fechar janela para limpar usuário da variável apllication
 * 53) TestaSenha(valor)				- Recebe String relativo a senha e devolve o grau de segurança
 * 54) habilitaCheckbox(frm)			- Habilita todas as checkbox para poder enviar o formulário
 * 55) arredondar(numero, casas)		- Arredonda um valor para um númerod de casas decimais
 * 56) trim(str)						- Remove espaços
 * 57) buscarEnter(event, page)			- Faz a busca apenas dando o enter nas caixas de busca padrão
 * 58) ts( trgt,inc ) 					- Aumenta ou diminui a fonte
 * 59) somenteNumerosSemPonto(evt)      - Valida somente números sem ponto
 * 60) somenteNumeros(evt)      		- Valida somente números com ponto
 * 61) move(formO,selectO,to) 			- Junto com a função swap, sobe e desce elementos de um select
 * 62) swap(fIndex,sIndex,formO,selectO)- troca elementos de posição
/* 

/***** SCRIPT PARA A BARRA DE STATUS ******/

/*
Script: Status Bar Decrypter v1.0 
Author: Anarchos [http://i.am/Anarchos] 
Modified by Option-line! [http://www.option-line.com/webmasters]
*/

function ObjDecrypt(id, data, delay)
{
	this.id = id;
	this.data = data ? data : "|| | ||| |";
	this.delay = delay ? delay : 3000;
	this.done = 1;
	this.msglist = new Array;
	this.msgix = -1;
	this.timer = null;
	this.mensagem = function(m) {
		this.msglist[this.msglist.length] = m;
	}
	this.iniciar = function() {
		if(this.msglist.length > 0) {
			this.msgix++;
			if(this.msgix >= this.msglist.length) this.msgix = 0;
			this.scheduler();
		}
		else
			window.status = 'Nenhuma mensagem definida!';
		return true;
	}
	this.scheduler = function() {
		window.setTimeout(this.id + ".decrypt('" + this.msglist[this.msgix] + "',2,3)", this.delay);
	}
	this.decrypt = function(text, max, delay) {
		if(this.done) {
		    this.done = 0;
    		this.decrypt_helper(text, max, delay, 0, max);
		}
	}
	this.decrypt_helper = function(text, runs_left, delay, charvar, max) {
		if(!this.done) {
			runs_left = runs_left - 1;
			var status = text.substring(0,charvar);
			for(var current_char = charvar; current_char < text.length; current_char++)
				status += this.data.charAt(Math.round(Math.random()*this.data.length));
			window.status = status;
			var rerun = this.id + ".decrypt_helper('" + text + "'," + runs_left + "," + delay + "," + charvar + "," + max + ");"
			var new_char = charvar + 1;
			var next_char = this.id + ".decrypt_helper('" + text + "'," + max + "," + delay + "," + new_char + "," + max + ");"
			if(runs_left > 0)
				window.setTimeout(rerun, delay);
			else {
				if (charvar < text.length)
					window.setTimeout(next_char, Math.round(delay*(charvar+3)/(charvar+1)));
				else {
					this.done = 1;
					this.iniciar();
				}
			}
		}
	}
	return this;
}

/***** SCRIPT PARA A BARRA DE STATUS ******/


	var oDecrypt;

	function barraStatus() {

		oDecrypt = new ObjDecrypt("oDecrypt");
		oDecrypt.mensagem("..:: KATU ::..");
		oDecrypt.mensagem("Sistemas Inteligentes para Saúde");
		oDecrypt.mensagem("http://www.katusis.com.br/");
		oDecrypt.iniciar();
	}


	function protegercodigo() {
		if(document.all) {
			if (event.button==2||event.button==3) {
				//alert('Copyright© 2005-2007 "Katu - Sistemas Inteligentes para Saúde" Todos os direitos reservados');
			}
		}
	}

	//Configura eventos
	document.onmousedown=protegercodigo;

	//Ao iniciar a página
    function inicio()
	{
		//Se veio algum id, é edição, então habilitar excluir
		if(idReg != "null") {
			botoes(1);
		}
		else {
			botoes(0);
		}
			
		mensagem(inf,0);
		barraStatus();
		try { hideAll(); }
		catch(e) { }
		window.defaultStatus = "..:: Clinic Web ::.."
	}

	//Ao clicar no botão novo
	function botaoNovo()
	{
		limpaForm();
		idReg="null";
		botoes(0);
	}

	//Verifica se existe algum campo obrigatório que não foi preenchido
	function validaCampos() {
		//Resposta da função (se não achar campos em branco, retorna true)
		var resp = true;

		//Passa por todos os campos obrigatórios
		for(i=0; i<campos_obrigatorios.length; i++)
		{
			obj = getObj("", campos_obrigatorios[i]);
			valor = obj.value;
			try { obj.style.backgroundColor = '#FFFFFF'; }
			catch(e) { }
			if(valor=="") {
				mensagem("O campo "+ nome_campos_obrigatorios[i] +" não foi preenchido!",2)
				resp = false;
				i = campos_obrigatorios.length; //Força o fim do looping
				setarObj(obj);
			}
			
		}
		return resp;			
	}
	

	//Habilita e desabilita botões conforme ação
	function botoes(tipo)
	{
	
		//Captura os botões para manipulá-los
		 var frm = cbeGetElementById("frmcadastrar");
		 var botNovo    = frm.novo;
		 var botSalvar  = frm.salvar;
		 var botExcluir = frm.exclui;

		try {
			 //Desabilita todos os botões e só habilita o que tem permissão
			 botNovo.disabled = true;
			 botSalvar.disabled = true;
			 botExcluir.disabled = true;
			 
			 if(tipo==0) { //Ao entrar na tela ou clicar no botão novo
				 botSalvar.disabled = false;
			 }
			 if(tipo==1) { //Quando abriu um registro para edição ou remoção
				botSalvar.disabled = false;
				botNovo.disabled = false;
				botExcluir.disabled = false;
			}
			if(tipo==2) {
				botNovo.disabled = true;
				botSalvar.disabled = true;
				botExcluir.disabled = true;
			}
		}
		catch(e) {
		
		}
	}

	//icon: 1-Correto, 2-Incorreto
	function mensagem(inf, icon)
	{
		//Local da Mensagem
		var tdmsg = cbeGetElementById("msg");
		var mens = "&nbsp;";
		
		//Se não veio nada, sair
		if(inf == "" || inf == "null") return;

		if(inf == "1") {
			mens = "Registro Inserido com Sucesso";
			icon = 1;
		}
		else if(inf =="2") {
			mens = "Ocorreu um erro na inserção do registro";
			icon = 2;
		}
		else if(inf == "3") {
			mens = "Registro removido com sucesso";
			icon = 1;
		}
		else if(inf == "4") {
			mens = "Erro na remoção do registro";
			icon = 2;
		}
		else if(inf == "5") {
			mens = "Registro alterado com sucesso";
			icon = 1;
		}
		else if(inf == "6") {
			mens = "Erro na alteração do registro";
			icon = 2;
		}
		else if(inf == "7") {
			mens = "Registro Duplicado";
			icon = 2;
		}
		else if(inf == "existelancamento") {
			mens = "Paciente não pode ser apagado pois existem lançamentos para o mesmo";
			icon = 2;
		}
		else if(inf == "existehistoria") {
			mens = "Paciente não pode ser apagado pois existem histórias para o mesmo";
			icon = 2;
		}
		else
			mens = inf;
			
		var imagem = "<img src='images/";

		if(mens != null)
		{
			if(icon == 1)
				mens = imagem + "yes.gif'>" + mens;
			else if(icon == 2)
				mens = imagem + "no.gif'>" + mens;
		}

		tdmsg.innerHTML = mens;
		
	}

    //Limpa os campos do formulário
	function limpaForm()
	{
		var obj;
		//Captura o formulário (sempre terá o mesmo nome)
		var frm = cbeGetElementById('frmcadastrar');

		//Varre todos os elementos, limpandos o conteúdo (exceto de botões)
		for(i=0; i<frm.elements.length; i++) {
			//Pega objeto por objeto do formulário
			obj = frm[i];

			//Se o tipo for botão, não limpar
			if(obj.type != "button"){
				obj.value = '';
			}
		}
		//Limpa o local de mensagens
		mensagem("&nbsp;",0);
	}

	//Seleciona todos os itens da combo para fazer o submit
	function selecionaCombo(frm)
	{
		var tam = frm.elements.length;
		var obj;

		//Varre todos os itens do formulário para encontrar as combos
    	for(var i=0;i<tam;i++)
		{
			//Pega objeto por objeto do formulário
			obj = frm[i];
			
			//Se achar uma combo, marcar todos os elementos
			if(obj.type == "select-multiple")
			{
				for(var j=0; j<obj.length; j++)
				{
					obj.options[j].selected = true;
				}
			}
		}
	}

	//Captura o objeto a partir do nome do formulário e nome do campo
	function getObj(frm, campo)
	{
		//Se não vir nome de formulário, considerar 'frmcadastrar'
		if(frm == "")
			return eval("cbeGetElementById('frmcadastrar')." + campo);
		else
			return eval("cbeGetElementById(" + frm + ")." + campo);
	}

	function buscar(page)
	{
		var frm = cbeGetElementById("frmcadastrar");
		frm.numPag.value = "1";
		frm.action = page + ".jsp";
		frm.submit();
	}

	function enviarAcao(tipo)
	{
		//Captura formulário
		var frm = cbeGetElementById("frmcadastrar");

		//Verifica permissões do usuário de incluir
		if(tipo == "inc" && idReg == "null" && incluir == "0") {
			alert("Esse usuário não possui permissão para incluir registros nesse cadastro!");
			return false;
		}

		//Verifica permissões do usuário de alterar
		if(tipo == "inc" && idReg != "null" && alterar == "0") {
			alert("Esse usuário não possui permissão para alterar o registro");
			return false;
		}

		//Verifica permissões do usuário de excluir
		if(tipo == "exc" && idReg != "null" && excluir == "0") {
			alert("Esse usuário não possui permissão para apagar o registro");
			return false;
		}

		//Se não veio o id, então é inclusão
		if(idReg == "null") {
			passou = validaCampos();
			if(!passou) return false;			
			frm.action = page + "?acao=" + tipo;
		}
		//Se veio o id
		else {
			//Se for inclusão, enviar ação de alterar e id ou excluir e id
			if(tipo == "inc")
			{
				passou = validaCampos();
				if(!passou) return false;
				frm.action = page + "?acao=alt&id=" + idReg;
			}
			//Se for exclusão, pedir para confirmar
			else
			{
				conf = confirm("Confirma a exclusão definitiva desse registro?","Confirmação")
				if(conf) frm.action = page + "?acao=exc&id=" + idReg;
				else { 
					frm.action = "";
					return false;
				}
			}
		}

		//Seleciona itens da combo para enviar
		selecionaCombo(frm);
		
		//Habilita todas as checkbox
		habilitaCheckbox(frm);

		if(frm.action != "")
			frm.submit();
		return true;		
	}

	//Verifica se o e-mail é válido
	function validaemail(obj){
			str = obj.value;
			var filter=/^.+@.+\..{2,3}$/
			if (filter.test(str))
				testresults=true
			else{
				testresults=false
			}
			
			//Se escreveu algum e-mail e se o teste deu inválido, mensagem
			if(str != "" && !testresults) {
				alert("e-mail inválido!");
				obj.focus();
			}
	}


	//Formata a entrada com somente números usando uma máscara
	function formatar(src, evt, mask){
 		wTecla = evt.keyCode;
		var isIE = false;
	
		if(wTecla==0)
			wTecla = evt.which;
		else
			isIE = true;
		
		//Teclas Válidas (Backspace e números)
 		if ( wTecla == 8 || wTecla >= 48 && wTecla <= 57 ){
			//Se for BackSpace, limpar caixa
			if(wTecla == 8)
			{
				src.value = "";
				return;
			}
		}
		else {
			if(isIE) evt.keyCode = 0;
			else	 return false;
		}

		var i = src.value.length;
		var saida = mask.substring(0,1);
		
		var texto = mask.substring(i);
		
		if (texto.substring(0,1) != saida) {
			src.value += texto.substring(0,1);
		}

		return true;
     }

     //Troca a cor do fundo da linha da tabela
     function trocaCor(objTR, tipo)
     {
		var cor, ponteiro;
		if( tipo == 1) { 
			cor = tdmedium;
			ponteiro = "pointer";
		}
		else {
			cor = tdlight;
			ponteiro = "default";
		}

		//Se o elemento for um TR, trocar a cor da linha toda (todos os TD´s)
		if(objTR.tagName == "TR") {
	
			for(var i=0;i<objTR.getElementsByTagName("td").length;i++){
				objTR.getElementsByTagName("td")[i].style.backgroundColor = cor;
				objTR.getElementsByTagName("td")[i].style.cursor = ponteiro;
			}
		}
		//Senão, pintar somente a célula
		else {
			objTR.style.backgroundColor = cor;
			objTR.style.cursor = ponteiro;
		}

     }

     //Vai para uma página
     function go(link)
     {
	  	var frm = cbeGetElementById("frmcadastrar");
		frm.action = link;
		frm.submit();
     }

     //Reenvia a página ordenando por outro campo
     function ordenar(page,campo)
     {
		var frm = cbeGetElementById('frmcadastrar');
		frm.action = page + ".jsp?ordem=" + campo;
		frm.submit();
     }	

     //Incluir itens em uma combo (select multiple)
     function insereCombo(nomecombo, valor, texto)
     {
			if(texto != "" && valor != "") {
	   			var combo = cbeGetElementById(nomecombo);
	   			if(existeValor(combo, valor) == false) {
					with(combo) {
						opcao = document.createElement("OPTION");
						opcao.text  = texto;
						opcao.value = valor;
						try {
							add(opcao, null); // standards compliant; doesn't work in IE
						}
						catch(ex) {
							add(opcao); // IE only
						}
					}
	  		    }
			}
     }

     //Verifica se um item já existe na lista, se existir, retorna true
     function existeValor(combo, valor)
     {
		  var result = false;
		  if(combo != null) {
			  if(combo.length > 0) {
				  for(var j=0; j<combo.length; j++) {
					if(combo.options[j].value == valor) {
						result = true;
					}
				  }
			  }
		  }
 	      return result;	
     }


	//Função que só permite digitar números no campo (usar evento onkeypress)
	//Exemplo: onkeypress="Javascript:OnlyNumbers(this,event);"
	function OnlyNumbers(pCampo,pTeclaPres) {
		var wTecla, wVr;
 		var isIE = false;
	
 		wTecla = pTeclaPres.keyCode;
		
		if(wTecla == 0)
			wTecla = pTeclaPress.which;
		else
			isIE = true;
		
 		wVr = pCampo.value;
		wTam = wVr.length ;

 		if ( wTecla == 8 || wTecla == 46 || wTecla >= 48 && wTecla <= 57 ){
			//Teclas Válidas
			//Se for ponto, verificar se já tem outro e se tem número antes
			if(wTecla == 46) {
				if(wVr.indexOf(".") >=0 || wTam == 0) {
					if(isIE) pTeclaPres.keyCode = 0;
					else return false;
				}
			}
		}
		else {
			if(isIE) pTeclaPres.keyCode = 0;
			else return false;
		}
		
		return true;
	}
	

	function setarCampoPai(campo, valor)
	{
		frm = window.opener.document.frmcadastrar;
		eval("frm."+campo+".value='"+valor+"'");
	}
	
	function fecharJanelaeAtualizar()
	{
		var page = window.opener.document;
		var popup = window.document.title;
		var titulo = page.title;
		
        //Se não for a busca por profissional (só a busca por paciente), atualizar em alguns casos
		if(popup != "..:Buscar Profissional:..") {
			if(titulo == "Faturamento" || titulo == "Histórico" || titulo == "Fichas de Atendimento" || titulo == "Laudos de Exames") {
				var frm = page.frmcadastrar;
				frm.submit();
			}
		}
		self.close();
	}

	//Função que valida CPF
	function valida_cpf_cnpj(obj) {
		var valor = obj.value;
		//Remove os 2 pontos, o traço e a barra para análise
		valor = valor.replace(".","");
		valor = valor.replace(".","");
		valor = valor.replace("-","");
		valor = valor.replace("/","");		
		var tam = valor.length;

		if(tam==14) {
			if(!cgc(valor)) {
				alert("CNPJ Inválido.Redigite!")
				obj.focus();
				return;
			}
		}
		else {
			if(tam==11) {
				if(!cpf(valor)) {
					alert("CPF Inválido. Redigite!")
					obj.focus();
					return;
				}
			}
			else {
				if(tam !=0) {
					alert("Tamanho inválido de CPF ou CNPJ!")
					obj.focus();
					return;
				}
			}
		}
	}

	//Valida CGC
	function cgc(pcgc) {
       		// verifica o tamanho
 		if (pcgc.length != 14) {
  			sim=false
  			alert ("Tamanho Invalido de CGC")
  		}
 		else {sim=true}
		if (sim )  // verifica se e numero
  		{
  			for (i=0;((i<=(pcgc.length-1))&& sim); i++)
  			{
   				val = pcgc.charAt(i)
       				// alert (val)
   				if ((val!="9")&&(val!="0")&&(val!="1")&&(val!="2")&&(val!="3")&&(val!="4") &&
				(val!="5")&&(val!="6")&&(val!="7")&&(val!="8")) {sim=false}
   			}
   			if (sim)  // se for numero continua
   			{
   				m2 = 2
    				soma1 = 0	
    				soma2 = 0
    				for (i=11;i>=0;i--)
    				{
     					val = eval(pcgc.charAt(i))
       					// alert ("Valor do Val: "+val)
     					m1 = m2
  					if (m2<9) { m2 = m2+1}
  					else {m2 = 2}
  					soma1 = soma1 + (val * m1)
  					soma2 = soma2 + (val * m2)
    				}  // fim do for de soma

  				soma1 = soma1 % 11
  				if (soma1 < 2) {  d1 = 0}
   				else { d1 = 11- soma1}

     				soma2 = (soma2 + (2 * d1)) % 11
  				if (soma2 < 2) { d2 = 0}
   				else { d2 = 11- soma2}
        			// alert (d1)
       				// alert (d2)
    				if ((d1==pcgc.charAt(12)) && (d2==pcgc.charAt(13))) { 
					//alert("Valor Valido de CCG")
					return true;
				}
   				else {
					//alert("Valor invalido de CCG")
					return false;
   				}
 			}

 		}
	}


	 function cpf(pcpf) {
		if (pcpf.length != 11) {sim=false}
 		else {sim=true}

  		if (sim )  // valida o primeiro digito
  		{
  			for (i=0;((i<=(pcpf.length-1))&& sim); i++)
  			{
   				val = pcpf.charAt(i)
   				if ((val!="9")&&(val!="0")&&(val!="1")&&(val!="2")&&(val!="3")&&(val!="4")
				 && (val!="5")&&(val!="6")&&(val!="7")&&(val!="8")) {sim=false}
   			}

   			if (sim)
  			{
    				soma = 0
    				for (i=0;i<=8;i++)
    				{
     					val = eval(pcpf.charAt(i))
     					soma = soma + (val*(i+1))
    				}

    				resto = soma % 11
    				if (resto>9) dig = resto -10
    				else  dig = resto
    				if (dig != eval(pcpf.charAt(9))) { sim=false }
   				else   // valida o segundo digito
    				{
     					soma = 0
    					for (i=0;i<=7;i++)
     					{
     						val = eval(pcpf.charAt(i+1))
      						soma = soma + (val*(i+1))
   					}

     					soma = soma + (dig * 9)
    					resto = soma % 11
     					if (resto>9) dig = resto -10
     					else  dig = resto
   					if (dig != eval(pcpf.charAt(10))) { sim = false }
    					else sim = true
  				}
   			}
  		}

  		if (sim) { 
			//alert("Valor Valido de CPF") 
			return true;
		}
  		else {
			//alert("Valor invalido de CPF")
			return false;
		}
	}

	//Função que Valida a data. usar no evento onblur
	function ValidaData(pCampo) {
 		wVr = pCampo.value;
		wTam = wVr.length ;

		//Se o tamanho de data estiver errado
		if(wTam != 10 && wTam > 0) {
			pCampo.value = "";
			alert("Tamanho de data incorreto. Digite a data no formato dd/mm/aaaa.");
			pCampo.focus();
			return;
		}

		//Calcula as posições das Barras
		pos1 = wVr.indexOf("/",0);
		pos2 = wVr.indexOf("/",pos1+1);

		//Isola o dia, mês e ano da data
		dia = wVr.substring(0,pos1);
		mes = wVr.substring(pos1+1,pos2);
		ano = wVr.substring(pos2+1,wTam);
		
		if(wTam > 0) {
			if(dia<1 || dia > 31) {
				alert("Não existe dia "+dia+" em nenhum mês.")
	  			pCampo.focus();
				return;
			}

			if(mes<1 || mes>12) {
				alert("Não existe mês "+mes+" no ano.")
	  			pCampo.focus();
				return;
			}
		}
					

 		if ((mes==4 || mes==6 || mes==9 || mes==11) && dia==31){
  			alert("Este mês não tem 31 dias!")
  			pCampo.focus();
  		}
 		if (mes == 2) {
			  var bissexto = (ano % 4 == 0 && (ano % 100 != 0 || ano % 400 == 0));
  				if (dia>29 || (dia==29 && !bissexto))	{
   						alert("Fevereiro não possui "+dia+" dias.")
						pCampo.value = "/"+mes+"/"+ano;
						pCampo.focus();
      			}
  		}
		
		if(ano != "" && (ano < 1900 || ano > 3000)) {
			alert("Ano inválido. Retifique. ");
			pCampo.value = "";
			pCampo.focus();
		}
	}

	//Verifica se a data é maior que a data de hoje
	function ValidaFuturo(pCampo) {
 		wVr = pCampo.value;
		wTam = wVr.length ;

		//Calcula as posições das Barras
		pos1 = wVr.indexOf("/",0);
		pos2 = wVr.indexOf("/",pos1+1);

		//Isola o dia, mês e ano da data
		dia = wVr.substring(0,pos1);
		mes = wVr.substring(pos1+1,pos2);
		ano = wVr.substring(pos2+1,wTam);
	
		var Hoje = new Date();
		var Data = new Date(ano,mes-1,dia);

		if(Data > Hoje) {
			pCampo.value = "";
			alert("Data maior que a data atual. Retifique.")		
			pCampo.focus();
		}
	}
	
	function ValidaHora(pCampo) {

		wVr = pCampo.value;
		wTam = wVr.length ;


		pos = wVr.indexOf(":")
		if(pos >=0) {
			var hora = wVr.substring(0,pos);
			if(hora<10 && hora.length==1) { hora = "0" + hora; }
			if(hora>23 || hora<0) {
				alert("Hora deve estar no intervalo de 00:00 a 23:59!")
				pCampo.focus();
				return;
			}
			var minuto = wVr.substring(pos+1,wTam);
			if(minuto < 0 || minuto > 59) {
				alert("Minuto deve estar entre 0 e 59!")
				pCampo.focus();
				return;
			}
			if(minuto.length == 0) { minuto = "00";}
			if(minuto.length == 1) { minuto += "0";}
			pCampo.value = hora + ":" + minuto;
			return;
		}
		else {
			if(wTam > 0) {
				alert("Formato Inválido de Horas. Tente hh:mm")
				pCampo.focus();
				return;
			}
		}
	}
	
	function getHoje()
	{
		//Data do sistema
		minhaDataAtual = new Date() 
		//extraímos o dia, mês e ano 
		dia = minhaDataAtual.getDate();
		if(dia<10) dia = "0" + dia;
		mes = parseInt(minhaDataAtual.getMonth()) + 1 
		if(mes<10) mes = "0" + mes;
		ano = minhaDataAtual.getFullYear()
		
		//Devolve formatada
		return dia + "/" + mes + "/" + ano;
		
	}	 
	
	function formatCurrency(num) {
		var compl = 0.50000000001;
		num = num.toString().replace(/\$|\,/g,'');
		if(isNaN(num))
		num = "0";
		sign = (num == (num = Math.abs(num)));
		num = Math.floor(num*100+compl);
		cents = num%100;
		num = Math.floor(num/100).toString();
		if(cents<10)
		cents = "0" + cents;
		for (var i = 0; i < Math.floor((num.length-(1+i))/3); i++)
		num = num.substring(0,num.length-(4*i+3))+'.'+
		num.substring(num.length-(4*i+3));
		return (((sign)?'':'-') + num + ',' + cents);
	}
	
	var version4 = (navigator.appVersion.charAt(0) == "4"); 
	var popupHandle;
	function closePopup() {
		if(popupHandle != null && !popupHandle.closed) popupHandle.close();
	}
	
	var novajanela; //Variável global que guarda referência para pop-up

	//Abre uma janela popup com determinada largura, altura, um valor a ser enviado e nome do parâmetro por GET
	function janela(pagina, larg, alt, id, parametro) {	
			var codigo;
			if(id != "null") {
				//Se já tiver algum parâmetro, usar '&' para concatenar, senão,  usar '?'
				if(pagina.indexOf('?') != -1)	codigo = "&";
				else codigo = "?";
				
				//Se não escolheu o nome do parâmetro, usar 'cod'
				if(parametro == "" || parametro == null) parametro = "cod";
		
				pagina += codigo + parametro + "=" + id;

				displayPopup(pagina,'popup',alt,larg);
				//eval("novajanela = window.open('"+pagina+"','popup','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,width="+larg+",height="+alt+",top=10,left=10');")
			}
	}
	
	function displayPopup(url,name,height,width) {
		displayPopup(url,name,height,width,res, "no");
	}
	
	function displayPopup(url,name,height,width,res) {
		// position=1 POPUP: makes screen display up and/or left, down and/or right 
		// depending on where cursor falls and size of window to open
		// position=2 CENTER: makes screen fall in center
		var properties = "toolbar = 0, location = 0, height = " + height;
		properties += ", width=" + width;
		properties += ",resizable=" + res;
		properties += ",scrollbars=" + res;
		var leftprop, topprop, screenX, screenY, cursorX, cursorY, padAmt;
		if(navigator.appName == "Microsoft Internet Explorer") {
			screenY = document.body.offsetHeight;
			screenX = window.screen.availWidth;
		}
		else {
			screenY = window.outerHeight
			screenX = window.outerWidth
		}
		leftvar = (screenX - width) / 2;
		rightvar = (screenY - height) / 2;
		if(navigator.appName == "Microsoft Internet Explorer") {
			leftprop = leftvar;
			topprop = rightvar;
		}
		else {
			leftprop = (leftvar - pageXOffset);
			topprop = (rightvar - pageYOffset);
   		}

		properties = properties + ", left = " + leftprop;
		properties = properties + ", top = " + topprop;

		popupHandle = open(url,name,properties);
	}

	//Seta as informações do paciente na página de história ao selecionar um paciente da busca
	function setarDadosPaciente(codigo, paciente, nascimento, cod_convenio, descr_convenio)
	{
		//Preenche dados do código, nome e nascimento
		setarCampoPai('codcli', codigo);
		setarCampoPai('paciente', paciente);
		setarCampoPai('nascimento', nascimento);

		//Para algumas telas, inserir convênio do paciente
		tituloPai = window.opener.document.title;
		if(tituloPai == "Faturamento" || tituloPai == "Agenda") {
			var pai = window.opener;
			pai.setarConvenio(cod_convenio, descr_convenio);
		}

		//Para alguma telas, setar o convenio na caixa
		if(tituloPai == "Histórico" ) {
			setarCampoPai('convenio', cod_convenio);
			setarCampoPai('nomeconvenio', descr_convenio);
		}
	
		//Separa dia, mês e ano para calcular idade
	  	dia = parseInt(nascimento.substring(0,3));
	  	mes = parseInt(nascimento.substring(3,6));
	  	ano = parseInt(nascimento.substring(6));

		setarCampoPai('idade', getIdade(nascimento));
	}
	
	//Devolve a hora atual no formato hh:mm
	function getHora()
	{
		hoje = new Date();
		hora = hoje.getHours();
		minuto = hoje.getMinutes();	
		
		if(hora<10) hora = "0" + hora;
		if(minuto<10) minuto = "0" + minuto;
		
		return (hora + ":" + minuto);
	}
	
	//Devolve a quantidade de dias de um mês
	function getDias(mes, ano)
	{
		//Cria vetor com a quantidade de dias de cada mês
		var vetorDias = Array(31,28,31,30,31,30,31,31,30,31,30,31);
		//Se for ano bissexto, fevereiro tem 29 dias
		if((ano%4==0 && ano%100!=0) || ano%400==0)
			vetorDias[1] = 29;

		//Retorna a quantidade de dias do mês, mas se for janeiro, retornar dezembro
		if(mes > 0)
			return vetorDias[mes-1];
		else
			return vetorDias[11];
	}

	//Devolve o tempo de vida da pessoa em anos, meses e dias
	function getIdade(nascimento)
	{
		//Se não veio a data correta
		if(nascimento == null || nascimento.length != 10)
			return "";

		//Separa dia, mês e ano para calcular idade
	  	dia = toInt(nascimento.substring(0,2));
	  	mes = toInt(nascimento.substring(3,5));
	  	ano = toInt(nascimento.substring(6));
	
		//Captura a data atual
		hoje = new Date();
		diahoje = hoje.getDate();
		meshoje = hoje.getMonth() + 1;
		anohoje = hoje.getFullYear();
	
		//Diferença entre os anos
		anos = anohoje - ano;
		
		//Se ainda não chegou no mês de aniversário
		if(meshoje < mes) {
			anos--;	
			meses = 12 - (mes - meshoje);
			if(diahoje < dia) {
				meses--;
				dias = (getDias(meshoje-1, anohoje) - dia) + diahoje;
			}
			else{
				//Resto do mês atual mais dias do mês seguinte até o aniversário
				dias = diahoje-dia;
			}
		}
		//Se está no mês do aniversário
		else if(meshoje == mes) {
				//Se ainda não chego no dia
				if(diahoje < dia) {
					anos--;
					meses = 11;
					dias = getDias(meshoje-1, anohoje) - dia + diahoje;
				}
				else {
					meses = 0;
					dias = diahoje - dia;
				}
		}
		//Se já passou o mês de aniversário
		else {
				meses = meshoje - mes;
				if(diahoje < dia) {
					meses--;
					dias = getDias(meshoje-1, meshoje) - dia + diahoje;
				}
				else {
					dias = diahoje - dia;				
				}
		}
		
		//Se tiver zerado algum item, não imprimir
		if(anos == 0) anos = "";
		else anos = anos + "a "; 
		if(meses == 0) meses = "";
		else meses = meses + "m ";
		if(dias == 0) dias = "";
		else dias = dias + "d ";

		return (anos + meses + dias);

	}
	
	function mostraImagem(caminho)
	{
		//displayPopup("imagem.jsp?img=" + caminho, "imagem", 400, 400);
		eval("imagem = window.open('imagem.jsp?img="+caminho+"','imagem','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,menubar=no,width=200,height=200,top=10,left=10');")
	}
	
    //Cria paginação
	function navegacao(page, numero)
	{
		var frm = cbeGetElementById("frmcadastrar");
		frm.numPag.value = numero
		frm.action = page;
		frm.submit();
	}
	
	//Tranforma um valor em String para int (problemas com parseInt("09"))
	function toInt(valor)
	{
		var resp;
		switch(valor)
		{
			case "01": resp = 1; break;
			case "02": resp = 2; break;
			case "03": resp = 3; break;
			case "04": resp = 4; break;
			case "05": resp = 5; break;
			case "06": resp = 6; break;
			case "07": resp = 7; break;
			case "08": resp = 8; break;
			case "09": resp = 9; break;
			default: resp = parseInt(valor);
		}
		
		return resp;
	}
	
	function abreLink(links, titulo)
	{
		frm = cbeGetElementById("frmcadastrar");
		frm.link.value = links;
		frm.titulo.value = titulo;
		frm.action = "pagina.jsp";
		frm.target = "_blank";
		frm.submit();
	}
	
	//Função que calcula a diferença em dias de duas datas
	function difDatas(data1, data2)
	{
		//Separa dia, mês e ano
		d1 = data1.substring(0,2);
		m1 = data1.substring(3,5);
		a1 = data1.substring(6);

		//Separa dia,  mês e ano
		d2 = data2.substring(0,2);
		m2 = data2.substring(3,5);
		a2 = data2.substring(6);
			
		//Converte em objeto date
		data1 = new Date(a1,m1-1,d1);
		data2 = new Date(a2,m2-1,d2);
	
		//Calcula a diferença em dias
		var dif = (data2.getTime() - data1.getTime()) / (3600*24*1000);		

		//Usa valor positivo
		if(dif<0) dif=-dif;
		
		return dif;
	}

	//Verifica se a data é menor que a data de hoje
	function ValidaPassado(pCampo) {
 		wVr = pCampo.value;
		wTam = wVr.length ;
	
		//Só valida se algo está escrito
		if(wTam>0) {
			//Calcula as posições das Barras
			pos1 = wVr.indexOf("/",0);
			pos2 = wVr.indexOf("/",pos1+1);
	
			//Isola o dia, mês e ano da data
			dia = wVr.substring(0,pos1);
			mes = wVr.substring(pos1+1,pos2);
			ano = wVr.substring(pos2+1,wTam);
		
			var Hoje = new Date();
			var Data = new Date(ano,mes-1,dia, 23, 59, 59);

			if(Data < Hoje) {
				alert("Data menor que a data atual. Retifique.")		
				pCampo.value = "";
				pCampo.focus();
			}
		}
	}

	function cadastrorapido() {
		var nome = cbeGetElementById("nome").value;
		eval("janela = window.open('buscapaciente.jsp?nome=" + nome + "','popupcadastrorapido','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,menubar=no,width=600,height=250,top=10,left=10');")
	}

	function formataData(data) {
		dia = data.getDate();
		mes = data.getMonth()+1;
		ano = data.getFullYear();

		if(dia<10) dia = "0" + dia;
		if(mes<10) mes = "0" + mes;
		
		return dia + "/" + mes + "/" + ano;
	}
	
	function formataHora(data) {
	
		hora = data.getHours();
		minuto = data.getMinutes();	
		
		if(hora<10) hora = "0" + hora;
		if(minuto<10) minuto = "0" + minuto;
		
		return (hora + ":" + minuto);
	
	}

	//Centraliza objeto na tela
	//obj = objeto a centralizar
	//opc = opção de centralização (H=Horizontal, V=Vertical, HV ou VH=Horizontal e Vertical)
	function centralizar(obj, opc) {
		//Tamanho do objeto
		var width = parseInt(obj.style.width);
		var height = parseInt(obj.style.height);
		
		var leftprop, topprop, screenX, screenY, cursorX, cursorY, padAmt;
		if(navigator.appName == "Microsoft Internet Explorer") {
			screenY = document.body.offsetHeight;
			screenX = document.body.clientWidth;
		}
		else {
			screenY = window.outerHeight
			screenX = document.body.clientWidth;
		}
		leftvar = (screenX - width) / 2;
		rightvar = (screenY - height) / 2;
		if(navigator.appName == "Microsoft Internet Explorer") {
			leftprop = leftvar;
			topprop = rightvar;
		}
		else {
			leftprop = (leftvar - pageXOffset);
			topprop = (rightvar - pageYOffset);
   		}
		
		//Se escolheu Horizontal
		if(opc.indexOf("H") >= 0) 
			obj.style.left = leftprop;
		
		//Se escolheu vertical
		if(opc.indexOf("V") >=0)
			obj.style.top = topprop;
	
	}
	
	//Alternar as abas
	function alteraraba(numero, qtd, corantes, cordepois) {

		//Coloca todas as abas na mesma camada
		for(i=1; i<=qtd; i++) {
			eval("cbeGetElementById('aba"+i+"').style.zIndex=1");
			eval("cbeGetElementById('tdaba"+i+"').style.cursor = 'pointer'");
			eval("cbeGetElementById('tdaba"+i+"').style.backgroundColor=corantes");
		}

		//Coloca somente a aba escolhida para uma camada superior
		eval("cbeGetElementById('aba"+numero+"').style.zIndex=10");
		eval("cbeGetElementById('tdaba"+numero+"').style.backgroundColor=cordepois");
		
		//Coloca o número da aba no campo hidden para recuperar
		cbeGetElementById('numeroaba').value = numero;
		
	}
	
	//Centraliza as abas da janela
	 function centralizarabas(qtd) {
	 	//Centralizar abas	
		for(i=1; i<=qtd; i++) {
			eval("centralizar(cbeGetElementById('aba"+i+"'), 'H')");
		}
		//Centralizar iframe e abas
		centralizar(cbeGetElementById("iframeaba"), "H");
		centralizar(cbeGetElementById("menuabas"), "H");
		
	 }
	
	//Exemplo: onkeypress="Javascript:OnlyNumbersSemPonto(this,event);"
     function OnlyNumbersSemPonto(pCampo,pTeclaPres) {
		var wTecla, wVr;
 		var isIE = false;
	
 		wTecla = pTeclaPres.keyCode;
		
		if(wTecla == 0)
			wTecla = pTeclaPress.wich;
		else
			isIE = true;
		
 		wVr = pCampo.value;
		wTam = wVr.length ;

 		if ( wTecla == 8 || wTecla >= 48 && wTecla <= 57 ){
			//Teclas Válidas
		}
		else {
			if(isIE) pTeclaPres.keyCode = 0;
			else return false;
		}
		
		return true;
	}
	
	//Coloca o foco no objeto e muda de cor
	function setarObj(obj) {
		try { 
			obj.style.backgroundColor = '#FF8080';
			obj.focus(); 
		} 
		catch (e) { }

	}
	
	//captura o evento de fechar janela para limpar usuário da variável apllication
	function fecharJanela() {
	}
	
	window.onunload = fecharJanela;
	
	
  // Recebe String relativo
  function TestaSenha(valor) {
     var d = document.getElementById('seguranca');
	 var resp = "";
     // Expressões Regulares
     ERaz = /[a-z]/;
     ERAZ = /[A-Z]/;
     ER09 = /[0-9]/;
     ERxx = /[@!#$%&*+=?|-]/;
     // Teste da String
     if(valor.length == ''){
       d.innerHTML = '&nbsp;';
     } else {
       if(valor.length < 5){
         d.innerHTML = '<font color=\'red\'>BAIXA</font>';
       } else {
         if(valor.length > 7 && valor.search(ERaz) != -1 && valor.search(ERAZ) != -1 && valor.search(ER09) != -1 || valor.search(ERaz) != -1 && valor.search(ERAZ) != -1 && valor.search(ERxx) || valor.search(ERaz) != -1 && valor.search(ERxx) != -1 && valor.search(ER09) || valor.search(ERxx) != -1 && valor.search(ERAZ) != -1 && valor.search(ER09)){
           d.innerHTML = '<font color=\'green\'> ALTA</font>';
         } else {
           if(valor.search(ERaz) != -1 && valor.search(ERAZ) != -1 || valor.search(ERaz) != -1 && valor.search(ER09) != -1 || valor.search(ERaz) != -1 && valor.search(ERxx) != -1 ||valor.search(ERAZ) != -1 && valor.search(ER09) != -1 ||valor.search(ERAZ) != -1 && valor.search(ERxx) != -1 ||valor.search(ER09) != -1 && valor.search(ERxx) != -1){
             d.innerHTML = '<font color=\'orange\'> MEDIA</font>';
           } else {
             d.innerHTML = '<font color=\'red\'> BAIXA</font>';
           }
         }
       }
     }
  }

	//Habilita todas as checkbox para poder enviar o formulário
	function habilitaCheckbox(frm)
	{
		var tam = frm.elements.length;
		var obj;

		//Varre todos os itens do formulário para encontrar os checks
    	for(var i=0;i<tam;i++)
		{
			//Pega objeto por objeto do formulário
			obj = frm[i];
			
			//Se achar uma checkbox
			if(obj.type == "checkbox")
			{
				obj.disabled = false;
			}
		}
	}
	
	//Muda o foco para o prox. campo
	function mudaFoco(campo, tammax, prox) {
		if(campo.value.length == tammax)
			cbeGetElementById(prox).focus();
	}
	
	//Modo de usar: onKeyPress="return soNumeros(event)"
	function soNumeros(e) {
	    var tecla=new Number();
 
    	if(window.event) {
			 tecla = e.keyCode;
    	}
    	else if(e.which) {
			 tecla = e.which;
    	}
    	else {
			 return true;
    	}
    
    	if(((tecla < 48) || (tecla > 57)) && (tecla!=8) ) {
			 return false;
    	}
    
	}
	
	//Arredonda um valor para um númerod de casas decimais
	function arredondar(numero, casas) {
		var x = new Number();
		var a=260;
		var b=.049;
		x = parseFloat(numero);
			
		return x.toFixed(2);
	}
	
	//Remove espaços
	function trim(str){
		return str.replace(/^\s+|\s+$/g,"");
	}

	//Faz a busca apenas dando o enter nas caixas de busca padrão
	function buscarEnter(e, page)
	{
	    var tecla=new Number();
 
    	if(window.event) {
			 tecla = e.keyCode;
    	}
    	else if(e.which) {
			 tecla = e.which;
    	}
		
		if(tecla == 13) {
			var frm = cbeGetElementById("frmcadastrar");
			frm.numPag.value = "1";
			frm.action = page + ".jsp";
			frm.submit();
		}
	}
	
	//Specify affected tags. Add or remove from list:
	var tgs = new Array( 'td', 'div' );
	
	//Specify spectrum of different font sizes:
	var szs = new Array( 'xx-small','x-small','small','medium','large','x-large','xx-large' );
	var startSz = 2;
	
	function ts( trgt,inc ) {
		if (!document.getElementById) return
		var d = document,cEl = null,sz = startSz,i,j,cTags;
		sz += inc;
		if ( sz < 0 ) sz = 0;
		if ( sz > 6 ) sz = 6;
		startSz = sz;
		if ( !( cEl = d.getElementById( trgt ) ) ) cEl = d.getElementsByTagName( trgt )[ 0 ];
		
		cEl.style.fontSize = szs[ sz ];
		
		for ( i = 0; i < tgs.length; i++ ) {
		cTags = cEl.getElementsByTagName( tgs[ i ] );
		for ( j = 0; j < cTags.length; j++ ) cTags[ j ].style.fontSize = szs[ sz ];
		}
	}		
	
	//Valida somente números sem ponto
	//onKeyPress="return somenteNumerosSemPonto(event)"
	function somenteNumerosSemPonto(evt) {
		evt = (evt) ? evt : window.event;
		var charCode = (evt.which) ? evt.which : evt.keyCode;
		if (charCode > 31 && (charCode < 48 || charCode > 57)) {
			status = "Esse campos só aceita números";
			return false;
		}
		status = "";
		return true;
	}

	//Valida somente números incluindo ponto
	//onKeyPress="return somenteNumeros(event)"
	function somenteNumeros(evt) {
		evt = (evt) ? evt : window.event;
		var charCode = (evt.which) ? evt.which : evt.keyCode;

		if (charCode != 8 && charCode != 46 && charCode > 31 && (charCode < 48 || charCode > 57)) {
			status = "Esse campos só aceita números";
			return false;
		}
		status = "";
		return true;
	}
	
    function move(formO,selectO,to) {

		//Pega o índice do elemento selecionado
		var index = selectO.selectedIndex;

		//Tamanho da seleção
		var selectLength  = selectO.length - 1;
        
		//Nada selecionado
		if (index == -1) return false;
        
		//Máximo pra baixo
		if(to == +1 && index == selectLength) {
            alert("Limite inferior");
            return;
        }
        else if(to == -1 && index == 0)
        {
            alert("Limite superior");
            return;
        }
        
        swap(index,index+to,formO,selectO);
    }
    
    //basic swap
    function swap(fIndex,sIndex,formO,selectO) {
        //store first
        fText  = selectO.options[fIndex].text;
        fValue = selectO.options[fIndex].value;
        
        //make first = second
        selectO.options[fIndex].text  = selectO.options[sIndex].text;
        selectO.options[fIndex].value = selectO.options[sIndex].value;  
        
        //make second = first
        selectO.options[sIndex].text = fText;
        selectO.options[sIndex].value = fValue;
        
        //amke new one be selected
        selectO.options[sIndex].selected = true;
		selectO.options[fIndex].selected = false;    
        
    }
    
 	
