/* Arquivo: AgendaPessoal.java
 * Autor: Amilton Souza Martha
 * Criação: 15/12/2008   Atualização: 28/12/2008
 * Obs: Manipula as informações da Agenda Pessoal
 */

package recursos;
import java.sql.*;

public class AgendaPessoal {
    //Atributos privados para conexão
    private Connection con = null;
    private Statement stmt = null;
    
    public AgendaPessoal() {
        con = Conecta.getInstance();
    }
    
    //Grava uma agenda pessoal
    public String gravarAgenda(String cod_usuario, String data, String hora, String horaalarme, String descricao) {
    
        //Se algo veio nulo, ignorar
        if(Util.isNull(data) || Util.isNull(hora) || Util.isNull(descricao))
            return "";
        
        String sql = "INSERT INTO agendapessoal(cd_usuario, data, hora, horaalarme, descricao) VALUES(";
        sql += cod_usuario + ",'" + Util.formataDataInvertida(data) + "','" + hora + "',";
        
        //Se não veio hora do alarme, não colocar
        if(Util.isNull(horaalarme))
            sql += "null,'" + descricao + "')";
        else
            sql += "'" + horaalarme + "','" + descricao + "')";
        return new Banco().executaSQL(sql);
    }
    
    //Apaga uma agenda pessoal
    public String excluirAgenda(String cod_agenda) {
    
        //Se algo veio nulo, ignorar
        if(Util.isNull(cod_agenda))
            return "";
        
        String sql = "DELETE FROM agendapessoal WHERE cod_agenda=" + cod_agenda;
        
        return new Banco().executaSQL(sql);
    }

    //Listagemn de agendas do usuário de um dia
    public String getAgendasPessoais(String cod_usuario, String data) {
        return getAgendasPessoais(cod_usuario, data, true);
    }
     
    //Listagemn de agendas do usuário de um dia
    public String getAgendasPessoais(String cod_usuario, String data, boolean permiteexcluir) {
        //Se não veio nada, ignorar
        if(Util.isNull(data)) return null;
        
        String resp = "";
        String sql = "";
        ResultSet rs = null;
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            //BUsca as agendas da pessoa
            sql += "SELECT * FROM agendapessoal WHERE cd_usuario=" + cod_usuario;
            sql += " AND data='" + Util.formataDataInvertida(data) + "' ";
            sql += "ORDER BY hora";

            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            //Contador
            int cont=0;
            
            //cabeçalho
            resp = "<table cellspacing='0' cellpadding='0' width='100%'>\n";
            
            //Cria looping com a resposta
            while(rs.next()) {
                resp += "<tr>\n";
                resp += "  <td class='tdMedium' width='40'>" + Util.formataHora(rs.getString("hora")) + "</td>\n";
                resp += "  <td class='tdLight'>" + rs.getString("descricao") + "</td>\n";
                if(permiteexcluir)
                    resp += "  <td class='tdLight' width='20' align='center'><a href='Javascript:excluiragenda(" + rs.getString("cod_agenda") + ")' title='Excluir Compromisso'><img src='images/delete.gif' border='0'></a></td>\n";
                resp += "</tr>\n";
                cont++;
            }
            
            //Se não achou nenhum registro
            if(cont == 0) {
                resp += "<tr>\n";
                resp += "  <td class='tdMedium' colspan='3' align='left'><b>Nenhum compromisso agendado</b></td>\n";
                resp += "</tr>\n";
            }
            else {
                resp += "<tr>\n";
                resp += "  <td class='tdMedium' colspan='3' align='left'><b>" + cont + " compromisso(s) encontrado(s)</b></td>\n";
                resp += "</tr>\n";
            }
            resp += "</table>\n";
        }
        catch(SQLException e) {
            resp = "ERRO: " + e.toString() + " SQL: " + sql;
        }
        
        return resp;
    }
    
    //Listagemn de agendas do usuário de um dia
    public String getAgendasPessoaisDia(String cod_usuario) {
        String resp = "";
        String sql = "";
        ResultSet rs = null;
        boolean achou = false;
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            //BUsca as agendas da pessoa
            sql += "SELECT * FROM agendapessoal WHERE cd_usuario=" + cod_usuario;
            sql += " AND data='" + Util.formataDataInvertida(Util.getData()) + "' ";
            sql += "AND horaalarme='" + Util.getHora() + "' AND exibiu='N'";

            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            //cabeçalho
            resp = "..:: ALERTA ::..\n\n";
            
            //Cria looping com a resposta
            while(rs.next()) {
                resp += "[" + Util.formataHora(rs.getString("hora")) + "] ";
                resp += rs.getString("descricao") + "\n";
                
                //Depois que pegou a agenda, setar como lida
                new Banco().executaSQL("UPDATE agendapessoal SET exibiu='S' WHERE cod_agenda=" + rs.getString("cod_agenda"));

                achou = true;
            }
            
            //Se não achou
            if(!achou) return "###";

        }
        catch(SQLException e) {
            resp = "ERRO: " + e.toString() + " SQL: " + sql;
        }
        
        return resp;
    }

    //Listagem de agendas pessoas por dia em um mês/ano
    public String getAgendasPessoaisCadastradas(String mes, String ano, String cod_usuario) {
        String resp = "";
        String sql = "";
        ResultSet rs = null;
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            //Faz um looping para ver a quantidade de agendas por dia
            for(int i=1; i<=31; i++) {
                String data = ano + "-" + mes + "-" + i;
                
                //Busca as agendas do dia
                sql  = "SELECT * FROM agendapessoal WHERE cd_usuario=" + cod_usuario;
                sql += " AND data='" + data + "' ";

                //Executa a pesquisa
                rs = stmt.executeQuery(sql);
                
                //Se achou agenda para o dia
                if(rs.next()) {
                    resp += "<idDate" + i + ">S</idDate" + i + ">\n";
                }
                else {
                    resp += "<idDate" + i + ">N</idDate" + i + ">\n";
                }
            }
            
            return resp;
            
        }
        catch(SQLException e) {
            resp = "ERRO: " + e.toString() + " SQL: " + sql;
        }
        
        return resp;
    }
}