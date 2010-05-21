/* Arquivo: Lembrete.java
 * Autor: Amilton Souza Martha
 * Criação: 25/09/2008   Atualização: 25/09/2008
 * Obs: Manipula as informações de lembretes do sistema
 */

package recursos;
import java.sql.*;

public class Lembrete {
    //Atributos privados para conexão
    private Connection con = null;
    private Statement stmt = null;
    
    public Lembrete() {
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
    public String[] getLembretes(String pesquisa, String campo, int numPag, int qtdeporpagina, int tipo, String codcli) {
        String resp[] = {"",""};
        String sql = "";
        ResultSet rs = null;
        
        //Limpa espaços em branco antes e depois da pesquisa
        pesquisa = pesquisa.trim();
        
        sql += "SELECT * FROM lembretes ";

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
            
            //Filtra por usuário
            sql += " AND codcli=" + codcli;
            
            //Coloca na ordem
            sql += " ORDER BY data DESC, hora DESC";
            
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            //Vai para o último registro
            rs.last();
            
            //Captura a quantidade de linhas
            int numRows = rs.getRow();
            rs.close();
            
            //Cria paginação das páginas
            resp[1] = Util.criaPaginacao("lembretespaciente.jsp", numPag, qtdeporpagina, numRows);
            
            //Limita para uma quantidade de registros
            sql += " LIMIT " + ((numPag-1)*qtdeporpagina) + "," + qtdeporpagina;
            
            //Executa a pesquisa novamente com o limitador
            rs = stmt.executeQuery(sql);
            
            //Cria looping com a resposta
            while(rs.next()) {
                resp[0] += "<tr onMouseOver='trocaCor(this,1);' onMouseOut='trocaCor(this,2);'>";
                resp[0] += "<td width='80' class='tdLight'>" + Util.formataData(rs.getString("datacadastro")) + "&nbsp;</td>\n";
                resp[0] += "<td width='80' class='tdLight'>" + Util.formataData(rs.getString("data")) + "&nbsp;</td>\n";
                resp[0] += "<td width='60' class='tdLight'>" + Util.formataHora(rs.getString("hora")) + "&nbsp;</td>\n";
                resp[0] += "<td class='tdLight'>" + rs.getString("lembrete") + "&nbsp;</td>\n";
                resp[0] += "</tr>";
            }
            
            //Se não retornar resposta, montar mensagem de não encontrado
            if(resp[0].equals("")) {
                resp[0] += "<tr>";
                resp[0] += " <td colspan='3' width='600' class='tdLight'>";
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
    
}