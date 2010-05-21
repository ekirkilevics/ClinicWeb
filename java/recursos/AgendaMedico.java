/* Arquivo: AgendaMedico.java
 * Autor: Amilton Souza Martha
 * Cria��o: 16/09/2005   Atualiza��o: 26/01/2009
 * Obs: Manipula as informa��es da agenda do m�dico
 */

package recursos;
import java.sql.*;

public class AgendaMedico {
    
    //Atributos privados para conex�o
    private Connection con = null;
    private Statement stmt = null;
    
    public AgendaMedico() {
        con = Conecta.getInstance();
    }
    
    //Recupera os hor�rios de in�cio e fim para o m�dico para o dia da semana
    public String[] getHorario(String prof_reg, String data, int semana) {
        
        String sql =  "SELECT agendamedico.hora_inicio, agendamedico.hora_fim ";
        sql += "FROM agendamedico WHERE ";
        sql += "agendamedico.dia_semana=" + semana + " ";
        sql += "AND agendamedico.vigencia='" + Util.formataDataInvertida(data) + "' ";
        sql += "AND agendamedico.prof_reg='" + prof_reg + "' ";
        sql += "AND hora_inicio > '00:00'";
        
        //Vetor de respostas que come�a com vazio
        String resp[] = {"",""};
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            ResultSet rs = null;
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            //Cria looping com a resposta
            if(rs.next()) {
                resp[0] = !Util.isNull(rs.getString("hora_inicio")) ? rs.getString("hora_inicio").substring(0,5) : "";
                resp[1] = !Util.isNull(rs.getString("hora_fim")) ? rs.getString("hora_fim").substring(0,5) : "";
            }
            
            rs.close();
            stmt.close();
            return resp;
        } catch(SQLException e) {
            resp[0] = "ERRO: " + e.toString();
            return resp;
        }
        
    }
    
    //Recupera os hor�rios de in�cio e fim para o m�dico para o dia da semana
    public String[] getHorarioAlmoco(String prof_reg, String data, int semana) {

        String sql =  "SELECT agendamedico.inicio_almoco, agendamedico.fim_almoco ";
        sql += "FROM agendamedico WHERE ";
        sql += "agendamedico.dia_semana=" + semana + " ";
        sql += "AND agendamedico.vigencia='" + Util.formataDataInvertida(data) + "' ";
        sql += "AND agendamedico.prof_reg='" + prof_reg + "' ";
        sql += "AND inicio_almoco > '00:00'";

        //Vetor de respostas que come�a com vazio
        String resp[] = {"",""};
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);

            ResultSet rs = null;
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);

            //Cria looping com a resposta
            if(rs.next()) {
                resp[0] = !Util.isNull(rs.getString("inicio_almoco")) ? rs.getString("inicio_almoco").substring(0,5) : "";
                resp[1] = !Util.isNull(rs.getString("fim_almoco")) ? rs.getString("fim_almoco").substring(0,5) : "";
            }

            rs.close();
            stmt.close();
            return resp;
        } catch(SQLException e) {
            resp[0] = "ERRO: " + e.toString();
            return resp;
        }

    }

    //Pega as especialidades de um profissional
    public String getProcedimentos(String cod_empresa) {
        String sql =  "SELECT grupoprocedimento.cod_grupoproced, ";
        sql += "grupoprocedimento.grupoproced ";
        sql += "FROM grupoprocedimento ";
        sql += "WHERE grupoprocedimento.cod_empresa=" + cod_empresa;
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
    
    //Pega os procedimentos para um m�dico (prof_reg) para um dia da semana (semana)
    //1-Domingo, 2-Segunda, 3-Ter�a, 4-Quarta, 5-Quinta, 6-Sexta, 7-S�bado
    public String getProcedimentosSemana(int semana, String prof_reg, String data) {
        
        String sql =  "SELECT grupoprocedimento.* FROM (agendamedico ";
        sql += "INNER JOIN agenda_procedimento ON agendamedico.";
        sql += "agenda_id = agenda_procedimento.agenda_id) ";
        sql += "INNER JOIN grupoprocedimento ON agenda_procedimento.";
        sql += "cod_proced = grupoprocedimento.cod_grupoproced ";
        sql += "WHERE ((agendamedico.prof_reg='" + prof_reg;
        sql += "') AND agendamedico.dia_semana=" + semana + ") ";
        sql += "AND agendamedico.vigencia='" + Util.formataDataInvertida(data) + "' ";
        sql += "ORDER BY grupoproced";
        
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
            return "ERRO: " + e.toString() + " SQL: " + sql;
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
    public String[] getConfigAgendas(String pesquisa, String campo, String ordem, int numPag, int qtdeporpagina, int tipo) {
        
        String resp[] = {"",""};
        String sql = "";
        ResultSet rs = null;
        
        //Seleciona somente os m�dicos internos
        sql += "SELECT profissional.nome, agendamedico.vigencia, agendamedico.prof_reg ";
        sql += "FROM agendamedico ";
        sql += "INNER JOIN profissional ON profissional.prof_reg=agendamedico.prof_reg ";
        
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
            
            //Agrupo por profissional
            sql += " GROUP BY profissional.nome, agendamedico.vigencia, agendamedico.prof_reg";
            
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
            resp[1] = Util.criaPaginacao("agendamedico.jsp", numPag, qtdeporpagina, numRows);
            
            //Limita para uma quantidade de registros
            sql += " LIMIT " + ((numPag-1)*qtdeporpagina) + "," + (numPag*qtdeporpagina);
            
            //Executa a pesquisa novamente com o limitador
            rs = stmt.executeQuery(sql);
            
            //Cria looping com a resposta
            while(rs.next()) {
                resp[0] += "<tr onClick=go('agendamedico.jsp?prof_reg=" + rs.getString("prof_reg") + "&data=" + Util.formataData(rs.getString("vigencia")) + "') onMouseOver='trocaCor(this,1);' onMouseOut='trocaCor(this,2);'>";
                resp[0] += "<td width='30%' class='tdLight'>" + Util.formataData(rs.getString("vigencia")) + "&nbsp;</td>\n";
                resp[0] += "<td width='70%' class='tdLight'>" + rs.getString("nome") + "&nbsp;</td>\n";
                resp[0] += "</tr>";
            }
            
            //Se n�o retornar resposta, montar mensagem de n�o encontrado
            if(resp[0].equals("")) {
                resp[0] += "<tr>";
                resp[0] += "<td colspan='2' width='100%' class='tdLight'>";
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

            //S� pega profissionais internos
            sql += " AND locacao='interno' and ativo='S' ORDER BY nome";

            //Executa a pesquisa
            rs = stmt.executeQuery(sql);

            //Cria looping com a resposta
            while (rs.next()) {
                resp += "<option value='" + rs.getString("prof_reg") + "'>" + rs.getString("nome") + "</option>\n";
            }

            rs.close();
            stmt.close();

            return resp;

        } catch (SQLException e) {
            return "Erro:" + e.toString();
        }
    }
    
    public String removeConfigAgenda(String prof_reg, String data) {
        
        String sql = "";
        //Apaga os procedimentos da agenda
        sql = "DELETE FROM agenda_procedimento WHERE agenda_id IN(SELECT agenda_id FROM agendamedico WHERE prof_reg='" + prof_reg + "' AND vigencia='" + data + "')";
        new Banco().executaSQL(sql);
        
        //Apaga a agenda
        sql = "DELETE FROM agendamedico WHERE prof_reg='" + prof_reg + "' AND vigencia='" + data + "'";
        return new Banco().executaSQL(sql);
    }
    
    
}