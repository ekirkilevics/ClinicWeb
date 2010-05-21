<%@page import="recursos.*" %>
<%@page import="java.sql.*" %>

<jsp:useBean class="recursos.Banco" id="banco" scope="page"/>
<jsp:useBean class="recursos.AgendaMedico" id="agenda" scope="page"/>

<%
	//Configuração
	String tabela = "agendamedico";
	String chave  = "agenda_id";
	String pagina = "agendamedico.jsp";
	String ret = ""; //Retorno

	//Parâmetros
	String acao = request.getParameter("acao");
	String id = request.getParameter("id");

	//Nome dos campos (form e tabela)
   	String campostabela[] = {"agenda_id","prof_reg","dia_semana","hora_inicio","hora_fim", "inicio_almoco", "fim_almoco", "vigencia"};

	//Valor fixo para todos os dias da semana
	String prof_reg = request.getParameter("prof_reg");
	String vigencia = Util.formataDataInvertida(request.getParameter("vigencia"));

	int i, j;
	
	//Remove os dados da agenda medica e procedimentos dela para inserir novamente
	ret = agenda.removeConfigAgenda(prof_reg, vigencia);

	//Se não for exclusão, é inserção ou alteração (mesma rotina)
	if(!acao.equals("exc"))
	{   
		for(i=1; i<=7; i++)
		{
			//Vetor de dados que vai ser preenchido
			String dados[] = new String[campostabela.length];
	
			//Pega a lista de procedimentos do profissional para o dia da semana
			String lista[] = request.getParameterValues("diasemana"+i);
			
			//Se tiver algum procedimento, gravar, senão gravar registro em branco 
			if(lista != null && lista.length > 0) 
			{
				//Captura o valor do próximo índice numérico e coloca no vetor de dados
				dados[0] = banco.getNext(tabela, chave );
		
				//Captura os dados para cada dia da semana
				dados[1] = prof_reg;
				dados[2] = i+"";
				dados[3] = request.getParameter("diade"+i);
				dados[4] = request.getParameter("diaate"+i);
				dados[5] = request.getParameter("almocode"+i);
				dados[6] = request.getParameter("almocoate"+i);
				dados[7] = vigencia;
				
				//Insere os dados novamente
				banco.gravarDados(tabela, dados, campostabela, (String)session.getAttribute("usuario"));
			
				//Inserir um registro para cada procedimento
				for(j=0; j<lista.length; j++)
				{
					String aux1[] = {dados[0],  lista[j]};
					String aux2[] = {"agenda_id","cod_proced"};
					banco.gravarDados("agenda_procedimento", aux1, aux2, (String)session.getAttribute("usuario") );
				}
			}
			else {
				//Captura o valor do próximo índice numérico e coloca no vetor de dados
				dados[0] = banco.getNext(tabela, chave );
		
				//Captura os dados para cada dia da semana
				dados[1] = prof_reg;
				dados[2] = i+"";
				dados[3] = "00:00";
				dados[4] = "00:00";
				dados[5] = null;
				dados[6] = null;
				dados[7] = vigencia;
				
				//Insere os dados novamente
				banco.gravarDados(tabela, dados, campostabela, (String)session.getAttribute("usuario"));
			
			}
		}
		response.sendRedirect(pagina + "?cod=" + id + "&inf=5");
	}
	else
		response.sendRedirect(pagina + "?inf=3"); //Removido com sucesso
%>
