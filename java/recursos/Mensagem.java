/* Arquivo: Mensagem.java
 * Autor: Amilton Souza Martha
 * Criação: 29/04/2008   Atualização: 29/04/2008
 * Obs: Manipula as informações de mensagens entre usuários
 */

package recursos;
import java.sql.*;
import java.util.Vector;

public class Mensagem {
    //Atributos privados para conexão
    private Connection con = null;
    private Statement stmt = null;
    
    public Mensagem() {
        con = Conecta.getInstance();
    }

    //Pega as mensagens para esse usuário
        public String getMensagens(String cod_usuario) {
        String resp = "";
        String sql = "";
        ResultSet rs = null;
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            //Busca mensagens que ainda não foram lidas
            sql  = "SELECT mensagens.mensagem, mensagens.data, mensagens.hora, t_usuario.ds_nome ";
            sql += "FROM mensagens INNER JOIN t_usuario ON mensagens.cod_usuario_origem = t_usuario.cd_usuario ";
            sql += "WHERE mensagens.cod_usuario_destino=" + cod_usuario + " AND mensagens.ativo='S'";
            
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            //Cria looping com a resposta
            while(rs.next()) {
                resp += "<table border='0' cellspacing='0' cellpadding='0'>\n";
                resp += " <tr>\n";
                resp += "  <td style='font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 10px; color:#222222'><b>" + rs.getString("ds_nome") + " em " + Util.formataData(rs.getString("data")) + " " + Util.formataHora(rs.getString("hora")) + " enviou:</b></td>\n";
                resp += " </tr>\n";
                resp += " <tr>\n";
                resp += "  <td style='font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 10px;'>" + rs.getString("mensagem") + "</td>\n";
                resp += " </tr>\n";
                resp += "</table>\n";
            }
            
            //Coloca como mensagens já lidas
            new Banco().executaSQL("UPDATE mensagens SET ativo='N' WHERE cod_usuario_destino=" + cod_usuario);

            rs.close();
            stmt.close();
            
            return resp;
        } catch(SQLException e) {
            return "Ocorreu um erro: " + e.toString();
        }
    }
    
    
}