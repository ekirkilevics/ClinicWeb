/* Arquivo: Medicamento.java
 * Autor: Amilton Souza Martha
 * Cria��o: 13/10/2005   Atualiza��o: 03/08/2009
 * Obs: Manipula informa��es de medicamento
 */

package recursos;
import java.sql.*;

public class Medicamento {
    //Atributos privados para conex�o
    private Connection con = null;
    private Statement stmt = null;
    
    public Medicamento() {
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
    public String[] getMedicamentos(String pesquisa, String campo, String ordem, int numPag, int qtdeporpagina, int tipo, String cod_empresa) {
        String resp[] = {"",""};
        String sql = "";
        ResultSet rs = null;
        
        //Limpa espa�os em branco antes e depois da pesquisa
        pesquisa = pesquisa.trim();
        
        sql += "SELECT * FROM medicamentos ";
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            //Consulta exata
            if(tipo == 1)
                sql += "WHERE " + campo + "='" + pesquisa + "'";
            //Come�ando com o valor
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
            
            //Vai para o �ltimo registro
            rs.last();
            
            //Captura a quantidade de linhas
            int numRows = rs.getRow();
            rs.close();
            
            //Cria pagina��o das p�ginas
            resp[1] = Util.criaPaginacao("medicamentos.jsp", numPag, qtdeporpagina, numRows);
            
            //Limita para uma quantidade de registros
            sql += " LIMIT " + ((numPag-1)*qtdeporpagina) + "," + qtdeporpagina;
            
            //Executa a pesquisa novamente com o limitador
            rs = stmt.executeQuery(sql);
            
            //Cria looping com a resposta
            while(rs.next()) {
                resp[0] += "<tr onClick=go('medicamentos.jsp?cod=" + rs.getString("cod_comercial") + "') onMouseOver='trocaCor(this,1);' onMouseOut='trocaCor(this,2);'>";
                resp[0] += "<td width='50%' class='tdLight'>" + rs.getString("comercial") + "</td>\n";
                resp[0] += "<td class='tdLight'>" + rs.getString("apresentacao") + "&nbsp;</td>\n";
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
    
       /* pesquisa: valor a ser pesquisado
        * campo: campo a ser pesquisado
        * ordem: ordem de resposta dos campos
        * numPag: n�mero da p�gina selecionada (pagina��o)
        * qtdeporpagina: quantidade de registros por p�gina
        * tipo: tipo de pesquisa (exata, substring)
        * cod_empresa: c�digo da empresa logada
        */
    public String[] getMedicamentosPesq(String pesquisa, String campo, String ordem, int numPag, int qtdeporpagina, int tipo, String cod_empresa) {
        String resp[] = {"",""};
        String sql = "";
        ResultSet rs = null;
        
        //Limpa espa�os em branco antes e depois da pesquisa
        pesquisa = pesquisa.trim();
        
        sql += "SELECT * FROM medicamentos ";
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            //Consulta exata
            if(tipo == 1)
                sql += "WHERE " + campo + "='" + pesquisa + "'";
            //Come�ando com o valor
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
            
            //Vai para o �ltimo registro
            rs.last();
            
            //Captura a quantidade de linhas
            int numRows = rs.getRow();
            rs.close();
            
            //Cria pagina��o das p�ginas
            resp[1] = Util.criaPaginacao("buscamedicamentos.jsp", numPag, qtdeporpagina, numRows);
            
            //Limita para uma quantidade de registros
            sql += " LIMIT " + ((numPag-1)*qtdeporpagina) + "," + (numPag*qtdeporpagina);
            
            //Executa a pesquisa novamente com o limitador
            rs = stmt.executeQuery(sql);
            
            //Cria looping com a resposta
            while(rs.next()) {
                resp[0] += "<tr onClick=\"insereMedicamento('" + rs.getString("cod_comercial") + "','" + rs.getString("comercial") + "');\" onMouseOver='trocaCor(this,1);' onMouseOut='trocaCor(this,2);'>";
                resp[0] += "<td width='50%' class='tdLight'>" + rs.getString("comercial") + "</td>\n";
                resp[0] += "<td class='tdLight'>" + rs.getString("apresentacao") + "&nbsp;</td>\n";
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

   //Busca a �ltima indica��o para o medicamento
   public String getIndicacaoMedicamento(String cod_comercial, String prof_reg) {
       String sql = "SELECT indicacao FROM hist_medicamento INNER JOIN historia ";
       sql += "ON hist_medicamento.cod_hist = historia.cod_hist ";
       sql += "WHERE cod_comercial=" + cod_comercial + " AND prof_reg='" + prof_reg + "'";
       sql += " ORDER BY cod_hist_med LIMIT 1";

       String indicacao = new Banco().getValor("indicacao", sql);

       return indicacao;
   }
 
}