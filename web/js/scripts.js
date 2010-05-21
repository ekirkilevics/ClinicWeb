/******  SCRIPT PARA A MANIPULAÇÃO DO MENU EM ÁRVORE *********/

var temp, temp2, cookieArray, cookieArray2, cookieCount;

function sair() {
	conf = confirm("Deseja sair do Clinic Web?")
	if(conf)
		parent.location='index.jsp?saida=' + cod_usuario;
}
	
function alterarSenha() {
	displayPopup("alterarsenha.jsp","senha",180,400);
}

function verponto(){ 
	displayPopup("verponto.jsp","senha",455,600);
}

function agendatelefonica(){ 
	displayPopup("agendatelefonica.jsp","senha",550,630);
}

function agendapessoal(){ 
	displayPopup("agendapessoal.jsp","senha",550,700, "yes");
}

function cadastraPonto() {
	displayPopup("ponto.jsp","ponto",180,300);
}

function initiate(){

  cookieCount=0;

  if(document.cookie){

    cookieArray=document.cookie.split(";");
    cookieArray2=new Array();

    for(i in cookieArray){
      cookieArray2[cookieArray[i].split("=")[0].replace(/ /g,"")]=cookieArray[i].split("=")[1].replace(/ /g,"");
    }

  }

  cookieArray=(document.cookie.indexOf("state=")>=0)?cookieArray2["state"].split(","):new Array();

  temp=document.getElementById("containerul");

  for(var o=0;o<temp.getElementsByTagName("li").length;o++){

    if(temp.getElementsByTagName("li")[o].getElementsByTagName("ul").length>0){

      temp2				= document.createElement("span");
      temp2.className			= "symbols";
      temp2.style.backgroundImage	= (cookieArray.length>0)?((cookieArray[cookieCount]=="true")?"url(images/minus.png)":"url(images/plus.png)"):"url(images/plus.png)";
      temp2.onclick=function(){
        showhide(this.parentNode);
        writeCookie();
      }

      temp.getElementsByTagName("li")[o].insertBefore(temp2,temp.getElementsByTagName("li")[o].firstChild)

      temp.getElementsByTagName("li")[o].getElementsByTagName("ul")[0].style.display = "none";
	
      if(cookieArray[cookieCount]=="true"){
        showhide(temp.getElementsByTagName("li")[o]);
      }

      cookieCount++;

    }
    else{

      //Força o tamanho grande para não quebrar a linha
      temp.getElementsByTagName("li")[o].style.width = '200';

      temp2				= document.createElement("span");
      temp2.className			= "symbols";
      temp2.style.backgroundImage	= "url(images/page.gif)";

      temp.getElementsByTagName("li")[o].insertBefore(temp2,temp.getElementsByTagName("li")[o].firstChild);

    }


  }

}



function showhide(el){

  el.getElementsByTagName("ul")[0].style.display=(el.getElementsByTagName("ul")[0].style.display=="block")?"none":"block";

  el.getElementsByTagName("span")[0].style.backgroundImage=(el.getElementsByTagName("ul")[0].style.display=="block")?"url(images/minus.png)":"url(images/plus.png)";

}



function writeCookie(){		// Runs through the menu and puts the "states" of each nested list into an array, the array is then joined together and assigned to a cookie.

  cookieArray=new Array()

  for(var q=0;q<temp.getElementsByTagName("li").length;q++){

    if(temp.getElementsByTagName("li")[q].childNodes.length>0){
      if(temp.getElementsByTagName("li")[q].childNodes[0].nodeName=="SPAN" && temp.getElementsByTagName("li")[q].getElementsByTagName("ul").length>0){

        cookieArray[cookieArray.length]=(temp.getElementsByTagName("li")[q].getElementsByTagName("ul")[0].style.display=="block");

      }
    }

  }

  document.cookie="state="+cookieArray.join(",")+";expires="+new Date(new Date().getTime() + 365*24*60*60*1000).toGMTString();

}


/******  SCRIPT PARA A MANIPULAÇÃO DO MENU EM ÁRVORE *********/

