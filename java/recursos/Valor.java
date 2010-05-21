/* Arquivo: Valor.java
 * Autor: Amilton Souza Martha
 * Criação: 13/09/2005   Atualização: 01/04/2009
 * Obs: Manipula as informações de valores de procedimentos x convênios
 */

package recursos;
import java.sql.*;

public class Valor {
    //Atributos privados para conexão
    private Connection con = null;
    private Statement stmt = null;
    
    public Valor() {
        con = Conecta.getInstance();
    }
    
    //devolve os planos dos convênios
    //tipo: 1-em combo, 2-em list
    public String getPlanos(String cod_convenio) {
        return getPlanos(cod_convenio, "1");
    }
    
    //Devolve os planos dos convênios
    public String getPlanos(String cod_convenio, String tipo) {
        
        String resp = "";
        
        //se não veio cód. de convênio, voltar vazio
        if(Util.isNull(cod_convenio)){
            //Verifica se é em combo ou list
            if(tipo.equals("1"))
                resp += "<select name='cod_plano' id='cod_plano' class='caixa' style='width:120px'></select>";
            else
                resp += "<select name='cod_plano' id='cod_plano' class='caixa' style='width:170px; height:100px' multiple></select>";
            
            return resp;
        }
        
        String sql =  "SELECT * FROM planos ";
        sql += "WHERE cod_convenio=" + cod_convenio + " ORDER BY plano";
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            ResultSet rs = null;
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            //Verifica se é em combo ou list
            if(Util.isNull(tipo) || tipo.equals("1") || tipo.equalsIgnoreCase("undefined"))
                resp += "<select name='cod_plano' id='cod_plano' class='caixa' style='width:120px'>";
            else
                resp += "<select name='cod_plano' id='cod_plano' class='caixa' style='width:170px; height:100px' multiple>";
            
            //Cria looping com a resposta
            while(rs.next()) {
                resp += "<option value='" + rs.getString("cod_plano") + "'>" + rs.getString("plano") + "</option>\n";
            }
            
            //Insere plano não identificado
            resp += "<option value='-1'>Não identificado</option>\n";
            
            resp += "</select>\n";
            
            rs.close();
            stmt.close();
            
            return resp;
        } catch(SQLException e) {
            return e.toString();
        }
    }
    
    //Retorna os procedimentos e especialidades
    public String getProcedimentos(String cod_empresa) {
        String resp = "";
        String sql = "";
        ResultSet rs = null;
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            sql += "SELECT COD_PROCED, Procedimento, CODIGO ";
            sql += "FROM procedimentos ";
            sql += "WHERE procedimentos.flag = 1 ";
            sql += "AND procedimentos.cod_empresa=" + cod_empresa + " ";
            sql += "ORDER BY Procedimento";
            
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            //Cria looping com a resposta
            while(rs.next()) {
                resp += "<option value='" + rs.getString("COD_PROCED") + "'>[" + rs.getString("CODIGO") + "] " + rs.getString("Procedimento") + "</option>\n";
            }
            rs.close();
            stmt.close();
            
            return resp;
        } catch(SQLException e) {
            return "Erro:" + e.toString();
        }
    }
    
    //Retorna os procedimentos e especialidades
    public String getPlano(String codvalor) {
        String resp = "";
        String sql = "";
        ResultSet rs = null;
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            sql += "SELECT planos.cod_plano, planos.plano ";
            sql += "FROM valorprocedimentos INNER JOIN planos ON ";
            sql += "valorprocedimentos.cod_plano = planos.cod_plano ";
            sql += "WHERE valorprocedimentos.cod_valorprocedimento=" + codvalor;
            
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            //Cria looping com a resposta
            while(rs.next()) {
                resp += "<option value='" + rs.getString("cod_plano") + "'>" + rs.getString("plano") +  "</option>\n";
            }
            rs.close();
            stmt.close();
            
            return resp;
        } catch(SQLException e) {
            return "ERRO: " + e.toString() + " SQL:" + sql;
        }
    }
    
    /* pesquisa: valor a ser pesquisado
     * campo: campo a ser pesquisado
     * ordem: ordem de resposta dos campos
     * numPag: número da página selecionada (paginação)
     * qtdeporpagina: quantidade de registros por página
     * tipo: tipo de pesquisa (exata, substring)
     * cod_empresa: código da empresa logada
     * cod_convenio: código do convênio
     */
    public String[] getValores(String pesquisa, String convenio_pesq, String ordem, int numPag, int qtdeporpagina, int tipo, String cod_empresa) {
        String resp[] = {"",""};
        String sql = "";
        ResultSet rs = null;
        
        //Limpa espaços em branco antes e depois da pesquisa
        pesquisa = pesquisa.trim();
        
        sql += "SELECT procedimentos.Procedimento, convenio.descr_convenio, ";
        sql += "valorprocedimentos.valor, valorprocedimentos.cod_valorprocedimento, planos.plano ";
        sql += "FROM (procedimentos INNER JOIN (convenio INNER JOIN valorprocedimentos ON ";
        sql += "convenio.cod_convenio = valorprocedimentos.cod_convenio) ON ";
        sql += "procedimentos.COD_PROCED = valorprocedimentos.cod_proced) ";
        sql += "INNER JOIN planos ON valorprocedimentos.cod_plano = planos.cod_plano ";
        sql += "WHERE procedimentos.cod_empresa=" + cod_empresa;
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            //Consulta exata
            if(tipo == 1)
                sql += " AND Procedimento='" + pesquisa + "'";
            //Começando com o valor
            else if(tipo == 2)
                sql += " AND Procedimento LIKE '" + pesquisa + "%'";
            //Com o valor no meio
            else if(tipo == 3)
                sql += " AND Procedimento LIKE '%" + pesquisa + "%'";
            
            //Se escolheu convênio, filtrar
            if(!Util.isNull(convenio_pesq))
                sql += " AND valorprocedimentos.cod_convenio=" + convenio_pesq;
            
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
            resp[1] = Util.criaPaginacao("valoresprocedimentos.jsp", numPag, qtdeporpagina, numRows);
            
            //Limita para uma quantidade de registros
            sql += " LIMIT " + ((numPag-1)*qtdeporpagina) + "," + qtdeporpagina;
            
            //Executa a pesquisa novamente com o limitador
            rs = stmt.executeQuery(sql);
            
            //Cria looping com a resposta
            while(rs.next()) {
                resp[0] += "<tr onClick=go('valoresprocedimentos.jsp?cod=" + rs.getString("cod_valorprocedimento") + "') onMouseOver='trocaCor(this,1);' onMouseOut='trocaCor(this,2);'>";
                resp[0] += "<td width='30%' class='tdLight'>" + rs.getString("Procedimento") + "&nbsp;</td>\n";
                resp[0] += "<td width='30%' class='tdLight'>" + rs.getString("descr_convenio") + "&nbsp;</td>\n";
                resp[0] += "<td width='20%' class='tdLight'>" + rs.getString("plano") + "&nbsp;</td>\n";
                resp[0] += "<td class='tdLight'>" + Util.formatCurrency(rs.getString("valor")) + "&nbsp;</td>\n";
                resp[0] += "</tr>";
            }
            
            //Se não retornar resposta, montar mensagem de não encontrado
            if(resp[0].equals("")) {
                resp[0] += "<tr>";
                resp[0] += " <td colspan='3' width='600' class='tdLight'>";
                resp[0] += "  Nenhum registro encontrado para a pesquisa";
                resp[0] += " </td>";
                resp[0] += "</tr>";
            }
            rs.close();
            stmt.close();
            return resp;
            
        } catch(SQLException e) {
            resp[0] = "ERRO: " + e.toString() + " SQL: " + sql;
            return resp;
        }
    }
    
    //Retorna as tabelas
    public String getTabelas(String cod_empresa) {
        String resp = "";
        String sql = "";
        ResultSet rs = null;
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            sql += "SELECT * FROM tabelas WHERE cod_empresa=" + cod_empresa + " ";
            sql += "ORDER BY tabela";
            
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            //Cria looping com a resposta
            while(rs.next()) {
                resp += "<option value='" + rs.getString("cod_tiss") + "'>[" + rs.getString("cod_tiss") + "] " + rs.getString("tabela") +  "</option>\n";
            }
            rs.close();
            stmt.close();
            
            return resp;
        } catch(SQLException e) {
            return "Erro:" + e.toString();
        }
    }    
    
    //Retorna os convênios com valores cadastrados
    public String getConvenios(String convenio_pesq) {
        String resp = "";
        String sql = "";
        ResultSet rs = null;
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            sql += "SELECT convenio.descr_convenio, convenio.cod_convenio FROM convenio ";
            sql += "INNER JOIN valorprocedimentos ON ";
            sql += "valorprocedimentos.cod_convenio = convenio.cod_convenio ";
            sql += "GROUP BY convenio.descr_convenio, convenio.cod_convenio ";
            sql += "ORDER BY descr_convenio";
            
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            //Cria looping com a resposta
            while(rs.next()) {
                //Se veio convênio, setar
                if(!Util.isNull(convenio_pesq) && convenio_pesq.equals(rs.getString("cod_convenio")))
                    resp += "<option value='" + rs.getString("cod_convenio") + "' selected>" + rs.getString("descr_convenio") +  "</option>\n";
                else
                    resp += "<option value='" + rs.getString("cod_convenio") + "'>" + rs.getString("descr_convenio") +  "</option>\n";
            }
            rs.close();
            stmt.close();
            
            return resp;
        } catch(SQLException e) {
            return "ERRO: " + e.toString() + " SQL: " + sql;
        }
    }    
}