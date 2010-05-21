/* Arquivo: Lote.java
 * Autor: Amilton Souza Martha
 * Criação: 03/08/2007   Atualização: 03/08/2009
 * Obs: Manipula as informações de Lotes de guias
 */

package recursos;
import java.sql.*;
import java.util.Vector;

public class Lote {
    //Atributos privados para conexão
    
    private Connection con = null;
    private Statement stmt = null;

    //Nome e Descrição das Tabelas das Guias do TISS
    private String descricaoTabelasTISS[] = {"Guia de Consulta", "Guia SP/SADT", "Guia de Honorário Individual", "Guia de Resumo de Internação"};
    private String nomeTabelasTISS[] = {"guiasconsulta", "guiassadt", "guiashonorarioindividual", "guiasresumointernacao"};

    public Lote() {
        con = Conecta.getInstance();
    }
  
    public String getNomeTabelaGuia(String tipoGuia) {
        //Se não veio nada, nem processar
        if(Util.isNull(tipoGuia)) return "";
        
        String resp = "";

        try {
            resp = nomeTabelasTISS[Integer.parseInt(tipoGuia)-1];
        }
        catch(ArrayIndexOutOfBoundsException e) {
            resp = "Tipo de Guia Inexistente";
        }
        catch(Exception e) {
            resp = e.toString();
        }
        
        return resp;
        
    }
    
    
    public String getTipoGuia(String tipoGuia) {
        
        //Se não veio nada, nem processar
        if(Util.isNull(tipoGuia)) return "";
        
        String resp = "";

        try {
            resp = descricaoTabelasTISS[Integer.parseInt(tipoGuia)-1];
        }
        catch(ArrayIndexOutOfBoundsException e) {
            resp = "Tipo de Guia Inexistente";
        }
        catch(Exception e) {
            resp = e.toString();
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
    public String[] getLotes(String pesquisa, String campo, String ordem, int numPag, int qtdeporpagina, int tipo, String cod_empresa) {
        String resp[] = {"",""};
        String sql = "";
        ResultSet rs = null;
        
        //Limpa espaços em branco antes e depois da pesquisa
        pesquisa = pesquisa.trim();
        
        sql += "SELECT * FROM lotesguias ";
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
            resp[1] = Util.criaPaginacao("lotes.jsp", numPag, qtdeporpagina, numRows);
            
            //Limita para uma quantidade de registros
            sql += " LIMIT " + ((numPag-1)*qtdeporpagina) + "," + qtdeporpagina;
             
            //Executa a pesquisa novamente com o limitador
            rs = stmt.executeQuery(sql);
            
              //Cria looping com a resposta
            while(rs.next()) {
                
                resp[0] += "<tr onClick=go('lotes.jsp?cod=" + rs.getString("codLote") + "') onMouseOver='trocaCor(this,1);' onMouseOut='trocaCor(this,2);'>";
                resp[0] += "  <td width='40' class='tdLight' align='center'>" + rs.getString("codLote") + "&nbsp;</td>\n";
                resp[0] += "  <td width='80' class='tdLight'>" + Util.formataData(rs.getString("dataRegistroTransacao")) + "&nbsp;</td>\n";
                resp[0] += "  <td width='100' class='tdLight'>" + getTipoGuia(rs.getString("tipoGuia")) + "&nbsp;</td>\n";
                resp[0] += "  <td class='tdLight'>" + rs.getString("identificacao") + "&nbsp;</td>\n";
                resp[0] += "  <td width='30' class='tdLight' align='center'>" + rs.getString("gerouGuia") + "&nbsp;</td>\n";
                resp[0] += "</tr>";
            }
            
            //Se não retornar resposta, montar mensagem de não encontrado
            if(resp[0].equals("")) {
                resp[0] += "<tr>";
                resp[0] += " <td colspan=4 width='600' class='tdLight'>";
                resp[0] += "  Nenhum registro encontrado para a pesquisa";
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

    //Busca os lotes de guia da empresa que ainda não geraram arquivo XML
    public String getLotes(String cod_empresa) {
        String resp = "";
        String sql = "";
        ResultSet rs = null;
        
        sql += "SELECT * FROM lotesguias WHERE gerouGuia='N' ";
        sql += "AND cod_empresa=" + cod_empresa;
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            resp += "<table border=0 cellspacing=0 cellpadding=0 width='400' class='table'>\n";
            resp += " <tr>\n";
            resp += "  <td class='tdMedium'>nº do Lote</td>\n";
            resp += "  <td class='tdMedium'>Data</td>\n";
            resp += "  <td class='tdMedium'>Operadora</td>\n";
            resp += "  <td class='tdMedium'>Gerar XML</td>\n";
            resp += " </tr>\n";
            
            //Cria looping com a resposta
            while(rs.next()) {
                resp += " <tr>\n";
                resp += "  <td class='tdLight'>" + rs.getString("codLote") + "</td>\n";
                resp += "  <td class='tdLight'>" + Util.formataData(rs.getString("dataRegistroTransacao")) + "</td>\n";
                resp += "  <td class='tdLight'>" + rs.getString("identificacao") + "</td>\n";
                resp += "  <td class='tdLight' align='center'><a href='Javascript:gerarXML(" + rs.getString("codLote") + ")'><img src='images/grava.gif' border=0></a>\n";
                resp += " </tr>\n";
            }
                
            resp += "</table>";
            rs.close();
            stmt.close();
            return resp;
            
        } catch(SQLException e) {
            resp = "ERRO: " + e.toString() + " SQL:" + sql;
            return resp;
        }
    }

    //Busca as guias do lote com o seu valor
    public Vector getGuiasLote(String lotes) {
        String resp = "";
        String sql = "";
        Vector retorno = new Vector();
        ResultSet rs = null;
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            sql  = "SELECT valorprocedimentos.valor, guiasconsulta.nomeBeneficiario, ";
            sql += "guiasconsulta.codLote, guiasconsulta.dataEmissaoGuia, ";
            sql += "guiasconsulta.nomeProfissional, guiasconsulta.numeroConselho ";
            sql += "FROM (((faturas_itens INNER JOIN (guiasconsulta INNER JOIN faturas ON ";
            sql += "guiasconsulta.numeroFatura = faturas.Numero) ON ";
            sql += "faturas_itens.Numero = faturas.Numero) INNER JOIN valorprocedimentos ON ";
            sql += "faturas_itens.Cod_Proced = valorprocedimentos.cod_proced) INNER JOIN convenio ON ";
            sql += "(guiasconsulta.registroANS = convenio.cod_ans) AND ";
            sql += "(valorprocedimentos.cod_convenio = convenio.cod_convenio)) INNER JOIN planos ON ";
            sql += "(planos.plano = guiasconsulta.nomePlano) AND (convenio.cod_convenio = planos.cod_convenio) ";
            sql += "AND (valorprocedimentos.cod_plano = planos.cod_plano) ";
            sql += "WHERE guiasconsulta.codLote IN(" + lotes + ")" ;
            sql += " ORDER BY numeroConselho, dataEmissaoGuia";
            
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            //Cabeçalho
            resp += "<table border=0 cellspacing=0 cellpadding=0 width='90%' class='table'>\n";
            resp += " <tr>\n";
            resp += "  <td class='tblrel' style='background-color:black; color:white'><b>nº do Lote</b></td>\n";
            resp += "  <td class='tblrel' style='background-color:black; color:white'><b>Data</b></td>\n";
            resp += "  <td class='tblrel' style='background-color:black; color:white'><b>Paciente</b></td>\n";
            resp += "  <td class='tblrel' style='background-color:black; color:white'><b>Profissional</b></td>\n";
            resp += "  <td class='tblrel' style='background-color:black; color:white'><b>Valor</b></td>\n";
            resp += " </tr>\n";
            retorno.add(resp);

            String prof_reg_old = "";
            float subtotal = 0;
            float total = 0;
            
            //Cria looping com a resposta
            while(rs.next()) {
                
                //Se mudou de médico, colocar subtotal
                if(!prof_reg_old.equals("") && !prof_reg_old.equals(rs.getString("numeroConselho"))) {
                    resp  = "<tr>\n";
                    resp += " <td colspan='4' class='tblrel' style='background-color:#CCCCCC' align='right'><b>Sub-total:</b></td>\n";
                    resp += " <td class='tblrel' style='background-color:#CCCCCC'><b>" + Util.formatCurrency(subtotal+"") + "</b></td>\n";
                    resp += "</tr>\n";
                    subtotal = 0;
                    retorno.add(resp);
                }
                
                //Acumuladores
                subtotal += rs.getFloat("valor");
                total += rs.getFloat("valor");
                
                resp  = " <tr>\n";
                resp += "  <td class='tblrel' align='center'>" + rs.getString("codLote") + "</td>\n";
                resp += "  <td class='tblrel'>" + Util.formataData(rs.getString("dataEmissaoGuia")) + "</td>\n";
                resp += "  <td class='tblrel'>" + rs.getString("nomeBeneficiario") + "</td>\n";
                resp += "  <td class='tblrel'>" + rs.getString("nomeProfissional") + "</td>\n";
                resp += "  <td class='tblrel'>" + Util.formatCurrency(rs.getString("valor")) + "</td>\n";
                resp += " </tr>\n";
                retorno.add(resp);
                
                prof_reg_old = rs.getString("numeroConselho");
            }

            //Último subtotal
            resp  = "<tr>\n";
            resp += " <td colspan='4' class='tblrel' style='background-color:#CCCCCC' align='right'><b>Sub-total:</b></td>\n";
            resp += " <td class='tblrel' style='background-color:#CCCCCC'><b>" + Util.formatCurrency(subtotal+"") + "</b></td>\n";
            resp += "</tr>\n";
            retorno.add(resp);
                
            //Total
            resp  = "<tr>\n";
            resp += " <td colspan='4' class='tblrel' style='background-color:black; color: white' align='right'><b>Total:</b></td>\n";
            resp += " <td class='tblrel' style='background-color:black; color: white'><b>" + Util.formatCurrency(total+"") + "</b></td>\n";
            resp += "</tr>\n";
            resp += "</table>";
            retorno.add(resp);
            
            rs.close();
            stmt.close();
            return retorno;
            
        } catch(SQLException e) {
            retorno.add("ERRO: " + e.toString() + " SQL:" + sql);
            return retorno;
        }
    }

    //Busca as guias para serem inseridas no lote
    public String getGuias(String de, String ate, String cod_convenio, String tipoGuia, String ordem, String tipoConsulta, String guiainicial, String guiafinal, String cod_empresa) {
        String resp = "";
        String sql = "";
        ResultSet rs = null;
        String tabela = "";
        boolean achou = false;
        boolean troca = false;
        String cor = "";

        //Se não veio alguma informação, parar
        if(Util.isNull(de) || Util.isNull(ate) || Util.isNull(cod_convenio) || Util.isNull(tipoGuia) || Util.isNull(cod_empresa))
               return "";

        //Se for guia de consulta
        if(tipoGuia.equals("1")) {
            tabela = "guiasconsulta";
        }
        //Se for guia SADT
        else if(tipoGuia.equals("2")){
            tabela = "guiassadt";
        }
        //Se for guia de honorário individual
        else if(tipoGuia.equals("3")){
            tabela = "guiashonorarioindividual";
        }
        //Se for guia de resumo de internação
        else if(tipoGuia.equals("4")){
            tabela = "guiasresumointernacao";
        }
        
        try {

            //Busca o código ANS do convênio selecionado
            String codANS = new Banco().getValor("cod_ans", "SELECT cod_ans FROM convenio WHERE cod_convenio=" + cod_convenio);

            sql = "SELECT codGuia, dataEmissaoGuia, nomeBeneficiario, ";
            //Se for Consulta ou SADT, buscar tipo de saída
            if(tipoGuia.equals("1") || tipoGuia.equals("2"))
                sql += "tiposaida, ";
            sql += "numeroGuiaPrestador FROM " + tabela + " ";
            
            //Verifica o tipo de consulta que está sendo feito
            if(tipoConsulta.equals("periodo")) {
                sql += "WHERE dataEmissaoGuia BETWEEN '" + Util.formataDataInvertida(de);
                sql += "' AND '" + Util.formataDataInvertida(ate) + "' ";
            }
            else { //Se não for período, é intervalo de guias
                sql += "WHERE numeroGuiaPrestador BETWEEN " + guiainicial;
                sql += " AND " + guiafinal + " ";
            }
            sql += "AND registroANS='" + codANS + "' ";
            sql += "AND (codLote is NULL OR codLote='' OR codLote='null') ORDER BY " + ordem;
            
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);

            //Cabeçalho
            resp += "<table border=0 cellspacing=0 cellpadding=0 width='100%' class='table'>\n";
            resp += " <tr>\n";
            resp += "  <td width='50' class='tdMedium' align='center'><input title='Selecionar/Remover Todos' type='checkbox' name='chktodos' id='chktodos' onclick='Javascript:todos(this.checked)'></td>\n";
            resp += "  <td width='80' class='tdMedium'><a title='Ordenar por nº da guia' href=\"Javascript:ordenarGuia('numeroGuiaPrestador')\">nº da Guia</a></td>\n";
            resp += "  <td width='80' class='tdMedium'><a title='Ordenar por Data' href=\"Javascript:ordenarGuia('dataEmissaoGuia')\">Data</a></td>\n";
            resp += "  <td class='tdMedium'><a title='Ordenar por Beneficiário' href=\"Javascript:ordenarGuia('nomeBeneficiario')\">Beneficiário</a></td>\n";
            resp += " </tr>\n";
            
            //Looping com a resposta
            while(rs.next()) {
                if(( (tipoGuia.equals("1") || tipoGuia.equals("2")) && Util.isNull(rs.getString("tiposaida")))){
                    cor = "#FF6F6F";
                }
                else if(troca) {
                    cor = "#CCCCCC";
                    troca = false;
                }
                else {
                    cor = "#FFFFFF";
                    troca = true;
                }

                resp += " <tr>\n";
                resp += "  <td class='tdLight' style='background-color:" + cor + "' align='center'><input type='checkbox' name='chk' value='" + rs.getString("codGuia") + "'></td>\n";
                //Só coloca link de edição se for SADT ou Consulta
                if(tipoGuia.equals("1") || tipoGuia.equals("2"))
                    resp += "  <td class='tdLight' style='background-color:" + cor + "'><a title='Clique Aqui para Editar a Guia' href='Javascript:editarguia(" + rs.getString("codGuia") + "," + tipoGuia + ")'><u>" + rs.getString("numeroGuiaPrestador") + "</u></a></td>\n";
                else
                    resp += "  <td class='tdLight' style='background-color:" + cor + "'>" + rs.getString("numeroGuiaPrestador") + "</td>\n";                
                resp += "  <td class='tdLight' style='background-color:" + cor + "'>" + Util.formataData(rs.getString("dataEmissaoGuia")) + "</td>\n";
                resp += "  <td class='tdLight' style='background-color:" + cor + "'>" + rs.getString("nomeBeneficiario") + "</td>\n";
                resp += " </tr>\n";
                achou = true;
            }
            
            //Se não achou nenhuma guia, mensagem
            if(!achou) {
                resp += "<tr>\n";
                resp += "  <td colspan=4 class='tdLight'>Nenhuma guia encontrada</td>\n";
                resp += "</tr>";
            }
            else {
                resp += "<tr>\n";
                resp += "  <td colspan=4 class='tdMedium' align='right'><button type='button' class='botao' onclick='gerarlote()'><img src='images/4.gif'>&nbsp;&nbsp;Gerar Lote</button></td>\n";
                resp += "</tr>";
            }

            resp += "</table>";
            
            rs.close();
            stmt.close();
            return resp;
            
        } catch(SQLException e) {
            resp = "TipoGuia: " + tipoGuia + " ERRO: " + e.toString() + " SQL:" + sql;
            return resp;
        }
    }

    //Busca os lotes de guia da empresa que ainda não geraram arquivo XML
    public String getGuias(String codLote, String tipoguia, String ordem) {
        String resp = "";
        String sql = "";
        ResultSet rs = null;

        //Se não veio alguma informação, parar
        if(codLote == null || tipoguia == null) return "";
        
        //Pega o nome da tabela e puxa as guias
        String tabela = this.getNomeTabelaGuia(tipoguia);
        sql += "SELECT * FROM " + tabela + " WHERE ";
        sql += "codLote=" + codLote;
        sql += " ORDER BY " + ordem;
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            resp += "<table border=0 cellspacing=0 cellpadding=0 width='600' class='table'>\n";
            resp += " <tr>\n";
            resp += "  <td class='tdMedium'><a title='Ordenar por nº da guia' href=\"Javascript:ordenarGuia('numeroGuiaPrestador')\">Nº da Guia</a></td>\n";
            resp += "  <td class='tdMedium'><a title='Ordenar por Beneficiário' href=\"Javascript:ordenarGuia('nomeBeneficiario')\">Beneficiário</a></td>\n";
            
            //Se for guia de Resumo de Internação, não tem profissional
            if(!tipoguia.equals("4"))
                resp += "  <td class='tdMedium'><a title='Ordenar por Profissional' href=\"Javascript:ordenarGuia('nomeProfissional')\">Profissional</a></td>\n";
            
            resp += "  <td class='tdMedium'><a title='Ordenar por Data da Guia' href=\"Javascript:ordenarGuia('dataEmissaoGuia')\">Data da Guia</a></td>\n";
            resp += "  <td class='tdMedium'>Editar Guia</td>\n";
            resp += "  <td class='tdMedium'>Excluir Guia</td>\n";
            resp += " </tr>\n";
            
            //Cria looping com a resposta
            while(rs.next()) {
                resp += " <tr>\n";
                resp += "  <td class='tdLight'>" + Util.formataNumero(rs.getString("numeroGuiaPrestador"), 12) + "</td>\n";
                resp += "  <td class='tdLight'>" + rs.getString("nomeBeneficiario") + "</td>\n";

                //Se for guia de Resumo de Internação, não tem profissional
                if(!tipoguia.equals("4"))
                    resp += "  <td class='tdLight'>" + rs.getString("nomeProfissional") + "</td>\n";
                
                resp += "  <td class='tdLight'>" + Util.formataData(rs.getString("dataEmissaoGuia")) + "</td>\n";
                resp += "  <td class='tdLight' align='center'><a title='Editar Guia' href='Javascript:editarguia(" + rs.getString("codGuia") + "," + tipoguia + ")'><img src='images/open.gif' border=0></a>\n";
                resp += "  <td class='tdLight' align='center'><a title='Excluir Guia' href='Javascript:excluirguia(" + rs.getString("codGuia") + "," + tipoguia + ")'><img src='images/delete.gif' border=0></a>\n";
                resp += " </tr>\n";
            }
                
            resp += "</table>";
            rs.close();
            stmt.close();
            return resp;
            
        } catch(SQLException e) {
            resp = "ERRO: " + e.toString() + " SQL:" + sql;
            return resp;
        }
    }
    
