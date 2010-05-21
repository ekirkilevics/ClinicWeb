<%@page import="recursos.*" %>
<%@page import="org.apache.commons.fileupload.*" %>
<%@page import="java.io.*" %>
<%@page import="java.util.*" %>


<%
	//KATU
	//String caminhoupload = "C:\\Katu\\Tomcat 5.5\\webapps\\ROOT\\clinicweb\\upload\\";
	//INF
	String caminhoupload = "/var/lib/tomcat5.5/webapps/clinicweb/upload/";

	String nomearquivo = "";
	boolean conseguiu = true;
	
	 //Faz o upload do arquivo
	  try {
		  boolean isMultipart = FileUpload.isMultipartContent(request);
		  if (isMultipart) {
			 // Create a new file upload handler
			 DiskFileUpload upload = new DiskFileUpload();

			 // Set upload parameters
			// upload.setSizeMax(50*1024*1024); //50Mb

			 // Parse the request
			 List items = upload.parseRequest(request);

			 Iterator it = items.iterator();
			 while (it.hasNext()) {
				   FileItem fitem = (FileItem) it.next();
				   if (!fitem.isFormField()) {
					  nomearquivo = Util.getArquivo(fitem.getName());
					  nomearquivo = nomearquivo.toLowerCase();
					  //Grava o arquivo no local escolhido
					  fitem.write(new File(caminhoupload, nomearquivo ));
				   }
			}
		}
	}
	catch(Exception e)
	{
		out.println(e.toString());
		conseguiu = false;	
	}
	
%>