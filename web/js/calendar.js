var ie=document.all
var ns6=document.getElementById&&!document.all
var n=document.layers


if (ie||ns6)    {fShow="visible";fHide="hidden";}
if (n) {fShow="show"; fHide="hide";}

var MonthNames = new Array("Janeiro", "Fevereiro", "Março", "Abril", "Maio", "Junho", "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro");
var nCurrentYear = 0;
var nCurrentMonth = 0;

var nWidth  = 30;
var nHeight = 15;

var leftX;
var rightX
var topY;
var bottomY;


function Calendar()
{

	var HTMLstr = "";
	
	HTMLstr += "<table width='250px' cellspacing='0' cellpadding='0' border='1'>\n";
	HTMLstr += "<tr><td bgcolor='#ACC1DF'>\n";
	HTMLstr += "\n";
	HTMLstr += "<table border='0' cols='3' width='100%'>\n";
	HTMLstr += "<tr>\n";
	HTMLstr += "<td><b><font class='texto' style='color:white'>Ano:</font></b></td>\n";
	HTMLstr += "\n";
	if (n)
	{
		HTMLstr += "<td align='right' width='40'>\n";
		HTMLstr += "<a href=\"javascript:prevYear();\"><font color='white' size=-2><img src='images/prev.gif' border='0'></font></a>\n";
		HTMLstr += "<a href=\"javascript:nextYear();\"><font color='white' size=-2><img src='images/next.gif' border='0'></font></a>\n";
	}
	if (ie||ns6)
	{
		HTMLstr += "<td align='right' width='40'>\n";
		HTMLstr += "<a href=\"javascript:prevYear();\" style='text-decoration: none;'><font color='white' size=-2><img src='images/prev.gif' border='0'></font></a>\n";
		HTMLstr += "<a href=\"javascript:nextYear();\" style='text-decoration: none;'><font color='white' size=-2><img src='images/next.gif' border='0'></font></a>\n";
	}
	HTMLstr += "</td>\n";
	HTMLstr += "\n";
	HTMLstr += "<td align='left' class='texto'>";
	
	if (n) HTMLstr += "<ilayer id='main'><layer id='idYear' top='0' left='0'>\n";
	if (ie||ns6)HTMLstr += "<div id='main' style='position: relative'>\n";
	HTMLstr += "<font color='#99ffff'><b>1999</b></font>\n";
	if (n) HTMLstr += "</layer></ilayer>\n";
	if (ie||ns6)HTMLstr += "</div>\n";
	HTMLstr += "</td>\n";
	HTMLstr += "</tr>\n";
	HTMLstr += "<tr>\n";
	HTMLstr += "<td><b><font class='texto' style='color:white'>Mês:</font></b></td>\n";
	HTMLstr += "\n";
	HTMLstr += "<td align='right'>\n";
	if (n)
	{
		HTMLstr += "<a href=\"javascript:prevMonth();\"><font color='white' size=-2><img src='images/prev.gif' border='0'></font></a>\n";
		HTMLstr += "<a href=\"javascript:nextMonth();\"><font color='white' size=-2><img src='images/next.gif' border='0'></font></a>\n";
	}
	if (ie||ns6)
	{
	HTMLstr += "<a href=\"javascript:prevMonth();\" style='text-decoration: none;'><font color='white' size=-2><img src='images/prev.gif' border='0'></font></a>\n";
	HTMLstr += "<a href=\"javascript:nextMonth();\" style='text-decoration: none;'><font color='white' size=-2><img src='images/next.gif' border='0'></font></a>\n";
	}
	HTMLstr += "</td>\n";
	HTMLstr += "\n";
	HTMLstr += "<td align='left'>\n";
	if (ie||ns6)HTMLstr += "<div id='main2' style='position=relative;'>";
	if (n) HTMLstr += "<ilayer id='main2'><layer id='idMonth' top='0' left='0'>\n";
	HTMLstr += "<font color='#99ffff'><b>Dezembro</b></font>\n";
	if (ie||ns6)HTMLstr += "<div>\n";
	if (n) HTMLstr += "</layer></ilayer>\n";
	HTMLstr += "</td>\n";
	HTMLstr += "\n";
	HTMLstr += "</tr>\n";
	HTMLstr += "</table>\n";
	HTMLstr += "\n";
	HTMLstr += "</td></tr>\n";
	HTMLstr += "\n";
	HTMLstr += "<tr height='110px'><td valign=\"top\">\n";
	HTMLstr += "\n";
	HTMLstr += "<table border=0 cols=7>\n";
	HTMLstr += "<tr>\n";
	HTMLstr += "<td width='30' class='texto'><b>Seg</b></td>\n";
	HTMLstr += "<td width='30' class='texto'><b>Ter</b></td>\n";
	HTMLstr += "<td width='30' class='texto'><b>Qua</b></td>\n";
	HTMLstr += "<td width='30' class='texto'><b>Qui</b></td>\n";
	HTMLstr += "<td width='30' class='texto'><b>Sex</b></td>\n";
	HTMLstr += "<td width='30' class='texto' style='color:red'><b>Sáb</b></td>\n";
	HTMLstr += "<td width='30' class='texto' style='color:red'><b>Dom</b></td>\n";
	HTMLstr += "</tr>\n";
	HTMLstr += "<tr>\n";
	HTMLstr += "<td colspan=7>\n";
	if (ie||ns6)HTMLstr += "<div style='position: relative;'>";
	if (n) HTMLstr += "<ilayer id='idMenuContainer' height='120px' width='250px'>\n";
	
	  for (var date=1; date <= 31; date++)
	  {
		if (n)
		{
			HTMLstr += "  <layer id=\"idDate"+date+"\" val="+date+" visibility=\"hide\">\n";
			HTMLstr += "    <b style='font-family:verdana; font-size:12px; backgound-color:#E8EFF7'><a href='Javascript:pegarData(" + date + ")'>"+date+"</a></b>\n";
			HTMLstr += "  </layer>\n";
		}
		if (ie||ns6)
		{
			HTMLstr += "  <div id=\"idDate"+date+"\" val="+date+" style=\"position: absolute; visibility: hidden\">\n";
			// HTMLstr += "    <b>"+date+"</b>\n";
			HTMLstr += "    <b style='font-family:verdana; font-size:12px; backgound-color:#E8EFF7'><a href='Javascript:pegarData(" + date + ")'>"+date+"</a></b>\n";
			HTMLstr += "  </div>\n";
		}
	  }
	
	if (ie||ns6)HTMLstr += "</div>";
	if (n) HTMLstr += "</ilayer>\n";
	HTMLstr += "</td></tr>\n";
	HTMLstr += "</table>\n";
	HTMLstr += "\n";
	HTMLstr += "</td></tr>\n";
	HTMLstr += "</table>\n";
	
	//document.writeln(HTMLstr);
	document.getElementById("divcalendar").innerHTML = HTMLstr;
	buildMonthMenu(HTMLstr);
}


