/* Arquivo: Grupo.java
 * Autor: Amilton Souza Martha
 * Criação: 05/12/2005   Atualização: 05/10/2006
 * Obs: Manipula as informaçoes de grupos de usuários
 */

package recursos;
import java.sql.*;

public class Grupo {
    //Atributos privados para conexão
    private Connection con = null;
    private Statement stmt = null;
    
    public Grupo() {
        con = Conecta.getInstance();
    }
    
    public String getItensMenu(String grupo_id, String cod_empresa) {
        String resp = "";
        String sql = "", sql2 = "";
        String incluir="", excluir="", alterar="", pesquisar="";
        ResultSet rs = null, rs2 = null;
        Statement stmt2 = null;
        int cont=1;
        
        //Pesquisa todas as páginas exceto cadastro de empresas
        sql  = "SELECT * FROM menu WHERE link IS NOT NULL ";
        sql += " AND cod_empresa=" + cod_empresa;
        sql += " ORDER BY item";
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            //Crie segunda conexão para as permissões
            stmt2 = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            resp += "<tr>";
            resp += "<td class='tdMedium'>Item do Menu</td>\n";
            resp += "<td class='tdMedium' style='text-align:center'>Incluir</td>\n";
            resp += "<td class='tdMedium' style='text-align:center'>Excluir</td>\n";
            resp += "<td class='tdMedium' style='text-align:center'>Alterar</td>\n";
            resp += "<td class='tdMedium' style='text-align:center'>Pesquisar</td>\n";
            resp += "<td class='tdMedium' style='text-align:center'>Todos</td>\n";
            resp += "</tr>";
            
            //Cria looping com a resposta
            while(rs.next()) {
                
                if(grupo_id != null && !grupo_id.equals("")) {
                    sql2  = "SELECT incluir, excluir, alterar, pesquisar ";
                    sql2 += "FROM t_permissao WHERE grupoId=" + grupo_id;
                    sql2 += " AND menuId=" + rs.getString("menuId");
                    rs2 = stmt2.executeQuery(sql2);
                    if(rs2.next()) {
                        incluir   = rs2.getInt("incluir") == 1 ? "checked" : "";
                        excluir   = rs2.getInt("excluir") == 1 ? "checked" : "";
                        alterar   = rs2.getInt("alterar") == 1 ? "checked" : "";
                        pesquisar = rs2.getInt("pesquisar") == 1 ? "checked" : "";
                    } else {
                        incluir   = "";
                        excluir   = "";
                        alterar   = "";
                        pesquisar = "";
                    }
                    rs2.close();
                    
                }
                resp += "<tr>";
                resp += "<td class='tdLight'>" + rs.getString("item") + "</td>\n";
                resp += "<td class='tdLight' style='text-align:center'><input type='checkbox' value='1' name='incluir" + cont + "' id='incluir" + cont + "' " + incluir + "></td>\n";
                resp += "<td class='tdLight' style='text-align:center'><input type='checkbox' value='1' name='excluir" + cont + "' id='excluir" + cont + "' " + excluir + "></td>\n";
                resp += "<td class='tdLight' style='text-align:center'><input type='checkbox' value='1' name='alterar" + cont + "' id='alterar" + cont + "' " + alterar + "></td>\n";
                resp += "<td class='tdLight' style='text-align:center'><input type='checkbox' value='1' name='pesquisar" + cont + "' id='pesquisar" + cont + "' " + pesquisar + "></td>\n";
                resp += "<td class='tdMedium' style='text-align:center'><input type='checkbox' name='horizontal" + cont + "' id='horizontal" + cont + "' onClick='Javascript:setarHorizontal(this," + cont + ")'></td>\n";
                resp += "</tr>";
                cont++;
            }
            
            resp += "<tr>";
            resp += "<td class='tdMedium'>Todos<input type='hidden' name='totalmenu' id='totalmenu' value=" + (cont-1) + "></td>\n";
            resp += "<td class='tdMedium' style='text-align:center'><input type='checkbox' name='totincluir' id='totincluir' onClick='setarVertical(this, \"incluir\")'></td>\n";
            resp += "<td class='tdMedium' style='text-align:center'><input type='checkbox' name='totexcluir' id='totexcluir' onClick='setarVertical(this, \"excluir\")'></td>\n";
            resp += "<td class='tdMedium' style='text-align:center'><input type='checkbox' name='totalterar' id='totalterar' onClick='setarVertical(this, \"alterar\")'></td>\n";
            resp += "<td class='tdMedium' style='text-align:center'><input type='checkbox' name='totpesquisar' id='totpesquisar' onClick='setarVertical(this, \"pesquisar\")'></td>\n";
            resp += "<td class='tdMedium' style='text-align:center'><input type='checkbox' onClick='setarTudo(this)'></td>\n";
            resp += "</tr>";
            
            rs.close();
            stmt.close();
            return resp;
            
        } catch(SQLException e) {
            return "Erro:" + e.toString();
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
    public String[] getGrupos(String pesquisa, String campo, String ordem, int numPag, int qtdeporpagina, int tipo, String cod_empresa) {
        String resp[] = {"",""};
        String sql = "";
        String paginacao = "";
        ResultSet rs = null;
        
        //Limpa espaços em branco antes e depois da pesquisa
        pesquisa = pesquisa.trim();
        
        //Não listar grupo administrtador geral
        sql += "SELECT * FROM t_grupos WHERE grupo_id > 1 ";
        
        try {
            
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            //Consulta exata
            if(tipo == 1)
                sql += "AND " + campo + "='" + pesquisa + "'";
            //Começando com o valor
            else if(tipo == 2)
                sql += "AND " + campo + " LIKE '" + pesquisa + "%'";
            //Com o valor no meio
            else if(tipo == 3)
                sql += "AND " + campo + " LIKE '%" + pesquisa + "%'";
            
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
            resp[1] = Util.criaPaginacao("grupos.jsp", numPag, qtdeporpagina, numRows);
            
            //Limita para uma quantidade de registros
            sql += " LIMIT " + ((numPag-1)*qtdeporpagina) + "," + qtdeporpagina;
             
            //Executa a pesquisa novamente com o limitador
            rs = stmt.executeQuery(sql);
            
            //Cria looping com a resposta
            while(rs.next()) {
                resp[0] += "<tr onClick=go('grupos.jsp?cod=" + rs.getString("grupo_id") + "') onMouseOver='trocaCor(this,1);' onMouseOut='trocaCor(this,2);'>";
                resp[0] += "<td width='100%' class='tdLight'>" + rs.getString("grupo") + "&nbsp;</td>\n";
                resp[0] += "</tr>";
            }
            
            //Se não retornar resposta, montar mensagem de não encontrado
            if(resp[0].equals("")) {
                resp[0] += "<tr>";
                resp[0] += "<td width='100%' class='tdLight'>";
                resp[0] += "Nenhum registro encontrado para a pesquisa";
                resp[0] += "</td>";
                resp[0] += "</tr>";
            }
            
            rs.close();
            stmt.close();
            return resp;
            
        } catch(SQLException e) {
            resp[0] = " Erro:" + e.toString();
            return resp;
        }
    }
    
    
    //Retorne ResultSet de Itens do Menu na mesma ordem que foi montado
    public ResultSet getRSItensMenu(String cod_empresa) {
        String resp = "";
        String sql = "";
        ResultSet rs = null;
        int cont=1;
        
        sql  = "SELECT * FROM menu WHERE link IS NOT NULL ";
        sql += " AND item <> 'Empresas'";
        sql += " AND cod_empresa=" + cod_empresa;
        sql += " ORDER BY item";
        
        try {
            
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            return rs;
            
        } catch(SQLException e) {
            return null;
        }
    }
    
}