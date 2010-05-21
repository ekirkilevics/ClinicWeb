<%@page import="recursos.*" %>
<%@page import="java.sql.*" %>

<jsp:useBean class="recursos.Banco" id="banco" scope="page"/>
<jsp:useBean class="recursos.Faturamento" id="faturamento" scope="page"/>
<jsp:useBean class="recursos.TISS" id="tiss" scope="page"/>

<%
	String codcli 		= request.getParameter("codcli");
	String plano		= request.getParameter("cod_plano");
	String convenio 	= banco.getValor("cod_convenio", "SELECT cod_convenio FROM planos WHERE cod_plano=" + plano);
	String prof_reg 	= request.getParameter("executante");
	String solicitante 	= request.getParameter("prof_reg");
	String data 		= Util.formataDataInvertida(request.getParameter("data"));
	String hora			= request.getParameter("hora");
	String procedimento = request.getParameter("procedimento");
	String viaAcesso 	= request.getParameter("viaAcesso");
	String qtde			= request.getParameter("qtde");
	String valor		= request.getParameter("valor").replace(".","");
			valor		= valor.replace(",",".");
	String pagto		= request.getParameter("pagto");
	String senha		= ((int)(Math.random()*10000)) + ""; //Gera senha de 4 caracteres numéricos aleatória
	senha = Util.formataNumero(senha, 4);
	
	String tabela		= "faturas";
	String chave 		= "Numero";

	//Parâmetros
	String acao = request.getParameter("acao");
	String id 	= request.getParameter("id");
	String ret = "";
	
	//Nome dos campos da tabela
	String campostabela[] = {"Numero","codcli","prof_reg","Cod_solicitante","Data_Lanca","hora_lanca"};
	
	//Vetor de dados que vai ser preenchido
	String dados[] = new String[campostabela.length];
	
	//Nome dos campos da tabela
	String campostabelaProced[] = {"cod_subitem","Numero","Cod_Proced", "qtde","valor","tipo_pagto","cod_convenio", "cod_plano", "registro", "senha", "viaAcesso"};
	
	//Vetor de dados que vai ser preenchido
	String dadosProced[] = new String[campostabelaProced.length];

	//Se não for exclusão, verificar se é registro duplicado
	if(!acao.equals("exc")) {
		//Se a ação for incluir
		if(acao.equals("inc")) {
			
			//Captura o valor do próximo índice numérico e coloca no vetor de dados
			dados[0] = banco.getNext(tabela, chave );
			
			//Dados a serem inseridos
			dados[1]  = codcli;
			dados[2]  = prof_reg;
			dados[3]  = solicitante;
			dados[4]  = data;
			dados[5]  = hora;
			
			banco.gravarDados(tabela, dados, campostabela, (String)session.getAttribute("usuario"));
			
			/******** Grava dados do Procedimento *********/
			//Se vier dados de procedimento, inserir
			if(!Util.isNull(procedimento) && !Util.isNull(qtde) && !Util.isNull(valor)) {
				
				//Preenche valores
				dadosProced[0] = banco.getNext("faturas_itens", "cod_subitem" );
				dadosProced[1] = dados[0];
				dadosProced[2] = procedimento;
				dadosProced[3] = qtde;
				dadosProced[4] = valor;
				dadosProced[5] = pagto;
				dadosProced[6] = convenio;
				dadosProced[7] = plano;
				dadosProced[8] = dadosProced[1] + "" + procedimento;
				dadosProced[9] = senha;
				dadosProced[10] = viaAcesso;

				//Verifica registro duplicado
				String duplicado = faturamento.procedimentoDuplicado(dados[1], dadosProced[2], dados[2], dados[4]);
				
				if(!duplicado.equals("OK")) {
					response.sendRedirect("faturamentos1.jsp?cod=" + dados[0] + "&inf=7&detalhes=" + duplicado);
				}
				else {
					banco.gravarDados("faturas_itens", dadosProced, campostabelaProced, (String)session.getAttribute("usuario"));
					response.sendRedirect("faturamentos1.jsp?cod=" + dados[0] + "&inf=Procedimento%20Inserido");
				}
			}
			/*************************************************/
			else
				response.sendRedirect("faturamentos1.jsp?cod=" + dados[0]); //Inserido com sucesso
		}
		//Se for alteração
		else {
			//Dados a serem inseridos
			dados[1]  = codcli;
			dados[2]  = prof_reg;
			dados[3]  = solicitante;
			dados[4]  = data;
			dados[5]  = hora;
			
			banco.alterarTabela(tabela, chave, id, dados, campostabela, (String)session.getAttribute("usuario"));
			
			/******** Grava dados do Procedimento *********/
			//Se vier dados de procedimento, inserir
			if(!Util.isNull(procedimento) && !Util.isNull(qtde) && !Util.isNull(valor)) {
				
				//Preeche valores
				dadosProced[0] = banco.getNext("faturas_itens", "cod_subitem" );
				dadosProced[1] = id;
				dadosProced[2] = procedimento;
				dadosProced[3] = qtde;
				dadosProced[4] = valor;
				dadosProced[5] = pagto;
				dadosProced[6] = convenio;
				dadosProced[7] = plano;
				dadosProced[8] = dadosProced[1] + "" + procedimento;
				dadosProced[9] = senha;
				dadosProced[10] = viaAcesso;
				
				//Verifica registro duplicado
				String duplicado = faturamento.procedimentoDuplicado(dados[1], dadosProced[2], dados[2], dados[4]);
				
				if(!duplicado.equals("OK")) {

					response.sendRedirect("faturamentos1.jsp?cod=" + id + "&inf=7&detalhes=" + duplicado);
				}
				else {
					ret = banco.gravarDados("faturas_itens", dadosProced, campostabelaProced, (String)session.getAttribute("usuario"));
					response.sendRedirect("faturamentos1.jsp?cod=" + id + "&inf=Procedimento%20Inserido");
				}
			}
			/*************************************************/
			else
				response.sendRedirect("faturamentos1.jsp?cod=" + id + "&inf=5");
		}
		
	}
	
	//Se for exclusão
	else {
		ret = faturamento.removeFatura(id, (String)session.getAttribute("usuario"));
		if(ret.equals("OK")) {
			//excluir as guias de consulta e SADT dessa fatura
			tiss.apagarGuia(id, (String)session.getAttribute("codempresa"));
			
			response.sendRedirect("faturamentos1.jsp?inf=3"); //Removido com sucesso
		} else
			response.sendRedirect("faturamentos1.jsp?inf=" + ret); //Erro na remoção
	}
%>
