/* Arquivo: ValorTabela.java
 * Autor: Amilton Souza Martha
 * Criação: 02/05/2007   Atualização: 02/05/2007
 * Obs: Manipula as informações de valores de procedimentos x tabelas
 */

package recursos;
import java.sql.*;

public class ValorTabela {
    //Atributos privados para conexão
    private Connection con = null;
    private Statement stmt = null;
    
    public ValorTabela() {
        con = Conecta.getInstance();
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
    public String[] getValores(String pesquisa, String campo, String ordem, int numPag, int qtdeporpagina, int tipo, String cod_empresa) {
        String resp[] = {"",""};
        String sql = "";
        ResultSet rs = null;
        
        //Limpa espaços em branco antes e depois da pesquisa
        pesquisa = pesquisa.trim();
        
        sql += "SELECT tabelas.tabela, procedimentos.Procedimento, valor.valor, valor.cod_valor ";
        sql += "FROM (procedimentos INNER JOIN valor ON procedimentos.COD_PROCED = ";
        sql += "valor.cod_proced) INNER JOIN tabelas ON valor.cod_tabela = tabelas.cod_tabela ";
        sql += "WHERE procedimentos.cod_empresa=" + cod_empresa;
        
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
            resp[1] = Util.criaPaginacao("valortabelas.jsp", numPag, qtdeporpagina, numRows);
            
            //Limita para uma quantidade de registros
            sql += " LIMIT " + ((numPag-1)*qtdeporpagina) + "," + qtdeporpagina;
             
            //Executa a pesquisa novamente com o limitador
            rs = stmt.executeQuery(sql);
            
            //Cria looping com a resposta
            while(rs.next()) {
                resp[0] += "<tr onClick=go('valortabelas.jsp?cod=" + rs.getString("cod_valor") + "') onMouseOver='trocaCor(this,1);' onMouseOut='trocaCor(this,2);'>";
                resp[0] += "<td width='50%' class='tdLight'>" + rs.getString("Procedimento") + "&nbsp;</td>\n";
                resp[0] += "<td width='30%' class='tdLight'>" + rs.getString("tabela") + "&nbsp;</td>\n";
                resp[0] += "<td width='20%' class='tdLight'>" + Util.formatCurrency(rs.getString("valor")).substring(2) + "&nbsp;</td>\n";
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
            resp[0] = "Erro:" + e.toString() + sql;
            return resp;
        }
    }
    
    //resp[0] = Tabela
    //resp[1] = Procedimento
    public String [] getItensValor(String cod_valor) {
        String resp[] = {"", ""};
        String sql = "";
        ResultSet rs = null;
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            sql += "SELECT tabelas.tabela, procedimentos.Procedimento ";
            sql += "FROM tabelas INNER JOIN (procedimentos INNER JOIN valor ON ";
            sql += "procedimentos.COD_PROCED = valor.cod_proced) ON ";
            sql += "tabelas.cod_tabela = valor.cod_tabela ";
            sql += "WHERE valor.cod_valor=" + cod_valor;
         
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            //Cria looping com a resposta
            if(rs.next()) {
                resp[0] = rs.getString("tabela");
                resp[1] = rs.getString("Procedimento");
            }
            rs.close();
            stmt.close();
            
            return resp;
        } catch(SQLException e) {
            resp[0] = "Erro: " + e.toString();
            resp[1] = sql;
            return resp;
        }      
    }
 }