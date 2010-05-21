/* Arquivo: Modelos.java
 * Autor: Amilton Souza Martha
 * Criação: 11/05/2007   Atualização: 03/04/2009
 * Obs: Manipula as informações de modelos HTML
 */
package recursos;

import java.sql.*;

public class Modelos {
    //Atributos privados para conexão

    private Connection con = null;
    private Statement stmt = null;

    public Modelos() {
        con = Conecta.getInstance();
    }

    /* pesquisa: valor a ser pesquisado
     * campo: campo a ser pesquisado
     * ordem: ordem de resposta dos campos
     * numPag: número da página selecionada (paginação)
     * qtdeporpagina: quantidade de registros por página
     * tipo: tipo de pesquisa (exata, substring)
     * cod_empresa: código da empresa logada
     */
    public String[] getModelos(String pesquisa, String campo, String ordem, int numPag, int qtdeporpagina, int tipo, String cod_empresa) {
        String resp[] = {"", ""};
        String sql = "";
        ResultSet rs = null;

        //Limpa espaços em branco antes e depois da pesquisa
        pesquisa = pesquisa.trim();

        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);

            //Consulta exata
            if (tipo == 1) {
                sql = "SELECT * FROM modelos WHERE " + campo + "='" + pesquisa + "'";
            } //Começando com o valor
            else if (tipo == 2) {
                sql = "SELECT * FROM modelos WHERE " + campo + " LIKE '" + pesquisa + "%'";
            } //Com o valor no meio
            else if (tipo == 3) {
                sql = "SELECT * FROM modelos WHERE " + campo + " LIKE '%" + pesquisa + "%'";
            }

            //Filtra pela empresa
            sql += " AND cod_empresa=" + cod_empresa;

            //Coloca na ordem
            sql += " ORDER BY " + ordem;

            //Executa a pesquisa
            rs = stmt.executeQuery(sql);

            //Vai para o último registro
            rs.last();

            //Captura a quantidade de linhas
            int numRows = rs.getRow();
            rs.close();

            //Cria paginação das páginas
            resp[1] = Util.criaPaginacao("modelos.jsp", numPag, qtdeporpagina, numRows);

            //Limita para uma quantidade de registros
            sql += " LIMIT " + ((numPag - 1) * qtdeporpagina) + "," + qtdeporpagina;

            //Executa a pesquisa novamente com o limitador
            rs = stmt.executeQuery(sql);

            //Cria looping com a resposta
            while (rs.next()) {
                resp[0] += "<tr onClick=go('modelos.jsp?cod=" + rs.getString("cod_modelo") + "') onMouseOver='trocaCor(this,1);' onMouseOut='trocaCor(this,2);'>\n";
                resp[0] += "	<td width='100%' class='tdLight'>" + rs.getString("descricao") + "</td>\n";
                resp[0] += "</tr>\n";
            }

            //Se não retornar resposta, montar mensagem de não encontrado
            if (resp[0].equals("")) {
                resp[0] += "<tr>";
                resp[0] += "<td width='600' class='tdLight'>";
                resp[0] += "Nenhum registro encontrado para a pesquisa";
                resp[0] += "</td>";
                resp[0] += "</tr>";
            }

