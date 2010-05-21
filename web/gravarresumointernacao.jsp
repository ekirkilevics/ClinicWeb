<%@page import="recursos.*" %>
<%@page import="java.sql.*" %>

<jsp:useBean class="recursos.Banco" id="banco" scope="page"/>
<jsp:useBean class="recursos.HonorarioIndividual" id="honorario" scope="page"/>

<%
	//Configuração
	String tabela = "resumointernacao";
	String chave = "cod_resumointernacao";
	String pagina = "resumointernacao.jsp";
	String ret = "";
	String cod_empresa = (String)session.getAttribute("codempresa");
	
	//Itens
	String dataproced = request.getParameter("dataproced");
	String cod_proced = request.getParameter("cod_proced");
	String viaAcesso = request.getParameter("viaAcesso");
	String horaInicio = request.getParameter("horaInicio");
	String horaFim = request.getParameter("horaFim");
	String qtde = request.getParameter("qtde");
	String valor = Util.trataNulo(request.getParameter("valor"),"").replace(",",".");
	
	//Profissional
	String grauParticipacao = request.getParameter("grauParticipacao");
	String prof_reg = request.getParameter("prof_reg");

	//Parâmetros
	String acao = request.getParameter("acao");
	String id = request.getParameter("id");

	//Nome dos campos (form e tabela)
	String campos[]       = {"","codcli", "cod_convenio", "guiaSolicitacao", "data", "dataAutorizacao", "senhaAutorizacao", "validadeSenha", "dataInternacao", "horaInternacao", "dataSaidaInternacao", "horaSaidaInternacao", "caraterInternacao", "tipoAcomodacao", "tipoInternacao", "regimeInternacao", "emGestacao", "aborto", "transtornoMaternoRelGravidez", "complicacaoPeriodoPuerperio", "atendimentoRNSalaParto", "complicacaoNeonatal", "baixoPeso", "partoCesareo", "partoNormal", "obitoMulher", "qtdeobitoPrecoce", "qtdeobitoTardio", "declaracoesNascidosVivos", "qtdNascidosVivosTermo", "qtdNascidosMortos", "qtdVivosPrematuros", "diagnosticoPrincipal", "indicadorAcidente", "motivoSaidaInternacao", "CID", "numeroDeclaracao","tipoFaturamento","cod_empresa"};
    String campostabela[] = {"cod_resumointernacao", "codcli", "cod_convenio", "guiaSolicitacao", "data", "dataAutorizacao", "senhaAutorizacao", "validadeSenha", "dataInternacao", "horaInternacao", "dataSaidaInternacao", "horaSaidaInternacao", "caraterInternacao", "tipoAcomodacao", "tipoInternacao", "regimeInternacao", "emGestacao", "aborto", "transtornoMaternoRelGravidez", "complicacaoPeriodoPuerperio", "atendimentoRNSalaParto", "complicacaoNeonatal", "baixoPeso", "partoCesareo", "partoNormal", "obitoMulher", "qtdeobitoPrecoce", "qtdeobitoTardio", "declaracoesNascidosVivos", "qtdNascidosVivosTermo", "qtdNascidosMortos", "qtdVivosPrematuros", "diagnosticoPrincipal", "indicadorAcidente", "motivoSaidaInternacao", "CID", "numeroDeclaracao", "tipoFaturamento", "cod_empresa"};

	//Campos a validar
	int validar[] = {0};

	//Vetor de dados que vai ser preenchido
	String dados[] = new String[campos.length];

	//Captura os dados dos campos (exceto código que será auto-numérico)
	for(int i=1; i<campos.length; i++)	
		dados[i] = request.getParameter(campos[i]);
	
	//Captura o valor do próximo índice numérico e coloca no vetor de dados
	dados[0] = banco.getNext(tabela, chave );

	//Formata as datas
	dados[4] = Util.formataDataInvertida(dados[4]);
	dados[5] = Util.formataDataInvertida(dados[5]);
	dados[7] = Util.formataDataInvertida(dados[7]);
	dados[8] = Util.formataDataInvertida(dados[8]);
	dados[10] = Util.formataDataInvertida(dados[10]);
	
	//Coloca o código da empresa da sessão no último campo
	dados[dados.length-1] = (String)session.getAttribute("codempresa");
	
	
	//Se não for exclusão, verificar se é registro duplicado
	if(!acao.equals("exc"))
	{
		//Verifica registro duplicado
        boolean passou = banco.validaRegistro(tabela, chave, id, dados, campostabela, validar);

		//Se tiver registro duplicado, voltar com erro
		if(!passou) 
			response.sendRedirect(pagina + "?inf=7"); //Registro Duplicado
		else

		    //Se a ação for incluir
		    if(acao.equals("inc"))
			{
				ret = banco.gravarDados(tabela, dados, campostabela, (String)session.getAttribute("usuario"));

				//Se retornou OK, efetuado com sucesso
				if(ret.equals("OK"))
				{
					//Insere o procedimento
					ret = honorario.insereItemResumoInternacao(dados[0], dataproced, cod_proced, viaAcesso, horaInicio, horaFim, qtde, valor, cod_empresa);

					if(ret.equals("OK")) {
						//Insere o profissional
						ret = honorario.insereProfResumoInternacao(dados[0], grauParticipacao, prof_reg);
						if(ret.equals("OK"))
							response.sendRedirect(pagina + "?inf=1&cod=" + dados[0]); //Inserido com sucesso
						else
							response.sendRedirect(pagina + "?cod=" + dados[0] + "&inf=" + ret); //Erro nas inserção						
					}
					else
						response.sendRedirect(pagina + "?cod=" + dados[0] + "&inf=" + ret); //Erro nas inserção
				}
				//Se não vier OK, devolver o erro
				else
				{
					response.sendRedirect(pagina + "?cod=" + dados[0] + "&inf=" + ret); //Erro nas inserção
				}
			}
		    //Senão, é alterar
		    else
			{
				ret = banco.alterarTabela(tabela, chave, id, dados, campostabela, (String)session.getAttribute("usuario"));
				if(ret.equals("OK")) {
					//Insere o procedimento
					ret = honorario.insereItemResumoInternacao(id, dataproced, cod_proced, viaAcesso, horaInicio, horaFim, qtde, valor, cod_empresa);
					if(ret.equals("OK")) {
						//Insere o profissional
						ret = honorario.insereProfResumoInternacao(id, grauParticipacao, prof_reg);
						if(ret.equals("OK"))
							response.sendRedirect(pagina + "?cod=" + id + "&inf=5"); //Alterado com sucesso
						else
							response.sendRedirect(pagina + "?inf=" + ret); //Erro na alteração
					}
					else
						response.sendRedirect(pagina + "?inf=" + ret); //Erro na alteração
				}
				else
					response.sendRedirect(pagina + "?inf=" + ret); //Erro na alteração
			}
	}
	//é Excluir
	else
	{
		//Apaga os itens do formulário
		ret = banco.excluirTabela("procedimentosresumointernacao", "codGuia", id, (String)session.getAttribute("usuario"));
		ret = banco.excluirTabela("prof_resumointernacao", "cod_resumointernacao", id, (String)session.getAttribute("usuario"));
		ret = banco.excluirTabela(tabela, chave, id, (String)session.getAttribute("usuario"));


		//Apaga as guias
		ret = banco.excluirTabela("guiasresumointernacao", "cod_resumointernacao", id, (String)session.getAttribute("usuario"));
		ret = banco.excluirTabela("procedimentoresumointernacaoguia", "cod_resumointernacao", id, (String)session.getAttribute("usuario"));
		//ret = banco.excluirTabela("prof_resumointernacaoguia", "cod_resumointernacao", id, (String)session.getAttribute("usuario"));

		if(ret.equals("OK"))
		   	response.sendRedirect(pagina + "?inf=3"); //Removido com sucesso
		else
			response.sendRedirect(pagina + "?inf=" + ret); //Erro na remoção
	}

%>

