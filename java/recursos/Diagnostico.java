/* Arquivo: Diagnostico.java
 * Autor: Amilton Souza Martha
 * Cria��o: 06/09/2005   Atualiza��o: 08/10/2007
 * Obs: Manipula informa��es do diagn�stico
 */

package recursos;
import java.sql.*;

public class Diagnostico {
    //Atributos privados para conex�o
    private Connection con = null;
    private Statement stmt = null;
    
    public Diagnostico() {
        con = Conecta.getInstance();
    }
    
      /* pesquisa: valor a ser pesquisado
       * campo: campo a ser pesquisado
       * ordem: ordem de resposta dos campos
       * numPag: n�mero da p�gina selecionada (pagina��o)
       * qtdeporpagina: quantidade de registros por p�gina
       * tipo: tipo de pesquisa (exata, substring)
       * cod_empresa: c�digo da empresa logada
       */
    public String[] getDiagnosticos(String pesquisa, String campo, String ordem, int numPag, int qtdeporpagina, int tipo, String cod_empresa) {
        String resp[] = {"",""};
        String sql = "";
        String paginacao = "";
        ResultSet rs = null;
        String codigo = "";
        
        //Limpa espa�os em branco antes e depois da pesquisa
        pesquisa = pesquisa.trim();
        
        sql += "SELECT * FROM diagnosticos ";
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            //Consulta exata
            if(tipo == 1)
                sql += "WHERE (DESCRICAO='" + pesquisa + "' OR CID='" + pesquisa + "')";
            //Come�ando com o valor
            else if(tipo == 2)
                sql += "WHERE (DESCRICAO LIKE '" + pesquisa + "%' OR CID LIKE '" + pesquisa + "%')";
            //Com o valor no meio
            else if(tipo == 3)
                sql += "WHERE (DESCRICAO LIKE '%" + pesquisa + "%' OR CID LIKE '%" + pesquisa + "%')";
            
            //Filtra pela empresa
            sql += " AND cod_empresa=" + cod_empresa;
            
            //Coloca na ordem
            sql += " ORDER BY " + ordem;
            
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            //Vai para o �ltimo registro
            rs.last();
            
            //Captura a quantidade de linhas
            int numRows = rs.getRow();
            rs.close();
            
            //Cria pagina��o das p�ginas
            resp[1] = Util.criaPaginacao("diagnosticos.jsp", numPag, qtdeporpagina, numRows);
            
            //Limita para uma quantidade de registros
            sql += " LIMIT " + ((numPag-1)*qtdeporpagina) + "," + qtdeporpagina;
            
            //Executa a pesquisa novamente com o limitador
            rs = stmt.executeQuery(sql);
            //Cria looping com a resposta
            while(rs.next()) {
                codigo = rs.getString("CID");
                if(codigo == null) codigo = "";
                
                resp[0] += "<tr onClick=go('diagnosticos.jsp?cod=" + rs.getString("cod_diag") + "') onMouseOver='trocaCor(this,1);' onMouseOut='trocaCor(this,2);'>";
                resp[0] += "<td width='30%' class='tdLight'>" + codigo + "</td>\n";
                resp[0] += "<td class='tdLight'>" + rs.getString("DESCRICAO") + "&nbsp;</td>\n";
                resp[0] += "</tr>";
            }
            
            //Se n�o retornar resposta, montar mensagem de n�o encontrado
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
    
    //pesquisa: valor a ser pesquisado
    //campo: campo a ser pesquisado
    //ordem: ordem de resposta dos campos
    //qtd: quantidade de regsitros a retornar
    //tipo: tipo de pesquisa (exata, substring)
    public String[] getDiagnosticosPesq(String pesquisa, String campo, String ordem, int numPag, int qtdeporpagina, int tipo, String cod_empresa) {
        String resp[] = {"",""};
        String sql = "";
        String paginacao = "";
        ResultSet rs = null;
        String codigo = "";
        
        //Limpa espa�os em branco antes e depois da pesquisa
        pesquisa = pesquisa.trim();
        
        sql += "SELECT * FROM diagnosticos ";
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            //Consulta exata
            if(tipo == 1)
                sql += "WHERE DESCRICAO='" + pesquisa + "' OR CID='" + pesquisa + "'";
            //Come�ando com o valor
            else if(tipo == 2)
                sql += "WHERE DESCRICAO LIKE '" + pesquisa + "%' OR CID LIKE '" + pesquisa + "%'";
            //Com o valor no meio
            else if(tipo == 3)
                sql += "WHERE DESCRICAO LIKE '%" + pesquisa + "%' OR CID LIKE '%" + pesquisa + "%'";
            
            //Filtra pela empresa
            sql += " AND cod_empresa=" + cod_empresa;
            
            //Coloca na ordem
            sql += " ORDER BY " + ordem;
            
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            //Vai para o �ltimo registro
            rs.last();
            
            //Captura a quantidade de linhas
            int numRows = rs.getRow();
            rs.close();
            
            //Cria pagina��o das p�ginas
            resp[1] = Util.criaPaginacao("buscadiagnosticos.jsp", numPag, qtdeporpagina, numRows);
            
            //Limita para uma quantidade de registros
            sql += " LIMIT " + ((numPag-1)*qtdeporpagina) + "," + (numPag*qtdeporpagina);
            
            //Executa a pesquisa novamente com o limitador
            rs = stmt.executeQuery(sql);
            //Cria looping com a resposta
            while(rs.next()) {
                codigo = rs.getString("CID");
                if(codigo == null) codigo = "";
                
                resp[0] += "<tr onClick=\"insereDiagnostico('" + rs.getString("cod_diag") + "','" + rs.getString("CID") + "-" + rs.getString("DESCRICAO") + "');\" onMouseOver='trocaCor(this,1);' onMouseOut='trocaCor(this,2);'>";
                resp[0] += "<td width='30%' class='tdLight'>" + codigo + "</td>\n";
                resp[0] += "<td class='tdLight'>" + rs.getString("DESCRICAO") + "&nbsp;</td>\n";
                resp[0] += "</tr>";
            }
            
            //Se n�o retornar resposta, montar mensagem de n�o encontrado
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
}