/* Arquivo: OutrasDespesas.java
 * Autor: Amilton Souza Martha
 * Criação: 22/07/2008   Atualização: 02/09/2008
 * Obs: Manipula as informações de Outras Despesas
 */

package recursos;
import java.sql.*;

public class OutrasDespesas {
    //Atributos privados para conexão
    private Connection con = null;
    private Statement stmt = null;
    
    //Vetor de tipos de CD (Código de Despesa)
    private String[] vetorCD = {"Gases Medicinais", "Medicamentos", "Materiais", "Taxas Diversas", "Diárias", "Aluguéis"};
    
    public OutrasDespesas() {
        con = Conecta.getInstance();
    }
    
    //Monta Combo com os tipos de CD
    public String getCDs() {
        String resp = "";
        for(int i=0; i<vetorCD.length; i++) {
            resp += "<option value='" + (i+1) + "'>" + vetorCD[i] + "</option>\n";
        }
        return resp;
    }
    
    //Retorna os procedimentos
    public String getProcedimentos(String cod_empresa) {
        String resp = "";
        String sql = "";
        ResultSet rs = null;
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            sql += "SELECT COD_PROCED, Procedimento, CODIGO ";
            sql += "FROM procedimentos ";
            sql += "WHERE procedimentos.flag = 1 ";
            sql += "AND procedimentos.cod_empresa=" + cod_empresa + " ";
            sql += "ORDER BY Procedimento";
            
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            //Cria looping com a resposta
            while(rs.next()) {
                resp += "<option value='" + rs.getString("COD_PROCED") + "'>" + rs.getString("Procedimento") + " ( " + rs.getString("CODIGO") + " ) </option>\n";
            }
            rs.close();
            stmt.close();
            
            return resp;
        } catch(SQLException e) {
            return "Erro:" + e.toString();
        }
    }
    
    //Retorna os itens cadastrados em outras despesas
    public String getItensOutrasDespesas(String cod_outrasdespesas) {
        String resp = "";
        String sql = "";
        ResultSet rs = null;
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            //Executa a pesquisa
            sql += "SELECT * FROM outrasdespesas_itens WHERE cod_outrasdespesas=" + cod_outrasdespesas;
            rs = stmt.executeQuery(sql);
            
            //Cria looping com a resposta
            while(rs.next()) {
                resp += "<tr>\n";
		resp += "<td class='tdLight'>" + vetorCD[rs.getInt("CD")-1] + "</td>\n";
                resp += "<td class='tdLight'>" + rs.getString("cod_tabela") + "</td>\n";
                resp += "<td class='tdLight'>" + rs.getString("codigo") + "</td>\n";
                resp += "<td class='tdLight'>" + rs.getString("descricao") + "</td>\n";
                resp += "<td class='tdLight'>" + Util.formatCurrency(rs.getString("valorunitario")) + "</td>\n";
                resp += "<td class='tdLight' align='center'><a title='Excluir Item' href='Javascript:excluirItem(" + rs.getString("cod_outrasdespesasitens") + ")'><img src='images/delete.gif' border='0'></a></td>\n";
                resp += "</tr>\n";
            }
            rs.close();
            stmt.close();
            
            return resp;
        } catch(SQLException e) {
            return "Erro:" + e.toString();
        }
    }

    //Insere um intem em outras despesas
    public String insereItem(String cod_outrasdespesas, String cd, String cod_tabela, String cod_item, String descricao, String valor) {
        String sql = "";
        
        //Se veio descricao vazia ou valor ou cod_outrasdespesas, não gravar
        if(Util.isNull(cod_outrasdespesas) || Util.isNull(descricao) || Util.isNull(valor))
            return "";
        
        //Próximo sequencial
        String next = new Banco().getNext("outrasdespesas_itens", "cod_outrasdespesasitens");

        //Monta string de inserção
        sql  = "INSERT INTO outrasdespesas_itens(cod_outrasdespesasitens, cod_outrasdespesas,";
        sql += "codigo, descricao, cd, cod_tabela, valorunitario) VALUES(";
        sql += next + "," + cod_outrasdespesas + ",'" + cod_item + "','" + descricao + "','";
        sql += cd + "','" + cod_tabela + "'," + valor + ")";

        //Retorna resultado do script
        return new Banco().executaSQL(sql);
        
    }

    //Insere um intem em outras despesas
    public String removeItem(String cod_outrasdespesasitens) {
        String sql = "";
        
        //Se não veio código, não fazer nada
        if(Util.isNull(cod_outrasdespesasitens))
            return "";
        
        //Monta string de remoção
        sql  = "DELETE FROM outrasdespesas_itens WHERE cod_outrasdespesasitens=" + cod_outrasdespesasitens;

        //Retorna o resultado do script
        return new Banco().executaSQL(sql);
        
    }

    /* pesquisa: valor a ser pesquisado
     * campo: campo a ser pesquisado
     * ordem: ordem de resposta dos campos
     * numPag: número da página selecionada (paginação)
     * qtdeporpagina: quantidade de registros por página
     * tipo: tipo de pesquisa (exata, substring)
     * cod_empresa: código da empresa logada
     * cod_convenio: código do convênio
     */
    public String[] getOutrasDespesas(String pesquisa, String ordem, int numPag, int qtdeporpagina, int tipo, String cod_empresa) {
        String resp[] = {"",""};
        String sql = "";
        ResultSet rs = null;
        
        //Limpa espaços em branco antes e depois da pesquisa
        pesquisa = pesquisa.trim();
        
        sql += "SELECT convenio.descr_convenio, procedimentos.CODIGO, procedimentos.Procedimento, ";
        sql += "outrasdespesas.cod_outrasdespesas ";
        sql += "FROM (convenio INNER JOIN outrasdespesas ON convenio.cod_convenio = ";
        sql += "outrasdespesas.cod_convenio) INNER JOIN procedimentos ON ";
        sql += "outrasdespesas.cod_proced = procedimentos.COD_PROCED ";
        sql += "WHERE procedimentos.cod_empresa=" + cod_empresa;
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            //Consulta exata
            if(tipo == 1)
                sql += " AND Procedimento='" + pesquisa + "' OR descr_convenio='" + pesquisa + "'";
            //Começando com o valor
            else if(tipo == 2)
                sql += " AND Procedimento LIKE '" + pesquisa + "%' OR descr_convenio LIKE '" + pesquisa + "%'";
            //Com o valor no meio
            else if(tipo == 3)
                sql += " AND Procedimento LIKE '%" + pesquisa + "%' OR descr_convenio LIKE '%" + pesquisa + "%'";
            
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
            resp[1] = Util.criaPaginacao("outrasdespesas.jsp", numPag, qtdeporpagina, numRows);
            
            //Limita para uma quantidade de registros
            sql += " LIMIT " + ((numPag-1)*qtdeporpagina) + "," + qtdeporpagina;
            
            //Executa a pesquisa novamente com o limitador
            rs = stmt.executeQuery(sql);
            
            //Cria looping com a resposta
            while(rs.next()) {
                resp[0] += "<tr onClick=go('outrasdespesas.jsp?cod=" + rs.getString("cod_outrasdespesas") + "') onMouseOver='trocaCor(this,1);' onMouseOut='trocaCor(this,2);'>";
                resp[0] += "<td width='20%' class='tdLight'>" + rs.getString("CODIGO") + "&nbsp;</td>\n";
                resp[0] += "<td width='40%' class='tdLight'>" + rs.getString("Procedimento") + "&nbsp;</td>\n";
                resp[0] += "<td width='40%' class='tdLight'>" + rs.getString("descr_convenio") + "&nbsp;</td>\n";
                resp[0] += "</tr>";
            }
            
            //Se não retornar resposta, montar mensagem de não encontrado
            if(resp[0].equals("")) {
                resp[0] += "<tr>";
                resp[0] += " <td colspan='3' width='600' class='tdLight'>";
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
    
    //Retorna as tabelas
    public String getTabelas(String cod_empresa) {
        String resp = "";
        String sql = "";
        ResultSet rs = null;
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            sql += "SELECT * FROM tabelas WHERE cod_empresa=" + cod_empresa + " ";
            sql += "ORDER BY tabela";
            
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            //Cria looping com a resposta
            while(rs.next()) {
                resp += "<option value='" + rs.getString("cod_tiss") + "'>" + rs.getString("tabela") +  "</option>\n";
            }
            rs.close();
            stmt.close();
            
            return resp;
        } catch(SQLException e) {
            return "Erro:" + e.toString();
        }
    }    

}