/* Arquivo: Alerta.java
 * Autor: Amilton Souza Martha
 * Criação: 15/01/2008   Atualização: 21/02/2008
 * Obs: Manipula as informações de atendimentos (controle de entrada e saída)
 * Módulo para Hospital Escola de São Carlos
 */

package recursos;
import java.sql.*;
import java.util.Vector;

public class Atendimento {
    //Atributos privados para conexão
    private Connection con = null;
    private Statement stmt = null;
    
    public Atendimento() {
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
    public String[] getAtendimentos(String pesquisa, String campo, String ordem, int numPag, int qtdeporpagina, int tipo, String cod_empresa) {
        String resp[] = {"",""};
        String sql = "";
        ResultSet rs = null;
        
        //Limpa espaços em branco antes e depois da pesquisa
        pesquisa = pesquisa.trim();
        
        sql += "SELECT atendimentos.*, paciente.nome ";
        sql += "FROM atendimentos INNER JOIN paciente ON ";
        sql += "(atendimentos.codcli = paciente.codcli) ";
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
            resp[1] = Util.criaPaginacao("atendimentos.jsp", numPag, qtdeporpagina, numRows);
            
            //Limita para uma quantidade de registros
            sql += " LIMIT " + ((numPag-1)*qtdeporpagina) + "," + qtdeporpagina;
            
            //Executa a pesquisa novamente com o limitador
            rs = stmt.executeQuery(sql);
            
            //Cria looping com a resposta
            while(rs.next()) {
                resp[0] += "<tr onClick=go('atendimentos.jsp?cod=" + rs.getString("cod_atendimento") + "') onMouseOver='trocaCor(this,1);' onMouseOut='trocaCor(this,2);'>";
                resp[0] += " <td width='70' class='tdLight'>" + rs.getString("codigo") + "&nbsp;</td>\n";
                resp[0] += " <td class='tdLight'>" + rs.getString("nome") + "&nbsp;</td>\n";
                resp[0] += " <td width='100' class='tdLight'>" + Util.formataData(rs.getString("data_entrada")) + " " + Util.formataHora(rs.getString("hora_entrada")) + "&nbsp;</td>\n";
                resp[0] += " <td width='100' class='tdLight'>" + Util.formataData(rs.getString("data_saida")) + " " + Util.formataHora(rs.getString("hora_saida")) + "&nbsp;</td>\n";                resp[0] += "</tr>";
            }
            
            //Se não retornar resposta, montar mensagem de não encontrado
            if(resp[0].equals("")) {
                resp[0] += "<tr>";
                resp[0] += " <td width='600' class='tdLight'>";
                resp[0] += "  Nenhum registro encontrado para a pesquisa";
                resp[0] += " </td>";
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

        /* pesquisa: valor a ser pesquisado
        * campo: campo a ser pesquisado
        * ordem: ordem de resposta dos campos
        * numPag: número da página selecionada (paginação)
        * qtdeporpagina: quantidade de registros por página
        * tipo: tipo de pesquisa (exata, substring)
        * cod_empresa: código da empresa logada
        */
    public String[] getEntradasSaidas(String pesquisa, String campo, String ordem, int numPag, int qtdeporpagina, int tipo, String cod_empresa) {
        String resp[] = {"",""};
        String sql = "";
        String paginacao = "";
        ResultSet rs = null;
        
        //Limpa espaços em branco antes e depois da pesquisa
        pesquisa = pesquisa.trim();
        
        sql += "SELECT * FROM entradasaida ";
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
            
            //Só busca os ativos
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
            resp[1] = Util.criaPaginacao("entradasaida.jsp", numPag, qtdeporpagina, numRows);
            
            //Limita para uma quantidade de registros
            sql += " LIMIT " + ((numPag-1)*qtdeporpagina) + "," + qtdeporpagina;
            
            //Executa a pesquisa novamente com o limitador
            rs = stmt.executeQuery(sql);
            
            //Cria looping com a resposta
            while(rs.next()) {
                resp[0] += "<tr onClick=go('entradasaida.jsp?cod=" + rs.getString("cod_entradasaida") + "') onMouseOver='trocaCor(this,1);' onMouseOut='trocaCor(this,2);'>";
                resp[0] += " <td class='tdLight'>" + rs.getString("entradasaida") + "&nbsp;</td>\n";
                resp[0] += " <td width='30' class='tdLight' align='center'>" + rs.getString("tipo") + "&nbsp;</td>\n";
                resp[0] += "</tr>";
            }
            
            //Se não retornar resposta, montar mensagem de não encontrado
            if(resp[0].equals("")) {
                resp[0] += "<tr>";
                resp[0] += " <td width='600' class='tdLight'>";
                resp[0] += "  Nenhum registro encontrado para a pesquisa";
                resp[0] += " </td>";
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
    
    //Lista os locais de entrada/saída
    public String getEntradasSaidas(String tipo, String cod_empresa) {
        String sql  = "SELECT * FROM entradasaida WHERE cod_empresa=";
        sql += cod_empresa + " AND ativo='S' AND tipo='" + tipo + "' ORDER BY entradasaida";
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
                resp += "<option value='" + rs.getString("cod_entradasaida") + "'>" + rs.getString("entradasaida") + "</option>\n";
            }
            rs.close();
            stmt.close();
            
            return resp;
        } catch(SQLException e) {
            return "ERRO: " + e.toString() + " SQL: " + sql;
        }
    }    

    //Captura a descrição de Entrada/Saída de um código
    public String getEntradasSaida(String cod_es) {
        String sql  = "SELECT entradasaida FROM entradasaida WHERE cod_entradasaida=" + cod_es;
        String resp = "";
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            ResultSet rs = null;
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            //Se achou
            if(rs.next()) {
                resp = rs.getString("entradasaida");
            }
            rs.close();
            stmt.close();
            
            return resp;
        } catch(SQLException e) {
            return "ERRO: " + e.toString() + " SQL: " + sql;
        }
    }    

    //Relatório de Atendimentos
    public Vector getRelAtendimentos(String de, String ate, String procedente[], String encaminhado[], String hora1, String hora2, String codcli) {
        //Total de minutos a filtrar
        int min1 = 0, min2 = 0;
        try {
            min1 = Integer.parseInt(hora1) * 60;
            min2 = Integer.parseInt(hora2) * 60;
        } catch (NumberFormatException ex) { }
        
        //Total por paciente, total geral e contador de pacientes
        int totalpaciente = 0, totalgeral = 0, cont = 0;

        //Retorno dos dados
        Vector retorno = new Vector();
        
        //Formata as datas
        de = Util.formataDataInvertida(de);
        ate = Util.formataDataInvertida(ate);
        
        //Para capturar as datas e horas
        String d_e, h_e, d_s, h_s;
        
        //Monta sql para consultaiu
        String sql = "";
        sql += "SELECT paciente.nome, paciente.registro_hospitalar, paciente.localizacao, paciente.codcli, ";
        sql += "atendimentos.hora_entrada, atendimentos.hora_saida, ";
        sql += "atendimentos.data_entrada, atendimentos.data_saida ";
        sql += "FROM atendimentos INNER JOIN paciente ON atendimentos.codcli = paciente.codcli ";
        sql += "WHERE data_entrada BETWEEN '" + de + "' AND '" + ate + "' ";

        //Filtra os procedentes
        sql += " AND atendimentos.procedente IN(" + Util.vetorToString(procedente) + ")"; 

        //Filtra os encaminhados
        //Se não escolheu nenhum, buscar encaminhados vazios
        if(encaminhado == null || encaminhado.length == 0)
            sql += " AND (atendimentos.encaminhado='' OR atendimentos.encaminhado IS NULL)";
        else
            sql += " AND atendimentos.encaminhado IN(" + Util.vetorToString(encaminhado) + ")"; 
        
        //Se veio paciente
        if(!Util.isNull(codcli))
            sql += " AND atendimentos.codcli=" + codcli;
        
        sql += " GROUP BY paciente.codcli, nome, registro_hospitalar, localizacao ";
        sql += "ORDER BY paciente.nome";

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
            
            //Cria looping com a resposta
            while(rs.next()) {
                
                d_e = Util.formataData(rs.getString("data_entrada"));
                h_e = Util.formataHora(rs.getString("hora_entrada"));
                d_s = Util.formataData(rs.getString("data_saida"));
                h_s = Util.formataHora(rs.getString("hora_saida"));
                int diferenca1 = (int)Util.getDifTime(d_e, h_e, d_s, h_s);

                //Se a diferença está no intervalo escolhido
                if(diferenca1 >= min1 && diferenca1 <= min2) {

                    //Incrementa contador de pacientes
                    cont++;

                    resp  = "<table width='90%' cellspading=0 cellspacing=0 border=0 class='table'>\n";
                    resp += " <tr>\n";
                    resp += "   <td class='tdDark'><b>" + rs.getString("nome") + "</b></td>\n";
                    resp += "   <td class='tdDark'>Registro: <b>" + rs.getString("registro_hospitalar") + "</b></td>\n";
                    resp += "   <td class='tdDark'>Prontuário: <b>" + rs.getString("localizacao") + "</b></td>\n";
                    resp += "  </tr>\n";
                    resp += "</table>";
                    resp += "<table width='90%' cellspading=0 cellspacing=0 border=0 class='table'>\n";

                    //Para cada paciente, buscar todos os atendimentos
                    sql  = "SELECT * FROM atendimentos WHERE codcli = " + rs.getString("codcli");
                    sql += " AND data_entrada BETWEEN '" + de + "' AND '" + ate + "' ";

                    //Filtra os procedentes
                    sql += " AND procedente IN(" + Util.vetorToString(procedente) + ")";

                    //Filtra os encaminhados
                    //Se não escolheu nenhum, buscar encaminhados vazios
                    if(encaminhado == null || encaminhado.length == 0)
                        sql += " AND (encaminhado='' OR encaminhado IS NULL)";
                    else
                        sql += " AND encaminhado IN(" + Util.vetorToString(encaminhado) + ")";

                    sql += " ORDER BY atendimentos.codigo";

                    rs2 = stmt2.executeQuery(sql);

                    //Cabeçalho
                    resp += "<tr>\n";
                    resp += " <td class='tdMedium'>Atendimento</td>\n";
                    resp += " <td class='tdMedium'>Entrada</td>\n";
                    resp += " <td class='tdMedium'>Procedente</td>\n";
                    resp += " <td class='tdMedium'>Saída</td>\n";
                    resp += " <td class='tdMedium'>Encaminhado</td>\n";
                    resp += " <td class='tdMedium'>Tempo Decorrido</td>\n";
                    resp += "</tr>\n";

                    //Adiciona cada linha ao retorno
                    retorno.add(resp);

                    //Zera o total por paciente
                    totalpaciente = 0;

                    //Inserir todos os atendimentos no vetor
                    while(rs2.next()) {

                        d_e = Util.formataData(rs2.getString("data_entrada"));
                        h_e = Util.formataHora(rs2.getString("hora_entrada"));
                        d_s = Util.formataData(rs2.getString("data_saida"));
                        h_s = Util.formataHora(rs2.getString("hora_saida"));
                        int diferenca2 = (int)Util.getDifTime(d_e, h_e, d_s, h_s);

                        //Se a diferença está no intervalo escolhido
                        if(diferenca2 >= min1 && diferenca2 <= min2) {

                            resp  = "<tr>\n";
                            resp += " <td class='tdLight'>" + rs2.getString("codigo") + "</td>\n";
                            resp += " <td class='tdLight'>" + d_e + "&nbsp;" + h_e + "</td>\n";
                            resp += " <td class='tdLight'>" + getEntradasSaida(rs2.getString("procedente")) + "&nbsp;</td>\n";
                            resp += " <td class='tdLight'>" + d_s + "&nbsp;" + h_s + "&nbsp;</td>\n";
                            resp += " <td class='tdLight'>" + getEntradasSaida(rs2.getString("encaminhado")) + "&nbsp;</td>\n";
                            resp += " <td class='tdLight' align='center'>" + Util.emHoras(diferenca2) + "</td>\n";
                            resp += "</tr>\n";

                            //Adiciona cada linha ao retorno
                            retorno.add(resp);

                            //Contador por paciente
                            totalpaciente++;
                        }
                    }

                    //Adiciona no total geral
                    totalgeral += totalpaciente;

                    rs2.close();

                    retorno.add("<tr><td colspan=6 class='tdDark'>Total de atendimentos para o paciente: " + totalpaciente + "</td></tr>");
                    retorno.add("</table><br>");
                }
            }
            
            resp  = "<table cellspading=0 cellspacing=0 border=0 class='table'>\n";
            resp += " <tr>\n";
            resp += "   <td class='tdDark'>Total de Pacientes Atendidos: </td>\n";
            resp += "   <td class='tdDark'><b>" + cont + "</b></td>\n";
            resp += "  </tr>\n";
            resp += " <tr>\n";
            resp += "   <td class='tdDark'>Total de Atendimentos Realizados: </td>\n";
            resp += "   <td class='tdDark'><b>" + totalgeral + "</b></td>\n";
            resp += "  </tr>\n";
            resp += "</table>";
                
            retorno.add(resp);
            
            rs.close();
            stmt.close();
            stmt2.close();

            return retorno;
        } catch(SQLException e) {
            retorno.add("ERRO: " + e.toString() + " SQL: " + sql);
            return retorno;
        }
    }
    
    //Relatório de Atendimentos
    public Vector getRelAtendimentosAnalitico(String de, String ate, String ordem) {
        //Total de registros
        int totalpaciente = 0;
        
        //Retorno dos dados
        Vector retorno = new Vector();
        
        //Formata as datas
        de = Util.formataDataInvertida(de);
        ate = Util.formataDataInvertida(ate);
        
        //Para capturar as datas e horas
        String d_e, h_e, d_s, h_s;
        
        //Monta sql para consultaiu
        String sql = "";
        sql += "SELECT paciente.registro_hospitalar, paciente.localizacao, paciente.nome, atendimentos.* ";
        sql += "FROM atendimentos INNER JOIN paciente ON atendimentos.codcli = paciente.codcli ";
        sql += "WHERE data_entrada BETWEEN '" + de + "' AND '" + ate + "' ";
        sql += "ORDER BY " + ordem;

        String resp = "";
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            ResultSet rs = null;
            
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            resp  = "<table border='0' cellspacing='0' cellpadding='0' width='100%'>\n";
            resp += " <tr>\n";
            resp += "  <td class='tdMedium'><a title='Ordenar por Paciente' href=\"Javascript:ordenar('nome')\">Paciente</a></td>\n";
            resp += "  <td class='tdMedium'><a title='Ordenar por Registro' href=\"Javascript:ordenar('registro_hospitalar')\">Registro</a></td>\n";
            resp += "  <td class='tdMedium'>Prontuário</td>\n";
            resp += "  <td class='tdMedium'><a title='Ordenar por nº de atendimento' href=\"Javascript:ordenar('codigo')\">Atendimento</a></td>\n";
            resp += "  <td class='tdMedium'>Entrada</td>\n";
            resp += "  <td class='tdMedium'>Procedente</td>\n";
            resp += "  <td class='tdMedium'>Saída</td>\n";
            resp += "  <td class='tdMedium'>Encaminhado</td>\n";
            resp += "  <td class='tdMedium'>Tempo Decorrido</td>\n";
            resp += " </tr>\n";
            
            retorno.add(resp);
            
            //Cria looping com a resposta
            while(rs.next()) {
                
                d_e = Util.formataData(rs.getString("data_entrada"));
                h_e = Util.formataHora(rs.getString("hora_entrada"));
                d_s = Util.formataData(rs.getString("data_saida"));
                h_s = Util.formataHora(rs.getString("hora_saida"));
                int diferenca = (int)Util.getDifTime(d_e, h_e, d_s, h_s);

                resp  = " <tr>\n";
                resp += "   <td class='tdLight'>" + rs.getString("nome") + "</td>\n";
                resp += "   <td class='tdLight'>" + rs.getString("registro_hospitalar") + "</td>\n";
                resp += "   <td class='tdLight'>" + rs.getString("localizacao") + "</td>\n";
                resp += "   <td class='tdLight'>" + rs.getString("codigo") + "</td>\n";
                resp += "   <td class='tdLight'>" + d_e + "&nbsp;" + h_e + "</td>\n";
                resp += "   <td class='tdLight'>" + getEntradasSaida(rs.getString("procedente")) + "&nbsp;</td>\n";
                resp += "   <td class='tdLight'>" + d_s + "&nbsp;" + h_s + "&nbsp;</td>\n";
                resp += "   <td class='tdLight'>" + getEntradasSaida(rs.getString("encaminhado")) + "&nbsp;</td>\n";
                resp += "   <td class='tdLight' align='center'>" + Util.emHoras(diferenca) + "</td>\n";
                resp += " </tr>\n";

                //Adiciona cada linha ao retorno
                retorno.add(resp);

                //Contador por paciente
                totalpaciente++;
             }
             
            retorno.add("</table><br>");
            
            rs.close();
            stmt.close();

            return retorno;
        } catch(SQLException e) {
            retorno.add("ERRO: " + e.toString() + " SQL: " + sql);
            return retorno;
        }
    }
    
    public static void main(String args[]) {
        Atendimento teste = new Atendimento();
        String a[] = {"1", "5"};
        teste.getRelAtendimentos("01/02/2008", "22/02/2008",a ,null,"0","100","1");
    }
}