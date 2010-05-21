/* Arquivo: Exame.java
 * Autor: Amilton Souza Martha
 * Criação: 28/10/2007   Atualização: 04/05/2009
 * Obs: Manipula as informações de exames
 */

package recursos;
import java.sql.*;

public class Exame {
    //Atributos privados para conexão
    private Connection con = null;
    private Statement stmt = null;
    
    public Exame() {
        con = Conecta.getInstance();
    }
    
    //Retorna os exames cadastrados, as unidades e os links
    public String[] getExames(String cod_empresa) {
        String sql  = "SELECT * FROM exames WHERE cod_empresa=";
        sql += cod_empresa + " AND ativo='S' ORDER BY exame";

        String resp[] = {"","'","'"};
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            ResultSet rs = null;
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            //Cria looping com a resposta
            while(rs.next()) {
                resp[0] += "<option value='" + rs.getString("cod_exame") + "'>" + rs.getString("exame") + "</option>\n";
                resp[1] += Util.trataNulo(rs.getString("unidade"),"") + " (" + Util.trataNulo(rs.getString("minimo"),"") + "-" + Util.trataNulo(rs.getString("maximo"),"") + ")','";
                resp[2] += Util.trataNulo(rs.getString("pagina"),"") + "','";
            }
            
            //Tira a última aspas e vírgula
            if(resp[1].length()>2) {
                resp[1] = resp[1].substring(0,resp[1].length()-2);
                resp[2] = resp[2].substring(0,resp[2].length()-2);
            }
            else {
                resp[1] = "''";
                resp[2] = "''";
            }
            
            rs.close();
            stmt.close();
            
            return resp;
        } catch(SQLException e) {
            resp[0] = "ERRO: " + e.toString() + " SQL: " + sql;
            resp[1] = "''";
            resp[2] = "''";
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
    public String[] getExames(String pesquisa, String campo, String ordem, int numPag, int qtdeporpagina, int tipo, String cod_empresa) {
        String resp[] = {"",""};
        String sql = "";
        String paginacao = "";
        ResultSet rs = null;
        
        //Limpa espaços em branco antes e depois da pesquisa
        pesquisa = pesquisa.trim();
        
        sql += "SELECT * FROM exames ";
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
            
            //Filtra os exames ativos
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
            resp[1] = Util.criaPaginacao("exames.jsp", numPag, qtdeporpagina, numRows);
            
            //Limita para uma quantidade de registros
            sql += " LIMIT " + ((numPag-1)*qtdeporpagina) + "," + qtdeporpagina;
            
            //Executa a pesquisa novamente com o limitador
            rs = stmt.executeQuery(sql);
            
            //Cria looping com a resposta
            while(rs.next()) {
                resp[0] += "<tr onClick=go('exames.jsp?cod=" + rs.getString("cod_exame") + "') onMouseOver='trocaCor(this,1);' onMouseOut='trocaCor(this,2);'>";
                resp[0] += "<td width='100%' class='tdLight'>" + rs.getString("exame") + "&nbsp;</td>\n";
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
            resp[0] = "ERRO: " + e.toString() + " SQL: " + sql;
            return resp;
        }
    }

    //Grava o resultado do exame para o paciente
    public String gravarExame(String codcli, String cod_exame, String valor, String data, String obs) {
        String sql = "";
            
        //Pega próx. código
        String prox = new Banco().getNext("resultados", "cod_resultado");

        sql  = "INSERT INTO resultados(cod_resultado, cod_exame, codcli, valor, data, obs) VALUES(";
        sql += prox + "," + cod_exame + "," + codcli + "," + valor + ",'";
        sql += Util.formataDataInvertida(data) + "','" + obs + "')";

        //Retorno o resultado da execução do script (OK para sucesso)
        return new Banco().executaSQL(sql);
    }
    
    public String listaExames(String codcli) {
        String sql  = "";
        //Busca os exames cujo paciente tem resultados
        sql  = "SELECT exames.exame, exames.unidade, exames.cod_exame ";
        sql += "FROM exames INNER JOIN resultados ";
        sql += "ON exames.cod_exame = resultados.cod_exame ";
        sql += "WHERE resultados.codcli=" + codcli;
        sql += " GROUP BY exames.cod_exame ORDER BY exame";
        
        String resp = "";
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);

            //Cria statement para enviar sql
            Statement stmt2 = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            ResultSet rs = null;
            ResultSet rs2 = null;
            
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            resp += "<table cellspacing=0 cellpadding=0 width='95%'>\n";
            
            while(rs.next()) {
                sql  = "SELECT * FROM resultados ";
                sql += "WHERE codcli=" + codcli;
                sql += " AND cod_exame=" + rs.getString("cod_exame");
                sql += " ORDER BY data DESC";
                
                rs2 = stmt2.executeQuery(sql);
                
                resp += "<tr>\n";
                resp += "<td class='tdDark' style='border: 1px solid #111111'>";
                resp += "<a href=\"Javascript:verGrafico(" + rs.getString("cod_exame") + ")\" title='Ver Gráfico'><img src='images/31.gif' border='0'></a>";
                resp += "&nbsp;<b>" + rs.getString("exame") + "</td>\n";
                resp += "</tr>\n";
                resp += "<tr>\n";
                resp += "<td width='100%'>\n";
                resp += "<div style='width:600; height:50; overflow: auto'>\n";
                resp += " <table cellspacing=0 cellpadding=0 width='100%'>\n";
                resp += "   <tr>\n";                
                
                //Monta as datas
                while(rs2.next())
                    resp += "<td class='tdMedium'>" + Util.formataData(rs2.getString("data")) + "<a onMouseover=\"ddrivetip('" + rs2.getString("obs") + "', 250)\" onMouseout=\"hideddrivetip()\"><img src='images/obs.gif' border='0'></a>&nbsp;<a href='Javascript:excluiresultado(" + rs2.getString("cod_resultado") + ")' title='Excluir Resultado'><img src='images/excluirmini.gif' border='0'></a></td>\n";
                
                resp += "</tr><tr>";
                rs2.beforeFirst();
                
                //Monta os valores
                while(rs2.next())
                    resp += "<td class='tdLight'>" + Util.arredondar(rs2.getString("valor"),2,1) + " " + Util.trataNulo(rs.getString("unidade"), "") + "</td>\n";
                 
                resp += "   </tr>\n";
                resp += "  </table>\n";
                resp += "</div>\n";
                resp += "</td>\n";
                resp += "</tr>\n";
            }
            
            resp += "</table>\n";
            
            return resp;
        }
        catch(SQLException e) {
            resp = "ERRO: " + e.toString() + " SQL: " + sql;
        }
        return resp;
    }
}