    //Recebe as informações para gerar um lote
    public String gravarLote(String itens[], String cod_convenio, String tipoguia,  String cod_empresa) {
        String resp = "";
        String sql = "";
        Banco bc = new Banco();
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement();

            ResultSet rs = null;
            
            //Busca dados do convênio
            sql = "SELECT * FROM convenio WHERE cod_convenio=" + cod_convenio;
            rs = stmt.executeQuery(sql);
            
            if(rs.next()) {
                String proxlote = new Banco().getNext("lotesguias", "codLote");            
                String nome_convenio = rs.getString("descr_convenio");
                
                //Se tiver mais de 100 caracteres, truncar
                if(!Util.isNull(nome_convenio) && nome_convenio.length() > 100)
                    nome_convenio = nome_convenio.substring(0,100);
                
                //Cria o novo lote para inserir as guias
                sql  = "INSERT INTO lotesguias(codLote, cod_empresa, identificacao, tipoTransacao, dataRegistroTransacao, horaRegistroTransacao,";
                sql += "tipoCodigoPrestadorNaOperadora, codigoPrestadorNaOperadora, registroANS, tipoGuia, gerouGuia) VALUES(";
                sql += proxlote + "," + cod_empresa + ",'" + nome_convenio + "','ENVIO_LOTE_GUIAS','" + Util.formataDataInvertida(Util.getData()) + "','";
                sql += Util.getHora() + "','" + getTipoIdentificador(rs.getString("tipoidentificadoroperadora")) + "','" + rs.getString("identificadoroperadora");
                sql += "','" + rs.getString("cod_ans") + "'," + tipoguia + ",'N')";
                bc.executaSQL(sql);
                
                //Verifica o tipo de guia
                String tabela = "";
                switch(Integer.parseInt(tipoguia)){
                    case 1: tabela = "guiasconsulta"; break;
                    case 2: tabela = "guiassadt"; break;
                    case 3: tabela = "guiashonorarioindividual"; break;
                    case 4: tabela = "guiasresumointernacao"; break;
                }
                
                //Pega todas as guias selecionadas e insere no lote criado
                for(int i=0; i<itens.length; i++) {
                    bc.executaSQL("UPDATE " + tabela + " SET codLote=" + proxlote + " WHERE codGuia=" + itens[i] + " AND cod_empresa=" + cod_empresa);
                }
                
            }
            
            resp = "OK";
        }
        catch(SQLException e) {
            resp = "ERRO: " + e.toString() + " SQL: " + sql;
        }
        
