/* Arquivo: AgendaTelefonica.java
 * Autor: Amilton Souza Martha
 * Criação: 04/03/2009   Atualização: 04/03/2009
 * Obs: Manipula as informações de agenda telefônica
 */

package recursos;
import java.sql.*;

public class AgendaTelefonica {
    //Atributos privados para conexão
    private Connection con = null;
    private Statement stmt = null;

    public AgendaTelefonica() {
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
    public String[] getAgendas(String pesquisa, String ordem, int numPag, int qtdeporpagina, int tipo, String cod_empresa) {
        String resp[] = {"",""};
        String sql = "";
        ResultSet rs = null;

        //Limpa espaços em branco antes e depois da pesquisa
        pesquisa = pesquisa.trim();

        sql += "SELECT * FROM agendatelefonica ";
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);

            //Consulta exata
            if(tipo == 1)
                sql += "WHERE nome='" + pesquisa + "' OR tel1='" + pesquisa + "' OR tel2='" + pesquisa + "' OR tel3='" + pesquisa + "' OR contato1='" + pesquisa + "' OR contato2='" + pesquisa + "' OR contato3='" + pesquisa + "' ";
            //Começando com o valor
            else if(tipo == 2)
                sql += "WHERE nome LIKE '" + pesquisa + "%' OR tel1 LIKE '" + pesquisa + "%' OR tel2 LIKE '" + pesquisa + "%' OR tel3 LIKE '" + pesquisa + "%' OR contato1 LIKE '" + pesquisa + "%' OR contato2 LIKE '" + pesquisa + "%' OR contato3 LIKE '" + pesquisa + "%' ";
            //Com o valor no meio
            else if(tipo == 3)
                sql += "WHERE nome LIKE '%" + pesquisa + "%' OR tel1 LIKE '%" + pesquisa + "%' OR tel2 LIKE '%" + pesquisa + "%' OR tel3 LIKE '%" + pesquisa + "%' OR contato1 LIKE '%" + pesquisa + "%' OR contato2 LIKE '%" + pesquisa + "%' OR contato3 LIKE '%" + pesquisa + "%' ";

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
            resp[1] = Util.criaPaginacao("agendatelefonica.jsp", numPag, qtdeporpagina, numRows);

            //Limita para uma quantidade de registros
            sql += " LIMIT " + ((numPag-1)*qtdeporpagina) + "," + qtdeporpagina;

            //Executa a pesquisa novamente com o limitador
            rs = stmt.executeQuery(sql);

            //Cria looping com a resposta
            while(rs.next()) {
                resp[0] += "<tr onClick=go('agendatelefonica.jsp?cod=" + rs.getString("cod_agenda") + "') onMouseOver='trocaCor(this,1);' onMouseOut='trocaCor(this,2);'>";
                resp[0] += "<td width='100%' class='tdLight'>" + rs.getString("nome") + "&nbsp;</td>\n";
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

}