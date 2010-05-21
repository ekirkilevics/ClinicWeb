/* Arquivo: Links.java
 * Autor: Amilton Souza Martha
 * Criação: 09/03/2006   Atualização: 01/10/2008
 * Obs: Manipula as informações de links
 */

package recursos;
import java.sql.*;

public class Links {
    //Atributos privados para conexão
    private Connection con = null;
    private Statement stmt = null;
    
    public Links() {
        con = Conecta.getInstance();
    }
    
    public String getAssuntos(String cod_empresa) {
        String sql =  "SELECT link_assuntos.*,COUNT(links.link) AS total ";
        sql += "FROM links RIGHT JOIN link_assuntos ON ";
        sql += "links.cod_assunto = link_assuntos.cod_assunto ";
        sql += "WHERE cod_empresa=" + cod_empresa;
        sql += " GROUP BY link_assuntos.assunto ";
        sql += "ORDER by assunto";
        
        String resp = "";
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            ResultSet rs = null;
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            resp += "<table cellspacing=0 cellpading=0 width='100%'>\n";
            
            //Cria looping com a resposta
            while(rs.next()) {
                resp += "<tr>\n";
                resp += "<td class='texto'><a href='Javascript: selecionaAssunto(" + rs.getString("cod_assunto") + ")'>" + rs.getString("assunto") + " ( " + rs.getString("total") + " ) </a></td>\n";
                
                //Se tiver o par, mostrar em segunda coluna
                if(rs.next())
                    resp += "<td class='texto'><a href='Javascript: selecionaAssunto(" + rs.getString("cod_assunto") + ")'>" + rs.getString("assunto") + " ( " + rs.getString("total") + " ) </a></td>\n";
                resp += "</tr>\n";
            }
            
            resp += "</table>";
            
            rs.close();
            stmt.close();
            
            return resp;
        } catch(SQLException e) {
            return e.toString();
        }
    }
    
    public String getAssuntosCombo(String cod_empresa) {
        String sql =  "SELECT * FROM link_assuntos WHERE cod_empresa=" + cod_empresa + " ORDER BY assunto";
        
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
                resp += "<option value=" + rs.getString("cod_assunto") + ">" + rs.getString("assunto") + "</option>\n";
            }
            
            
            rs.close();
            stmt.close();
            
            return resp;
        } catch(SQLException e) {
            return e.toString();
        }
    }
    
    //Recupera os links de um assunto
    public String getLinks(String assunto) {
        String sql =  "SELECT * FROM links WHERE cod_assunto=" + assunto + " ORDER BY descricao";
        String resp = "";
        int cont=1;
        
        if(!assunto.equals("")) {
            try {
                //Cria statement para enviar sql
                stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                        ResultSet.CONCUR_READ_ONLY);
                
                ResultSet rs = null;
                //Executa a pesquisa
                rs = stmt.executeQuery(sql);
                
                //Início da Tabela
                resp += "<table cellspacing=0 cellpadding=0 class='table' width='100%'>\n";
                
                //Cria looping com a resposta
                while(rs.next()) {
                    resp += "<tr>\n";
                    resp += "  <td class='tdMedium'><a href=\"Javascript:abreLink('" + rs.getString("link") + "','" + rs.getString("titulo") + "')\"><b>" + cont + "- " + rs.getString("titulo") + "</b></a>&nbsp;</td>\n";
                    resp += "</tr>\n";
                    resp += "<tr>\n";
                    resp += "  <td class='tdLight'>" + rs.getString("descricao")+ "&nbsp;</td>\n";
                    resp += "</tr>\n";
                    cont++;
                }
                
                if(cont == 1) {
                    resp += "<tr>\n";
                    resp += "  <td class='tdLight'>Nenhum link nesse assunto</td>";
                    resp += "</tr>\n";
                }
                
                resp += "</table>";
                
                rs.close();
                stmt.close();
                
                return resp;
            } catch(SQLException e) {
                return sql + " - " + e.toString();
            }
        }
        
        return resp;
    }
    
    
       /* pesquisa: valor a ser pesquisado
        * campo: campo a ser pesquisado
        * ordem: ordem de resposta dos campos
        * numPag: número da página selecionada (paginação)
        * qtdeporpagina: quantidade de registros por página
        * tipo: tipo de pesquisa (exata, substring)
        * cod_empresa: código da empresa logada
        */
    public String[] getAssuntos(String pesquisa, String campo, String ordem, int numPag, int qtdeporpagina, int tipo, String cod_empresa) {
        String resp[] = {"",""};
        String sql = "";
        ResultSet rs = null;
        
        //Limpa espaços em branco antes e depois da pesquisa
        pesquisa = pesquisa.trim();
        
        sql += "SELECT * FROM link_assuntos ";
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
            resp[1] = Util.criaPaginacao("linkassuntos.jsp", numPag, qtdeporpagina, numRows);
            
            //Limita para uma quantidade de registros
            sql += " LIMIT " + ((numPag-1)*qtdeporpagina) + "," + qtdeporpagina;
             
            //Executa a pesquisa novamente com o limitador
            rs = stmt.executeQuery(sql);
            
            //Cria looping com a resposta
            while(rs.next()) {
                resp[0] += "<tr onClick=go('linkassuntos.jsp?cod=" + rs.getString("cod_assunto") + "') onMouseOver='trocaCor(this,1);' onMouseOut='trocaCor(this,2);'>";
                resp[0] += "<td width='100%' class='tdLight'>" + rs.getString("assunto") + "&nbsp;</td>\n";
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
    
       /* pesquisa: valor a ser pesquisado
        * campo: campo a ser pesquisado
        * ordem: ordem de resposta dos campos
        * numPag: número da página selecionada (paginação)
        * qtdeporpagina: quantidade de registros por página
        * tipo: tipo de pesquisa (exata, substring)
        * cod_empresa: código da empresa logada
        */
    public String[] getLinks(String pesquisa, String campo, String ordem, int numPag, int qtdeporpagina, int tipo, String cod_empresa) {
        String resp[] = {"",""};
        String sql = "";
        ResultSet rs = null;
        
        //Limpa espaços em branco antes e depois da pesquisa
        pesquisa = pesquisa.trim();
        
        sql += "SELECT links.* FROM link_assuntos ";
        sql += "INNER JOIN links ON link_assuntos.cod_assunto = ";
        sql += "links.cod_assunto ";
        
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
            sql += " AND link_assuntos.cod_empresa=" + cod_empresa;
            
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
            resp[1] = Util.criaPaginacao("links.jsp", numPag, qtdeporpagina, numRows);
            
            //Limita para uma quantidade de registros
            sql += " LIMIT " + ((numPag-1)*qtdeporpagina) + "," + (numPag*qtdeporpagina);
            
            //Executa a pesquisa novamente com o limitador
            rs = stmt.executeQuery(sql);
            
            //Cria looping com a resposta
            while(rs.next()) {
                resp[0] += "<tr onClick=go('links.jsp?cod=" + rs.getString("cod_link") + "') onMouseOver='trocaCor(this,1);' onMouseOut='trocaCor(this,2);'>";
                resp[0] += "<td width='100%' class='tdLight'>" + rs.getString("titulo") + "&nbsp;</td>\n";
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