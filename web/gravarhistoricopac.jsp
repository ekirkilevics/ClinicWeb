<%@page import="recursos.*" %>
<%@page import="java.sql.*" %>

<jsp:useBean class="recursos.Banco" id="banco" scope="page"/>
<jsp:useBean class="recursos.Historico" id="historico" scope="page"/>

<%
//Tipo de salvar
        String tiposalvar = request.getParameter("tiposalvar");

//Configuração 
        String tabela = "historia";
        String chave = "cod_hist";
        String pagina = "novahistoria.jsp";
        String ret = "";
        String erro = "";

//Parâmetros
        String acao = request.getParameter("acao");
        String id = request.getParameter("id");

//Nome dos campos (form e tabela)
        String campos[] = {"", "codcli", "prof_reg", "data", "hora", "historiahid", "definitivo", "resumo", "tipohistoria"};
        String campostabela[] = {"cod_hist", "codcli", "PROF_REG", "DTACON", "HORA", "TEXTO", "definitivo", "resumo", "tipohistoria"};

//Campos a validar
        int validar[] = {1, 3, 4};

//Vetor de dados que vai ser preenchido
        String dados[] = new String[campos.length];

//Captura os dados dos campos (exceto código que será auto-numérico)
        int i;
        for (i = 1; i < campos.length; i++) {
            dados[i] = request.getParameter(campos[i]);
        }

//Captura o valor do próximo índice numérico e coloca no vetor de dados
        dados[0] = banco.getNext(tabela, chave);

//Formatar os campos de data para o formato correto
        dados[3] = Util.formataDataInvertida(dados[3]);

//Se não veio nada,  considerar que é temporária a história
        if (dados[6] == null) {
            dados[6] = "N";
        }

//Se não veio nada,  considerar que não é resumo
        if (dados[7] == null) {
            dados[7] = "0";
        }

