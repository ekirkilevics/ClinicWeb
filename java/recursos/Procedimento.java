/* Arquivo: Procedimento.java
 * Autor: Amilton Souza Martha
 * Criação: 06/09/2005   Atualização: 05/02/2009
 * Obs: Manipula as informações de procedimento
 */

package recursos;
import java.sql.*;

public class Procedimento {
    //Atributos privados para conexão
    private Connection con = null;
    private Statement stmt = null;
    
    public Procedimento() {
        con = Conecta.getInstance();
    }
    
    //Devolve as especialidades
    public String getEspecialidades(String cod_empresa) {
        
        String sql =  "SELECT codesp, descri FROM especialidade ";
        sql += "WHERE descri <> '' AND cod_empresa=" + cod_empresa;
        sql += " ORDER BY descri";
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
                resp += "<option value='" + rs.getString("codesp") + "'>" + rs.getString("descri") + "</option>\n";
            }
            rs.close();
            stmt.close();
            
            return resp;
        } catch(SQLException e) {
            return e.toString();
        }
    }
    
    //Devolve os grupos de procedimentos
    public String getGruposProcecimentos(String cod_empresa) {
        
        String sql =  "SELECT * FROM grupoprocedimento ";
        sql += "WHERE cod_empresa=" + cod_empresa;
        sql += " ORDER BY grupoproced";
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
                resp += "<option value='" + rs.getString("cod_grupoproced") + "'>" + rs.getString("grupoproced") + "</option>\n";
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
    public String[] getProcedimentos(String pesquisa, String ordem, int numPag, int qtdeporpagina, int tipo, String cod_empresa) {
        String resp[] = {"",""};
        String sql = "";
        String codigo = "";
        ResultSet rs = null;
        
        //Limpa espaços em branco antes e depois da pesquisa
        pesquisa = pesquisa.trim();
        
        sql += "SELECT procedimentos.COD_PROCED, procedimentos.CODIGO,";
        sql += "procedimentos.Procedimento FROM procedimentos ";
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            //Consulta exata
            if(tipo == 1)
                sql += "WHERE (Procedimento='" + pesquisa + "' OR CODIGO='" + pesquisa + "')";
            //Começando com o valor
            else if(tipo == 2)
                sql += "WHERE (Procedimento LIKE '" + pesquisa + "%' OR CODIGO LIKE '" + pesquisa + "%')";
            //Com o valor no meio
            else if(tipo == 3)
                sql += "WHERE (Procedimento LIKE '%" + pesquisa + "%' OR CODIGO LIKE '%" + pesquisa + "%')";
            
            //Filtra pela empresa
            sql += " AND procedimentos.cod_empresa=" + cod_empresa;
            
            //Só os ativos
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
            resp[1] = Util.criaPaginacao("procedimentos.jsp", numPag, qtdeporpagina, numRows);
            
            //Limita para uma quantidade de registros
            sql += " LIMIT " + ((numPag-1)*qtdeporpagina) + "," + qtdeporpagina;
             
            //Executa a pesquisa novamente com o limitador
            rs = stmt.executeQuery(sql);
            
            //Cria looping com a resposta
            while(rs.next()) {
                codigo = rs.getString("CODIGO");
                if(codigo == null) codigo = "";
                
                resp[0] += "<tr onClick=go('procedimentos.jsp?cod=" + rs.getString("COD_PROCED") + "') onMouseOver='trocaCor(this,1);' onMouseOut='trocaCor(this,2);'>";
                resp[0] += "<td width='100' class='tdLight'>" + codigo + "&nbsp;</td>\n";
                resp[0] += "<td class='tdLight'>" + rs.getString("Procedimento") + "</td>\n";
                resp[0] += "</tr>";
            }
            
            //Se não retornar resposta, montar mensagem de não encontrado
            if(resp[0].equals("")) {
                resp[0] += "<tr>";
                resp[0] += "  <td colspan='3' width='600' class='tdLight'>";
                resp[0] += "   Nenhum registro encontrado para a pesquisa";
                resp[0] += "  </td>";
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
        * numPag: número da página selecionada (paginação)
        * qtdeporpagina: quantidade de registros por página
        * tipo: tipo de pesquisa (exata, substring)
        * cod_empresa: código da empresa logada
        */
    public String[] getProcedimentosPesq(String pesquisa, String campo, String ordem, int numPag, int qtdeporpagina, int tipo, String cod_empresa) {
        String resp[] = {"",""};
        String sql = "";
        String paginacao = "";
        String codigo = "";
        ResultSet rs = null;
        
        //Limpa espaços em branco antes e depois da pesquisa
        pesquisa = pesquisa.trim();
        
        sql += "SELECT especialidade.descri, procedimentos.COD_PROCED, procedimentos.CODIGO,";
        sql += "procedimentos.Procedimento FROM especialidade ";
        sql += "RIGHT JOIN procedimentos ON especialidade.codesp = ";
        sql += "procedimentos.codesp ";
        
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
            sql += " AND procedimentos.cod_empresa=" + cod_empresa;
            
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
            resp[1] = Util.criaPaginacao("buscaprocedimentos.jsp", numPag, qtdeporpagina, numRows);
            
            //Limita para uma quantidade de registros
            sql += " LIMIT " + ((numPag-1)*qtdeporpagina) + "," + (numPag*qtdeporpagina);
            
            //Executa a pesquisa novamente com o limitador
            rs = stmt.executeQuery(sql);
            
            //Cria looping com a resposta
            while(rs.next()) {
                codigo = rs.getString("CODIGO");
                if(codigo == null) codigo = "";
                
                resp[0] += "<tr onClick=\"insereProcedimento('" + rs.getString("COD_PROCED") + "','" + rs.getString("Procedimento") + "');\" onMouseOver='trocaCor(this,1);' onMouseOut='trocaCor(this,2);'>";
                resp[0] += "<td width='100' class='tdLight'>" + codigo + "&nbsp;</td>\n";
                resp[0] += "<td width='200' class='tdLight'>" + rs.getString("descri") + "&nbsp;</td>\n";
                resp[0] += "<td width='300' class='tdLight'>" + rs.getString("Procedimento") + "</td>\n";
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
            resp[0] = "Erro:" + e.toString();
            return resp;
        }
    }
    
}