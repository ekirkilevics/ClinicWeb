<%@page import="recursos.*" %>
<%@page import="java.sql.*" %>
<%@page import="org.apache.commons.fileupload.*" %>
<%@page import="java.io.*" %>
<%@page import="java.util.*" %>

<jsp:useBean class="recursos.Banco" id="banco" scope="page"/>

<%
	//Caminho do Upload
	String caminhoupload = Propriedade.getCampo("uploadFolder");
	String codcli = request.getParameter("codcli");
	String nomearquivo = "";
	String resp = "";
	String exc = request.getParameter("exc");
	
	//Se for para excluir
	if(!Util.isNull(exc)) {
			try
			{
				String sql = "UPDATE paciente SET foto=null WHERE codcli=" + codcli;
				out.println(banco.executaSQL(sql));
				
				File f = new File( caminhoupload, exc );
				f.delete();
				f = null;
				
				resp = "excluido";			
			}
			catch(Exception e)
			{
				out.println(e.toString());
			}
	}
	//Senão é incluir
	else {

		 //Faz o upload do arquivo
		  try {
			  boolean isMultipart = FileUpload.isMultipartContent(request);
			  if (isMultipart) {
				 // Create a new file upload handler
				 DiskFileUpload upload = new DiskFileUpload();
	
				 // Set upload parameters
				 upload.setSizeMax(50*1024*1024); //50Mb
	
				 // Parse the request
				 List items = upload.parseRequest(request);
	
				 Iterator it = items.iterator();
				 while (it.hasNext()) {
					   FileItem fitem = (FileItem) it.next();
					   if (!fitem.isFormField()) {
						  nomearquivo = Util.getArquivo(fitem.getName());
						  nomearquivo = "foto" + codcli + nomearquivo.toLowerCase();
						  //Grava o arquivo no local escolhido
						  fitem.write(new File(caminhoupload, nomearquivo ));
					   }
				}
			}
			String sql = "UPDATE paciente SET foto='" + nomearquivo + "' WHERE codcli=" + codcli;
			resp = banco.executaSQL(sql);
				
		}
		catch(Exception e)
		{
			resp = e.toString();
			out.println(e.toString());
		}
	}	

%>
<html>
<head><title>Gravar foto</title>
<script language="JavaScript">
	
	var resp = "<%= resp%>";
	var nomearquivo = "<%= nomearquivo%>";

	if(resp == "OK") {
		window.opener.document.getElementById("foto").innerHTML = "<img src='upload/" + nomearquivo + "' border=0 width=40 height=40>";
		window.opener.document.getElementById("foto").href = "Javascript: mostraImagem('upload/" + nomearquivo + "')";
		alert("Foto inserida com sucesso.");
		self.close();
	}
	else {
		window.location = "pacientes.jsp?cod=<%= codcli%>";
	}

</script>
</head>

</html>