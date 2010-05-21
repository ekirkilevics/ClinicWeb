/* Arquivo: Banco.java
 * Autor: Amilton Souza Martha
 * Criação: 06/09/2005   Atualização: 17/06/2009
 * Obs: Manipula o banco com funções básicas
 */

package recursos;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.MalformedURLException;
import java.net.URL;
import java.sql.*;
import java.util.Vector;

public class Banco {
    
    //Atributos privados para conexão
    private Connection con = null;
    private Statement stmt = null;
    
    //Vetor de tabelas que não excluem, apenas trocam o campo ativo para 'N'
    private String tabela_sem_exclusao[] = {"profissional", "t_usuario", "convenio", "exames", "vac_vacinas", "vac_laboratorios","entradasaida","agendamento", "vac_estoque", "paciente", "hospitais", "procedimentos", "planos", "grupoprocedimento"};
    
    //Construtor que cria conexão com o banco
    public Banco() {
        con = Conecta.getInstance();
    }
    
    //Executa uma query sql diretamente
    public String executaSQL(String sql) {
        try {
            //Cria statemente para enviar sql
            Statement st = con.createStatement();
            
            //Executa atualização
            st.executeUpdate(sql);
            
            //Fecha conexão
            st.close();
            
            return "OK";

        } catch(SQLException e) {
            return "ERRO no executaSQL: " + e.toString() + " SQL: " + sql;
        }
    }
    
    //Recupera os dados para montar página do AJAX (sobrecarga sem complemento)
    public Vector getItensAjax(String query, String chave, String campo, String tabela, String cod_empresa) {
        return getItensAjax(query, chave, campo, tabela, cod_empresa, "", "");
    }
    
    //Recupera os dados para montar página do AJAX
    public Vector getItensAjax(String query, String chave, String campo, String tabela, String cod_empresa, String complemento, String prof_reg) {
        
        //comando SQL de busca
        String sql = "";
        
        //Retorna os dados
        Vector resp = new Vector();
        
        //Conta quantos registros encontrou
        int cont=0;
        
        try {
            //Cria nova Statement para o ponteiro não alterar o anterior
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            ResultSet rs = null;
            
            String campos[] = null;
            
            //Se for da tabela de paciente
            if(tabela.equals("paciente")) {
                //Insere data de nascimento
                campos = new String[2];
                campos[0] = campo;
                campos[1] = "data_nascimento";
                
                //Substitui o separador pela vírgula
                campo += ", data_nascimento";
                
                //Coloca ativo no complemento
                complemento = "AND ativo='S' ";
                
                //Filtra pelo médico logado, se tiver vinculado
                if(!Util.isNull(prof_reg))
                    complemento += "AND (prof_reg='' OR prof_reg is null OR prof_reg='" + prof_reg + "')";
            } else {
                campos = new String[1];
                campos[0] = campo;
            }
            
            //Busca os campos
            sql  = "SELECT " + chave + "," + campo + " FROM " + tabela;
            sql += " WHERE " + campos[0] + " LIKE '%" + query + "%' " + complemento;
            
            //Se a tabela é sem exclusão, filtrar somente ativos
            if(pertence(tabela, tabela_sem_exclusao)) {
                sql += " AND ativo='S' ";
            }
            
            //Se veio cod_empresa, colocar no filtro
            if(!Util.isNull(cod_empresa))
                sql += " AND cod_empresa=" + cod_empresa;
            
            sql += " ORDER BY " + campos[0];
            rs = stmt.executeQuery(sql);
            
            //Insere início da tabela
            resp.add("<table cellspacing='0' cellpadding='0' width='100%'>");
            
            //varre o recordset e captura todos os dados
            while(rs.next()) {
                resp.add("<tr onClick=\"setar('" + chave + "','" + campos[0] + "','" + rs.getString(chave) + "','" + rs.getString(campos[0]) + "')\" onMouseOver='trocaCor(this,1);' onMouseOut='trocaCor(this,2);'>");
                for(int i=0; i<campos.length; i++) {
                    resp.add(" <td class='tdLight'>" + Util.formataTexto(rs.getString(campos[i])) + " </td>");
                }
                resp.add("</tr>");
                cont++;
            }
            
            //Se não encontrou registros, colocar mensagem
            if(cont == 0) {
                resp.add("<tr>");
                resp.add(" <td class='tdLight'>Nenhum registro coincidente</td>");
                resp.add("</tr>");
            }
            
            //Finaliza a tabela
            resp.add("</table>");
        } catch(SQLException e){
            resp.add("ERRO: " + e.toString() + " SQL:" + sql);
        }
        
        return resp;
    }
    
