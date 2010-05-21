/* Arquivo: Faturamento.java
 * Autor: Amilton Souza Martha
 * Criação: 25/11/2005   Atualização: 06/05/2009
 * Obs: Manipula informações de Faturamento
 */
package recursos;

import java.sql.*;

public class Faturamento {
    //Atributos privados para conexão
    private Connection con = null;
    private Statement stmt = null;

    public Faturamento() {
        con = Conecta.getInstance();
    }
    //Devolve o nome do convênio pelo código
    public String getNomeConvenio(String codconvenio) {
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);

            String resp = "";
            ResultSet rs = null;

            //Recupera o código do convênio do paciente
            String sql = "SELECT descr_convenio FROM convenio ";
            sql += "WHERE cod_convenio=" + codconvenio;

            //Executa a pesquisa
            rs = stmt.executeQuery(sql);

            if (rs.next()) {
                resp = rs.getString("descr_convenio");            //Fecha o recordset
            }
            rs.close();
            stmt.close();

            return resp;
        } catch (SQLException e) {
            return e.toString();
        }
    }
    //Devolve os convênios
    public String getConvenios(String codconv, String cod_empresa) {
        String resp = "", sql = "";
        ResultSet rs = null;

        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);

            //Recupera todos os convênios para montar a lista
            sql = "SELECT cod_convenio, descr_convenio FROM convenio ";
            sql += "WHERE cod_empresa=" + cod_empresa + " ORDER BY descr_convenio";

            //Executa a pesquisa
            rs = stmt.executeQuery(sql);

            //Cria looping com a resposta
            while (rs.next()) {
                if (rs.getString("cod_convenio").equals(codconv)) {
                    resp += "<option value='" + rs.getString("cod_convenio") + "' selected>" + rs.getString("descr_convenio") + "</option>\n";
                } else {
                    resp += "<option value='" + rs.getString("cod_convenio") + "'>" + rs.getString("descr_convenio") + "</option>\n";
                }
            }

            rs.close();

            stmt.close();
            return resp + sql;
        } catch (SQLException e) {
            return "ERRO:" + e.toString() + " SQL=" + sql;
        }
    }
    //Devolve as especialidades
    public String getEspecialidades() {
        String sql = "SELECT codesp, descri FROM especialidade ";
        sql += "WHERE descri <> '' ORDER BY descri";
        String resp = "";
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);

            ResultSet rs = null;
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);

            //Cria looping com a resposta
            while (rs.next()) {
                resp += "<option value='" + rs.getString("codesp") + "'>" + rs.getString("descri") + "</option>\n";
            }
            rs.close();
            stmt.close();

            return resp;
        } catch (SQLException e) {
            return e.toString();
        }
    }
    //Pega os procedimentos que o convênio possui, na especialidade selecionada
    //resp[0]: código procedimento
    //resp[1]: nome procedimento
    //resp[2]: valor procecimento
    public String[] getProcedimentos(String cod_plano) {
        //Vetor para a resposta
        String resp[] = {"' ','", "' ','", "' ','"};

        try {

            //Se veio cod_plano vazio, retornar nada
            if (Util.isNull(cod_plano)) {
                resp[0] += "'";
                resp[1] += "'";
                resp[2] += "'";
                return resp;
            }

            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);

            String sql;
            ResultSet rs = null;

            //Recupera os procedimentos que o plano cobre
            sql = "SELECT procedimentos.COD_PROCED, procedimentos.Procedimento, ";
            sql += "valorprocedimentos.valor ";
            sql += "FROM valorprocedimentos INNER JOIN procedimentos ";
            sql += "ON valorprocedimentos.cod_proced = procedimentos.COD_PROCED ";
            sql += "WHERE valorprocedimentos.cod_plano=" + cod_plano;
            sql += " AND procedimentos.flag=1 ";
            sql += "ORDER BY Procedimento";

            //Executa a pesquisa
            rs = stmt.executeQuery(sql);

            while (rs.next()) {
                resp[0] += rs.getString("COD_PROCED") + "','";
                resp[1] += rs.getString("Procedimento") + "','";
                resp[2] += rs.getString("valor") + "','";
            }

            if (!resp[0].equals("' ','")) {
                resp[0] = resp[0].substring(0, resp[0].length() - 2);
                resp[1] = resp[1].substring(0, resp[1].length() - 2);
                resp[2] = resp[2].substring(0, resp[2].length() - 2);
            } else {
                //Finaliza a aspas simples
                resp[0] += "'";
                resp[1] += "'";
                resp[2] += "'";
            }

            //Fecha o recordset
            rs.close();

            stmt.close();
            return resp;
        } catch (SQLException e) {
            resp[0] = e.toString();
            return resp;
        }
    }
    
    //Monta combo com todos os profissionais
    public String getProfissionais(String cod_empresa) {
        String resp = "";
        String sql = "";
        ResultSet rs = null;

        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);

            sql += "SELECT nome, cod, prof_reg FROM profissional ";
            sql += "WHERE cod_empresa=" + cod_empresa;

            //Só pega profissionais internos
            sql += " AND locacao='interno' and ativo='S' ORDER BY nome";

            //Executa a pesquisa
            rs = stmt.executeQuery(sql);

            //Cria looping com a resposta
            while (rs.next()) {
                resp += "<option value='" + rs.getString("prof_reg") + "'>" + rs.getString("nome") + "</option>\n";
            }

            rs.close();
            stmt.close();

            return resp;

        } catch (SQLException e) {
            return "Erro:" + e.toString();
        }
    }

    //Captura os cheques de um faturamento
    public ResultSet getCheques(String codsubitem) {
        String sql = "";
        ResultSet rs = null;

        sql += "SELECT * FROM faturas_chq WHERE cod_subitem=" + codsubitem;
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);

            //Executa a pesquisa
            rs = stmt.executeQuery(sql);

            return rs;

        } catch (SQLException e) {
            return null;
        }
    }
    
    //Verifica se o registro está duplicado
    public String procedimentoDuplicado(String codcli, String cod_proced, String prof_reg, String data) {
        String sql = "";
        ResultSet rs = null;

        sql += "SELECT procedimentos.tipoGuia, faturas.prof_reg ";
        sql += "FROM (procedimentos INNER JOIN faturas_itens ";
        sql += "ON procedimentos.COD_PROCED = faturas_itens.Cod_Proced) ";
        sql += "INNER JOIN faturas ON faturas_itens.Numero = faturas.Numero ";
        sql += "WHERE faturas_itens.Cod_Proced=" + cod_proced + " ";
        sql += "AND faturas.Data_Lanca='" + data + "' ";
        sql += "AND faturas.codcli=" + codcli;

        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);

            //Executa a pesquisa
            rs = stmt.executeQuery(sql);

            //Se acho o cliente com o mesmo procedimento na mesma data
            if (rs.next()) {
                //Se o médico for o mesmo, é duplicado
                if (rs.getString("prof_reg").equals(prof_reg)) {
                    return "Mesmo%20Médico";
                //Se o médico for diferente, verificar se é guia de consulta, se não for é duplicado
                } else {
                    if (rs.getInt("tipoGuia") != 1) {
                        return "Não%20é%20Consulta";
                    }
                }
            }

            rs.close();
            stmt.close();
            return "OK";

        } catch (SQLException e) {
            return "ERRO:" + e.toString();
        }
    }

    private String getImagem(String pagto, String convenio, String cod_subitem) {
        String img = "";	//Imagem
        String label = "";	//título do tool tip text
        String resp = "";	//resposta final

        if (pagto.equals("1")) { //Dinheiro
            img = "money.gif";
            label = "Pagamento em Dinheiro";

        } else if (pagto.equals("2")) { //Cheque
            img = "cheque.gif";
            label = "Pagamento em Cheque";
        } else if (pagto.equals("3")) { //Cartão
            img = "cartoes.gif";
            label = "Pagamento com Cartão de Crédito";
        } else {//Convênio
            resp = getNomeConvenio(convenio);
            return resp;
        }

        resp = "<a title='" + label + "' href=Javascript:detalhesPagamento(";
        resp += pagto + "," + cod_subitem + ")>";
        resp += "<img src='images/" + img + "' border=0></a>";

        return resp;
    }
    //Recupera os itens da fatura
    public String getItensFatura(String cod_fatura) {
        String resp = "";
        String sql = "";
        ResultSet rs = null;
        String sqtde, svalor;
        float soma = 0, subtotal = 0;
        int cont = 0; //contador de registros

        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);

            //Captura os itens da fatura
            sql = "SELECT faturas_itens.*, procedimentos.Procedimento, ";
            sql += "paciente.codcli, paciente.nome, faturas.Data_Lanca, ";
            sql += "paciente.data_nascimento ";
            sql += "FROM ((faturas_itens INNER JOIN procedimentos ON ";
            sql += "faturas_itens.Cod_Proced = procedimentos.COD_PROCED) ";
            sql += "INNER JOIN faturas ON faturas_itens.Numero = ";
            sql += "faturas.Numero) INNER JOIN paciente ON faturas.codcli = ";
            sql += "paciente.codcli ";
            sql += "WHERE faturas_itens.Numero=" + cod_fatura;

            //Executa a pesquisa
            rs = stmt.executeQuery(sql);

            //Cria looping com a resposta
            while (rs.next()) {
                //Valores
                sqtde = rs.getString("qtde");
                svalor = rs.getString("valor");

                //SubTotal e total
                subtotal = Float.parseFloat(sqtde) * Float.parseFloat(svalor);
                soma += subtotal;

                resp += "<tr>\n";
                resp += "	<td class='tdLight'>" + rs.getString("Procedimento") + "&nbsp;</td>\n";
                resp += "	<td class='tdLight' align='center'>" + Util.trataNulo(rs.getString("viaAcesso"), "") + "&nbsp;</td>\n";
                resp += "	<td class='tdLight' align='center'>" + sqtde + "&nbsp;</td>\n";
                resp += "	<td class='tdLight'>" + Util.formatCurrency(svalor) + "&nbsp;</td>\n";
                resp += "	<td class='tdLight'>" + Util.formatCurrency("" + subtotal) + "&nbsp;</td>\n";
                resp += "	<td class='tdLight' align='center'>" + getImagem(rs.getString("tipo_pagto"), rs.getString("cod_convenio"), rs.getString("cod_subitem")) + "</td>\n";
                resp += "	<td class='TdLight' align='center'><a title='Excluir Registro' href='Javascript:excluirProcedimento(" + rs.getString("cod_subitem") + ");'><img src='images/delete.gif' border='0'></a></td>\n";
                resp += "</tr>\n";

                cont++;

            }

            resp += "<tr><td><input type='hidden' name='subtotal' id='subtotal' value='" + soma + "'><input type='hidden' name='qtdeitens' id='qtdeitens' value='" + cont + "'></td></tr>";

            rs.close();
            stmt.close();

            return resp;

        } catch (SQLException e) {
            return "Erro:" + e.toString();
        }
    }
    //Recupera os itens da fatura (customização para o INF - cliente 1)
    public String getItensFatura1(String cod_fatura) {
        String resp = "";
        String sql = "";
        ResultSet rs = null;
        String sqtde, svalor;
        float soma = 0, subtotal = 0;
        String imprime_faturamento = "";

        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);

            //Captura os itens da fatura
            sql = "SELECT faturas_itens.*, procedimentos.Procedimento, ";
            sql += "paciente.codcli, paciente.nome, faturas.Data_Lanca, ";
            sql += "paciente.data_nascimento ";
            sql += "FROM ((faturas_itens INNER JOIN procedimentos ON ";
            sql += "faturas_itens.Cod_Proced = procedimentos.COD_PROCED) ";
            sql += "INNER JOIN faturas ON faturas_itens.Numero = ";
            sql += "faturas.Numero) INNER JOIN paciente ON faturas.codcli = ";
            sql += "paciente.codcli ";
            sql += "WHERE faturas_itens.Numero=" + cod_fatura;

            //Executa a pesquisa
            rs = stmt.executeQuery(sql);

            //Cria looping com a resposta
            while (rs.next()) {
                sqtde = rs.getString("qtde");
                svalor = rs.getString("valor");
                subtotal = Float.parseFloat(sqtde) * Float.parseFloat(svalor);
                imprime_faturamento = "'" + rs.getString("paciente.codcli") + "','" + rs.getString("paciente.nome") + "','" + Util.formataData(rs.getString("faturas.Data_Lanca")) + "','" + Util.formataData(rs.getString("paciente.data_nascimento")) + "','" + rs.getString("cod_subitem");

                soma += subtotal;
                resp += "<tr>\n";
                resp += "	<td class='tdLight'>" + rs.getString("Procedimento") + "&nbsp;</td>\n";
                resp += "	<td class='tdLight' align='center'>" + Util.trataNulo(rs.getString("viaAcesso"), "") + "&nbsp;</td>\n";
                resp += "	<td class='tdLight' align='center'>" + sqtde + "&nbsp;</td>\n";
                resp += "	<td class='tdLight'>" + Util.formatCurrency(svalor) + "&nbsp;</td>\n";
                resp += "	<td class='tdLight'>" + Util.formatCurrency("" + subtotal) + "&nbsp;</td>\n";
                resp += "	<td class='tdLight' align='center'>" + getImagem(rs.getString("tipo_pagto"), rs.getString("cod_convenio"), rs.getString("cod_subitem")) + "</td>\n";
                resp += "	<td class='TdLight' align='center'><a title='Excluir Registro' href='Javascript:excluirProcedimento(" + rs.getString("cod_subitem") + ");'><img src='images/delete.gif' border='0'></a></td>\n";
                resp += "	<td class='TdLight' align='center'><a title='Imprimir Ficha de Atendimento' href=\"Javascript:fichaatendimento(" + imprime_faturamento + "');\"><img src='images/print.gif' border='0'></a></td>\n";
                resp += "</tr>\n";

            }

            resp += "<tr><td><input type='hidden' name='subtotal' id='subtotal' value='" + soma + "'></td></tr>";

            rs.close();
            stmt.close();

            return resp;

        } catch (SQLException e) {
            return "Erro:" + e.toString();
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
    public String[] getFaturamento(String pesquisa, String campo, String ordem, int numPag, int qtdeporpagina, int tipo, String cod_empresa, String pagina) {
        String resp[] = {"", ""};
        String sql = "";
        String codigo = "";
        String solicitante = "";
        ResultSet rs = null;
        ResultSet rs2 = null;
        Statement stmt2 = null;
        float subtotal;
        pagina = new Banco().getPagina(pagina); //Pega o nome da página atual

        //Limpa espaços em branco antes e depois da pesquisa
        pesquisa = pesquisa.trim();

        //Só fazer a pesquisa se veio algum valor
        if (!Util.isNull(pesquisa)) {

            sql += "SELECT paciente.nome, Executante.nome, Solicitante.nome, ";
            sql += "faturas.Numero, faturas.Data_Lanca ";
            sql += "FROM ((paciente INNER JOIN faturas ON paciente.codcli = ";
            sql += "faturas.codcli) LEFT JOIN profissional AS Solicitante ON ";
            sql += "faturas.Cod_Solicitante = Solicitante.prof_reg) INNER JOIN ";
            sql += "profissional AS Executante ON faturas.prof_reg = ";
            sql += "Executante.prof_reg ";

            try {
                //Cria statement para enviar sql
                stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                        ResultSet.CONCUR_READ_ONLY);

                //Consulta exata
                if (tipo == 1) {
                    sql += "WHERE " + campo + "='" + pesquisa + "'";
                //Começando com o valor
                } else if (tipo == 2) {
                    sql += "WHERE " + campo + " LIKE '" + pesquisa + "%'";
                //Com o valor no meio
                } else if (tipo == 3) {
                    sql += "WHERE " + campo + " LIKE '%" + pesquisa + "%'";                //Filtra pela empresa
                }
                sql += " AND paciente.cod_empresa=" + cod_empresa;

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
                resp[1] = Util.criaPaginacao(pagina, numPag, qtdeporpagina, numRows);

                //Limita para uma quantidade de registros
                sql += " LIMIT " + ((numPag - 1) * qtdeporpagina) + "," + qtdeporpagina;

                //Executa a pesquisa
                rs = stmt.executeQuery(sql);

                stmt2 = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                        ResultSet.CONCUR_READ_ONLY);

                //Cria looping com a resposta
                while (rs.next()) {
                    codigo = rs.getString("faturas.Numero");

                    //Soma os itens da fatura
                    rs2 = stmt2.executeQuery("SELECT SUM(valor*qtde) as Total FROM faturas_itens WHERE Numero = " + codigo);
                    rs2.next();
                    subtotal = rs2.getFloat("Total");
                    rs2.close();

                    solicitante = rs.getString("Solicitante.nome") != null ? rs.getString("Solicitante.nome") : "N/C";

                    resp[0] += "<tr onClick=go('" + pagina + "?cod=" + codigo + "') onMouseOver='trocaCor(this,1);' onMouseOut='trocaCor(this,2);'>";
                    resp[0] += "<td width='110' class='tdLight'>" + rs.getString("paciente.nome") + "</td>\n";
                    resp[0] += "<td width='110' class='tdLight'>" + rs.getString("Executante.nome") + "&nbsp;</td>\n";
                    resp[0] += "<td width='110' class='tdLight'>" + solicitante + "</td>\n";
                    resp[0] += "<td width='60' class='tdLight'>" + Util.formataData(rs.getString("data_Lanca")) + "</td>\n";
                    resp[0] += "<td width='60' class='tdLight'>" + Util.formatCurrency(subtotal + "") + "</td>\n";
                    resp[0] += "</tr>";
                }

                //Se não retornar resposta, montar mensagem de não encontrado
                if (resp[0].equals("")) {
                    resp[0] += "<tr>";
                    resp[0] += "<td colspan='6' width='600' class='tdLight'>";
                    resp[0] += "Nenhum registro";
                    resp[0] += "</td>";
                    resp[0] += "</tr>";
                }
                rs.close();
                stmt.close();

                return resp;

            } catch (SQLException e) {
                resp[0] = "Erro:" + e.toString();
                return resp;
            }
        } else {
            //Cria paginação das páginas
            resp[1] = Util.criaPaginacao(pagina, numPag, qtdeporpagina, 0);
            resp[0] += "<tr>";
            resp[0] += "<td colspan='6' width='600' class='tdLight'>";
            resp[0] += "Nenhum registro encontrado";
            resp[0] += "</td>";
            resp[0] += "</tr>";
            return resp;
        }
    }

    /*
    resp[0] = Nome do paciente
    resp[1] = Data de Nascimento
    resp[2] = Solicitante.nome
    resp[3] = foto
     */    //Captura dados do faturamento
    public String[] getDados(String cod_faturamento) {

        String resp[] = new String[4];
        ResultSet rs = null;
        String sql;


        try {

            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);

            sql = "SELECT paciente.nome, paciente.data_nascimento, paciente.foto, ";
            sql += "Solicitante.nome FROM (paciente INNER ";
            sql += "JOIN faturas ON paciente.codcli = faturas.codcli) ";
            sql += "LEFT JOIN profissional AS Solicitante ON ";
            sql += "faturas.Cod_Solicitante = Solicitante.prof_reg ";
            sql += "WHERE faturas.Numero=" + cod_faturamento;

            //Executa a pesquisa
            rs = stmt.executeQuery(sql);

            if (rs.next()) {
                resp[0] = rs.getString("paciente.nome");
                resp[1] = Util.formataData(rs.getString("data_nascimento"));
                resp[2] = rs.getString("Solicitante.nome") != null ? rs.getString("Solicitante.nome") : "";
                resp[3] = rs.getString("paciente.foto");
            }

            rs.close();
            stmt.close();

            return resp;

        } catch (SQLException e) {
            resp[0] = "Erro" + e.toString();
            return resp;
        }

    }
    //Excluir todos os registros de itens da fatura
    public String removeFatura(String numero, String usuario) {
        ResultSet rs = null;
        String sql, resp = "";

        try {

            Banco bc = new Banco();
            
            //Cria statement para enviar sql
            stmt = con.createStatement();

            //Busca todos os itens da fatura
            sql = "SELECT cod_subitem FROM faturas_itens WHERE Numero=" + numero;

            //Executa a pesquisa
            rs = stmt.executeQuery(sql);

            //Varre todos os itens da fatura e apaga registros de cheques e cartões
            while (rs.next()) {
                bc.executaSQL("DELETE FROM faturas_chq WHERE cod_subitem=" + rs.getString("cod_subitem"));
                bc.executaSQL("DELETE FROM faturas_cartoes WHERE cod_subitem=" + rs.getString("cod_subitem"));
            }

            //Apaga todos os itens da fatura
            bc.executaSQL("DELETE FROM faturas_itens WHERE Numero=" + numero);

            //Apaga a fatura em si
            bc.executaSQL("DELETE FROM faturas WHERE Numero=" + numero);

            rs.close();
            stmt.close();

            resp = "OK";

            return resp;

        } catch (SQLException e) {
            resp = e.toString();
            return resp;
        }

    }

    //Excluir um registro de item da fatura
    public String removeFaturaItem(String cod) {
        //Se não veio código
        if (Util.isNull(cod)) {
            return "";
        }

        Banco bc = new Banco();
        bc.executaSQL("DELETE FROM faturas_itens WHERE cod_subitem=" + cod);
        bc.executaSQL("DELETE FROM procedimentossadt WHERE codsubitem=" + cod);
        bc.executaSQL("DELETE FROM faturas_chq WHERE cod_subitem=" + cod);
        bc.executaSQL("DELETE FROM faturas_cartoes WHERE cod_subitem=" + cod);

        return "OK";
    }

    public static void main(String args[]) {
        Faturamento fat = new Faturamento();
        //boolean teste;
        //fat.getFaturamento("a","paciente.nome","paciente.nome", 1,50,2,"8","");
        String teste = fat.procedimentoDuplicado("31683","41","02042449","2008-07-31");

        //System.out.println(teste);
    }
}