//Se não for exclusão, verificar se é registro duplicado
        if (!acao.equals("exc")) {
            //Verifica registro duplicado
            boolean passou = banco.validaRegistro(tabela, chave, id, dados, campostabela, validar);

            //Se tiver, voltar com erro
            if (!passou) {
                erro = "7"; //Registro Duplicado
            } else {
                //Vetor de dados que vai ser preenchido e da tabela
                String dados1[] = new String[4];
                String campos1[] = {"cod_hist_med", "cod_hist", "cod_comercial", "indicacao"};
                String dados2[] = new String[3];
                String campos2[] = {"cod_hist_proced", "cod_hist", "cod_proced"};
                String dados3[] = new String[3];
                String campos3[] = {"cod_hist_diag", "cod_hist", "cod_diag"};

                //Pega as listas
                String lista1[] = request.getParameterValues("lstmedicamento");
                String lista2[] = request.getParameterValues("lstprocedimento");
                String lista3[] = request.getParameterValues("lstdiagnostico");
                String lista4[] = request.getParameterValues("lstindicacao");

                //Se a ação for incluir
                if (acao.equals("inc")) {
                    ret = banco.gravarDados(tabela, dados, campostabela, (String) session.getAttribute("usuario"));
                    if (ret.equals("OK")) {
                        //Atualiza a agenda do paciente para status
                        ret = historico.atualizaAgenda(dados[1], dados[3], dados[2]);

                        //Se tiver algum medicamento, gravar, senão, não gravar
                        if (lista1 != null && lista1.length > 0) {
                            for (i = 0; i < lista1.length; i++) {
                                dados1[0] = banco.getNext("hist_medicamento", "cod_hist_med");
                                dados1[1] = dados[0];
                                dados1[2] = lista1[i];
                                dados1[3] = lista4[i].replace("\n", "<br>");
                                out.println(banco.gravarDados("hist_medicamento", dados1, campos1, (String) session.getAttribute("usuario")));
                            }
                        }

                        //Se tiver algum procedimento, gravar, senão, não gravar
                        if (lista2 != null && lista2.length > 0) {
                            for (i = 0; i < lista2.length; i++) {
                                dados2[0] = banco.getNext("hist_procedimento", "cod_hist_proced");
                                dados2[1] = dados[0];
                                dados2[2] = lista2[i];
                                banco.gravarDados("hist_procedimento", dados2, campos2, (String) session.getAttribute("usuario"));
                            }
                        }

                        //Se tiver algum valor, gravar, senão, não gravar
                        if (lista3 != null && lista3.length > 0) {
                            for (i = 0; i < lista3.length; i++) {
                                dados3[0] = banco.getNext("hist_diagnostico", "cod_hist_diag");
                                dados3[1] = dados[0];
                                dados3[2] = lista3[i];
                                banco.gravarDados("hist_diagnostico", dados3, campos3, (String) session.getAttribute("usuario"));
                            }
                        }
                        //Pega o ID
                        id = dados[0];
                    } else {
                        out.println("erro na insersão: " + ret);
                        erro = ret;
                    }
                } //Senão, é alterar
                else {
                    ret = banco.alterarTabela(tabela, chave, id, dados, campostabela, (String) session.getAttribute("usuario"));

                    if (ret.equals("OK")) {
                        //Remove os dados do medicamentos, procedimentos e diagnósticos para inserir novamente
                        banco.excluirTabela("hist_medicamento", "cod_hist", id, (String) session.getAttribute("usuario"));
                        banco.excluirTabela("hist_procedimento", "cod_hist", id, (String) session.getAttribute("usuario"));
                        banco.excluirTabela("hist_diagnostico", "cod_hist", id, (String) session.getAttribute("usuario"));

                        //Se tiver algum medicamento, gravar, senão, não gravar
                        if (lista1 != null && lista1.length > 0) {
                            for (i = 0; i < lista1.length; i++) {
                                dados1[0] = banco.getNext("hist_medicamento", "cod_hist_med");
                                dados1[1] = new String(id);
                                dados1[2] = lista1[i];
                                dados1[3] = lista4[i].replace("\n", "<br>");
                                banco.gravarDados("hist_medicamento", dados1, campos1, (String) session.getAttribute("usuario"));
                            }
                        }

                        //Se tiver algum procedimento, gravar, senão, não gravar
                        if (lista2 != null && lista2.length > 0) {
                            for (i = 0; i < lista2.length; i++) {
                                dados2[0] = banco.getNext("hist_procedimento", "cod_hist_proced");
                                dados2[1] = new String(id);
                                dados2[2] = lista2[i];
                                banco.gravarDados("hist_procedimento", dados2, campos2, (String) session.getAttribute("usuario"));
                            }
                        }

                        //Se tiver algum valor, gravar, senão, não gravar
                        if (lista3 != null && lista3.length > 0) {
                            for (i = 0; i < lista3.length; i++) {
                                dados3[0] = banco.getNext("hist_diagnostico", "cod_hist_diag");
                                dados3[1] = new String(id);
                                dados3[2] = lista3[i];
                                banco.gravarDados("hist_diagnostico", dados3, campos3, (String) session.getAttribute("usuario"));
                            }
                        }
                    } else {
                        out.println("erro na alteração: " + ret);
                        erro = ret;
                    }
                }
            }
        } //Se for exclusão
        else {
            //Exclui relacionamentos com dados estruturados
            banco.excluirTabela("hist_medicamento", "cod_hist", id, (String) session.getAttribute("usuario"));
            banco.excluirTabela("hist_procedimento", "cod_hist", id, (String) session.getAttribute("usuario"));
            banco.excluirTabela("hist_diagnostico", "cod_hist", id, (String) session.getAttribute("usuario"));

            //Remove história
            ret = banco.excluirTabela(tabela, chave, id, (String) session.getAttribute("usuario"));
            if (ret.equals("OK")) {
                out.println("Removido");
            } else {
                out.println("Erro ao remover: " + ret);
            }

            tiposalvar = "2";
        }

%>
<html>
    <head>
        <title>Iframe</title>
        <script language="JavaScript">

            var id = "<%= id%>";
            var tiposalvar = "<%= tiposalvar%>";
            var erro = "<%= erro%>";

            function iniciar() {

                if(erro == "7") {
                    parent.alert("Já existe uma história para essa paciente na mesma data e hora");
                }
                else if(erro == "") {
                    parent.atualizarId(id, tiposalvar);
                }
				else {
					parent.alert("Ocorreu um erro ao salvar a história\n" + erro);
				}
            }

        </script>
    </head>
    <body onLoad="iniciar()">
        &nbsp;
    </body>
</html>
