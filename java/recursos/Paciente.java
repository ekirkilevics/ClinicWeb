/* Arquivo: Paciente.java
 * Autor: Amilton Souza Martha
 * Criação: 12/09/2005   Atualização: 02/04/2009
 * Obs: Manipula informações do Paciente
 */

package recursos;
import java.sql.*;

public class Paciente {
        
    //Atributos privados para conexão
    private Connection con = null;
    private Statement stmt = null;
    
    public Paciente() {
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
    public String[] getPacientes(String pesquisa, String ordem, int numPag, int qtdeporpagina, int tipo, String cod_empresa) {
        String resp[] = {"",""};
        String sql = "";
        ResultSet rs = null;
        
        //Limpa espaços em branco antes e depois da pesquisa
        pesquisa = pesquisa.trim();
        
        sql  = "SELECT * FROM paciente ";
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            //Consulta exata
            if(tipo == 1)
                sql += "WHERE (nome='" + pesquisa + "' OR registro_hospitalar='" + pesquisa + "')";
            //Começando com o valor
            else if(tipo == 2)
                sql += "WHERE (nome LIKE '" + pesquisa + "%' OR registro_hospitalar LIKE '" + pesquisa + "%')";
            //Com o valor no meio
            else if(tipo == 3)
                sql += "WHERE (nome LIKE '%" + pesquisa + "%' OR registro_hospitalar LIKE '%" + pesquisa + "%')";
            
            //Filtra pela empresa
            sql += " AND cod_empresa=" + cod_empresa;
            
            //Filtra pacientes ativos
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
            resp[1] = Util.criaPaginacao("pacientes.jsp", numPag, qtdeporpagina, numRows);
            
            //Limita para uma quantidade de registros
            sql += " LIMIT " + ((numPag-1)*qtdeporpagina) + "," + qtdeporpagina;
           
            //Executa a pesquisa novamente com o limitador
            rs = stmt.executeQuery(sql);
            
            //Cria looping com a resposta
            while(rs.next()) {
                resp[0] += "<tr onClick=go('pacientes.jsp?cod=" + rs.getString("codcli") + "') onMouseOver='trocaCor(this,1);' onMouseOut='trocaCor(this,2);'>";
                resp[0] += "<td width='70%' class='tdLight'>" + rs.getString("nome") + "&nbsp;</td>\n";
                resp[0] += "<td class='tdLight'>" + Util.formataData(rs.getString("data_nascimento")) + "&nbsp;</td>\n";
                resp[0] += "</tr>";
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
            resp[0] = "SQL=" + sql + " Erro:" + e.toString();
            return resp;
        }
    }

    /* Pega dados básicos do paciente para exibição
     * resp[0] = nascimento
     * resp[1] = foto
     * resp[2] = nome
     * resp[3] = prof_reg do médico responsável
     */
    public String[] getDadosPaciente(String codcli) {
        String resp[] = {"", "", "", ""};
        String sql = "";
        ResultSet rs = null;
        
        //Se não veio informação, retornar vazio
        if(Util.isNull(codcli)) return resp;
        
        sql += "SELECT data_nascimento, foto, nome, prof_reg  ";
        sql += "FROM paciente WHERE codcli=" + codcli;
        
        try {
            //Cria statement para enviar sq6l
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
                  
            rs = stmt.executeQuery(sql);
            
            //se achou o paciente, pegar dados
            if(rs.next()) {
                resp[0] = Util.formataData(rs.getString("data_nascimento"));
                resp[1] = rs.getString("foto") != null ? rs.getString("foto") : "";
                resp[2] = rs.getString("nome");
                resp[3] = Util.trataNulo(rs.getString("prof_reg"),"");;
            }
        }
        catch(SQLException e){
            resp[0] = "ERRO: " + e.toString();
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
    public String[] getPacientesPesq(String pesquisa, String campo, String ordem, int numPag, int qtdeporpagina, int tipo, String cod_empresa) {
        String resp[] = {"",""};
        String sql = "";
        ResultSet rs = null;
        
        //Limpa espaços em branco antes e depois da pesquisa
        pesquisa = pesquisa.trim();
        
        sql += "SELECT paciente.*, convenio.descr_convenio ";
        sql += "FROM paciente LEFT JOIN convenio ON paciente.cod_convenio = convenio.cod_convenio ";
        
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
            sql += " AND paciente.cod_empresa=" + cod_empresa;
            
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
            resp[1] = Util.criaPaginacao("buscapaciente.jsp", numPag, qtdeporpagina, numRows);
            
            //Limita para uma quantidade de registros
            sql += " LIMIT " + ((numPag-1)*qtdeporpagina) + "," + qtdeporpagina;
            
            //Executa a pesquisa novamente com o limitador
            rs = stmt.executeQuery(sql);
            
            //Cria looping com a resposta
            String nome_convenio;
            while(rs.next()) {
                nome_convenio = rs.getString("descr_convenio") != null ? rs.getString("descr_convenio") : "N/C";
                resp[0] += "<tr onClick=\"setarDadosPaciente('" + rs.getString("codcli") + "','" + rs.getString("nome") + "','" + Util.formataData(rs.getString("data_nascimento")) + "'," + rs.getString("cod_convenio") + ",'" + nome_convenio + "');fecharJanelaeAtualizar();\" onMouseOver='trocaCor(this,1);' onMouseOut='trocaCor(this,2);'>";
                resp[0] += "  <td width='70%' class='tdLight'>" + rs.getString("nome") + "&nbsp;</td>\n";
                resp[0] += "  <td class='tdLight'>" + Util.formataData(rs.getString("data_nascimento")) + "&nbsp;</td>\n";
                resp[0] += "</tr>";
            }
            
            //Se não retornar resposta, montar mensagem de não encontrado
            if(resp[0].equals("")) {
                resp[0] += "<tr>";
                resp[0] += "<td colspan='3' width='100%' class='tdLight'>";
                resp[0] += "Nenhum registro encontrado para a pesquisa";
                resp[0] += "</td>";
                resp[0] += "</tr>";
            }
            rs.close();
            stmt.close();
            
            return resp;
            
        } catch(SQLException e) {
            resp[0] = "SQL=" + sql + " Erro:" + e.toString();
            return resp;
        }
    }
    
    //Recupera todos os alertas para criar select box
    public String getAlertas(String cod_empresa) {
        String sql =  "SELECT * FROM alertas WHERE cod_empresa=" + cod_empresa;
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
                resp += "<option value='" + rs.getString("cod_alerta") + "'>" + rs.getString("alerta") + "</option>\n";
            }
            rs.close();
            stmt.close();
            
            return resp;
        } catch(SQLException e) {
            return e.toString();
        }
    }
    
