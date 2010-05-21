<%@include file="cabecalho.jsp" %>

<jsp:useBean class="recursos.Menu" id="menu" scope="session"/>

<html>
<head>
<script language="JavaScript" src="js/scriptsform.js"></script>
<script language="JavaScript">
	var cod_usuario = "<%= (String)session.getAttribute("usuario")%>";
</script>

<script type="text/javascript" src="js/scripts.js">

<!-- This script and many more are available free online at -->
<!-- The JavaScript Source!! http://javascript.internet.com -->

</script>

<link href="css/css.css" rel="stylesheet" type="text/css">
<style type="text/css">
<!--

#containerul, #containerul ul{
  text-align:left;
  margin:0;			        /* Removes browser default margins applied to the lists. */
  padding:0;
  font-family: Verdana, Arial, Helvetica, sans-serif;
  font-size:10px;
}

#containerul li{
  margin:0 0 0 10px;			/* A left margin to indent the list items and give the menu a sense of structure. */
  padding:0;				    /* Removes browser default padding applied to the list items. */
  list-style-type:none;			/* Removes the bullet point that usually goes next to each item in a list. */
  white-space: nowrap;
}

#containerul .symbols{			/* Various styles to position the symbols next to the items in the menu. */
  float:left;
  width:12px;
  height:1em;
  background-position:0 50%;
  background-repeat:no-repeat;
}

-->
</style>

</head>

<body LEFTMARGIN=0 TOPMARGIN=0 MARGINWIDTH=0 MARGINHEIGHT=0 style="background-image:  url(images/fundomenu.jpg); overflow-x: 'hidden'">
<center>
	<%
		if(Util.existeArquivo("images/logo" + cod_empresa + ".gif")) {
	%>
		<img src="images/logo<%= cod_empresa%>.gif">
	<%
		 } else {
	%>
		<img src="images/logo0.gif">
	<%  } %>
</center>

<%
	if(!Util.isNull(usuario_logado)) {
	 	out.println(menu.montaMenu(usuario_logado, cod_empresa));
	}
%>
<script type="text/javascript">
initiate();		// This must be placed immediately after the menu in order to format it properly.
</script>

</body>
</html>
