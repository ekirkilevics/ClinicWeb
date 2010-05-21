<%@page import="recursos.*" %>
<%!
	public void gravaCookie(String nome, String valor,  HttpServletResponse response)
	{
		try {
			valor = limpaString(valor);
			Cookie newcookie = new Cookie(nome, valor);
			newcookie.setMaxAge(30 * 24 * 60 * 60); //30 dias
			response.addCookie(newcookie);			
		}
		catch(Exception e) { }
	}
	
	public String limpaString(String str)
	{
		str = str.replace('"',' ');
		return str;
	}

%>
<%
	//Captura a página que vai entrar
	String endereco = request.getParameter("link");
	String titulo = request.getParameter("titulo");
	String msgCookie = Util.getData() + " (" + Util.getHora() + ") - <a href='pagina.jsp?link=" + endereco + "&titulo=" + titulo + "' target='_blank'>" + titulo + "</a>";

	Cookie listaPossiveisCookies[] = request.getCookies();
	if (listaPossiveisCookies != null) {
			int numCookies = listaPossiveisCookies.length;
		    for (int i = 0 ; i < numCookies ; ++i)  {
			    if (listaPossiveisCookies[i].getName().equals("cookie5")) 
					gravaCookie("cookie4", listaPossiveisCookies[i].getValue(), response);
				else if (listaPossiveisCookies[i].getName().equals("cookie4"))
					gravaCookie("cookie3", listaPossiveisCookies[i].getValue(), response);
				else if (listaPossiveisCookies[i].getName().equals("cookie3"))
					gravaCookie("cookie2", listaPossiveisCookies[i].getValue(), response);
				else if (listaPossiveisCookies[i].getName().equals("cookie2"))
					gravaCookie("cookie1", limpaString(listaPossiveisCookies[i].getValue()), response);
  			}
	}
	
	gravaCookie("cookie5", msgCookie, response);
%>
<html>
<body>
<script language="JavaScript">
	window.location = "<%= endereco%>";
</script>
</body>
</html>