            rs.close();
            stmt.close();
            return resp;
        } catch (SQLException e) {
            resp[0] = "Ocorreu um erro: " + e.toString();
            return resp;
        }
    }

    /* pesquisa: valor a ser pesquisado
     * campo: campo a ser pesquisado
     * ordem: ordem de resposta dos campos
     * numPag: número da página selecionada (paginação)
     * qtdeporpagina: quantidade de registros por página
     * tipo: tipo de pesquisa (exata, substring)
     * cod_empresa: código da empresa logada
     */
    public String[] getModelos18(String pesquisa, String campo, String ordem, int numPag, int qtdeporpagina, int tipo, String cod_empresa) {
        String resp[] = {"", ""};
        String sql = "";
        String paginacao = "";
        ResultSet rs = null;

        //Limpa espaços em branco antes e depois da pesquisa
        pesquisa = pesquisa.trim();

        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);

            //Consulta exata
            if (tipo == 1) {
                sql = "SELECT * FROM modelos WHERE " + campo + "='" + pesquisa + "'";
            } //Começando com o valor
            else if (tipo == 2) {
                sql = "SELECT * FROM modelos WHERE " + campo + " LIKE '" + pesquisa + "%'";
            } //Com o valor no meio
            else if (tipo == 3) {
                sql = "SELECT * FROM modelos WHERE " + campo + " LIKE '%" + pesquisa + "%'";
            }

            //Filtra pela empresa
            sql += " AND cod_empresa=" + cod_empresa;

            //Coloca na ordem
            sql += " ORDER BY " + ordem;

            //Executa a pesquisa
            rs = stmt.executeQuery(sql);

            //Vai para o último registro
            rs.last();

            //Captura a quantidade de linhas
            int numRows = rs.getRow();
            rs.close();

            //Cria paginação das páginas
            resp[1] = Util.criaPaginacao("modelos18.jsp", numPag, qtdeporpagina, numRows);

            //Limita para uma quantidade de registros
            sql += " LIMIT " + ((numPag - 1) * qtdeporpagina) + "," + qtdeporpagina;

            //Executa a pesquisa novamente com o limitador
            rs = stmt.executeQuery(sql);

            //Cria looping com a resposta
            while (rs.next()) {
                resp[0] += "<tr onClick=go('modelos18.jsp?cod=" + rs.getString("cod_modelo") + "') onMouseOver='trocaCor(this,1);' onMouseOut='trocaCor(this,2);'>\n";
                resp[0] += "	<td width='100%' class='tdLight'>" + rs.getString("descricao") + "</td>\n";
                resp[0] += "</tr>\n";
            }

            //Se não retornar resposta, montar mensagem de não encontrado
            if (resp[0].equals("")) {
                resp[0] += "<tr>";
                resp[0] += "<td width='600' class='tdLight'>";
                resp[0] += "Nenhum registro encontrado para a pesquisa";
                resp[0] += "</td>";
                resp[0] += "</tr>";
            }

            rs.close();
            stmt.close();
            return resp;
        } catch (SQLException e) {
            resp[0] = "Ocorreu um erro: " + e.toString();
            return resp;
        }
    }

    //Substitui os dados do paciente
    private String substituiDadosPaciente(String texto, String codcli) {
        String sql = "";
        ResultSet rs = null;
        String camposmodelo[] = {"#registro_paciente#", "#prontuario_paciente#", "#nome_paciente#",
            "#endereco_paciente#", "#numero_paciente#", "#complemento_paciente#",
            "#nascimento_paciente#", "#cartao_sus#", "#mãe_paciente#", "#pai_paciente#",
            "#responsavel_paciente#", "#sexo_paciente#", "#bairro_paciente#", "#cep_paciente#",
            "#cpf_paciente#", "#rg_paciente#", "#religião_paciente#", "#nacionalidade_paciente#",
            "#uf_nasc_paciente#", "#municipionascimento_paciente#", "#uf_rg_paciente#",
            "#data_emissaorg_paciente#", "#email_paciente#",
            "#cidade_paciente#", "#estado_paciente#", "#obs_paciente#", "#data_cadastro#"
        };
        String camposbanco[] = {"registro_hospitalar", "localizacao", "nome",
            "nome_logradouro", "numero", "complemento",
            "data_nascimento", "cartao_sus", "mae", "pai",
            "nome_responsavel", "cod_sexo", "bairro", "cep",
            "cic", "rg", "religiao", "nacionalidade",
            "ufnascimento", "municipionascimento", "rg_estado",
            "emissaorg", "email", "cidade", "uf", "obs", "data_abertura_registro"
        };

        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            rs = stmt.executeQuery("SELECT * FROM paciente WHERE codcli=" + codcli);
            if (rs.next()) {
                //Substitui os campos no texto
                for (int i = 0; i < camposmodelo.length; i++) {
                    try {
                        String aux = rs.getString(camposbanco[i]);
                        if (camposbanco[i].equals("data_nascimento") || camposbanco[i].equals("data_abertura_registro")) {
                            aux = Util.formataData(aux);
                        }
                        if (Util.isNull(aux)) {
                            aux = "N/C";
                        }
                        texto = texto.replace(camposmodelo[i], aux);
                    } catch (Exception e) {
                        texto = texto.replace(camposmodelo[i], "N/C");
                    }
                }
                //Substitui pelos dados do paciente
                texto = texto.replace("#estadocivil_paciente#", getEstadoCivil(rs.getString("cod_est_civil")));
                texto = texto.replace("#cor_paciente#", getCor(rs.getString("cod_cor")));
                texto = texto.replace("#indicado_por#", getIndicacao(rs.getString("indicacao"), rs.getString("indicado_por")));
                texto = texto.replace("#idade_paciente#", Util.getIdade(Util.formataData(rs.getString("data_nascimento"))));
                texto = texto.replace("#fone_paciente#", "(" + Util.trataNulo(rs.getString("ddd_residencial"), "N/C") + ") " + Util.trataNulo(rs.getString("tel_residencial"), "N/C"));
                texto = texto.replace("#fonecomercial_paciente#", "(" + Util.trataNulo(rs.getString("ddd_comercial"), "N/C") + ") " + Util.trataNulo(rs.getString("tel_comercial"), "N/C"));
                texto = texto.replace("#celular_paciente#", "(" + Util.trataNulo(rs.getString("ddd_celular"), "N/C") + ") " + Util.trataNulo(rs.getString("tel_celular"), "N/C"));

                //Médico responsável
                String medico_responsavel = new Banco().getValor("nome", "SELECT nome FROM profissional WHERE prof_reg='" + rs.getString("prof_reg") + "'");
                texto = texto.replace("#profissional_responsavel#", Util.trataNulo(medico_responsavel, "N/C"));

                //Se tem profissão
                try {
                    if (!Util.isNull(rs.getString("profissao"))) {
                        //Pega a profissão, se tiver
                        String nomeprofissao = new Banco().getValor("prof", "SELECT CONCAT('(',codCBOS,') ',profissao) as prof FROM cbo2002 WHERE codCBOS='" + rs.getString("profissao") + "'");
                        texto = texto.replace("#profissao_paciente#", nomeprofissao);
                    } else {
                        texto = texto.replace("#profissao_paciente#", "");
                    }
                } catch (Exception e) {
                }

            }
        } catch (SQLException e) {
            texto = "ERRO: " + e.toString() + " SQL: " + sql;
        }
        return texto;
    }

    //Pega os dados de indicação do paciente
    private String getIndicacao(String indicacao, String indicado_por) {
        String resp = "";
        String descr_indicacao = new Banco().getValor("indicacao", "SELECT indicacao FROM indicacoes WHERE cod_indicacao=" + indicacao);

        if(!Util.isNull(descr_indicacao))
            resp = descr_indicacao;
        if(!Util.isNull(indicado_por))
            resp += " (" + indicado_por + ")";

        return resp;
    }

    //Retorna o modelo já alterado os campos
    /*
     *	param[0] = codcli
     *	param[1] = prof_reg
     *	param[2] = cod_hista
     *  param[3] = tipomodelo
     *  param[4] = cod_modelo
     */
    public String getModelo(String param[], String cod_empresa) {
        String resp = "";
        String sql = "";
        ResultSet rs = null;

        //Se não veio tipo de receita
        if (Util.isNull(param[4])) {
            return "";
        }

        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);

            //Se escolheu buscar os dados já gravados na tabela história
            if (param[4].equals("receita") || param[4].equals("procedimentos")) {
                sql = "SELECT " + param[3] + " FROM historia WHERE cod_hist=" + param[2];

                //Executa a pesquisa
                rs = stmt.executeQuery(sql);

                //Cria looping com a resposta
                if (rs.next()) {
                    resp = rs.getString(param[3]);
                }
            } else {
                sql = "SELECT * FROM modelos ";
                sql += "WHERE cod_modelo=" + param[4];

                //Executa a pesquisa
                rs = stmt.executeQuery(sql);

                //Cria looping com a resposta
                if (rs.next()) {
                    resp = rs.getString("modelo");
                }

                //Se veio cod_cli, subsitui dados do paciente
                if (!Util.isNull(param[0])) {
                    resp = substituiDadosPaciente(resp, param[0]);
                    resp = resp.replace("#convenio_paciente#", getConvenios(param[0]));
                    resp = resp.replace("#numero_carteirinha#", getCarteirinhas(param[0]));
                }

                //Se veio prof_reg
                if (!Util.isNull(param[1])) {
                    String nomeprofissional = new Banco().getValor("profissional", "nome", cod_empresa, "AND prof_reg='" + param[1] + "'");
                    String codigoprofissional = new Banco().getValor("profissional", "reg_prof", cod_empresa, "AND prof_reg='" + param[1] + "'");
                    resp = resp.replace("#profissional_atendeu#", nomeprofissional);
                    resp = resp.replace("#registro_profissional#", codigoprofissional);
                }

                //Se veio história
                if (!Util.isNull(param[2])) {
                    String medicamentos = getMedicamentos(param[2]);
                    resp = resp.replace("#medicamentos#", medicamentos);

                    String procedimentos = getProcedimentos(param[2]);
                    resp = resp.replace("#procedimentos#", procedimentos);

                    String diagnosticos = getDiagnosticos(param[2]);
                    resp = resp.replace("#diagnosticos#", diagnosticos);
                }

                //Tira dados do atendimento
                resp = resp.replace("#número_atendimento#", "");
                resp = resp.replace("#procedente#", "");
                resp = resp.replace("#encaminhado#", "");
                resp = resp.replace("#datahoraentrada#", "");
                resp = resp.replace("#datahorasaida#", "");

                //Substitui data, local, cabeçaho e rodapé
                resp = resp.replace("#data_atual#", Util.getData());
                resp = resp.replace("#local#", new Configuracao().getItemConfig("cidade", cod_empresa));
                resp = resp.replace("#cabeçalho#", "<pre>" + new Configuracao().getItemConfig("cabecalho", cod_empresa) + "</pre>");
                resp = resp.replace("#rodapé#", "<pre>" + new Configuracao().getItemConfig("rodape", cod_empresa) + "</pre>");

                String end_cli = new Configuracao().getItemConfig("logradouro", cod_empresa) + ", nº ";
                end_cli += new Configuracao().getItemConfig("numero", cod_empresa) + " ";
                end_cli += new Configuracao().getItemConfig("complemento", cod_empresa) + " ";
                end_cli += "Telefone: " + new Configuracao().getItemConfig("telefone", cod_empresa);

                resp = resp.replace("#endereco_clinica#", end_cli);

            }

            rs.close();
            stmt.close();
            return resp;
        } catch (SQLException e) {
            return "Ocorreu um erro: " + e.toString();
        }
    }

    //Devolve o estado civil do paciente pelo código
    private String getEstadoCivil(String cod_estadocivil) {
        String resp = "";
        if (Util.isNull(cod_estadocivil)) {
            return "";
        }
        char estadocivil = cod_estadocivil.charAt(0);

        switch (estadocivil) {
            case 'C':
                resp = "Casado";
                break;
            case 'S':
                resp = "Solteiro";
                break;
            case 'E':
                resp = "Separado";
                break;
            case 'D':
                resp = "Divorciado";
                break;
            case 'V':
                resp = "Viúvo";
                break;
            case 'O':
                resp = "Outros";
                break;
            default:
                resp = "Outros";
        }

        return resp;
    }

    //Devolve a cor do paciente pelo código
    private String getCor(String cod_cor) {
        String resp = "";
        if (Util.isNull(cod_cor)) {
            return "";
        }
        char cor = cod_cor.charAt(0);

        switch (cor) {
            case 'B':
                resp = "Branco";
                break;
            case 'N':
                resp = "Negro";
                break;
            case 'P':
                resp = "Pardo";
                break;
            case 'I':
                resp = "Índio";
                break;
            case 'A':
                resp = "Amarelo";
                break;
            case 'O':
                resp = "Outros";
                break;
            default:
                resp = "Outros";
        }

        return resp;
    }

    public String getModelo(String cod_modelo, String codcli, String cod_empresa) {
        String resp = "";

        try {
            //Pega o modelo
            resp = new Banco().getValor("modelos", "modelo", cod_empresa, "AND cod_modelo=" + cod_modelo);

            //Pega dados do paciente e substitui no modelo
            resp = substituiDadosPaciente(resp, codcli);
            resp = resp.replace("#convenio_paciente#", getConvenios(codcli));
            resp = resp.replace("#numero_carteirinha#", getCarteirinhas(codcli));

            //Tira dados do atendimento
            resp = resp.replace("#número_atendimento#", "");
            resp = resp.replace("#procedente#", "");
            resp = resp.replace("#encaminhado#", "");
            resp = resp.replace("#datahoraentrada#", "");
            resp = resp.replace("#datahorasaida#", "");


            //Substitui data, local, cabeçaho e rodapé
            resp = resp.replace("#data_atual#", Util.getData());
            resp = resp.replace("#local#", new Configuracao().getItemConfig("cidade", cod_empresa));
            resp = resp.replace("#cabeçalho#", "<pre>" + new Configuracao().getItemConfig("cabecalho", cod_empresa) + "</pre>");
            resp = resp.replace("#rodapé#", "<pre>" + new Configuracao().getItemConfig("rodape", cod_empresa) + "</pre>");

            String end_cli = new Configuracao().getItemConfig("logradouro", cod_empresa) + ", nº ";
            end_cli += new Configuracao().getItemConfig("numero", cod_empresa) + " ";
            end_cli += new Configuracao().getItemConfig("complemento", cod_empresa) + " ";
            end_cli += "Telefone: " + new Configuracao().getItemConfig("telefone", cod_empresa);

            resp = resp.replace("#endereco_clinica#", end_cli);

            return resp;
        } catch (Exception e) {
            return "ERRO: " + e.toString();
        }
    }

    public String getModeloAtendimento(String cod_modelo, String cod_atendimento, String cod_empresa) {
        String resp = "";
        String sql = "";

        try {
            Banco bc = new Banco();

            //Pega o modelo
            resp = bc.getValor("modelos", "modelo", cod_empresa, "AND cod_modelo=" + cod_modelo);

            //Pega registros do atendimento
            ResultSet rs = bc.getRegistro("atendimentos", "cod_atendimento", Integer.parseInt(cod_atendimento));

            //Pega dados do atendimento
            resp = resp.replace("#número_atendimento#", rs.getString("codigo"));
            resp = resp.replace("#procedente#", getEntradaSaida(rs.getString("procedente")));
            resp = resp.replace("#encaminhado#", getEntradaSaida(rs.getString("encaminhado")));
            resp = resp.replace("#datahoraentrada#", Util.formataData(rs.getString("data_entrada")) + " " + Util.formataHora(rs.getString("hora_entrada")));
            resp = resp.replace("#datahorasaida#", Util.formataData(rs.getString("data_saida")) + " " + Util.formataHora(rs.getString("hora_saida")));

            //Pega dados do paciente e substitui no modelo
            resp = substituiDadosPaciente(resp, rs.getString("codcli"));

            //Substitui data, local, cabeçaho e rodapé
            resp = resp.replace("#data_atual#", Util.getData());
            resp = resp.replace("#local#", new Configuracao().getItemConfig("cidade", cod_empresa));
            resp = resp.replace("#cabeçalho#", "<pre>" + new Configuracao().getItemConfig("cabecalho", cod_empresa) + "</pre>");
            resp = resp.replace("#rodapé#", "<pre>" + new Configuracao().getItemConfig("rodape", cod_empresa) + "</pre>");

            String end_cli = new Configuracao().getItemConfig("logradouro", cod_empresa) + ", nº ";
            end_cli += new Configuracao().getItemConfig("numero", cod_empresa) + " ";
            end_cli += new Configuracao().getItemConfig("complemento", cod_empresa) + " ";
            end_cli += "Telefone: " + new Configuracao().getItemConfig("telefone", cod_empresa);

            resp = resp.replace("#endereco_clinica#", end_cli);

            return resp;
        } catch (Exception e) {
            return "ERRO: " + e.toString();
        }
    }

    //Retorna os modelos de uma empresa
    public String getEntradaSaida(String cod) {
        String resp = "";
        String sql = "";
        ResultSet rs = null;

        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);

            //Campos a pesquisar na tabela
            sql += "SELECT entradasaida FROM entradasaida WHERE cod_entradasaida=" + cod;

            //Executa a pesquisa
            rs = stmt.executeQuery(sql);

            //Cria looping com a resposta
            if (rs.next()) {
                resp = rs.getString("entradasaida");
            }

            rs.close();
            stmt.close();
        } catch (SQLException e) {
            resp += "ERRO: " + e.toString() + " SQL: " + sql;
        }

        return resp;
    }

    //Retorna os medicamentos de uma determinada história
    public String getMedicamentos(String cod_hist) {
        String resp = "";
        String sql = "";
        ResultSet rs = null;
        int cont = 1;

        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);

            //Campos a pesquisar na tabela
            sql += "SELECT medicamentos.cod_comercial, medicamentos.comercial, hist_medicamento.indicacao ";
            sql += "FROM medicamentos INNER JOIN hist_medicamento ";
            sql += "ON medicamentos.cod_comercial = hist_medicamento.cod_comercial ";
            sql += "WHERE hist_medicamento.cod_hist=" + cod_hist;
            sql += " ORDER BY cod_hist_med";

            //Executa a pesquisa
            rs = stmt.executeQuery(sql);

            //Cria looping com a resposta
            while (rs.next()) {
                resp += "<b><i>" + cont + " - " + rs.getString("comercial") + "</i></b>";
                resp += "<br>";
                resp += rs.getString("indicacao") + "<br><br>";
                cont++;
            }

            rs.close();
            stmt.close();
        } catch (SQLException e) {
            resp += e.toString();
        }

        return resp;
    }

    //Retorna os convênios do paciente
    public String getConvenios(String codcli) {
        String resp = "";
        String sql = "";
        ResultSet rs = null;

        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);

            //Busca convênios
            sql = "SELECT convenio.descr_convenio FROM paciente_convenio ";
            sql += "INNER JOIN convenio ON paciente_convenio.cod_convenio = convenio.cod_convenio ";
            sql += "WHERE paciente_convenio.codcli=" + codcli;

            //Executa a pesquisa
            rs = stmt.executeQuery(sql);

            //Cria looping com a resposta
            while (rs.next()) {
                resp += rs.getString("descr_convenio") + ", ";
            }

            //Tira a última vírgula
            if (resp.length() > 1) {
                resp = resp.substring(0, resp.length() - 2);
            }

            rs.close();
            stmt.close();
        } catch (SQLException e) {
            resp += e.toString();
        }

        return resp;
    }


    //Retorna os números da carteirinha
    public String getCarteirinhas(String codcli) {
        String resp = "";
        String sql = "";
        ResultSet rs = null;

        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);

            //Busca convênios
            sql = "SELECT num_associado_convenio FROM paciente_convenio ";
            sql += "WHERE paciente_convenio.codcli=" + codcli;

            //Executa a pesquisa
            rs = stmt.executeQuery(sql);

            //Cria looping com a resposta
            while (rs.next()) {
                resp += rs.getString("num_associado_convenio") + ", ";
            }

            //Tira a última vírgula
            if (resp.length() > 1) {
                resp = resp.substring(0, resp.length() - 2);
            }

            rs.close();
            stmt.close();
        } catch (SQLException e) {
            resp += e.toString();
        }

        return resp;
    }

    //Retorna os modelos de uma empresa
    public String getModelos(String cod_empresa) {
        String resp = "";
        String sql = "";
        ResultSet rs = null;

        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);

            //Campos a pesquisar na tabela
            sql += "SELECT cod_modelo, descricao FROM modelos ORDER BY descricao";

            //Executa a pesquisa
            rs = stmt.executeQuery(sql);

            //Cria looping com a resposta
            while (rs.next()) {
                resp += "<option value='" + rs.getString("cod_modelo") + "'>" + rs.getString("descricao") + "</option>\n";
            }

            rs.close();
            stmt.close();
        } catch (SQLException e) {
            resp += "ERRO: " + e.toString() + " SQL: " + sql;
        }

        return resp;
    }

    //Retorna os modelos de uma empresa baseado em um tipo
    public String getModelos(String tipo, String cod_empresa) {
        String resp = "";
        String sql = "";
        ResultSet rs = null;

        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);

            //Campos a pesquisar na tabela
            sql += "SELECT cod_modelo, descricao FROM modelos WHERE tipomodelo='" + tipo + "' ORDER BY descricao";

            //Executa a pesquisa
            rs = stmt.executeQuery(sql);

            //Cria looping com a resposta
            while (rs.next()) {
                resp += "<option value='" + rs.getString("cod_modelo") + "'>" + rs.getString("descricao") + "</option>\n";
            }

            rs.close();
            stmt.close();
        } catch (SQLException e) {
            resp += "ERRO: " + e.toString() + " SQL: " + sql;
        }

        return resp;
    }
    //Retorna os procedimentos de uma determinada história

    public String getProcedimentos(String cod_hist) {
        String resp = "";
        String sql = "";
        ResultSet rs = null;

        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);

            //Campos a pesquisar na tabela
            sql += "SELECT procedimentos.COD_PROCED, procedimentos.Procedimento ";
            sql += "FROM procedimentos INNER JOIN hist_procedimento ";
            sql += "ON procedimentos.COD_PROCED = hist_procedimento.cod_proced ";
            sql += "WHERE hist_procedimento.cod_hist=" + cod_hist;
            sql += " ORDER BY cod_hist_proced";

            //Executa a pesquisa
            rs = stmt.executeQuery(sql);

            //Cria looping com a resposta
            while (rs.next()) {
                resp += "<li>" + rs.getString("Procedimento") + "</li>";
            }

            rs.close();
            stmt.close();
        } catch (SQLException e) {
            resp += e.toString();
        }

        return resp;
    }

    //Retorna os diagnósticos de uma determinada história
    public String getDiagnosticos(String cod_hist) {
        String resp = "";
        String sql = "";
        ResultSet rs = null;

        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);

            //Campos a pesquisar na tabela
            sql += "SELECT diagnosticos.CID, diagnosticos.DESCRICAO ";
            sql += "FROM diagnosticos INNER JOIN hist_diagnostico ";
            sql += "ON diagnosticos.cod_diag = hist_diagnostico.cod_diag ";
            sql += "WHERE hist_diagnostico.cod_hist=" + cod_hist;
            sql += " ORDER BY cod_hist_diag";

            //Executa a pesquisa
            rs = stmt.executeQuery(sql);

            //Cria looping com a resposta
            while (rs.next()) {
                resp += "<li>(" + rs.getString("CID") + ") " + rs.getString("DESCRICAO") + "</li>";
            }

            rs.close();
            stmt.close();
        } catch (SQLException e) {
            resp += e.toString();
        }

        return resp;
    }

    //Retorna os modelos da empresa
    public String getListaModelos(String cod_hist, String tipomodelo, String cod_empresa) {
        String resp = "";
        String sql = "";
        ResultSet rs = null;
        String modelo = "";

        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);

            if (tipomodelo.equals("receita")) {
                modelo = "R";
            } else if (tipomodelo.equals("procedimentos")) {
                modelo = "E";
            } else {
                modelo = "";
            }

            //Campos a pesquisar na tabela
            sql += "SELECT * FROM modelos WHERE cod_empresa=" + cod_empresa;

            if (!Util.isNull(tipomodelo)) {
                sql += " AND tipomodelo='" + modelo + "'";
            }

            //Executa a pesquisa
            rs = stmt.executeQuery(sql);

            //Cria looping com a resposta
            while (rs.next()) {
                resp += "<option value='" + rs.getString("cod_modelo");
                resp += "'>" + rs.getString("descricao") + "</option>\n";
            }

            //Campos a pesquisar na tabela
            sql = "SELECT " + tipomodelo + " FROM historia WHERE cod_hist=" + cod_hist;

            //Executa a pesquisa
            rs = stmt.executeQuery(sql);

            if (rs.next()) {
                if (!Util.isNull(rs.getString(1))) {
                    resp += "<option value='" + tipomodelo + "' selected>Modelo impresso anteriomente</option>\n";
                }
            }

            rs.close();
            stmt.close();
        } catch (SQLException e) {
            resp += e.toString();
        }

        return resp;
    }

    public String atualizaTexto(String texto, String cod_hist, String tipo) {
        String resp = "";
        String sql = "";
        ResultSet rs = null;

        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);

            //Verifica se já existe história
            sql = "SELECT " + tipo + ", DTACON FROM historia WHERE cod_hist=" + cod_hist;

            //Executa a pesquisa
            rs = stmt.executeQuery(sql);

            //Verifica o que encontrou
            if (rs.next()) {

                //Se estiver em branco, salvar
                if (Util.getData().equals(Util.formataData(rs.getString("DTACON"))) || Util.isNull(rs.getString(1))) {
                    sql = "UPDATE historia SET " + tipo + "='" + texto + "' WHERE cod_hist=" + cod_hist;
                    new Banco().executaSQL(sql);
                }
            }

            rs.close();
            stmt.close();
            resp = "OK";
        } catch (SQLException e) {
            resp = "ERRO: " + e.toString() + " SQL: " + sql;
        }

        return resp;

    }

    public static void main(String args[]) {
        String teste = " ";
        /*
         *	param[0] = codcli
         *	param[1] = prof_reg
         *	param[2] = cod_hist
         *      param[3] = tipomodelo
         *      param[4] = cod_modelo
         */
        String param[] = {"409", "12345", "30651", "receita", "4"};
        teste = new Modelos().getModelo(param, "1");

        teste = Util.freeRTE_Preload(teste);

        System.out.println(teste);
    }
}