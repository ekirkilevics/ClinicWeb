/* Arquivo: Conta.java
 * Autor: Amilton Souza Martha
 * Criação: 08/05/2009   Atualização: 28/05/2009
 * Obs: Manipula as informações de contas a receber
 */

package recursos;
import java.sql.*;
import java.util.Vector;
import javax.servlet.http.HttpServletRequest;

public class Conta {
    //Atributos privados para conexão
    private Connection con = null;
    private Statement stmt = null;

    public Conta() {
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
    public String[] getContas(String pesquisa, String campo, String ordem, int numPag, int qtdeporpagina, int tipo, String cod_empresa) {
        String resp[] = {"",""};
        String sql = "";
        ResultSet rs = null;

        //Limpa espaços em branco antes e depois da pesquisa
        pesquisa = pesquisa.trim();

        sql += "SELECT * FROM contas ";
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
            resp[1] = Util.criaPaginacao("contas.jsp", numPag, qtdeporpagina, numRows);

            //Limita para uma quantidade de registros
            sql += " LIMIT " + ((numPag-1)*qtdeporpagina) + "," + qtdeporpagina;

            //Executa a pesquisa novamente com o limitador
            rs = stmt.executeQuery(sql);

            //Cria looping com a resposta
            while(rs.next()) {
                resp[0] += "<tr onClick=go('contas.jsp?cod=" + rs.getString("cod_conta") + "') onMouseOver='trocaCor(this,1);' onMouseOut='trocaCor(this,2);'>";
                resp[0] += " <td width='80' class='tdLight'>" + Util.formataData(rs.getString("data_vencimento")) + "&nbsp;</td>\n";
                resp[0] += " <td class='tdLight'>" + rs.getString("descricao") + "&nbsp;</td>\n";
                resp[0] += " <td width='80' class='tdLight'>" + Util.formatCurrency(rs.getString("valortotal")) + "&nbsp;</td>\n";
                resp[0] += "</tr>";
            }

            //Se não retornar resposta, montar mensagem de não encontrado
            if(resp[0].equals("")) {
                resp[0] += "<tr>";
                resp[0] += " <td width='600' class='tdLight' colspan='3'>";
                resp[0] += "   Nenhum registro encontrado para a pesquisa";
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

    //Retorna os bancos da empresa
    public String getBancos(String cod_empresa) {
        return getBancos(cod_empresa, "");
    }

    //Retorna os bancos da empresa
    public String getBancos(String cod_empresa, String bancoselecionado) {
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

            //Executa a pesquisa
            rs = stmt.executeQuery(sql);

            String sel = (bancoselecionado.equals("-1")) ? " selected" : "";
            resp += "<option value='-1'" + sel + ">Carteira</option>\n";

            //Cria looping com a resposta
            while(rs.next()) {
                sel = (bancoselecionado.equals(rs.getString("cod_banco"))) ? " selected" : "";

                resp += "<option value='" + rs.getString("cod_banco") + "'" + sel + ">";
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

    //Relatório de contas a receber
    public Vector getRelContasReceber(String de, String ate, String convenio, String lote, String ordem, String cod_empresa) {
        //Retorno dos dados
        Vector retorno = new Vector();
        String cor = "", resp = "";

        //Converte as datas
        de = Util.formataDataInvertida(de);
        ate = Util.formataDataInvertida(ate);

        String sql = "";

        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);

            ResultSet rs = null;

            //Pega todas as histórias
            sql  = "SELECT faturas.numero, faturas.Data_Lanca, paciente.nome, ";
            sql += "faturas_itens.qtde, faturas_itens.valor, procedimentos.Procedimento, ";
            sql += "convenio.descr_convenio, faturas_itens.cod_subitem, guiassadt.codLote AS codLotesadt, ";
            sql += "guiasconsulta.codLote AS codLoteconsulta ";
            sql += "FROM (guiassadt RIGHT JOIN ((((faturas_itens INNER JOIN faturas ON ";
            sql += "faturas_itens.Numero = faturas.Numero) INNER JOIN procedimentos ON ";
            sql += "faturas_itens.Cod_Proced = procedimentos.COD_PROCED) INNER JOIN paciente ON ";
            sql += "faturas.codcli = paciente.codcli) INNER JOIN convenio ON faturas_itens.cod_convenio = ";
            sql += "convenio.cod_convenio) ON guiassadt.numeroFatura = faturas.Numero) LEFT JOIN ";
            sql += "guiasconsulta ON faturas.Numero = guiasconsulta.numeroFatura ";
            sql += "WHERE faturas.Data_Lanca BETWEEN '" + de + "' AND '" + ate + "' ";
            sql += "AND faturas_itens.valor_recebido IS NULL ";

            //Filtra por convênio
            if(!Util.isNull(convenio))
                sql += " AND faturas_itens.cod_convenio=" + convenio;

            //Filtra por lote
            if(!Util.isNull(lote))
                sql += " AND codLote = " + lote;

            //Ordenação
            sql += " ORDER BY " + ordem;

            //Executa a pesquisa
            rs = stmt.executeQuery(sql);

            //Cabeçalho
            resp  = "<tr>\n";
            resp += "  <td class='tdMedium' style='border-bottom:0px;'><a title='Ordenar por Data' href=\"Javascript:ordenar('contasreceber','Data_lanca')\">Data</a></td>\n";
            resp += "  <td class='tdMedium' style='border-bottom:0px;'><a title='Ordenar por Convênio' href=\"Javascript:ordenar('contasreceber','descr_convenio')\">Convênio</a></td>\n";
            resp += "  <td class='tdMedium' style='border-bottom:0px;'><a title='Ordenar por Paciente' href=\"Javascript:ordenar('contasreceber','nome')\">Paciente</a></td>\n";
            resp += "  <td class='tdMedium' style='border-bottom:0px;'><a title='Ordenar por Procedimento' href=\"Javascript:ordenar('contasreceber','Procedimento')\">Procedimento</a></td>\n";
            resp += "  <td class='tdMedium' style='border-bottom:0px;'>Valor</td>\n";
            resp += "  <td class='tdMedium' style='border-bottom:0px;'>Lote</td>\n";
            resp += "</tr>\n";
            resp += "<tr>\n";
            resp += "  <td class='tdMedium'>Data Recebimento</td>\n";
            resp += "  <td class='tdMedium'>Operação</td>\n";
            resp += "  <td class='tdMedium'>Banco</td>\n";
            resp += "  <td class='tdMedium'>Observação</td>\n";
            resp += "  <td class='tdMedium'>Valor Recebido</td>\n";
            resp += "  <td class='tdMedium'>Recebido<input type='checkbox' id='chktodos' onclick='todos(this.checked)'></td>\n";
            resp += "</tr>\n";
            retorno.add(resp);

            //Soma total
            float soma = 0;

            //Pegar os itens
            while(rs.next()) {

                //Trata o lote
                if(!Util.isNull(rs.getString("codLotesadt")))
                    lote = rs.getString("codLotesadt");
                else
                    lote = Util.trataNulo(rs.getString("codLoteconsulta"), "");

                //Número do faturamento
                String cod_fatura = rs.getString("cod_subitem");

                //Valores
                int qtde = rs.getInt("qtde");
                float valor = rs.getFloat("valor");
                soma += (qtde*valor);

                //Troca as cores
                if(cor.equals("#D6DFEF"))
                    cor = "#FFFFFF";
                else
                    cor = "#D6DFEF";

                resp  = "<tr>\n";
                resp += "  <td class='tdLight' style='border-bottom:0px;background-color:" + cor + "'>" + Util.formataData(rs.getString("Data_Lanca")) + "</td>\n";
                resp += "  <td class='tdLight' style='border-bottom:0px;background-color:" + cor + "'>" + rs.getString("descr_convenio") + "</td>\n";
                resp += "  <td class='tdLight' style='border-bottom:0px;background-color:" + cor + "'>" + rs.getString("nome") + "</td>\n";
                resp += "  <td class='tdLight' style='border-bottom:0px;background-color:" + cor + "'>" + rs.getString("Procedimento") + "</td>\n";
                resp += "  <td class='tdLight' style='border-bottom:0px;background-color:" + cor + "'>" + Util.formatCurrency((qtde*valor)+"") + "<input type='hidden' name='vlr" + cod_fatura + "' id='vlr" + cod_fatura + "' value='" + (qtde*valor) + "'></td>\n";
                resp += "  <td class='tdLight' align='center' style='border-bottom:0px;background-color:" + cor + "'>" + lote + "&nbsp;</td>\n";
                resp += "</tr>\n";
                resp += "<tr>\n";
                resp += "  <td class='tdLight' style='background-color:" + cor + "'><input disabled type='text' class='caixa' size='10' name='data" + cod_fatura + "' id='data" + cod_fatura + "' maxlength='10' onKeyPress=\"return formatar(this, event, '##/##/####');\"></td>\n";
                resp += "  <td class='tdLight' style='background-color:" + cor + "'><select disabled name='operacao" + cod_fatura + "' id='operacao" + cod_fatura + "' class='caixa'><option value=''></option><option value='1'>Dinheiro</option><option value='2'>Cheque</option><option value='3'>Cartão</option><option value='4'>Internet</option><option value='5'>Débito Automático</option><option value='6'>Depósito</option></select></td>\n";
                resp += "  <td class='tdLight' style='background-color:" + cor + "'><select disabled name='banco" + cod_fatura + "' id='banco" + cod_fatura + "' class='caixa'><option value=''></option>" + new Conta().getBancos(cod_empresa) + "</select></td>\n";
                resp += "  <td class='tdLight' style='background-color:" + cor + "'><input disabled type='text' class='caixa' name='obs" + cod_fatura + "' id='obs" + cod_fatura + "' maxlenght='50' size='30'></td>\n";
                resp += "  <td class='tdLight' style='background-color:" + cor + "'><input disabled type='text' class='caixa' size='10' name='valor" + cod_fatura + "' id='valor" + cod_fatura + "' onBlur='Javascript:atualizarvalor()'></td>\n";
                resp += "  <td class='tdLight' style='background-color:" + cor + "' align='center'><input type='checkbox' name='chk' id='" + cod_fatura + "' value='" + cod_fatura + "' onclick='Javascript:marcarRecebeu(this);atualizarvalor();'></td>\n";
                resp += "</tr>\n";
                retorno.add(resp);
            }

            resp  = "<tr>\n";
            resp += " <td colspan='4' class='tdMedium' align='right'>Valor Total:  </td>";
            resp += " <td class='tdMedium' align='center'>" + Util.formatCurrency(soma+"") + "</td>\n";
            resp += " <td rowspan='2' class='tdMedium' align='center'><button type='button' class='botao' onclick='salvarContas()'><img src='images/gravamini.gif'><br>Gravar</button></td>\n";
            resp += "</tr>\n";
            resp += "<tr>\n";
            resp += " <td colspan='4' class='tdMedium' align='right'>Valor Recebido: </td>";
            resp += " <td class='tdMedium' align='center'><span id='valorrecebido'>R$ 0,00</span></td>\n";
            resp += "</tr>\n";
            retorno.add(resp);


            rs.close();
            stmt.close();

        } catch(SQLException e) {
            retorno.add("ERRO: " + e.toString() + " SQL: " + sql);
        }

        return retorno;
    }

    //Busca a data de recebimento de um lote
    public String getDataRecebimento(String lote) {
        //Se não escolheu lote, pegar data atual
        if(Util.isNull(lote)) return Util.getData();

        String resp = "";
        Banco bc = new Banco();

        //Verifica se está em guia de consulta
        resp = Util.formataData(bc.getValor("dataprevisao", "SELECT dataprevisao FROM lotesguias WHERE codLote=" + lote));

        //Se achou, retornar
        if(!Util.isNull(resp)) return resp;
        else return Util.getData();
    }


    //Busca a data de recebimento de um lote
    public String getBancoLote(String lote, String cod_convenio) {
        String resp = "", sql = "";
        Banco bc = new Banco();

        //Busca o convênio do lote
        if(!Util.isNull(lote)) {
            sql  = "SELECT convenio.cod_banco FROM convenio INNER JOIN lotesguias ON ";
            sql += "convenio.cod_ans = lotesguias.registroANS ";
            sql += "WHERE lotesguias.codLote=" + lote;
        }
        else {
            sql = "SELECT convenio.cod_banco FROM convenio WHERE cod_convenio=" + cod_convenio;
        }

        resp = bc.getValor("cod_banco", sql);

        return resp;
    }

    //Recebe os itens checados e o request para gravar no banco
    public String gravarContasReceber(String chks[], HttpServletRequest request) {
        String resp = "";

        //Se não voltou nada nos chks, retornar
        if(chks == null) return "vetor nulo";

        //Varre o vetor para pegar todos os chks
        for(int i=0; i<chks.length; i++) {

          //Recupera valores dos campos
          String valor = Util.getValorMoney(request.getParameter("valor" + chks[i]));
          String data = Util.formataDataInvertida(request.getParameter("data" + chks[i]));
          String operacao = request.getParameter("operacao" + chks[i]);
          String banco = request.getParameter("banco" + chks[i]);
          String obs = request.getParameter("obs" + chks[i]);

          String sql = "UPDATE faturas_itens SET valor_recebido=" + valor;
          sql += ",data_recebido='" + data + "',operacao_recebido=" + operacao;
          sql += ",banco_recebido=" + banco + ",obs_recebido='" + obs + "' ";
          sql += "WHERE cod_subitem=" + chks[i];

          resp = new Banco().executaSQL(sql);
          
          //Se deu algum erro, retornar
          if(!resp.equalsIgnoreCase("OK")) return resp;
        }

        return resp;
    }

    //Cria relatório de fluxo de caixa de contas a pagar e receber
    public Vector getRelFluxoCaixa(String de, String ate, String cp_pagar, String cp_pagos, String cr_receber, String cr_recebidos, String ordem) {
        //Retorno dos dados
        Vector retorno = new Vector();
        boolean troca = false;
        String cor = "", corfonte = "", resp = "";

        //Converte as datas
        de = Util.formataDataInvertida(de);
        ate = Util.formataDataInvertida(ate);

        String sql = "";

        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);

            ResultSet rs = null;

            //Contas a Pagar
            if(!Util.isNull(cp_pagar)) {
                sql +=  "SELECT data_vencimento AS data, data_pagamento AS data_pagamento, ";
                sql += "descricao AS descricao, valortotal AS valor, valorpago AS valorpago, 'C' AS tipo ";
                sql += "FROM contas WHERE valorpago IS null ";
                sql += " AND data_vencimento BETWEEN '" + de + "' AND '" + ate + "' ";
            }

            //Contas a Pagar pagas
            if(!Util.isNull(cp_pagos)) {

                //Se já tiver selecionado anteriormente, juntar SQL com Union
                if(sql.length()>0) sql += " UNION ";

                sql +=  "SELECT data_vencimento AS data, data_pagamento AS data_pagamento, ";
                sql += "descricao AS descricao, valortotal AS valor, valorpago AS valorpago, 'C' AS tipo ";
                sql += "FROM contas WHERE data_pagamento BETWEEN '" + de + "' AND '" + ate + "' ";
            }


            //Contas a Receber em aberto (valor recebido nulo)
            if(!Util.isNull(cr_receber)) {

                //Se já tiver selecionado anteriormente, juntar SQL com Union
                if(sql.length()>0) sql += " UNION ";

                //Pega lançamentos juntando com guias de consulta
                sql +=  "SELECT IF(lotesguias.dataprevisao IS NULL, faturas.Data_Lanca, lotesguias.dataprevisao) AS DATA, ";
                sql += "faturas_itens.data_recebido AS data_pagamento, ";
                sql += "CONCAT(paciente.nome,' (',procedimentos.Procedimento,')') AS descricao, ";
                sql += "faturas_itens.qtde*faturas_itens.valor AS valor, ";
                sql += "faturas_itens.valor_recebido AS valorpago, 'D' AS tipo ";
                sql += "FROM ((((faturas INNER JOIN paciente ON faturas.codcli = paciente.codcli) INNER JOIN ";
                sql += "faturas_itens ON faturas.Numero = faturas_itens.Numero) INNER JOIN procedimentos ON ";
                sql += "faturas_itens.Cod_Proced = procedimentos.COD_PROCED) LEFT JOIN guiasconsulta ON ";
                sql += "faturas.Numero = guiasconsulta.numeroFatura) LEFT JOIN lotesguias ON ";
                sql += "guiasconsulta.codLote = lotesguias.codLote ";
                sql += "WHERE faturas_itens.valor_recebido IS NULL ";
                sql += "HAVING DATA BETWEEN '" + de + "' AND '" + ate + "'";

                //Pega lançamentos juntando com guias de SADT
                sql += " UNION ";

                sql +=  "SELECT IF(lotesguias.dataprevisao IS NULL, faturas.Data_Lanca, lotesguias.dataprevisao) AS DATA, ";
                sql += "faturas_itens.data_recebido AS data_pagamento, ";
                sql += "CONCAT(paciente.nome,' (',procedimentos.Procedimento,')') AS descricao, ";
                sql += "faturas_itens.qtde*faturas_itens.valor AS valor, ";
                sql += "faturas_itens.valor_recebido AS valorpago, 'D' AS tipo ";
                sql += "FROM ((((faturas INNER JOIN paciente ON faturas.codcli = paciente.codcli) INNER JOIN ";
                sql += "faturas_itens ON faturas.Numero = faturas_itens.Numero) INNER JOIN procedimentos ON ";
                sql += "faturas_itens.Cod_Proced = procedimentos.COD_PROCED) LEFT JOIN guiassadt ON ";
                sql += "faturas.Numero = guiassadt.numeroFatura) LEFT JOIN lotesguias ON ";
                sql += "guiassadt.codLote = lotesguias.codLote ";
                sql += "WHERE faturas_itens.valor_recebido IS NULL ";
                sql += "HAVING DATA BETWEEN '" + de + "' AND '" + ate + "'";
            }

            //Contas a Receber em Recebidas (valor recebido não nulo)
            if(!Util.isNull(cr_recebidos)) {

                //Se já tiver selecionado anteriormente, juntar SQL com Union
                if(sql.length()>0) sql += " UNION ";

                //Pega lançamentos juntando com guias de consulta
                sql +=  "SELECT IF(lotesguias.dataprevisao IS NULL, faturas.Data_Lanca, lotesguias.dataprevisao) AS DATA, ";
                sql += "faturas_itens.data_recebido AS data_pagamento, ";
                sql += "CONCAT(paciente.nome,' (',procedimentos.Procedimento,')') AS descricao, ";
                sql += "faturas_itens.qtde*faturas_itens.valor AS valor, ";
                sql += "faturas_itens.valor_recebido AS valorpago, 'D' AS tipo ";
                sql += "FROM ((((faturas INNER JOIN paciente ON faturas.codcli = paciente.codcli) INNER JOIN ";
                sql += "faturas_itens ON faturas.Numero = faturas_itens.Numero) INNER JOIN procedimentos ON ";
                sql += "faturas_itens.Cod_Proced = procedimentos.COD_PROCED) LEFT JOIN guiasconsulta ON ";
                sql += "faturas.Numero = guiasconsulta.numeroFatura) LEFT JOIN lotesguias ON ";
                sql += "guiasconsulta.codLote = lotesguias.codLote ";
                sql += "WHERE faturas_itens.data_recebido BETWEEN '" + de + "' AND '" + ate + "'";

                //Pega lançamentos juntando com guias de SADT
                sql += " UNION ";

                sql +=  "SELECT IF(lotesguias.dataprevisao IS NULL, faturas.Data_Lanca, lotesguias.dataprevisao) AS DATA, ";
                sql += "faturas_itens.data_recebido AS data_pagamento, ";
                sql += "CONCAT(paciente.nome,' (',procedimentos.Procedimento,')') AS descricao, ";
                sql += "faturas_itens.qtde*faturas_itens.valor AS valor, ";
                sql += "faturas_itens.valor_recebido AS valorpago, 'D' AS tipo ";
                sql += "FROM ((((faturas INNER JOIN paciente ON faturas.codcli = paciente.codcli) INNER JOIN ";
                sql += "faturas_itens ON faturas.Numero = faturas_itens.Numero) INNER JOIN procedimentos ON ";
                sql += "faturas_itens.Cod_Proced = procedimentos.COD_PROCED) LEFT JOIN guiassadt ON ";
                sql += "faturas.Numero = guiassadt.numeroFatura) LEFT JOIN lotesguias ON ";
                sql += "guiassadt.codLote = lotesguias.codLote ";
                sql += "WHERE faturas_itens.data_recebido BETWEEN '" + de + "' AND '" + ate + "'";
            }

            //Ordena
            sql += "ORDER BY " + ordem;

            //Executa a pesquisa
            rs = stmt.executeQuery(sql);

            //Cabeçalho
            resp  = "<tr>\n";
            resp += " <td class='tblrel' style='background-color:#CCCCCC'><b>Data Vencimento</b></td>\n";
            resp += " <td class='tblrel' style='background-color:#CCCCCC'><b>Valor Previsto</b></td>\n";
            resp += " <td class='tblrel' style='background-color:#CCCCCC'><b>Descrição</b></td>\n";
            resp += " <td class='tblrel' style='background-color:#CCCCCC'><b>Data Efetuada</b></td>\n";
            resp += " <td class='tblrel' style='background-color:#CCCCCC'><b>Valor Efetuado</b></td>\n";
            resp += "</tr>\n";

            retorno.add(resp);

            //Totais
            float totalC1=0, totalC2=0, totalD1=0, totalD2=0, total=0;

            while(rs.next()) {

                //Troca a cor
                if(troca) {
                    cor = "#FFFFFF";
                    troca = false;
                }
                else {
                    cor = "#DEDEDE";
                    troca = true;
                }

                //Troca a cor da fonte
                if(rs.getString("tipo").equals("C")) {
                    corfonte = "red";
                    totalC1 += rs.getFloat("valor");
                    totalC2 += rs.getFloat("valorpago");
                }
                else {
                    corfonte = "blue";
                    totalD1 += rs.getFloat("valor");
                    totalD2 += rs.getFloat("valorpago");
                }

                resp  = "<tr>\n";
                resp += " <td class='tblrel' style='background-color:" + cor + ";color:" + corfonte + "'>" + Util.formataData(rs.getString("data")) + "</td>\n";
                resp += " <td class='tblrel' style='background-color:" + cor + ";color:" + corfonte + "'>" + Util.formatCurrency(rs.getString("valor")) + "</td>\n";
                resp += " <td class='tblrel' style='background-color:" + cor + ";color:" + corfonte + "'>" + rs.getString("descricao") + "</td>\n";
                resp += " <td class='tblrel' style='background-color:" + cor + ";color:" + corfonte + "'>" + Util.formataData(rs.getString("data_pagamento")) + "&nbsp;</td>\n";
                resp += " <td class='tblrel' style='background-color:" + cor + ";color:" + corfonte + "'4>" + Util.formatCurrency(Util.trataNulo(rs.getString("valorpago"),"")) + "&nbsp;</td>\n";
                resp += "</tr>\n";
                
                retorno.add(resp);
            }

            resp  = "<tr>\n";
            resp += " <td class='tblrel' style='background-color:#CCCCCC;color:red'><b>Débitos:</b></td>\n";
            resp += " <td class='tblrel' style='background-color:#CCCCCC;color:red'><b>" + Util.formatCurrency(totalC1+"") + "</b></td>\n";
            resp += " <td class='tblrel' style='background-color:#CCCCCC;color:red'>&nbsp;</td>\n";
            resp += " <td class='tblrel' style='background-color:#CCCCCC;color:red'>&nbsp;</td>\n";
            resp += " <td class='tblrel' style='background-color:#CCCCCC;color:red'><b>" + Util.formatCurrency(totalC2+"") + "&nbsp;</b></td>\n";
            resp += "</tr>\n";
            resp += "<tr>\n";
            resp += " <td class='tblrel' style='background-color:#CCCCCC;color:blue'><b>Créditos:</b></td>\n";
            resp += " <td class='tblrel' style='background-color:#CCCCCC;color:blue'><b>" + Util.formatCurrency(totalD1+"") + "</b></td>\n";
            resp += " <td class='tblrel' style='background-color:#CCCCCC;color:blue'>&nbsp;</td>\n";
            resp += " <td class='tblrel' style='background-color:#CCCCCC;color:blue'>&nbsp;</td>\n";
            resp += " <td class='tblrel' style='background-color:#CCCCCC;color:blue'><b>" + Util.formatCurrency(totalD2+"") + "&nbsp;</b></td>\n";
            resp += "</tr>\n";
            resp += "<tr>\n";
            
            //Verifica cor da fonte
            if(totalD1 > totalC1) corfonte = "blue";
            else corfonte = "red";

            resp += " <td class='tblrel' style='background-color:#CCCCCC;'><b>Saldo:</b></td>\n";
            resp += " <td class='tblrel' style='background-color:#CCCCCC;color:" + corfonte + "'><b>" + Util.formatCurrency((totalD1-totalC1)+"") + "</b></td>\n";
            resp += " <td class='tblrel' style='background-color:#CCCCCC;'>&nbsp;</td>\n";
            resp += " <td class='tblrel' style='background-color:#CCCCCC;'>&nbsp;</td>\n";

            //Verifica cor da fonte
            if(totalD2 > totalC2) corfonte = "blue";
            else corfonte = "red";
            
            resp += " <td class='tblrel' style='background-color:#CCCCCC;color:" + corfonte + "'><b>" + Util.formatCurrency((totalD2-totalC2)+"") + "&nbsp;</b></td>\n";
            resp += "</tr>\n";

            retorno.add(resp);

            rs.close();
            stmt.close();

        } catch(SQLException e) {
            retorno.add("ERRO: " + e.toString() + " SQL: " + sql);
        }

        return retorno;
    }

}