        return resp;
    }
    
    private String getTipoIdentificador(String codtipo) {
        String tipos[] = {"CNPJ","codigoPrestadorNaOperadora","CPF"};
        String resp = "";
        
        try {
            resp = tipos[Integer.parseInt(codtipo)-1];
        }
        catch(Exception e) {
            resp = e.toString().substring(0,29);
        }
        
        return resp;
    }
    
    //trata se o campo veio nulo
    private String trataNulo(String valor) {
        String resp = "";
        if(Util.isNull(valor))
            resp = "null";
        else
            resp = "'" + valor + "'";
        return resp;
    }

    //Retorna o total do valor do lote
    public float getTotalLote(String codlote) {
        String resp = "";
        String sql = "";
        float retorno = 0.0f;

        Banco bc = new Banco();

        //Pega o tipo de guia do lote
        String tipoGuia = bc.getValor("tipoguia", "SELECT tipoGuia FROM lotesguias WHERE codLote=" + codlote);

        //Se for guia de consulta, somar os totais pelo faturamento
        if(tipoGuia.equals("1")) {
            sql  = "SELECT Sum(faturas_itens.valor) AS soma ";
            sql += "FROM faturas_itens INNER JOIN (guiasconsulta INNER JOIN faturas ON ";
            sql += "guiasconsulta.numeroFatura = faturas.Numero) ON faturas_itens.Numero = faturas.Numero ";
            sql += "WHERE guiasconsulta.codLote=" + codlote;
            resp = Util.trataNulo(bc.getValor("soma", sql),"0.0f");
            retorno = Float.parseFloat(resp);

        }
        //Se for guia SADT, somar pelos procedimentos junto com outras despesas
        else if(tipoGuia.equals("2")) {
            sql  = "SELECT Sum(procedimentossadt.valorTotal) AS soma ";
            sql += "FROM guiassadt INNER JOIN procedimentossadt ON ";
            sql += "guiassadt.codGuia = procedimentossadt.codguia ";
            sql += "WHERE guiassadt.codLote=" + codlote;
            resp = Util.trataNulo(bc.getValor("soma", sql),"0.0f");

            sql  = "SELECT Sum(guiasoutrasdespesas.valorTotal) AS soma ";
            sql += "FROM guiasoutrasdespesas INNER JOIN guiassadt ON ";
            sql += "(guiassadt.numeroFatura = guiasoutrasdespesas.numeroFatura) ";
            sql += "AND (guiasoutrasdespesas.codGuia = guiassadt.codGuia) ";
            sql += "WHERE guiassadt.codLote=" + codlote;
            
            retorno = Float.parseFloat(resp) + Float.parseFloat(Util.trataNulo(bc.getValor("soma", sql),"0.0f"));

        }
        //Se for guia de honorário individual, somar os itens da guia
        else if(tipoGuia.equals("3")) {
            sql  = "SELECT Sum(procedimentoshonorarios.valorTotal) AS soma ";
            sql += "FROM guiashonorarioindividual INNER JOIN procedimentoshonorarios ON ";
            sql += "guiashonorarioindividual.codGuia = procedimentoshonorarios.codguia ";
            sql += "WHERE guiashonorarioindividual.codLote=" + codlote;
            resp = Util.trataNulo(bc.getValor("soma", sql),"0.0f");
            retorno = Float.parseFloat(resp);
        }
        //Se for guia de resumo de internação, somar os itens da guia
        else if(tipoGuia.equals("4")) {
            sql  = "SELECT Sum(procedimentoresumointernacaoguia.valorTotal) AS soma ";
            sql += "FROM guiasresumointernacao INNER JOIN procedimentoresumointernacaoguia ";
            sql += "ON guiasresumointernacao.codGuia = procedimentoresumointernacaoguia.codGuia ";
            sql += "WHERE guiasresumointernacao.codLote=" + codlote;
            resp = Util.trataNulo(bc.getValor("soma", sql),"0.0f");
            retorno = Float.parseFloat(resp);
        }
        return retorno;
    }
    
}
