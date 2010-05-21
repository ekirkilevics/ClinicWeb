/* Arquivo: Protocolo.java
 * Autor: Amilton Souza Martha
 * Criação: 10/11/2008   Atualização: 16/02/2009
 * Obs: Manipula as informações do protocolo de questionários
 */

package recursos;
import java.sql.*;
import java.util.Vector;
import javax.servlet.http.HttpServletRequest;

public class Protocolo {
    //Atributos privados para conexão
    private Connection con = null;
    private Statement stmt = null;
    
    public Protocolo() {
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
    public String[] getQuestoes(String pesquisa, String campo, String ordem, int numPag, int qtdeporpagina, int tipo, String cod_empresa) {
        String resp[] = {"",""};
        String sql = "";
        ResultSet rs = null;
        
        //Limpa espaços em branco antes e depois da pesquisa
        pesquisa = pesquisa.trim();
        
        sql += "SELECT * FROM prot_questoes ";
        
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
            resp[1] = Util.criaPaginacao("questoes.jsp", numPag, qtdeporpagina, numRows);
            
            //Limita para uma quantidade de registros
            sql += " LIMIT " + ((numPag-1)*qtdeporpagina) + "," + qtdeporpagina;
             
            //Executa a pesquisa novamente com o limitador
            rs = stmt.executeQuery(sql);
            
            //Cria looping com a resposta
            while(rs.next()) {
                resp[0] += "<tr onClick=go('questoes.jsp?cod=" + rs.getString("cod_questao") + "') onMouseOver='trocaCor(this,1);' onMouseOut='trocaCor(this,2);'>";
                resp[0] += " <td width='100%' class='tdLight'>" + rs.getString("pergunta") + "&nbsp;</td>\n";
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
            resp[0] = "ERRO:" + e.toString() + " SQL: " + sql;
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
    public String[] getBlocos(String pesquisa, String campo, String ordem, int numPag, int qtdeporpagina, int tipo, String cod_empresa) {
        String resp[] = {"",""};
        String sql = "";
        ResultSet rs = null;
        
        //Limpa espaços em branco antes e depois da pesquisa
        pesquisa = pesquisa.trim();
        
        sql += "SELECT * FROM prot_blocos ";
        
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
            resp[1] = Util.criaPaginacao("blocos.jsp", numPag, qtdeporpagina, numRows);
            
            //Limita para uma quantidade de registros
            sql += " LIMIT " + ((numPag-1)*qtdeporpagina) + "," + qtdeporpagina;
             
            //Executa a pesquisa novamente com o limitador
            rs = stmt.executeQuery(sql);
            
            //Cria looping com a resposta
            while(rs.next()) {
                resp[0] += "<tr onClick=go('blocos.jsp?cod=" + rs.getString("cod_bloco") + "') onMouseOver='trocaCor(this,1);' onMouseOut='trocaCor(this,2);'>";
                resp[0] += " <td width='100%' class='tdLight'>" + rs.getString("bloco") + "&nbsp;</td>\n";
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
            resp[0] = "ERRO:" + e.toString() + " SQL: " + sql;
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
    public String[] getProtocolos(String pesquisa, String campo, String ordem, int numPag, int qtdeporpagina, int tipo, String cod_empresa) {
        String resp[] = {"",""};
        String sql = "";
        ResultSet rs = null;
        
        //Limpa espaços em branco antes e depois da pesquisa
        pesquisa = pesquisa.trim();
        
        sql += "SELECT * FROM prot_protocolos ";
        
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
            resp[1] = Util.criaPaginacao("protocolos.jsp", numPag, qtdeporpagina, numRows);
            
            //Limita para uma quantidade de registros
            sql += " LIMIT " + ((numPag-1)*qtdeporpagina) + "," + qtdeporpagina;
             
            //Executa a pesquisa novamente com o limitador
            rs = stmt.executeQuery(sql);
            
            //Cria looping com a resposta
            while(rs.next()) {
                resp[0] += "<tr onClick=go('protocolos.jsp?cod=" + rs.getString("cod_protocolo") + "') onMouseOver='trocaCor(this,1);' onMouseOut='trocaCor(this,2);'>";
                resp[0] += " <td width='100%' class='tdLight'>" + rs.getString("protocolo") + "&nbsp;</td>\n";
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
            resp[0] = "ERRO:" + e.toString() + " SQL: " + sql;
            return resp;
        }
    }

    //Devolve os itens de uma questão
    public String getItens(String cod_questao) {
        String sql = "";
        String resp = "";
        ResultSet rs = null;
        
        if(Util.isNull(cod_questao)) return "";
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            sql += "SELECT * FROM prot_itens WHERE cod_questao=" + cod_questao;
            sql += " ORDER BY cod_item";
            
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            //Cria looping com a resposta
            while(rs.next()) {
                resp += "<tr>\n";
                resp += "  <td class='tdLight'>" + rs.getString("codigo") + "</td>\n";
                resp += "  <td class='tdLight'>" + rs.getString("item") + "</td>\n";
                resp += "  <td class='tdLight' align='center'><a title='Excluir item' href='Javascript:excluiritem(" + rs.getString("cod_item") + ")'><img src='images/delete.gif' border=0></a></td>\n";
                resp += "</tr>\n";
                
            }
            rs.close();
            stmt.close();
            
            
            return resp;
        } catch(SQLException e) {
            return "ERRO: " + e.toString() + " SQL=" + sql;
        }
    }

    //Devolve as questões cadastradas
    public String getQuestoes(String cod_empresa) {
        String sql = "";
        String resp = "";
        ResultSet rs = null;
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            sql += "SELECT * FROM prot_questoes ORDER BY pergunta";
            
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            //Cria looping com a resposta
            while(rs.next()) {
                resp += "<option value='" + rs.getString("cod_questao") + "'>";
                resp += rs.getString("pergunta");
                resp += "</option>\n";
            }
            rs.close();
            stmt.close();
            
            
            return resp;
        } catch(SQLException e) {
            return "ERRO: " + e.toString() + " SQL=" + sql;
        }
    }

    //Devolve os blocos da empresa
    public String getBlocos(String cod_empresa) {
        String sql = "";
        String resp = "";
        ResultSet rs = null;
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            sql += "SELECT * FROM prot_blocos ORDER BY bloco";
            
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            //Cria looping com a resposta
            while(rs.next()) {
                resp += "<option value='" + rs.getString("cod_bloco") + "'>";
                resp += rs.getString("bloco");
                resp += "</option>\n";
            }
            rs.close();
            stmt.close();
            
            
            return resp;
        } catch(SQLException e) {
            return "ERRO: " + e.toString() + " SQL=" + sql;
        }
    }

    //Devolve os protocolos da empresa
    public String getProtocolos(String cod_empresa) {
        String sql = "";
        String resp = "";
        ResultSet rs = null;
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            sql += "SELECT * FROM prot_protocolos ORDER BY protocolo";
            
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            //Cria looping com a resposta
            while(rs.next()) {
                resp += "<option value='" + rs.getString("cod_protocolo") + "'>";
                resp += rs.getString("protocolo");
                resp += "</option>\n";
            }
            rs.close();
            stmt.close();
            
            
            return resp;
        } catch(SQLException e) {
            return "ERRO: " + e.toString() + " SQL=" + sql;
        }
    }

    //Devolve as questões cadastradas para o bloco
    public String getQuestoesSelecionadas(String cod_bloco) {
        String sql = "";
        String resp = "";
        ResultSet rs = null;
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            sql += "SELECT prot_questoes.pergunta, prot_questoes.cod_questao ";
            sql += "FROM prot_questao_bloco INNER JOIN prot_questoes ON ";
            sql += "prot_questao_bloco.cod_questao = prot_questoes.cod_questao ";
            sql += "WHERE prot_questao_bloco.cod_bloco=" + cod_bloco;
            sql += " ORDER BY ordem";
            
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            //Cria looping com a resposta
            while(rs.next()) {
                resp += "<option value='" + rs.getString("cod_questao") + "'>";
                resp += rs.getString("pergunta");
                resp += "</option>\n";
            }
            rs.close();
            stmt.close();
            
            
            return resp;
        } catch(SQLException e) {
            return "ERRO: " + e.toString() + " SQL=" + sql;
        }
    }

