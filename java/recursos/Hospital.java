/* Arquivo: Hospital.java
 * Autor: Amilton Souza Martha
 * Criação: 11/08/2008   Atualização: 13/08/2008
 * Obs: Manipula as informações de Hospitais
 */

package recursos;
import java.sql.*;

public class Hospital {
    //Atributos privados para conexão
    private Connection con = null;
    private Statement stmt = null;
    
    public Hospital() {
        con = Conecta.getInstance();
    }
    
    public String getHospitais(String cod_empresa) {
        String sql  = "SELECT * FROM hospitais WHERE cod_empresa=";
        sql += cod_empresa + " AND ativo='S' ORDER BY descricao";
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
                resp += "<option value='" + rs.getString("cod_hospital") + "'>" + rs.getString("descricao") + "</option>\n";
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
    public String[] getHospitais(String pesquisa, String campo, String ordem, int numPag, int qtdeporpagina, int tipo, String cod_empresa) {
        String resp[] = {"",""};
        String sql = "";
        ResultSet rs = null;
        
        //Limpa espaços em branco antes e depois da pesquisa
        pesquisa = pesquisa.trim();
        
        sql += "SELECT * FROM hospitais ";
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
            
            //Somente os ativos
            sql += " AND ativo='S'";
            
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
            resp[1] = Util.criaPaginacao("hospitais.jsp", numPag, qtdeporpagina, numRows);
            
            //Limita para uma quantidade de registros
            sql += " LIMIT " + ((numPag-1)*qtdeporpagina) + "," + qtdeporpagina;
            
            //Executa a pesquisa novamente com o limitador
            rs = stmt.executeQuery(sql);
            
            //Cria looping com a resposta
            while(rs.next()) {
                resp[0] += "<tr onClick=go('hospitais.jsp?cod=" + rs.getString("cod_hospital") + "') onMouseOver='trocaCor(this,1);' onMouseOut='trocaCor(this,2);'>";
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
    
    
}