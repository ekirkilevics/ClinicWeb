<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.Agenda" id="agenda" scope="page"/>

<%
	//Mês a data do calendàrio a exibir
	int dia    = request.getParameter("dia") != null ? Integer.parseInt(request.getParameter("dia")) : 0;
	int mes    = request.getParameter("mes") != null ? Integer.parseInt(request.getParameter("mes")) : 0;
	int ano    = request.getParameter("ano") != null ? Integer.parseInt(request.getParameter("ano")) : 0;
	String prof_reg   = request.getParameter("prof_reg") != null ? request.getParameter("prof_reg") : "";
	String medico = "";
	
	//Buscar nome do médico
	if(!Util.isNull(prof_reg)) {
		medico = banco.getValor("nome", "SELECT nome FROM profissional WHERE prof_reg='" + prof_reg + "'");
	}

	//Calcula data anterior e posterior
	int depois[] = agenda.navegaData(dia, mes, ano, 1);
	int antes[] = agenda.navegaData(dia, mes, ano, -1);

	String data = agenda.toString(dia, mes, ano);

	//Captura os parâmetros
	String query = request.getQueryString();
	String anterior = "", posterior = "";
	anterior = query.replace("dia=" + dia, "dia=" + antes[0]);
	anterior = anterior.replace("mes=" + mes, "mes=" + antes[1]);
	anterior = anterior.replace("ano=" + ano, "ano=" + antes[2]);
	posterior = query.replace("dia=" + dia, "dia=" + depois[0]);
	posterior = posterior.replace("mes=" + mes, "mes=" + depois[1]);
	posterior = posterior.replace("ano=" + ano, "ano=" + depois[2]);
	
%>

<html>
<head>
<title>..: Agenda do Médico :..</title>
<link href="css/css.css" rel="stylesheet" type="text/css">
<META HTTP-EQUIV="Refresh" CONTENT="60">
<META HTTP-EQUIV="expires" CONTENT="0">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
<script language="JavaScript">
	
	//Informação vinda de gravar
    var inf = "<%= inf%>";
	var jsdia = "<%= data%>";
	
	function verHistoricos(codcli, paciente, nascimento, cod_convenio, descr_convenio) {
		try {
			pai = window.opener;
			pai.location = "historicopac.jsp?codcli=" + codcli + "&nome=" + paciente + "&nascimento=" + nascimento + "&idade=" + getIdade(nascimento) + "&cod_convenio=" + cod_convenio + "&nomeconvenio=" + descr_convenio;
			pai.focus();		
		}
		catch(e) {
			alert("Houve um erro ao abrir histórico\n" + e);
		}
	}	
	
	function navegaagenda(tipo) {
		//Verifica se é próximo
		var jsanterior = "<%= anterior%>";
		var jsposterior = "<%= posterior%>";
		
		if(tipo == 1) {
			window.location = "detalheagendamedico.jsp?" + jsposterior;
		}
		//Verifica se é anterior
		else {
			window.location = "detalheagendamedico.jsp?" + jsanterior;
		}
	}
			

</script>
</head>

<body>
<script type="text/javascript">

/***********************************************
* Cool DHTML tooltip script II- © Dynamic Drive DHTML code library (www.dynamicdrive.com)
* This notice MUST stay intact for legal use
* Visit Dynamic Drive at http://www.dynamicdrive.com/ for full source code
***********************************************/

var offsetfromcursorX=12 //Customize x offset of tooltip
var offsetfromcursorY=10 //Customize y offset of tooltip

var offsetdivfrompointerX=10 //Customize x offset of tooltip DIV relative to pointer image
var offsetdivfrompointerY=14 //Customize y offset of tooltip DIV relative to pointer image. Tip: Set it to (height_of_pointer_image-1).

document.write('<div id="dhtmltooltip" class="texto"></div>') //write out tooltip DIV
document.write('<img id="dhtmlpointer" src="images/arrow2.gif">') //write out pointer image

var ie=document.all
var ns6=document.getElementById && !document.all
var enabletip=false
if (ie||ns6)
var tipobj=document.all? document.all["dhtmltooltip"] : document.getElementById? document.getElementById("dhtmltooltip") : ""

var pointerobj=document.all? document.all["dhtmlpointer"] : document.getElementById? document.getElementById("dhtmlpointer") : ""

function ietruebody(){
return (document.compatMode && document.compatMode!="BackCompat")? document.documentElement : document.body
}