    //Recupera os dados dos pacientes com uma data de nascimento
    public Vector getPacientesPorNascimento(String nascimento, String cod_empresa) {
        
        //comando SQL de busca
        String sql = "";
        
        //Retorna os dados
        Vector resp = new Vector();
        
        //Conta quantos registros encontrou
        int cont=0;
        
        try {
            //Cria nova Statement para o ponteiro não alterar o anterior
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            ResultSet rs = null;
            
            //Busca os campos
            sql  = "SELECT nome, codcli FROM paciente ";
            sql += "WHERE data_nascimento='" + Util.formataDataInvertida(nascimento);
            sql += "' AND cod_empresa=" + cod_empresa + " ORDER BY nome";
            rs = stmt.executeQuery(sql);
            
            //Insere início da tabela
            resp.add("<table cellspacing='0' cellpadding='0' width='100%'>");
            
            //varre o recordset e captura todos os dados
            while(rs.next()) {
                resp.add("<tr onClick=\"setar('codcli','nome','" + rs.getString("codcli") + "','" + rs.getString("nome") + "')\" onMouseOver='trocaCor(this,1);' onMouseOut='trocaCor(this,2);'>");
                resp.add(" <td class='tdLight'>" + rs.getString("nome") + "</td>");
                resp.add("</tr>");
                cont++;
            }
            
            //Se não encontrou registros, colocar mensagem
            if(cont == 0) {
                resp.add("<tr>");
                resp.add(" <td class='tdLight'>Nenhum registro coincidente</td>");
                resp.add("</tr>");
            }
            
            
            //Finaliza a tabela
            resp.add("</table>");
        } catch(SQLException e){
            resp.add(e.toString());
        }
        
        return resp;
    }
    
    //Recupera os dados para montar página do AJAX (só para diagnósticos)
    public Vector getItensAjaxDiagnosticos(String query, String seq, String cod_empresa) {
        
        //comando SQL de busca
        String sql = "";
        
        //Retorna os dados
        Vector resp = new Vector();
        
        //Conta quantos registros encontrou
        int cont=0;
        
        try {
            //Cria nova Statement para o ponteiro não alterar o anterior
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            ResultSet rs = null;
            
            //Busca os campos
            sql  = "SELECT DESCRICAO, CID, cod_diag FROM diagnosticos ";
            sql += "WHERE DESCRICAO LIKE '%" + query + "%' OR CID LIKE '%" + query + "%'";
            sql += " AND cod_empresa=" + cod_empresa;
            sql += " ORDER BY DESCRICAO";
            rs = stmt.executeQuery(sql);
            
            //Insere início da tabela
            resp.add("<table cellspacing='0' cellpadding='0' width='100%'>");
            
            //varre o recordset e captura todos os dados
            while(rs.next()) {
                //Se veio do relatório de consulta de CID´s, colocar o CID e não o cod_diag
                if(seq.equals("1") || seq.equals("2"))
                    resp.add("<tr onClick=\"setar('cod_diag" + seq + "','DESCRICAO" + seq + "','" + rs.getString("CID") + "','" + rs.getString("CID") + " - " + rs.getString("DESCRICAO") + "')\" onMouseOver='trocaCor(this,1);' onMouseOut='trocaCor(this,2);'>");
                else
                    resp.add("<tr onClick=\"setar('cod_diag" + seq + "','DESCRICAO" + seq + "','" + rs.getString("cod_diag") + "','" + rs.getString("CID") + " - " + rs.getString("DESCRICAO") + "')\" onMouseOver='trocaCor(this,1);' onMouseOut='trocaCor(this,2);'>");

                resp.add(" <td class='tdLight'>[" + Util.formataTexto(rs.getString("CID") + "] " + rs.getString("DESCRICAO")) + "</td>");
                resp.add("</tr>");
                cont++;
            }
            
            //Se não encontrou registros, colocar mensagem
            if(cont == 0) {
                resp.add("<tr>");
                resp.add(" <td class='tdLight'>Nenhum registro coincidente</td>");
                resp.add("</tr>");
            }
            
            
            //Finaliza a tabela
            resp.add("</table>");
        } catch(SQLException e){
            resp.add(e.toString());
        }
        
        return resp;
    }

    //Recupera os dados para montar página do AJAX (só para diagnósticos)
    public Vector getItensAjaxProcedimentosCompleto(String query, String cod_empresa) {

        //comando SQL de busca
        String sql = "";

        //Retorna os dados
        Vector resp = new Vector();

        //Conta quantos registros encontrou
        int cont=0;

        try {
            //Cria nova Statement para o ponteiro não alterar o anterior
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);

            ResultSet rs = null;

            //Busca os campos
            sql  = "SELECT Procedimento, CODIGO, cod_proced FROM procedimentos ";
            sql += "WHERE Procedimento LIKE '%" + query + "%' OR CODIGO LIKE '%" + query + "%'";
            sql += " AND cod_empresa=" + cod_empresa;
            sql += " ORDER BY Procedimento";
            rs = stmt.executeQuery(sql);

            //Insere início da tabela
            resp.add("<table cellspacing='0' cellpadding='0' width='100%'>");

            //varre o recordset e captura todos os dados
            while(rs.next()) {
                resp.add("<tr onClick=\"setar('COD_PROCED','Procedimento','" + rs.getString("COD_PROCED") + "','[" + rs.getString("CODIGO") + "] " + rs.getString("Procedimento") + "')\" onMouseOver='trocaCor(this,1);' onMouseOut='trocaCor(this,2);'>");
                resp.add(" <td class='tdLight'>[" + Util.formataTexto(rs.getString("CODIGO") + "] " + rs.getString("Procedimento")) + "</td>");
                resp.add("</tr>");
                cont++;
            }

            //Se não encontrou registros, colocar mensagem
            if(cont == 0) {
                resp.add("<tr>");
                resp.add(" <td class='tdLight'>Nenhum registro coincidente</td>");
                resp.add("</tr>");
            }


            //Finaliza a tabela
            resp.add("</table>");
        } catch(SQLException e){
            resp.add(e.toString());
        }

