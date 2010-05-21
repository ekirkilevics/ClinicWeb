/* Arquivo: Configuracao.java
 * Autor: Amilton Souza Martha
 * Criação: 04/10/2005   Atualização: 30/03/2007
 * Obs: Manipula o banco dee configuracaoes do sistema
 */

package recursos;
import java.sql.*;

public class Configuracao {
    
    //Atributos privados para conexão
    private Connection con = null;
    private Statement stmt = null;
    
    //Construtor que cria conexão com o banco
    public Configuracao() {
        con = Conecta.getInstance();
    }
    
    //Busca algum item dee configuração do sistemas (tabela configuracoes)
    public String getItemConfig(String parametro, String cod_empresa) {
        ResultSet rs = null;
        String sql = "";
        String resp = "";
        
        try {
            //Cria statemente para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            //Procura o parâmetro na configuração
            sql  = "SELECT " + parametro + " FROM configuracoes ";
            sql += "WHERE cod_empresa=" + cod_empresa;
            rs = stmt.executeQuery(sql);
            
            //Se encontrar, vai retornar
            if(rs.next())
                resp = (rs.getString(parametro)!= null ? rs.getString(parametro) : "");
            //Se não encontrar, procurar o default
            else {
                if(parametro.equals("tdlight"))  resp = "#E6F9DF";
                if(parametro.equals("tdmedium")) resp = "#BAEDA9";
                if(parametro.equals("tddark"))   resp = "#8EE272";
                if(parametro.equals("fundo"))    resp = "#ECFAE7";
            }
            
            //Fecha conexão
            rs.close();
            stmt.close();
            
            return resp;
        } catch(SQLException e) {
            return e.toString();
        }
    }
    
    //Busca o tempo de sessão para o usuário logado
    public String getTempoSessao(String usuario_logado) {
        ResultSet rs = null;
        String sql = "";
        String resp = "";
        
        try {
            //Cria statemente para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            //Procura o parâmetro na configuração
            sql  = "SELECT t_grupos.temposessao ";
            sql += "FROM t_usuario INNER JOIN t_grupos ON ";
            sql += "t_usuario.ds_grupo = t_grupos.grupo_id ";
            sql += "WHERE t_usuario.cd_usuario=" + usuario_logado;
            
            rs = stmt.executeQuery(sql);
            
            //Se encontrar, vai retornar
            if(rs.next())
                resp = rs.getString("temposessao");
            //Se não encontrar, procurar o default
            else {
                resp = "20";
            }
            
            //Fecha conexão
            rs.close();
            stmt.close();
            
            return resp;
        } catch(SQLException e) {
            return e.toString();
        }
    }

   //Retorna os bancos da empresa
    public String getBancos(String cod_empresa) {
        String resp = "";
        String sql = "";
        ResultSet rs = null;
        
        //Se não veio cod. de convênio, retornar vazio
        if(Util.isNull(cod_empresa)) return "";
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            sql += "SELECT * FROM bancos WHERE cod_empresa=" + cod_empresa + " ORDER BY banco";
            
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            //Cria looping com a resposta
            while(rs.next()) {
                resp += "<tr>\n";
                resp += "    <td class='tdLight'>" + rs.getString("banco") + "</td>\n";
                resp += "    <td class='tdLight'>" + rs.getString("agencia") + "</td>\n";
                resp += "    <td class='tdLight'>" + rs.getString("conta") + "</td>\n";
                resp += "    <td class='tdLight' align='center'><a href='Javascript:excluirbanco(" + rs.getString("cod_banco") + ")' title='Remover Conta'><img src='images/delete.gif' border=0></a>\n";
                resp += "</tr>\n";
            }
            rs.close();
            stmt.close();
            
            return resp;
        } catch(SQLException e) {
            return "Erro:" + e.toString();
        }
    }    

}