function setCurrentMonth()
{
  date = new Date();
  currentyear=date.getYear()
  if (currentyear < 1000)
  currentyear+=1900
  setYearMonth(currentyear, date.getMonth()+1);
}

function setMonth(nMonth)
{
	setYearMonth(nCurrentYear, nMonth);
}

function setYearMonth(nYear, nMonth)
{
  if (ie||ns6)
{
  nCurrentYear = nYear;
  nCurrentMonth = nMonth;
  var cross_obj=ns6? document.getElementById("main"): document.all["main"]
  var cross_obj2=ns6? document.getElementById("main2"): document.all["main2"]
  cross_obj.innerHTML  = "<font color=\"#99ffff\"><b>"+nCurrentYear+"</b></font>";
  cross_obj2.innerHTML = "<a class='texto' href=\"javascript:showMonthMenu()\" style=\"text-decoration:none; color:#99ffff\"><b>"+MonthNames[nCurrentMonth-1]+"</b></a>\n";

  var date   = new Date(nCurrentYear, nCurrentMonth-1, 1);
  var nWeek  = 1;
  var nDate;

  while (date.getMonth() == nCurrentMonth-1)
  {
	nDate = date.getDate();
	nLastDate = nDate;

	var posDay = date.getDay()-1;
	if (posDay == -1) posDay=6;
	var posLeft = posDay*(nWidth+5)+5;
	var posTop  = (nWeek-1)*nHeight;
        var cross_obj3=ns6? document.getElementById("idDate"+nDate).style : document.all["idDate"+nDate].style
	cross_obj3.left = posLeft;
	cross_obj3.top  = posTop;
	if (date.getDay() == 0 || date.getDay() == 6)
		cross_obj3.color  = "red";
	else
		cross_obj3.color  = "black";
	cross_obj3.visibility = "visible";
	// original:
	// date = new Date(currentyear, date.getMonth(), date.getDate()+1);
	// johan:
	date = new Date(nCurrentYear, date.getMonth(), date.getDate()+1);
	
	if (posDay == 6) nWeek++;
  }
  for (++nDate; nDate <= 31; nDate++){
        cross_obj3=ns6? document.getElementById("idDate"+nDate).style : document.all["idDate"+nDate].style
	cross_obj3.visibility = "hidden";
      }
}
  if (n)
{
  // Verify parameters
  if (nMonth < 1 || nMonth > 12) {alert("Function: setYearMonth()\nERROR: Incorrect month "+nMomth);}

  nCurrentYear = nYear;
  nCurrentMonth = nMonth;

  document.main.document.idYear.document.open();
  document.main.document.idYear.document.write("<font color=\"#99ffff\"><b>"+nCurrentYear+"</b></font>");
  document.main.document.idYear.document.close();

  document.main2.document.idMonth.document.open();
  document.main2.document.idMonth.document.write("<a href=\"javascript:showMonthMenu()\" style=\"text-decoration:none\"><font color=\"#99ffff\"><b>"+MonthNames[nCurrentMonth-1]+"</b></font></a>");
  document.main2.document.idMonth.document.close();

  var date   = new Date(nYear, nMonth-1, 1);
  var nWeek  = 1;
  var nDate;

  while (date.getMonth() == nMonth-1)
  {
	nDate = date.getDate();
	nLastDate = nDate;

	var posDay = date.getDay()-1;
	if (posDay == -1) posDay=6;
	var posLeft = posDay*(nWidth+5)+5;
	var posTop  = (nWeek-1)*nHeight;

	document.layers["idMenuContainer"].document.layers["idDate"+nDate].left = posLeft;
	document.layers["idMenuContainer"].document.layers["idDate"+nDate].top  = posTop;
	if (date.getDay() == 0 || date.getDay() == 6)
		document.layers["idMenuContainer"].document.layers["idDate"+nDate].color  = "red";
	else
		document.layers["idMenuContainer"].document.layers["idDate"+nDate].color  = "black";
	document.layers["idMenuContainer"].document.layers["idDate"+nDate].visibility = "visible";
	date = new Date(nCurrentYear, date.getMonth(), date.getDate()+1);
	if (posDay == 6) nWeek++;
  }
  for (++nDate; nDate <= 31; nDate++)
	document.layers["idMenuContainer"].document.layers["idDate"+nDate].visibility = "hidden";
}
}

