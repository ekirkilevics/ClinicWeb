/* Arquivo: Feriado.java
 * Autor: Amilton Souza Martha
 * Criação: 16/07/2007   Atualização: 14/10/2008
 * Obs: Manipula as informações de feriados e dias/horas sem expediente
 */

package recursos;
import java.sql.*;

public class Feriado {
    //Atributos privados para conexão
    private Connection con = null;
    private Statement stmt = null;
    
    public Feriado() {
        con = Conecta.getInstance();
    }
    
    //Monta combo com todos os profissionais
    public String getProfissionais(String cod_empresa) {
        String resp = "";
        String sql = "";
        ResultSet rs = null;
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            sql += "SELECT nome, cod, prof_reg FROM profissional ";
            sql += "WHERE cod_empresa=" + cod_empresa;
            
            //Só pega profissionais internos
            sql += " AND locacao='interno' and ativo='S' ORDER BY nome";
            
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            //Cria looping com a resposta
            while(rs.next()) {
                resp += "<option value='" + rs.getString("prof_reg") + "'>" + rs.getString("nome") + "</option>\n";
            }
            
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
    public String[] getFeriados(String pesquisa, String ordem, int numPag, int qtdeporpagina, int tipo, String cod_empresa) {
        String resp[] = {"",""};
        String sql = "";
        ResultSet rs = null;
        
        //Limpa espaços em branco antes e depois da pesquisa
        pesquisa = pesquisa.trim();
        
        sql += "SELECT feriados.*, profissional.nome FROM feriados LEFT JOIN profissional ON (";
        sql += "feriados.prof_reg = profissional.prof_reg) ";
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            //Consulta exata
            if(tipo == 1)
                sql += "WHERE descricao='" + pesquisa + "' OR profissional.nome='" + pesquisa + "'";
            //Começando com o valor
            else if(tipo == 2)
                sql += "WHERE descricao LIKE '" + pesquisa + "%' OR profissional.nome LIKE '" + pesquisa + "%'";
            //Com o valor no meio
            else if(tipo == 3)
                sql += "WHERE descricao LIKE '%" + pesquisa + "%' OR profissional.nome LIKE '%" + pesquisa + "%'";
            
            //Filtra pela empresa
            sql += " AND feriados.cod_empresa=" + cod_empresa;
            
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
            resp[1] = Util.criaPaginacao("feriados.jsp", numPag, qtdeporpagina, numRows);
            
            //Limita para uma quantidade de registros
            sql += " LIMIT " + ((numPag-1)*qtdeporpagina) + "," + qtdeporpagina;
             
            //Executa a pesquisa novamente com o limitador
            rs = stmt.executeQuery(sql);
            
            //Cria looping com a resposta
            while(rs.next()) {
                resp[0] += "<tr onClick=go('feriados.jsp?cod=" + rs.getString("cod_feriado") + "') onMouseOver='trocaCor(this,1);' onMouseOut='trocaCor(this,2);'>";
                resp[0] += " <td width='100' class='tdLight'>" + Util.formataData(rs.getString("datainicio")) + "&nbsp;</td>\n";
                resp[0] += " <td width='200' class='tdLight'>" + rs.getString("descricao") + "</td>\n";
                resp[0] += " <td class='tdLight'>" + Util.trataNulo(rs.getString("nome"), "Todos") + "</td>\n";
                resp[0] += "</tr>";
            }
            
            //Se não retornar resposta, montar mensagem de não encontrado
            if(resp[0].equals("")) {
                resp[0] += "<tr>";
                resp[0] += "<td colspan=3 width='600' class='tdLight'>";
                resp[0] += "Nenhum registro encontrado para a pesquisa";
                resp[0] += "</td>";
                resp[0] += "</tr>";
            }
            rs.close();
            stmt.close();
            return resp;
            
        } catch(SQLException e) {
            resp[0] = "ERRO:" + e.toString() + " SQL: " + sql;
            return resp;
        }
    }

    //Insere um bloqueio de agenda
    public String insereBloqueio(String prof_reg, String data, String hora, String cod_empresa) {
        String sql = "";
        
        String prox = new Banco().getNext("feriados", "cod_feriado");

        sql  = "INSERT INTO feriados(cod_feriado, cod_empresa, descricao, prof_reg, datainicio, datafim, ";
        sql += "hora_inicio, hora_fim, diatodo, definitivo) VALUES(" + prox + "," + cod_empresa + ",'";
        sql += "Horário Bloqueado','" + prof_reg + "','" + Util.formataDataInvertida(data) + "','";
        sql += Util.formataDataInvertida(data) + "','" + hora + "','" + hora + "','N','N')";
            
        //Retorno o resultado da execução do script (OK para sucesso)
        return new Banco().executaSQL(sql);
            
    }

    //Remove um bloqueio de agenda se não for intervalo
    public String removeBloqueio(String cod_feriado) {
        String resp = "";
        String sql = "";
        
        try {
            //Cria statement para enviar sql e executa
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            ResultSet rs = null;

            //Busca se o feriado/bloqueio não é intervalo (mesmo dia e mesmo horário)
            sql  = "SELECT * FROM feriados WHERE datainicio=datafim AND hora_inicio=hora_fim ";
            sql += "AND cod_feriado=" + cod_feriado;
            
            rs = stmt.executeQuery(sql);
            
            //Se não for intervalo, excluir, senão, mensagem de erro
            if(rs.next()) {
                resp = new Banco().excluirTabela("feriados", "cod_feriado", cod_feriado);
            }
            else {
                resp = "intervalo";
            }
            stmt.close();
            return resp;
            
        } catch(SQLException e) {
            resp = "ERRO: " + e.toString() + " SQL:" + sql;
            return resp;
        }
    }

    //Verifica se existe agendamento no período escolhido
    public String existeAgendaPeriodo(String dados[]) {
        String resp = "";
        String sql = "";
        
        try {
            //Cria statement para enviar sql e executa
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            ResultSet rs = null;

            sql  = "SELECT * FROM agendamento WHERE data BETWEEN '" + dados[2];
            sql += "' AND '" + dados[3] + "' AND ativo='S' ";
            
            //Se veio horário
            if(!dados[5].equals("00:00") && !dados[6].equals("00:00"))
                sql += " AND hora BETWEEN '" + dados[5] + "' AND '" + dados[6] + "' ";
            
            //Se veio profissional
            if(!dados[4].equals("todos"))
                sql += " AND prof_reg='" + dados[4] + "' ";
            
            rs = stmt.executeQuery(sql);
            
            //Se não for intervalo, excluir, senão, mensagem de erro
            if(rs.next()) {
                resp = "S";
            }
            else {
                resp = "N";
            }
            stmt.close();
            return resp;
            
        } catch(SQLException e) {
            resp = "ERRO: " + e.toString() + " SQL:" + sql;
            return resp;
        }
    }
 
    
}