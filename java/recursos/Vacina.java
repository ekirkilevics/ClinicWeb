/* Arquivo: Vacina.java
 * Autor: Amilton Souza Martha
 * Criação: 14/11/2007   Atualização: 18/11/2008
 * Obs: Manipula as informações de vacina
 */

package recursos;
import java.sql.*;
import java.util.Vector;

public class Vacina {
    //Atributos privados para conexão
    private Connection con = null;
    private Statement stmt = null;
    
    //Tipos de Pagamentos
    private String tipo_pagto[] = {"Convênio","Dinheiro","Cheque","Cheque Pré", "Cheque Programado", "Cartão de Débito", "Cartão de Crédito", "Crédito Parcelado"};

    public String getTiposPagto() {
          String resp = "";
          for(int i=0; i<tipo_pagto.length; i++) {
              resp += "<option value='" + (i+1) + "'>" + tipo_pagto[i] + "</option>\n";
          }
          return resp;
    }
    
    public Vacina() {
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
    public String[] getVacinas(String pesquisa, String campo, String ordem, int numPag, int qtdeporpagina, int tipo, String cod_empresa) {
        String resp[] = {"",""};
        String sql = "";
        ResultSet rs = null;
        
        //Limpa espaços em branco antes e depois da pesquisa
        pesquisa = pesquisa.trim();
        
        sql += "SELECT * FROM vac_vacinas ";
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            //Consulta exata
            if(tipo == 1)
                sql += "WHERE " + campo + "='" + pesquisa + "'";
            //Começando com o valor
            else if(tipo == 2)
                sql += "WHERE " + campo + " LIKE '" + pesquisa + "%'";
            //Com o valor no meio
            else if(tipo == 3)
                sql += "WHERE " + campo + " LIKE '%" + pesquisa + "%'";
            
            //Filtra pela empresa e ativo
            sql += " AND ativo='S' AND cod_empresa=" + cod_empresa;
            
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
            resp[1] = Util.criaPaginacao("vacinas.jsp", numPag, qtdeporpagina, numRows);
            
            //Limita para uma quantidade de registros
            sql += " LIMIT " + ((numPag-1)*qtdeporpagina) + "," + qtdeporpagina;
            
            //Executa a pesquisa novamente com o limitador
            rs = stmt.executeQuery(sql);
            
            //Cria looping com a resposta
            while(rs.next()) {
                resp[0] += "<tr onClick=go('vacinas.jsp?cod=" + rs.getString("cod_vacina") + "') onMouseOver='trocaCor(this,1);' onMouseOut='trocaCor(this,2);'>";
                resp[0] += "<td width='100%' class='tdLight'>" + rs.getString("descricao") + "&nbsp;</td>\n";
                resp[0] += "</tr>";
            }
            
            //Se não retornar resposta, montar mensagem de não encontrado
            if(resp[0].equals("")) {
                resp[0] += "<tr>";
                resp[0] += "<td width='600' class='tdLight'>";
                resp[0] += "Nenhum registro encontrado para a pesquisa";
                resp[0] += "</td>";
                resp[0] += "</tr>";
            }
            rs.close();
            stmt.close();
            return resp;
            
        } catch(SQLException e) {
            resp[0] = "Erro:" + e.toString();
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
    public String[] getConsumos(String pesquisa, String campo, String ordem, int numPag, int qtdeporpagina, int tipo, String cod_empresa) {
        String resp[] = {"",""};
        String sql = "";
        ResultSet rs = null;
        
        //Limpa espaços em branco antes e depois da pesquisa
        pesquisa = pesquisa.trim();
        
        sql += "SELECT * FROM vac_consumos ";
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            //Consulta exata
            if(tipo == 1)
                sql += "WHERE " + campo + "='" + pesquisa + "'";
            //Começando com o valor
            else if(tipo == 2)
                sql += "WHERE " + campo + " LIKE '" + pesquisa + "%'";
            //Com o valor no meio
            else if(tipo == 3)
                sql += "WHERE " + campo + " LIKE '%" + pesquisa + "%'";
            
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
            resp[1] = Util.criaPaginacao("consumo.jsp", numPag, qtdeporpagina, numRows);
            
            //Limita para uma quantidade de registros
            sql += " LIMIT " + ((numPag-1)*qtdeporpagina) + "," + qtdeporpagina;
            
            //Executa a pesquisa novamente com o limitador
            rs = stmt.executeQuery(sql);
            
            //Cria looping com a resposta
            while(rs.next()) {
                resp[0] += "<tr onClick=go('consumo.jsp?cod=" + rs.getString("cod_consumo") + "') onMouseOver='trocaCor(this,1);' onMouseOut='trocaCor(this,2);'>";
                resp[0] += "<td class='tdLight'>" + rs.getString("descricao") + "&nbsp;</td>\n";
                resp[0] += "<td width='80' class='tdLight'>" + Util.formataData(rs.getString("data")) + "&nbsp;</td>\n";
                resp[0] += "<td width='80' class='tdLight'>" + Util.formatCurrency(rs.getString("valor")) + "&nbsp;</td>\n";
                resp[0] += "</tr>";
            }
            
            //Se não retornar resposta, montar mensagem de não encontrado
            if(resp[0].equals("")) {
                resp[0] += "<tr>";
                resp[0] += "<td width='600' class='tdLight'>";
                resp[0] += "Nenhum registro encontrado para a pesquisa";
                resp[0] += "</td>";
                resp[0] += "</tr>";
            }
            rs.close();
            stmt.close();
            return resp;
            
        } catch(SQLException e) {
            resp[0] = "Erro:" + e.toString();
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
    public String[] getHistVacinas(String pesquisa, String campo, String ordem, int numPag, int qtdeporpagina, int tipo, String cod_empresa) {
        String resp[] = {"",""};
        String sql = "";
        ResultSet rs = null;
        
        //Limpa espaços em branco antes e depois da pesquisa
        pesquisa = pesquisa.trim();
        
        //Se a pesquisa estiver em branco, não pesquisar
        if(Util.isNull(pesquisa)) {
            //Cria paginação das páginas
            resp[1] = Util.criaPaginacao("hist_vacinas.jsp", numPag, qtdeporpagina, 0);
            resp[0] += "<tr>";
            resp[0] += "<td colspan='6' width='600' class='tdLight'>";
            resp[0] += "Nenhum registro encontrado";
            resp[0] += "</td>";
            resp[0] += "</tr>";
            return resp;
        }
        
        sql += "SELECT paciente.nome, vac_vacinas.descricao, vac_hist_vacinas.cod_hist_vacina ";
        sql += "FROM (vac_hist_vacinas INNER JOIN vac_vacinas ";
        sql += "ON vac_hist_vacinas.cod_vacina = vac_vacinas.cod_vacina) INNER JOIN paciente ";
        sql += "ON vac_hist_vacinas.codcli = paciente.codcli ";

        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            //Consulta exata
            if(tipo == 1)
                sql += "WHERE " + campo + "='" + pesquisa + "'";
            //Começando com o valor
            else if(tipo == 2)
                sql += "WHERE " + campo + " LIKE '" + pesquisa + "%'";
            //Com o valor no meio
            else if(tipo == 3)
                sql += "WHERE " + campo + " LIKE '%" + pesquisa + "%'";
            
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
            resp[1] = Util.criaPaginacao("hist_vacinas.jsp", numPag, qtdeporpagina, numRows);
            
            //Limita para uma quantidade de registros
            sql += " LIMIT " + ((numPag-1)*qtdeporpagina) + "," + qtdeporpagina;
            
            //Executa a pesquisa novamente com o limitador
            rs = stmt.executeQuery(sql);
            
            //Cria looping com a resposta
            while(rs.next()) {
                resp[0] += "<tr onClick=go('hist_vacinas.jsp?cod=" + rs.getString("cod_hist_vacina") + "') onMouseOver='trocaCor(this,1);' onMouseOut='trocaCor(this,2);'>";
                resp[0] += "   <td class='tdLight'>" + rs.getString("nome") + "&nbsp;</td>\n";
                resp[0] += "   <td width='250' class='tdLight'>" + rs.getString("descricao") + "&nbsp;</td>\n";
                resp[0] += "</tr>";
            }
            
            //Se não retornar resposta, montar mensagem de não encontrado
            if(resp[0].equals("")) {
                resp[0] += "<tr>";
                resp[0] += "<td colspan='3' width='600' class='tdLight'>";
                resp[0] += "Nenhum registro encontrado para a pesquisa";
                resp[0] += "</td>";
                resp[0] += "</tr>";
            }
            rs.close();
            stmt.close();
            return resp;
            
        } catch(SQLException e) {
            resp[0] = "Erro:" + e.toString();
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
    public String[] getHistVacinas2(String pesquisa, String campo, String ordem, int numPag, int qtdeporpagina, int tipo, String cod_empresa) {
        String resp[] = {"",""};
        String sql = "";
        ResultSet rs = null;
        
        //Limpa espaços em branco antes e depois da pesquisa
        pesquisa = pesquisa.trim();
        
        sql += "SELECT paciente.nome, vac_vacinas.descricao, vac_hist_vacinas.cod_hist_vacina, ";
        sql += "vac_hist_vacinas.data_recebimento FROM (vac_hist_vacinas INNER JOIN vac_vacinas ";
        sql += "ON vac_hist_vacinas.cod_vacina = vac_vacinas.cod_vacina) INNER JOIN paciente ";
        sql += "ON vac_hist_vacinas.codcli = paciente.codcli ";

        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            //Consulta exata
            if(tipo == 1)
                sql += "WHERE " + campo + "='" + pesquisa + "'";
            //Começando com o valor
            else if(tipo == 2)
                sql += "WHERE " + campo + " LIKE '" + pesquisa + "%'";
            //Com o valor no meio
            else if(tipo == 3)
                sql += "WHERE " + campo + " LIKE '%" + pesquisa + "%'";
            
            //Filtra as vacinas que já foram aplicadas
            sql+=" AND aplicador IS NULL";
            
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
            resp[1] = Util.criaPaginacao("hist_vacinas2.jsp", numPag, qtdeporpagina, numRows);
            
            //Limita para uma quantidade de registros
            sql += " LIMIT " + ((numPag-1)*qtdeporpagina) + "," + qtdeporpagina;
            
            //Executa a pesquisa novamente com o limitador
            rs = stmt.executeQuery(sql);
            
            //Cria looping com a resposta
            while(rs.next()) {
                resp[0] += "<tr onClick=go('hist_vacinas2.jsp?cod=" + rs.getString("cod_hist_vacina") + "') onMouseOver='trocaCor(this,1);' onMouseOut='trocaCor(this,2);'>";
                resp[0] += "   <td class='tdLight'>" + rs.getString("nome") + "&nbsp;</td>\n";
                resp[0] += "   <td width='250' class='tdLight'>" + rs.getString("descricao") + "&nbsp;</td>\n";
                resp[0] += "   <td width='80' class='tdLight'>" + Util.formataData(rs.getString("data_recebimento")) + "&nbsp;</td>\n";
                resp[0] += "</tr>";
            }
            
            //Se não retornar resposta, montar mensagem de não encontrado
            if(resp[0].equals("")) {
                resp[0] += "<tr>";
                resp[0] += "<td colspan='3' width='600' class='tdLight'>";
                resp[0] += "Nenhum registro encontrado para a pesquisa";
                resp[0] += "</td>";
                resp[0] += "</tr>";
            }
            rs.close();
            stmt.close();
            return resp;
            
        } catch(SQLException e) {
            resp[0] = "Erro:" + e.toString();
            return resp;
        }
    }
    
    //Pega as previsões
    public String[] getPrevisaoVacinas(String pesquisa, String campo, String ordem, int numPag, int qtdeporpagina, int tipo, String cod_empresa) {
        String resp[] = {"",""};
        String sql = "";
        ResultSet rs = null;
        
        if(ordem==null || ordem.equals("")) ordem = "paciente.nome";
        
        //Limpa espaços em branco antes e depois da pesquisa
        pesquisa = pesquisa.trim();
        
        sql += "SELECT paciente.nome, vac_vacinas.descricao, vac_prev_vacinas.data_sugestao, ";
        sql += "vac_prev_vacinas.cod_prev_vacina FROM paciente, vac_vacinas, vac_prev_vacinas " +
                "WHERE ";
        sql += " vac_prev_vacinas.cod_cliente = paciente.codcli AND vac_prev_vacinas.cod_vacina = vac_vacinas.cod_vacina";

        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            //Consulta exata
            if(tipo == 1)
                sql += " AND " + campo + "='" + pesquisa + "'";
            //Começando com o valor
            else if(tipo == 2)
                sql += " AND " + campo + " LIKE '" + pesquisa + "%'";
            //Com o valor no meio
            else if(tipo == 3)
                sql += " AND " + campo + " LIKE '%" + pesquisa + "%'";
            
            //Filtra somente previsões de hoje em diante
            sql += " AND data_sugestao >='" + Util.formataDataInvertida(Util.getData()) + "'";
            
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
            resp[1] = Util.criaPaginacao("previsaovacinas.jsp", numPag, qtdeporpagina, numRows);
            
            //Limita para uma quantidade de registros
            sql += " LIMIT " + ((numPag-1)*qtdeporpagina) + "," + qtdeporpagina;
            
            //Executa a pesquisa novamente com o limitador
            rs = stmt.executeQuery(sql);
            
            //Cria looping com a resposta
            while(rs.next()) {
                resp[0] += "<tr onClick=go('previsaovacinas.jsp?cod=" + rs.getString("cod_prev_vacina") + "') onMouseOver='trocaCor(this,1);' onMouseOut='trocaCor(this,2);'>";
                resp[0] += "   <td class='tdLight'>" + rs.getString("nome") + "&nbsp;</td>\n";
                resp[0] += "   <td width='250' class='tdLight'>" + rs.getString("descricao") + "&nbsp;</td>\n";
                resp[0] += "   <td width='80' class='tdLight'>" + Util.formataData(rs.getString("data_sugestao")) + "&nbsp;</td>\n";
                resp[0] += "</tr>";
            }
            
            //Se não retornar resposta, montar mensagem de não encontrado
            if(resp[0].equals("")) {
                resp[0] += "<tr>";
                resp[0] += "<td colspan='3' width='600' class='tdLight'>";
                resp[0] += "Nenhum registro encontrado para a pesquisa";
                resp[0] += "</td>";
                resp[0] += "</tr>";
            }
            rs.close();
            stmt.close();
            return resp;
            
        } catch(SQLException e) {
            resp[0] = "Erro:" + e.toString();
            return resp;
        }
    }

       /* pesquisa: valor a ser pesquisado
        * ordem: ordem de resposta dos campos
        * numPag: número da página selecionada (paginação)
        * qtdeporpagina: quantidade de registros por página
        * tipo: tipo de pesquisa (exata, substring)
        * cod_empresa: código da empresa logada
        */
    public String[] getValorVacinas(String pesquisa, String ordem, int numPag, int qtdeporpagina, int tipo, String cod_empresa) {
        String resp[] = {"",""};
        String sql = "";
        ResultSet rs = null;
        
        //Limpa espaços em branco antes e depois da pesquisa
        pesquisa = pesquisa.trim();
        
        sql += "SELECT vac_vacinas.descricao, convenio.descr_convenio, vac_valor_vacinas.valor, ";
        sql += "vac_valor_vacinas.cod_valor_vacina ";
        sql += "FROM (vac_valor_vacinas INNER JOIN vac_vacinas ON vac_valor_vacinas.cod_vacina = ";
        sql += "vac_vacinas.cod_vacina) INNER JOIN convenio ON vac_valor_vacinas.cod_convenio = ";
        sql += "convenio.cod_convenio ";

        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            //Consulta exata
            if(tipo == 1)
                sql += "WHERE descr_convenio='" + pesquisa + "' OR descricao='" + pesquisa + "' ";
            //Começando com o valor
            else if(tipo == 2)
                sql += "WHERE descr_convenio LIKE '" + pesquisa + "%' OR descricao LIKE '" + pesquisa + "%' ";
            //Com o valor no meio
            else if(tipo == 3)
                sql += "WHERE descr_convenio LIKE '%" + pesquisa + "%' OR descricao LIKE '%" + pesquisa + "%'";
            
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
            resp[1] = Util.criaPaginacao("valorvacinas.jsp", numPag, qtdeporpagina, numRows);
            
            //Limita para uma quantidade de registros
            sql += " LIMIT " + ((numPag-1)*qtdeporpagina) + "," + qtdeporpagina;
            
            //Executa a pesquisa novamente com o limitador
            rs = stmt.executeQuery(sql);
            
            //Cria looping com a resposta
            while(rs.next()) {
                resp[0] += "<tr onClick=go('valorvacinas.jsp?cod=" + rs.getString("cod_valor_vacina") + "') onMouseOver='trocaCor(this,1);' onMouseOut='trocaCor(this,2);'>";
                resp[0] += "  <td width='250' class='tdLight'>" + rs.getString("descricao") + "&nbsp;</td>\n";
                resp[0] += "  <td class='tdLight'>" + rs.getString("descr_convenio") + "&nbsp;</td>\n";
                resp[0] += "  <td width='50' class='tdLight'>" + Util.formatCurrency(rs.getString("valor")) + "&nbsp;</td>\n";
                resp[0] += "</tr>";
            }
            
            //Se não retornar resposta, montar mensagem de não encontrado
            if(resp[0].equals("")) {
                resp[0] += "<tr>";
                resp[0] += "<td colspan='3' width='600' class='tdLight'>";
                resp[0] += "Nenhum registro encontrado para a pesquisa";
                resp[0] += "</td>";
                resp[0] += "</tr>";
            }
            rs.close();
            stmt.close();
            return resp;
            
        } catch(SQLException e) {
            resp[0] = "Erro:" + e.toString();
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
            while(rs.next()) {
                resp += "<option value='" + rs.getString("prof_reg") + "'>" + rs.getString("nome") + "</option>\n";
            }
            
            rs.close();
            stmt.close();
            
            return resp;
            
        } catch(SQLException e) {
            return "Erro:" + e.toString();
        }
    }
 
    //Recebe o código da vacina, o tipo de pagto e o intervalo (de até) para devolver o total recebido e a quantidade
    public String[] getTotalFaturado(String cod_vacina, int tipo_pagto, String de, String ate) {
        String resp[] = {"",""};
        String sql = "";
        ResultSet rs = null;
        
        try {
            //Cria statement para enviar sql
            Statement stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            sql += "SELECT SUM(vac_pagamentos.valor) AS soma, COUNT(vac_pagamentos.valor) AS total ";
            sql += "FROM vac_pagamentos INNER JOIN vac_hist_vacinas ";
            sql += "ON vac_pagamentos.cod_hist_vacina = vac_hist_vacinas.cod_hist_vacina ";
            sql += "WHERE vac_pagamentos.data BETWEEN '" + Util.formataDataInvertida(de);
            sql += "' AND '" + Util.formataDataInvertida(ate) + "' AND vac_pagamentos.tipo_pagto=" + tipo_pagto;
            sql += "  AND cod_vacina=" + cod_vacina;
            
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            //Pega a resposta
            if(rs.next()) {
                resp[0] = rs.getString("soma");
                resp[1] = rs.getString("total");
                
                //Se vier nulo, colocar zero
                if(Util.isNull(resp[0])) resp[0] = "0";
                if(Util.isNull(resp[1])) resp[1] = "0";
            }
            
            rs.close();
            stmt.close();
            
            return resp;
            
        } catch(SQLException e) {
            resp[0] = "ERRO: " + e.toString() + " SQL: " + sql; 
            return resp;
        }
    }


    //Recebe o código da vacina e o intervalo (de até) para devolver a quantidade de aplicações
    public String getQtdeFaturado(String cod_vacina, String de, String ate) {
        String resp = "0";
        String sql = "";
        ResultSet rs = null;
        
        try {
            //Cria statement para enviar sql
            Statement stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            sql += "SELECT COUNT(*) AS total ";
            sql += "FROM vac_hist_vacinas ";
            sql += "WHERE data_recebimento BETWEEN '" + Util.formataDataInvertida(de);
            sql += "' AND '" + Util.formataDataInvertida(ate) + "' ";
            sql += "  AND cod_vacina=" + cod_vacina;
            
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            //Pega a resposta
            if(rs.next()) {
                resp = rs.getString("total");
                
                //Se vier nulo, colocar zero
                if(Util.isNull(resp)) resp = "0";
            }
            
            rs.close();
            stmt.close();
            
            return resp;
            
        } catch(SQLException e) {
            resp = "ERRO: " + e.toString() + " SQL: " + sql; 
            return resp;
        }
    }

    //Monta relatório de vacinas aplicadas
    public String getRelFechamentoPeriodo(String de, String ate, String cod_empresa) {
        String resp = "";
        String sql = "", cod_vacina = "";
        String sub[];
        String subtotvacinas = "";
        float somavalor = 0;
        int somatotal = 0;
        float somavalorfinal[] = new float[tipo_pagto.length+1];
        int somatotalfinal[] = new int[tipo_pagto.length+1];
        ResultSet rs = null;
        int i;
        boolean achou = false;
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            sql += "SELECT vac_vacinas.descricao, vac_hist_vacinas.cod_vacina ";
            sql += "FROM (vac_vacinas INNER JOIN vac_hist_vacinas ON ";
            sql += "vac_vacinas.cod_vacina = vac_hist_vacinas.cod_vacina) ";
            sql += "INNER JOIN vac_pagamentos ON vac_hist_vacinas.cod_hist_vacina = vac_pagamentos.cod_hist_vacina ";
            sql += "WHERE vac_pagamentos.data BETWEEN '" + Util.formataDataInvertida(de) + "' AND '";
            sql += Util.formataDataInvertida(ate) + "' AND vac_vacinas.cod_empresa=" + cod_empresa;
            sql += " GROUP BY vac_vacinas.descricao, vac_hist_vacinas.cod_vacina ";
            sql += "ORDER BY descricao";
            
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);

            //Monta Cabeçalho
            resp += " <tr>\n";
            resp += "  <td class='tblrel' style='background-color:#CCCCCC'><b>Vacina</b></td>";
            for(i=0; i<tipo_pagto.length; i++) {
                resp += " <td style='background-color:#CCCCCC' class='tblrel'><b>" + tipo_pagto[i] + "</b></td>\n";
            }
            resp += "  <td style='background-color:#CCCCCC' class='tblrel'><b>Total</b></td>\n";
            resp += " </tr>\n";
            
            //Cria looping com a resposta
            while(rs.next()) {
                //Achou pelo menos um registro
                achou = true;
                
                //Pega a vacina
                cod_vacina = rs.getString("cod_vacina");
                
                resp += "<tr>\n";
                resp += "<td class='tblrel'>" + rs.getString("descricao") + "</td>";
                somavalor = 0;
                somatotal = 0;
                
                //Varre todas as posições
                for(i=0; i<tipo_pagto.length; i++) {
                    sub = getTotalFaturado(cod_vacina, i+1, de, ate);
                    
                    try {
                        //Acumula os valores das colunas para totalizar na horizontal
                        somavalor += Float.parseFloat(sub[0]);
                        somatotal += Float.parseFloat(sub[1]);

                        //Acumula valores na linhas para totalizar vertical
                        somavalorfinal[i] += Float.parseFloat(sub[0]);
                        somatotalfinal[i] += Float.parseFloat(sub[1]);
                    }
                    catch(Exception e) {
                        return "ERRO: " + e.toString() + " 1-" + sub[0] + " 2-" + sub[1];
                    }
                    
                    resp += "<td class='tblrel'>" + Util.formatCurrency(sub[0]) + " (" + sub[1] + ")" + "</td>";
                }

                //Acumula o finalizador da horizontal
                somavalorfinal[i] += somavalor;
                somatotalfinal[i] += somatotal;

                //Calcula o total de vacinas aplicadas
                subtotvacinas = getQtdeFaturado(cod_vacina, de, ate);
                
                //resp += "<td class='tblrel'>" + Util.formatCurrency(somavalor+"")+ "</td>\n";
                resp += "<td class='tblrel'>" + Util.formatCurrency(somavalor+"") + " (" + subtotvacinas + ")" + "</td>\n";
                resp += "</tr>\n"; 
            }
            
            //Se não achou nenhum registro
            if(!achou) {
                resp += "<tr>\n";
                resp += "<td colspan='" + (tipo_pagto.length+2) + "' class='tblrel' align='center'>Nenhum registro encontrado no período</td>\n";
                resp += "</tr>";
            }

            //Finaliza as somas
            resp += "<tr>\n";
            resp += "<td class='tblrel' style='background-color:#CCCCCC' align='right'><b>TOTAIS:&nbsp;&nbsp;&nbsp;&nbsp;</b></td>\n";

            //Varre todas as posições
            for(i=0; i<tipo_pagto.length; i++) {
               resp += "  <td class='tblrel' style='background-color:#CCCCCC'><b>" + Util.formatCurrency(somavalorfinal[i]+"") + " (" + somatotalfinal[i] + ")</b></td>";
            }
            resp += "  <td class='tblrel' style='background-color:#CCCCCC'><b>" + Util.formatCurrency(somavalorfinal[i]+"") + "</b></td>";
            resp += "</tr>";
            
            //Acumula despesas do período
            resp += getDespesas(de, ate, cod_empresa);
            
            rs.close();
            stmt.close();
            
            return resp;
            
        } catch(SQLException e) {
            return "ERRO:" + e.toString() + " SQL: " + sql;
        }
    }
    
   //Pega as despesas cadastradas no período
    public String getDespesas(String de, String ate, String cod_empresa) {
        String resp = "";
        String sql = "";
        ResultSet rs = null;
        float total = 0;
        boolean achou = false;
        
        try {
            //Cria statement para enviar sql
            Statement stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            sql += "SELECT * FROM vac_consumos ";
            sql += " WHERE DATA BETWEEN '" + Util.formataDataInvertida(de);
            sql += "' AND '" + Util.formataDataInvertida(ate) + "' AND cod_empresa=" + cod_empresa;
            sql += " ORDER BY DATA, descricao";
            
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);

            //Abre tabela dentro do TD 
            resp += "<tr>\n";
            resp += "<td colspan='" + (tipo_pagto.length+2) + "'>&nbsp;</td>\n";
            resp += "</tr>\n";

            resp += "<tr>\n";
            resp += "<td colspan='" + (tipo_pagto.length+2) + "'>";
            resp += "<table width='100%' cellspacing='0' cellpadding='0'>\n";

            //Cabeçalho
            resp += "<tr>\n";
            resp += " <td width='90' class='tblrel' style='background-color:#CCCCCC'><b>Data</b></td>\n";
            resp += " <td class='tblrel' style='background-color:#CCCCCC'><b>Descricao</b></td>\n";
            resp += " <td width='200' class='tblrel' style='background-color:#CCCCCC'><b>Valor</b></td>\n";
            resp += "</tr>\n";
            
            //Pega a resposta
            while(rs.next()) {
                //Acumula o valor
                total += Float.parseFloat(rs.getString("valor"));
                
                resp += "<tr>\n";
                resp += " <td class='tblrel'>" + Util.formataData(rs.getString("DATA")) + "</td>\n";
                resp += " <td class='tblrel'>" + rs.getString("descricao") + "</td>\n";
                resp += " <td class='tblrel'>" + Util.formatCurrency(rs.getString("valor")) + "</td>\n";
                resp += "</tr>\n";
                
                //Se achou algum registro
                achou = true;
            }
            
            //Se não achou nenhum registro
            if(!achou) {
                resp += "<tr>\n";
                resp += "<td colspan='3' class='tblrel' align='center'>Nenhum registro encontrado no período</td>\n";
                resp += "</tr>";
            }
                
            //Linha finalizadora
            resp += "<tr>\n";
            resp += "<td colspan='2' class='tblrel' style='background-color:#cccccc' align='right'><b>TOTAL:  </b></td>\n";
            resp += "<td class='tblrel' style='background-color:#cccccc'><b>" + Util.formatCurrency(total+"") + "</b></td>\n";
            resp += "</tr>";
            
            //Fim da tabela do TD
            resp += "</table>\n";
            resp += "</td>\n";
            resp += "</tr>";
            
            rs.close();
            stmt.close();
            
            return resp;
            
        } catch(SQLException e) {
            resp = "ERRO: " + e.toString() + " SQL: " + sql; 
            return resp;
        }
    }
    

    public String getVacinas(String cod_empresa) {
        String sql  = "SELECT cod_vacina, descricao FROM vac_vacinas WHERE cod_empresa=";
        sql += cod_empresa + " AND ativo='S' ORDER BY descricao";
        String resp = "";
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            ResultSet rs = null;
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);

            //Estoque
            Estoque es = new Estoque();
            int estoques[] = new int[2];
            
            //Cria looping com a resposta
            while(rs.next()) {
                //Captura q quantidade em estoque e o estoque mínimo
                estoques = es.getEstoqueVacina(rs.getString("cod_vacina"));
                
                //Se está menor que estoque mínimo, mudar a cor
                if(estoques[0] < estoques[1])
                    resp += "<option style='color:red' value='" + rs.getString("cod_vacina") + "'>" + rs.getString("descricao") + "</option>\n";
                else
                    resp += "<option value='" + rs.getString("cod_vacina") + "'>" + rs.getString("descricao") + "</option>\n";
            }
            rs.close();
            stmt.close();
            
            return resp;
        } catch(SQLException e) {
            return e.toString();
        }
    }

    //Recupera quantas doses o paciente tomou de uma vacina
    public String getQtdeDoses(String cod_vacina, String codcli) {
        String sql  = "";
        String resp = "";
        
        try {
            sql += "SELECT COUNT(*) AS total FROM vac_vacinas WHERE cod_vacina=" + cod_vacina;
            sql += " AND codcli=" + codcli;

            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            ResultSet rs = null;
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            //Pega a resposta
            if(rs.next()) {
                resp = rs.getString("total");
            }
            rs.close();
            stmt.close();
            
            return resp;
        } catch(SQLException e) {
            return "ERRO: " + e.toString() + " SQL: " + sql;
        }
    }

    //Recupera as doses de uma vacina
    public String getDoses(String cod_vacina) {
        String sql  = "SELECT * FROM vac_dose WHERE cod_vacina=" + cod_vacina + " ORDER BY dose";
        String resp = "";
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            ResultSet rs = null;
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            //Cria looping com a resposta
            while(rs.next()) {
                resp += "<tr>\n";
                resp += " <td class='tdLight' align='center'>" + rs.getString("dose") + "</td>\n";
                resp += " <td class='tdLight' align='center'>" + rs.getString("descDose") + "</td>\n";
                resp += " <td class='tdLight' align='center'><a title='Excluir Dose' href='Javascript:excluirdose(" + rs.getString("cod_dose") + ")'><img src='images/delete.gif' border='0'></a></td>\n";
                resp += "</tr>\n";
            }
            rs.close();
            stmt.close();
            
            return resp;
        } catch(SQLException e) {
            return "ERRO: " + e.toString() + " SQL: " + sql;
        }
    }
      
    //Recupera os pagamentos de um lançamento de vacina
    public String getPagamentos(String cod_hist_vacina) {
        String sql  = "";
        String resp = "";
        float soma = 0;
        
        //Se não veio o cód. da história, ainda não escolheu
        if(Util.isNull(cod_hist_vacina)) {
            resp += "<tr>\n";
            resp += " <td class='tdMedium' colspan='2' align='right'>Total: </td>\n";
            resp += " <td colspan='3' class='tdMedium'>" + Util.formatCurrency("0") + "<input type='hidden' name='6' id='total' value='" + soma + "'></td>\n";
            resp += "</tr>\n";

            return resp;
        }
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            ResultSet rs = null;
            
            //Executa a pesquisa
            sql = "SELECT * FROM vac_pagamentos WHERE cod_hist_vacina=" + cod_hist_vacina;
            rs = stmt.executeQuery(sql);
            
            //Cria looping com a resposta
            while(rs.next()) {
                resp += "<tr>\n";
                resp += " <td class='tdLight'>" + Util.formataData(rs.getString("data")) + "</td>\n";
                resp += " <td class='tdLight'>" + tipo_pagto[rs.getInt("tipo_pagto")-1] + "</td>\n";
                resp += " <td class='tdLight'>" + Util.formatCurrency(rs.getString("valor")) + "</td>\n";
                resp += " <td class='tdLight' align='center'>" + rs.getString("pago") + "</td>\n";
                resp += " <td class='tdLight' align='center'><a title='Excluir Pagamento' href='Javascript:excluirpagto(" + rs.getString("cod_pagamento") + ")'><img src='images/delete.gif' border='0'></a></td>\n";
                resp += "</tr>\n";
                
                //Acumula valor
                soma += rs.getFloat("valor");
            }
            
            resp += "<tr>\n";
            resp += " <td class='tdMedium' colspan='2' align='right'>Total: </td>\n";
            resp += " <td colspan='3' class='tdMedium'>" + Util.formatCurrency(soma+"") + "<input type='hidden' name='6' id='total' value='" + soma + "'></td>\n";
            resp += "</tr>\n";
            
            rs.close();
            stmt.close();
            
            return resp;
        } catch(SQLException e) {
            return "ERRO: " + e.toString() + " SQL: " + sql;
        }
    }

    //Recupera os lotes de uma vacina
    public String getLotesVacina(String cod_saida, boolean consulta) {
        //Se não escolheu vacina ainda
        if(Util.isNull(cod_saida))
            return "<select name='lote' id='lote' class='caixa' style='width:95%'><option value=''></option></select>";
        
        if(!consulta) return getLotesVacina("0");
        
        String sql  = "";
        String resp = "";
        
        sql  = "SELECT vac_laboratorios.laboratorio, vac_estoque.cod_estoque, ";
        sql += "vac_estoque.lote, vac_estoque.validade ";
        sql += "FROM vac_laboratorios, vac_estoque, vac_saidas ";
        sql += "WHERE vac_saidas.cod_saida = " + cod_saida + " AND vac_estoque.ativo='S' ";
        sql += "AND vac_saidas.lote=vac_estoque.cod_estoque AND ";
        sql += "vac_estoque.cod_laboratorio=vac_laboratorios.cod_laboratorio";
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            ResultSet rs = null;
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
        
            resp += "<select name='lote' id='lote' class='caixa' style='width:95%' "+((consulta)?"disabled":"")+" >";
            boolean achou = false;
            
            //Cria looping com a resposta
            if(rs.next()) {
                resp += "<option value='" + rs.getString("cod_estoque") + "'>" + rs.getString("lote") + " - " + rs.getString("laboratorio") + " - Val.: " + Util.formataData(rs.getString("validade")) + " (" + getQuantidadeEstoque(rs.getString("cod_estoque"),null) + ")</option>\n";
                achou = true;
            }

            if(!achou) //Se não achou nenhum item no estoque
                resp += "<option value=''>Nenhum item no estoque foi encontrado</option>\n";

            resp += "</select>";
            
            rs.close();
        stmt.close();
            
            return resp;
        } catch(SQLException e) {
            return "ERRO: " + e.toString() + " SQL: " + sql;
        }
    }

    //Recupera os lotes de uma vacina
    public String getLotesVacina(String cod_vacina) {

        //Se não escolheu vacina ainda
        if(Util.isNull(cod_vacina))
            return "<select name='lote' id='lote' class='caixa' style='width:95%'><option value=''></option></select>";
        
        String sql  = "SELECT vac_laboratorios.laboratorio, vac_estoque.cod_estoque, ";
        sql += "vac_estoque.lote, vac_estoque.validade ";
        sql += "FROM vac_estoque INNER JOIN vac_laboratorios ON vac_estoque.cod_laboratorio = ";
        sql += "vac_laboratorios.cod_laboratorio ";
        sql += "WHERE vac_estoque.cod_vacina=" + cod_vacina + " AND vac_estoque.ativo='S' ORDER BY laboratorio";

        String resp = "";
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            ResultSet rs = null;
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
        
            resp += "<select name='lote' id='lote' class='caixa' style='width:95%'>";
            
            boolean achou = false;
            String estoque = "";
            
            //Cria looping com a resposta
            while(rs.next()) {
                estoque = getQuantidadeEstoque(rs.getString("cod_estoque"),null);
                if(Integer.parseInt(estoque) > 0) {
                    resp += "<option value='" + rs.getString("cod_estoque") + "'>" + rs.getString("lote") + " - " + rs.getString("laboratorio") + " - Val.: " + Util.formataData(rs.getString("validade")) + " (" + estoque + ")</option>\n";
                    achou = true;
                }
            }

            if(!achou) //Se não achou nenhum item no estoque
                resp += "<option value=''>Nenhum item no estoque foi encontrado</option>\n";

            resp += "</select>";
            
            rs.close();
        stmt.close();
            
            return resp;
        } catch(SQLException e) {
            return "ERRO: " + e.toString() + " SQL: " + sql;
        }
    }


    //Verifica se o estoque está em algum lançamento ou saída
    //retorna 0 se não existir
    //retorna 1 se estiver em lançamento
    //retorna 2 se estiver em saída
    public String verificaLancamentoEstoque(String cod_estoque) {
        
        String sql  = "";
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);

            ResultSet rs = null;

            //Verifica se existe lançamento
            sql = "SELECT * FROM vac_hist_vacinas WHERE cod_estoque=" + cod_estoque;
            rs = stmt.executeQuery(sql);
            if(rs.next()) return "1";
            
            //Verifica se existe saída
            sql = "SELECT * FROM vac_saidas WHERE lote='" + cod_estoque + "'";
            rs = stmt.executeQuery(sql);
            if(rs.next()) return "2";
            
            rs.close();
            stmt.close();
            
            return "0";
        } catch(SQLException e) {
            return "ERRO: " + e.toString() + " SQL: " + sql;
        }
    }

    //Recupera as doses de uma vacina
    public String getDosesVacina(String cod_vacina) {

        //Se não escolheu vacina ainda
        if(Util.isNull(cod_vacina))
            return "<select name='dose' id='dose' class='caixa' style='width:95%'><option value=''></option></select>";
        
        String sql  = "SELECT * FROM vac_dose WHERE cod_vacina=" + cod_vacina;

        String resp = "";
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            ResultSet rs = null;
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
        
            resp += "<select name='dose' id='dose' class='caixa' style='width:95%'>";
            boolean achou = false;
            
            //Cria looping com a resposta
            while(rs.next()) {
                resp += "<option value='" + rs.getString("dose") + "'>" + rs.getString("dose") + " (" + rs.getString("descDose") + ")</option>\n";
                achou = true;
            }

            if(!achou) //Se não achou nenhum item no estoque
                resp += "<option value=''>Nenhuma dose cadastrada</option>\n";

            resp += "</select>";
            
            rs.close();
        stmt.close();
            
            return resp;
        } catch(SQLException e) {
            return "ERRO: " + e.toString() + " SQL: " + sql;
        }
    }

    //Recupera o valor de uma vacina para um convênio
    public String getValorVacinaConvenio(String cod_vacina, String cod_convenio) {
        String sql = "";
        String resp = "";

        //Se não escolheu vacina ainda
        if(!Util.isNull(cod_vacina) && !Util.isNull(cod_convenio)) {
            sql  = "SELECT valor FROM vac_valor_vacinas WHERE cod_vacina=" + cod_vacina;
            sql += " AND cod_convenio=" + cod_convenio;
            try {
                //Cria statement para enviar sql
                stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                        ResultSet.CONCUR_READ_ONLY);

                ResultSet rs = null;
                //Executa a pesquisa
                rs = stmt.executeQuery(sql);

                //Se achou
                if(rs.next()) {
                    resp = rs.getString("valor");
                }

                rs.close();
                stmt.close();

                return resp;
            } catch(SQLException e) {
                return "ERRO: " + e.toString() + " SQL: " + sql;
            }
        }
        
        return resp;
    }

    //Insere a dose na vacina
    public String insereDose(String dose, String descDose, String cod_vacina) {
        
        if(Util.isNull(dose) || Util.isNull(descDose)) return "Sem código";
        
        String prox = new Banco().getNext("vac_dose", "cod_dose");
        String sql  = "INSERT INTO vac_dose(cod_dose, cod_vacina, dose, mes, descDose) VALUES(";
        sql += prox + "," + cod_vacina + "," + dose + ",0 ,'" + descDose + "')";

        //Retorna o resultado do script
        return new Banco().executaSQL(sql);
    }
    
    //Insere um pagamento no histórico de vacinas
    public String inserePagamento(String cod_hist_vacina, String data, String valor, String tipo_pagto, String pago) {
        
        //Se algum item veio nulo, não gravar
        if(Util.isNull(cod_hist_vacina) || Util.isNull(data)|| Util.isNull(valor)|| Util.isNull(tipo_pagto)) return "Sem código";
        
        //Se não escolheu o pago, deixar como N
        if(Util.isNull(pago)) pago = "N";
        
        String prox = new Banco().getNext("vac_pagamentos", "cod_pagamento");
        String sql  = "INSERT INTO vac_pagamentos(cod_pagamento, cod_hist_vacina, data, valor, tipo_pagto, pago) VALUES(";
        sql += prox + "," + cod_hist_vacina + ",'" + Util.formataDataInvertida(data) + "',";
        sql += valor + "," + tipo_pagto + ",'" + pago + "')";

        //Retorna o resultado do script
        return new Banco().executaSQL(sql);
    }

    public String excluirDose(String cod_dose) {
        
        //Se não veio nada, não fazer
        if(Util.isNull(cod_dose)) return "";
        
        String sql = "DELETE FROM vac_dose WHERE cod_dose=" + cod_dose;
        return new Banco().executaSQL(sql);
    }

    public String excluirPagamento(String cod_pagamento) {
        
        //Se não veio nada, não fazer
        if(Util.isNull(cod_pagamento)) return "";
        
        String sql = "DELETE FROM vac_pagamentos WHERE cod_pagamento=" + cod_pagamento;
        return new Banco().executaSQL(sql);
    }
    
    //Retorna os convênios de um paciente
    public String getConvenios(String codcli) {
        String resp = "";
        String sql = "";
        ResultSet rs = null;
        boolean temparticular = false;
        
        //Se não veio cod. de convênio, retornar vazio
        if(Util.isNull(codcli)) return "";
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            sql += "SELECT convenio.cod_convenio, convenio.descr_convenio ";
            sql += "FROM convenio INNER JOIN paciente_convenio ON ";
            sql += "convenio.cod_convenio = paciente_convenio.cod_convenio ";
            sql += "WHERE paciente_convenio.codcli=" + codcli + " ORDER BY convenio.descr_convenio";
            
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            //Cria looping com a resposta
            while(rs.next()) {
                //Se tem particular registrado (cód. -1), não incluir na mão
                if(rs.getString("cod_convenio") != null && rs.getString("cod_convenio").equals("-1")) temparticular = true;
                
                resp += "<option value='" + rs.getString("cod_convenio");
                resp += "'>" + rs.getString("descr_convenio") + " </option>\n";
            }
            
            //Se ainda não tinha particular registrado, colocar na combo
            if(!temparticular)
                resp += "<option value='-1'>Particular</option>\n";
            
            rs.close();
            stmt.close();
            
            
            return resp;
        } catch(SQLException e) {
            return "Erro:" + e.toString();
        }
    } 

    //Relatório de Lancamentos
    public Vector getRelVacinas(String de, String ate, String codcli, String cod_vacina, String cod_laboratorio, String lote, String ordem) {
        //Retorno dos dados
        Vector retorno = new Vector();
        
        //Coloca as datas no formato correto pro SQL (aaaa/mm/dd)
        de = Util.formataDataInvertida(de);
        ate = Util.formataDataInvertida(ate);
        
        //Monta sql para consulta
        String sql =  "SELECT paciente.nome, vac_vacinas.descricao, vac_hist_vacinas.dose, ";
        sql += "vac_laboratorios.laboratorio, convenio.descr_convenio, ";
        sql += "vac_hist_vacinas.data_aplicacao, vac_estoque.lote, vac_hist_vacinas.valor ";
        sql += "FROM (convenio INNER JOIN (vac_vacinas INNER JOIN ";
        sql += "(paciente INNER JOIN vac_hist_vacinas ON paciente.codcli = ";
        sql += "vac_hist_vacinas.codcli) ON vac_vacinas.cod_vacina = ";
        sql += "vac_hist_vacinas.cod_vacina) ON convenio.cod_convenio = ";
        sql += "vac_hist_vacinas.cod_convenio) LEFT JOIN (vac_laboratorios ";
        sql += "RIGHT JOIN vac_estoque ON vac_laboratorios.cod_laboratorio = ";
        sql += "vac_estoque.cod_laboratorio) ON vac_hist_vacinas.cod_estoque = vac_estoque.cod_estoque ";
        sql += " WHERE data_aplicacao BETWEEN '" + de + "' AND '" + ate + "' ";
        
        if(!Util.isNull(codcli))
            sql += "AND vac_hist_vacinas.codcli=" + codcli + " ";
        if(!Util.isNull(cod_vacina))
            sql += "AND vac_hist_vacinas.cod_vacina=" + cod_vacina + " ";
        if(!Util.isNull(cod_laboratorio))
            sql += "AND vac_estoque.cod_laboratorio=" + cod_laboratorio + " ";
        if(!Util.isNull(lote))
            sql += "AND vac_estoque.lote='" + lote + "' ";
        
        sql += "ORDER BY " + ordem;
        
        String resp = "";
        boolean troca = false;
        int cont=0;
        float total = 0;
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            ResultSet rs = null;
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            resp  = "<tr style=\"background-color:'#CCCCCC'\">\n";
            resp += " <td class='tblrel'><a title='Ordenar por paciente' href=\"Javascript:ordenar('relvacinas2','nome')\"><b>Paciente</b></a></td>\n";
            resp += " <td class='tblrel'><a title='Ordenar por Vacina' href=\"Javascript:ordenar('relvacinas2','descricao')\"><b>Vacina</b></a></td>\n";
            resp += " <td class='tblrel'><a title='Ordenar por Laboratório' href=\"Javascript:ordenar('relvacinas2','laboratorio')\"><b>Laboratório</b></a></td>\n";
            resp += " <td class='tblrel'><a title='Ordenar por Convênio' href=\"Javascript:ordenar('relvacinas2','descr_convenio')\"><b>Convênio</b></a></td>\n";
            resp += " <td class='tblrel'><a title='Ordenar por Lote' href=\"Javascript:ordenar('relvacinas2','lote')\"><b>Lote</b></a></td>\n";
            resp += " <td class='tblrel'><a title='Ordenar por Data' href=\"Javascript:ordenar('relvacinas2','data_aplicacao')\"><b>Data</b></a></td>\n";
            resp += " <td class='tblrel'><b>Valor</b></td>\n";
            resp += "</tr>\n";
            
            //Adiciona cabeçalho ao retorno
            retorno.add(resp);
            
            //Cria looping com a resposta
            while(rs.next()) {
                //Alterna as cores do fundo
                if(troca) {
                    resp = "<tr style='background-color:#FFFFFF'>\n";
                    troca = false;
                } else {
                    resp = "<tr style='background-color:#EEEEEE'>\n";
                    troca = true;
                }
                
                total += rs.getFloat("valor");
                
                resp += "	<td class='tblrel'>" + rs.getString("nome") + "</td>\n";
                resp += "	<td class='tblrel'>" + rs.getString("descricao") + "</td>\n";
                resp += "	<td class='tblrel'>" + rs.getString("laboratorio") + "</td>\n";
                resp += "	<td class='tblrel'>" + rs.getString("descr_convenio") + "</td>\n";
                resp += "	<td class='tblrel'>" + rs.getString("lote") + "</td>\n";
                resp += "	<td class='tblrel'>" + Util.formataData(rs.getString("data_aplicacao")) + "</td>\n";
                resp += "	<td class='tblrel'>" + Util.formatCurrency(rs.getString("valor")) + "&nbsp;</td>\n";                    
                resp += "</tr>\n";
                
                //Adiciona cada linha ao retorno
                retorno.add(resp);
                
                cont++;
            }
            
            //Quando acabar o loopin, dar o subtotal do último e total geral
            resp = "";
            resp += "<tr style=\"background-color:'#CCCCCC'\">\n";
            resp += "  <td colspan=5 class='tblrel' align='left'><b>TOTAL: " + cont + "</b></td>\n";
            resp += "  <td class='tblrel'><b>" + Util.formatCurrency(total+"") + "</b></td>\n";
            resp += "</tr>\n";
            
            
            //Adiciona linha na saída
            retorno.add(resp);
            
            rs.close();
            stmt.close();

            return retorno;
        } catch(SQLException e) {
            retorno.add(e.toString() + "<br>" + sql);
            return retorno;
        }
    }

    //Relatório de Controle diário de aplicação de vacinas
    public Vector getRelControleDiario(String de, String ordem) {
        String sql = "", resp = "", aux = "";
           
        //Retorno dos dados
        Vector retorno = new Vector();
        
        //Coloca as datas no formato correto pro SQL (aaaa/mm/dd)
        de = Util.formataDataInvertida(de);
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            //Monta sql para consulta
            sql  = "SELECT cod_laboratorio, laboratorio FROM vac_laboratorios ";
            sql += "WHERE ativo='S' ORDER BY laboratorio ";

            ResultSet rs = null;
            //Looping de laboratórios
            rs = stmt.executeQuery(sql);

            resp = "<tr>\n";
            resp += " <td class='tblrel' style='background-color:black; color:white'><b>Vacina</b></td>\n";
            resp += " <td class='tblrel' style='background-color:black; color:white'><b>Lote</b></td>\n";
            resp += " <td class='tblrel' style='background-color:black; color:white'><b>Vencimento</b></td>\n";
            resp += " <td class='tblrel' style='background-color:black; color:white'><b>Entrada</b></td>\n";
            resp += " <td class='tblrel' style='background-color:black; color:white'><b>Saída</b></td>\n";
            resp += " <td class='tblrel' style='background-color:black; color:white'><b>Aplicações</b></td>\n";
            resp += "</tr>\n";
            retorno.add(resp);
            
            while(rs.next()) {
                //Verifica se o laboratório tem aplicações
                aux = getAplicacoes(rs.getString("cod_laboratorio"), de);
                
                if(!Util.isNull(aux)) {
                    resp  = "<tr>\n";
                    resp += " <td colspan='6' class='tblrel' style='background-color:#CCCCCC'><b>..:: " + rs.getString("laboratorio") + "</b></td>\n";
                    resp += "</tr>\n";

                    retorno.add(resp);
                    retorno.add(aux);
                }
                
            }
            
            rs.close();
            stmt.close();

            return retorno;
        } catch(SQLException e) {
            retorno.add(e.toString() + "<br>" + sql);
            return retorno;
        }
    }

    //Retorna as aplicações de vacinas de um laboratório em um dia
    public String getAplicacoes(String cod_laboratorio, String data) {
        String sql  = "";
        String resp = "";
        String data_entrada = "", data_saida = "";
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            ResultSet rs = null;
            //Executa a pesquisa
            sql  = "SELECT Count(vac_hist_vacinas.cod_hist_vacina) AS contador, ";
            sql += "vac_vacinas.descricao, vac_estoque.lote, vac_estoque.validade, ";
            sql += "vac_estoque.data_entrada, vac_saidas.data, vac_saidas.qtde ";
            sql += "FROM vac_saidas RIGHT JOIN ((vac_hist_vacinas INNER JOIN vac_estoque ";
            sql += "ON vac_hist_vacinas.cod_estoque = vac_estoque.cod_estoque) ";
            sql += "INNER JOIN vac_vacinas ON vac_estoque.cod_vacina = vac_vacinas.cod_vacina) ";
            sql += "ON vac_saidas.lote = vac_estoque.cod_estoque ";
            sql += "WHERE vac_estoque.cod_laboratorio = " + cod_laboratorio;
            sql += " AND vac_hist_vacinas.data_aplicacao = '" + data + "' ";
            sql += "GROUP BY vac_vacinas.descricao, vac_estoque.lote, vac_estoque.validade";
            rs = stmt.executeQuery(sql);

            //Cria looping com a resposta
            while(rs.next()) {
                //Data de entrada e saída
                data_entrada = Util.formataData(rs.getString("data_entrada"));
                data_saida = Util.formataData(rs.getString("data"));
                
                resp += "<tr>\n";
                resp += "<td class='tblrel'>" + rs.getString("descricao") + "</td>\n";
                resp += "<td class='tblrel'>" + rs.getString("lote") + "</td>\n";
                resp += "<td class='tblrel'>" + Util.formataData(rs.getString("validade")) + "</td>\n";
                //Se a data de entrada for a de consulta, mostrar quantidade
                if(data.equals(data_entrada))
                    resp += "<td class='tblrel'>" + rs.getString("qtde_compra") + "</td>\n";
                else
                    resp += "<td class='tblrel'>&nbsp;</td>\n";
                //Se a data de saída for a de consulta, mostrar quantidade
                if(data.equals(data_saida))
                    resp += "<td class='tblrel'>" + rs.getString("vac_saidas.qtde") + "</td>\n";
                else
                    resp += "<td class='tblrel'>&nbsp;</td>\n";
                resp += "<td class='tblrel'>" + rs.getString("contador") + "</td>\n";
                
            }
            rs.close();
            stmt.close();
            
            return resp;
        } catch(SQLException e) {
            return "ERRO: " + e.toString() + "SQL: " + sql;
        }
    }
    
    //Relatório de Lancamentos
    public Vector getRelAplicVacinas(String de, String ate, String codcli, String cod_vacina, String cod_lab, String ordem) {
        //Retorno dos dados
        Vector retorno = new Vector();
        
        //Coloca as datas no formato correto pro SQL (aaaa/mm/dd)
        de = Util.formataDataInvertida(de);
        ate = Util.formataDataInvertida(ate);
        
        //Monta sql para consulta
        String sql =  "SELECT paciente.nome, vac_vacinas.descricao, vac_hist_vacinas.dose, ";
        sql += "vac_hist_vacinas.data_aplicacao, vac_hist_vacinas.hora_aplicacao, ";
        sql += "vac_laboratorios.laboratorio, vac_estoque.lote, vac_hist_vacinas.local_aplicacao, ";
        sql += "vac_hist_vacinas.lado_aplicacao, vac_hist_vacinas.aplicador ";
        sql += "FROM (((vac_hist_vacinas INNER JOIN paciente ON vac_hist_vacinas.codcli = ";
        sql += "paciente.codcli) LEFT JOIN vac_estoque ON vac_hist_vacinas.cod_estoque = ";
        sql += "vac_estoque.cod_estoque) LEFT JOIN vac_laboratorios ON vac_estoque.cod_laboratorio = ";
        sql += "vac_laboratorios.cod_laboratorio) INNER JOIN vac_vacinas ON ";
        sql += "vac_hist_vacinas.cod_vacina = vac_vacinas.cod_vacina ";
        sql += "WHERE data_aplicacao BETWEEN '" + de + "' AND '" + ate + "' "; 
        
       
        if(!Util.isNull(codcli))
            sql += "AND vac_hist_vacinas.codcli=" + codcli + " ";
        if(!Util.isNull(cod_vacina))
            sql += "AND vac_hist_vacinas.cod_vacina=" + cod_vacina + " ";
        if(!Util.isNull(cod_lab))
            sql += "AND vac_laboratorios.cod_laboratorio=" + cod_lab + " ";
       
        
        sql += "ORDER BY " + ordem;
        
        String resp = "";
        boolean troca = false;
        int cont=0;
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            ResultSet rs = null;
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            resp  = "<tr style=\"background-color:'#CCCCCC'\">\n";
            resp += " <td class='tblrel'><a title='Ordenar por paciente' href=\"Javascript:ordenar('relvacinas2','nome')\"><b>Paciente</b></a></td>\n";
            resp += " <td class='tblrel'><a title='Ordenar por Data' href=\"Javascript:ordenar('relvacinas2','data_aplicacao')\"><b>Data Aplica&ccedil;&atilde;o</b></a></td>\n";
            resp += " <td class='tblrel'><a title='Ordenar por Hora' href=\"Javascript:ordenar('relvacinas2','hora_aplicacao')\"><b>Hora Aplica&ccedil;&atilde;o</b></a></td>\n";
            resp += " <td class='tblrel'><a title='Ordenar por Vacina' href=\"Javascript:ordenar('relvacinas2','descricao')\"><b>Vacina</b></a></td>\n";
            resp += " <td class='tblrel'><a title='Ordenar por Dose' href=\"Javascript:ordenar('relvacinas2','dose')\"><b>Dose</b></a></td>\n";
            resp += " <td class='tblrel'><a title='Ordenar por Dose' href=\"Javascript:ordenar('relvacinas2','laboratorio')\"><b>Laborat&oacute;rio</b></a></td>\n";
            resp += " <td class='tblrel'><a title='Ordenar por Lote' href=\"Javascript:ordenar('relvacinas2','lote')\"><b>Lote</b></a></td>\n";
            resp += " <td class='tblrel'><a title='Ordenar por Aplicador' href=\"Javascript:ordenar('relvacinas2','aplicador')\"><b>Aplicador</b></a></td>\n";
            resp += " <td class='tblrel'><a title='Ordenar por Local' href=\"Javascript:ordenar('relvacinas2','local_aplicacao')\"><b>Local</b></a></td>\n";
            resp += "</tr>\n";
            
            //Adiciona cabeçalho ao retorno
            retorno.add(resp);
            
            //Cria looping com a resposta
            while(rs.next()) {
                //Alterna as cores do fundo
                if(troca) {
                    resp = "<tr style='background-color:#FFFFFF'>\n";
                    troca = false;
                } else {
                    resp = "<tr style='background-color:#EEEEEE'>\n";
                    troca = true;
                }
                
                
                resp += "	<td class='tblrel'>" + rs.getString("nome") + "</td>\n";
                resp += "	<td class='tblrel'>" + Util.formataData(rs.getString("data_aplicacao")) + "</td>\n";
                resp += "	<td class='tblrel'>" + Util.formataHora(rs.getString("hora_aplicacao")) + "&nbsp;</td>\n";
                resp += "	<td class='tblrel'>" + rs.getString("descricao") + "</td>\n";
                resp += "	<td class='tblrel'>" + rs.getString("dose") + "</td>\n";
                resp += "	<td class='tblrel'>" + Util.trataNulo(rs.getString("laboratorio"),"N/C") + "</td>\n";
                resp += "	<td class='tblrel'>" + Util.trataNulo(rs.getString("lote"),"N/C") + "</td>\n";
                resp += "	<td class='tblrel'>" + Util.trataNulo(rs.getString("aplicador"),"N/C") + "</td>\n";
                resp += "	<td class='tblrel'>" + Util.trataNulo(rs.getString("local_aplicacao"),"N/C") + " (" + Util.trataNulo(rs.getString("lado_aplicacao"),"N/C") + ")</td>\n";                    
                resp += "</tr>\n";
                
                //Adiciona cada linha ao retorno
                retorno.add(resp);
                
                //Contador de registros
                cont++;
                
            }
                   
            resp  = "<tr>\n";
            resp += " <td class='tblrel' style='background-color:#CCCCCC' colspan='9'><b>Total: " + cont + " registros.</b></td>\n";
            resp += "</tr>\n";
            
            retorno.add(resp);
            
            rs.close();
            stmt.close();

            return retorno;
        } catch(SQLException e) {
            retorno.add(e.toString() + "<br>" + sql);
            return retorno;
        }
    }
    
    public Vector getRelRecebeVacinas(String de, String ate, String codcli, String cod_vacina, String cod_laboratorio, String lote, String ordem) {
        //Retorno dos dados
        Vector retorno = new Vector();
        
        //Coloca as datas no formato correto pro SQL (aaaa/mm/dd)
        de = Util.formataDataInvertida(de);
        ate = Util.formataDataInvertida(ate);
        
        //Monta sql para consulta
        String sql =  "SELECT paciente.nome, vac_vacinas.descricao, vac_hist_vacinas.dose, ";
        sql += "vac_laboratorios.laboratorio, convenio.descr_convenio, ";
        sql += "vac_hist_vacinas.data_recebimento, vac_estoque.lote, vac_hist_vacinas.valor_desc AS valor ";
        sql += "FROM (convenio INNER JOIN (vac_vacinas INNER JOIN ";
        sql += "(paciente INNER JOIN vac_hist_vacinas ON paciente.codcli = ";
        sql += "vac_hist_vacinas.codcli) ON vac_vacinas.cod_vacina = ";
        sql += "vac_hist_vacinas.cod_vacina) ON convenio.cod_convenio = ";
        sql += "vac_hist_vacinas.cod_convenio) LEFT JOIN (vac_laboratorios ";
        sql += "RIGHT JOIN vac_estoque ON vac_laboratorios.cod_laboratorio = ";
        sql += "vac_estoque.cod_laboratorio) ON vac_hist_vacinas.cod_estoque = vac_estoque.cod_estoque ";
        sql += " WHERE data_recebimento BETWEEN '" + de + "' AND '" + ate + "' ";
        
        if(!Util.isNull(codcli))
            sql += "AND vac_hist_vacinas.codcli=" + codcli + " ";
        if(!Util.isNull(cod_vacina))
            sql += "AND vac_hist_vacinas.cod_vacina=" + cod_vacina + " ";
        if(!Util.isNull(cod_laboratorio))
            sql += "AND vac_estoque.cod_laboratorio=" + cod_laboratorio + " ";
        if(!Util.isNull(lote))
            sql += "AND vac_estoque.lote='" + lote + "' ";
        
        sql += "ORDER BY " + ordem;
        
        String resp = "";
        boolean troca = false;
        int cont=0;
        float total = 0;
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            ResultSet rs = null;
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            resp  = "<tr style=\"background-color:'#CCCCCC'\">\n";
            resp += " <td class='tblrel'><a title='Ordenar por paciente' href=\"Javascript:ordenar('relrecebevacinas2','nome')\"><b>Paciente</b></a></td>\n";
            resp += " <td class='tblrel'><a title='Ordenar por Convênio' href=\"Javascript:ordenar('relrecebevacinas2','descr_convenio')\"><b>Convênio</b></a></td>\n";
            resp += " <td class='tblrel'><a title='Ordenar por Vacina' href=\"Javascript:ordenar('relrecebevacinas2','descricao')\"><b>Vacina</b></a></td>\n";
            resp += " <td class='tblrel'><a title='Ordenar por Laboratório' href=\"Javascript:ordenar('relrecebevacinas2','laboratorio')\"><b>Laboratório</b></a></td>\n";
            resp += " <td class='tblrel'><a title='Ordenar por Lote' href=\"Javascript:ordenar('relrecebevacinas2','lote')\"><b>Lote</b></a></td>\n";
            resp += " <td class='tblrel'><a title='Ordenar por Data' href=\"Javascript:ordenar('relrecebevacinas2','data_recebimento')\"><b>Data</b></a></td>\n";
            resp += " <td class='tblrel'><b>Valor</b></td>\n";
            resp += "</tr>\n";
            
            //Adiciona cabeçalho ao retorno
            retorno.add(resp);
            
            //Cria looping com a resposta
            while(rs.next()) {
                //Alterna as cores do fundo
                if(troca) {
                    resp = "<tr style='background-color:#FFFFFF'>\n";
                    troca = false;
                } else {
                    resp = "<tr style='background-color:#EEEEEE'>\n";
                    troca = true;
                }
                
                //AQUI
                total += rs.getFloat("valor");
                
                resp += "	<td class='tblrel'>" + rs.getString("nome") + "</td>\n";
                resp += "	<td class='tblrel'>" + rs.getString("descr_convenio") + "</td>\n";
                resp += "	<td class='tblrel'>" + rs.getString("descricao") + "</td>\n";
                resp += "	<td class='tblrel'>" + rs.getString("laboratorio") + "</td>\n";
                resp += "	<td class='tblrel'>" + rs.getString("lote") + "</td>\n";
                resp += "	<td class='tblrel'>" + Util.formataData(rs.getString("data_recebimento")) + "</td>\n";
                //AQUI
                resp += "	<td class='tblrel'>" + Util.formatCurrency(rs.getString("valor")) + "&nbsp;</td>\n";                    
                resp += "</tr>\n";
                
                //Adiciona cada linha ao retorno
                retorno.add(resp);
                
                cont++;
            }
            
            //Quando acabar o loopin, dar o subtotal do último e total geral
            resp = "";
            resp += "<tr style=\"background-color:'#CCCCCC'\">\n";
            resp += "  <td colspan=6 class='tblrel' align='left'><b>TOTAL: " + cont + "</b></td>\n";
            resp += "  <td class='tblrel'><b>" + Util.formatCurrency(total+"") + "</b></td>\n";
            resp += "</tr>\n";
            
            
            //Adiciona linha na saída
            retorno.add(resp);
            
            rs.close();
            stmt.close();

            return retorno;
        } catch(SQLException e) {
            retorno.add(e.toString() + "<br>" + sql);
            return retorno;
        }
    }
    
    //Relatório de Previsão de Vacinas
    public Vector getRelPrevVacinas(String de, String ate, String codcli, String cod_vacina, String cod_laboratorio, String lote, String ordem) {
        //Retorno dos dados
        Vector retorno = new Vector();
        
        //Coloca as datas no formato correto pro SQL (aaaa/mm/dd)
        de = Util.formataDataInvertida(de);
        ate = Util.formataDataInvertida(ate);
        
        //Monta sql para consulta
        String sql =  "";
        
        sql += "SELECT vac_prev_vacinas.cod_prev_vacina, paciente.nome, paciente.mae, data_sugestao,";
        sql += "paciente.nome_responsavel, paciente.tel_residencial, paciente.tel_comercial, ";
        sql += "paciente.tel_celular, vac_vacinas.descricao, vac_prev_vacinas.dose, vac_dose.descDose ";
        sql += "FROM ((paciente INNER JOIN vac_prev_vacinas ON paciente.codcli = vac_prev_vacinas.cod_cliente) ";
        sql += "INNER JOIN vac_vacinas ON vac_prev_vacinas.cod_vacina = vac_vacinas.cod_vacina) ";
        sql += "LEFT JOIN vac_dose ON (vac_prev_vacinas.dose = vac_dose.dose) AND ";
        sql += "(vac_prev_vacinas.cod_vacina = vac_dose.cod_vacina) ";
        sql += "WHERE vac_prev_vacinas.data_sugestao BETWEEN '"+de+"' AND '"+ate+"' ";
        
        if(!Util.isNull(codcli))
            sql += "AND paciente.codcli=" + codcli + " ";
        if(!Util.isNull(cod_vacina))
            sql += "AND vac_vacinas.cod_vacina=" + cod_vacina + " ";
        
        sql += "ORDER BY " + ordem;
        
        String resp = "";
        boolean troca = false;
        int cont=0;
       
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            ResultSet rs = null;
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            resp  = "<tr style=\"background-color:'#CCCCCC'\">\n";
            resp += " <td class='tblrel'><a title='Ordenar por paciente' href=\"Javascript:ordenar('relprevvacinas2','paciente.nome')\"><b>Paciente</b></a></td>\n";
            resp += " <td class='tblrel'><a title='Ordenar por Nome da Mãe' href=\"Javascript:ordenar('relprevvacinas2','paciente.mae')\"><b>Nome da M&atilde;e</b></a></td>\n";
            resp += " <td class='tblrel'><a title='Ordenar por Respons&aacute;' href=\"Javascript:ordenar('relprevvacinas2','paciente.nome_responsavel')\"><b>Respons&aacute;vel</b></a></td>\n";
            resp += " <td class='tblrel'><a title='Ordenar por Telefone Com' href=\"Javascript:ordenar('relprevvacinas2','paciente.tel_comercial')\"><b>Tel Comercial</b></a></td>\n";
            resp += " <td class='tblrel'><a title='Ordenar por Telefone Res' href=\"Javascript:ordenar('relprevvacinas2','paciente.tel_residencial')\"><b>Tel Residencial</b></a></td>\n";
            resp += " <td class='tblrel'><a title='Ordenar por Telefone Cel' href=\"Javascript:ordenar('relprevvacinas2','paciente.tel_celular')\"><b>Tel Celular</b></a></td>\n";
            resp += " <td class='tblrel'><a title='Ordenar por Vacina' href=\"Javascript:ordenar('relprevvacinas2','vac_vacinas.descricao')\"><b>Vacina</b></a></td>\n";
            resp += " <td class='tblrel'><a title='Ordenar por Dose' href=\"Javascript:ordenar('relprevvacinas2','vac_prev_vacinas.dose')\"><b>Dose</b></a></td>\n";
            resp += " <td class='tblrel'><a title='Ordenar por Data' href=\"Javascript:ordenar('relprevvacinas2','vac_prev_vacinas.data_sugestao')\"><b>Previs&atilde;o</b></a></td>\n";
            resp += "</tr>\n";
            
            //Adiciona cabeçalho ao retorno
            retorno.add(resp);
            
            //Cria looping com a resposta
            while(rs.next()) {
                //Alterna as cores do fundo
                if(troca) {
                    resp = "<tr style='background-color:#FFFFFF'>\n";
                    troca = false;
                } else {
                    resp = "<tr style='background-color:#EEEEEE'>\n";
                    troca = true;
                }
                
                
                resp += "	<td class='tblrel'>" + rs.getString("paciente.nome") + "</td>\n";
                resp += "	<td class='tblrel'>" + ((rs.getString("paciente.mae")==null)? "&nbsp;" : rs.getString("paciente.mae")) + "</td>\n";
                resp += "	<td class='tblrel'>" + ((rs.getString("paciente.nome_responsavel")==null)? "&nbsp;" : rs.getString("paciente.nome_responsavel")) + "</td>\n";
                resp += "	<td class='tblrel'>" + ((rs.getString("paciente.tel_comercial")==null)? "&nbsp;" : rs.getString("paciente.tel_comercial")) + "</td>\n";
                resp += "	<td class='tblrel'>" + ((rs.getString("paciente.tel_residencial")==null)?"&nbsp;":rs.getString("paciente.tel_residencial")) + "</td>\n";
                resp += "	<td class='tblrel'>" + ((rs.getString("paciente.tel_celular")==null)?"&nbsp;":rs.getString("paciente.tel_celular")) + "</td>\n";
                resp += "	<td class='tblrel'>" + rs.getString("vac_vacinas.descricao") + "</td>\n";
                resp += "	<td class='tblrel'>Dose " + rs.getString("vac_prev_vacinas.dose") +((rs.getString("vac_dose.descDose")==null)? "&nbsp;" : " ("+rs.getString("vac_dose.descDose")+")")+ "</td>\n";
                resp += "	<td class='tblrel'>" + Util.formataData(rs.getString("data_sugestao")) + "</td>\n";  
                resp += "</tr>\n";
                
                //Adiciona cada linha ao retorno
                retorno.add(resp);
                
                cont++;
            }
                        
            rs.close();
            stmt.close();

            return retorno;
        } catch(SQLException e) {
            retorno.add(e.toString() + "<br>" + sql);
            return retorno;
        }
    }

    //Relatório de Saída de Vacinas
    public Vector getRelSaidaVacinas(String de, String ate, String unidade, String vacina, String lab, String lote, String ordem) {
        //Retorno dos dados
        Vector retorno = new Vector();
        
        //Coloca as datas no formato correto pro SQL (aaaa/mm/dd)
        de = Util.formataDataInvertida(de);
        ate = Util.formataDataInvertida(ate);
        
        //Monta sql para consulta
        String sql =  "";
        
        sql += " SELECT vac_saidas.data, vac_saidas.qtde, vac_estoque.lote, vac_saidas.tipo_saida, vac_laboratorios.laboratorio, " +
                " vac_vacinas.descricao, vac_estoque.lote" +
                " FROM vac_saidas, vac_vacinas, vac_estoque, vac_laboratorios WHERE vac_saidas.cod_vacina = vac_vacinas.cod_vacina " +
                " AND vac_laboratorios.cod_laboratorio= vac_estoque.cod_laboratorio" +
                " AND vac_saidas.lote=vac_estoque.cod_estoque AND vac_saidas.data BETWEEN '" + de + "' AND '" + ate + "' ";
        
                    
        if(!Util.isNull(unidade))
            sql += "AND vac_saidas.tipo_saida='" + unidade + "' ";
        if(!Util.isNull(vacina))
            sql += "AND vac_vacinas.cod_vacina='" + vacina + "' ";
        if(!Util.isNull(lab))
            sql += "AND vac_estoque.cod_laboratorio='" + lab + "' ";
        if(!Util.isNull(lote))
            sql += "AND vac_estoque.lote='" + lote + "' ";
        
        sql += "ORDER BY " + ordem;
        
        String resp = "";
        boolean troca = false;
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            ResultSet rs = null;
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            resp  = "<tr style=\"background-color:'#CCCCCC'\">\n";
            resp += " <td class='tblrel'><a title='Ordenar por Unidade' href=\"Javascript:ordenar('relsaidavacinas2','tipo_saida')\"><b>Saída</b></a></td>\n";
            resp += " <td class='tblrel'><a title='Ordenar por Data' href=\"Javascript:ordenar('relsaidavacinas2','data')\"><b>Data</b></a></td>\n";
            resp += " <td class='tblrel'><a title='Ordenar por Quantidade' href=\"Javascript:ordenar('relsaidavacinas2','qtde')\"><b>Quantidade</b></a></td>\n";
            resp += " <td class='tblrel'><a title='Ordenar por Vacina' href=\"Javascript:ordenar('relsaidavacinas2','vac_vacinas.descricao')\"><b>Vacina</b></a></td>\n";
            resp += " <td class='tblrel'><a title='Ordenar por Laborat&oacute;rio' href=\"Javascript:ordenar('relsaidavacinas2','vac_laboratorios.laboratorio')\"><b>Laborat&oacute;rio</b></a></td>\n";
            resp += " <td class='tblrel'><a title='Ordenar por Lote' href=\"Javascript:ordenar('relsaidavacinas2','vac_estoque.lote')\"><b>Lote</b></a></td>\n";
            
            resp += "</tr>\n";
            
            //Adiciona cabeçalho ao retorno
            retorno.add(resp);
            
            //Cria looping com a resposta
            while(rs.next()) {
                //Alterna as cores do fundo
                if(troca) {
                    resp = "<tr style='background-color:#FFFFFF'>\n";
                    troca = false;
                } else {
                    resp = "<tr style='background-color:#EEEEEE'>\n";
                    troca = true;
                }
                
                
                resp += "	<td class='tblrel'>" + rs.getString("tipo_saida") + "</td>\n";
                resp += "	<td class='tblrel'>" + Util.formataData(rs.getString("data")) + "</td>\n";
                resp += "	<td class='tblrel'>" + rs.getString("qtde") + "</td>\n";
                resp += "	<td class='tblrel'>" + rs.getString("vac_vacinas.descricao") + "</td>\n";
                resp += "	<td class='tblrel'>" + rs.getString("vac_laboratorios.laboratorio") + "</td>\n";
                resp += "	<td class='tblrel'>" + rs.getString("vac_estoque.lote") + "</td>\n";
                resp += "</tr>\n";
                
                //Adiciona cada linha ao retorno
                retorno.add(resp);
                
            }
            
            
            
            rs.close();
            stmt.close();

            return retorno;
        } catch(SQLException e) {
            retorno.add(e.toString() + "<br>" + sql);
            return retorno;
        }
    }
    
    //Relatório de Estoque de Vacinas
    public Vector getRelEstoque(String cod_empresa, String data) {
        //Retorno dos dados
        Vector retorno = new Vector();
        
        //Monta sql para consulta
        String sql =  "SELECT vac_vacinas.descricao, vac_vacinas.estoque_min, vac_laboratorios.laboratorio, ";
        sql += "vac_estoque.lote, vac_estoque.cod_estoque, ";
        sql += "vac_estoque.data_entrada, vac_estoque.validade, vac_estoque.qtde_compra ";
        sql += "FROM (vac_vacinas LEFT JOIN vac_estoque ON vac_estoque.cod_vacina = vac_vacinas.cod_vacina) ";
        sql += "LEFT JOIN vac_laboratorios ON vac_estoque.cod_laboratorio = vac_laboratorios.cod_laboratorio ";
        sql += "WHERE vac_vacinas.cod_empresa=" + cod_empresa + " AND vac_vacinas.ativo='S' AND vac_estoque.ativo='S' ";
        sql += "AND vac_estoque.data_entrada <= '" + Util.formataDataInvertida(data) + "' ";
        sql += "ORDER BY vac_vacinas.descricao";
        
        String resp = "";
        String oldvacina  = "";
        long cont=0;
        int estoque_min = 0;
        String cor = "";
        String estoque = "0";
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            ResultSet rs = null;
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            //Cria looping com a resposta
            while(rs.next()) {
            
                //Calcula o estoque do lote
                estoque = getQuantidadeEstoque(rs.getString("cod_estoque"),data);
                
                //Só exibe se for positivo
                if(Integer.parseInt(estoque) > 0) {

                    //Se trocou o nome da vacina, colocar no cabeçalho
                    if(!oldvacina.equals(rs.getString("descricao"))) {

                        if(!Util.isNull(oldvacina)) {

                            if(cont < estoque_min) cor = "style='background-color:red'";
                            else cor = "";

                            resp  = "<tr>";
                            resp += " <td class='tdDark' " + cor + ">Estoque Mínimo: </td>\n";
                            resp += " <td class='tdDark' " + cor + ">" + estoque_min + "</td>\n";
                            resp += " <td class='tdDark' align='right' " + cor + ">Em estoque: </td>\n";
                            resp += " <td class='tdDark' align='left' " + cor + ">" + cont + "</td>\n";
                            resp += "</tr>";
                            resp += "<tr><td colspan='4'>&nbsp;</td></tr>\n";
                            retorno.add(resp);
                        }
                        resp  = "<tr>";
                        resp += " <td class='tdDark' colspan='4'><b><li>" + rs.getString("descricao") + "</li></b></td>\n";
                        resp += "</tr>\n";
                        resp += "<tr>\n";
                        resp += " <td class='tdMedium'>Laboratório</td>\n";
                        resp += " <td class='tdMedium'>Lote</td>\n";
                        resp += " <td class='tdMedium'>Validade</td>\n";
                        resp += " <td class='tdMedium'>Estoque</td>\n";
                        resp += "</tr>\n";

                        retorno.add(resp);

                        //Zera acumulador
                        cont=0;
                    }

                    resp  = "<tr>\n";
                    resp += " <td class='tdLight'>" + Util.trataNulo(rs.getString("laboratorio"),"N/C") + "</td>\n";
                    resp += " <td class='tdLight'>" + Util.trataNulo(rs.getString("lote"),"N/C") + "</td>\n";
                    resp += " <td class='tdLight'>" + Util.formataData(Util.trataNulo(rs.getString("validade"),"")) + "&nbsp;</td>\n";
                    resp += " <td class='tdLight'>" + estoque + "</td>\n";
                    resp += "</tr>\n";

                    //Pega o nome da vacina e estoque mínimo
                    oldvacina = rs.getString("descricao");
                    estoque_min = rs.getInt("estoque_min");

                    //Adiciona cada linha ao retorno
                    retorno.add(resp);

                    cont+= Float.parseFloat(estoque);
               }

            }
            
            if(cont < estoque_min) cor = "style='background-color:red'";
            else cor = "";

            resp  = "<tr>";
            resp += " <td class='tdDark' " + cor + ">Estoque Mínimo: </td>\n";
            resp += " <td class='tdDark' " + cor + ">" + estoque_min + "</td>\n";
            resp += " <td class='tdDark' align='right' " + cor + ">Em estoque: </td>\n";
            resp += " <td class='tdDark' align='left' " + cor + ">" + cont + "</td>\n";
            resp += "</tr>";
            retorno.add(resp);

            rs.close();
            stmt.close();

            return retorno;
        } catch(SQLException e) {
            retorno.add("ERRO: " + e.toString() + " SQL: " + sql);
            return retorno;
        }
    }
    
    public String getLocalVacina(String cod_hist_vacina) {
        if(cod_hist_vacina==null) cod_hist_vacina="-1";
        String sql  = "SELECT local_aplicacao FROM vac_hist_vacinas WHERE cod_hist_vacina= " + cod_hist_vacina  ;
        String resp = "";
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            ResultSet rs = null;
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);

            String local = "";
            
            //Cria looping com a resposta
            if(rs.next()) {
                //Captura o local de aplicacao
                local = rs.getString("local_aplicacao");
                if(local==null) local="";
            }
            rs.close();
            stmt.close();
            
            
            resp += "<option value=\"Delt&oacute;ide\" " +
                    ((local.equals("Deltóide"))? "selected":"") +
                    ">Delt&oacute;ide</option>";
            resp += "<option value=\"Gl&uacute;teo\" " +
                    ((local.equals("Glúteo"))? "selected":"") +
                    ">Gl&uacute;teo</option>";
            resp += "<option value=\"Vasto Lateral da Coxa\" " +
                    ((local.equals("Vasto Lateral da Coxa"))? "selected":"") +
                    ">Vasto Lateral da Coxa</option>";
            resp += "<option value=\"Via Oral\" " +
                    ((local.equals("Via Oral"))? "selected":"") +
                    ">Via Oral</option>";
            
            return resp;
        } catch(SQLException e) {
            return e.toString();
        }
    }
    
    
    public String getLadoVacina(String cod_hist_vacina) {
        if(cod_hist_vacina==null) cod_hist_vacina="-1";
        String sql  = "SELECT lado_aplicacao FROM vac_hist_vacinas WHERE cod_hist_vacina= " + cod_hist_vacina  ;
        String resp = "";
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            ResultSet rs = null;
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);

            String local = "";
            
            //Cria looping com a resposta
            if(rs.next()) {
                //Captura o local de aplicacao
                local = rs.getString("lado_aplicacao");
                if(local==null) local="";
            }
            rs.close();
            stmt.close();
                        
            
            resp += "<option value=\"Direito\" " +
                    ((local.equals("Direito"))? "selected":"") +
                    ">Direito</option>";
            resp += "<option value=\"Esquerdo\" " +
                    ((local.equals("Esquerdo"))? "selected":"") +
                    ">Esquerdo</option>";
            
            return resp;
        } catch(SQLException e) {
            return e.toString();
        }
    }
    
    public String[] getSaidaVacinas(String pesquisa, String ordem, int numPag, int qtdeporpagina, int tipo, String cod_empresa) {
        String resp[] = {"",""};
        String sql = "";
        ResultSet rs = null;
        
        //Limpa espaços em branco antes e depois da pesquisa
        pesquisa = pesquisa.trim();
        
        sql += "SELECT vac_saidas.cod_saida, vac_saidas.tipo_saida, vac_saidas.qtde, " +
                "vac_saidas.data, vac_vacinas.descricao FROM vac_saidas INNER JOIN vac_vacinas " +
                "ON vac_saidas.cod_vacina=vac_vacinas.cod_vacina WHERE " ;

        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            //Consulta exata
            if(tipo == 1)
                sql += "vac_vacinas.descricao='" + pesquisa + "' OR tipo_saida='" + pesquisa + "'";
            //Começando com o valor
            else if(tipo == 2)
                sql += "vac_vacinas.descricao LIKE '" + pesquisa + "%' OR tipo_saida LIKE '" + pesquisa + "%'";
            //Com o valor no meio
            else if(tipo == 3)
                sql += "vac_vacinas.descricao LIKE '%" + pesquisa + "%' OR tipo_saida LIKE '%" + pesquisa + "%'";
            
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
            resp[1] = Util.criaPaginacao("emprestimovacinas.jsp", numPag, qtdeporpagina, numRows);
            
            //Limita para uma quantidade de registros
            sql += " LIMIT " + ((numPag-1)*qtdeporpagina) + "," + qtdeporpagina;
            
            //Executa a pesquisa novamente com o limitador
            rs = stmt.executeQuery(sql);
            
            //Cria looping com a resposta
            while(rs.next()) {
                resp[0] += "<tr onClick=go('emprestimovacinas.jsp?cod=" + rs.getString("cod_saida") + "') onMouseOver='trocaCor(this,1);' onMouseOut='trocaCor(this,2);'>";
                resp[0] += "   <td class='tdLight'>" + rs.getString("tipo_saida") + "&nbsp;</td>\n";
                resp[0] += "   <td width='250' class='tdLight'>" + rs.getString("vac_vacinas.descricao") + " ("+ rs.getString("vac_saidas.qtde") +")&nbsp;</td>\n";
                resp[0] += "   <td width='80' class='tdLight'>" + Util.formataData(rs.getString("data")) + "&nbsp;</td>\n";
                resp[0] += "</tr>";
            }
            
            //Se não retornar resposta, montar mensagem de não encontrado
            if(resp[0].equals("")) {
                resp[0] += "<tr>";
                resp[0] += "<td colspan='3' width='600' class='tdLight'>";
                resp[0] += "Nenhum registro encontrado para a pesquisa";
                resp[0] += "</td>";
                resp[0] += "</tr>";
            }
            rs.close();
            stmt.close();
            return resp;
            
        } catch(SQLException e) {
            resp[0] = "Erro:" + e.toString();
            return resp;
        }
    }
    
    public String[] getUnidade(String pesquisa, String campo, String ordem, int numPag, int qtdeporpagina, int tipo, String cod_empresa) {
        String resp[] = {"",""};
        String sql = "";
        ResultSet rs = null;
        
        //Limpa espaços em branco antes e depois da pesquisa
        pesquisa = pesquisa.trim();
        
        sql += "SELECT * ";
        sql += " FROM (vac_unidades ) ";

        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            //Consulta exata
            if(tipo == 1)
                sql += "WHERE " + campo + "='" + pesquisa + "'";
            //Começando com o valor
            else if(tipo == 2)
                sql += "WHERE " + campo + " LIKE '" + pesquisa + "%'";
            //Com o valor no meio
            else if(tipo == 3)
                sql += "WHERE " + campo + " LIKE '%" + pesquisa + "%'";
            
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
            resp[1] = Util.criaPaginacao("cadastrounidades.jsp", numPag, qtdeporpagina, numRows);
            
            //Limita para uma quantidade de registros
            sql += " LIMIT " + ((numPag-1)*qtdeporpagina) + "," + qtdeporpagina;
            
            //Executa a pesquisa novamente com o limitador
            rs = stmt.executeQuery(sql);
            
            //Cria looping com a resposta
            while(rs.next()) {
                resp[0] += "<tr onClick=go('cadastrounidades.jsp?cod=" + rs.getString("cod_unidade") + "') onMouseOver='trocaCor(this,1);' onMouseOut='trocaCor(this,2);'>";
                resp[0] += "   <td class='tdLight'>" + rs.getString("nome") + "&nbsp;</td>\n";
                resp[0] += "</tr>";
            }
            
            //Se não retornar resposta, montar mensagem de não encontrado
            if(resp[0].equals("")) {
                resp[0] += "<tr>";
                resp[0] += "<td colspan='3' width='600' class='tdLight'>";
                resp[0] += "Nenhum registro encontrado para a pesquisa";
                resp[0] += "</td>";
                resp[0] += "</tr>";
            }
            rs.close();
            stmt.close();
            return resp;
            
        } catch(SQLException e) {
            resp[0] = "Erro:" + e.toString();
            return resp;
        }
    }

    public String getTodasUnidades() {
        String sql  = "SELECT nome FROM vac_unidades ";
        sql +=  " ORDER BY nome";
        String resp = "";
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            ResultSet rs = null;
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);


            
            //Cria looping com a resposta
            while(rs.next()) {
                                
               resp += "<option value='" + rs.getString("nome") + "'>" + rs.getString("nome") + "</option>\n";
            }
            rs.close();
            stmt.close();
            
            return resp;
        } catch(SQLException e) {
            return e.toString();
        }
    }

    //Retorna o total em estoque de uma lote específico
    public String getQuantidadeEstoque(String cod_estoque, String data) {
       
        String resp = "0";
        
        //Se não veio cod_estoque, retornar vazio
        if(Util.isNull(cod_estoque)) return resp;
        
        //Se não veio data, pega a atual
        if(Util.isNull(data)) data = Util.getData();
        
        try {
            
            Banco bc = new Banco();
            
            //Busca o valor de compra do estoque
            String valorcompra = bc.getValor("qtde_compra", "SELECT qtde_compra FROM vac_estoque WHERE cod_estoque=" + cod_estoque + " AND data_entrada <= '" + Util.formataDataInvertida(data) + "'");

            //Soma todos os lançamentos de vacinas que tem esse lote
            String aplicacoes = bc.getValor("total", "SELECT COUNT(*) AS total FROM vac_hist_vacinas WHERE cod_estoque=" + cod_estoque + " AND data_aplicacao <= '" + Util.formataDataInvertida(data) + "'");

            //Soma todas as saídas para esse lote
            String saidas = bc.getValor("saidas", "SELECT SUM(qtde) AS saidas FROM vac_saidas WHERE lote='" + cod_estoque + "' AND data <= '" + Util.formataDataInvertida(data) + "'");
            
            //Se não veio valores, zerar
            if(Util.isNull(valorcompra)) valorcompra = "0";
            if(Util.isNull(aplicacoes)) aplicacoes = "0";
            if(Util.isNull(saidas)) saidas = "0";
            
            //Faz a diferença
            int resultado = Integer.parseInt(valorcompra) - (Integer.parseInt(aplicacoes)+Integer.parseInt(saidas));
            
            //Converte para String
            resp = resultado + "";
            
            return resp;
        } catch(Exception e) {
            return "ERRO: " + e.toString();
        }
    }

    public String getNomeVacina(String cod_vacina) {
        String sql  = "SELECT descricao FROM vac_vacinas ";
        sql +=  " WHERE cod_vacina='"+cod_vacina+"'";
        String resp = "";
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            ResultSet rs = null;
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
           
            //Cria looping com a resposta
            if(rs.next()) {
                                
               resp += "<option value='" + rs.getString("descricao") + "'> " + rs.getString("descricao") + " </option>\n";
            }
            rs.close();
            stmt.close();
            
            return resp;
        } catch(SQLException e) {
            return e.toString();
        }
    }

    //Grava uma previsão de vacina
    public String gravarPrevisaoVacina(String data_sugestao, String codcli, String dose, String cod_vacina) {
        
        Banco bc = new Banco();
        String next = bc.getNext("vac_prev_vacinas", "cod_prev_vacina");
        
        String sql = "INSERT INTO vac_prev_vacinas(cod_prev_vacina, data_sugestao, dose, cod_vacina, cod_cliente) ";
        sql += "VALUES(" + next + ",'" + Util.formataDataInvertida(data_sugestao) + "'," + dose + "," + cod_vacina;
        sql += "," + codcli + ")";
        
        return bc.executaSQL(sql);
    }
    
   
    
    public static void main(String args[]) {
        Vacina v = new Vacina();
        
        String estoque = v.getQuantidadeEstoque("305","20/10/2008");
        
        System.out.println(estoque);
    }
    
    
}
    