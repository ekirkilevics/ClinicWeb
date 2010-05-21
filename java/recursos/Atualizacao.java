/* Arquivo: Atualizacao.java
 * Autor: Amilton Souza Martha
 * Criação: 29/11/2005   Atualização: 03/07/2006
 * Obs: Exibe as atualizações do sistema por versão
 */

package recursos;
import java.sql.*;

public class Atualizacao {
    //Atributos privados para conexão
    private Connection con = null;
    private Statement stmt = null;
    
    public Atualizacao() {
        con = Conecta.getInstance();
    }
    
    //Devolve os convênios
    public String getVersoes() {
        String sql =  "SELECT DISTINCT(data), versao ";
        sql += "FROM atualizacoes ORDER BY data DESC";
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
                resp += "<option value='" + rs.getString("versao") + "'>" + rs.getString("versao") + " ( " + Util.formataData(rs.getString("data")) + " )</option>\n";
            }
            
            //Fecha o recordset e a conexão
            rs.close();
            stmt.close();
            
            return resp;
        } catch(SQLException e) {
            return e.toString();
        }
    }
    
    //Devolve a última versão e sua data de atualização
    //[0] - Versão
    //[1] - Data
    public String[] getUltimaVersao() {
        
        String resp[] = {"",""};
        String sql =  "SELECT MAX(data) as data, MAX(versao) as versao FROM atualizacoes";
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            ResultSet rs = null;
            
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            //Cria looping com a resposta
            if(rs.next()) {
                resp[0] = rs.getString("versao");
                resp[1] = Util.formataData(rs.getString("data"));
            }
            
            //Fecha o recordset e a conexão
            rs.close();
            stmt.close();
            
            return resp;
        } catch(SQLException e) {
            resp[0] = e.toString();
            return resp;
        }
    }
    
    //Retorna as atualizações de uma versão
    public String getAtualizacoes(String versao) {
        String resp = "<table width='600' border='0' cellpadding='0' cellspacing='0' class='table'>";
        String sql = "";
        ResultSet rs = null;
        boolean par = true;
        int cont = 1;
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            //Se não escolheu a versão, pegar como default a última
            if(versao.equals("")) {
                sql = "SELECT data, versao FROM atualizacoes ORDER BY data DESC";
                //Executa a pesquisa
                rs = stmt.executeQuery(sql);
                if(rs.next()) {
                    versao = rs.getString("versao");
                }
                rs.close();
            }
            
            //Captura as alterações para a versão escolhida
            sql = "SELECT * FROM atualizacoes WHERE versao ='" + versao + "'";
            
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            //Cria looping com a resposta
            while(rs.next()) {
                resp += "<tr>\n";
                if(par) {
                    resp += "<td class='tdLight' style='width:600px;word-wrap: break-word'><b>" + cont + ")</b> " + rs.getString("texto") + "</td>\n";
                    par = false;
                } else {
                    resp += "<td class='tdMedium' style='width:600px; word-wrap: break-word'><b>" + cont + ")</b> " + rs.getString("texto") + "</td>\n";
                    par = true;
                }
                cont++;
                resp += "</tr>\n";
            }
            
            resp += "</table>\n";
            
            //Fecha o recordset e a conexão
            rs.close();
            stmt.close();
            
            return resp;
        } catch(SQLException e) {
            return "Erro:" + e.toString();
        }
    }
    
}