function nextMonth()
{
  nCurrentMonth++;
  if (nCurrentMonth > 12)
  {
	nCurrentMonth -= 12;
	nextYear();
  }
  
  setYearMonth(nCurrentYear, nCurrentMonth);
  //Setar a data para o primeiro dia do mês
  pegarData(1);
}


function prevMonth()
{
  nCurrentMonth--;
  if (nCurrentMonth < 1)
  {
	nCurrentMonth += 12;
	prevYear();
  }
  setYearMonth(nCurrentYear, nCurrentMonth);
  //Setar a data para o primeiro dia do mês
  pegarData(1);
}

function prevYear()
{
  nCurrentYear--;
  setYearMonth(nCurrentYear, nCurrentMonth);
  //Setar a data para o primeiro dia do mês
  pegarData(1);
}

function nextYear()
{
  nCurrentYear++;
  setYearMonth(nCurrentYear, nCurrentMonth);
  //Setar a data para o primeiro dia do mês
  pegarData(1);
}

////////////////////////////////////////////////////

function updateIt(e)
{
//  var x = e.pageX;
//  var y = e.pageY;

//  if (x > rightX || x < leftX) hideMonthMenu();
//  else if (y > bottomY || y < topY) hideMonthMenu();
}

function hideMonthMenu()
{
  document.layers["idMonthMenu"].visibility="hide";
}

function showMonthMenu()
{
if (!n) return;
  topY    = document.layers["main2"].pageY-50;
  bottomY = document.layers["main2"].pageY + document.layers["idMonthMenu"].clip.height+50;
  leftX   = document.layers["main2"].pageX-50;
  rightX  = document.layers["main2"].pageX + document.layers["idMonthMenu"].clip.width+50;

  document.layers["idMonthMenu"].top = document.layers["main2"].pageY+document.layers["main2"].clip.height;
  document.layers["idMonthMenu"].left = document.layers["main2"].pageX;
  document.layers["idMonthMenu"].visibility="show";
}

function buildMonthMenu()
{
if (!n) return;
  var HTML = "";
  HTML += "<layer id=\"idMonthMenu\" visibility=\"hide\" width=\"120\" bgcolor=\"#ACC1DF\">\n";
  HTML += "<table border=\"1\" cellspacing=\"0\" cellpading=\"0\">\n";
  for (var month=0; month<12;)
  {
	HTML += "<tr>\n";
	for (var i = 0; i < 3; i++)
	{
		var nMonth = month+1;
		HTML += "<td><a href=\"javascript:hideMonthMenu();setMonth("+nMonth+");\"><font class='texto' style='color:white' size=-1><b>"+MonthNames[month]+"</b></font></a></td>\n";
		month++;
	}
	HTML += "</tr>\n";
  }
  HTML += "</table>";
  HTML += "</layer>";
  document.writeln(HTML);
}