   //Devolve os blocos selecionados no protocolo
    public String getBlocosSelecionados(String cod_protocolo) {
        String sql = "";
        String resp = "";
        ResultSet rs = null;
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            sql += "SELECT prot_blocos.bloco, prot_blocos.cod_bloco ";
            sql += "FROM prot_bloco_protocolo INNER JOIN prot_blocos ON ";
            sql += "prot_bloco_protocolo.cod_bloco = prot_blocos.cod_bloco ";
            sql += "WHERE prot_bloco_protocolo.cod_protocolo=" + cod_protocolo;
            sql += " ORDER BY ordem";
            
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            //Cria looping com a resposta
            while(rs.next()) {
                resp += "<option value='" + rs.getString("cod_bloco") + "'>";
                resp += rs.getString("bloco");
                resp += "</option>\n";
            }
            rs.close();
            stmt.close();
            
            
            return resp;
        } catch(SQLException e) {
            return "ERRO: " + e.toString() + " SQL=" + sql;
        }
    }

    //Insere um item em uma questão
    public String insereItem(String cod_questao, String item, String codigo) {
        String sql = "" ;
        
        //Se não escolheu item, não gravar nada
        if(Util.isNull(item)) return "";
        
        String nextcod = new Banco().getNext("prot_itens","cod_item");

        sql =  "INSERT INTO prot_itens(cod_item, cod_questao, item, codigo) ";
        sql += "VALUES(" + nextcod + "," + cod_questao + ",'" + item + "','" + codigo + "')";

        //Retorno o resultado da execução do script (OK para sucesso)
        return new Banco().executaSQL(sql);
            
    }    

    //Insere um item em uma questão
    public String excluirItem(String cod_item) {
        String sql = "" ;
        
        //Se não escolheu item, não gravar nada
        if(Util.isNull(cod_item)) return "";
        
        //Apaga o registro
        sql =  "DELETE FROM prot_itens WHERE cod_item=" + cod_item;

        //Retorno o resultado da execução do script (OK para sucesso)
        return new Banco().executaSQL(sql);
            
    }    

    //Verifica se um protocolo já foi aplicado e devolve S ou N
    public String getProtocoloAplicado(String cod, String campo) {
        String sql = "";
        String resp = "";
        ResultSet rs = null;
        
        //Se ainda não escolheu o item, não pesquisar
        if(Util.isNull(cod)) return "N";
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            sql += "SELECT prot_aplicacoes.cod_aplicacao ";
            sql += "FROM prot_aplicacoes INNER JOIN (prot_questao_bloco ";
            sql += "INNER JOIN prot_bloco_protocolo ON ";
            sql += "prot_questao_bloco.cod_bloco = prot_bloco_protocolo.cod_bloco) ON ";
            sql += "prot_aplicacoes.cod_protocolo = prot_bloco_protocolo.cod_protocolo ";
            sql += "WHERE " + campo + "=" + cod;

            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            //Se achou resposta é pq foi aplicado
            if(rs.next()) 
                resp = "S";
            else
                resp = "N";
            
            rs.close();
            stmt.close();
            
            return resp;
        } catch(SQLException e) {
            return "ERRO: " + e.toString() + " SQL=" + sql;
        }
    }

    //Pega as questões de um bloco para responder
    private String getQuestao(String cod_protocolo, String cod_questao, String tipo_resposta, String codcli, String data) {
        String sql = "";
        String resp = "";
        ResultSet rs = null;
        
        //Verifica se já existe resposta para essa questão
        Vector resposta = getRespostaQuestao(cod_protocolo, cod_questao, codcli, data);

        //Se não veio nada na resposta, colocar espaço em branco
        if(resposta.size()==0) resposta.add("");
        
        //Se for texto curto
        if(tipo_resposta.equals("3")) {
            resp = "<input type='text' value='" + resposta.get(0) + "' name='resp" + cod_questao + "' id='resp" + cod_questao + "' class='caixa' maxlength='100' style='width:100%'>";
            return resp;
        }
        
        //Se for texto longo
        if(tipo_resposta.equals("4")) {
            resp = "<textarea name='resp" + cod_questao + "' id='resp" + cod_questao + "' class='caixa' style='width:100%' rows='4'>" + resposta.get(0) + "</textarea>";
            return resp;
        }

        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            //Executa a pesquisa
            sql += "SELECT * FROM prot_itens WHERE cod_questao=" + cod_questao + " ORDER BY cod_item";
            rs = stmt.executeQuery(sql);
            
            //Para cada questão, montar para responder
            while(rs.next()) {
                //Se for checkbox
                if(tipo_resposta.equals("1")) {
                    //Se a resposta dada é a que está sendo colocada, checar
                    if(existeValor(rs.getString("codigo"), resposta))
                        resp += "<input type='checkbox' name='resp" + cod_questao + "' id='resp" + cod_questao + "' value='" + rs.getString("codigo") + "' checked>" + rs.getString("item") + "<br>";
                    else
                        resp += "<input type='checkbox' name='resp" + cod_questao + "' id='resp" + cod_questao + "' value='" + rs.getString("codigo") + "'>" + rs.getString("item") + "<br>";
                }
                //Se for option
                if(tipo_resposta.equals("2")) {
                    //Se a resposta dada é a que está sendo colocada, checar
                    if(existeValor(rs.getString("codigo"), resposta))
                        resp += "<input type='radio' name='resp" + cod_questao + "' id='resp" + cod_questao + "' value='" + rs.getString("codigo") + "' checked>" + rs.getString("item") + "<br>";
                    else
                        resp += "<input type='radio' name='resp" + cod_questao + "' id='resp" + cod_questao + "' value='" + rs.getString("codigo") + "'>" + rs.getString("item") + "<br>";
                }
            }
            
            rs.close();
            stmt.close();
            
            return resp;
        } catch(SQLException e) {
            return "ERRO: " + e.toString() + " SQL=" + sql;
        }
    }

    //Pega a resposta de uma questão já respondida
    public Vector getRespostaQuestao(String cod_protocolo, String cod_questao, String codcli, String data) {
        String sql = "";
        Vector resp = new Vector();
        ResultSet rs = null;
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            sql += "SELECT prot_respostas.resposta ";
            sql += "FROM prot_respostas INNER JOIN prot_aplicacoes ON ";
            sql += "prot_respostas.cod_aplicacao = prot_aplicacoes.cod_aplicacao ";
            sql += "WHERE prot_aplicacoes.cod_protocolo=" + cod_protocolo;
            sql += " AND prot_aplicacoes.codcli=" + codcli;
            sql += " AND prot_aplicacoes.data='" + Util.formataDataInvertida(data) + "'";
            sql += " AND prot_respostas.cod_questao=" + cod_questao;

            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            //Se achou resposta é pq foi aplicado
            while(rs.next()) 
                resp.add(rs.getString("resposta"));
            
            rs.close();
            stmt.close();
            
            return resp;
        } catch(SQLException e) {
            resp.add("ERRO: " + e.toString() + " SQL=" + sql);
            return resp;
        }
    }

    //Pega as questões de um bloco para responder
    private String getQuestoesBloco(String cod_protocolo, String cod_bloco, String codcli, String data) {
        String sql = "";
        String resp = "";
        ResultSet rs = null;
        int cont = 1;
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            sql += "SELECT prot_questao_bloco.cod_questao, prot_questoes.pergunta, ";
            sql += "prot_questoes.tipo_resposta ";
            sql += "FROM prot_questao_bloco INNER JOIN prot_questoes ON ";
            sql += "prot_questao_bloco.cod_questao = prot_questoes.cod_questao ";
            sql += "WHERE prot_questao_bloco.cod_bloco=" + cod_bloco;
            sql += " ORDER BY ordem";

            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            //Cabeçalho
            resp += "<table cellspading='0' cellspacing='0' width='100%'>\n";
            
            //Para cada questão, montar para responder
            while(rs.next()) {
                resp += "<tr>\n";
                resp += " <td width='100%' class='tdMedium'><b>" + cont + " - " + rs.getString("pergunta") + "</b></td>\n";
                resp += "</tr>\n";
                resp += "<tr>\n";
                resp += " <td width='100%' class='tdLight'>\n";
                resp +=     getQuestao(cod_protocolo, rs.getString("cod_questao"), rs.getString("tipo_resposta"), codcli, data);
                resp += " </td>\n";
                resp += "</tr>\n";
                cont++;
            }
            
            resp += "</table>\n";
            rs.close();
            stmt.close();
            
            return resp;
        } catch(SQLException e) {
            return "ERRO: " + e.toString() + " SQL=" + sql;
        }
    }

    //Devolve as questões cadastradas do protocolo para responder
    public String getQuestoesProtocolo(String cod_protocolo, String codcli, String data) {
        String sql = "";
        String resp = "";
        ResultSet rs = null;
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            //Pega os blocos desse protocolo
            sql = "SELECT prot_blocos.bloco, prot_bloco_protocolo.cod_bloco ";
            sql += "FROM prot_bloco_protocolo INNER JOIN prot_blocos ON ";
            sql += "prot_bloco_protocolo.cod_bloco = prot_blocos.cod_bloco ";
            sql += "WHERE prot_bloco_protocolo.cod_protocolo=" + cod_protocolo;
            sql += " ORDER BY ordem";

            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            //Cria looping com a resposta
            while(rs.next()) {
                resp += "<div class='title'>" + rs.getString("bloco") + "</div>\n";
                resp += "<table cellspacing='0' cellpadding='0' width='600' class='table'>\n";
                resp += " <tr>\n";
                resp += "  <td width='100%'>\n";
                resp += getQuestoesBloco(cod_protocolo, rs.getString("cod_bloco"), codcli, data);
                resp += " </tr>\n";
                resp += "</table><br>\n";
            }
            rs.close();
            stmt.close();
            
            return resp;
        } catch(SQLException e) {
            return "ERRO: " + e.toString() + " SQL=" + sql;
        }
    }
    
    //Grava as respostas do protocolo
    public String gravaRespostasProtocolo(HttpServletRequest request, String usuario) {
        String sql = "";
        ResultSet rs = null;
        Banco bc = new Banco();
        
        //Parâmetros do cabeçalho
        String codcli = request.getParameter("codcli");
        String cod_protocolo = request.getParameter("protocolo");
        String data = Util.formataDataInvertida(request.getParameter("data"));
        String proxaplic = new Banco().getNext("prot_aplicacoes", "cod_aplicacao");
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            //Apaga as respostas anteriores desse cliente, protocolo e data
            sql  = "DELETE FROM prot_respostas ";
            sql += "WHERE cod_aplicacao IN (";
            sql += "SELECT cod_aplicacao FROM prot_aplicacoes ";
            sql += "WHERE data='" + data + "' AND ";
            sql += "codcli=" + codcli + " AND ";
            sql += "cod_protocolo=" + cod_protocolo;
            sql += ")";
            bc.executaSQL(sql);

            //Apaga os cabeçalhos da aplicação
            sql  = "DELETE FROM prot_aplicacoes ";
            sql += "WHERE data='" + data + "' AND ";
            sql += "codcli=" + codcli + " AND ";
            sql += "cod_protocolo=" + cod_protocolo;
            bc.executaSQL(sql);

            //Insere o cabeçalho da aplicação do protocolo
            sql  = "INSERT INTO prot_aplicacoes (cod_aplicacao, codcli, data, cod_protocolo, usuario) ";
            sql += "VALUES(" + proxaplic + "," + codcli + ",'" + data + "'," + cod_protocolo + ",'" + usuario + "')";
            String ret = new Banco().executaSQL(sql);
            
            //Se deu algum erro, retornar
            if(!ret.equals("OK")) return ret;
            
            //Pega todas as questões que esse protocolo possui
            sql  = "SELECT prot_questoes.cod_questao, prot_questoes.tipo_resposta ";
            sql += "FROM (prot_questao_bloco INNER JOIN prot_questoes ON ";
            sql += "prot_questao_bloco.cod_questao = prot_questoes.cod_questao) ";
            sql += "INNER JOIN prot_bloco_protocolo ON ";
            sql += "prot_questao_bloco.cod_bloco = prot_bloco_protocolo.cod_bloco ";
            sql += "WHERE prot_bloco_protocolo.cod_protocolo=" + cod_protocolo;
            rs = stmt.executeQuery(sql); 
            
            //Para cada questão do protocolo, capturar a resposta
            while(rs.next()) {
                gravarResposta(proxaplic, request, rs.getString("cod_questao"), rs.getString("tipo_resposta"));
            }
            
            return "OK";
        } catch(SQLException e) {
            return "ERRO: " + e.toString() + " SQL=" + sql;
        }
        
    }

    //Grava a resposta de cada questão do protocolo
    private String gravarResposta(String cod_aplicacao, HttpServletRequest request, String cod_questao, String tr) {
        String sql = "";

        //Se a resposta vier nula, não salvar
        if(Util.isNull(request.getParameter("resp" + cod_questao))) return "OK";
        
        //Se for texto (curtou longo) ou option, só tem uma resposta, gravar
        if(tr.equals("2") || tr.equals("3") || tr.equals("4")) {
            sql  = "INSERT INTO prot_respostas(cod_questao, cod_aplicacao, resposta) VALUES(";
            sql += cod_questao + "," + cod_aplicacao + ",'" + request.getParameter("resp" + cod_questao) + "')";
            return new Banco().executaSQL(sql);
        }
        
        //Se for checkbox, gravar os itens selecionados
        if(tr.equals("1")) {
            String valores[] = request.getParameterValues("resp" + cod_questao);
            
            //Para todos os selecionados, gravar um registro no banco
            for(int i=0; i<valores.length; i++) {
                sql  = "INSERT INTO prot_respostas(cod_questao, cod_aplicacao, resposta) VALUES(";
                sql += cod_questao + "," + cod_aplicacao + ",'" + valores[i] + "')";
                new Banco().executaSQL(sql);
            }
        }
            
        return "OK";
    }
    
    //Devolve as datas que um protocolo foi respondido
    public String getDatasProtocolo(String cod_protocolo, String codcli) {
        String sql = "";
        String resp = "";
        ResultSet rs = null;
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            sql += "SELECT * FROM prot_aplicacoes WHERE codcli=" + codcli;
            sql += " AND cod_protocolo=" + cod_protocolo;
            sql += " ORDER BY DATA DESC";
            
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            //Cabeçalho
            resp += "<select name='data' id='data' class='caixa' onChange='Javascript:setarData(this.value)'>";
            resp += "<option value=''></option>\n";
            
            //data atual na lista
            boolean dataatual = false;
            
            //Cria looping com a resposta
            while(rs.next()) {
                resp += "<option value='" + Util.formataData(rs.getString("data")) + "'>";
                resp +=   Util.formataData(rs.getString("data")) + " [" + rs.getString("usuario") + "]";
                resp += "</option>\n";
                
                //Se uma das datas for a de hj
                if(Util.formataData(rs.getString("data")).equals(Util.getData()))
                        dataatual = true;
            }
            
            //Se não apareceu a data de hoje, colocar como novo
            if(!dataatual)
                resp += "<option value='" + Util.getData() + "'>Novo Protocolo</option>\n";
            
            resp += "</select>";
            rs.close();
            stmt.close();
            
            
            return resp;
        } catch(SQLException e) {
            return "ERRO: " + e.toString() + " SQL=" + sql;
        }
    }
    
    //Verifica se um elemento pertence a um vetor
    private boolean existeValor(String valor, Vector vetor) {
        //varre o vetor para ver se existe o valor
        for(int i=0; i<vetor.size(); i++) {
            //Se achar, resp é true
            if(valor.equalsIgnoreCase(vetor.get(i).toString()))
                return true;
        }
        
        return false;
    }
}