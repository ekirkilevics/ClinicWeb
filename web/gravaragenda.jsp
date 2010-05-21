<%@page import="recursos.*" %>
<%@page import="java.sql.*" %>

<jsp:useBean class="recursos.Agenda" id="agenda" scope="page"/>
<jsp:useBean class="recursos.Banco" id="banco" scope="page"/>
<jsp:useBean class="recursos.Configuracao" id="configuracao" scope="page"/>

<%
	//Configura��o
	String tabela = "agendamento";
	String chave = "agendamento_id";
	String pagina = "detalheagenda.jsp?";

	//Sobre SMS
	String confsms = request.getParameter("sms") != null ? request.getParameter("sms") : "N";
	String dataenviosms = request.getParameter("dataenviosms");
	String horaenviosms = request.getParameter("horaenviosms");
	String cod_empresa = (String)session.getAttribute("codempresa");
	
	//Dados do Celular
	String dddcelular = request.getParameter("dddcelular");
	String celular = request.getParameter("celular");	

	String ret = ""; //Retorno

	//Nome dos campos (form e tabela)
	String campos[]       = {"","codcli","cod_proced","prof_reg","data","hora", "status", "cod_convenio", "cod_plano", "retorno", "data_inclusao", "hora_inclusao", "usuario_inclusao", "obs", "encaixe"};
    String campostabela[] = {"agendamento_id","codcli","cod_proced","prof_reg","data","hora", "status", "cod_convenio", "cod_plano", "retorno","data_inclusao", "hora_inclusao", "usuario_inclusao", "obs", "encaixe"};

	//Query original
	String query = request.getParameter("query");

	//Se j� veio com um inf, remover para inserir o pr�ximo aqui
	if(query.indexOf("inf") >=0) {
		query = query.substring(0,query.indexOf("inf"));
	}

	//Captura o id (no caso de exclus�o)
	String id = request.getParameter("id");

	//Se veio id, ent�o � exclus�o
	if(id != null)
	{
		//Antes de excluir, pega os dados para enviar
		//Captura valores da agenda
		/* 	dadosagenda[0] = Nome Paciente
			dadosagenda[1] = Nome Profissional
			dadosagenda[2] = Email profissional
			dadosagenda[3] = Procedimento
			dadosagenda[4] = data
			dadosagenda[5] = hora
			dadosagenda[6] = Email do paciente
			dadosagenda[7] = ddd celular
			dadosagenda[8] = tel celular
		*/
		String dadosagenda[] = agenda.getAgenda(id);
		ret = agenda.excluirAgenda(id, (String)session.getAttribute("usuario"));
		if(ret.equals("OK")) {

		   	response.sendRedirect(pagina + query + "&inf=3&prof_reg="+request.getParameter("prof_reg")); //Removido com sucesso
		}
		else
			response.sendRedirect(pagina + query + "&inf=" + ret); //Erro na remo��o
	}
	else
	{
		//Campos a validar
		int validar[] = {1,2,3,4};
	
		//Vetor de dados que vai ser preenchido
		String dados[] = new String[campos.length];
	
		//Captura os dados dos campos (exceto c�digo que ser� auto-num�rico)
		for(int i=1; i<campos.length; i++)	
			dados[i] = request.getParameter(campos[i]);
		
		//Captura o valor do pr�ximo �ndice num�rico e coloca no vetor de dados
		dados[0] = banco.getNext(tabela, chave );
	
		//Formatar os campos de data para o formato correto
		dados[4] = Util.formataDataInvertida(dados[4]);

		//Ao cadastrar, status � 3 (n�o chegou )
		dados[6] = "3";
		
		//Ao incluir, colocar data,hora e usu�rio que incluiu
		dados[10] = Util.formataDataInvertida(Util.getData());
		dados[11] = Util.getHora();
		dados[12] = (String)session.getAttribute("usuario");
		
		//Atualiza informa��o de celular
		if(!Util.isNull(celular) && !Util.isNull(dddcelular)) {
			banco.executaSQL("UPDATE paciente SET ddd_celular='" + dddcelular + "', tel_celular='" + celular + "' WHERE codcli=" + dados[1]);
		}

		//Verifica registro duplicado
		boolean passou = banco.validaRegistro(tabela, chave, "", dados, campostabela, validar );
	
		//Se for registro duplicado e n�o for encaixe, voltar com erro
		if(!passou && dados[14].equals("N")) 
				response.sendRedirect(pagina + query + "&inf=Paciente%20j�%20possui%20agenda%20nessa%20data%20para%20esse%20procedimento!"); //Registro Duplicado
		else
		{

				//Se a sess�o estava aberta, era reagendamento, apagar a agenda antiga e finalizar sess�o
				if(!Util.isNull((String)session.getAttribute("reagendar"))) {
					dados[13] = banco.getValor("obs", "SELECT obs FROM agendamento WHERE agendamento_id=" + (String)session.getAttribute("reagendar"));
				}					

				ret = banco.gravarDados(tabela, dados, campostabela, (String)session.getAttribute("usuario"));
				if(ret.equals("OK")) {

					//Pega os dados da agenda
					String dadosagenda[] = agenda.getAgenda(dados[0]);

					//Se a sess�o estava aberta, era reagendamento, apagar a agenda antiga e finalizar sess�o
					if(!Util.isNull((String)session.getAttribute("reagendar"))) {
						//Pega dados da agenda anterior antes de excluir
						dadosagenda = agenda.getAgenda((String)session.getAttribute("reagendar"));

						ret = agenda.excluirAgenda((String)session.getAttribute("reagendar"), (String)session.getAttribute("usuario"));
			
						session.setAttribute("reagendar", null);
					}					

					response.sendRedirect(pagina + query + "&inf=1&prof_reg="+dados[3]); //Inserido com sucesso
				}
				else
					response.sendRedirect(pagina + query + "&inf=" + ret); //Erro nas inser��o
		}
	}

%>
