/* Arquivo: Convenio.java
 * Autor: Amilton Souza Martha
 * Criação: 02/09/2005   Atualização: 17/03/2009
 * Obs: Manipula as informações do convenio
 */

package recursos;
import java.sql.*;

public class Convenio {
    //Atributos privados para conexão
    private Connection con = null;
    private Statement stmt = null;
    
    public Convenio() {
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
    public String[] getConvenios(String pesquisa, String ordem, int numPag, int qtdeporpagina, int tipo, String cod_empresa) {
        
        String resp[] = {"",""};
        String sql = "";
        String paginacao = "";
        ResultSet rs = null;
        String razao = "";
        
        //Limpa espaços em branco antes e depois da pesquisa
        pesquisa = pesquisa.trim();
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            sql = "SELECT cod_convenio, descr_convenio, Razao_social FROM convenio WHERE ";
            
            //Consulta exata
            if(tipo == 1)
                sql += "(Razao_social ='" + pesquisa + "' OR descr_convenio ='" + pesquisa + "' OR cod_ans='" + pesquisa + "')";
            //Começando com o valor
            else if(tipo == 2)
                sql += "(Razao_social LIKE '" + pesquisa + "%' OR descr_convenio LIKE '" + pesquisa + "%' OR cod_ans LIKE '" + pesquisa + "%')";
            //Com o valor no meio
            else if(tipo == 3)
                sql += "(Razao_social LIKE '%" + pesquisa + "%' OR descr_convenio LIKE '%" + pesquisa + "%' OR cod_ans LIKE '%" + pesquisa + "%')";
            
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
            resp[1] = Util.criaPaginacao("convenios.jsp", numPag, qtdeporpagina, numRows);
            
            //Limita para uma quantidade de registros
            sql += " LIMIT " + ((numPag-1)*qtdeporpagina) + "," + qtdeporpagina;
            
            //Executa a pesquisa novamente com o limitador
            rs = stmt.executeQuery(sql);
            
            //Cria looping com a resposta
            while(rs.next()) {
                //Captura a razão social para tratar a exibição
                razao = rs.getString("Razao_social");
                if(razao == null || razao.equals(""))
                    razao = "&nbsp;";
                else
                    razao = razao + "";
                resp[0] += "<tr onClick=go('convenios.jsp?cod=" + rs.getString("cod_convenio") + "') onMouseOver='trocaCor(this,1);' onMouseOut='trocaCor(this,2);'>\n";
                resp[0] += "	<td width='30%' class='tdLight'>" + rs.getString("descr_convenio") + "</td>\n";
                resp[0] += "	<td width='70%' class='tdLight'>" + razao + "</td>\n";
                resp[0] += "</tr>\n";
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
            resp[0] = "Ocorreu um erro: " + e.toString();
            return resp;
        }
    }
    
    //Retorna os planos de um convênio
    public String getPlanos(String cod_convenio) {
        String resp = "";
        String sql = "";
        ResultSet rs = null;
        
        //Se não veio cod. de convênio, retornar vazio
        if(Util.isNull(cod_convenio)) return "";
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            sql += "SELECT * FROM planos WHERE cod_convenio=" + cod_convenio;
            sql += " AND ativo='S' ORDER BY plano";
            
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            //Cria looping com a resposta
            while(rs.next()) {
                resp += "<tr>\n";
                resp += "  <td colspan=5 class='tdLight'>" + rs.getString("plano") + "</td>\n";
                resp += "  <td class='tdLight' align='center'><a href='Javascript:removeplano(" + rs.getString("cod_plano") + ")' title='Remover Plano'><img src='images/delete.gif' border=0></a>\n";
                resp += "</tr>\n";
            }
            rs.close();
            stmt.close();
            
            return resp;
        } catch(SQLException e) {
            return "Erro:" + e.toString();
        }
    }    

    //Cadastra o médico na operadora
    public String cadastraMedico(String cod_convenio, String prof_reg, String codOperadora) {
        String sql = "";
        
        //Se não veio nada, ignorar
        if(Util.isNull(cod_convenio) || Util.isNull(prof_reg) || Util.isNull(codOperadora)) return "";
        
        String prox = new Banco().getNext("prof_convenio", "cod_prof_conv");
        sql  = "INSERT INTO prof_convenio(cod_prof_conv, prof_reg, cod_convenio, codOperadora) ";
        sql += "VALUES(" + prox + ",'" + prof_reg + "'," + cod_convenio + ",'" + codOperadora + "')";

        //Retorno o resultado da execução do script (OK para sucesso)
        return new Banco().executaSQL(sql);

    }    

    //Exclui o médico na operadora
    public String excluiMedico(String cod_med) {
        String sql = "";
        
        //Se não veio nada, ignorar
        if(Util.isNull(cod_med)) return "";
        
        sql  = "DELETE FROM prof_convenio WHERE cod_prof_conv=" + cod_med;
        
        //Retorno o resultado da execução do script (OK para sucesso)
        return new Banco().executaSQL(sql);
    }    

    //Retorna os médicos de um convênio
    public String getMedicos(String cod_convenio) {
        String resp = "";
        String sql = "";
        ResultSet rs = null;
        
        //Se não veio cod. de convênio, retornar vazio
        if(Util.isNull(cod_convenio)) return "";
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            sql += "SELECT profissional.nome, prof_convenio.codOperadora, prof_convenio.cod_prof_conv ";
            sql += "FROM prof_convenio INNER JOIN profissional ON ";
            sql += "profissional.prof_reg = prof_convenio.prof_reg ";
            sql += "WHERE cod_convenio=" + cod_convenio + " ORDER BY nome";
            
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            //Cria looping com a resposta
            while(rs.next()) {
                resp += "<tr>\n";
                resp += "  <td class='tdLight'>" + rs.getString("nome") + "</td>\n";
                resp += "  <td class='tdLight'>" + rs.getString("codOperadora") + "</td>\n";
                resp += "  <td class='tdLight' align='center'><a href='Javascript:removemedico(" + rs.getString("cod_prof_conv") + ")' title='Remover Médico'><img src='images/delete.gif' border=0></a>\n";
                resp += "</tr>\n";
            }
            rs.close();
            stmt.close();
            
            return resp;
        } catch(SQLException e) {
            return "Erro:" + e.toString();
        }
    }    

   //Retorna os bancos da empresa
    public String getBancos(String cod_empresa) {
        String resp = "";
        String sql = "";
        ResultSet rs = null;
        
        //Se não veio cod. de convênio, retornar vazio
        if(Util.isNull(cod_empresa)) return "";
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            sql += "SELECT * FROM bancos WHERE cod_empresa=" + cod_empresa + " ORDER BY banco";
            
            //Carteira
            resp += "<option value='-1'>Carteira</option>\n";

            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            //Cria looping com a resposta
            while(rs.next()) {
                resp += "<option value='" + rs.getString("cod_banco") + "'>";
                resp += rs.getString("banco") + " (" + rs.getString("agencia") + ":" + rs.getString("conta");
                resp += ") </option>\n";
            }
            rs.close();
            stmt.close();
            
            return resp;
        } catch(SQLException e) {
            return "Erro:" + e.toString();
        }
    }    
    
}