<%@page import="recursos.*" %>

<jsp:useBean class="recursos.SMS" id="sms" scope="page"/>

<%
	//out.println(sms.sendSMS("", "551184142199", "Clinic Web � uma evolu��o natural do Clinic Manager?"));
	
	out.println(sms.getCreditos());
	
	out.println(sms.getMensagens());

%>
