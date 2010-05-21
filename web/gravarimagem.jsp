<%@page import="recursos.*" %>
<%@page import="java.sql.*" %>
<%@page import="org.apache.commons.fileupload.*" %>
<%@page import="java.io.*" %>
<%@page import="java.util.*" %>

<jsp:useBean class="recursos.Banco" id="banco" scope="page"/>

<%
	//Configuração
	String tabela = "imagens";
	String chave = "cod_imagem";
	String pagina = "insereimagem.jsp";
	String ret = ""; //Retorno
	//Caminho do Upload
	String caminhoupload = Propriedade.getCampo("uploadFolder");
	String caminhoprancheta = Propriedade.getCampo("baseFolder") + "/prancheta";

	//Parâmetros
	String acao = request.getParameter("acao");
	String id = request.getParameter("id");
	String tipoimg = request.getParameter("tipo");

	//Nome dos campos (form e tabela)
	String campos[]       = {"","imagem","cod_hist","descricao","acompanha"};
    String campostabela[] = {"cod_imagem","imagem","cod_hist","descricao","acompanhar"};

	//Campos a validar
	int validar[] = {0};

	//Vetor de dados que vai ser preenchido
	String dados[] = new String[campos.length];
	
	//Captura o valor do próximo índice numérico e coloca no vetor de dados
	dados[0] = banco.getNext(tabela, chave );

	String nomearquivo = "";
	boolean conseguiu = true;
	
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
					  //captura o nome do arquivo
					  nomearquivo = Util.getArquivo(fitem.getName()); 
					  //separa a extensão do arquivo
					  String ext = nomearquivo.substring(nomearquivo.length()-4);
					  //Altera o nome da imagem
					  nomearquivo = "imagem" + "_" + dados[0] + "_" + Util.getData().replace("/","_") + "_" + Util.getHora().replace(":","_") + ext;
					  //Grava o arquivo no local escolhido
					  fitem.write(new File(caminhoupload, nomearquivo ));
				   }
				   else
				   {
						String nomecampo = fitem.getFieldName();
						String valorcampo = fitem.getString();
						if(nomecampo.equals("cod_hist"))
							dados[2] = valorcampo;
						else if(nomecampo.equals("descricao"))
							dados[3] = valorcampo;
						else if(nomecampo.equals("acompanha"))
							dados[4] = valorcampo;
				   }
			}
		}
	}
	catch(Exception e)
	{
		ret = pagina + "?codhist=" + request.getParameter("codhist") + "&inf=Pasta:%20" + caminhoupload + "<br>" + e.toString();
		conseguiu = false;	
	}
	
	//se deu erro, voltar com a mensagem
	if(!conseguiu) {
		response.sendRedirect(ret);
	}
	else
	{
		//Preenche os outros valores 
		dados[1] = nomearquivo;
		
		//Se não for exclusão, verificar se é registro duplicado
		if(acao.equals("inc"))
		{
				if(conseguiu)
					ret = banco.gravarDados(tabela, dados, campostabela);
	
				//Se retornou OK, efetuado com sucesso
				if(ret.equals("OK"))
				{
					response.sendRedirect(pagina + "?codhist=" + dados[2] + "&inf=1"); //Inserido com sucesso
				}
				//Se não vier OK, devolver o erro
				else
				{
					response.sendRedirect(pagina + "?codhist=" + dados[2] + "&inf=" + ret); //Erro nas inserção
				}
		}
		//é Excluir
		else
		{
			if(tipoimg != null && tipoimg.equals("imagem")) {
				ret = banco.excluirTabela(tabela, chave, id);
				dados[2] = request.getParameter("codhist");
				String imagem = request.getParameter("img");
			
				if(ret.equals("OK"))
				{
					try
					{
						File f = new File( caminhoupload, imagem );
						f.delete();
						f = null;			
						response.sendRedirect(pagina + "?codhist=" + dados[2] + "&inf=3"); //Removido com sucesso
					}
					catch(IOException e)
					{
						out.println(e.toString());
					}
				}
				else
					response.sendRedirect(pagina + "?codhist=" + dados[2] + "&inf=" + ret); //Erro na remoção
			}
			else {
				ret = banco.excluirTabela("prancheta", "cod_prancheta", id);
				dados[2] = request.getParameter("codhist");
				String imagem = request.getParameter("img");
			
				if(ret.equals("OK"))
				{
					try
					{
						File f = new File( caminhoprancheta, imagem );
						f.delete();
						f = null;			
						response.sendRedirect(pagina + "?codhist=" + dados[2] + "&inf=3"); //Removido com sucesso
					}
					catch(IOException e)
					{
						out.println(e.toString());
					}
				}
				else
					response.sendRedirect(pagina + "?codhist=" + dados[2] + "&inf=" + ret); //Erro na remoção
				
			}
		}
	}
%>