        return resp;
    }

    //Recupera os dados para montar página do AJAX (só para diagnósticos)
    public Vector getItensAjaxPacientesDiagnosticos(String cod_diag, String de, String ate) {
        
        //comando SQL de busca
        String sql = "";
        
        //Retorna os dados
        Vector retorno = new Vector();
        
        String resp = "";
        
        //Formata as Datas
        de = Util.formataDataInvertida(de);
        ate = Util.formataDataInvertida(ate);
        
        //Conta quantos registros encontrou
        int cont=0;
        
        try {
            //Cria nova Statement para o ponteiro não alterar o anterior
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            ResultSet rs = null;
            
            //Busca os campos
            sql  = "SELECT historia.codcli, hist_diagnostico.cod_diag, paciente.nome, historia.DTACON ";
            sql += "FROM (hist_diagnostico INNER JOIN historia ON ";
            sql += "hist_diagnostico.cod_hist = historia.cod_hist) ";
            sql += "INNER JOIN paciente ON historia.codcli = paciente.codcli ";
            sql += "WHERE hist_diagnostico.cod_diag=" + cod_diag + " AND ";
            sql += "historia.DTACON Between '" + de + "' AND '" + ate + "' ";
            sql += "GROUP BY historia.codcli, hist_diagnostico.cod_diag, paciente.nome ";
            sql += "ORDER BY nome";

            rs = stmt.executeQuery(sql);
            
            //Insere início da tabela
            resp = "<table cellspacing='0' cellpadding='0' width='500' class='table'>\n";
            resp += " <tr>\n";
            resp += "  <td class='tdMedium'><b>Paciente</b></td>\n";
            resp += "  <td width='90' class='tdMedium'><b>Data da História</b></td>\n";
            resp += " </tr>\n";
            retorno.add(resp);
            
            //varre o recordset e captura todos os dados
            while(rs.next()) {

                resp  = " <tr>\n";
                resp += "  <td class='tdLight'><a href=\"Javascript:go('historicopac.jsp?codcli=" + rs.getString("codcli") + "')\" title='Ver Histórias'>" + rs.getString("nome") + "</a></td>\n";
                resp += "  <td class='tdLight'>" + Util.formataData(rs.getString("DTACON")) + "</td>\n";
                resp += " </tr>\n";
                retorno.add(resp);
            }
            
            //Finaliza a tabela
            retorno.add("</table>");
        } catch(SQLException e){
            retorno.add("ERRO: " + e.toString() + " SQL: " + sql);
        }
        
        return retorno;
    }

    //Recupera os dados para montar página do AJAX (só para convênios)
    public Vector getItensAjaxConvenios(String query, String cod_empresa) {
        
        //comando SQL de busca
        String sql = "";
        
        //Retorna os dados
        Vector resp = new Vector();
        
        //Conta quantos registros encontrou
        int cont=0;
        
        try {
            //Cria nova Statement para o ponteiro não alterar o anterior
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            ResultSet rs = null;
            
            //Busca os campos
            sql  = "SELECT descr_convenio, cod_convenio, cod_ans, mascaranumconvenio FROM convenio ";
            sql += "WHERE (descr_convenio LIKE '%" + query + "%' OR cod_ans LIKE '%" + query + "%')";
            sql += " AND cod_empresa=" + cod_empresa + " AND ativo='S'";
            sql += " ORDER BY descr_convenio";
            rs = stmt.executeQuery(sql);
            
            //Insere início da tabela
            resp.add("<table cellspacing='0' cellpadding='0' width='100%'>");
            
            //varre o recordset e captura todos os dados
            while(rs.next()) {
                resp.add("<tr onClick=\"setar('cod_convenio','descr_convenio','" + rs.getString("cod_convenio") + "','(" + rs.getString("cod_ans") + ") " + rs.getString("descr_convenio") + "','" + rs.getString("mascaranumconvenio") + "')\" onMouseOver='trocaCor(this,1);' onMouseOut='trocaCor(this,2);'>");
                resp.add(" <td class='tdLight'>(" + Util.formataTexto(rs.getString("cod_ans") + ") " + rs.getString("descr_convenio")) + "</td>");
                resp.add("</tr>");
                cont++;
            }
            
            //Se não encontrou registros, colocar mensagem
            if(cont == 0) {
                resp.add("<tr>");
                resp.add(" <td class='tdLight'>Nenhum registro coincidente</td>");
                resp.add("</tr>");
            }
            
            
            //Finaliza a tabela
            resp.add("</table>");
        } catch(SQLException e){
            resp.add(e.toString());
        }
        
        return resp;
    }

    //Recupera os dados para montar página do AJAX (só para profissões)
    public Vector getItensAjaxProfissoes(String query) {
        
        //comando SQL de busca
        String sql = "";
        
        //Retorna os dados
        Vector resp = new Vector();
        
        //Conta quantos registros encontrou
        int cont=0;
        
        try {
            //Cria nova Statement para o ponteiro não alterar o anterior
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            ResultSet rs = null;
            
            //Busca os campos
            sql  = "SELECT * FROM cbo2002 ";
            sql += "WHERE profissao LIKE '%" + query + "%' OR codCBOS LIKE '%" + query + "%'";
            sql += " ORDER BY profissao";
            rs = stmt.executeQuery(sql);
            
            //Insere início da tabela
            resp.add("<table cellspacing='0' cellpadding='0' width='100%'>");
            
            //varre o recordset e captura todos os dados
            while(rs.next()) {
                resp.add("<tr onClick=\"setar('codCBOS','profissao','" + rs.getString("codCBOS") + "','(" + rs.getString("codCBOS") + ") " + rs.getString("profissao") + "')\" onMouseOver='trocaCor(this,1);' onMouseOut='trocaCor(this,2);'>");
                resp.add(" <td class='tdLight'>(" + Util.formataTexto(rs.getString("codCBOS") + ") " + rs.getString("profissao")) + "</td>");
                resp.add("</tr>");
                cont++;
            }
            
            //Se não encontrou registros, colocar mensagem
            if(cont == 0) {
                resp.add("<tr>");
                resp.add(" <td class='tdLight'>Nenhum registro coincidente</td>");
                resp.add("</tr>");
            }
            
            
            //Finaliza a tabela
            resp.add("</table>");
        } catch(SQLException e){
            resp.add(e.toString());
        }
        
        return resp;
    }

    //Recupera os dados para montar página do AJAX (só para Procedimentos no lançamento financeiro)
    public Vector getItensAjaxProcedimentos(String query, String cod_convenio, String cod_empresa) {
        
        //comando SQL de busca
        String sql = "";
        
        //Retorna os dados
        Vector resp = new Vector();
        
        //Conta quantos registros encontrou
        int cont=0;
        
        //Calcular o valor do procedimento
        float valor = 0;
        
        try {
            //Cria nova Statement para o ponteiro não alterar o anterior
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            ResultSet rs = null;
            
            //Busca os campos
            sql  = "SELECT procedimentos.COD_PROCED, procedimentos.Procedimento, ";
            sql += "valor.valor, convenio.Indice_CH, tabelas.tipo ";
            sql += "FROM (convenio INNER JOIN tabelas ON convenio.Cod_Tabela = ";
            sql += "tabelas.cod_tabela) INNER JOIN (procedimentos INNER JOIN valor ";
            sql += "ON procedimentos.COD_PROCED = valor.cod_proced) ON tabelas.cod_tabela = valor.cod_tabela ";
            sql += "WHERE procedimentos.Procedimento LIKE '%" + query;
            sql += "%' AND convenio.cod_convenio=" + cod_convenio + " AND cod_empresa=" + cod_empresa;
            
            rs = stmt.executeQuery(sql);
            
            //Insere início da tabela
            resp.add("<table cellspacing='0' cellpadding='0' width='100%'>");
            
            //varre o recordset e captura todos os dados
            while(rs.next()) {
                //Se for valor de CH
                if(rs.getString("tipo").equals("2"))
                    valor = rs.getFloat("valor.valor") * rs.getFloat("convenio.Indice_CH");
                else
                    valor = rs.getFloat("valor.valor");
                resp.add("<tr onClick=\"setarprocedimento('" + rs.getString("COD_PROCED") + "','" + rs.getString("Procedimento") + "','" + valor + "')\" onMouseOver='trocaCor(this,1);' onMouseOut='trocaCor(this,2);'>");
                resp.add(" <td class='tdLight'>" + Util.formataTexto(rs.getString("Procedimento")) + "</td>");
                resp.add("</tr>");
                cont++;
            }
            
            //Se não encontrou registros, colocar mensagem
            if(cont == 0) {
                resp.add("<tr>");
                resp.add(" <td class='tdLight'>Nenhum registro coincidente</td>");
                resp.add("</tr>");
            }
            
            //Finaliza a tabela
            resp.add("</table>");
        } catch(SQLException e){
            resp.add("Erro: " + e.toString() + " SQL=" + sql);
        }
        
        return resp;
    }
    
    //Captura o código do profissional médico vinculado ao usuário logado
    public String getProfissional(String cod_usuario) {
        String resp = "";
        String sql = "";
        ResultSet rs = null;
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            //Valores a pegar do banco (menos administrador geral)
            sql  = "SELECT profissional.prof_reg, profissional.nome FROM profissional INNER JOIN t_usuario ON ";
            sql += "profissional.prof_reg = t_usuario.prof_reg WHERE t_usuario.cd_usuario = " + cod_usuario;
            
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            //Cria looping com a resposta
            if(rs.next()) {
                resp = rs.getString("prof_reg");
            } else {
                resp = "";
            }
            
            rs.close();
            stmt.close();
            
            return resp;
        } catch(SQLException e) {
            return "Ocorreu um erro: " + e.toString();
        }
        
    }
    
    /* Método que cria log dos campos */
    public String gerarLog(String tabela, String chave, String id, String dados[], String campos[], String usuario, String tipo) {
        String sql = "OK";
        String valorvelho="", valornovo="";
        
        sql = "SELECT * FROM tabelas WHERE tabela='" + tabela + "'";
        
        try {
            //Cria nova Statement para o ponteiro não alterar o anterior
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            ResultSet rs = null;
            ResultSet rs2 = null;
            
            rs = stmt.executeQuery(sql);
            
            //Se achou o campo, então criar log
            while(rs.next()) {
                
                if(tipo.equals("A")) {
                    //Busca valor antes da alteração
                    rs2 = getRegistro(tabela, chave, id);
                    valorvelho = rs2.getString(rs.getString("campo"));
                    
                    //Captura valor novo que veio
                    valornovo = dados[getIndex(rs.getString("campo"), campos)];
                    
                    //Fecha bancos
                    rs2.close();
                } else if(tipo.equals("E")) {
                    //Busca valor antes da alteração
                    rs2 = getRegistro(tabela, chave, id);
                    
                    //Se existir o registro antigo
                    if(rs2 != null)
                        valorvelho = rs2.getString(rs.getString("campo"));
                    else
                        valorvelho = "";
                    
                    //Na exclusão, valor novo está vazio
                    valornovo = "";
                    
                    //Fecha bancos
                    if(rs2 != null) rs2.close();
                } else {
                    //Na inclusão, valor antigo não existe
                    valorvelho = "";
                    
                    //Captura valor novo que veio
                    valornovo = dados[getIndex(rs.getString("campo"), campos)];
                }
                
                //Remove espaços
                valorvelho = Util.trim(valorvelho);
                valornovo  = Util.trim(valornovo);
                
                //Só registra o log se os valores foram alterados
                if(!valorvelho.equalsIgnoreCase(valornovo)) {
                    
                    //String para inserir no LOG
                    sql =  "INSERT INTO log (data, hora, cod_usuario, chave, tabela, ";
                    sql += "campo,  de, para) ";
                    sql += "VALUES('" + Util.formataDataInvertida(Util.getData());
                    sql += "','" + Util.getHora() + "','" + usuario + "','" + id + "','";
                    sql += tabela + "','" + rs.getString("campo") + "','" + valorvelho;
                    sql += "','" + valornovo + "')";
                    
                    sql = executaSQL(sql);
                }
                
            }
            return "OK";
            
        } catch(SQLException e) {
            return e.toString();
        }
        
    }
    
    //Método para as outras páginas não darem pau
    public String alterarTabela(String tabela, String chave, String id, String dados[], String campos[]) {
        return alterarTabela(tabela, chave, id, dados, campos, "1");
    }
    
    public String alterarTabela(String tabela, String chave, String id, String dados[], String campos[], String usuario) {
        return alterarTabela(tabela, chave, id, dados, campos, null, usuario);
    }
    
    public String alterarTabela(String tabela, String chave, String id, String dados[], String campos[], int camposcript[]) {
        return alterarTabela(tabela, chave, id, dados, campos, camposcript, "1");
    }
       /*
        * tabela: Nome da Tabela a ser alterada
        * chave: nome do campo de chave primária
        * id: identificador do campo que vai ser alterado
        * dados[]: vetor com as informações a alterar
        * campos[]: vetor com o nome dos campos
        * camposcript[]: campos a serem criptografados antes de inserir na base
        */
    public String alterarTabela(String tabela, String chave, String id, String dados[], String campos[], int camposcript[], String usuario) {
        
        String sql = "";
        try {
            int i;
            sql = "UPDATE " + tabela + " SET ";
            
            //Cria statemente para enviar sql
            stmt = con.createStatement();
            
            //Altera todos os dados, exceto o código
            for(i=1; i<dados.length-1; i++) {
                //Se for um campo a criptografar, usar password
                if(pertence(i, camposcript)) {
                    //Se tiver em branco, não alterar
                    if(!Util.trim(dados[i]).equals(""))
                        sql += campos[i] + "=password('" + Util.trim(dados[i]) + "'),";
                } else {
                    //Se o nome do campo for 'idemx' não alterar o seu conteúdo
                    //Se o dado for nulo, não alterar tb
                    if(!campos[i].equals("idemx"))
                        //Se o campos estiver vazio ou nulo, anular
                        if(Util.isNull(dados[i]))
                            sql += campos[i] + "=null,";
                        else
                            sql += campos[i] + "='" + Util.trim(dados[i]) + "',";
                }
            }
            
            //Se o nome do campo for 'idemx' não alterar o seu conteúdo
            //Se o dado for nulo, não alterar tb
            if(!campos[i].equals("idemx")) {
                //Se for um campo a criptografar, usar password
                if(pertence(i, camposcript))
                    sql += campos[i] + "=password('" + Util.trim(dados[i]) + "')";
                else
                    //Se o campos estiver vazio ou nulo, anular
                    if(Util.isNull(dados[i]))
                        sql += campos[i] + "=null";
                    else
                        sql += campos[i] + "='" + Util.trim(dados[i]) + "'";
            } else //Se o último item não for incluído, tirar a vírgula final
                sql = sql.substring(0, sql.length()-1);
            
            sql += " WHERE " + chave + "='" + id + "'";
            
            stmt.executeUpdate(sql);
            stmt.close();
            
            //Sincroniza a tabela em Thread
            new Sincronismo(tabela).start();

            return "OK";
        } catch(SQLException e) {
            return "ERRO ao alterar tabela " + tabela + ": " + e.toString() + " SQL: " + sql;
        }
        
        
    }
    
    /* Verifica se um elemenro pertence ao vetor*/
    public boolean pertence(int num, int vetor[]) {
        //Se o vetor vier nulo, já não existe
        if(vetor == null) return false;
        
        //senão, procura no vetor
        for(int i=0; i<vetor.length; i++)
            if(vetor[i] == num)
                return true;
        
        return false;
    }
    
    public boolean pertence(String num, String vetor[]) {
        //Se o vetor vier nulo, já não existe
        if(vetor == null) return false;
        
        //senão, procura no vetor
        for(int i=0; i<vetor.length; i++)
            if(vetor[i].equalsIgnoreCase(num))
                return true;
        
        return false;
    }
    
    //Retorna o índice onde a String se encontra
    private int getIndex(String valor, String vetor[]) {
        int resp = -1;
        
        for(int i=0; i<vetor.length; i++) {
            if(valor.equalsIgnoreCase(vetor[i]))
                return i;
        }
        
        return resp;
    }
    
    public String excluirTabela(String tabela, String chave, String id) {
        return excluirTabela(tabela, chave, id, "1");
    }
    
       /*
        * tabela: Nome da Tabela a ser excluída
        * chave: nome do campo de chave primária
        * id: identificador do campo que vai ser alterado
        * stmt: conexão
        */
    public String excluirTabela(String tabela, String chave, String id, String usuario) {
        String sql = "";
        
        try {
            //Cria statemente para enviar sql
            stmt = con.createStatement();
            
            //Para essas tabelas, não excluir, apenas não aparece mais na lista
            if(pertence(tabela, tabela_sem_exclusao)) {
                sql = "UPDATE " + tabela + " SET ativo='N' WHERE " + chave + "='" + id + "'";
            } else {
                sql = "DELETE FROM " + tabela + " WHERE " + chave + "='" + id + "'";
            }
            stmt.executeUpdate(sql);
            stmt.close();

            //Sincroniza a tabela em Thread
            new Sincronismo(tabela).start();
            
            return "OK";
        } catch(SQLException e) {
            
            int pos1 = e.toString().indexOf("foreign key constraint fails");
            if(pos1>-1)
                return "Registro não pode ser excluído pois está sendo usado";
            else
                return e.toString();
        }
    }
    
    public String gravarDados(String tabela, String dados[], String campos[]) {
        return gravarDados(tabela, dados, campos, "1");
    }
    
    public String gravarDados(String tabela, String dados[], String campos[], String usuario) {
        return gravarDados(tabela, dados, campos, null, usuario);
    }
    
    public String gravarDados(String tabela, String dados[], String campos[], int camposcript[]) {
        return gravarDados(tabela, dados, campos, camposcript, "1");
    }
    
       /*
        * tabela: Nome da Tabela a ser adicionado dados
        * dados[]: vetor com dados a serem inseridos
        * campos[]: vetor com os nomes dos campos da tabela
        * camposcript[]: vetor com os campos a serem criptografados
        * usuario: usuário que fez a inserção
        */
    //Grava informações no Banco
    public String gravarDados(String tabela, String dados[], String campos[], int camposcript[], String usuario) {
        int i;
        String sql = "";
        
        try {
            //Cria statemente para enviar sql
            stmt = con.createStatement();
            
            sql = "INSERT INTO " + tabela + "(";
            
            //Acumula até o penúltimo campo
            for(i=0; i < campos.length-1; i++) {
                sql += campos[i] + ", ";
            }
            
            //Insere o último sem a vírgula
            sql += campos[i];
            
            //Começa os valores
            sql +=")  VALUES(";
            
            for(i=0; i<campos.length-1; i++) {
                //Se for um campo a criptografar, usar password
                if(pertence(i, camposcript))
                    sql += "password('" + Util.trim(dados[i]) + "'),";
                else
                    //Se estiver vazio ou nulo, anular campo
                    if(Util.isNull(dados[i]))
                        sql += "null,";
                    else
                        sql += "'" + Util.trim(dados[i]) + "',";
            }
            
            //Se for um campo a criptografar, usar password
            if(pertence(i, camposcript))
                sql += "password('" + Util.trim(dados[i]) + "')";
            else
                //Se estiver vazio ou nulo, anular campo
                if(Util.isNull(dados[i]))
                    sql += "null";
                else
                    sql += "'" + Util.trim(dados[i]) + "'";
            
            //Fecha parênteses do VALUES
            sql += ")";
            
            stmt.executeUpdate(sql);
            stmt.close();
            
            //Sincroniza a tabela em Thread
            new Sincronismo(tabela).start();
            
            return "OK";

        } catch(SQLException e) {
            return "ERRO: " + e.toString() + " SQL: " + sql;
        }
        
    }
    
       /*
        * tabela: Nome da Tabela a ser alterada
        * chave: nome do campo de chave primária
        */
    //Retorna o próximo número sequencial da chave primária
    public String getNext(String tabela, String chave) {
        String retorno = "";
        
        try {
            //Cria statemente para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            ResultSet rs = null;
            String sql = "SELECT MAX(" + chave + ")+1 as Contador FROM " + tabela;
            rs = stmt.executeQuery(sql);
            
            if(rs.next())
                retorno = rs.getString("Contador");
            else
                retorno = "1";
            
            //Se for negativo ou zero ou Nulo, começar do 1
            if(Util.isNull(retorno) || Integer.parseInt(retorno)<=0)
                retorno = "1";
            
            rs.close();
            stmt.close();
            
            return retorno;
        } catch(SQLException e) {
            return "1";
        }
    }
    
    
       /*
        * tabela: Nome da Tabela a ser alterada
        * chave: nome do campo de chave primária
        * id: identificador do campo que vai ser alterado
        * dados[]: vetor com as informações a alterar
        * campos[]: vetor com o nome dos campos
        * validar: vetor de inteiros com as posições do vetor campos a validar
        * stmt: conexão
        */
    //Método que verifica se já existe o registro com os dados
    public boolean validaRegistro(String tabela, String chave, String id, String dados[], String campos[], int validar[]) {
        ResultSet rs = null;
        String sql = "";
        String pesq = "";
        boolean resp = false;
        int i;
        
        try {
            //Cria statemente para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            //Concatena os campos a validar
            if(validar.length > 0) {
                for(i=0; i<validar.length-1; i++)
                    pesq += campos[ validar[i] ] + "='" + Util.trim(dados[ validar[i] ]) + "' AND ";
                pesq += campos[ validar[i] ] + "='" + Util.trim(dados[ validar[i] ]) + "'";
            }
            
            //Se vier a chave,  então é alteração e verificar se não existe registro duplicado (além dele mesmo)
            if(id != null && !id.equals(""))
                pesq += " AND " + chave + "<>" + id;
            
            //Se for tabela que não exclui (só alterar status), verificar somente os registros ativos
            if(pertence(tabela, tabela_sem_exclusao)) {
                pesq += " AND ativo='S'";
            }
            
            //Verifica se há ocorrência do registro
            sql = "SELECT * FROM " + tabela + " WHERE " + pesq;
            rs = stmt.executeQuery(sql);
            
            if(rs.next())
                resp = false;
            else
                resp = true;
            
            rs.close();
            stmt.close();
            return resp;
        } catch(Exception e) {
            return false;
        }
    }
    
       /*
        * tabela: Nome da Tabela a ser alterada
        * chave: nome do campo de chave primária
        * cod: código a ser pesquisado
        * con: conexão
        */
    //Método que retorna o ResultSet com os dados do registro
    public ResultSet getRegistro(String tabela,  String chave, int cod) {
        Statement stmt = null;
        ResultSet rs = null;
        String sql = "";
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            sql = "SELECT * FROM " + tabela + " WHERE " + chave + "='" + cod + "'";
            rs = stmt.executeQuery(sql);
            
            if(rs.next()){
                return rs;
            } else {
                return null;
            }
        } catch(SQLException e) {
            return null;
        }
        
    }
    
    //Sobrecarga do método acima para aceitar código String
    public ResultSet getRegistro(String tabela,  String chave, String cod) {
        Statement stmt = null;
        ResultSet rs = null;
        String sql = "";
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            sql = "SELECT * FROM " + tabela + " WHERE " + chave + "='" + cod + "'";
            rs = stmt.executeQuery(sql);
            
            if(rs.next()){
                return rs;
            } else {
                return null;
            }
        } catch(SQLException e) {
            return null;
        }
    }
    
    //Método que retorna se o tipo é o escolhido e retorna o selected
    public String getSel(int tipo, int compara) {
        if(tipo == compara)
            return " selected";
        else
            return " ";
    }
    
    //Recebe o campo e o resultset e retorna o campo
    public String getCampo(String campo, ResultSet rs) {
        
        String resp = "";
        try {
            if(rs == null)
                return "";
            else {
                resp = rs.getString(campo);
                if( Util.isNull(resp))
                    resp = "";
                
                return resp;
            }
        } catch(SQLException e) {
            return e.toString();
        }
    }
    
    
    //Retorna as autorizações de Incluir, Excluir, Alterar e Pesquisar
    //0-Não autorizado    1-Autorizado
    public String[] autorizado(String usuario_id, String nomepagina, String cod_empresa) {
        String sql="", grupoId="", menu_id="";
        String resp[] = {"0","0","0","0"};
        ResultSet rs = null;
        
        //Se for o usuário katu (cód. <= 1), não pesquisar e dar permissão na página (Backdoor)
        if(!Util.isNull(usuario_id) && Integer.parseInt(usuario_id) <= 1) {
            resp[0] = "1";
            resp[1] = "1";
            resp[2] = "1";
            resp[3] = "1";
            return resp;
        }
        
        try {
            
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            /****** Pesquisa qual o grupo que o usuário pertence ******/
            sql = "SELECT ds_grupo FROM t_usuario WHERE cd_usuario = '" + usuario_id + "'";
            rs = stmt.executeQuery(sql);
            
            if(rs.next())
                grupoId = rs.getString("ds_grupo");
            rs.close();
            
            /**********************************************************/
            
            /********** Pesquisa qual o Id da página que está ***********/
            sql  = "SELECT menuId FROM menu WHERE link = '" + getPagina(nomepagina);
            sql += "' AND cod_empresa=" + cod_empresa;
            rs = stmt.executeQuery(sql);
            
            //Se não achou, senta e chora
            if(rs.next())
                menu_id = rs.getString("menuId");
            
            rs.close();
            /**********************************************************/
            
            
            /****** Busca as autorizações parta o grupo e para a página ******/
            //Se a página não está no banco (permissão concedida)
            if(menu_id.equals("")) {
                resp[0] = "1";
                resp[1] = "1";
                resp[2] = "1";
                resp[3] = "1";
            } else {
                sql = "SELECT incluir, excluir, alterar, pesquisar FROM t_permissao WHERE grupoId=" + grupoId + " AND menuId=" + menu_id;
                rs = stmt.executeQuery(sql);
                if(rs.next()) {
                    resp[0] = rs.getString("incluir");
                    resp[1] = rs.getString("excluir");
                    resp[2] = rs.getString("alterar");
                    resp[3] = rs.getString("pesquisar");
                }
                rs.close();
            }
            
            /**********************************************************/
            
            stmt.close();
            return resp;
        } catch(SQLException e) {
            resp[0] = sql;
            resp[1] = e.toString();
            return resp;
        }
    }
    
    public String getPagina(String fulladdress) {
        int barra = fulladdress.lastIndexOf('/');
        return fulladdress.substring(barra+1);
    }
    
    //Retorna um campo específico a partir de um comando SQL
    public String getValor(String campo, String sql) {
        String resp = "";
        ResultSet rs = null;
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            //Busca o valor
            rs = stmt.executeQuery(sql);
            
            if(rs.next())
                resp = rs.getString(campo);
            
            //Se veio nulo, trocar por vazio
            if(resp == null) resp = "";
            
            rs.close();
            stmt.close();
            
            return resp;
            
        } catch(SQLException e) {
            return "ERRO: " + e.toString() + " SQL: " + sql;
        }
    }
    
    public String getValor(String tabela, String campo, String cod_empresa) {
        return getValor(tabela, campo, cod_empresa, "");
    }
    
    //Recupera o valor de um campo específico de uma tabela
    public String getValor(String tabela, String campo, String cod_empresa, String complemento) {
        String resp = "";
        String sql = "";
        ResultSet rs = null;
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            //Busca o valor
            sql = "SELECT " + campo + " FROM " + tabela + " WHERE cod_empresa=" + cod_empresa + " " + complemento;
            rs = stmt.executeQuery(sql);
            
            if(rs.next())
                resp = rs.getString(campo);
            
            //Se veio nulo, trocar por vazio
            if(resp == null) resp = "";
            
            rs.close();
            stmt.close();
            
            return resp;
            
        } catch(SQLException e) {
            return "ERRO: " + e.toString() + " SQL: " + sql;
        }
    }
    
    private String formataValor(String valor) {
            String resp = "";

            //Se não for nulo
            if(!Util.isNull(valor))
                    valor = valor.replace("'", "´");

            if(!Util.isNull(valor))
                    resp = "'" + valor + "',";
            else
                    resp = "null,";

            return resp;
    }
    
    //Transfere os dados do paciente 1 para o paciente 2 e inativa o paciente 1
    public String transfereDados(String codcli1, String codcli2) {
        String sql = "";
        //Se veio nulo, não fazer nada
        if(Util.isNull(codcli1) || Util.isNull(codcli2)) return "";
        
        //Tabelas a alterar
        String tabelas[] = {"agendamento","faturas", "historia", "paciente_convenio", "vac_hist_vacinas"};

       //Passa por todas as tabelas
        for(int i=0; i<tabelas.length; i++) {
            sql = "UPDATE " + tabelas[i] + " SET codcli=" + codcli2 + " WHERE codcli=" + codcli1;
            executaSQL(sql);
        }

        //Depois inativa o paciente1
        sql =  "UPDATE paciente SET ativo='N' WHERE codcli=" + codcli1;
        return executaSQL(sql);
            
    }
  
    public static void main(String args[]) {
        Banco banco = new Banco();
        //String teste = banco.getNext("atendimentos", "codigo");
        //String teste = banco.processaAtualizacao("3.11", "-1");
        //String teste = banco.extraiTabela("INSERT INTO paciente(teste, teste) VALUES('teste', 'teste')");
        //String teste = banco.extraiTabela("UPDATE atualizacoes SET cod_atualizacao=1 WHERE ativo='S'");
        
    }

}