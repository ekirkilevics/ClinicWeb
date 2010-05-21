/* Arquivo: Estoque.java
 * Autor: Amilton Souza Martha
 * Criação: 15/11/2007   Atualização: 26/08/2008
 * Obs: Manipula as informações de estoque
 */

package recursos;
import java.sql.*;

public class Estoque {
    //Atributos privados para conexão
    private Connection con = null;
    private Statement stmt = null;
    
    public Estoque() {
        con = Conecta.getInstance();
    }
    
       /* pesquisa: valor a ser pesquisado
        * campo: campo a ser pesquisado
        * ordem: ordem de resposta dos campos
        * numPag: número da página selecionada (paginação)
        * qtdeporpagina: quantidade de registros por página
        * tipo: tipo de pesquisa (exata, substring)
        * cod_empresa: código da empresa logada
        */
    public String[] getEstoques(String pesquisa, String ordem, int numPag, int qtdeporpagina, int tipo, String cod_empresa) {
        String resp[] = {"",""};
        String sql = "";
        ResultSet rs = null;
        
        //Limpa espaços em branco antes e depois da pesquisa
        pesquisa = pesquisa.trim();
        
        sql += "SELECT vac_estoque.cod_estoque, vac_vacinas.descricao, vac_laboratorios.laboratorio, ";
        sql += "vac_estoque.validade, vac_estoque.lote, vac_estoque.qtde_estoque ";
        sql += "FROM vac_laboratorios INNER JOIN (vac_vacinas INNER JOIN vac_estoque ON ";
        sql += "vac_vacinas.cod_vacina = vac_estoque.cod_vacina) ON vac_laboratorios.cod_laboratorio = vac_estoque.cod_laboratorio ";

        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            //Consulta exata
            if(tipo == 1)
                sql += "WHERE (descricao='" + pesquisa + "' OR laboratorio='" + pesquisa + "')";
            //Começando com o valor
            else if(tipo == 2)
                sql += "WHERE (descricao LIKE '" + pesquisa + "%' OR laboratorio LIKE '" + pesquisa + "%')";
            //Com o valor no meio
            else if(tipo == 3)
                sql += "WHERE (descricao LIKE '%" + pesquisa + "%' OR laboratorio LIKE '%" + pesquisa + "%')";
            
            //Só os ativos
            sql += " AND vac_estoque.ativo='S'";
            
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            //Quantidade em estoque
            String qtde = "";

            //Para puxar o estoque
            Vacina vac = new Vacina();

            //Captura a quantidade de linhas
            int numRows = 0;
            while(rs.next()) {
                //Calcula a quantidade para exibir somente os positivos
                qtde = vac.getQuantidadeEstoque(rs.getString("cod_estoque"),null);
                
                //Atualiza a quantidade de estoque
                new Banco().executaSQL("UPDATE vac_estoque SET qtde_estoque=" + qtde + " WHERE cod_estoque=" + rs.getString("cod_estoque"));
                
                if(Integer.parseInt(qtde) > 0 ) {
                    numRows++;
                }
            }
            rs.close();
            
            //Limita para estoques não zerados
            sql += " AND qtde_estoque > 0";
                    
            //Coloca na ordem
            sql += " ORDER BY " + ordem;

            //Limita para uma quantidade de registros
            sql += " LIMIT " + ((numPag-1)*qtdeporpagina) + "," + qtdeporpagina;
            
            //Executa a pesquisa novamente com o limitador
            rs = stmt.executeQuery(sql);
            
            //Cria looping com a resposta
            while(rs.next()) {
                resp[0] += "<tr onClick=go('estoque.jsp?cod=" + rs.getString("cod_estoque") + "') onMouseOver='trocaCor(this,1);' onMouseOut='trocaCor(this,2);'>";
                resp[0] += "<td width='250' class='tdLight'>" + rs.getString("descricao") + "&nbsp;</td>\n";
                resp[0] += "<td class='tdLight'>" + rs.getString("laboratorio") + "&nbsp;</td>\n";
                resp[0] += "<td width='50' class='tdLight'>" + rs.getString("lote") + "&nbsp;</td>\n";
                resp[0] += "<td width='80' class='tdLight'>" + Util.formataData(rs.getString("validade")) + "&nbsp;</td>\n";
                resp[0] += "<td width='40' class='tdLight'>" +  rs.getString("qtde_estoque") + "&nbsp;</td>\n";
                resp[0] += "</tr>";
            }

            //Cria paginação das páginas
            resp[1] = Util.criaPaginacao("estoque.jsp", numPag, qtdeporpagina, numRows);

            //Se não retornar resposta, montar mensagem de não encontrado
            if(resp[0].equals("")) {
                resp[0] += "<tr>";
                resp[0] += "<td colspan='4' width='600' class='tdLight'>";
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

    public String getVacinas(String cod_empresa) {
        String sql  = "SELECT cod_vacina, descricao FROM vac_vacinas WHERE cod_empresa=";
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
                resp += "<option value='" + rs.getString("cod_vacina") + "'>" + rs.getString("descricao") + "</option>\n";
            }
            rs.close();
            stmt.close();
            
            return resp;
        } catch(SQLException e) {
            return e.toString();
        }
    }

    //resp[0] = estoque
    //resp[1] = estoque mínimo
    public int[] getEstoqueVacina(String cod_vacina) {
        String sql  = "";
        int resp[] = new int[2];
        int soma = 0;
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            sql  = "SELECT vac_vacinas.estoque_min, vac_estoque.cod_estoque ";
            sql += "FROM vac_vacinas INNER JOIN vac_estoque ";
            sql += "ON vac_vacinas.cod_vacina = vac_estoque.cod_vacina ";
            sql += "WHERE vac_vacinas.cod_vacina=" + cod_vacina;
            sql += " AND vac_estoque.ativo='S'";

            ResultSet rs = null;
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            Vacina vac = new Vacina();
            
            //Pega a resposta
            while(rs.next()) {
                soma += Integer.parseInt(vac.getQuantidadeEstoque(rs.getString("cod_estoque"),Util.getData()));
                resp[1] = rs.getInt("estoque_min");
            }
            
            resp[0] = soma;
            rs.close();
            stmt.close();
            
            return resp;
        } catch(SQLException e) {
            return resp;
        }
    }

    public String getLaboratorios(String cod_empresa) {
        String sql  = "SELECT cod_laboratorio, laboratorio FROM vac_laboratorios WHERE cod_empresa=";
        sql += cod_empresa + " AND ativo='S' ORDER BY laboratorio";
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
                resp += "<option value='" + rs.getString("cod_laboratorio") + "'>" + rs.getString("laboratorio") + "</option>\n";
            }
            rs.close();
            stmt.close();
            
            return resp;
        } catch(SQLException e) {
            return e.toString();
        }
    }
    
    public static void main(String args[]) {
        Estoque e = new Estoque();
        e.getEstoques("","descricao",1,30,3,"8");
    }

}