    //Recupera a quantidade de alertas do paciente
    public String getAlertasPaci(String codcli) {
        String sql = "";
        String resp = "";
        ResultSet rs = null;
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            sql += "SELECT COUNT(*) AS contador ";
            sql += "FROM alerta_paciente INNER JOIN alertas ON ";
            sql += "alerta_paciente.cod_alerta = alertas.cod_alerta ";
            sql += "WHERE alerta_paciente.cod_paci='" + codcli + "'";
            
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            //Se contou
            if(rs.next()) {
                resp = rs.getString("contador");
            }
            
            rs.close();
            stmt.close();
            
            return resp;
        } catch(SQLException e) {
            return "ERRO: " + e.toString() + " SQL=" + sql;
        }
    }
    
    //Verifica se existem registros para o paciente
    public String existeRegistros(String codcli) {
        String sql = "";
        ResultSet rs = null;
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            //Executa a pesquisa de lançamentos
            sql = "SELECT * FROM faturas WHERE codcli=" + codcli;
            rs = stmt.executeQuery(sql);
            
            //Verifica se achou algum registro
            if(rs.next()) return "existelancamento";
            
            //Executa a pesquisa de histórias
            sql = "SELECT * FROM historia WHERE codcli=" + codcli;
            rs = stmt.executeQuery(sql);
            
            //Verifica se achou algum registro
            if(rs.next()) return "existehistoria";
            
            rs.close();
            stmt.close();
            
            return "no";
        } catch(SQLException e) {
            return e.toString();
        }
    }

    //Lista as indicações
    public String getIndicacoes(String cod_empresa) {
        String sql  = "SELECT * FROM indicacoes WHERE cod_empresa=";
        sql += cod_empresa + " ORDER BY indicacao";
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
                resp += "<option value='" + rs.getString("cod_indicacao") + "'>" + rs.getString("indicacao") + "</option>\n";
            }
            resp += "<option value='-1'>Outros</option>\n";
            rs.close();
            stmt.close();
            
            return resp;
        } catch(SQLException e) {
            return e.toString();
        }
    }
    
    //Insere um convenio no paciente
    public String insereConvenio(String codcli, String cod_convenio, String cod_plano, String num_associado_convenio, String validade_carteira) {
        String sql  = "";
        Banco bc = new Banco();
        
        //Se não digitou valores, não gravar
        if(Util.isNull(cod_convenio) || Util.isNull(cod_plano)) return "Sem Convênio";
        
        //Verifica se existe cadastro com o mesmo convênio
        sql = "SELECT * FROM paciente_convenio WHERE codcli=" + codcli + " AND cod_convenio=" + cod_convenio;
        String existe = bc.getValor("codcli", sql);
        
        //Se não achou o registro, pode inserir
        if(Util.isNull(existe)) {
            String novo_cod = bc.getNext("paciente_convenio", "cod_pac_conv" );
            sql  = "INSERT INTO paciente_convenio(cod_pac_conv, codcli, cod_convenio, cod_plano, num_associado_convenio, validade_carteira) ";
            sql += "VALUES(" + novo_cod + "," + codcli + "," + cod_convenio + "," + cod_plano + ",'" + num_associado_convenio;
            sql += "','" + Util.formataDataInvertida(validade_carteira) + "')";

            //Retorna o resultado do script
            return bc.executaSQL(sql);
        }
         return "duplicado";

    }

    //Retorna os convênios de um paciente
    public String getConvenios(String codcli) {
        String resp = "";
        String sql = "";
        ResultSet rs = null;
        
        //Se não veio cod. de convênio, retornar vazio
        if(Util.isNull(codcli)) return "";
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            sql += "SELECT convenio.descr_convenio, planos.plano, paciente_convenio.num_associado_convenio, ";
            sql += "paciente_convenio.validade_carteira, paciente_convenio.cod_pac_conv ";
            sql += "FROM (convenio INNER JOIN paciente_convenio ON convenio.cod_convenio = ";
            sql += "paciente_convenio.cod_convenio) LEFT JOIN planos ON paciente_convenio.cod_plano = planos.cod_plano ";
            sql += "WHERE paciente_convenio.codcli=" + codcli + " ORDER BY convenio.descr_convenio";
            
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            String plano = "";
            
            //Cria looping com a resposta
            while(rs.next()) {
                
                plano = !Util.isNull(rs.getString("plano")) ? rs.getString("plano") : "Não identificado";
                
                resp += "<tr>\n";
                resp += "    <td class='tdLight' style='width:200px; word-wrap: break-word'>" + rs.getString("descr_convenio") + "</td>\n";
                resp += "    <td class='tdLight'>" + plano + "</td>\n";
                resp += "    <td class='tdLight'>" + Util.trataNulo(rs.getString("num_associado_convenio"),"N/C") + "</td>\n";
                resp += "    <td class='tdLight'>" + Util.formataData(rs.getString("validade_carteira")) + "&nbsp;</td>\n";
                resp += "    <td class='tdLight' align='center'><a href='Javascript:excluirconvenio(" + rs.getString("cod_pac_conv") + ")' title='Remover Convênio'><img src='images/delete.gif' border=0></a>\n";
                resp += "</tr>\n";
            }
            rs.close();
            stmt.close();
            
            return resp;
        } catch(SQLException e) {
            return "Erro:" + e.toString();
        }
    } 

    //Retorna os convênios de um paciente
    public String getConveniosCombo(String codcli) {
        String resp = "";
        String sql = "";
        ResultSet rs = null;
        boolean temparticular = false;
        
        //Se não veio cod. de convênio, retornar vazio
        if(Util.isNull(codcli)) return "";
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            sql += "SELECT paciente_convenio.cod_plano, paciente_convenio.cod_convenio, convenio.descr_convenio,";
            sql += "planos.plano, paciente_convenio.validade_carteira ";
            sql += "FROM (convenio INNER JOIN paciente_convenio ON convenio.cod_convenio = ";
            sql += "paciente_convenio.cod_convenio) LEFT JOIN planos ON paciente_convenio.cod_plano = planos.cod_plano ";
            sql += "WHERE paciente_convenio.codcli=" + codcli + " ORDER BY convenio.descr_convenio, planos.plano";
            
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            String plano = "", codigo = "";
            
            //Cria looping com a resposta
            while(rs.next()) {
                //Pega o nome do plano e se estiver como -1 é Não Identificado
                plano = !Util.isNull(rs.getString("plano")) ? rs.getString("plano") : "Não identificado";
                
                //Concatena códigos de convênio e plano
                codigo = rs.getString("cod_convenio") + "@" + rs.getString("cod_plano");
                
                //Se tem particular registrado (cód. -1), não incluir na mão
                if(rs.getString("cod_convenio") != null && rs.getString("cod_convenio").equals("-1")) temparticular = true;
                
                //Se o vencimento é menos que hoje,colocar de vermelho
                String datavencimento = Util.formataData(rs.getString("validade_carteira"));
                String datahoje = Util.getData();
                if(Util.getDifDate(datavencimento,datahoje ) > 0) {
                    resp += "<option style='color:red' value='" + codigo;
                    resp += "'>" + rs.getString("descr_convenio") + " (" + plano;
                    resp += " ) Venc.: " + Util.formataData(rs.getString("validade_carteira")) + "</option>\n";
                }
                else {
                    resp += "<option value='" + codigo;
                    resp += "'>" + rs.getString("descr_convenio") + " (" + plano;
                    resp += " ) Venc.: " + Util.formataData(rs.getString("validade_carteira")) + "</option>\n";
                }
            }

            
            //Se ainda não tinha particular registrado, colocar na combo
            if(!temparticular)
                resp += "<option value='-1@-2'>Particular (Particular)</option>\n";
            
            rs.close();
            stmt.close();
            
            
            return resp;
        } catch(SQLException e) {
            return "Erro:" + e.toString();
        }
    } 
    
    //Retorna os convênios de um paciente em forma de radio button
    //[0] = itens
    //[1] = cod_convenio
    public String[] getConveniosRadio(String codcli, String nomecampo, String strcod) {
        String resp[] = {"", ""};
        String sql = "";
        ResultSet rs = null;
        
        //Se não veio cod. de convênio, retornar vazio
        if(Util.isNull(codcli)) return resp;
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            sql += "SELECT paciente_convenio.cod_plano, paciente_convenio.cod_convenio, convenio.descr_convenio, planos.plano ";
            sql += "FROM (convenio INNER JOIN paciente_convenio ON convenio.cod_convenio = ";
            sql += "paciente_convenio.cod_convenio) LEFT JOIN planos ON paciente_convenio.cod_plano = planos.cod_plano ";
            sql += "WHERE paciente_convenio.codcli=" + codcli + " ORDER BY convenio.descr_convenio, planos.plano";
            
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            String plano = "", codigo = "";
            String valor = "", selecionado = "", travado = "";
            
            boolean primeiro = true;

            //Se veio strcod, então é edição, não permitir trocar convênio
            if(!Util.isNull(strcod)) {
                travado = " disabled";
            }

            //Início da combo
            resp[0] += "<select name='" + nomecampo + "' id='" + nomecampo + "' class='caixa' style='width:300px' onChange='Javascript:escolheConvenio(this.value)'" + travado + ">\n";

            //Cria looping com a resposta
            while(rs.next()) {
                
                //Pega o nome do plano e se estiver como -1 é Não Identificado
                plano = !Util.isNull(rs.getString("plano")) ? rs.getString("plano") : "Não identificado";
                
                //Concatena códigos de convênio e plano
                codigo = rs.getString("cod_plano");

                //Se for o primeiro registro, pegar e selecionar
                if(primeiro) {
                    valor = codigo;
                    selecionado = " checked";
                    primeiro = false;
                }
                else
                    selecionado = "";

                //Não adiciona plano particular
                if(rs.getString("cod_convenio") != null && !rs.getString("cod_convenio").equals("-1")) {
                    resp[0] += "<option value='" + codigo + "'" + selecionado + ">" +  rs.getString("descr_convenio") + " (" + plano + ") </option>\n";
                }
            }
            
            //Fim da combo
            resp[0] += "</select>\n";
            
            //Coloca campo oculto
            resp[0] += "<input type='hidden' name='cod_convenio' id='cod_convenio' value='" + valor + "'>\n";
            
            resp[1] = valor;
            rs.close();
            stmt.close();
            
            return resp;
        } catch(SQLException e) {
            resp[0] = "ERRO: " + e.toString() + " SQL: " + sql;
            return resp;
        }
    } 

   //Retorna os convênios de um paciente
    public String getConveniosPlanos(String codcli) {
        String resp = "";
        String sql = "";
        ResultSet rs = null;
        boolean temparticular = false;
        
        //Se não veio cod. de convênio, retornar vazio
        if(Util.isNull(codcli)) return "";
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            sql += "SELECT paciente_convenio.cod_plano, paciente_convenio.cod_convenio, convenio.descr_convenio, ";
            sql += "planos.plano, paciente_convenio.validade_carteira ";
            sql += "FROM (convenio INNER JOIN paciente_convenio ON convenio.cod_convenio = ";
            sql += "paciente_convenio.cod_convenio) LEFT JOIN planos ON paciente_convenio.cod_plano = planos.cod_plano ";
            sql += "WHERE paciente_convenio.codcli=" + codcli + " ORDER BY convenio.descr_convenio, planos.plano";
            
            //Executa a pesquisa
            rs = stmt.executeQuery(sql); 
            
            //Cria looping com a resposta
            while(rs.next()) {
                //Se tem particular registrado (cód. -1), não incluir na mão
                if(rs.getString("cod_convenio") != null && rs.getString("cod_convenio").equals("-1")) temparticular = true;
                
                //Se o vencimento é menos que hoje,colocar de vermelho
                if(Util.getDifDate(Util.formataData(rs.getString("validade_carteira")), Util.getData()) > 0) {
                    resp += "<option style='color:red' value='" + rs.getString("cod_plano");
                    resp += "'>" + rs.getString("descr_convenio") + " (" + (Util.isNull(rs.getString("plano")) ? "Não identificado" : rs.getString("plano"));
                    resp += " ) Venc.: " + Util.formataData(rs.getString("validade_carteira")) + "</option>\n";
                }
                else {
                    resp += "<option value='" + rs.getString("cod_plano");
                    resp += "'>" + rs.getString("descr_convenio") + " (" + (Util.isNull(rs.getString("plano")) ? "Não identificado" : rs.getString("plano"));
                    resp += " ) Venc.: " + Util.formataData(rs.getString("validade_carteira")) + "</option>\n";
                }
            }
            
            //Se ainda não tinha particular registrado, colocar na combo
            if(!temparticular)
                resp += "<option value='-2'>Particular (Particular)</option>\n";
            
            rs.close();
            stmt.close();
            
            
            return resp;
        } catch(SQLException e) {
            return "Erro:" + e.toString();
        }
    } 

    //devolve os planos dos convênios
    //tipo: 1-em combo, 2-em list
    public String getPlanos(String cod_convenio) {
        return getPlanos(cod_convenio, "", "1");
    }

    public String getPlanos(String cod_convenio, String tipo) {
        return getPlanos(cod_convenio, "", tipo);
    }

    //Devolve os planos dos convênios
    public String getPlanos(String cod_convenio, String cod_plano, String tipo) {

        String resp = "";
        
        //se não veio cód. de convênio, voltar vazio
        if(Util.isNull(cod_convenio)){
            //Verifica se é em combo ou list
            if(tipo.equals("1"))
                resp += "<select name='cod_plano' id='cod_plano' class='caixa' style='width:120px'></select>";
            else
                resp += "<select name='cod_plano' id='cod_plano' class='caixa' style='width:170px; height:100px' multiple></select>";

            return resp;
        }
        
        String sql =  "SELECT * FROM planos ";
        sql += "WHERE cod_convenio=" + cod_convenio + " AND ativo='S' ORDER BY plano";
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            ResultSet rs = null;
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            //Verifica se é em combo ou list
            if(Util.isNull(tipo) || tipo.equals("1") || tipo.equalsIgnoreCase("undefined"))
                resp += "<select name='cod_plano' id='cod_plano' class='caixa' style='width:120px'>";
            else
                resp += "<select name='cod_plano' id='cod_plano' class='caixa' style='width:170px; height:100px' multiple>";
            
            //Insere plano não identificado
            resp += "<option value='-1'>Não identificado</option>\n";

            String selected = "";
            
            //Para não dar pau no if debaixo
            if(Util.isNull(cod_plano)) cod_plano = "";

            //Cria looping com a resposta
            while(rs.next()) {
                
                //Se é o mesmo plano
                if(cod_plano.equals(rs.getString("cod_plano")))
                    selected = " selected";
                else
                    selected = "";

                resp += "<option value='" + rs.getString("cod_plano") + "' " + selected + ">" + rs.getString("plano") + "</option>\n";
            }
            
            resp += "</select>\n";
            
            rs.close();
            stmt.close();
            
            return resp;
        } catch(SQLException e) {
            return e.toString();
        }
    }
 
    //Monta combo com todos os profissionais
    public String getProfissionais(String cod_empresa) {
        String resp = "";
        String sql = "";
        ResultSet rs = null;
        
        sql += "SELECT nome, cod, prof_reg FROM profissional ";
        sql += "WHERE ativo='S' AND exibir='S' AND cod_empresa=" + cod_empresa;
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            //Só pega profissionais internos
            sql += " AND locacao='interno' ORDER BY nome";
            
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
            return "ERRO: " + e.toString() + " SQL: " + sql;
        }
    }

    //Insere uma profissão no CBO
    public String insereProfissao(String descr, String cod_empresa) {
        String sql  = "";
        int maiorcod = 0;
        String resp = "";
        
        //Se não digitou valores, não gravar
        if(Util.isNull(descr)) return "Sem descrição";
        
        try {
            //Cria statement para enviar sql e RS
            Statement stmt = con.createStatement();
            ResultSet rs = null;
            
            //Busca o maior valor do banco de dados
            sql = "SELECT CONVERT(MAX(codCBOS), UNSIGNED) AS maior FROM cbo2002";
            rs = stmt.executeQuery(sql);
            
            if(rs.next()) maiorcod = rs.getInt("maior");
            
            //Se já existe sequência de 9999, buscar a última para inserir
            if(maiorcod == 9999) {
                sql = "SELECT MAX(CONVERT(SUBSTR(codCBOS,6), UNSIGNED))+1 AS final FROM cbo2002 WHERE LEFT(codCBOS,4) = '9999'";
                rs = stmt.executeQuery(sql);
                if(rs.next()) {
                    //Captura a sequência
                    String seq = rs.getString("final");

                    resp = "9999-" + Util.formataNumero(seq,2);
                }
            }
            //Se não existir, começar nova sequência
            else {
                resp = "9999-01";
            }
            
            //Insere a profissão no banco de Dados
            sql  = "INSERT INTO cbo2002(codCBOS, cod_empresa, profissao) VALUES('";
            sql += resp + "','" + cod_empresa + "','" + descr + "')";
            String ret = new Banco().executaSQL(sql);
            
            rs.close();
            stmt.close();

            //Se o banco deu erro, retornar
            if(!ret.equals("OK")) return ret;

            return resp;
        } catch(SQLException e) {
            return "ERRO: " + e.toString() + " SQL: " + sql;
        }
    }
    
    //Busca o celular do paciente
    public String getCelularPaciente(String codcli) {
        String resp = "";
        String sql = "";
        ResultSet rs = null;
        
        //Se não veio informação, retornar vazio
        if(Util.isNull(codcli)) return resp;
        
        sql += "SELECT ddd_celular, tel_celular ";
        sql += "FROM paciente WHERE codcli=" + codcli;
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
                  
            rs = stmt.executeQuery(sql);
            
            //se achou o paciente, pegar dados
            if(rs.next()) {
                String ddd = rs.getString("ddd_celular");
                String tel = rs.getString("tel_celular");
                if(!Util.isNull(ddd) && !Util.isNull(tel))
                    resp = ddd + tel;
            }
        }
        catch(SQLException e){
            resp = "ERRO: " + e.toString();
        }
        return resp;
    }

    public static void main(String args[]) {
        Paciente pac = new Paciente();
        
        System.out.println(pac.getConveniosCombo("9654"));
    }
}