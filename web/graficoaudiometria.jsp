<%
	String cod_audiometria = request.getParameter("cod");
%>
<frameset cols="50%,50%" frameborder="NO" border="0" framespacing="0">
    <frame src="graficoaudiometria_d.jsp?cod=<%= cod_audiometria %>" name="ladodireito" id="ladodireito" scrolling="AUTO" noresize>
    <frame src="graficoaudiometria_e.jsp?cod=<%= cod_audiometria %>" name="ladoesquerdo" id="ladoesquerdo" scrolling="AUTO" noresize>
</frameset>