function ddrivetip(thetext, thewidth, thecolor){
if (ns6||ie){
if (typeof thewidth!="undefined") tipobj.style.width=thewidth+"px"
if (typeof thecolor!="undefined" && thecolor!="") tipobj.style.backgroundColor=thecolor
tipobj.innerHTML=thetext
enabletip=true
return false
}
}

function positiontip(e){
if (enabletip){
var nondefaultpos=false
var curX=(ns6)?e.pageX : event.clientX+ietruebody().scrollLeft;
var curY=(ns6)?e.pageY : event.clientY+ietruebody().scrollTop;
//Find out how close the mouse is to the corner of the window
var winwidth=ie&&!window.opera? ietruebody().clientWidth : window.innerWidth-20
var winheight=ie&&!window.opera? ietruebody().clientHeight : window.innerHeight-20

var rightedge=ie&&!window.opera? winwidth-event.clientX-offsetfromcursorX : winwidth-e.clientX-offsetfromcursorX
var bottomedge=ie&&!window.opera? winheight-event.clientY-offsetfromcursorY : winheight-e.clientY-offsetfromcursorY

var leftedge=(offsetfromcursorX<0)? offsetfromcursorX*(-1) : -1000

//if the horizontal distance isn't enough to accomodate the width of the context menu
if (rightedge<tipobj.offsetWidth){
//move the horizontal position of the menu to the left by it's width
tipobj.style.left=curX-tipobj.offsetWidth+"px"
nondefaultpos=true
}
else if (curX<leftedge)
tipobj.style.left="5px"
else{
//position the horizontal position of the menu where the mouse is positioned
tipobj.style.left=curX+offsetfromcursorX-offsetdivfrompointerX+"px"
pointerobj.style.left=curX+offsetfromcursorX+"px"
}

//same concept with the vertical position
if (bottomedge<tipobj.offsetHeight){
tipobj.style.top=curY-tipobj.offsetHeight-offsetfromcursorY+"px"
nondefaultpos=true
}
else{
	tipobj.style.top=curY+offsetfromcursorY+offsetdivfrompointerY+"px"
	pointerobj.style.top=curY+offsetfromcursorY+"px"
}
tipobj.style.visibility="visible"
if (!nondefaultpos)
	pointerobj.style.visibility="visible"
else
	pointerobj.style.visibility="hidden"
}
}

function hideddrivetip(){
	if (ns6||ie){
		enabletip=false
		tipobj.style.visibility="hidden"
		pointerobj.style.visibility="hidden"
		tipobj.style.left="-1000px"
		tipobj.style.backgroundColor=''
		tipobj.style.width=''
	}
}

document.onmousemove=positiontip

</script>

<form name="frmcadastrar" id="frmcadastrar" action="gravaragenda.jsp" method="post">
  <!-- Campos hidden para enviar os valores por POST -->
  <input type="hidden" name="prof_reg" id="prof_reg" value="<%= prof_reg%>">
  <input type="hidden" name="data" id="data">
  <input type="hidden" name="hora" id="hora">
  <input type="hidden" name="query" id="query" value="<%= query%>">  
  
  <table width="600" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr>
      <td width="651" height="18" class="title">
		<%= medico%>
		<br><%= Util.getDiaSemana(dia, mes, ano) %> - <%= data  %>
	  </td>
    </tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td align="center" class="tdMedium" style="border:solid #000000 1px">
			<a href="Javascript:navegaagenda(-1)" title="Dia Anterior"><img src="images/setaabre.gif" border="0"> Anterior</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<a href="Javascript:navegaagenda(1)" title="Dia Seguinte">Próximo <img src="images/setafecha.gif" border="0"> </a> 
		</td>
	</tr>
	<tr style="height:25px">
		<td align="right"><span name='msg' id='msg' class="msg">&nbsp;</span></td>
	</tr>
	<tr>
		<td class="texto">
			<table cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td class="texto">
						<img src="images/3.gif">Paciente não chegou<br>
						<img src="images/1.gif">Paciente aguarda atendimento<br>
						<img src="images/9.gif">Paciente já foi atendido
					</td>
					<td class="texto">
						<b>Negrito</b>: encaixe<br>
						<span style="background-color:#FFFF99">Fundo Amarelo</span>: retorno de consulta<br>
                        <span style="background-color:#CEFFCE">Fundo Verde</span>: paciente de primeira vez<br>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td>
			    <%= agenda.montaAgendaMedico(dia, mes, ano, prof_reg, cod_empresa, usuario_logado )%>
		</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
  </table>
</form>

</body>
</html>
