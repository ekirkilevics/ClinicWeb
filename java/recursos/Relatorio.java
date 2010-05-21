/* Arquivo: Relatorio.java
 * Autor: Amilton Souza Martha
 * Criação: 14/03/2006   Atualização: 04/06/2009
 * Obs: Manipula informações dos Relatórios
 */

package recursos;
import java.sql.*;
import java.util.*;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;

public class Relatorio {
    
    //Atributos privados para conexão
    private Connection con = null;
    private Statement stmt = null;
    
    //Variáveis 'globais'
    private String colunasFiltroAgenda[] = {"Profissional", "Data", "Hora", "Paciente", "Registro", "Telefones", "Procedimento", "Convênio", "Status do Paciente", "Retorno", "Encaixe", "Agendado por", "Observação"};

    
    public Relatorio() {
        con = Conecta.getInstance();
    }
    
    //Relatório de Lancamentos
    public Vector getLancamentos(String de, String ate, String agrupar, String filtros[], String primeiravez) {
        //Retorno dos dados
        Vector retorno = new Vector();
        
        //Vetor de Strings com equivalências de Pesquisa
        String campos[] = {"Executante.prof_reg","Solicitante.prof_reg", "paciente.codcli", "especialidade.codesp", "convenio.cod_convenio", "Solicitante.locacao","procedimentos.COD_PROCED", "procedimentos.grupoproced" };
        
        //Coloca as datas no formato correto pro SQL (aaaa/mm/dd)
        de = Util.formataDataInvertida(de);
        ate = Util.formataDataInvertida(ate);
        
        //Monta sql para consulta
        String sql =  "SELECT faturas.Data_Lanca, faturas.hora_lanca, ";
        sql += "paciente.nome, Executante.nome, Solicitante.nome, paciente.codcli, ";
        sql += "faturas_itens.qtde, procedimentos.Procedimento, ";
        sql += "convenio.descr_convenio, faturas_itens.cod_subitem, ";
        sql += "faturas_itens.tipo_pagto, faturas_itens.valor, especialidade.descri ";
        sql += "FROM ((((faturas LEFT JOIN paciente ON faturas.codcli = ";
        sql += "paciente.codcli) INNER JOIN ((procedimentos RIGHT JOIN ";
        sql += "faturas_itens ON procedimentos.COD_PROCED = ";
        sql += "faturas_itens.Cod_Proced) INNER JOIN especialidade ON ";
        sql += "procedimentos.codesp = especialidade.codesp) ON ";
        sql += "faturas.Numero = faturas_itens.Numero) LEFT JOIN ";
        sql += "profissional AS Solicitante ON faturas.Cod_Solicitante = ";
        sql += "Solicitante.prof_reg) LEFT JOIN profissional AS Executante ";
        sql += "ON faturas.prof_reg = Executante.prof_reg) LEFT JOIN ";
        sql += "convenio ON faturas_itens.cod_convenio = convenio.cod_convenio ";
        sql += "WHERE faturas.Data_Lanca BETWEEN '" + de + "' AND '" + ate + "' ";
        
        for(int j=0; j<campos.length; j++) {
            if(!filtros[j].equals("todos")) {
                sql += "AND " + campos[j] + "='" + filtros[j] + "' ";
            }
        }

        if(agrupar.equals("faturas.Data_Lanca"))
            sql += "ORDER BY " + agrupar + ", paciente.nome";
        else
            sql += "ORDER BY " + agrupar + ",faturas.Data_Lanca, paciente.nome";
        
        String resp = "";
        String hora;
        float valor=0, soma=0, somageral=0;
        int somaQtde=0, somageralQtde = 0;
        String anterior="", atual="";
        String solicitante="";
        String cor="#EEEEEE";
        boolean troca = false;
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            ResultSet rs = null;
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            resp  = "<tr>\n";
            resp += "<td class='tblrel' style='background-color:black; color:white'><b>Data</b></td>\n";
            resp += "<td class='tblrel' style='background-color:black; color:white'><b>Hora</b></td>\n";
            resp += "<td class='tblrel' style='background-color:black; color:white'><b>Paciente</b></td>\n";
            resp += "<td class='tblrel' style='background-color:black; color:white'><b>Executante</b></td>\n";
            resp += "<td class='tblrel' style='background-color:black; color:white'><b>Solicitante</b></td>\n";
            resp += "<td class='tblrel' style='background-color:black; color:white'><b>Qtde</b></td>\n";
            resp += "<td class='tblrel' style='background-color:black; color:white'><b>Procedimento</b></td>\n";
            resp += "<td class='tblrel' style='background-color:black; color:white'><b>Especialidade</b></td>\n";
            resp += "<td class='tblrel' style='background-color:black; color:white'><b>Convênio</b></td>\n";
            resp += "<td class='tblrel' style='background-color:black; color:white'><b>Total</b></td>\n";
            resp += "</tr>\n";
            
            //Adiciona cabeçalho ao retorno
            retorno.add(resp);
            
            //Cria looping com a resposta
            while(rs.next()) {
                
                //Se não tem filtro de primeira vez OU tem e é primeira vez
                if(Util.isNull(primeiravez) || (primeiravez.equalsIgnoreCase("S") && Util.primeiraVez(rs.getString("codcli"), Util.formataData(rs.getString("Data_Lanca")), true))) {
                
                    //Se a hora estiver null, imprimir espaço em branco
                    hora = rs.getString("hora_lanca") != null? rs.getString("hora_lanca") : "&nbsp;";

                    //Pega o valor atual do campo que está sendo ordenado
                    //Se for a data, pegar formatada, senão, o camp mesmo
                    atual = agrupar.equals("faturas.Data_Lanca") ? Util.formataData(rs.getString("Data_Lanca")) : rs.getString(agrupar);

                    //Pega valor do solicitante e verifica se está nulo
                    solicitante = rs.getString("Solicitante.nome") != null ? rs.getString("Solicitante.nome") : "N/C";

                    //Se o item anterior for diferente do atual, inserir linha de subtotal
                    if(!anterior.equals(atual) && !anterior.equals("")) {
                        resp = "";
                        resp += "<tr>\n";
                        resp += "<td colspan=5 class='tblrel' style='background-color:#CCCCCC' align='right'><b>Sub-Total: </b></td>\n";
                        resp += "<td class='tblrel' align='center' style='background-color:#CCCCCC'><b>" + somaQtde + "</b></td>\n";
                        resp += "<td colspan=4 class='tblrel' align='right' style='background-color:#CCCCCC'><b>" + Util.formatCurrency(soma+"") + "</b></td>\n";
                        resp += "</tr>\n";

                        //Adiciona linha na saída
                        retorno.add(resp);

                        //Zera acumulador
                        soma = 0;
                        somaQtde = 0;
                    }

                    //Calcula o valor
                    valor = rs.getFloat("faturas_itens.valor") * rs.getInt("qtde");

                    //Acumula valores
                    soma += valor;
                    somageral += valor;
                    somaQtde += rs.getInt("qtde");
                    somageralQtde += rs.getInt("qtde");

                    resp = "";
                    //Alterna as cores do fundo
                    if(troca) {
                        resp += "<tr style='background-color:#FFFFFF'>\n";
                        troca = false;
                    } else {
                        resp += "<tr style='background-color:#EEEEEE'>\n";
                        troca = true;
                    }

                    resp += "	<td class='tblrel'>" + Util.formataData(rs.getString("Data_Lanca")) + "</td>\n";
                    resp += "	<td class='tblrel'>" + hora + "</td>\n";
                    resp += "	<td class='tblrel'>" + rs.getString("paciente.nome") + "</td>\n";
                    resp += "	<td class='tblrel'>" + rs.getString("Executante.nome") + "</td>\n";
                    resp += "	<td class='tblrel'>" + solicitante + "</td>\n";
                    resp += "	<td class='tblrel' align='center'>" + rs.getString("qtde") + "</td>\n";
                    resp += "	<td class='tblrel'>" + rs.getString("Procedimento") + "</td>\n";
                    resp += "	<td class='tblrel'>" + rs.getString("especialidade.descri") + "</td>\n";
                    resp += "	<td class='tblrel'>" + rs.getString("descr_convenio") + "</td>\n";
                    resp += "	<td class='tblrel' align='right'>" + Util.formatCurrency(valor+"") + "</td>\n";
                    resp += "</tr>\n";

                    //Captura o campo que está sendo agrupado/ordenado para ver se mudou de valor na próxima
                    anterior = agrupar.equals("faturas.Data_Lanca") ? Util.formataData(rs.getString("Data_Lanca")) : rs.getString(agrupar);

                    //Se for nulo, colocar String vazia para não dar erro no .equals
                    if(anterior==null) anterior = "";

                    //Adiciona cada linha ao retorno
                    retorno.add(resp);
                }
            }
            
            //Quando acabar o looping, dar o subtotal do último e total geral
            resp = "";
            resp += "<tr>\n";
            resp += "<td colspan=5 class='tblrel' align='right' style='background-color:#CCCCCC'><b>Sub-Total: </b></td>\n";
            resp += "<td class='tblrel' align='center' style='background-color:#CCCCCC'><b>" + somaQtde + "</b></td>\n";
            resp += "<td colspan=4 class='tblrel' align='right' style='background-color:#CCCCCC'><b>" + Util.formatCurrency(soma+"") + "</b></td>\n";
            resp += "</tr>\n";
            
            resp += "<tr>\n";
            resp += "<td colspan=10>&nbsp;</td>\n";
            resp += "</tr>\n";
            
            resp += "<tr>\n";
            resp += "<td colspan=5 class='tblrel' align='right' style='background-color:black; color:white'><b>Total: </b></td>\n";
            resp += "<td class='tblrel' align='center' style='background-color:black; color:white'><b>" + somageralQtde + "</b></td>\n";
            resp += "<td colspan=4 class='tblrel' align='right' style='background-color:black; color:white'><b>" + Util.formatCurrency(somageral+"") + "</b></td>\n";
            resp += "</tr>\n";
            
            //Adiciona linha na saída
            retorno.add(resp);

            //Insere Honorário Individual
            retorno.add("<tr><td colspan=10><table cellspacing='0' cellpadding='0' width='100%'>");
            retorno.add(this.getRelHonorarioIndividual(de, ate, filtros, campos));
            retorno.add("</table></td></tr>");
            
            rs.close();
            stmt.close();

            return retorno;
        } catch(SQLException e) {
            retorno.add(e.toString() + "<br>" + sql);
            return retorno;
        }
    }

    private String getRelHonorarioIndividual(String de, String ate, String filtros[], String campos[]) {
        String sql = "";
        String resp = "";
        boolean troca = false;
        int totalQtde=0;
        float totalValor=0;

        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);

            sql  = "SELECT honorario_item.data, paciente.nome, Executante.nome, Executante.prof_reg, ";
            sql += "hospitais.descricao, honorario_item.qtde, procedimentos.Procedimento, ";
            sql += "especialidade.descri, convenio.descr_convenio, honorario_item.valor ";
            sql += "FROM (((honorario_item INNER JOIN procedimentos ON honorario_item.cod_proced = ";
            sql += "procedimentos.COD_PROCED) INNER JOIN especialidade ON procedimentos.codesp = ";
            sql += "especialidade.codesp) INNER JOIN ((profissional AS Executante INNER JOIN ";
            sql += "(honorarios INNER JOIN paciente ON honorarios.codcli = paciente.codcli) ON ";
            sql += "Executante.prof_reg = honorarios.prof_reg) INNER JOIN hospitais ON ";
            sql += "honorarios.cod_hospital = hospitais.cod_hospital) ON ";
            sql += "honorario_item.cod_honorario = honorarios.cod_honorario) INNER JOIN ";
            sql += "(convenio INNER JOIN planos ON convenio.cod_convenio = planos.cod_convenio) ";
            sql += "ON honorarios.cod_convenio = planos.cod_plano ";
            sql += "WHERE honorario_item.data BETWEEN '" + de + "' AND '" + ate + "' ";

            //Insere filtros
            for(int j=0; j<campos.length; j++) {
                if(!filtros[j].equals("todos")) {
                    //Não tem solicitante
                    if(!campos[j].equalsIgnoreCase("Solicitante.prof_reg") && !campos[j].equalsIgnoreCase("Solicitante.locacao"))
                        sql += "AND " + campos[j] + "='" + filtros[j] + "' ";
                }
            }

            resp  = "<tr>\n";
            resp += " <td colspan='9'>&nbsp;</td>\n";
            resp += "</tr>\n";
            resp += "<tr>\n";
            resp += " <td colspan='9' class='tblrel' style='border-left-width:0px'><b>GUIAS DE HONORÁRIO INDIVIDUAL</b></td>\n";
            resp += "</tr>\n";
            resp += "<tr>\n";
            resp += " <td class='tblrel' style='background-color:black; color:white'><b>Data</b></td>\n";
            resp += " <td class='tblrel' style='background-color:black; color:white'><b>Paciente</b></td>\n";
            resp += " <td class='tblrel' style='background-color:black; color:white'><b>Executante</b></td>\n";
            resp += " <td class='tblrel' style='background-color:black; color:white'><b>Hospital</b></td>\n";
            resp += " <td class='tblrel' style='background-color:black; color:white'><b>Qtde</b></td>\n";
            resp += " <td class='tblrel' style='background-color:black; color:white'><b>Procedimento</b></td>\n";
            resp += " <td class='tblrel' style='background-color:black; color:white'><b>Especialidade</b></td>\n";
            resp += " <td class='tblrel' style='background-color:black; color:white'><b>Convênio</b></td>\n";
            resp += " <td class='tblrel' style='background-color:black; color:white'><b>Total</b></td>\n";
            resp += "</tr>\n";


            ResultSet rs = null;
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);

            while(rs.next()) {
                    //Valores
                    int qtde = rs.getInt("qtde");
                    float valor = rs.getFloat("valor");
                    totalQtde += qtde;
                    totalValor += (valor*qtde);

                    //Alterna as cores do fundo
                    if(troca) {
                        resp += "<tr style='background-color:#FFFFFF'>\n";
                        troca = false;
                    } else {
                        resp += "<tr style='background-color:#EEEEEE'>\n";
                        troca = true;
                    }

                    resp += "	<td class='tblrel'>" + Util.formataData(rs.getString("data")) + "</td>\n";
                    resp += "	<td class='tblrel'>" + rs.getString("paciente.nome") + "</td>\n";
                    resp += "	<td class='tblrel'>" + rs.getString("executante.nome") + "</td>\n";
                    resp += "	<td class='tblrel'>" + rs.getString("hospitais.descricao") + "</td>\n";
                    resp += "	<td class='tblrel' align='center'>" + qtde + "</td>\n";
                    resp += "	<td class='tblrel'>" + rs.getString("Procedimento") + "</td>\n";
                    resp += "	<td class='tblrel'>" + rs.getString("especialidade.descri") + "</td>\n";
                    resp += "	<td class='tblrel'>" + rs.getString("convenio.descr_convenio") + "</td>\n";
                    resp += "	<td class='tblrel' align='right'>" + Util.formatCurrency((qtde*valor)+"") + "</td>\n";
                    resp += "</tr>\n";

            }
            resp += "	<td class='tblrel' colspan=4 style='background-color:black; color:white' align='right'>Total:</td>\n";
            resp += "	<td class='tblrel' style='background-color:black; color:white' align='center'>" + totalQtde + "</td>\n";
            resp += "	<td class='tblrel' colspan='4' align='right'style='background-color:black; color:white'>" + Util.formatCurrency(totalValor+"") + "</td>\n";
            resp += "</tr>\n";


        }
        catch(SQLException e) {
            resp = "ERRO: " + e.toString() + " SQL: " + sql;
        }

        return resp;
    }
    
    //Relatório de Listagem de Lote
    //tiporel=1 --> Só cabeçalho
    //tiporel=2 --> Cabeçalho + Listagem
    public Vector getListagemLote(String n_lote, String tiporel) {
        //Retorno dos dados
        Vector retorno = new Vector();
        String sql = "";
        String resp = "";
        String tipoGuia = "";
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            ResultSet rs = null;

            //Busca dados do lote
            sql  = "SELECT configuracoes.nomeFantasia, ";
            sql += "configuracoes.codCNES, lotesguias.* ";
            sql += "FROM lotesguias INNER JOIN configuracoes ";
            sql += "ON lotesguias.cod_empresa = configuracoes.cod_empresa ";
            sql += "WHERE codLote=" + n_lote;
            rs = stmt.executeQuery(sql);
            
             //Se achou, pegar dados
            if(rs.next()) {
                tipoGuia = rs.getString("tipoGuia");
                String codANS = rs.getString("registroANS");

                //Se existe logo, imprimir
                if(Util.existeArquivo("images/convenios/logo" + codANS + ".jpg"))
                    resp += "<img src='images/convenios/logo" + codANS + ".jpg' border='0'><br>";

                resp += "<div class='texto' style='font-size:14px'><b>Dados da Operadora</b></div>\n";
                resp += "<table style='background-color:#EFEFEF; border: 1px solid #111111' width='90%' cellspacing=0 cellppading=0>\n";
                resp += "<tr><td class='tblrel' style='font-size:14px'><b style='color:red'>ANS nº " + codANS + "</b></td><td class='tblrel' style='font-size:14px'><b style='color:red'>Operadora: " + rs.getString("identificacao").toUpperCase() + "</b></td></tr>";
                resp += "</table>\n";
                
                resp += "<div class='texto' style='font-size:14px'><b>Dados da Prestador</b></div>\n";
                resp += "<table style='background-color:#EFEFEF; border: 1px solid #111111' width='90%' cellspacing=0 cellppading=0>\n";
                resp += "<tr><td class='tblrel'>Código/CNPJ/CPF: " + rs.getString("codigoPrestadorNaOperadora") + "</td><td class='tblrel'>Prestador: " + rs.getString("nomeFantasia") + "</td><td class='tblrel'>Cód. CNES: " + rs.getString("codCNES") + "</td></tr>\n";
                resp += "</table>";

                resp += "<div class='texto' style='font-size:14px'><b>Dados do Lote</b></div>\n";
                resp += "<table style='background-color:#EFEFEF; border: 1px solid #111111' width='90%' cellspacing=0 cellppading=0>\n";
                resp += "<tr><td class='tblrel'>Número do Lote: " + rs.getString("codLote") + "</td><td class='tblrel'>Data do Lote: " + Util.formataData(rs.getString("dataRegistroTransacao")) + "</td></tr>\n";
                resp += "</table>";

                resp += "<div class='texto' style='font-size:14px'><b>Dados da Fatura</b></div>\n";
                resp += "<table style='background-color:#EFEFEF; border: 1px solid #111111' width='90%' cellspacing=0 cellppading=0>\n";
                resp += "<tr><td class='tblrel' style='font-size:14px'><b style='color:red'>Número da Fatura: " + Util.trataNulo(rs.getString("nf"),"N/C") + "</b></td><td class='tblrel' style='font-size:12px'><b style='color:red'>Data Previsão de Pagto: " + Util.formataData(rs.getString("dataprevisao")) + "</b></td></tr>\n";
                resp += "</table>";

                //Se também quer a listagem
                if(tiporel.equals("2")) {
                    if(tipoGuia.equals("1")) 
                        retorno = getListagemLoteConsulta(n_lote);
                    else if(tipoGuia.equals("2")) 
                        retorno = getListagemLoteSADT(n_lote);
                    else
                        retorno = getListagemLoteHonorarios(n_lote);
                }
                
                //Insere o cabeçalho antes da lista e pula uma linha
                retorno.add(0,resp);
                retorno.add(1,"<br>");
            }
        }
        catch(SQLException e) {
            retorno.add("ERRO: " + e.toString() + " SQL: " + sql);
        }
 
        return retorno;
    }

    public Vector getLogAgendas(String data, String prof_reg, String ordem) {
        //Retorno dos dados
        Vector retorno = new Vector();
        String sql = "";
        String resp = "";
        String cor = "";
        boolean troca = true;
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            ResultSet rs = null;

            //Busca dados do lote
            sql  = "SELECT agendamento.hora, paciente.nome, grupoprocedimento.grupoproced, ";
            sql += "agendamento.obs, convenio.descr_convenio, planos.plano, ";
            sql += "paciente.registro_hospitalar, usuario_inclusao.ds_nome, agendamento.data_inclusao, ";
            sql += "agendamento.hora_inclusao, usuario_exclusao.ds_nome, agendamento.data_exclusao, ";
            sql += "agendamento.hora_exclusao, agendamento.ativo ";
            sql += "FROM (((((agendamento INNER JOIN paciente ON agendamento.codcli = paciente.codcli) ";
            sql += "INNER JOIN convenio ON agendamento.cod_convenio = convenio.cod_convenio) ";
            sql += "LEFT JOIN planos ON agendamento.cod_plano = planos.cod_plano) ";
            sql += "INNER JOIN grupoprocedimento ON agendamento.cod_proced = grupoprocedimento.cod_grupoproced) ";
            sql += "LEFT JOIN t_usuario AS usuario_inclusao ON agendamento.usuario_inclusao = usuario_inclusao.cd_usuario) ";
            sql += "LEFT JOIN t_usuario AS usuario_exclusao ON agendamento.usuario_exclusao = usuario_exclusao.cd_usuario ";
            sql += "WHERE agendamento.data='" + Util.formataDataInvertida(data) + "' ";
            sql += "AND agendamento.prof_reg='" + prof_reg + "' ";
            sql += "ORDER BY " + ordem;

            //retorno.add("<tr><td colspan=7>" + sql + "<td></tr>");
            rs = stmt.executeQuery(sql);
            
            resp  = "<tr>\n";
            resp += "  <td class='tblrel' style='background-color:#CCCCCC'><a title='Ordenar por Hora' href=\"Javascript:ordenar('relagendagerencial2','hora')\"><b>Hora da Agenda</b></a></td>\n";
            resp += "  <td class='tblrel' style='background-color:#CCCCCC'><a title='Ordenar por registro' href=\"Javascript:ordenar('relagendagerencial2','registro_hospitalar')\"><b>Registro</b></a></td>\n";
            resp += "  <td class='tblrel' style='background-color:#CCCCCC'><a title='Ordenar por paciente' href=\"Javascript:ordenar('relagendagerencial2','nome')\"><b>Paciente</b></a></td>\n";
            resp += "  <td class='tblrel' style='background-color:#CCCCCC'><a title='Ordenar por Procedimento' href=\"Javascript:ordenar('relagendagerencial2','Procedimento')\"><b>Procedimento</b></a></td>\n";
            resp += "  <td class='tblrel' style='background-color:#CCCCCC'><a title='Ordenar por Convênio' href=\"Javascript:ordenar('relagendagerencial2','descr_convenio')\"><b>Convênio</b></a></td>\n";
            resp += "  <td class='tblrel' style='background-color:#CCCCCC'><b>Plano</td>\n";
            resp += "  <td class='tblrel' style='background-color:#CCCCCC'><b>Observação</b></td>\n";
            resp += "  <td class='tblrel' style='background-color:#CCCCCC'><a title='Ordenar pelo usuário de inclusão' href=\"Javascript:ordenar('relagendagerencial2','usuario_inclusao.ds_nome')\"><b>Usuário Inclusão</b></a></td>\n";
            resp += "  <td class='tblrel' style='background-color:#CCCCCC'><a title='Ordenar por Data Inclusão' href=\"Javascript:ordenar('relagendagerencial2','data_inclusao')\"><b>Data Inclusão</b></a></td>\n";
            resp += "  <td class='tblrel' style='background-color:#CCCCCC'><a title='Ordenar por Hora Inclusão' href=\"Javascript:ordenar('relagendagerencial2','hora_inclusao')\"><b>Hora Inclusão</b></a></td>\n";
            resp += "  <td class='tblrel' style='background-color:#CCCCCC'><a title='Ordenar pelo usuário de exclusão' href=\"Javascript:ordenar('relagendagerencial2','usuario_exclusao.ds_nome')\"><b>Usuário Exclusão</b></a></td>\n";
            resp += "  <td class='tblrel' style='background-color:#CCCCCC'><a title='Ordenar por Data Exclusão' href=\"Javascript:ordenar('relagendagerencial2','data_exclusao')\"><b>Data Exclusão</b></a></td>\n";
            resp += "  <td class='tblrel' style='background-color:#CCCCCC'><a title='Ordenar por Hora Exclusão' href=\"Javascript:ordenar('relagendagerencial2','hora_exclusao')\"><b>Hora Exclusão</b></a></td>\n";
            resp += "</tr>\n";
            retorno.add(resp);
            
            //Se achou, pegar dados
            while(rs.next()) {
                if(troca) {
                    cor = "#FFFFF";
                    troca = false;
                }
                else {
                    cor = "#DDDDDD";
                    troca = true;
                }
                
                resp  = "<tr style='background-color:" + cor + "'>\n";
                resp += "  <td class='tblrel'>" + Util.formataHora(rs.getString("hora")) + "</td>\n";
                resp += "  <td class='tblrel'>" + Util.trataNulo(rs.getString("registro_hospitalar"),"N/C") + "</td>\n";
                resp += "  <td class='tblrel'>" + rs.getString("nome") + "</td>\n";
                resp += "  <td class='tblrel'>" + rs.getString("grupoproced") + "</td>\n";
                resp += "  <td class='tblrel'>" + rs.getString("descr_convenio") + "</td>\n";
                resp += "  <td class='tblrel'>" + Util.trataNulo(rs.getString("plano"),"Não Identificado") + "</td>\n";
                resp += "  <td class='tblrel'>" + Util.trataNulo(rs.getString("obs"),"&nbsp;") + "</td>\n";
                resp += "  <td class='tblrel'>" + Util.trataNulo(rs.getString("usuario_inclusao.ds_nome"),"&nbsp;") + "&nbsp;</td>\n";
                resp += "  <td class='tblrel'>" + Util.formataData(rs.getString("data_inclusao")) + "&nbsp;</td>\n";
                resp += "  <td class='tblrel'>" + Util.formataHora(rs.getString("hora_inclusao")) + "&nbsp;</td>\n";
                resp += "  <td class='tblrel'>" + Util.trataNulo(rs.getString("usuario_exclusao.ds_nome"),"&nbsp;") + "&nbsp;</td>\n";
                resp += "  <td class='tblrel'>" + Util.formataData(rs.getString("data_exclusao")) + "&nbsp;</td>\n";
                resp += "  <td class='tblrel'>" + Util.formataHora(rs.getString("hora_exclusao")) + "&nbsp;</td>\n";
                resp += "</tr>\n";
                //Insere o cabeçalho antes da lista e pula uma linha
                retorno.add(resp);
            }
        }
        catch(SQLException e) {
            retorno.add("ERRO: " + e.toString() + " SQL: " + sql);
        }
 
        return retorno;
    }

    //Relatório de Listagem de Lote de Guias de Consulta
    public Vector getListagemLoteConsulta(String n_lote) {
        //Retorno dos dados
        Vector retorno = new Vector();
        String sql = "";
        String resp = "";
        
        boolean troca = false;
        float soma = 0;
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            ResultSet rs = null;
            sql  = "SELECT procedimentos.Procedimento, guiasconsulta.codigoProcedimento, ";
            sql += "guiasconsulta.numeroGuiaPrestador, guiasconsulta.nomeBeneficiario, ";
            sql += "guiasconsulta.dataAtendimento, faturas_itens.valor ";
            sql += "FROM guiasconsulta LEFT JOIN (procedimentos LEFT JOIN faturas_itens ";
            sql += "ON procedimentos.COD_PROCED = faturas_itens.Cod_Proced) ON ";
            sql += "(guiasconsulta.codigoProcedimento = procedimentos.CODIGO) AND ";
            sql += "(guiasconsulta.numeroFatura = faturas_itens.Numero)";
            sql += " WHERE codLote=" + n_lote + " ORDER BY numeroGuiaPrestador";
            
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            resp  = "<table width='90%' cellspacing=0 cellppading=0>\n";
            resp += "<tr>\n";
            resp += " <td class='tblrel' style='background-color:#CCCCCC'>Nº GUIA</td>\n";
            resp += " <td class='tblrel' style='background-color:#CCCCCC'>BENEFICIÁRIO</td>\n";
            resp += " <td class='tblrel' style='background-color:#CCCCCC'>DATA</td>\n";
            resp += " <td class='tblrel' style='background-color:#CCCCCC'>PROCEDIMENTO</td>\n";
            resp += " <td class='tblrel' style='background-color:#CCCCCC'>VALOR</td>\n";
            resp += "</tr>\n";
            
            //Adiciona cabeçalho ao retorno
            retorno.add(resp);
            
            //Cria looping com a resposta
            while(rs.next()) {
                
                //Acumula valores
                soma += rs.getFloat("valor");
                
                //Alterna as cores do fundo
                if(troca) {
                    resp = "<tr style='background-color:#FFFFFF'>\n";
                    troca = false;
                } else {
                    resp = "<tr style='background-color:#EEEEEE'>\n";
                    troca = true;
                }
                
                resp += "	<td class='tblrel'>" + rs.getString("numeroGuiaPrestador") + "</td>\n";
                resp += "	<td class='tblrel'>" + rs.getString("nomeBeneficiario") + "</td>\n";
                resp += "	<td class='tblrel'>" + Util.formataData(rs.getString("dataAtendimento")) + "</td>\n";
                resp += "	<td class='tblrel'>( " + rs.getString("codigoProcedimento") + ") " + Util.trataNulo(rs.getString("Procedimento"),"N/C") + "</td>\n";
                resp += "	<td class='tblrel'>" + Util.trataNulo(rs.getString("valor"),"N/C") + "</td>\n";
                resp += "</tr>\n";
                
                //Adiciona cada linha ao retorno
                retorno.add(resp);
                
            }
            
            resp  = "<tr style='background-color:#CCCCCC'>\n";
            resp += "  <td class='tblrel' colspan='4' align='right'>TOTAL: </td>\n";
            resp += "  <td class='tblrel'>" + Util.formatCurrency(soma+"") + "</tr>\n";
            resp += "</tr>\n";
            retorno.add(resp);
            
            retorno.add("</table>");
       
            rs.close();
            stmt.close();

            return retorno;
        } catch(SQLException e) {
            retorno.add(e.toString() + "<br>" + sql);
            return retorno;
        }
    }

    //Relatório de Listagem de Lote de Guias de SP/SADT
    public Vector getListagemLoteSADT(String n_lote) {
        //Retorno dos dados
        Vector retorno = new Vector();
        String sql = "";
        String resp = "";
        
        boolean troca = false;
        float soma = 0;
        String guiaOld = "", beneficiarioOld = "", dataOld = "", numeroGuiaOld = "";
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            ResultSet rs = null;
            sql  = "SELECT guiassadt.nomeBeneficiario, guiassadt.numeroGuiaPrestador, ";
            sql += "procedimentossadt.codigo, procedimentossadt.descricao, guiassadt.codGuia, ";
            sql += "procedimentossadt.data, procedimentossadt.quantidadeRealizada, procedimentossadt.valorTotal ";
            sql += "FROM guiassadt INNER JOIN procedimentossadt ON ";
            sql += "guiassadt.codGuia = procedimentossadt.codguia ";
            sql += " WHERE codLote=" + n_lote + " ORDER BY guiassadt.numeroGuiaPrestador";
            
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            resp  = "<table width='90%' cellspacing=0 cellpadding=0>\n";
            resp += "<tr>\n";
            resp += " <td class='tblrel' style='background-color:#CCCCCC'>Nº GUIA</td>\n";
            resp += " <td class='tblrel' style='background-color:#CCCCCC'>BENEFICIÁRIO</td>\n";
            resp += " <td class='tblrel' style='background-color:#CCCCCC'>DATA</td>\n";
            resp += " <td class='tblrel' style='background-color:#CCCCCC'>QTDE</td>\n";
            resp += " <td class='tblrel' style='background-color:#CCCCCC'>PROCEDIMENTO</td>\n";
            resp += " <td class='tblrel' style='background-color:#CCCCCC'>VALOR</td>\n";
            resp += "</tr>\n";
            
            //Adiciona cabeçalho ao retorno
            retorno.add(resp);
            
            //Cria looping com a resposta
            while(rs.next()) {
                
                //Acumula valores
                soma += rs.getFloat("valorTotal");
                
                //Alterna as cores do fundo
                if(troca) {
                    resp = "<tr style='background-color:#FFFFFF'>\n";
                    troca = false;
                } else {
                    resp = "<tr style='background-color:#EEEEEE'>\n";
                    troca = true;
                }
                
                resp += "	<td class='tblrel'>" + rs.getString("numeroGuiaPrestador") + "</td>\n";
                resp += "	<td class='tblrel'>" + rs.getString("nomeBeneficiario") + "</td>\n";
                resp += "	<td class='tblrel'>" + Util.formataData(rs.getString("data")) + "</td>\n";
                resp += "	<td class='tblrel'>" + rs.getString("quantidadeRealizada") + "</td>\n";
                resp += "	<td class='tblrel'>( " + rs.getString("codigo") + ") " + rs.getString("descricao") + "</td>\n";
                resp += "	<td class='tblrel'>" + rs.getString("valorTotal") + "</td>\n";
                resp += "</tr>\n";
                
                //Se a guia atual for diferente da guia anterior, trocou
                if(!guiaOld.equals("") && !guiaOld.equals(rs.getString("codGuia"))) {
                    //Alterna as cores do fundo
                    String aux = "";
                    String resp_somaOutrasDespesas = somaOutrasDespesas(guiaOld, n_lote);

                    aux = "<tr style='background-color:#DEDEDE'>\n";
                    aux += "	<td class='tblrel'>" + numeroGuiaOld + "</td>\n";
                    aux += "	<td class='tblrel'>" + beneficiarioOld + "</td>\n";
                    aux += "	<td class='tblrel'>" + dataOld + "</td>\n";
                    aux += "	<td class='tblrel'>N/C</td>\n";
                    aux += "	<td class='tblrel'>Outras Despesas</td>\n";
                    aux += "	<td class='tblrel'>" + resp_somaOutrasDespesas + "</td>\n";
                    aux += "</tr>\n";
                    
                    //Só adiciona se tiver valor de outras despesas
                    if(!Util.isNull(resp_somaOutrasDespesas)) {
                        retorno.add(aux);
                        soma += Float.parseFloat(somaOutrasDespesas(guiaOld, n_lote));
                    }
                        
                }
                
                //Adiciona cada linha ao retorno
                retorno.add(resp);
                
                //Pega o número da guia para ver a hora que troca
                guiaOld = rs.getString("codGuia");
                beneficiarioOld = rs.getString("nomeBeneficiario");
                dataOld = Util.formataData(rs.getString("data"));
                numeroGuiaOld = rs.getString("numeroGuiaPrestador");
                
            }
            
            //Alterna as cores do fundo
            String aux = "";
            String resp_somaOutrasDespesas = somaOutrasDespesas(guiaOld, n_lote);
            
            aux = "<tr style='background-color:#DEDEDE'>\n";
            aux += "	<td class='tblrel'>" + numeroGuiaOld + "</td>\n";
            aux += "	<td class='tblrel'>" + beneficiarioOld + "</td>\n";
            aux += "	<td class='tblrel'>" + dataOld + "</td>\n";
            aux += "	<td class='tblrel'>N/C</td>\n";
            aux += "	<td class='tblrel'>Outras Despesas</td>\n";
            aux += "	<td class='tblrel'>" + resp_somaOutrasDespesas + "</td>\n";
            aux += "</tr>\n";

            //Só adiciona se tiver valor de outras despesas
            if(!Util.isNull(resp_somaOutrasDespesas)) {
                retorno.add(aux);
                soma += Float.parseFloat(somaOutrasDespesas(guiaOld, n_lote));
            }
            
            resp  = "<tr style='background-color:#CCCCCC'>\n";
            resp += "  <td class='tblrel' colspan='5' align='right'>TOTAL: </td>\n";
            resp += "  <td class='tblrel'>" + Util.formatCurrency(soma+"") + "</tr>\n";
            resp += "</tr>\n";
            retorno.add(resp);
            
            retorno.add("</table>");
       
            rs.close();
            stmt.close();

            return retorno;
        } catch(SQLException e) {
            retorno.add(e.toString() + "<br>" + sql);
            return retorno;
        }
    }

    //Relatório de Listagem de Lote de Guias de Honorário Individual
    public Vector getListagemLoteHonorarios(String n_lote) {
        //Retorno dos dados
        Vector retorno = new Vector();
        String sql = "";
        String resp = "";
        
        boolean troca = false;
        float soma = 0;
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            ResultSet rs = null;
            sql  = "SELECT guiashonorarioindividual.nomeBeneficiario, ";
            sql += "guiashonorarioindividual.numeroGuiaPrestador, procedimentoshonorarios.codigo, ";
            sql += "procedimentoshonorarios.descricao, procedimentoshonorarios.quantidadeRealizada, ";
            sql += "procedimentoshonorarios.valorTotal, procedimentoshonorarios.data ";
            sql += "FROM guiashonorarioindividual INNER JOIN procedimentoshonorarios ON ";
            sql += "guiashonorarioindividual.codGuia = procedimentoshonorarios.codguia ";
            sql += " WHERE codLote=" + n_lote + " ORDER BY numeroGuiaPrestador";
            
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            resp  = "<table width='90%' cellspacing=0 cellppading=0>\n";
            resp += "<tr>\n";
            resp += " <td class='tblrel' style='background-color:#CCCCCC'>Nº GUIA</td>\n";
            resp += " <td class='tblrel' style='background-color:#CCCCCC'>BENEFICIÁRIO</td>\n";
            resp += " <td class='tblrel' style='background-color:#CCCCCC'>DATA</td>\n";
            resp += " <td class='tblrel' style='background-color:#CCCCCC'>PROCEDIMENTO</td>\n";
            resp += " <td class='tblrel' style='background-color:#CCCCCC'>VALOR</td>\n";
            resp += "</tr>\n";
            
            //Adiciona cabeçalho ao retorno
            retorno.add(resp);
            
            //Cria looping com a resposta
            while(rs.next()) {
                
                //Acumula valores
                soma += rs.getFloat("valorTotal");
                
                //Alterna as cores do fundo
                if(troca) {
                    resp = "<tr style='background-color:#FFFFFF'>\n";
                    troca = false;
                } else {
                    resp = "<tr style='background-color:#EEEEEE'>\n";
                    troca = true;
                }
                
                resp += "	<td class='tblrel'>" + rs.getString("numeroGuiaPrestador") + "</td>\n";
                resp += "	<td class='tblrel'>" + rs.getString("nomeBeneficiario") + "</td>\n";
                resp += "	<td class='tblrel'>" + Util.formataData(rs.getString("data")) + "</td>\n";
                resp += "	<td class='tblrel'>( " + rs.getString("codigo") + ") " + Util.trataNulo(rs.getString("descricao"),"N/C") + "</td>\n";
                resp += "	<td class='tblrel'>" + Util.formatCurrency(rs.getString("valorTotal")) + "</td>\n";
                resp += "</tr>\n";
                
                //Adiciona cada linha ao retorno
                retorno.add(resp);
                
            }
            
            resp  = "<tr style='background-color:#CCCCCC'>\n";
            resp += "  <td class='tblrel' colspan='4' align='right'>TOTAL: </td>\n";
            resp += "  <td class='tblrel'>" + Util.formatCurrency(soma+"") + "</tr>\n";
            resp += "</tr>\n";
            retorno.add(resp);
            
            retorno.add("</table>");
       
            rs.close();
            stmt.close();

            return retorno;
        } catch(SQLException e) {
            retorno.add(e.toString() + "<br>" + sql);
            return retorno;
        }
    }

    //Retorna a soma de outras despesas de uma guia/lote
    public String somaOutrasDespesas(String codGuia, String cod_lote) {
        
        String sql =  "";
        String resp = "";
        try {
            sql  = "SELECT SUM(valorTotal) AS soma ";
            sql += "FROM guiasoutrasdespesas INNER JOIN guiassadt ";
            sql += "ON guiasoutrasdespesas.codGuia = guiassadt.codGuia ";
            sql += "WHERE guiasoutrasdespesas.codGuia=" + codGuia;
            sql += " AND guiassadt.codLote=" + cod_lote;
            
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            ResultSet rs = null;
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            //Pega a resposta
            if(rs.next())
                resp = rs.getString("soma");             
            
            rs.close();
            stmt.close();
            
            return resp;
        } catch(SQLException e) {
            return "ERRO no somaOutrasDespesas: " + e.toString() + " SQL: " + sql;
        }
    }

    //Relatório de Lancamentos
    public Vector getAtendimentos(String de, String ate, String agrupar, String filtros[]) {
        //Retorno dos dados
        Vector retorno = new Vector();
        
        //Vetor de Strings com equivalências de Pesquisa
        String campos[] = {"Executante.prof_reg","Solicitante.prof_reg", "paciente.codcli", "especialidade.codesp", "convenio.cod_convenio", "Solicitante.locacao", "procedimentos.COD_PROCED" };
        
        //Coloca as datas no formato correto pro SQL (aaaa/mm/dd)
        de = Util.formataDataInvertida(de);
        ate = Util.formataDataInvertida(ate);
        
        //Monta sql para consulta
        String sql =  "SELECT faturas.Data_Lanca, faturas.hora_lanca, faturas.Numero, ";
        sql += "paciente.nome, Executante.nome, Solicitante.nome, ";
        sql += "faturas_itens.qtde, procedimentos.Procedimento, ";
        sql += "convenio.descr_convenio, faturas_itens.cod_subitem, ";
        sql += "faturas_itens.tipo_pagto, faturas_itens.valor, especialidade.descri ";
        sql += "FROM ((((faturas LEFT JOIN paciente ON faturas.codcli = ";
        sql += "paciente.codcli) INNER JOIN ((procedimentos RIGHT JOIN ";
        sql += "faturas_itens ON procedimentos.COD_PROCED = ";
        sql += "faturas_itens.Cod_Proced) INNER JOIN especialidade ON ";
        sql += "procedimentos.codesp = especialidade.codesp) ON ";
        sql += "faturas.Numero = faturas_itens.Numero) LEFT JOIN ";
        sql += "profissional AS Solicitante ON faturas.Cod_Solicitante = ";
        sql += "Solicitante.prof_reg) LEFT JOIN profissional AS Executante ";
        sql += "ON faturas.prof_reg = Executante.prof_reg) LEFT JOIN ";
        sql += "convenio ON faturas_itens.cod_convenio = convenio.cod_convenio ";
        sql += "WHERE faturas.Data_Lanca BETWEEN '" + de + "' AND '" + ate + "' ";
        
        for(int j=0; j<campos.length; j++) {
            if(!filtros[j].equals("todos")) {
                sql += "AND " + campos[j] + "='" + filtros[j] + "' ";
            }
        }
        
        if(agrupar.equals("faturas.Data_Lanca"))
            sql += "ORDER BY " + agrupar + ", paciente.nome";
        else
            sql += "ORDER BY " + agrupar + ",faturas.Data_Lanca, paciente.nome";
        
        String resp = "";
        String hora;
        float valor=0, soma=0, somageral=0;
        int somaQtde=0, somageralQtde = 0;
        String anterior="", atual="";
        String solicitante="";
        String cor="#EEEEEE";
        boolean troca = false;
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            ResultSet rs = null;
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            resp  = "<tr>\n";
            resp += " <td class='tblrel' style='background-color:#CCCCCC'><b>nº da Guia</b></td>\n";
            resp += " <td class='tblrel' style='background-color:#CCCCCC'><b>Data</b></td>\n";
            resp += " <td class='tblrel' style='background-color:#CCCCCC'><b>Hora</b></td>\n";
            resp += " <td class='tblrel' style='background-color:#CCCCCC'><b>Paciente</b></td>\n";
            resp += " <td class='tblrel' style='background-color:#CCCCCC'><b>Executante</b></td>\n";
            resp += " <td class='tblrel' style='background-color:#CCCCCC'><b>Solicitante</b></td>\n";
            resp += " <td class='tblrel' style='background-color:#CCCCCC'><b>Qtde</b></td>\n";
            resp += " <td class='tblrel' style='background-color:#CCCCCC'><b>Procedimento</b></td>\n";
            resp += " <td class='tblrel' style='background-color:#CCCCCC'><b>Especialidade</b></td>\n";
            resp += " <td class='tblrel' style='background-color:#CCCCCC'><b>Convênio</b></td>\n";
            resp += "</tr>\n";
            
            //Adiciona cabeçalho ao retorno
            retorno.add(resp);
            
            //Cria looping com a resposta
            while(rs.next()) {
                //Se a hora estiver null, imprimir espaço em branco
                hora = rs.getString("hora_lanca") != null? rs.getString("hora_lanca") : "&nbsp;";
                
                //Pega o valor atual do campo que está sendo ordenado
                //Se for a data, pegar formatada, senão, o camp mesmo
                atual = agrupar.equals("faturas.Data_Lanca,faturas.hora_lanca") ? Util.formataData(rs.getString("Data_Lanca")) : rs.getString(agrupar);
                
                //Pega valor do solicitante e verifica se está nulo
                solicitante = rs.getString("Solicitante.nome") != null ? rs.getString("Solicitante.nome") : "N/C";
                
                //Se o item anterior for diferente do atual, inserir linha de subtotal
                if(!anterior.equals(atual) && !anterior.equals("")) {
                    resp = "";
                    resp += "<tr>\n";
                    resp += " <td colspan=5 class='tblrel' align='right' style='background-color:#CCCCCC'><b>Sub-Total: </b></td>\n";
                    resp += " <td colspan=5 class='tblrel' align='center' style='background-color:#CCCCCC'><b>" + somaQtde + "</b></td>\n";
                    resp += "</tr>\n";
                    
                    //Adiciona linha na saída
                    retorno.add(resp);
                    
                    //Zera acumulador
                    soma = 0;
                    somaQtde = 0;
                }
                
                
                //Acumula valores
                somaQtde += rs.getInt("qtde");
                somageralQtde += rs.getInt("qtde");
                
                resp = "";
                //Alterna as cores do fundo
                if(troca) {
                    cor = "#FFFFFF";
                    troca = false;
                } else {
                    cor = "#EEEEEE";
                    troca = true;
                }
                
                resp += "	<td class='tblrel' style='background-color:" + cor + "'>" + getNumeroGuia(rs.getString("faturas.Numero")) + "</td>\n";
                resp += "	<td class='tblrel' style='background-color:" + cor + "'>" + Util.formataData(rs.getString("Data_Lanca")) + "</td>\n";
                resp += "	<td class='tblrel' style='background-color:" + cor + "'>" + hora + "</td>\n";
                resp += "	<td class='tblrel' style='background-color:" + cor + "'>" + rs.getString("paciente.nome") + "</td>\n";
                resp += "	<td class='tblrel' style='background-color:" + cor + "'>" + rs.getString("Executante.nome") + "</td>\n";
                resp += "	<td class='tblrel' style='background-color:" + cor + "'>" + solicitante + "</td>\n";
                resp += "	<td class='tblrel' align='center' style='background-color:" + cor + "'>" + rs.getString("qtde") + "</td>\n";
                resp += "	<td class='tblrel' style='background-color:" + cor + "'>" + rs.getString("Procedimento") + "</td>\n";
                resp += "	<td class='tblrel' style='background-color:" + cor + "'>" + rs.getString("especialidade.descri") + "</td>\n";
                resp += "	<td class='tblrel' style='background-color:" + cor + "'>" + rs.getString("descr_convenio") + "</td>\n";
                resp += "</tr>\n";
                
                //Captura o campo que está sendo agrupado/ordenado para ver se mudou de valor na próxima
                anterior = agrupar.equals("faturas.Data_Lanca,faturas.hora_lanca") ? Util.formataData(rs.getString("Data_Lanca")) : rs.getString(agrupar);
                
                //Se for nulo, colocar String vazia para não dar erro no .equals
                if(anterior==null) anterior = "";
                
                //Adiciona cada linha ao retorno
                retorno.add(resp);
            }
            
            //Quando acabar o loopin, dar o subtotal do último e total geral
            resp = "";
            resp += "<tr>\n";
            resp += "<td colspan=5 class='tblrel' align='right' style='background-color:#CCCCCC'><b>Sub-Total: </b></td>\n";
            resp += "<td colspan=5 class='tblrel' align='center' style='background-color:#CCCCCC'><b>" + somaQtde + "</b></td>\n";
            resp += "</tr>\n";
            
            resp += "<tr>\n";
            resp += "<td colspan=10>&nbsp;</td>\n";
            resp += "</tr>\n";
            
            resp += "<tr>\n";
            resp += "<td colspan=5 class='tblrel' align='right' style='background-color:#CCCCCC'><b>Total: </b></td>\n";
            resp += "<td colspan=5 class='tblrel' align='center' style='background-color:#CCCCCC'><b>" + somageralQtde + "</b></td>\n";
            resp += "</tr>\n";
            
            //Adiciona linha na saída
            retorno.add(resp);
            
            rs.close();
            stmt.close();
            
            return retorno;
        } catch(SQLException e) {
            retorno.add(e.toString() + "<br>" + sql);
            return retorno;
        }
    }

    //Relatório de Inconsistência de agenda x faturamento
    public Vector getRelAgendaFaturas(String de, String ate, String cod_empresa) {
        //Retorno dos dados
        Vector retorno = new Vector();
        
        //Coloca as datas no formato correto pro SQL (aaaa/mm/dd)
        de = Util.formataDataInvertida(de);
        ate = Util.formataDataInvertida(ate);
        
        //Monta sql para consulta
        String sql =  "SELECT paciente.nome, agendamento.data, agendamento.hora, ";
        sql += "grupoprocedimento.grupoproced, t_usuario.ds_nome, faturas.Numero, ";
        sql += "profissional.nome, convenio.descr_convenio ";
        sql += "FROM (((((paciente INNER JOIN agendamento ON paciente.codcli = agendamento.codcli) ";
        sql += "LEFT JOIN faturas ON (agendamento.codcli = faturas.codcli) AND ";
        sql += "(agendamento.data = faturas.Data_Lanca)) LEFT JOIN grupoprocedimento ";
        sql += "ON agendamento.cod_proced = grupoprocedimento.cod_grupoproced) ";
        sql += "LEFT JOIN t_usuario ON agendamento.usuario_inclusao = t_usuario.cd_usuario) ";
        sql += "LEFT JOIN profissional ON agendamento.prof_reg = profissional.prof_reg) ";
        sql += "LEFT JOIN convenio ON agendamento.cod_convenio = convenio.cod_convenio ";
        sql += "WHERE agendamento.data BETWEEN '" + de + "' AND '" + ate + "' ";
        sql += "AND paciente.cod_empresa=" + cod_empresa;
        sql += " ORDER BY agendamento.data ASC, agendamento.hora ASC";
        
        String resp = "";
        boolean troca = false;
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            ResultSet rs = null;
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            resp  = "<table border='0' cellspacing='0' cellpadding='0'>\n";
            resp += " <tr>\n";
            resp += "  <td class='tblrel' style='background-color:#CCCCCC'><b>Data</b></td>\n";
            resp += "  <td class='tblrel' style='background-color:#CCCCCC'><b>Hora</b></td>\n";
            resp += "  <td class='tblrel' style='background-color:#CCCCCC'><b>Paciente</b></td>\n"; 
            resp += "  <td class='tblrel' style='background-color:#CCCCCC'><b>Convênio</b></td>\n";
            resp += "  <td class='tblrel' style='background-color:#CCCCCC'><b>Procedimento</b></td>\n";
            resp += "  <td class='tblrel' style='background-color:#CCCCCC'><b>Médico</b></td>\n";
            resp += "  <td class='tblrel' style='background-color:#CCCCCC'><b>Agendado por </b></td>\n";
            resp += "  <td class='tblrel' style='background-color:#CCCCCC'><b>Faturado? </b></td>\n";
            resp += "  <td class='tblrel' style='background-color:#CCCCCC'><b>Guia TISS </b></td>\n";
            resp += " </tr>\n";
            
            //Adiciona cabeçalho ao retorno
            retorno.add(resp);
            
            //Cria looping com a resposta
            while(rs.next()) {
                resp = "";
                //Alterna as cores do fundo
                if(troca) {
                    resp += "<tr style='background-color:#FFFFFF'>\n";
                    troca = false;
                } else {
                    resp += "<tr style='background-color:#EEEEEE'>\n";
                    troca = true;
                }
                
                resp += "	<td class='tblrel' style='padding-left:5px'>" + Util.formataData(rs.getString("Data")) + "</td>\n";
                resp += "	<td class='tblrel' style='padding-left:5px'>" + Util.formataHora(rs.getString("hora")) + "</td>\n";
                resp += "	<td class='tblrel' style='padding-left:5px'>" + rs.getString("paciente.nome") + "</td>\n";
                resp += "	<td class='tblrel' style='padding-left:5px'>" + Util.trataNulo(rs.getString("descr_convenio"),"N/C") + "</td>\n";
                resp += "	<td class='tblrel' style='padding-left:5px'>" + Util.trataNulo(rs.getString("grupoproced"),"N/C") + "</td>\n";
                resp += "	<td class='tblrel' style='padding-left:5px'>" + Util.trataNulo(rs.getString("profissional.nome"),"N/C") + "</td>\n";
                resp += "	<td class='tblrel' style='padding-left:5px'>" + Util.trataNulo(rs.getString("ds_nome"),"N/C") + "</td>\n";
                resp += "	<td class='tblrel' style='padding-left:5px'>" + (rs.getString("Numero")==null ? "N" : "S") + "</td>\n";
                resp += "	<td class='tblrel' style='padding-left:5px'>" + getNumeroGuia(rs.getString("faturas.Numero")) + "</td>\n";                
                resp += "</tr>\n";
               
                //Adiciona cada linha ao retorno
                retorno.add(resp);
            }
            
            resp = "</table>\n";
            
            //Finaliza a tabela
            retorno.add(resp);
            
            rs.close();
            stmt.close();
            
            return retorno;
        } catch(SQLException e) {
            retorno.add(e.toString() + "<br>" + sql);
            return retorno;
        }
    }

    //Recupera o número da Guia do procedimento
    public String getNumeroGuia(String cod_fatura) {
        String resp = "N/C";
        String sql = "";
        ResultSet rs = null;
        
        try {
            //Cria statement para enviar sql
            Statement stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            //Busca o valor
            sql = "SELECT numeroGuiaPrestador FROM guiasconsulta WHERE numeroFatura=" + cod_fatura;
            rs = stmt.executeQuery(sql);
            
            //Se achou na guia de consulta, pegar o número, senão, procurar na guia SADT
            if(rs.next())
                resp = rs.getString("numeroGuiaPrestador");
            else {
                sql = "SELECT numeroGuiaPrestador FROM guiassadt WHERE numeroFatura=" + cod_fatura;
                rs = stmt.executeQuery(sql);
                if(rs.next())
                    resp = rs.getString("numeroGuiaPrestador");
            }
            
            rs.close();
            stmt.close();
            
            return resp;
            
        } catch(SQLException e) {
            return "ERRO: " + e.toString() + " SQL: " + sql;
        }
    }

    //Relatório de Lancamentos
    public Vector getAtendimentosIndividual(String de, String ate, String prof_reg) {
        //Retorno dos dados
        Vector retorno = new Vector();
        
        //Coloca as datas no formato correto pro SQL (aaaa/mm/dd)
        de = Util.formataDataInvertida(de);
        ate = Util.formataDataInvertida(ate);
        
        //Monta sql para consulta
        String sql =  "SELECT faturas.Data_Lanca, faturas.hora_lanca, faturas.Numero, ";
        sql += "paciente.nome, Executante.nome, Solicitante.nome, ";
        sql += "faturas_itens.qtde, procedimentos.Procedimento, ";
        sql += "convenio.descr_convenio, faturas_itens.cod_subitem, ";
        sql += "faturas_itens.tipo_pagto, faturas_itens.valor, especialidade.descri ";
        sql += "FROM ((((faturas LEFT JOIN paciente ON faturas.codcli = ";
        sql += "paciente.codcli) INNER JOIN ((procedimentos RIGHT JOIN ";
        sql += "faturas_itens ON procedimentos.COD_PROCED = ";
        sql += "faturas_itens.Cod_Proced) INNER JOIN especialidade ON ";
        sql += "procedimentos.codesp = especialidade.codesp) ON ";
        sql += "faturas.Numero = faturas_itens.Numero) LEFT JOIN ";
        sql += "profissional AS Solicitante ON faturas.Cod_Solicitante = ";
        sql += "Solicitante.prof_reg) LEFT JOIN profissional AS Executante ";
        sql += "ON faturas.prof_reg = Executante.prof_reg) LEFT JOIN ";
        sql += "convenio ON faturas_itens.cod_convenio = convenio.cod_convenio ";
        sql += "WHERE faturas.Data_Lanca BETWEEN '" + de + "' AND '" + ate + "' ";
        sql += "AND (faturas.prof_reg='" + prof_reg + "' OR faturas.Cod_Solicitante='" + prof_reg + "') ";
        sql += "ORDER BY faturas.Data_Lanca, paciente.nome";
        
        String resp = "";
        String hora;
        float valor=0, soma=0, somageral=0;
        int somaQtde=0, somageralQtde = 0;
        String anterior="", atual="";
        String solicitante="";
        String cor="#EEEEEE";
        boolean troca = false;
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            ResultSet rs = null;
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            resp  = "<tr style=\"background-color:'#CCCCCC'\">\n";
            resp += "<td class='tblrel'><b>nº da Guia</b></td>\n";                    
            resp += "<td class='tblrel'><b>Data</b></td>\n";
            resp += "<td class='tblrel'><b>Hora</b></td>\n";
            resp += "<td class='tblrel'><b>Paciente</b></td>\n";
            resp += "<td class='tblrel'><b>Executante</b></td>\n";
            resp += "<td class='tblrel'><b>Solicitante</b></td>\n";
            resp += "<td class='tblrel'><b>Qtde</b></td>\n";
            resp += "<td class='tblrel'><b>Procedimento</b></td>\n";
            resp += "<td class='tblrel'><b>Especialidade</b></td>\n";
            resp += "<td class='tblrel'><b>Convênio</b></td>\n";
            resp += "</tr>\n";
            
            //Adiciona cabeçalho ao retorno
            retorno.add(resp);
            
            //Cria looping com a resposta
            while(rs.next()) {
                //Se a hora estiver null, imprimir espaço em branco
                hora = rs.getString("hora_lanca") != null? rs.getString("hora_lanca") : "&nbsp;";
                
                //Pega o valor atual do campo que está sendo ordenado
                //Se for a data, pegar formatada, senão, o camp mesmo
                atual = Util.formataData(rs.getString("Data_Lanca"));
                
                //Pega valor do solicitante e verifica se está nulo
                solicitante = rs.getString("Solicitante.nome") != null ? rs.getString("Solicitante.nome") : "N/C";
                
                //Se o item anterior for diferente do atual, inserir linha de subtotal
                if(!anterior.equals(atual) && !anterior.equals("")) {
                    resp = "";
                    resp += "<tr style=\"background-color:'#CCCCCC'\">\n";
                    resp += "<td colspan=5 class='tblrel' align='right'><b>Sub-Total: </b></td>\n";
                    resp += "<td colspan=5 class='tblrel' align='center'><b>" + somaQtde + "</b></td>\n";
                    resp += "</tr>\n";
                    
                    //Adiciona linha na saída
                    retorno.add(resp);
                    
                    //Zera acumulador
                    soma = 0;
                    somaQtde = 0;
                }
                
                
                //Acumula valores
                somaQtde += rs.getInt("qtde");
                somageralQtde += rs.getInt("qtde");
                
                resp = "";
                //Alterna as cores do fundo
                if(troca) {
                    resp += "<tr style='background-color:#FFFFFF'>\n";
                    troca = false;
                } else {
                    resp += "<tr style='background-color:#EEEEEE'>\n";
                    troca = true;
                }
                
                resp += "	<td class='tblrel'>" + getNumeroGuia(rs.getString("faturas.Numero")) + "</td>\n";
                resp += "	<td class='tblrel'>" + Util.formataData(rs.getString("Data_Lanca")) + "</td>\n";
                resp += "	<td class='tblrel'>" + hora + "</td>\n";
                resp += "	<td class='tblrel'>" + rs.getString("paciente.nome") + "</td>\n";
                resp += "	<td class='tblrel'>" + rs.getString("Executante.nome") + "</td>\n";
                resp += "	<td class='tblrel'>" + solicitante + "</td>\n";
                resp += "	<td class='tblrel' align='center'>" + rs.getString("qtde") + "</td>\n";
                resp += "	<td class='tblrel'>" + rs.getString("Procedimento") + "</td>\n";
                resp += "	<td class='tblrel'>" + rs.getString("especialidade.descri") + "</td>\n";
                resp += "	<td class='tblrel'>" + rs.getString("descr_convenio") + "</td>\n";
                resp += "</tr>\n";
                
                //Captura o campo que está sendo agrupado/ordenado para ver se mudou de valor na próxima
                anterior = Util.formataData(rs.getString("Data_Lanca"));
                
                //Se for nulo, colocar String vazia para não dar erro no .equals
                if(anterior==null) anterior = "";
                
                //Adiciona cada linha ao retorno
                retorno.add(resp);
            }
            
            //Quando acabar o loopin, dar o subtotal do último e total geral
            resp = "";
            resp += "<tr style=\"background-color:'#CCCCCC'\">\n";
            resp += "<td colspan=6 class='tblrel' align='right'><b>Sub-Total: </b></td>\n";
            resp += "<td colspan=6 class='tblrel' align='center'><b>" + somaQtde + "</b></td>\n";
            resp += "</tr>\n";
            
            resp += "<tr>\n";
            resp += "<td colspan=10>&nbsp;</td>\n";
            resp += "</tr>\n";
            
            resp += "<tr style=\"background-color:'#CCCCCC'\">\n";
            resp += "<td colspan=5 class='tblrel' align='right'><b>Total: </b></td>\n";
            resp += "<td colspan=5 class='tblrel' align='center'><b>" + somageralQtde + "</b></td>\n";
            resp += "</tr>\n";
            
            //Adiciona linha na saída
            retorno.add(resp);
            
            rs.close();
            stmt.close();
            
            return retorno;
        } catch(SQLException e) {
            retorno.add(e.toString() + "<br>" + sql);
            return retorno;
        }
    }
    
    //Busca os lançamentos para relatório sintético
    public Vector getLancamentosSintetico(String de, String ate, String especialidade, String cod_empresa) {
        String resp = "";
        String cabecalho = "";
        String subtotal = "";
        float soma = 0, total = 0;
        float sub1 = 0, sub2 = 0;
        float sub3 = 0, sub4 = 0;
        
        //Retorno dos dados
        Vector retorno = new Vector();
        
        //Coloca as datas no formato correto pro SQL (aaaa/mm/dd)
        de = Util.formataDataInvertida(de);
        ate = Util.formataDataInvertida(ate);
        
        //Busca as especialidades escolhidas
        String sql =  "SELECT descri, codesp FROM especialidade ";
        sql += " WHERE Not IsNull(descri) AND cod_empresa=" + cod_empresa;
        
        //Se veio filtro de especialidade,  escolher
        if(!especialidade.equals("todos"))
            sql += " AND codesp=" + especialidade;
        
        //Coloca em ordem de nome
        sql += " ORDER BY descri";
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            ResultSet rs = null;
            ResultSet rs2 = null;
            
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            //Início da tabela
            retorno.add("<table cellspacing=0 cellpadding=0 width='100%'>\n");
            
            while(rs.next()) {
                sub1 = 0;
                sub2 = 0;
                resp = "";
                cabecalho = "<tr><td class='tblrel' style='background-color:#EEEEEE'><b>" + rs.getString("descri") + "</b></td>\n<td class='tblrel' style='background-color:#EEEEEE'>Qtde</td><td class='tblrel' style='background-color:#EEEEEE'>Total</td>\n</tr>\n";
                
                //Busca os grupos de procedimentos da(s) especialidade(s)
                sql  = "SELECT DISTINCT(grupoprocedimento.cod_grupoproced), grupoprocedimento.grupoproced ";
                sql += "FROM (especialidade INNER JOIN procedimentos ";
                sql += "ON especialidade.codesp = procedimentos.codesp) ";
                sql += "INNER JOIN grupoprocedimento ON procedimentos.";
                sql += "grupoproced = grupoprocedimento.cod_grupoproced ";
                sql += "WHERE especialidade.codesp=" + rs.getString("codesp");
                sql += " AND grupoprocedimento.ativo='S' ";
                sql += " ORDER BY grupoproced";
                
                //Cria statement para enviar sql
                Statement stmt2 = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                        ResultSet.CONCUR_READ_ONLY);
                
                //Executa a pesquisa
                rs2 = stmt2.executeQuery(sql);
                
                while(rs2.next()) {
                    float aux[] = getTotalGrupoProced(rs2.getString("cod_grupoproced"), rs.getString("codesp"), de, ate);
                    soma  = aux[0];
                    total = aux[1];
                    
                    sub1 += soma;
                    sub2 += total;
                    
                    sub3 += soma;
                    sub4 += total;
                    
                    //Se a soma deu maior que zero, imprimir
                    if(soma > 0) {
                        resp += "<tr>\n";
                        resp += "<td class='tblrel'><li>" + rs2.getString("grupoproced") + "</li></td>\n";
                        resp += "<td class='tblrel'>" + total + "</td>\n";
                        resp += "<td class='tblrel' align='right'>" + Util.formatCurrency(soma+"") + "</td>\n";
                        resp += "</tr>\n";
                    }
                    
                }
                
                rs2.close();
                stmt2.close();
                
                subtotal  = "<tr>\n";
                subtotal += "<td class='tblrel' style='text-align:right'><b>Sub-total: </b></td>\n";
                subtotal += "<td class='tblrel'><b>" + sub2 + "</b></td>\n";
                subtotal += "<td class='tblrel' align='right'><b>" + Util.formatCurrency(sub1+"") + "</b></td>\n";
                subtotal += "</tr>\n";
                
                //Se inseriu algum item, inserir o conteúdo
                if(!resp.equals("")) {
                    retorno.add(cabecalho);
                    retorno.add(resp);
                    retorno.add(subtotal);
                }
            }
            
            
            subtotal  = "<tr>\n";
            subtotal += "<td class='tblrel' style='text-align:right; background-color:#CCCCCC'><b>Total: </b></td>\n";
            subtotal += "<td class='tblrel' style='background-color:#CCCCCC'><b>" + sub4 + "</b></td>\n";
            subtotal += "<td class='tblrel' style='background-color:#CCCCCC' align='right'><b>" + Util.formatCurrency(sub3+"") + "</b></td>\n";
            subtotal += "</tr>\n";
            
            rs.close();
            stmt.close();
            
            retorno.add(subtotal);
            retorno.add("</table>");
            
            return retorno;
            
        } catch(SQLException e) {
            retorno.add("Erro:" + e.toString() + sql);
            return retorno;
        }
    }
    
    //Relatório de Pagamentos
    public Vector getPagamentos(String de, String ate, String tipopagto, String cheque, String cod_empresa) {
        //Retorno dos dados
        Vector retorno = new Vector();
        
        //Variáveis auxiliares
        String sql="";
        String resp = "";
        float soma = 0, somatotal = 0;
        
        //Coloca as datas no formato correto pro SQL (aaaa/mm/dd)
        de = Util.formataDataInvertida(de);
        ate = Util.formataDataInvertida(ate);
        
        //Se for todos os pagamentos ou for somente dinheiro
        if(tipopagto.equals("todos") || tipopagto.equals("1")) {
            
            //Monta sql para consulta
            sql =  "SELECT faturas.Data_Lanca, paciente.nome, ";
            sql += "procedimentos.Procedimento, Executante.nome, ";
            sql += "faturas_itens.valor ";
            sql += "FROM ((faturas LEFT JOIN paciente ON faturas.codcli ";
            sql += "= paciente.codcli) INNER JOIN (faturas_itens INNER ";
            sql += "JOIN procedimentos ON faturas_itens.Cod_Proced = ";
            sql += "procedimentos.COD_PROCED) ON faturas.Numero = ";
            sql += "faturas_itens.Numero) LEFT JOIN profissional AS ";
            sql += "Executante ON faturas.prof_reg = Executante.prof_reg ";
            sql += "WHERE (faturas.Data_Lanca BETWEEN '" + de + "' AND '" + ate + "') ";
            sql += "AND faturas_itens.tipo_pagto=1 ";
            sql += "AND paciente.cod_empresa=" + cod_empresa + " ";
            sql += "ORDER BY faturas.Data_Lanca";
            
            try {
                //Cria statement para enviar sql
                stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                        ResultSet.CONCUR_READ_ONLY);
                
                //Zera acumulador
                soma = 0;
                
                ResultSet rs = null;
                //Executa a pesquisa
                rs = stmt.executeQuery(sql);
                
                resp = "<br><table width='98%' border='0' cellpadding='0' cellspacing='0' style='background-color:white;border: 0px; border-top: 1px solid #CCCCCC;	border-left: 1px solid #CCCCCC;'>";
                resp += "<tr>\n";
                resp += "  <td colspan=5 class='tblrel' align='center' style='background-color:black; color: white'><b>L&nbsp;I&nbsp;S&nbsp;T&nbsp;A&nbsp;&nbsp;D&nbsp;E&nbsp;&nbsp;D&nbsp;I&nbsp;N&nbsp;H&nbsp;E&nbsp;I&nbsp;R&nbsp;O</b></td>\n";
                resp += "</tr>\n";
                resp += "<tr>\n";
                resp += "  <td class='tblrel' style='background-color:#CCCCCC'><b>Data</b></td>\n";
                resp += "  <td class='tblrel' style='background-color:#CCCCCC'><b>Paciente</b></td>\n";
                resp += "  <td class='tblrel' style='background-color:#CCCCCC'><b>Procedimento</b></td>\n";
                resp += "  <td class='tblrel' style='background-color:#CCCCCC'><b>Executante</b></td>\n";
                resp += "  <td class='tblrel' style='background-color:#CCCCCC'><b>Valor</b></td>\n";
                resp += "</tr>\n";
                
                //Adiciona cabeçalho ao retorno
                retorno.add(resp);
                
                //Cria looping com a resposta
                while(rs.next()) {
                    resp = "";
                    resp += "<tr>\n";
                    resp += "	<td class='tblrel'>" + Util.formataData(rs.getString("faturas.Data_Lanca")) + "</td>\n";
                    resp += "	<td class='tblrel'>" + rs.getString("paciente.nome") + "</td>\n";
                    resp += "	<td class='tblrel'>" + rs.getString("procedimentos.Procedimento") + "</td>\n";
                    resp += "	<td class='tblrel'>" + rs.getString("Executante.nome") + "</td>\n";
                    resp += "	<td class='tblrel' align='right'>" + Util.formatCurrency(rs.getString("faturas_itens.valor")) + "</td>\n";
                    resp += "</tr>\n";
                    
                    //Acumula valores
                    soma += rs.getFloat("faturas_itens.valor");
                    
                    //Adiciona cada linha ao retorno
                    retorno.add(resp);
                }
                
                //Quando acabar o looping, dar o subtotal do último e total geral
                resp = "";
                resp += "<tr>\n";
                resp += "<td colspan=4 class='tblrel' style='background-color:#CCCCCC' align='right'><b>Total: </b></td>\n";
                resp += "<td class='tblrel' align='right' style='background-color:#CCCCCC'><b>" + Util.formatCurrency(soma+"") + "</b></td>\n";
                resp += "</tr>\n";
                resp += "</table>\n";
                
                //Fecha Record Set
                rs.close();
                stmt.close();
                
                //Acumula na soma geral
                somatotal += soma;
                
                //Adiciona linha na saída
                retorno.add(resp);
                
            } catch(SQLException e) {
                retorno.add(e.toString() + "<br>" + sql);
            }
        }
        
        //Se for todos os pagamentos ou for somente cheques
        if(tipopagto.equals("todos") || tipopagto.equals("2")) {
            
            //Monta sql para consulta
            sql =  "SELECT faturas.Data_Lanca, paciente.nome, procedimentos.Procedimento,";
            sql += "faturas_chq.*,Executante.nome ";
            sql += "FROM ((((faturas_itens INNER JOIN procedimentos ON faturas_itens.Cod_Proced = ";
            sql += "procedimentos.COD_PROCED) INNER JOIN (faturas INNER JOIN paciente ON ";
            sql += "faturas.codcli = paciente.codcli) ON faturas_itens.Numero = faturas.Numero) ";
            sql += "LEFT JOIN profissional AS Executante ON faturas.prof_reg = Executante.prof_reg) ";
            sql += "LEFT JOIN faturas_chq ON faturas_itens.cod_subitem = faturas_chq.cod_subitem) ";
            sql += "LEFT JOIN profissional AS Solicitante ON faturas.Cod_Solicitante = Solicitante.prof_reg ";
            sql += "WHERE ((faturas_chq.Data_Cheque BETWEEN '" + de + "' AND '" + ate + "') OR ";
            sql += "(faturas.Data_Lanca BETWEEN '" + de + "' AND '" + ate + "' AND faturas_chq.Data_cheque is NULL) ) ";
            sql += "AND faturas_itens.tipo_pagto=2 ";
            
            //Se veio número do cheque
            if(!Util.isNull(cheque))
                sql += "AND faturas_chq.cheque='" + cheque + "' ";
            
            sql += "AND paciente.cod_empresa=" + cod_empresa + " ";
            sql += "ORDER BY faturas_chq.Data_Cheque";
            
            try {
                //Cria statement para enviar sql
                stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                        ResultSet.CONCUR_READ_ONLY);
                
                //Zera acumulador
                soma = 0;
                
                ResultSet rs = null;
                //Executa a pesquisa
                rs = stmt.executeQuery(sql);
                
                resp = "<br><table width='98%' border='0' cellpadding='0' cellspacing='0' style='background-color:white;border: 0px; border-top: 1px solid #CCCCCC;	border-left: 1px solid #CCCCCC;'>";
                resp += "<tr>\n";
                resp += "  <td colspan=9 class='tblrel' align='center' style='background-color:black; color: white'><b>L&nbsp;I&nbsp;S&nbsp;T&nbsp;A&nbsp;&nbsp;D&nbsp;E&nbsp;&nbsp;C&nbsp;H&nbsp;E&nbsp;Q&nbsp;U&nbsp;E&nbsp;S</b></td>\n";
                resp += "</tr>\n";
                resp += "<tr>\n";
                resp += "  <td class='tblrel' style='background-color:#CCCCCC'><b>Dt. Ch.</b></td>\n";
                resp += "  <td class='tblrel' style='background-color:#CCCCCC'><b>Ordem</b></td>\n";
                resp += "  <td class='tblrel' style='background-color:#CCCCCC'><b>Banco</b></td>\n";
                resp += "  <td class='tblrel' style='background-color:#CCCCCC'><b>nº Ch.</b></td>\n";
                resp += "  <td class='tblrel' style='background-color:#CCCCCC'><b>Emissão</b></td>\n";
                resp += "  <td class='tblrel' style='background-color:#CCCCCC'><b>Paciente</b></td>\n";
                resp += "  <td class='tblrel' style='background-color:#CCCCCC'><b>Procedimento</b></td>\n";
                resp += "  <td class='tblrel' style='background-color:#CCCCCC'><b>Executante</b></td>\n";
                resp += "  <td class='tblrel' style='background-color:#CCCCCC'><b>Valor</b></td>\n";
                resp += "</tr>\n";
                
                //Adiciona cabeçalho ao retorno
                retorno.add(resp);
                
                //Cria looping com a resposta
                while(rs.next()) {
                    resp = "";
                    resp += "<tr>\n";
                    resp += "	<td class='tblrel'>" + Util.trataNulo(Util.formataData(rs.getString("faturas_chq.Data_Cheque")),"N/C") + "</td>\n";
                    resp += "	<td class='tblrel'>" + Util.trataNulo(rs.getString("faturas_chq.ordem"),"N/C") + "</td>\n";
                    resp += "	<td class='tblrel'>" + Util.trataNulo(rs.getString("faturas_chq.Banco"),"N/C") + "</td>\n";
                    resp += "	<td class='tblrel'>" + Util.trataNulo(rs.getString("faturas_chq.Cheque"), "N/C") + "</td>\n";
                    resp += "	<td class='tblrel'>" + Util.formataData(rs.getString("faturas.Data_Lanca")) + "</td>\n";
                    resp += "	<td class='tblrel'>" + rs.getString("paciente.nome") + "</td>\n";
                    resp += "	<td class='tblrel'>" + rs.getString("procedimentos.Procedimento") + "</td>\n";
                    resp += "	<td class='tblrel'>" + rs.getString("Executante.nome") + "</td>\n";
                    resp += "	<td class='tblrel' align='right'>" + Util.trataNulo(Util.formatCurrency(rs.getString("faturas_chq.Valor")),"N/C") + "</td>\n";
                    resp += "</tr>\n";
                    
                    //Acumula valores
                    soma += rs.getFloat("faturas_chq.Valor");
                    
                    //Adiciona cada linha ao retorno
                    retorno.add(resp);
                }
                
                //Quando acabar o looping, dar o subtotal do último e total geral
                resp = "";
                resp += "<tr>\n";
                resp += "<td colspan=8 class='tblrel' align='right' style='background-color:#CCCCCC'><b>Total: </b></td>\n";
                resp += "<td class='tblrel' align='right' style='background-color:#CCCCCC'><b>" + Util.formatCurrency(soma+"") + "</b></td>\n";
                resp += "</tr>\n";
                resp += "</table>\n";
                
                //Fecha Record Set
                rs.close();
                stmt.close();
                
                //Acumula na soma geral
                somatotal += soma;
                
                //Adiciona linha na saída
                retorno.add(resp);
                
            } catch(SQLException e) {
                retorno.add(e.toString() + "<br>" + sql);
            }
        }
        
        //Se for todos os pagamentos ou for somente cartões
        if(tipopagto.equals("todos") || tipopagto.equals("3")) {
            
            //Monta sql para consulta
            sql =  "SELECT faturas.Data_Lanca, paciente.nome, ";
            sql += "procedimentos.Procedimento, Executante.nome, ";
            sql += "faturas_itens.valor, faturas_cartoes.Bandeira, ";
            sql += "faturas_cartoes.numero_cartao, faturas_cartoes.valor, ";
            sql += "faturas_cartoes.parcelas ";
            sql += "FROM ((((faturas_cartoes RIGHT JOIN faturas_itens ON ";
            sql += "faturas_cartoes.cod_subitem = faturas_itens.cod_subitem) ";
            sql += "LEFT JOIN procedimentos ON faturas_itens.Cod_Proced = ";
            sql += "procedimentos.COD_PROCED) INNER JOIN faturas ON ";
            sql += "faturas_itens.Numero = faturas.Numero) LEFT JOIN ";
            sql += "profissional AS Executante ON faturas.prof_reg = ";
            sql += "Executante.prof_reg) INNER JOIN paciente ON ";
            sql += "faturas.codcli = paciente.codcli ";
            sql += "WHERE (faturas.Data_Lanca BETWEEN '" + de + "' AND '" + ate + "') ";
            sql += "AND faturas_itens.tipo_pagto=3 ";
            sql += "AND paciente.cod_empresa=" + cod_empresa + " ";
            sql += "ORDER BY faturas.Data_Lanca";
            
            try {
                //Cria statement para enviar sql
                stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                        ResultSet.CONCUR_READ_ONLY);
                
                //Zera acumulador
                soma = 0;
                
                ResultSet rs = null;
                //Executa a pesquisa
                rs = stmt.executeQuery(sql);
                
                resp = "<br><table width='98%' border='0' cellpadding='0' cellspacing='0' style='background-color:white;border: 0px; border-top: 1px solid #CCCCCC;	border-left: 1px solid #CCCCCC;'>";
                resp += "<tr>\n";
                resp += "<td colspan=8 class='tblrel' align='center' style='background-color:black; color: white'><b>L&nbsp;I&nbsp;S&nbsp;T&nbsp;A&nbsp;&nbsp;D&nbsp;E&nbsp;&nbsp;C&nbsp;A&nbsp;R&nbsp;T&nbsp;Õ&nbsp;E&nbsp;S</b></td>\n";
                resp += "</tr>\n";
                resp += "<tr>\n";
                resp += "<td class='tblrel' style='background-color:#CCCCCC'><b>Data</b></td>\n";
                resp += "<td class='tblrel' style='background-color:#CCCCCC'><b>Bandeira</b></td>\n";
                resp += "<td class='tblrel' style='background-color:#CCCCCC'><b>nº cartão</b></td>\n";
                resp += "<td class='tblrel' style='background-color:#CCCCCC'><b>Parcelas</b></td>\n";
                resp += "<td class='tblrel' style='background-color:#CCCCCC'><b>Paciente</b></td>\n";
                resp += "<td class='tblrel' style='background-color:#CCCCCC'><b>Procedimento</b></td>\n";
                resp += "<td class='tblrel' style='background-color:#CCCCCC'><b>Executante</b></td>\n";
                resp += "<td class='tblrel' style='background-color:#CCCCCC'><b>Valor</b></td>\n";
                resp += "</tr>\n";
                
                //Adiciona cabeçalho ao retorno
                retorno.add(resp);
                
                //Cria looping com a resposta
                while(rs.next()) {
                    resp = "";
                    resp += "<tr>\n";
                    resp += "	<td class='tblrel'>" + Util.formataData(rs.getString("faturas.Data_Lanca")) + "</td>\n";
                    resp += "	<td class='tblrel'>" + Util.trataNulo(rs.getString("Bandeira"),"N/C") + "</td>\n";
                    resp += "	<td class='tblrel'>" + Util.trataNulo(rs.getString("numero_cartao"),"N/C") + "</td>\n";
                    resp += "	<td class='tblrel'>" + Util.trataNulo(rs.getString("parcelas"),"N/C") + "</td>\n";
                    resp += "	<td class='tblrel'>" + rs.getString("paciente.nome") + "</td>\n";
                    resp += "	<td class='tblrel'>" + rs.getString("procedimentos.Procedimento") + "</td>\n";
                    resp += "	<td class='tblrel'>" + rs.getString("Executante.nome") + "</td>\n";
                    resp += "	<td class='tblrel' align='right'>" + Util.formatCurrency(rs.getString("faturas_cartoes.valor")) + "&nbsp;</td>\n";
                    resp += "</tr>\n";
                    
                    //Acumula valores
                    soma += rs.getFloat("faturas_cartoes.valor");
                    
                    //Adiciona cada linha ao retorno
                    retorno.add(resp);
                }
                
                //Quando acabar o looping, dar o subtotal do último e total geral
                resp = "";
                resp += "<tr>\n";
                resp += "<td colspan=7 class='tblrel' align='right' style='background-color:#CCCCCC'><b>Total: </b></td>\n";
                resp += "<td class='tblrel' align='right' style='background-color:#CCCCCC'><b>" + Util.formatCurrency(soma+"") + "</b></td>\n";
                resp += "</tr>\n";
                resp += "</table>\n";
                
                //Fecha Record Set
                rs.close();
                stmt.close();
                
                //Acumula na soma geral
                somatotal += soma;
                
                //Adiciona linha na saída
                retorno.add(resp);
                
            } catch(SQLException e) {
                retorno.add(e.toString() + "<br>" + sql);
            }
        }
        
        resp = "<br><table width='98%' border='0' cellpadding='0' cellspacing='0' style='background-color:white;border: 0px; border-top: 1px solid #CCCCCC;	border-left: 1px solid #CCCCCC;'>";
        resp += "<tr>\n";
        resp += "<td class='tblrel' align='right' style='background-color:black; color:white'><b>Total Geral: " + Util.formatCurrency(somatotal+"") + "</b></td>\n";
        resp += "</tr>\n";
        resp += "</table>\n";
        
        //Adiciona linha na saída
        retorno.add(resp);
        
        return retorno;
        
    }
    
    //Calcula a soma total para um grupo de procedimentos
    private float[] getTotalGrupoProced(String cod_grupoproced, String codesp, String de, String ate) {
        float resp[] = new float[2];
        String sql = "";
        ResultSet rs = null;
        
        sql =  "SELECT Sum(qtde*valor) AS somatorio, Sum(qtde) as contador ";
        sql += "FROM procedimentos INNER JOIN faturas_itens ON ";
        sql += "procedimentos.COD_PROCED = faturas_itens.Cod_Proced ";
        sql += "INNER JOIN faturas ON faturas_itens.Numero = ";
        sql += "faturas.Numero INNER JOIN grupoprocedimento ON ";
        sql += "procedimentos.grupoproced = grupoprocedimento.cod_grupoproced ";
        sql += "WHERE (faturas.Data_Lanca BETWEEN '" + de + "' AND '";
        sql += ate + "') AND procedimentos.grupoproced = " + cod_grupoproced;
        sql += " AND procedimentos.codesp=" + codesp;
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            //Cria looping com a resposta
            if(rs.next()) {
                resp[0] = rs.getFloat("somatorio");
                resp[1] = rs.getFloat("contador");
            }
            
            rs.close();
            stmt.close();
            
            return resp;
            
        } catch(SQLException e) {
            resp[0] = -1;
            return resp;
        }
    }
    
    //Monta combo com todos os profissionais
    public String getProfissionais(String cod_empresa) {
        String resp = "";
        String sql = "";
        ResultSet rs = null;
        
        sql += "SELECT nome, cod, prof_reg FROM profissional ";
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            //Só pega profissionais internos
            sql += " WHERE locacao='interno' AND cod_empresa=" + cod_empresa;
            sql += " AND ativo='S' ORDER BY nome";
            
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
    
    //Devolve os convênios
    public String getConvenios(String cod_empresa) {
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            String resp = "", sql;
            ResultSet rs = null;
            
            //Recupera todos os convênios para montar a lista
            sql =  "SELECT cod_convenio, descr_convenio FROM convenio ";
            sql += "WHERE cod_empresa=" + cod_empresa;
            sql += " ORDER BY descr_convenio";
            
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            //Cria looping com a resposta
            while(rs.next()) {
                resp += "<option value='" + rs.getString("cod_convenio") + "'>" + rs.getString("descr_convenio") + "</option>\n";
            }
            
            rs.close();
            stmt.close();
            
            return resp;
        } catch(SQLException e) {
            return e.toString();
        }
    }
    
    //Devolve as especialidades
    public String getEspecialidades(String cod_empresa) {
        String sql =  "SELECT codesp, descri FROM especialidade ";
        sql += "WHERE descri <> '' AND cod_empresa=" + cod_empresa;
        sql += " ORDER BY descri";
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
                resp += "<option value='" + rs.getString("codesp") + "'>" + rs.getString("descri") + "</option>\n";
            }
            rs.close();
            stmt.close();
            
            return resp;
        } catch(SQLException e) {
            return e.toString();
        }
    }
    
    //Devolve os Grupos de Procedimento
    public String getGruposProcedimentos(String cod_empresa) {
        String sql =  "SELECT cod_grupoproced, grupoproced FROM grupoprocedimento ";
        sql += "WHERE cod_empresa=" + cod_empresa;
        sql += " AND ativo='S' ";
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

    //Devolve os diagnósticos usuais
    public String getDiagnosticos(String cod_empresa) {
        String sql =  "SELECT cod_diag, DESCRICAO FROM diagnosticos ";
        sql += "WHERE flag=1 AND cod_empresa=" + cod_empresa;
        sql += " ORDER BY DESCRICAO";
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
                resp += "<option value='" + rs.getString("cod_diag") + "'>" + rs.getString("DESCRICAO") + "</option>\n";
            }
            rs.close();
            stmt.close();
            
            return resp;
        } catch(SQLException e) {
            return e.toString();
        }
    }
    
    //Devolve os pacientes com aniversário em um mês específico
    public Vector getEtiquetas(String mes, String meses, String cod_convenio, String cod_diag, String prof_reg, String cod_empresa) {
        //Retorno dos dados
        Vector retorno = new Vector();
        int cont=0;
        
        String sql="";
        sql  = "SELECT paciente.* ";
        sql += "FROM paciente_convenio RIGHT JOIN ((hist_diagnostico RIGHT JOIN ";
        sql += "historia ON hist_diagnostico.cod_hist = historia.cod_hist) RIGHT JOIN ";
        sql += "paciente ON historia.codcli = paciente.codcli) ON ";
        sql += "paciente_convenio.codcli = paciente.codcli ";
        sql += "WHERE ativo='S' ";
        sql += "AND nome_logradouro <> '' ";
        sql += "AND cep <> '' ";
        sql += "AND cod_empresa=" + cod_empresa + " ";
        sql += "AND status <> 2 ";
        
        //Se veio mês de nascimento
        if(!Util.isNull(mes))
            sql += " AND MONTH(data_nascimento) = " + mes;

        //Se escolher meses de consulta
        if(!Util.isNull(meses)) {

            //Converte em int a qtde de meses
            int qtdemeses = Integer.parseInt(meses)-1;
            
            //Cria uma data atual e depois reduz a quantidade de meses
            GregorianCalendar antes = new GregorianCalendar();
            antes.add(Calendar.MONTH, -qtdemeses);
            
            sql += " AND historia.DTACON > '" + toString(antes) + "'";
        }
        
        //Se escolheu convênio
        if(!Util.isNull(cod_convenio)) {
            sql += " AND paciente_convenio.cod_convenio = " + cod_convenio;
        }
        
        //Se escolheu diagnóstico
        if(!Util.isNull(cod_diag)) {
            sql += " AND hist_diagnostico.cod_diag=" + cod_diag;

        }
        
        //Se ecolheu médico responsável
        if(!Util.isNull(prof_reg)) {
            sql += " AND paciente.prof_reg='" + prof_reg + "' ";
        }

        sql += " GROUP BY paciente.codcli ";
        sql += " ORDER BY paciente.nome";
        
        String resp = "";
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            ResultSet rs = null;
            
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            //Começo da linha da etiqueta
            resp = "<table border=0 cellspacing=0 cellpadding=0 width='100%'>\n";
            retorno.add(resp);
            
            boolean achou = false;
            
            //Cria looping com a resposta
            while(rs.next()) {
                resp  = "";
                resp += "<tr><td height=96 width=255 class='texto' style='padding-left:10px'>\n";
                resp += rs.getString("nome") + "<br>";
                resp += rs.getString("nome_logradouro") + (!Util.isNull(rs.getString("numero")) ? " nº " + rs.getString("numero") : "") + "<br>";
                resp += rs.getString("bairro") + ", " + rs.getString("cidade") + "/" + rs.getString("uf") + "<br>";
                resp += "CEP: " + rs.getString("cep");
                resp += "</td>\n";
                resp += "<td width=255 class='texto' style='padding-left:10px'>\n";
                
                if(rs.next()) {
                    resp += rs.getString("nome") + "<br>";
                    resp += rs.getString("nome_logradouro") + " nº " + rs.getString("numero") + "<br>";
                    resp += rs.getString("bairro") + ", " + rs.getString("cidade") + "/" + rs.getString("uf") + "<br>";
                    resp += "CEP: " + rs.getString("cep");
                } else resp += "&nbsp;";
                
                resp += "</td>\n";
                resp += "<td class='texto' style='padding-left:10px'>\n";
                
                if(rs.next()) {
                    resp += rs.getString("nome") + "<br>";
                    resp += rs.getString("nome_logradouro") + " nº " + rs.getString("numero") + "<br>";
                    resp += rs.getString("bairro") + ", " + rs.getString("cidade") + "/" + rs.getString("uf") + "<br>";
                    resp += "CEP: " + rs.getString("cep");
                } else resp += "&nbsp;";
                
                resp += "</td>\n";
                
                resp += "</tr>";
                
                retorno.add(resp);
                
                achou = true;
                
                //Contador de linhas encontradas
                cont++;
                
                //Se for múltiplo de 10, colocar quebra de páginas
                if(cont % 10 == 0){
                    resp  = "</table>\n";
                    resp += "<div class='novapagina'></div>\n";
                    resp += "<table border=0 cellspacing=0 cellpadding=0 width='100%'>\n";
                    retorno.add(resp);
                }
            }
            rs.close();
            stmt.close();
            
            //Se não achou nenhum registro
            if(!achou) {
                retorno.add("<tr>");
                retorno.add("<td class='texto'>Nenhum registro encontrado</td>");
                retorno.add("</tr>");
            }
            
            retorno.add("</table>");
            
            return retorno;
        } catch(SQLException e) {
            retorno.add(e.toString());
            return retorno;
        }
    }
    
    //Devolve uma data no formato de aaaa/mm/dd
    private String toString(GregorianCalendar data) {
        int d,m,a;
        try {
            d = data.get(Calendar.DATE);
            m = data.get(Calendar.MONTH);
            a = data.get(Calendar.YEAR);
            
            return a + "/" + m + "/" + d;
        } catch (Exception e) {
            return e.toString();
        }
    }
    
    //devolve os pacientes que não possuem lançamento
    public Vector getPacientesSemLancamento(String de, String ate, String cod_empresa) {
        //Retorno dos dados
        Vector retorno = new Vector();
        String sql = "";
        
        //Coloca as datas no formato correto pro SQL (aaaa/mm/dd)
        de = Util.formataDataInvertida(de);
        ate = Util.formataDataInvertida(ate);
        
        sql  = "SELECT paciente.* ";
        sql += "FROM faturas_itens RIGHT JOIN (paciente LEFT JOIN ";
        sql += "faturas ON paciente.codcli = faturas.codcli) ON ";
        sql += "faturas_itens.Numero = faturas.Numero ";
        sql += "WHERE faturas_itens.Numero Is Null ";
        sql += "AND paciente.cod_empresa=" + cod_empresa + " ";
        sql += "AND paciente.ativo='S' ";
        sql += "AND paciente.data_abertura_registro BETWEEN '" + de + "' AND '" + ate + "' ";
        
        String resp = "";
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            boolean flag = false;
            String cor = "";
            int cont=1;
            
            ResultSet rs = null;
            
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            //Cria looping com a resposta
            while(rs.next()) {
                if(flag) {
                    cor = "#FFFFFF";
                    flag = false;
                } else {
                    cor = "#DEDEDE";
                    flag = true;
                }
                resp = "";
                resp += "<div class='texto' style='background-color:" + cor + "'>";
                resp += "<b>" + cont + " - " + rs.getString("nome") + ", nº de registro: " + rs.getString("registro_hospitalar") + "</b><br>";
                resp += "Nascimento: " + Util.formataData(rs.getString("data_nascimento")) + "<br>";
                resp += "Data do Cadastro: " + Util.formataData(rs.getString("data_abertura_registro"));
                resp += "</div>";
                cont++;
                
                retorno.add(resp);
            }
            rs.close();
            stmt.close();
            
            return retorno;
        } catch(SQLException e) {
            retorno.add(e.toString());
            return retorno;
        }
    }
 
    //Devolve os lançamentos de ponto inconsistentes
    public Vector getLancamentosPonto(String de, String ate, String cod_empresa) {
        //Retorno dos dados
        Vector retorno = new Vector();
        String sql = "";
        
        //Coloca as datas no formato correto pro SQL (aaaa/mm/dd)
        de = Util.formataDataInvertida(de);
        ate = Util.formataDataInvertida(ate);
        
        sql  = "SELECT cd_usuario, ds_nome FROM t_usuario WHERE ativo='S' ORDER BY ds_nome";       
        String resp = "";
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
             ResultSet rs = null;
             ResultSet rs2 = null;
            
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            //Buscar inconsistências para cada usuário
            while(rs.next()) {
                
                Statement stmt2 = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);

                //Buscar lançamentos que falta algum item
                sql = "SELECT * FROM ponto WHERE cd_usuario=" + rs.getString("cd_usuario");
                sql += " AND (entrada1 is null OR saida1 is null or entrada2 is null or saida2 is null)";
                sql += " AND DATA BETWEEN '" + de + "' AND '" + ate + "'";
                sql += " ORDER BY data";
                
                rs2 = stmt2.executeQuery(sql);
                
                resp  = "<table>";
                resp += "  <tr>";
                resp += "   <td colspan='5' class='tdMedium'>" + rs.getString("ds_nome") + "</td>";
                resp += "  </tr>";
                resp += "<tr>";
                resp += " <td width='100' class='tdMedium'>Data</td>";
                resp += " <td width='100' class='tdMedium'>Entrada</td>";
                resp += " <td width='100' class='tdMedium'>Saída</td>";
                resp += " <td width='100' class='tdMedium'>Entrada</td>";
                resp += " <td width='100' class='tdMedium'>Saída</td>";
                resp += "</tr>";

                
                //Captura todos os lançamentos nessa situação
                while(rs2.next()) {
                    resp += "<tr>";
                    resp += " <td class='tdLight'>" + Util.formataData(rs2.getString("data")) + "&nbsp;</td>";
                    resp += " <td class='tdLight'>" + Util.formataHora(rs2.getString("entrada1")) + "&nbsp;</td>";
                    resp += " <td class='tdLight'>" + Util.formataHora(rs2.getString("saida1")) + "&nbsp;</td>";
                    resp += " <td class='tdLight'>" + Util.formataHora(rs2.getString("entrada2")) + "&nbsp;</td>";
                    resp += " <td class='tdLight'>" + Util.formataHora(rs2.getString("saida2")) + "&nbsp;</td>";
                    resp += "</tr>";
                }
                
                rs2.close();
                stmt2.close();
               
                resp += "</table><br>";
                retorno.add(resp);
            }
            rs.close();
            stmt.close();
            
            return retorno;
        } catch(SQLException e) {
            retorno.add(e.toString());
            return retorno;
        }
        
    }
    
    //Recebe código de status e converte
    private String getStatus(String status) {
        String resp = "";
        
        if(Util.isNull(status))
            resp = "N/C";
        else if(status.equals("0"))
            resp = "Ativo";
        else if(status.equals("1"))
            resp = "Inativo";
        else if(status.equals("2"))
            resp = "Falecido";
        else
            resp = "N/C2";
        
        return resp;
    }
    
    //Relatório de Pacientes
    public Vector getPacientes(String de, String ate, String paciente, int tipo, String prof_reg, String status, String cod_convenio, String mes, String cod_empresa) {
        //Retorno dos dados
        Vector retorno = new Vector();
        
        //Coloca as datas no formato correto pro SQL (aaaa/mm/dd)
        de = Util.formataDataInvertida(de);
        ate = Util.formataDataInvertida(ate);
        
        //Monta sql para consulta
        String sql = "";
        sql += "SELECT paciente.data_abertura_registro, paciente.nome, paciente.registro_hospitalar, ";
        sql += "paciente.status, paciente.data_nascimento, paciente.ddd_comercial, paciente.tel_comercial, ";
        sql += "paciente.ddd_residencial, paciente.tel_residencial, paciente.ddd_celular, paciente.tel_celular, ";
        sql += "convenio.descr_convenio, paciente.email ";
        sql += "FROM (paciente LEFT JOIN paciente_convenio ON paciente.codcli = paciente_convenio.codcli) ";
        sql += "LEFT JOIN convenio ON paciente_convenio.cod_convenio = convenio.cod_convenio ";
        sql += "WHERE paciente.cod_empresa=" + cod_empresa + " AND paciente.ativo='S' ";
        
        //Se veio data de e atê, colocar intervalo
        if(!Util.isNull(de))  sql += " AND data_abertura_registro >= '" + de + "'";
        if(!Util.isNull(ate)) sql += " AND data_abertura_registro <= '" + ate + "'";
        
        //Se escolheu convênio
        if(!Util.isNull(cod_convenio))
            sql += " AND paciente_convenio.cod_convenio = " + cod_convenio;
        
        //Se veio profissional
        if(!Util.isNull(prof_reg))
            sql += " AND prof_reg='" + prof_reg + "'";
        
        //Se veio status do paciente
        if(!Util.isNull(status) && !status.equals("todos"))
            sql += " AND status='" + status + "'";
        
        //Se escolheu mês
        if(!Util.isNull(mes))
            sql += " AND MONTH(paciente.data_nascimento)=" + mes;

        //Verifica o tipo de busca no texto
        if(!Util.isNull(paciente)) {
            //Consulta exata
            if(tipo == 1)
                sql += " AND paciente.nome='" + paciente + "'";
            //Começando com o valor
            else if(tipo == 2)
                sql += " AND paciente.nome LIKE '" + paciente + "%'";
            //Com o valor no meio
            else if(tipo == 3)
                sql += " AND paciente.nome LIKE '%" + paciente + "%'";
        }
        
        //Agrupar por ordem alfabética
        sql += " ORDER BY paciente.nome";
        
        
        String resp = "";
        boolean troca = false;
        
        //Contador de registros
        int cont = 0;
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            ResultSet rs = null;
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            resp += "<tr>\n";
            resp += "<td class='tblrel' style='background-color:#CCCCCC'><b>nº Registro</b></td>\n";
            resp += "<td class='tblrel' style='background-color:#CCCCCC'><b>Cadastro</b></td>\n";
            resp += "<td class='tblrel' style='background-color:#CCCCCC'><b>Nome</b></td>\n";
            resp += "<td class='tblrel' style='background-color:#CCCCCC'><b>Nascimento</b></td>\n";
            resp += "<td class='tblrel' style='background-color:#CCCCCC'><b>Convênio</b></td>\n";
            resp += "<td class='tblrel' style='background-color:#CCCCCC'><b>Status</b></td>\n";
            resp += "<td class='tblrel' style='background-color:#CCCCCC'><b>Tel. Res.</b></td>\n";
            resp += "<td class='tblrel' style='background-color:#CCCCCC'><b>Tel. Cel.</b></td>\n";
            resp += "<td class='tblrel' style='background-color:#CCCCCC'><b>Tel. Com.</b></td>\n";
            resp += "<td class='tblrel' style='background-color:#CCCCCC'><b>email</b></td>\n";
            resp += "</tr>\n";
            
            //Adiciona cabeçalho ao retorno
            retorno.add(resp);
            
            //Cria looping com a resposta
            while(rs.next()) {
                resp = "";
                
                //Alterna as cores do fundo
                if(troca) {
                    resp += "<tr style='background-color:#FFFFFF'>\n";
                    troca = false;
                } else {
                    resp += "<tr style='background-color:#EEEEEE'>\n";
                    troca = true;
                }
                
                resp += "	<td class='tblrel'>" + Util.trataNulo(rs.getString("registro_hospitalar"),"&nbsp;") + "</td>\n";
                resp += "	<td class='tblrel'>" + Util.trataNulo(Util.formataData(rs.getString("data_abertura_registro")),"&nbsp;") + "</td>\n";
                resp += "	<td class='tblrel'>" + rs.getString("paciente.nome") + "</td>\n";
                resp += "	<td class='tblrel'>" + Util.formataData(rs.getString("data_nascimento")) + "</td>\n";
                resp += "	<td class='tblrel'>" + Util.trataNulo(rs.getString("descr_convenio"), "Sem convênio") + "</td>\n";
                resp += "	<td class='tblrel'>" + this.getStatus(rs.getString("status")) + "</td>\n";
                resp += "	<td class='tblrel'>(" + Util.trataNulo(rs.getString("ddd_residencial"),"N/C") + ") " + Util.trataNulo(rs.getString("tel_residencial"),"N/C") + "</td>\n";
                resp += "	<td class='tblrel'>(" + Util.trataNulo(rs.getString("ddd_celular"),"N/C") + ") " + Util.trataNulo(rs.getString("tel_celular"),"N/C") + "</td>\n";
                resp += "	<td class='tblrel'>(" + Util.trataNulo(rs.getString("ddd_comercial"),"N/C") + ") " + Util.trataNulo(rs.getString("tel_comercial"),"N/C") + "</td>\n";
                resp += "	<td class='tblrel'>" + Util.trataNulo(rs.getString("email"), "&nbsp;") + "</td>\n";
                //Adiciona cada linha ao retorno
                retorno.add(resp);
                
                //Contador
                cont++;
            }
            
            //Linha final
            resp = "<tr>\n";
            resp += " <td colspan='10' class='tblrel' style='background-color:#CCCCCC'><b>Total de Registros: " + cont + "</b></td>\n";
            resp += "</tr>\n";
            retorno.add(resp);
            
            rs.close();
            stmt.close();
            
            return retorno;
        } catch(SQLException e) {
            retorno.add(e.toString() + "<br>" + sql);
            return retorno;
        }
    }
    
    //Relatório de Profissionais
    public Vector getProfissionais(String profissional, int tipo, String especialidade, String situacao, String cod_empresa) {
        //Retorno dos dados
        Vector retorno = new Vector();
        
        //Monta sql para consulta
        String sql = "";
        sql += "SELECT profissional.* FROM profissional LEFT JOIN ";
        sql += "prof_esp ON profissional.prof_reg = prof_esp.prof_reg ";
        sql += "WHERE profissional.ativo='S' AND cod_empresa=" + cod_empresa;
        
        //Verifica o tipo de busca no texto
        //Consulta exata
        if(tipo == 1)
            sql += " AND nome='" + profissional + "'";
        //Começando com o valor
        else if(tipo == 2)
            sql += " AND nome LIKE '" + profissional + "%'";
        //Com o valor no meio
        else if(tipo == 3)
            sql += " AND nome LIKE '%" + profissional + "%'";
        
        //Filtra por especialidades
        if(!especialidade.equals("todos"))
            sql += " AND codesp=" + especialidade;
        
        //Filtro por situação
        if(!situacao.equals("todos"))
            sql += " AND locacao='" + situacao + "'";
        
        //Agrupar por ordem alfabética
        sql += " ORDER BY nome";
        
        String resp = "";
        int cont=1;
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            ResultSet rs = null;
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            //Cria looping com a resposta
            while(rs.next()) {
                resp = "";
                resp += "<table width='100%' border='0' cellpadding='0' cellspacing='0'>\n";
                resp += "<tr>\n";
                resp += "   <td colspan='2' class='tblrel' style='background-color:#DDDDDD'><img id='img" + cont + "' src='images/plus.png' onClick='view("+cont+")'> Profissional: <b>" + rs.getString("profissional.nome") + "</b></td>\n";
                resp += "</tr>\n";
                resp += "</table>\n";
                resp += "<div id='tr"+cont+"' style='display:\"none\"'>\n";
                resp += "<table width='100%' border='0' cellpadding='0' cellspacing='0'>\n";
                resp += "<tr>\n";
                resp += "	<td width='100px' class='tblrel'>Endereço:</td>\n";
                resp += "	<td colspan='3' class='tblrel'>" + Util.trataNulo(rs.getString("nome_logradouro"), "N/C") + "</td>\n";
                resp += "</tr>\n";
                resp += "<tr>\n";
                resp += "	<td class='tblrel'>e-mail:</td>\n";
                resp += "	<td colspan='3' class='tblrel'>" + Util.trataNulo(rs.getString("email"), "N/C") + "</td>\n";
                resp += "</tr>\n";
                resp += "<tr>\n";
                resp += "	<td class='tblrel'>Telefone:</td>\n";
                resp += "	<td class='tblrel'>(" + Util.trataNulo(rs.getString("ddd_residencial"),"__") + ") " +  Util.trataNulo(rs.getString("tel_residencial"),"") + "</td>\n";
                resp += "	<td class='tblrel'>Celular:</td>\n";
                resp += "	<td class='tblrel'>(" + Util.trataNulo(rs.getString("ddd_celular"),"__") + ") " +  Util.trataNulo(rs.getString("ddd_celular"),"") + "</td>\n";
                resp += "</tr>\n";
                resp += "<tr>\n";
                resp += "	<td class='tblrel'>Especialidades:</td>\n";
                resp += "	<td colspan='3' class='tblrel'>" + getEspecialidadesProfissional(rs.getString("prof_reg")) + "</td>\n";
                resp += "</tr>\n";
                resp += "</table>";
                resp += "</div>\n";
                resp += "<table><tr><td height='3px'></td></tr></table>";
                cont++;
                
                //Adiciona cada linha ao retorno
                retorno.add(resp);
            }
            
            retorno.add("<input type='hidden' id='qtdetotal' name='qtdetotal' value='" + cont + "'>");
            rs.close();
            stmt.close();
            
            return retorno;
        } catch(SQLException e) {
            retorno.add(e.toString() + "<br>" + sql);
            return retorno;
        }
    }
    
    //Recebe o intervalo de pesquisa e a empresa
    public Vector getRelatorioAnalitico(String de, String ate, String cod_empresa) {
        //Retorno dos dados
        Vector retorno = new Vector();
        
        //Converte as datas
        de = Util.formataDataInvertida(de);
        ate = Util.formataDataInvertida(ate);
        
        String sql = "";
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            //Cria statement para enviar sql
            Statement stmt2 = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            ResultSet rs = null;
            ResultSet rs2 = null;
            
            float somasubtotal=0, somafinal=1;
            int contasubtotal=0, contafinal=1;
            float porcentagem1, porcentagem2;
            
            //Pega todos os grupos de procedimentos para buscar os totais
            sql =  "SELECT cod_grupoproced, grupoproced FROM grupoprocedimento ";
            sql += "WHERE cod_empresa=" + cod_empresa;
            sql += " ORDER BY grupoproced";
            
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            //Começa a tabela de respostas do relatório
            retorno.add("<center><table width='90%' cellspacing=0 cellpadding=0 class='table'");
            
            //Para cada grupo de procedimento, calcular os totais
            while(rs.next()) {
                
                //Calcula a soma total antes das parciais para calcular as porcentagens
                sql =  "SELECT Sum(faturas_itens.valor) AS valortotal, ";
                sql += "Sum(faturas_itens.qtde) AS qtdetotal FROM faturas ";
                sql += "INNER JOIN ((faturas_itens INNER JOIN procedimentos ON ";
                sql += "faturas_itens.Cod_Proced = procedimentos.COD_PROCED) ";
                sql += "INNER JOIN grupoprocedimento ON procedimentos.grupoproced ";
                sql += "= grupoprocedimento.cod_grupoproced) ON faturas.Numero = ";
                sql += "faturas_itens.Numero ";
                sql += "WHERE faturas.Data_Lanca BETWEEN '" + de + "' AND '" + ate;
                sql += "' AND grupoprocedimento.cod_grupoproced=" + rs.getString("cod_grupoproced");
                sql += " GROUP BY grupoprocedimento.cod_grupoproced ";
                
                
                //Executa a pesquisa
                rs2 = stmt2.executeQuery(sql);
                
                if(rs2.next()) {
                    somafinal = rs2.getFloat("valortotal");
                    contafinal = rs2.getInt("qtdetotal");
                } else {
                    somafinal = 0;
                    contafinal = 0;
                }
                
                sql =  "SELECT convenio.descr_convenio as convenio, SUM(faturas_itens.valor) ";
                sql += "AS valortotal, Sum(faturas_itens.qtde) AS qtdetotal ";
                sql += "FROM faturas INNER JOIN (((faturas_itens INNER JOIN convenio ";
                sql += "ON faturas_itens.cod_convenio = convenio.cod_convenio) ";
                sql += "INNER JOIN procedimentos ON faturas_itens.Cod_Proced = ";
                sql += "procedimentos.COD_PROCED) INNER JOIN grupoprocedimento ";
                sql += "ON procedimentos.grupoproced = grupoprocedimento.cod_grupoproced) ";
                sql += "ON faturas.Numero = faturas_itens.Numero ";
                sql += "WHERE faturas.Data_Lanca BETWEEN '" + de + "' AND '" + ate;
                sql += "' AND grupoprocedimento.cod_grupoproced=" + rs.getString("cod_grupoproced");
                sql += " GROUP BY convenio.descr_convenio, grupoprocedimento.cod_grupoproced ";
                sql += " ORDER BY convenio.descr_convenio";
                
                //Adiciona cabeçalho com o nome do procedimento
                retorno.add("<tr>");
                retorno.add("<td colspan=5 class='tdDark'><b><li>" + rs.getString("grupoproced") + "</li></b></td>");
                retorno.add("</tr>");
                
                retorno.add("<tr>");
                retorno.add("<td class='tdMedium'><b>Convênio</b></td>");
                retorno.add("<td class='tdMedium'><b>Qtde</b></td>");
                retorno.add("<td class='tdMedium'><b>% do Total</b></td>");
                retorno.add("<td class='tdMedium'><b>Valor</b></td>");
                retorno.add("<td class='tdMedium'><b>% Valor</b></td>");
                retorno.add("</tr>");
                
                //Executa a pesquisa
                rs2 = stmt2.executeQuery(sql);
                
                while(rs2.next()) {
                    
                    //Captura valores parciais
                    somasubtotal = rs2.getFloat("valortotal");
                    contasubtotal = rs2.getInt("qtdetotal");
                    
                    //Calcula as porcentagens
                    porcentagem1 = (100.0f*somasubtotal)/somafinal;
                    porcentagem2 = (100.0f*contasubtotal)/contafinal;
                    
                    retorno.add("<tr>");
                    retorno.add("<td class='tdLight'>" + rs2.getString("convenio") + "</td>");
                    retorno.add("<td class='tdLight'>" + contasubtotal + "</td>");
                    retorno.add("<td class='tdLight'>" + Util.arredondar(porcentagem2,2,2) + "</td>");
                    retorno.add("<td class='tdLight' align='right'>" + Util.formatCurrency(somasubtotal+"") + "</td>");
                    retorno.add("<td class='tdLight'>" + Util.arredondar(porcentagem1,2,2) + "</td>");
                    retorno.add("</tr>");
                    
                }
                
                retorno.add("<tr>");
                retorno.add("<td class='tdMedium'>&nbsp;</td>");
                retorno.add("<td class='tdMedium'><b>" + contafinal + "</b></td>");
                retorno.add("<td class='tdMedium'><b>100%</b></td>");
                retorno.add("<td class='tdMedium' align='right'><b>" + Util.formatCurrency(somafinal+"") + "</b></td>");
                retorno.add("<td class='tdMedium'><b>100%</b></td>");
                retorno.add("</tr>");
            }
            
            retorno.add("</table></center>");
            
            rs.close();
            stmt.close();
            
        } catch(SQLException e) {
            retorno.add(e.toString());
        }
        
        return retorno;
    }
    
    //Recupera os campos de filtro do rel de agenda (recuperando o cookie dos selecionados)
    public String getCamposRelAgenda(HttpServletRequest request) {
        String resp = "";
        int tam = colunasFiltroAgenda.length;
        
        //Recupera o cookies de itens escolhidos da agenda
        Cookie cookies [] = request.getCookies();
        String camposRelAgenda = "";
        String vetCamposRelAgenda[] = null;
        if (cookies != null) {
            for (int i = 0; i < cookies.length; i++) {
                if (cookies [i].getName().equals ("camposRelAgenda")){
                    camposRelAgenda = cookies[i].getValue();
                    vetCamposRelAgenda = camposRelAgenda.split(",");
                    break;
                }
            }
        }
        
        for(int i=0; i<tam; i++) {
            resp += "<tr>\n";
            if(i < tam)
                //Se existir cookie para esse item
                if(Util.pertence(i+"", vetCamposRelAgenda))
                    resp += " <td class='tdLight'><input type='checkbox' name='campos' value='" + i + "' checked> " + colunasFiltroAgenda[i] + "</td>\n";
                else
                    resp += " <td class='tdLight'><input type='checkbox' name='campos' value='" + i + "'> " + colunasFiltroAgenda[i] + "</td>\n";
            else
                resp += " <td class='tdLight'>&nbsp;</td>\n";

            i++;
            if(i < tam)
                //Se existir cookie para esse item
                if(Util.pertence(i+"", vetCamposRelAgenda))                
                    resp += " <td class='tdLight'><input type='checkbox' name='campos' value='" + i + "' checked> " + colunasFiltroAgenda[i] + "</td>\n";
                else
                    resp += " <td class='tdLight'><input type='checkbox' name='campos' value='" + i + "'> " + colunasFiltroAgenda[i] + "</td>\n";
            else
                resp += " <td class='tdLight'>&nbsp;</td>\n";
            
            resp += "</tr>\n";
        }
        
        return resp;
    }
    
    private void insereCampo(String cabecalho, String item, Vector resposta, String campos[], String texto) {
        boolean achou = false;
        
        //Verifica se o item se encontra no vetor de campos escolhidos
        for(int i=0; i<campos.length; i++) {
            if(campos[i].equals(item))
                achou = true;
        }
        
        //Se achou o campo, incluir na resposta
        if(achou) {
            //Se o item for profissional e o cabeçalho não
            if(item.equals("0") && !cabecalho.equals("1"))
                resposta.add(texto);
            //Se o item for procedimento e o cabeçalho não
            else if(item.equals("6") && !cabecalho.equals("2"))
                resposta.add(texto);
            //Se o item for status e o cabeçalho não
            else if(item.equals("8") && !cabecalho.equals("3"))
                resposta.add(texto);
            else if(item.equals("7") && !cabecalho.equals("4"))
                resposta.add(texto);
            else if(!item.equals("0") && !item.equals("6") && !item.equals("8") && !item.equals("7"))
                resposta.add(texto);
        }
        
    }
   
    //Recebe o intervalo de pesquisa e o médico para dar o relatório de agendas
    public Vector getRelatorioAgendamentos(String de, String ate, String prof_reg, String grupoproced, String statusagenda, String ordem, String campos[], String cod_convenio, String cabecalho, String primeiravez) {
        //Retorno dos dados
        Vector retorno = new Vector();
        boolean troca = false;
        String cor = "";
        String descricaocabecalho = "";
        
        //Converte as datas
        de = Util.formataDataInvertida(de);
        ate = Util.formataDataInvertida(ate);
        
        String sql = "";
        int totencaixe=0, totretorno=0, totprimeiravez=0;
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            ResultSet rs = null;
            
            //Verifica se escolheu cabeçalho
            if(!Util.isNull(cabecalho)) {
                //Profissional
                if(cabecalho.equals("1"))
                    descricaocabecalho = "Profissional: " + new Banco().getValor("nome", "SELECT nome FROM profissional WHERE prof_reg='" + prof_reg + "'");
                //Procedimento
                if(cabecalho.equals("2"))
                    descricaocabecalho = "Procedimento: " + new Banco().getValor("grupoproced", "SELECT grupoproced FROM grupoprocedimento WHERE cod_grupoproced=" + grupoproced);
                //Status
                if(cabecalho.equals("3")) {
                    descricaocabecalho = "Status: ";
                    if(statusagenda.equals("1")) descricaocabecalho += "Aguardando atendimento";
                    if(statusagenda.equals("3")) descricaocabecalho += "Não compareceu";
                    if(statusagenda.equals("9")) descricaocabecalho += "Atendido";
                }
                if(cabecalho.equals("4"))
                    descricaocabecalho = "Convênio: " + new Banco().getValor("descr_convenio", "SELECT descr_convenio FROM convenio WHERE cod_convenio=" + cod_convenio);
            }
            
            //Pega todas as agendas
            sql =  "SELECT paciente.nome AS nome_paciente, paciente.codcli, grupoprocedimento.grupoproced, ";
            sql += "agendamento.data, agendamento.hora, convenio.descr_convenio, agendamento.status, ";
            sql += "agendamento.encaixe, agendamento.retorno, profissional.nome AS medico, t_usuario.ds_nome, ";
            sql += "paciente.ddd_comercial, paciente.tel_comercial, paciente.ddd_residencial, ";
            sql += "paciente.tel_residencial, paciente.ddd_celular, paciente.tel_celular, agendamento.obs, ";
            sql += "paciente.registro_hospitalar ";
            sql += "FROM ((((paciente INNER JOIN agendamento ON paciente.codcli = agendamento.codcli) ";
            sql += "INNER JOIN convenio ON agendamento.cod_convenio = convenio.cod_convenio) ";
            sql += "INNER JOIN profissional ON agendamento.prof_reg = profissional.prof_reg) ";
            sql += "LEFT JOIN t_usuario ON agendamento.usuario_inclusao = t_usuario.cd_usuario) ";
            sql += "LEFT JOIN grupoprocedimento ON agendamento.cod_proced = grupoprocedimento.cod_grupoproced ";
            sql += "WHERE agendamento.ativo='S' ";
            sql += " AND data BETWEEN '" + de + "' AND '" + ate + "' ";
            
            //Se escolheu profissional
            if(!Util.isNull(prof_reg))
                sql += " AND agendamento.prof_reg='" + prof_reg + "'";
            
            //Se escolheu procedimento
            if(!Util.isNull(grupoproced))
                sql += " AND agendamento.cod_proced=" + grupoproced;
            
            //Se escolheu status
            if(!Util.isNull(statusagenda))
                sql += " AND agendamento.status=" + statusagenda;
            
            //Se escolheu convênio
            if(!Util.isNull(cod_convenio))
                sql += " AND agendamento.cod_convenio=" + cod_convenio;

            sql += " ORDER BY " + ordem;
            
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            //Se escolheu cabeçalho
            if(!Util.isNull(cabecalho)) {
                 retorno.add("<center><div class='title'>" + descricaocabecalho + "</div></center>");
            }
            
            //Adiciona cabeçalho
            retorno.add("<center><table border=0 cellspacing=0 cellpadding=0 width='95%'>");
            retorno.add("<tr>");

            insereCampo(cabecalho, "0", retorno, campos, "<td class='tblrel' style='background-color:#CECECE'><a title='Ordenar por Profissional' href=\"Javascript:ordenar('relagenda2','medico')\"><b>Profissional</b></a></td>");
            insereCampo(cabecalho, "1", retorno, campos, "<td class='tblrel' style='background-color:#CECECE'><a title='Ordenar por Data' href=\"Javascript:ordenar('relagenda2','data ASC, hora ASC')\"><b>Data</b></a></td>");
            insereCampo(cabecalho, "2", retorno, campos, "<td class='tblrel' style='background-color:#CECECE'><b>Hora</b></td>");
            insereCampo(cabecalho, "3", retorno, campos, "<td class='tblrel' style='background-color:#CECECE'><a title='Ordenar por Paciente' href=\"Javascript:ordenar('relagenda2','nome_paciente')\"><b>Paciente</b></a></td>");
            insereCampo(cabecalho, "4", retorno, campos, "<td class='tblrel' style='background-color:#CECECE'><a title='Ordenar por Registro' href=\"Javascript:ordenar('relagenda2','registro_hospitalar')\"><b>Registro</b></a></td>");
            insereCampo(cabecalho, "5", retorno, campos, "<td class='tblrel' style='background-color:#CECECE'><b>Telefones</b></td>");
            insereCampo(cabecalho, "6", retorno, campos, "<td class='tblrel' style='background-color:#CECECE'><a title='Ordenar por Procedimento' href=\"Javascript:ordenar('relagenda2','grupoproced')\"><b>Procedimento</b></a></td>");
            insereCampo(cabecalho, "7", retorno, campos, "<td class='tblrel' style='background-color:#CECECE'><a title='Ordenar por Convênio' href=\"Javascript:ordenar('relagenda2','descr_convenio')\"><b>Convênio</b></a></td>");
            insereCampo(cabecalho, "8", retorno, campos, "<td class='tblrel' style='background-color:#CECECE'><b>Status</b></td>");
            insereCampo(cabecalho, "9", retorno, campos, "<td class='tblrel' style='background-color:#CECECE'><b>Retorno</b></td>");
            insereCampo(cabecalho, "10", retorno, campos, "<td class='tblrel' style='background-color:#CECECE'><b>Encaixe</b></td>");
            insereCampo(cabecalho, "11", retorno, campos, "<td class='tblrel' style='background-color:#CECECE'><b>Agendado por</b></td>");
            insereCampo(cabecalho, "12", retorno, campos, "<td class='tblrel' style='background-color:#CECECE'><b>OBS</b></td>");
            retorno.add("</tr>");
            
            //Contador de ocorrências
            int cont = 0;
            
            //String para telefones
            String cel, res, com, fones="";

            //Pegar as agendas
            while(rs.next()) {
                
                //Se não tem filtro de primeira vez OU tem e é primeira vez
                if(Util.isNull(primeiravez) || (primeiravez.equalsIgnoreCase("S") && Util.primeiraVez(rs.getString("codcli"), Util.formataData(rs.getString("data")), true))) {

                    //Acumula os totais
                    if(!Util.isNull(rs.getString("encaixe")) && rs.getString("encaixe").equals("S")) totencaixe++;
                    if(!Util.isNull(rs.getString("retorno")) && rs.getString("retorno").equals("S")) totretorno++;
                    if(Util.primeiraVez(rs.getString("codcli"), Util.formataData(rs.getString("data")), true)) totprimeiravez++;

                    //Pega os telefones
                    cel = "(" + Util.trataNulo(rs.getString("ddd_celular"), "") + ")" + Util.trataNulo(rs.getString("tel_celular"), "");
                    res = "(" + Util.trataNulo(rs.getString("ddd_residencial"), "") + ")" + Util.trataNulo(rs.getString("tel_residencial"), "");
                    com = "(" + Util.trataNulo(rs.getString("ddd_comercial"), "") + ")" + Util.trataNulo(rs.getString("tel_comercial"), "");

                    //Monta os telefones
                    fones = "";
                    if(cel.length()>3)
                        fones += cel;
                    if(res.length()>3)
                        fones += "<br>" + res;
                    if(com.length()>3)
                        fones += "<br>" + com;

                    //Alterna Cores
                    if(troca) {
                        cor = "style='background-color:#DDDDDD'";
                        troca = false;
                    }
                    else {
                        cor = "";
                        troca = true;
                    }

                    retorno.add("<tr>");
                    insereCampo(cabecalho, "0", retorno, campos, "<td class='tblrel' " + cor + ">" + rs.getString("medico") + "</td>");
                    insereCampo(cabecalho, "1", retorno, campos, "<td class='tblrel' " + cor + ">" + Util.formataData(rs.getString("data")) + "</td>");
                    insereCampo(cabecalho, "2", retorno, campos, "<td class='tblrel' " + cor + ">" + Util.formataHora(rs.getString("hora")) + "</td>");
                    insereCampo(cabecalho, "3", retorno, campos, "<td class='tblrel' " + cor + ">" + rs.getString("nome_paciente") + "</td>");
                    insereCampo(cabecalho, "4", retorno, campos, "<td class='tblrel' " + cor + ">" + Util.trataNulo(rs.getString("registro_hospitalar"),"&nbsp;") + "</td>");
                    insereCampo(cabecalho, "5", retorno, campos, "<td class='tblrel' " + cor + ">" + fones + "</td>");
                    insereCampo(cabecalho, "6", retorno, campos, "<td class='tblrel' " + cor + ">" + rs.getString("grupoproced") + "</td>");
                    insereCampo(cabecalho, "7", retorno, campos, "<td class='tblrel' " + cor + ">" + rs.getString("descr_convenio") + "</td>");
                    insereCampo(cabecalho, "8", retorno, campos, "<td class='tblrel' " + cor + " align='center'><img src='images/" + rs.getInt("status") + ".gif'></td>");
                    insereCampo(cabecalho, "9", retorno, campos, "<td class='tblrel' " + cor + " align='center'>" + rs.getString("retorno") + "</td>");
                    insereCampo(cabecalho, "10", retorno, campos, "<td class='tblrel' " + cor + " align='center'>" + rs.getString("encaixe") + "</td>");
                    insereCampo(cabecalho, "11", retorno, campos, "<td class='tblrel' " + cor + ">" + Util.trataNulo(rs.getString("ds_nome"),"N/C") + "</td>");
                    insereCampo(cabecalho, "12", retorno, campos, "<td class='tblrel' " + cor + ">" + Util.trataNulo(rs.getString("obs"),"&nbsp;") + "</td>");
                    retorno.add("</tr>");
                    cont++;
                }
            }
            
            retorno.add("<tr>");
            retorno.add("<td colspan='13' class='tblrel' style='background-color:#CECECE'><b>Total de Registros: " + cont + "</b></td>");
            retorno.add("</tr>");
            retorno.add("</table>");
            retorno.add("</center><br><br>");

            retorno.add("<center><table border=0 cellspacing=0 cellpadding=0 width='95%'>");
            retorno.add("<tr>");
            retorno.add("<td class='texto'><b>TOTAIS:</b> </td><td class='texto'><b>Encaixe:</b> " + totencaixe + "</td><td class='texto'><b>Retorno:</b> " + totretorno + "</td><td class='texto'><b>Primeira Vez:</b> " + totprimeiravez + "</td>");
            retorno.add("</tr>");
            retorno.add("</table>");
            retorno.add("</center>");
            
            rs.close();
            stmt.close();
            
        } catch(SQLException e) {
            retorno.add("ERRO: " + e.toString() + " SQL: " + sql);
        }
        
        return retorno;
    }

    //Devolve os grupos de procedimentos
    public String getGruposProcecimentos(String cod_empresa) {
        
        String sql =  "SELECT * FROM grupoprocedimento ";
        sql += "WHERE cod_empresa=" + cod_empresa;
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
    
    //Devolve as especialidades de um profissional
    public String getEspecialidadesProfissional(String prof_reg) {
        
        String sql =  "SELECT especialidade.descri ";
        sql += "FROM prof_esp INNER JOIN especialidade ";
        sql += "ON prof_esp.codesp = especialidade.codesp ";
        sql += "WHERE prof_esp.prof_reg='" + prof_reg + "'";

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
                resp += "<li>" + rs.getString("descri") + "</li>\n";
            }
            rs.close();
            stmt.close();
            
            return resp;
        } catch(SQLException e) {
            return e.toString();
        }
    }
    
    //Relatório de Pacientes de Primeira Consulta
    public Vector getPacientesPrimeiraConsulta(String de, String ate, String grupoproced, String cod_empresa) {
        //Retorno dos dados
        Vector retorno = new Vector();
        
        //Coloca as datas no formato correto pro MySQL (aaaa-mm-dd)
        de  = Util.formataDataInvertida(de);
        ate = Util.formataDataInvertida(ate);
        
        //Monta sql para consulta
        String sql = "";
        
        sql += "SELECT faturas.codcli, profissional.nome, faturas.prof_reg ";
        sql += "FROM profissional INNER JOIN ((faturas_itens INNER JOIN procedimentos ON ";
        sql += "faturas_itens.Cod_Proced = procedimentos.COD_PROCED) INNER JOIN faturas ON ";
        sql += "faturas_itens.Numero = faturas.Numero) ON profissional.prof_reg = faturas.prof_reg ";
        sql += "WHERE procedimentos.cod_empresa=" + cod_empresa;
        
        //Se selecionou grupo de procedimento, pegar todos
        if(!grupoproced.equals("todos")) {
            sql += " AND procedimentos.grupoproced = " + grupoproced;
        }
        
        //Se veio data de e atê, colocar intervalo
        if(!Util.isNull(de))  sql += " AND faturas.Data_Lanca >= '" + de + "'";
        if(!Util.isNull(ate)) sql += " AND faturas.Data_Lanca <= '" + ate + "'";
        
        sql += " GROUP BY faturas.codcli, faturas.prof_reg ";
        sql += "HAVING Count(faturas_itens.cod_subitem)=1 ";
        sql += "ORDER BY faturas.prof_reg";
        
        String resp = "";
        int cont=0;
        String prof = "", oldprof = "";
        long tot = 0;
        double porc = 0.0;
        int totalgeral = 0;
        String oldnome = "";
        int totalgeral2 = 0;
        double media = 0;
        int contaprof = 0;
        
        
        try {
            
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            ResultSet rs = null;
            
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            resp += "<tr>\n";
            resp += "  <td class='tblrel' style='background-color:#CACACA'><b>Profissional</b></td>\n";
            resp += "  <td class='tblrel' style='background-color:#CACACA; text-align:center'><b>Total de Atendimentos</b></td>\n";
            resp += "  <td class='tblrel' style='background-color:#CACACA; text-align:center'><b>Atendimentos Únicos</b></td>\n";
            resp += "  <td class='tblrel' style='background-color:#CACACA; text-align:center'><b>%</b></td>\n";
            resp += "</tr>\n";
            
            //Adiciona cabeçalho ao retorno
            retorno.add(resp);
            
            //Cria looping com a resposta
            while(rs.next()) {
                
                prof = rs.getString("prof_reg");
                
                if(!oldprof.equals("") && !oldprof.equals(prof)) {
                    
                    tot = getTotalConsultasProfissional(oldprof, de, ate, grupoproced, cod_empresa);
                    porc = Util.arredondar((cont * 100.0) / tot, 1, 1);
                    media = media + porc;
                    contaprof++;
                    
                    resp += "<tr>\n";
                    resp += "  <td class='tblrel'>" + oldnome + "</td>\n";
                    resp += "  <td class='tblrel' style='text-align:center'>" + tot + "</td>\n";
                    resp += "  <td class='tblrel' style='text-align:center'>" + cont + "</td>\n";
                    resp += "  <td class='tblrel' style='text-align:center'>" + porc + "</td>\n";
                    resp += "</tr>\n";
                    
                    //Adiciona cada linha ao retorno
                    retorno.add(resp);
                    
                    totalgeral += cont;
                    totalgeral2 += tot;
                    cont=0;
                }
                
                resp = "";
                cont++;
                
                oldprof = prof;
                oldnome = rs.getString("profissional.nome");
            }
            
            tot = getTotalConsultasProfissional(oldprof, de, ate, grupoproced, cod_empresa);
            porc = Util.arredondar((cont * 100.0) / tot, 1, 1);
            media = media + porc;
            contaprof++;
            media = Util.arredondar(media / contaprof,1,1);
            
            resp += "<tr>\n";
            resp += "  <td class='tblrel'>" + oldnome + "</td>\n";
            resp += "  <td class='tblrel' style='text-align:center'>" + tot + "</td>\n";
            resp += "  <td class='tblrel' style='text-align:center'>" + cont + "</td>\n";
            resp += "  <td class='tblrel' style='text-align:center'>" + porc + "</td>\n";
            resp += "</tr>\n";
            
            //Adiciona cada linha ao retorno
            retorno.add(resp);
            
            //Soma o último item
            totalgeral += cont;
            totalgeral2 += tot;
            
            resp = "";
            resp += "<tr>\n";
            resp += "  <td class='tblrel' style='background-color:#CACACA'><b>Totais....:</b></td>\n";
            resp += "  <td class='tblrel' style='background-color:#CACACA; text-align:center'><b>" + totalgeral2 + "</b></td>\n";
            resp += "  <td class='tblrel' style='background-color:#CACACA; text-align:center'><b>" + totalgeral + "</b></td>\n";
            resp += "  <td class='tblrel' style='background-color:#CACACA; text-align:center'><b>" + media + "</b></td>\n";
            resp += "</tr>\n";
            
            //Adiciona cada linha ao retorno
            retorno.add(resp);
            
            rs.close();
            stmt.close();
            
            return retorno;
        } catch(SQLException e) {
            retorno.add(e.toString() + "<br>" + sql);
            return retorno;
        }
    }
    
    //Relatório de Fidelização de Pacientes
    public Vector getFidelizacao(String de, String ate, String grupoproced, String qtde, String cod_empresa) {
        //Retorno dos dados
        Vector retorno = new Vector();
        
        //Coloca as datas no formato correto pro MySQL (aaaa-mm-dd)
        de  = Util.formataDataInvertida(de);
        ate = Util.formataDataInvertida(ate);
        
        //Monta sql para consulta
        String sql = "";
        
        sql += "SELECT faturas.codcli, profissional.nome, faturas.prof_reg ";
        sql += "FROM profissional INNER JOIN ((faturas_itens INNER JOIN procedimentos ON ";
        sql += "faturas_itens.Cod_Proced = procedimentos.COD_PROCED) INNER JOIN faturas ON ";
        sql += "faturas_itens.Numero = faturas.Numero) ON profissional.prof_reg = faturas.prof_reg ";
        sql += "WHERE procedimentos.cod_empresa=" + cod_empresa;
        
        //Se não selecionou grupo de procedimento, pegar todos
        if(grupoproced.equals("todos")) {
            
            sql += " AND procedimentos.grupoproced <> -99";
            
        }
        //Se escolheu o grupo de procedimentos, filtra
        else  {
            
            sql += " AND procedimentos.grupoproced = " + grupoproced;
        }
        
        //Se veio data de e atê, colocar intervalo
        if(!Util.isNull(de))  sql += " AND faturas.Data_Lanca >= '" + de + "'";
        if(!Util.isNull(ate)) sql += " AND faturas.Data_Lanca <= '" + ate + "'";
        
        sql += " GROUP BY faturas.codcli, faturas.prof_reg ";
        sql += "HAVING Count(faturas_itens.cod_subitem) >= " + qtde;
        sql += " ORDER BY faturas.prof_reg";
        
        String resp = "";
        int cont=0;
        String prof = "", oldprof = "";
        long tot = 0;
        double porc = 0.0;
        int totalgeral = 0;
        String oldnome = "";
        int totalgeral2 = 0;
        double media = 0;
        int contaprof = 0;
        
        try {
            
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            ResultSet rs = null;
            
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            resp += "<tr>\n";
            resp += "  <td class='tblrel' style='background-color:#CACACA'><b>Profissional</b></td>\n";
            resp += "  <td class='tblrel' style='background-color:#CACACA; text-align:center'><b>Total de Pacientes</b></td>\n";
            resp += "  <td class='tblrel' style='background-color:#CACACA; text-align:center'><b>Pacientes Fiéis</b></td>\n";
            resp += "  <td class='tblrel' style='background-color:#CACACA; text-align:center'><b>%</b></td>\n";
            resp += "</tr>\n";
            
            //Adiciona cabeçalho ao retorno
            retorno.add(resp);
            
            //Cria looping com a resposta
            while(rs.next()) {
                
                prof = rs.getString("prof_reg");
                
                if(!oldprof.equals("") && !oldprof.equals(prof)) {
                    
                    tot = getTotalConsultasProfissional(oldprof, de, ate, grupoproced, cod_empresa);
                    porc = Util.arredondar((cont * 100.0) / tot, 1, 1);
                    media = media + porc;
                    contaprof++;
                    
                    resp += "<tr>\n";
                    resp += "  <td class='tblrel'>" + oldnome + "</td>\n";
                    resp += "  <td class='tblrel' style='text-align:center'>" + tot + "</td>\n";
                    resp += "  <td class='tblrel' style='text-align:center'>" + cont + "</td>\n";
                    resp += "  <td class='tblrel' style='text-align:center'>" + porc + "</td>\n";
                    resp += "</tr>\n";
                    
                    //Adiciona cada linha ao retorno
                    retorno.add(resp);
                    
                    totalgeral += cont;
                    totalgeral2 += tot;
                    cont=0;
                }
                
                resp = "";
                cont++;
                
                oldprof = prof;
                oldnome = rs.getString("profissional.nome");
            }
            
            tot = getTotalConsultasProfissional(oldprof, de, ate, grupoproced, cod_empresa);
            porc = Util.arredondar((cont * 100.0) / tot, 1, 1);
            media = media + porc;
            contaprof++;
            media = Util.arredondar(media / contaprof,1,1);
            
            resp  = "";
            resp += "<tr>\n";
            resp += "  <td class='tblrel'>" + oldnome + "</td>\n";
            resp += "  <td class='tblrel' style='text-align:center'>" + tot + "</td>\n";
            resp += "  <td class='tblrel' style='text-align:center'>" + cont + "</td>\n";
            resp += "  <td class='tblrel' style='text-align:center'>" + porc + "</td>\n";
            resp += "</tr>\n";
            
            //Adiciona cada linha ao retorno
            retorno.add(resp);
            
            //Soma o último item
            totalgeral += cont;
            totalgeral2 += tot;
            
            resp = "";
            resp += "<tr>\n";
            resp += "  <td class='tblrel' style='background-color:#CACACA'><b>Totais....:</b></td>\n";
            resp += "  <td class='tblrel' style='background-color:#CACACA; text-align:center'><b>" + totalgeral2 + "</b></td>\n";
            resp += "  <td class='tblrel' style='background-color:#CACACA; text-align:center'><b>" + totalgeral + "</b></td>\n";
            resp += "  <td class='tblrel' style='background-color:#CACACA; text-align:center'><b>" + media + "</b></td>\n";
            resp += "</tr>\n";
            
            //Adiciona cada linha ao retorno
            retorno.add(resp);
            
            rs.close();
            stmt.close();
            
            return retorno;
        } catch(SQLException e) {
            retorno.add(e.toString() + "<br>" + sql);
            return retorno;
        }
    }
    
    //Captura o total de consultas reallizadas pelo profissional
    private long getTotalConsultasProfissional(String prof_reg, String  de, String ate, String grupoproced, String cod_empresa) {
        
        long cont=0;
        
        //Monta sql para consulta
        String sql = "";
        
        sql += "SELECT faturas.codcli, faturas.prof_reg ";
        sql += "FROM (faturas_itens INNER JOIN procedimentos ON ";
        sql += "faturas_itens.Cod_Proced=procedimentos.COD_PROCED) ";
        sql += "INNER JOIN faturas ON faturas_itens.Numero=faturas.Numero ";
        sql += "WHERE procedimentos.cod_empresa=" + cod_empresa;
        sql += " AND faturas.prof_reg='" + prof_reg + "'";
        
        //Se não selecionou grupo de procedimento, pegar todos
        if(grupoproced.equals("todos")) {
            
            sql += " AND procedimentos.grupoproced <> -99";
            
        }
        //Se escolheu o grupo de procedimentos, filtra
        else  {
            
            sql += " AND procedimentos.grupoproced = " + grupoproced;
        }
        
        //Se veio data de e atê, colocar intervalo
        if(!Util.isNull(de))  sql += " AND faturas.Data_Lanca >= '" + de + "'";
        if(!Util.isNull(ate)) sql += " AND faturas.Data_Lanca <= '" + ate + "'";
        
        sql += " GROUP BY faturas.codcli, faturas.prof_reg ";
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            ResultSet rs = null;
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            //Cria looping com a resposta
            while(rs.next()) {
                cont++;
            }
            rs.close();
            stmt.close();
            
            return cont;
        } catch(SQLException e) {
            return -1;
        }
    }
    
    public String getRelIndicacoes(String de, String ate, String cod_empresa) {
        String resp = "";
        de  = Util.formataDataInvertida(de);
        ate = Util.formataDataInvertida(ate);
        String sql =  "SELECT * FROM indicacoes ORDER BY indicacao";
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

            resp += "<tr>";
            resp += "  <td class='tdMedium'>Indicação</td>\n";
            resp += "  <td class='tdMedium' style='text-align:center'>Quantidade</td>\n";
            resp += "  <td class='tdMedium' style='text-align:center'>Porcentagem</td>\n";
            resp += "</tr>\n";
            
            //Calcula o total de cadastros no intervalo de pesquisa
            sql = "SELECT COUNT(*) FROM paciente WHERE data_abertura_registro BETWEEN '" + de + "' AND '" + ate + "'"; 
            rs2 = stmt2.executeQuery(sql);
            int total = 0;
            double porc = 0;
            if(rs2.next())total = rs2.getInt(1);
            
            //Cria looping com a resposta
            while(rs.next()) {

               stmt2 = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);

               sql  = "SELECT COUNT(*) FROM paciente WHERE data_abertura_registro BETWEEN '" + de + "' AND '" + ate + "'"; 
               sql += " AND indicacao=" + rs.getString("cod_indicacao"); 
               rs2 = stmt2.executeQuery(sql);
               if(rs2.next()) {
                    if(total > 0) //Não existe divisão por zero
                        porc = Util.arredondar((double)((100*rs2.getInt(1))/total),2,1);
                    else    
                        porc = 0;
                    resp += "<tr>";
                    resp += "  <td class='tdLight'>" + rs.getString("indicacao") + "</td>\n";
                    resp += "  <td class='tdLight' style='text-align:center'>" + rs2.getString(1) + "</td>\n";
                    resp += "  <td class='tdLight' style='text-align:center'>" + porc + "%</td>\n";
                    resp += "</tr>\n";
               }

            }

            //Busca os itens que não tem indicação
            sql  = "SELECT COUNT(*) FROM paciente WHERE data_abertura_registro BETWEEN '" + de + "' AND '" + ate + "'"; 
            sql += " AND indicacao IS NULL";
            rs2 = stmt2.executeQuery(sql);
            if(rs2.next()) {
                if(total > 0) //Não existe divisão por zero
                    porc = Util.arredondar((double)((100*rs2.getInt(1))/total),2,1);
                else    
                    porc = 0;
                resp += "<tr>";
                resp += "  <td class='tdLight'>Sem indicação (Cadastro Rápido)</td>\n";
                resp += "  <td class='tdLight' style='text-align:center'>" + rs2.getString(1) + "</td>\n";
                resp += "  <td class='tdLight' style='text-align:center'>" + porc + "%</td>\n";
                resp += "</tr>\n";
            }

            rs2.close();
            stmt2.close();

            resp += "<tr>";
            resp += "  <td class='tdMedium'>Totais</td>\n";
            resp += "  <td class='tdMedium' style='text-align:center'>" + total + "</td>\n";
            resp += "  <td class='tdMedium' style='text-align:center'>100%</td>\n";
            resp += "</tr>\n";

        }
        catch(SQLException e) {
            resp = "Erro: " + e.toString() + " Sql:" + sql;
        }
        return resp;
    }

    public String getRelIndicacoesOutros(String de, String ate, String cod_empresa) {
        String resp = "";
        String sql = "";
        de  = Util.formataDataInvertida(de);
        ate = Util.formataDataInvertida(ate);

        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            ResultSet rs = null;

            resp += "<tr>";
            resp += "  <td class='tdMedium'>Indicação</td>\n";
            resp += "  <td class='tdMedium' style='text-align:center'>Quantidade</td>\n";
            resp += "</tr>\n";
            
            //Busca as indicações Distintas
            sql  = "SELECT COUNT(indicado_por), indicado_por FROM paciente WHERE data_abertura_registro BETWEEN '" + de;
            sql += "' AND '" + ate + "' AND indicado_por <> '' GROUP BY indicado_por ORDER BY 1 DESC"; 
            rs = stmt.executeQuery(sql);
            
            //Cria looping com a resposta
            while(rs.next()) {

                resp += "<tr>";
                resp += "  <td class='tdLight'>" + rs.getString("indicado_por") + "</td>\n";
                resp += "  <td class='tdLight' style='text-align:center'>" + rs.getString(1) + "</td>\n";
                resp += "</tr>\n";

            }
            rs.close();
            stmt.close();
            
        }
        catch(SQLException e) {
            resp = "Erro: " + e.toString() + " Sql:" + sql;
        }
        return resp;
    }

   //Relatório de Valores
    public Vector getRelValores(String cod_convenio, String cod_empresa) {
        //Retorno dos dados
        Vector retorno = new Vector();
        
        //Monta sql para consulta
        String sql = "";
        sql += "SELECT DISTINCT(convenio.cod_convenio), descr_convenio, Indice_CH, valor_SADT, retorno_consulta ";
        sql += "FROM convenio INNER JOIN planos ON ";
        sql += "convenio.cod_convenio = planos.cod_convenio ";
        sql += "WHERE convenio.ativo='S' ";
        
        //Se escolheu um convênio, filtrar
        if(!cod_convenio.equals("todos"))
            sql += "AND convenio.cod_convenio=" + cod_convenio + " ";
        
        sql += "ORDER BY descr_convenio";

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
                resp = "<br>";
                resp += "<table width='100%' border='0' cellpadding='0' cellspacing='0'>\n";
                resp += "<tr>\n";
                resp += "   <td class='tblrel' style='background-color:black; color:white'> <b>" + rs.getString("descr_convenio").toUpperCase() + "</b></td>\n";
                resp += "   <td width=80 class='tblrel' style='background-color:black; color:white'> Valor CH: </td>\n";
                resp += "   <td width=80 class='tblrel' style='background-color:black; color:white'>" + Util.trataNulo(rs.getString("Indice_CH"), "N/C") + "</td>\n";
                resp += "   <td width=80 class='tblrel' style='background-color:black; color:white'> CH p/SADT: </td>\n";
                resp += "   <td width=80 class='tblrel' style='background-color:black; color:white'>" + Util.trataNulo(rs.getString("valor_SADT"),"N/C") + "</td>\n";
                resp += "   <td width=80 class='tblrel' style='background-color:black; color:white'> Retorno:</td>\n";
                resp += "   <td width=80 class='tblrel' style='background-color:black; color:white'>" + Util.trataNulo(rs.getString("retorno_consulta"), "N/C") + "</td>\n";
                resp += "</tr>\n";
                resp += "</table>\n";
                
                resp += getRelPlanosConvenio(rs.getString("cod_convenio"));
                
                //Adiciona cada linha ao retorno
                retorno.add(resp);
            }
            
            rs.close();
            stmt.close();
            
            return retorno;
        } catch(SQLException e) {
            retorno.add("ERRO: " + e.toString() + " SQL: " + sql);
            return retorno;
        }
    }
    
    //Recupera os planos de um determinado convênio
    public String getRelPlanosConvenio(String cod_convenio){
        String resp = "";
        String  sql = "";
        ResultSet rs = null;
        sql = "SELECT * FROM planos WHERE cod_convenio=" + cod_convenio;
        sql += " ORDER BY plano";
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
                  
            rs = stmt.executeQuery(sql);
            
            resp = "<table cellspacing=0 cellpadding=0 width='100%'>\n";
            
            //se achou o paciente, pegar dados
            while(rs.next()) {
                resp += "<tr>\n";
                resp += "  <td class='tblrel' style='background-color:#DDDDDD'><b>Plano: " + rs.getString("plano").toUpperCase() + "</b></td>\n";
                resp += "</tr>\n";
                resp += "<tr>\n";
                resp += "  <td width='100%'>\n";
                resp += getRelProcedimentosPlano(rs.getString("cod_plano"));
                resp += "  </td>\n";
                resp += "</tr>\n";
            }
            
            rs.close();
            resp += "</table>\n";
        }
        catch(SQLException e){
            resp = "ERRO: " + e.toString() + " SQL: " + sql;
        }
        return resp;        
    }

    //Recupera os planos de um determinado convênio
    public String getRelProcedimentosPlano(String cod_plano){
        String resp = "";
        String  sql = "";
        ResultSet rs = null;
        boolean achou = false;

        sql  = "SELECT procedimentos.Procedimento, procedimentos.CODIGO, ";
        sql += "valorprocedimentos.valor FROM procedimentos ";
        sql += "INNER JOIN valorprocedimentos ON procedimentos.COD_PROCED = ";
        sql += "valorprocedimentos.cod_proced ";
        sql += "WHERE valorprocedimentos.cod_plano=" + cod_plano;
        sql += " ORDER BY Procedimento";

        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
                  
            rs = stmt.executeQuery(sql);
            
            resp = "<table cellspacing=0 cellpadding=0 width='100%'>\n";
            resp += "<tr>\n";
            resp += "  <td class='tblrel'><b>Procedimento</b></td>\n";
            resp += "  <td class='tblrel' width='20%'><b>Código</b></td>\n";
            resp += "  <td class='tblrel' width='20%'><b>Valor</b></td>\n";
            resp += "</tr>\n";
            
            //se achou o paciente, pegar dados
            while(rs.next()) {
                resp += "<tr>\n";
                resp += "  <td class='tblrel'>" + rs.getString("Procedimento") + "</td>\n";
                resp += "  <td class='tblrel'>" + rs.getString("CODIGO") + "</td>\n";
                resp += "  <td class='tblrel'>" + Util.formatCurrency(rs.getString("valor")) + "</td>\n";
                resp += "</tr>\n";
                achou = true;
            }
            
            //Se não achou nenhum valor para o plano
            if(!achou) {
                resp += "<tr>\n";
                resp += "<td class='tblrel' colspan=3 align='center'>";
                resp += "Nenhum valor lançado para esse plano";
                resp += "</td></tr>\n";
            }
            rs.close();
            resp += "</table>\n";
        }
        catch(SQLException e){
            resp = "ERRO: " + e.toString() + " SQL: " + sql;
        }
        return resp;        
    }
    
    //Recupera os planos de um determinado convênio
    public String relResumoDiagnosticos(String de, String ate, String cod_diag1, String cod_diag2){
        String resp = "";
        String  sql = "";
        ResultSet rs = null;
        String CID = "";
        
        //Formata as datas
        de = Util.formataDataInvertida(de);
        ate = Util.formataDataInvertida(ate);

        try {
            sql  = "SELECT diagnosticos.CID, diagnosticos.DESCRICAO, diagnosticos.cod_diag, historia.codcli ";
            sql += "FROM (hist_diagnostico INNER JOIN historia ";
            sql += "ON hist_diagnostico.cod_hist = historia.cod_hist) ";
            sql += "INNER JOIN diagnosticos ON hist_diagnostico.cod_diag = diagnosticos.cod_diag ";
            sql += "WHERE historia.DTACON BETWEEN '" + de + "' AND '" + ate + "' ";
            sql += "AND diagnosticos.CID>='" + cod_diag1 + "' AND diagnosticos.CID<='" + cod_diag2 + "' ";
            sql += "GROUP BY diagnosticos.CID, historia.codcli ";
            sql += "ORDER BY diagnosticos.CID";
            
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
                  
            rs = stmt.executeQuery(sql);
            
            resp = "<table cellspacing=0 cellpadding=0 width='500' class='table'>\n";
            resp += "<tr>\n";
            resp += "  <td class='tdMedium'><b>CID</b></td>\n";
            resp += "  <td class='tdMedium'><b>Diagnóstico</b></td>\n";
            resp += "  <td class='tdMedium' width='90'><b>Quantidade</b></td>\n";
            resp += "</tr>\n";
            
            //Vetores de objetos do CID´s
            Vector cids = new Vector();
            
            //Posição do CID
            int pos;
            
            //Objeto do diagnóstico
            ObjDiagnostico diag;
            
            //Se achou o paciente, pegar dados
            while(rs.next()) {
            
                //Pega o CID
                CID = rs.getString("CID");
                
                //Pega posição do CID
                pos = procuraValor(CID, cids); 
                
                //Se não encontrar o CID no vetor, adicionar no vetor e colocar 1 na ocorrência
                if(pos==-1) {
                    cids.add(new ObjDiagnostico(CID, rs.getString("DESCRICAO"), rs.getString("cod_diag"), 1));
                }
                //Se encontrar, aumentar o contador
                else {
                    //Recupera o objeto a alterar
                    diag = (ObjDiagnostico)cids.get(pos);
                    //Incrementa o contador do objeto
                    diag.setContador(diag.getContador()+1);
                    //Devolve o objeto ao vetor
                    cids.set(pos,diag);
                }
            }

            //Varre o vetor para mostrar na tela
            for(int i=0; i<cids.size(); i++) {
                
                //Captura os objetos do vetor
                diag = (ObjDiagnostico)cids.get(i);
                
                resp += "<tr>\n";
                resp += "  <td class='tdLight'><a href=\"Javascript:carregaListaCID('" + diag.getCod_diag() + "')\" title='Mostrar pacientes'>" + diag.getCID() + "</a></td>\n";
                resp += "  <td class='tdLight'>" + diag.getDescricao() + "</td>\n";
                resp += "  <td class='tdLight' align='center'>" + diag.getContador() + "</td>\n";
                resp += "</tr>\n";

            }
            
            //Se não achou nenhum item
            if(cids.size()==0) {
                resp += "<tr>\n";
                resp += " <td class='tblrel' colspan=3 align='center'>";
                resp += " Nenhum registro encontrado";
                resp += " </td></tr>\n";
            }
            rs.close();
            resp += "</table>\n";
        }
        catch(SQLException e){
            resp = "ERRO: " + e.toString() + " SQL: " + sql;
        }
        return resp;        
    }

    //Verifica se uma Diagnóstico pertecen a um Vector, retorna -1 se não achou ou a posição onde achou
    private int procuraValor(String CID, Vector vetor) {
        int resp = -1;
        ObjDiagnostico item;
        
        //Se vetor veio vazio ou o valor, retornar que não achou
        if(Util.isNull(CID) || vetor == null) return resp;
        
        //Varre o vetor procurando o elemento
        for(int i=0; i<vetor.size(); i++) {
            //Pega o item do vetor
            item = (ObjDiagnostico)vetor.get(i);

            //Se achar, troca pega posição e retorna
            if(CID.equalsIgnoreCase(item.getCID())) {
                resp = i;
                i=vetor.size();
            }
        }
        return resp;
    }

    //Relatório de medicamentos ministrados
    public Vector getRelMedicamentos(String de, String ate, String cod_comercial) {
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
            sql  =  "SELECT paciente.codcli, paciente.nome, COUNT(hist_medicamento.cod_hist_med) AS contador ";
            sql += "FROM (historia INNER JOIN hist_medicamento ON historia.cod_hist = hist_medicamento.cod_hist) ";
            sql += "INNER JOIN paciente ON historia.codcli = paciente.codcli ";
            sql += "WHERE historia.DTACON Between '" + de + "' AND '" + ate + "' ";
            sql += "AND hist_medicamento.cod_comercial=" + cod_comercial + " ";
            sql += "GROUP BY paciente.codcli ";
            sql += "ORDER BY paciente.nome";

            //Executa a pesquisa
            rs = stmt.executeQuery(sql);

            //Contadores
            int cont = 0;
            int soma = 0;

            //Pegar as agendas
            while(rs.next()) {

                //troca as cores
                if(cor.equals("#EDF1F8"))
                    cor = "#FFFFFF";
                else
                    cor = "#EDF1F8";
                
                //Contar e acumular
                int contador = rs.getInt("contador");
                cont++;
                soma += contador;

                resp  = "<tr>\n";
                resp += "  <td class='tdLight' style='background-color:" + cor + "'><a title='Ver Histórias' href=\"Javascript:verHistorias(" + rs.getString("codcli") + ")\">" + rs.getString("nome") + "</a></td>\n";
                resp += "  <td class='tdLight' style='background-color:" + cor + "' align='center'>" + contador + "</td>\n";
                resp += "</tr>\n";
                retorno.add(resp);
            }

            resp  = "<tr>\n";
            resp += "  <td class='tdDark'>Total de Pacientes: " + cont + "</td>\n";
            resp += "  <td class='tdDark' align='center'>" + soma + "</td>\n";
            resp += "</tr>\n";
            retorno.add(resp);

            rs.close();
            stmt.close();

        } catch(SQLException e) {
            retorno.add("ERRO: " + e.toString() + " SQL: " + sql);
        }

        return retorno;
    }

    //Relatório de procedimentos executados
    public Vector getRelProcedimentos(String de, String ate, String cod_proced) {
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
            sql  =  "SELECT paciente.codcli, paciente.nome, COUNT(hist_procedimento.cod_hist_proced) AS contador ";
            sql += "FROM (historia INNER JOIN hist_procedimento ON historia.cod_hist = hist_procedimento.cod_hist) ";
            sql += "INNER JOIN paciente ON historia.codcli = paciente.codcli ";
            sql += "WHERE historia.DTACON Between '" + de + "' AND '" + ate + "' ";
            sql += "AND hist_procedimento.cod_proced=" + cod_proced + " ";
            sql += "GROUP BY paciente.codcli ";
            sql += "ORDER BY paciente.nome";

            //Executa a pesquisa
            rs = stmt.executeQuery(sql);

            //Contadores
            int cont = 0;
            int soma = 0;

            //Pegar as agendas
            while(rs.next()) {

                //troca as cores
                if(cor.equals("#EDF1F8"))
                    cor = "#FFFFFF";
                else
                    cor = "#EDF1F8";

                //Contar e acumular
                int contador = rs.getInt("contador");
                cont++;
                soma += contador;

                resp  = "<tr>\n";
                resp += "  <td class='tdLight' style='background-color:" + cor + "'><a title='Ver Histórias' href=\"Javascript:verHistorias(" + rs.getString("codcli") + ")\">" + rs.getString("nome") + "</a></td>\n";
                resp += "  <td class='tdLight' style='background-color:" + cor + "' align='center'>" + contador + "</td>\n";
                resp += "</tr>\n";
                retorno.add(resp);
            }

            resp  = "<tr>\n";
            resp += "  <td class='tdDark'>Total de Pacientes: " + cont + "</td>\n";
            resp += "  <td class='tdDark' align='center'>" + soma + "</td>\n";
            resp += "</tr>\n";
            retorno.add(resp);

            rs.close();
            stmt.close();

        } catch(SQLException e) {
            retorno.add("ERRO: " + e.toString() + " SQL: " + sql);
        }

        return retorno;
    }

    //Relatório de previsão mensal
    public Vector getRelPrevisaoMensal(String datainicio, String datafim) {
        //Retorno dos dados
        Vector retorno = new Vector();
        String sql = "";
        String resp = "", respaux = "";

        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);

            ResultSet rs = null;

            //Formata as datas
            datainicio = Util.formataDataInvertida(datainicio);
            datafim = Util.formataDataInvertida(datafim);

            sql  = "SELECT lotesguias.codLote, lotesguias.tipoGuia, lotesguias.dataRegistroTransacao, ";
            sql += "lotesguias.dataprevisao, convenio.descr_convenio, lotesguias.nf, ";
            sql += "bancos.banco, lotesguias.obs, lotesguias.registroANS ";
            sql += "FROM (convenio LEFT JOIN bancos ON convenio.cod_banco = bancos.cod_banco) ";
            sql += "INNER JOIN lotesguias ON convenio.cod_ans = lotesguias.registroANS ";
            sql += "WHERE dataprevisao BETWEEN '" + datainicio + "' AND '" + datafim + "' ";
            sql += "ORDER BY lotesguias.dataprevisao, lotesguias.registroANS ";
            rs = stmt.executeQuery(sql);

            //Acumuladores
            float soma=0, parcial=0, item=0;

            String operadoradataold = "";
            String operadoradata = "";

             //Looping
            while(rs.next()) {

                //Valor do lote
                item = new Lote().getTotalLote(rs.getString("codLote"));

                //Pega a operadora/data
                operadoradata = rs.getString("registroANS") + rs.getString("dataprevisao");

                resp  = "<tr>\n";
                resp += "  <td class='tblrel' align='center'>" + rs.getString("codLote") + "</td>\n";
                resp += "  <td class='tblrel'>" + new Lote().getTipoGuia(rs.getString("tipoGuia")) + "</td>\n";
                resp += "  <td class='tblrel'>" + Util.formataData(rs.getString("dataRegistroTransacao")) + "</td>\n";
                resp += "  <td class='tblrel'>" + Util.formataData(rs.getString("dataprevisao")) + "</td>\n";
                resp += "  <td class='tblrel'>" + rs.getString("descr_convenio") + "</td>\n";
                resp += "  <td class='tblrel'>" + Util.formatCurrency(item + "") + "</td>\n";
                resp += "  <td class='tblrel'>" + Util.trataNulo(rs.getString("nf"),"N/C") + "</td>\n";
                resp += "  <td class='tblrel'>" + Util.trataNulo(rs.getString("banco"),"Carteira") + "</td>\n";
                resp += "  <td class='tblrel'>" + Util.trataNulo(rs.getString("obs"),"&nbsp;") + "</td>\n";
                resp += "</tr>\n";

                //Se mudou de operadora
                if(!operadoradataold.equals("") && !operadoradataold.equals(operadoradata)) {
                    respaux  = "<tr>\n";
                    respaux += "  <td class='tblrel' style='background-color:#CCCCCC' colspan='5'>";
                    respaux += "<b>Sub-total: </b></td>\n";
                    respaux += "  <td class='tblrel' style='background-color:#CCCCCC' colspan='4'>";
                    respaux += "<b>" + Util.formatCurrency(parcial+"") + "</b></td>\n";
                    respaux += "</tr>\n";
                    retorno.add(respaux);
                    parcial = 0;
                }

                //Acumuladores
                soma += item;
                parcial += item;

                retorno.add(resp);

                //Pega o valor atual
                operadoradataold = operadoradata;
            }

            //Último subtotal
            respaux  = "<tr>\n";
            respaux += "  <td class='tblrel' style='background-color:#CCCCCC' colspan='5'>";
            respaux += "<b>Sub-total: </b></td>\n";
            respaux += "  <td class='tblrel' style='background-color:#CCCCCC' colspan='4'>";
            respaux += "<b>" + Util.formatCurrency(parcial+"") + "</b></td>\n";
            respaux += "</tr>\n";
            retorno.add(respaux);

            resp  = "<tr>\n";
            resp += "  <td class='tblrel' style='background:black; color:white' colspan='5'><b>Total do Período: </b></td>\n";
            resp += "  <td class='tblrel' style='background:black; color:white' colspan='4'><b>" + Util.formatCurrency(soma + "") + "</b></td>\n";
            resp += "</tr>\n";
            retorno.add(resp);
        }
        catch(SQLException e) {
            retorno.add("ERRO: " + e.toString() + " SQL: " + sql);
        }

        return retorno;
    }


    public static void main(String args[]) {
        Relatorio rel = new Relatorio();

        String teste = "";
        
        rel.getPagamentos("01/01/2009","31/12/2009","todos","", "68");
    }
         
}