/* Arquivo: Alerta.java
 * Autor: Amilton Souza Martha
 * Criação: 21/02/2006   Atualização: 02/09/2008
 * Obs: Manipula as informações de alertas
 */

package recursos;
import java.sql.*;

public class Alerta {
    //Atributos privados para conexão
    private Connection con = null;
    private Statement stmt = null;
    
    public Alerta() {
        con = Conecta.getInstance();
    }
    
    public String getAlertas(String cod_empresa) {
        String sql  = "SELECT * FROM alertas WHERE cod_empresa=";
        sql += cod_empresa + " ORDER BY alerta";
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
                resp += "<option value='" + rs.getString("cod_alerta") + "'>" + rs.getString("alerta") + "</option>\n";
            }
            rs.close();
            stmt.close();
            
            return resp;
        } catch(SQLException e) {
            return e.toString();
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
    public String[] getAlertas(String pesquisa, String campo, String ordem, int numPag, int qtdeporpagina, int tipo, String cod_empresa) {
        String resp[] = {"",""};
        String sql = "";
        ResultSet rs = null;
        
        //Limpa espaços em branco antes e depois da pesquisa
        pesquisa = pesquisa.trim();
        
        sql += "SELECT * FROM alertas ";
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
            resp[1] = Util.criaPaginacao("alertas.jsp", numPag, qtdeporpagina, numRows);
            
            //Limita para uma quantidade de registros
            sql += " LIMIT " + ((numPag-1)*qtdeporpagina) + "," + qtdeporpagina;
            
            //Executa a pesquisa novamente com o limitador
            rs = stmt.executeQuery(sql);
            
            //Cria looping com a resposta
            while(rs.next()) {
                resp[0] += "<tr onClick=go('alertas.jsp?cod=" + rs.getString("cod_alerta") + "') onMouseOver='trocaCor(this,1);' onMouseOut='trocaCor(this,2);'>";
                resp[0] += "<td width='100%' class='tdLight'>" + rs.getString("alerta") + "&nbsp;</td>\n";
                resp[0] += "</tr>";
            }
            
            //Se não retornar resposta, montar mensagem de não encontrado
            if(resp[0].equals("")) {
                resp[0] += "<tr>";
                resp[0] += " <td width='600' class='tdLight'>";
                resp[0] += "   Nenhum registro encontrado para a pesquisa";
                resp[0] += " </td>";
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
    
    //Recupera todos os alertas do paciente para criar select box
    public String getAlertasPaciente(String codcli) {
        String sql = "";
        String resp = "";
        ResultSet rs = null;
        int cont=1;
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            sql += "SELECT alertas.*, alerta_paciente.* ";
            sql += "FROM alerta_paciente INNER JOIN alertas ON ";
            sql += "alerta_paciente.cod_alerta = alertas.cod_alerta ";
            sql += "WHERE alerta_paciente.cod_paci='" + codcli + "'";
            
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            //Cabeçalho
            resp += "<table cellspacing=0 cellpadding=0 width='100%'>\n";
            resp += "<tr>\n";
            resp += "  <td class='tdMedium'><b>nº</b></td>\n";
            resp += "  <td class='tdMedium'><b>Alertas</b></td>\n";
            resp += "  <td class='tdMedium'><b>Início</b></td>\n";
            resp += "  <td class='tdMedium'><b>Fim</b></td>\n";
            resp += "  <td class='tdMedium'><b>Excluir</b></td>\n";
            resp += "</tr>\n";
            
            //Cria looping com a resposta
            while(rs.next()) {
                resp += "<tr>\n";
                resp += "  <td class='tdLight'>Alerta " + cont + "</td>\n";
                resp += "  <td class='tdLight'>" + rs.getString("alerta") + "</td>\n";
                resp += "  <td class='tdLight'>" + Util.formataData(rs.getString("de")) + "&nbsp;</td>\n";
                resp += "  <td class='tdLight'>" + Util.formataData(rs.getString("ate")) + "&nbsp;</td>\n";
                resp += "  <td class='tdLight' align='center'><a title='Excluir alerta' href='Javascript:excluiralerta(" + rs.getString("cod_alerta_paci") + ")'><img src='images/delete.gif' border=0></a></td>\n";
                resp += "</tr>\n";
                cont++;
                
            }
            
            resp += "</table>";
            rs.close();
            stmt.close();
            
            
            return resp;
        } catch(SQLException e) {
            return "ERRO: " + e.toString() + " SQL=" + sql;
        }
    }
    
    //Insere um alerta existente para um paciente
    public String insereAlertaCombo(String codcli, String cod_alerta, String de, String ate) {
        String sql = "" ;
        
        de = "'" + Util.formataDataInvertida(de) + "'";
        
        if(Util.isNull(ate)) ate = "null";
        else ate = "'" + Util.formataDataInvertida(ate) + "'";
        
        String nextcod = new Banco().getNext("alerta_paciente","cod_alerta_paci");

        sql =  "INSERT INTO alerta_paciente(cod_alerta_paci, cod_alerta, cod_paci, de, ate) ";
        sql += "VALUES(" + nextcod + "," + cod_alerta + "," + codcli + ",";
        sql += de + "," + ate + ")";

        //Retorno o resultado da execução do script (OK para sucesso)
        return new Banco().executaSQL(sql);
            
    }
    
    //Cria um alerta novo e insere para o paciente
    public String insereAlertaNovo(String codcli, String alertanovo, String de, String ate, String cod_empresa) {
        String sql = "";
        
        de = "'" + Util.formataDataInvertida(de) + "'";
        
        if(Util.isNull(ate)) ate = "null";
        else ate = "'" + Util.formataDataInvertida(ate) + "'";
        
        String nextcodalerta = new Banco().getNext("alertas","cod_alerta");

        sql =  "INSERT INTO alertas(cod_alerta, cod_empresa, alerta) ";
        sql += "VALUES(" + nextcodalerta + "," + cod_empresa + ",'" + alertanovo + "')";
        new Banco().executaSQL(sql);

        String nextcod = new Banco().getNext("alerta_paciente","cod_alerta_paci");

        sql =  "INSERT INTO alerta_paciente(cod_alerta_paci, cod_alerta, cod_paci, de, ate) ";
        sql += "VALUES(" + nextcod + "," + nextcodalerta + "," + codcli + ",";
        sql += de + "," + ate + ")";

        return new Banco().executaSQL(sql);
            
    }
}