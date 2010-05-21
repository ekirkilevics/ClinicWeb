<%@page import="recursos.*" %>
<%@page import="java.sql.*" %>
<%@page import="java.util.*" %>

<jsp:useBean class="recursos.Backup" id="backup" scope="page"/>
<%
    response.setHeader("Cache-Control", "no-cache");
    response.setHeader("Pragma", "no-cache");
    out.println(backup.executaBack((String)session.getAttribute("codempresa")));
%>
