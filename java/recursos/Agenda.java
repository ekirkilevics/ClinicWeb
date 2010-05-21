/* Arquivo: Agenda.java
 * Autor: Amilton Souza Martha
 * Criação: 27/09/2005   Atualização: 19/05/2009
 * Obs: Manipula as informações da agenda do paciente
 */
package recursos;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.sql.*;
import java.util.*;

public class Agenda {
    //Atributos privados para conexão
    private Connection con = null;
    private Statement stmt = null;

    public Agenda() {
        con = Conecta.getInstance();
    }

    /*
     * dia, mes e ano: data de verificação da agenda
     * codcli: código do paciente para não permitir visualizar agenda de outros
     * cod_proced: código do procedimento a ser analisado (se vir null ou vazio, pegar todos)
     */
    public String montaAgendaPaciente(int dia, int mes, int ano, String codcli, int cod_proced, String cod_empresa) {
        Statement stmt = null;
        String sql = "";
        GregorianCalendar inicio = null;
        String resp = "";
        String consultas = "";

        try {
            //Cria nova Statement para o ponteiro não alterar o anterior
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);

            ResultSet rs = null;

            //Cria uma data para pegar o dia da semana
            inicio = Util.toTime("00:00:00", dia, mes, ano);
            
            //Data para consulta
            String data = Util.formataDataInvertida(Util.formataData(dia, mes, ano));

            //Pega dia da semana para ver os médicos com agenda nesse dia
            int dia_semana = inicio.get(Calendar.DAY_OF_WEEK);

            //Verifica se a data é feriado e não completa o resto
            String feriado = new AgendadoMedico().ehFeriado(inicio);
            if (feriado != null) {
                resp = "<table cellspacing=0 cellpadding=0 class='table' width='98%'><tr>\n";
                resp += "<td class='tdMedium' align='center'>Agenda Bloqueada</td>\n";
                resp += "</tr><tr>\n";
                resp += "<td class='tdLight' align='center'>" + feriado + "</td>\n";
                resp += "</tr></table>\n";
                return resp;
            }

            //Busca os médicos que atendem ao procedimentos naquele dia
            sql = "SELECT DISTINCT(profissional.prof_reg), LEFT(profissional.nome,15) as nome15, profissional.nome, ";
            sql += "agendamedico.hora_inicio, agendamedico.hora_fim, profissional.tempoconsulta ";
            sql += "FROM (prof_esp INNER JOIN profissional ON prof_esp.prof_reg ";
            sql += "= profissional.prof_reg) INNER JOIN (agendamedico INNER ";
            sql += "JOIN agenda_procedimento ON agendamedico.agenda_id = ";
            sql += "agenda_procedimento.agenda_id) ON prof_esp.prof_reg = ";
            sql += "agendamedico.prof_reg ";
            sql += "WHERE profissional.ativo = 'S' AND profissional.exibir = 'S' ";
            sql += "AND agendamedico.dia_semana=" + dia_semana + " ";
            sql += "AND agenda_procedimento.cod_proced=" + cod_proced + " ";
            sql += "AND CONCAT(agendamedico.vigencia, agendamedico.prof_reg) IN (";
            sql += "SELECT CONCAT(MAX(agendamedico.vigencia), agendamedico.prof_reg) ";
            sql += "FROM agendamedico WHERE vigencia <= '" + data + "' GROUP BY prof_reg) ";
            sql += " ORDER BY nome";

            rs = stmt.executeQuery(sql);

            //Início da Tabela
            resp = "<div style='width:480px;height:38px; overflow: auto'>";
            resp += "<table cellspacing=0 cellpadding=0 class='table' width='98%'><tr>\n";

            int contaprofissionais = 0;
            String prof_reg_old = "";
            //Monta uma aba para cada profissional que atende o procedimento no dia
            while (rs.next()) {
                resp += "<td id='cabecalho" + rs.getString("profissional.prof_reg") + "' class='tdMedium' style='padding:0px'><a title='Inserir Encaixe' href=\"Javascript:insereencaixe('" + rs.getString("prof_reg") + "','" + rs.getString("nome") + "')\"6><img src='images/insert.gif' border='0'></a>&nbsp;<a title='" + rs.getString("nome") + "' href=\"Javascript:escolheProfissional('" + rs.getString("prof_reg") + "')\">" + rs.getString("nome15") + "...</a></td>\n";
                contaprofissionais++;
                prof_reg_old = rs.getString("profissional.prof_reg");
            }

            resp += "</tr>\n</table>\n</div>";

            //Se só achou um profissional, colocar o registro em um campo oculto para abrir a aba só dele
            if (contaprofissionais == 1) {
                resp += "<input type='hidden' id='prof_reg_unico' value='" + prof_reg_old + "'>";
            } else {
                resp += "<input type='hidden' id='prof_reg_unico' value=''>";
            }

            //Começa a montar as agendas
            resp += "<table cellspacing=0 cellpadding=0 width='480'><tr><td width='100%'>\n";

            //Volta para o primeiro registro
            rs.beforeFirst();

            //Monta as agendas para cada médico
            while (rs.next()) {
                consultas += getAgendaMedico(rs.getString("profissional.prof_reg"), rs.getString("agendamedico.hora_inicio"), rs.getString("agendamedico.hora_fim"), rs.getInt("tempoconsulta"), dia, mes, ano);
            }

            resp += "</td>\n</tr>\n</table>\n";
        } catch (Exception e) {
            resp = e.toString() + "SQL=" + sql;
        }

        return resp + consultas;
    }

    //Monta a agenda do médico de tanto em tanto tempo de acordo com o seu horário
    private String getAgendaMedico(String prof_reg, String inicioMedico, String fimMedico, int intervalo, int dia, int mes, int ano) {
        String resp = "";

        resp += "<div id='medico" + prof_reg + "' style='display:none'>";
        resp += "<table cellspacing='0' cellpadding='0' class='table' width='100%'>";
        GregorianCalendar gc_iniciomedico, gc_fimmedico;

        //Converte as Strings de horários em objetos GregorianCalendar
        gc_iniciomedico = Util.toTime(inicioMedico, dia, mes, ano);
        gc_fimmedico = Util.toTime(fimMedico, dia, mes, ano);

        //Pega os encaixes antes do horário
        resp += getAgenda(gc_iniciomedico, prof_reg, intervalo, -1);

        //Busca as agendas do profissional de acordo comm o seu intervalo
        while (Util.emMinutos(gc_iniciomedico) <= Util.emMinutos(Util.addMinutos(gc_fimmedico, -intervalo))) {
            resp += getAgenda(gc_iniciomedico, prof_reg, intervalo, 0);
            //Adiciona o intervalo em minutos
            gc_iniciomedico = Util.addMinutos(gc_iniciomedico, intervalo);

        }

        //Pega os encaixes depois do horário
        resp += getAgenda(gc_fimmedico, prof_reg, intervalo, 1);

        resp += "</table></div>";
        return resp;
    }

    //Converte GregoarianCalendar no formato dd/mm/aaaa
    private String toString(GregorianCalendar hora) {
        int h, m;
        String resp, hs = "", ms = "";
        try {
            h = hora.get(Calendar.HOUR_OF_DAY);
            m = hora.get(Calendar.MINUTE);

            if (h < 10) {
                hs = "0";
            }
            if (m < 10) {
                ms = "0";
            }
            resp = hs + h + ":" + ms + m;

            return resp;
        } catch (Exception e) {
            return "Erro na conversão para String: " + e.toString();
        }
    }

    //Converte no formato dd/mm/aaaa
    public String toString(int dia, int mes, int ano) {
        String sd = "", sm = "";

        if (dia < 10) {
            sd = "0";
        }
        if (mes < 10) {
            sm = "0";
        }
        return (sd + dia + "/" + sm + mes + "/" + ano);
    }

    //Devolve o nome do paciente e o procedimento para uma data e para um profissional
    //encaixe  -1=encaixe antes, 0=horário normal, 1=encaixe depois
    public String getAgenda(GregorianCalendar data, String prof_reg, int intervalo, int encaixe) {
        String resp = "", estrutura = "";
        Statement stmt = null;
        String eh_encaixe = "";
        String eh_retorno = "";

        try {

            //Cria nova Statement para o ponteiro não alterar o anterior
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);

            String sql = "";
            ResultSet rs = null;

            sql += "SELECT paciente.nome, paciente.codcli, agendamento.hora, grupoprocedimento.";
            sql += "grupoproced, grupoprocedimento.cod_grupoproced, agendamento.agendamento_id, agendamento.";
            sql += "status, agendamento.cod_plano, agendamento.cod_convenio, convenio.descr_convenio,";
            sql += "paciente.ddd_residencial, paciente.tel_residencial, agendamento.agendamento_id, ";
            sql += "paciente.ddd_celular, paciente.tel_celular, agendamento.encaixe, agendamento.retorno, ";
            sql += "paciente.ddd_comercial, paciente.tel_comercial, grupoprocedimento.cor ";
            sql += "FROM grupoprocedimento ";
            sql += "INNER JOIN ((paciente INNER JOIN agendamento ON ";
            sql += "paciente.codcli = agendamento.codcli) INNER JOIN ";
            sql += "convenio ON agendamento.cod_convenio = convenio.cod_convenio)";
            sql += " ON grupoprocedimento.cod_grupoproced = agendamento.";
            sql += "cod_proced ";
            sql += "WHERE agendamento.ativo='S' AND agendamento.data='" + formataDataBusca(data) + "' ";
            sql += "AND agendamento.prof_reg='" + prof_reg + "' ";

            if (encaixe == 0) { //Sem encaixe, horário normal
                sql += "AND hora >='" + toString(data) + "' ";
                sql += "AND hora <'" + toString(Util.addMinutos(data, intervalo)) + "' ";
            } else if (encaixe == -1) { //Encaixe antes do horário
                sql += "AND hora < '" + toString(data) + "' ";
            } else { //Encaixe depois do horário
                sql += "AND hora >='" + toString(data) + "' ";
            }

            sql += " ORDER BY hora";

            rs = stmt.executeQuery(sql);

            String agendar = "";
            String fones = "";
            boolean achou = false;
            String cor = "", corproced = "";

            //Looping com os horários encontrados (inclusive encaixes)
            while (rs.next()) {

                eh_encaixe = Util.trataNulo(rs.getString("encaixe"), "N");
                eh_retorno = Util.trataNulo(rs.getString("retorno"), "N");
                corproced = rs.getString("cor");

                fones = "<div style=background-color:#FF9900 class=texto><b>..:Telefones</b></div>Res: (";
                fones += rs.getString("ddd_residencial") != null ? rs.getString("ddd_residencial") : " ";
                fones += ") ";
                fones += rs.getString("tel_residencial") != null ? rs.getString("tel_residencial") : "";
                fones += "<br>Cel: (";
                fones += rs.getString("ddd_celular") != null ? rs.getString("ddd_celular") : " ";
                fones += ") ";
                fones += rs.getString("tel_celular") != null ? rs.getString("tel_celular") : " ";
                fones += "<br>Com: (";
                fones += rs.getString("ddd_comercial") != null ? rs.getString("ddd_comercial") : " ";
                fones += ") ";
                fones += rs.getString("tel_comercial") != null ? rs.getString("tel_comercial") : " ";

                resp = " <a onMouseover=\"ddrivetip('" + fones + "<br>" + "<div style=background-color:#FF9900 class=texto><b>..:Agendas Anteriores</b></div>" + getAgendasAnteriores(rs.getString("codcli"), formataDataBusca(data), prof_reg) + "', 250)\" onMouseout=\"hideddrivetip()\" href=\"JavaScript:irCadastro(" + rs.getString("codcli") + ")\"'>" + rs.getString("nome") + "</a> ( " + rs.getString("grupoproced") + " - " + rs.getString("convenio.descr_convenio") + " )";

                //Coloca botão para excluir agendamento
                agendar = "<a href=\"Javascript:excluiragenda(" + rs.getString("agendamento_id") + ",'" + prof_reg + "')\" title='Excluir Agendamento'><img src='images/delete.gif' style='width:12px; height:13px; border: 1px solid #000000'></a>";

                //Coloca status do atendimento (1-Chegou, 3-não chegou)
                agendar += " <a id='status" + rs.getString("agendamento_id") + "' title='Alterar Status' href='Javascript:alteraStatus(" + rs.getString("agendamento_id") + ")'><img id='img" + rs.getString("agendamento_id") + "' src='images/" + rs.getString("status") + ".gif' style='width:13px; height:13px; border: 1px solid #000000'></a>";

                //Coloca ícone para inserir/editar observação
                agendar += " <a title='Observações' href='Javascript: verObs(" + rs.getString("agendamento_id") + "," + rs.getString("codcli") + ")'><img src='images/obs.gif' style='width:13px; height:13px; border: 1px solid #000000'></a>";

                //Coloca o ícone para ir direto ao lançamento financeiro, se ainda não o fez
                if(this.fezLancamentoFinanceiro(rs.getString("agendamento_id")))
                    agendar += " <a title='Lançamento Executado' href=\"Javascript:alert('Lançamento já efetuado')\"><img src='images/moeda2.gif' style='width:13px; height:13px; border: 1px solid #000000'></a>";
                else
                    agendar += " <a title='Lançar Atendimento' href=\"Javascript: lancarProcedimento('" + formataData(data) + "','" + toString(data) + "','" + rs.getString("cod_grupoproced") + "','" + rs.getString("paciente.nome") + "','" + rs.getString("codcli") + "','" + prof_reg + "','" + rs.getString("cod_convenio") + "','" + rs.getString("cod_plano") + "'," + rs.getString("agendamento_id") + ")\"><img id='moeda" + rs.getString("agendamento_id") + "' src='images/moeda.gif' style='width:13px; height:13px; border: 1px solid #000000'></a>";

                //Coloca o ícone para reagendar pacientye
                agendar += " <a title='Reagendar Paciente' href=\"Javascript: reagendar(" + rs.getString("agendamento_id") + ")\"><img src='images/27.gif' style='width:13px; height:13px; border: 1px solid #000000'></a>";

                //Se a hora tiver ocupada
                if (toString(data).equals(Util.formataHora(rs.getString("hora")))) {
                    achou = true;
                }
                estrutura += "<tr>";
                estrutura += " <td width='40' class='tdLight' style='background-color:" + corproced + "'>" + Util.formataHora(rs.getString("hora")) + "</td>\n";

                //Verifica se é retorno pra trocar de cor
                if (eh_retorno.equals("S")) {
                    cor = "#FFFF99";
                }
                //Se deu true, é a primeira vez
                else if(Util.primeiraVez(rs.getString("codcli"), formataData(data), true)) {
                    cor = "#CEFFCE";
                }
                else {
                    cor = "white";                
                }
                
                //Se for encaixe, colocar de negrito
                if (eh_encaixe.equals("S")) {
                    estrutura += " <td class='tdLight' style='background-color:" + cor + "; heigth:20px'><b>" + agendar + resp + "</b></td>\n";
                } else {
                    estrutura += " <td class='tdLight' style='background-color:" + cor + "; heigth:20px'>" + agendar + resp + "</td>\n";
                }
                estrutura += "</tr>";
            }

            //Se não achou o registro de agenda e não for hora de encaixe, permitir agendamento
            if (!achou && encaixe == 0) {
                String estruturaaux = "";

                //Verifica se há cancelamento na agenda
                String cancelaAgenda[] = existeCancelamentoAgenda(data, prof_reg);
                if (!Util.isNull(cancelaAgenda[1])) {
                    estruturaaux += "<tr>";
                    estruturaaux += " <td width='40' class='tdLight'>" + toString(data) + "</td>\n";
                    
                    //Se for hora de almoço, não permite desbloquear
                    if(cancelaAgenda[0].equalsIgnoreCase("almoco"))
                        estruturaaux += " <td class='tdLight' style='background-color:#FFFFFF; heigth:20px'><a href=\"Javascript:alert('Não é possível desbloquear horário de almoço.\\nSe precisar agendar, use o encaixe.')\" title='Desbloquear Horário'><img src='images/cadeado.gif' heigth='13' border='0'></a> " + cancelaAgenda[1] + "</td>\n";
                    else
                        estruturaaux += " <td class='tdLight' style='background-color:#FFFFFF; heigth:20px'><a href='Javascript:desbloquearagenda(" + cancelaAgenda[0] + ")' title='Desbloquear Horário'><img src='images/cadeado.gif' heigth='13' border='0'></a> " + cancelaAgenda[1] + "</td>\n";
                    estruturaaux += "</tr>";
                } else {
                    //Ícone para agendar
                    agendar = "<a href=\"Javascript:agendar('" + prof_reg + "','" + toString(data) + "')\" title='Agendar Paciente'><img src='images/agenda.gif' border=0 heigth='13'></a> ";

                    //Ícone para bloquear horário agenda
                    agendar += " <a href=\"Javascript:bloquearagenda('" + prof_reg + "','" + toString(data) + "')\" title='Bloquear Horário'><img src='images/cadeadoaberto.gif' heigth='13' border=0></a> ";

                    //Para montar o horário antes dos encaixes
                    estruturaaux = "<tr>";
                    estruturaaux += " <td width='40' class='tdLight'>" + toString(data) + "</td>\n";
                    estruturaaux += " <td class='tdLight' style='background-color:white; heigth:20px'>" + agendar + "</td>\n";
                    estruturaaux += "</tr>";
                }
                estrutura = estruturaaux + estrutura;
            }

            rs.close();
            stmt.close();


            return estrutura;
        } catch (SQLException e) {
            return e.toString();
        }

    }

    //Verifica se a agenda já tem lançamento financeiro e retorna a imagem correspondente
    private boolean fezLancamentoFinanceiro(String agenda_id) {
        boolean resp = false;

        try {

            //Cria nova Statement para o ponteiro não alterar o anterior
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);

            String sql = "";
            ResultSet rs = null;

            //Busca o registro
            sql = "SELECT faturas.Numero ";
            sql += "FROM (agendamento INNER JOIN (faturas_itens INNER JOIN faturas ON ";
            sql += "faturas_itens.Numero = faturas.Numero) ON (faturas.Data_Lanca = agendamento.data) ";
            sql += "AND (agendamento.codcli = faturas.codcli)) INNER JOIN procedimentos ON ";
            sql += "(agendamento.cod_proced = procedimentos.grupoproced) AND ";
            sql += "(faturas_itens.Cod_Proced = procedimentos.COD_PROCED) ";
            sql += "WHERE agendamento.agendamento_id=" + agenda_id;
            rs = stmt.executeQuery(sql);

            //Se achou, tem lançamento, senão, precisa fazer
            if(rs.next())
                resp = true;
            else
                resp = false;
        }
        catch(SQLException e) {
            e.printStackTrace();
        }

        return resp;
    }

    //Formata uma data GregorianCalendar para aaaa-mm-dd para buscar no banco com SQL
    private String formataDataBusca(GregorianCalendar data) {
        String resp = "";
        int d, m, a;
        d = data.get(Calendar.DATE);
        m = data.get(Calendar.MONTH) + 1;
        a = data.get(Calendar.YEAR);

        resp = a + "-" + m + "-" + d;
        return resp;

    }
    
    //Formata uma data GregorianCalendar para dd/mm/aaaa
    private String formataData(GregorianCalendar data) {
        String resp = "";
        int d, m, a;
        d = data.get(Calendar.DATE);
        m = data.get(Calendar.MONTH) + 1;
        a = data.get(Calendar.YEAR);
        String sd = d < 10 ? "0" + d : "" + d;
        String sm = m < 10 ? "0" + m : "" + m;
        String sa = "" + a;

        resp = sd + "/" + sm + "/" + sa;
        return resp;

    }
    
    //Monta as linhas da Agenda para o FRAME
    public String montaAgendaMedicoFrame(String prof_reg) {
        String sql =  "";
        String resp = "<table width='100%' cellpadding='0' cellspacing='0' width='100%'>";
        
        try {
            
            //Cria statement para enviar sql
            Statement stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            ResultSet rs = null;
            
            //Busca as agendas para o dia
            sql  = "SELECT paciente.nome, agendamento.hora, paciente.codcli, agendamento.status ";
            sql += "FROM agendamento INNER JOIN paciente ";
            sql += "ON agendamento.codcli = paciente.codcli ";
            sql += "WHERE agendamento.ativo='S' AND agendamento.prof_reg='" + prof_reg + "' AND ";
            sql += "agendamento.data='" + Util.formataDataInvertida(Util.getData()) + "' ";
            sql += "AND agendamento.status <> 9 ";
            sql += "ORDER BY hora";

            rs = stmt.executeQuery(sql);
            
            //Loopiong com as respostas
            while(rs.next()) {
                resp += "<tr>\n";
                resp += " <td class='texto' width='100%' style='color:black; font-size:8px'>";
                resp += " <a title='Atender Paciente' href=\"historicopac.jsp?codcli=" + rs.getString("codcli") + "\" target='mainFrame'>";
                
                //Se não chegou, deixar a cor da hora em vermelho, senão, azul
                if(rs.getString("status").equals("3"))
                    resp += "<font color='red'>";
                else
                    resp += "<font color='blue'>";
                
                resp += Util.formataHora(rs.getString("hora"));
                resp += "</font>-" + rs.getString("nome") + "</a></td>\n";
                resp += "</tr>\n";
            }
            
            resp += "</table>";
            
            rs.close();
            stmt.close();
            
            return resp;
        } catch(Exception e) {
            return  "ERRO: " + e.toString() + "SQL: " + sql;
        }
    }

    //Monta as linhas da Agenda pelo intervalo de minutos definido em "atendimento"
    public String montaAgendaMedico(int dia, int mes, int ano, String prof_reg, String cod_empresa, String usuario_logado) {
        String sql = "";
        String resp = "<table width='100%' cellpadding='0' cellspacing='0'>";
        GregorianCalendar gc_inicio = null, gc_fim = null;
        String Strinicio = "00:00", Strfim = "00:00";
        int intervalo_consulta = 0;

        try {

            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);

            ResultSet rs = null;

            //Busca intervalo de atendimento para inserir os buracos
            sql = "SELECT tempoconsulta FROM profissional WHERE prof_reg='" + prof_reg + "'";
            rs = stmt.executeQuery(sql);

            if (rs.next()) {
                intervalo_consulta = rs.getInt("tempoconsulta");
            } else {
                intervalo_consulta = 5;
            }

            //Converte formato
            gc_inicio = Util.toTime(Strinicio, dia, mes, ano);
            int dia_semana = gc_inicio.get(Calendar.DAY_OF_WEEK);
            String data = Util.formataDataInvertida(Util.formataData(dia, mes, ano));

            //Busca os horários do médico para a data
            sql = "SELECT hora_inicio, hora_fim FROM agendamedico WHERE ";
            sql += "prof_reg='" + prof_reg + "' AND dia_semana=" + dia_semana + " ";
            sql += "AND agendamedico.vigencia IN (";
            sql += "SELECT MAX(agendamedico.vigencia) ";
            sql += "FROM agendamedico WHERE vigencia <= '" + data;
            sql += "' AND prof_reg='" + prof_reg + "') ";       

            //Executa a pesquisa
            rs = stmt.executeQuery(sql);

            if (rs.next()) {
                Strinicio = rs.getString("hora_inicio");
                Strfim = rs.getString("hora_fim");
            }

            //Converte com o horário de início do médico para o dia
            gc_inicio = Util.toTime(Strinicio, dia, mes, ano);
            gc_fim = Util.toTime(Strfim, dia, mes, ano);

            //Se início e fim forem iguais para a data, parar o processo e retornar
            if (Strinicio.equals(Strfim)) {
                return resp;           
            }
             
            //Pega os encaixes antes do início da agenda
            resp += getAgendaMedico(gc_inicio, prof_reg, intervalo_consulta, -1, usuario_logado);

            //Cria looping com a resposta
            while (Util.emMinutos(gc_inicio) <= Util.emMinutos(Util.addMinutos(gc_fim, -intervalo_consulta))) {

                resp += getAgendaMedico(gc_inicio, prof_reg, intervalo_consulta, 0, usuario_logado);

                //Adiciona o intervalo em minutos
                gc_inicio = Util.addMinutos(gc_inicio, intervalo_consulta);

            }

            //Pega os encaixes depois da agenda
            resp += getAgendaMedico(gc_fim, prof_reg, intervalo_consulta, 1, usuario_logado);

            resp += "</table>";

            rs.close();
            stmt.close();

            return resp;
        } catch (Exception e) {
            return e.toString();
        }
    }

    //Pega a agenda do médico para um dia/hora
    //encaixe  -1=encaixe antes, 0=horário normal, 1=encaixe depois
    //agendapessoal = true, insere agendas pessoas, false, não insere
    public String getAgendaMedico(GregorianCalendar data, String prof_reg, int intervalo, int encaixe) {
        return getAgendaMedico(data, prof_reg, intervalo, encaixe, "");
    }

    public String getAgendaMedico(GregorianCalendar data, String prof_reg, int intervalo, int encaixe, String usuario_logado) {

        String sql = "";
        String resp = "";
        String cor = "", negrito = "";
        ResultSet rs = null;
        boolean achou = false;
        String eh_encaixe = "";
        String eh_retorno = "";

        try {

            //Busca todos os pacientes que estão agendados para essa data e esse profissional
            sql = "SELECT paciente.nome, paciente.codcli, paciente.";
            sql += "data_nascimento, grupoprocedimento.grupoproced, ";
            sql += "agendamento.status, agendamento.hora, agendamento.obs, convenio.";
            sql += "descr_convenio, agendamento.cod_convenio, agendamento.encaixe, agendamento.retorno ";
            sql += "FROM (grupoprocedimento INNER JOIN ";
            sql += "(paciente INNER JOIN agendamento ON paciente.codcli ";
            sql += "= agendamento.codcli) ";
            sql += "ON grupoprocedimento.cod_grupoproced = agendamento.";
            sql += "cod_proced) LEFT JOIN convenio ON ";
            sql += "agendamento.cod_convenio = convenio.cod_convenio ";
            sql += "WHERE agendamento.ativo='S' AND agendamento.prof_reg='" + prof_reg + "' AND ";
            sql += "agendamento.data='" + formataDataBusca(data) + "' ";

            if (encaixe == 0) { //Sem encaixe, horário normal
                sql += "AND hora >='" + toString(data) + "' AND hora <'";
                sql += toString(Util.addMinutos(data, intervalo)) + "'";
            } else if (encaixe == -1) { //Encaixe antes do horário
                sql += "AND hora < '" + toString(data) + "' ";
            } else { //Encaixe depois do horário
                sql += "AND hora >='" + toString(data) + "' ";
            }

            sql += " ORDER BY hora";

            //Executa a pesquisa
            rs = stmt.executeQuery(sql);

            while (rs.next()) {
                eh_encaixe = Util.trataNulo(rs.getString("encaixe"), "N");
                eh_retorno = Util.trataNulo(rs.getString("retorno"), "N");

                //Verifica se é retorno pra trocar de cor
                if (eh_retorno.equals("S")) {
                    cor = "#FFFF99";
                }
                //Se deu true, é a primeira vez
                else if(Util.primeiraVez(rs.getString("codcli"), formataData(data), true)) {
                    cor = "#CEFFCE";
                }
                else {
                    cor = "white";                
                }
                
                //Verifica se é encaixe
                if (eh_encaixe.equals("S")) {
                    negrito = "font-weight: bold";
                } else {
                    negrito = "";
                }
                String nomeconvenio = rs.getString("descr_convenio") != null ? rs.getString("descr_convenio") : "Sem convênio";
                resp += "<tr>\n";
                resp += "  <td class='tdMedium' width='80px' style='background-color:" + cor + ";" + negrito + "'>" + Util.formataHora(rs.getString("hora")) + "</td>\n";
                resp += "  <td class='tdLight' width='100%' style='background-color:" + cor + ";" + negrito + "'><a onMouseover=\"ddrivetip('" + getAgendasAnteriores(rs.getString("codcli"), formataDataBusca(data), prof_reg) + "', 350)\" onMouseout=\"hideddrivetip()\" href=\"Javascript:verHistoricos('" + rs.getString("codcli") + "','" + rs.getString("nome") + "','" + Util.formataData(rs.getString("data_nascimento")) + "','" + rs.getString("cod_convenio") + "','" + rs.getString("descr_convenio") + "')\"><img src='images/" + rs.getString("status") + ".gif' border=0> &nbsp;" + rs.getString("nome") + " ( " + rs.getString("grupoproced") + " - " + nomeconvenio + " ) " + "</a></td>\n";
                resp += "</tr>\n";
                resp += "<tr>\n";
                resp += "  <td class='tdMedium' style='background-color:" + cor + ";" + negrito + "'>OBS:</td>\n";
                resp += "  <td class='tdLight' style='background-color:" + cor + ";" + negrito + "'><pre>" + (rs.getString("obs") != null ? rs.getString("obs") : "&nbsp;") + "</pre>&nbsp;</td>\n";
                resp += "</tr>\n";
                resp += "<tr>\n";
                resp += "  <td colspan=2 height='10px'></td>\n";
                resp += "</tr>\n";
                achou = true;
            }

            //Se é para inserir agendas pessoais no meio da agenda
            if(!Util.isNull(usuario_logado)) {
                resp += this.buscaAgendaPessoal(data, prof_reg, intervalo, usuario_logado, encaixe);
            }

            if (!achou && encaixe == 0) {

                //Verifica se é feriado ou tem cancelamento de agenda
                String cancelaAgenda[] = existeCancelamentoAgenda(data, prof_reg);
                if (!Util.isNull(cancelaAgenda[1])) {
                    resp += "<tr>\n";
                    resp += "  <td class='tdMedium' width='80px' style='background-color:white'>" + toString(data) + "</td>\n";
                    resp += "  <td class='tdLight' width='100%' style='background-color:white'>" + cancelaAgenda[1] + "</td>\n";
                    resp += "</tr>\n";
                } else {
                    resp += "<tr>\n";
                    resp += "  <td class='tdMedium' width='80px' style='background-color:white'>" + toString(data) + "</td>\n";
                    resp += "  <td class='tdLight' width='100%' style='background-color:white'>&nbsp;</td>\n";
                    resp += "</tr>\n";
                }
                resp += "<tr>\n";
                resp += "  <td class='tdMedium' style='background-color:white'>OBS:</td>\n";
                resp += "  <td class='tdLight' style='background-color:white'>&nbsp;</td>\n";
                resp += "</tr>\n";
                resp += "<tr>\n";
                resp += "  <td colspan=2 height='10px'></td>\n";
                resp += "</tr>\n";

            }

            return resp;
        } catch (SQLException ex) {
            return "ERRO: " + ex.toString() + " SQL: " + sql;
        }

    }

    //Busca a agenda pessoal para o médico
    public String buscaAgendaPessoal(GregorianCalendar data, String prof_reg, int intervalo, String usuario_logado, int encaixe) {
        String resp = "", sql = "";

        try {
            //Cria statement para enviar sql
            Statement stmt2 = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);

            //Verifica se existe algum cancelamento de agenda nessa data e nesse horário
            sql += "SELECT agendapessoal.hora, agendapessoal.descricao ";
            sql += "FROM t_usuario INNER JOIN agendapessoal ON ";
            sql += "t_usuario.cd_usuario = agendapessoal.cd_usuario ";
            sql += "WHERE t_usuario.prof_reg='" + prof_reg + "' AND t_usuario.cd_usuario=" + usuario_logado;
            sql += " AND data='" + formataDataBusca(data) + "' ";
            if (encaixe == 0) { //Sem encaixe, horário normal
                sql += "AND hora >='" + toString(data) + "' AND hora <'";
                sql += toString(Util.addMinutos(data, intervalo)) + "'";
            } else if (encaixe == -1) { //Encaixe antes do horário
                sql += "AND hora < '" + toString(data) + "' ";
            } else { //Encaixe depois do horário
                sql += "AND hora >='" + toString(data) + "' ";
            }

            ResultSet rs = null;

            rs = stmt2.executeQuery(sql);

            while (rs.next()) {
                resp += "<tr>\n";
                resp += "  <td class='tdMedium' width='80px' style='background-color:white'>" + Util.formataHora(rs.getString("hora")) + "</td>\n";
                resp += "  <td class='tdLight' width='100%' style='background-color:white'><img src='images/17.gif'>&nbsp; " + rs.getString("descricao") + "</td>\n";
                resp += "</tr>\n";
                resp += "<tr>\n";
                resp += "  <td class='tdMedium' style='background-color:white'>OBS:</td>\n";
                resp += "  <td class='tdLight' style='background-color:white'>&nbsp;</td>\n";
                resp += "</tr>\n";
                resp += "<tr>\n";
                resp += "  <td colspan=2 height='10px'></td>\n";
                resp += "</tr>\n";
            }

            rs.close();
            stmt2.close();
        } catch (SQLException e) {
            resp = "ERRO: " + e.toString() + " SQL: " + sql;
        }

        return resp;

    }

    //Verifica se um dia e horário existe cancelamento de agenda
    //Devolve:  resp[0]: cód. feriado
    //          resp[1]: descrição
    public String[] existeCancelamentoAgenda(GregorianCalendar data, String prof_reg) {
        String resp[] = {"", ""}, sql = "";
        String hora = toString(data);

        try {
            //Cria statement para enviar sql
            Statement stmt2 = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);

            //Verifica se existe algum cancelamento de agenda nessa data e nesse horário
            sql += "SELECT cod_feriado, descricao FROM feriados WHERE ";
            sql += "(prof_reg='" + prof_reg + "' AND dataInicio<='" + formataDataBusca(data) + "' AND dataFim>='" + formataDataBusca(data) + "' AND definitivo='N' AND diatodo='S') OR ";
            sql += "(prof_reg='" + prof_reg + "' AND dataInicio<='" + formataDataBusca(data) + "' AND dataFim>='" + formataDataBusca(data) + "' AND hora_inicio <= '" + hora + "' AND hora_fim >= '" + hora + "' AND definitivo='N' AND diatodo='N') OR ";
            sql += "(prof_reg='" + prof_reg + "' AND DAY(datainicio)=" + data.get(Calendar.DATE) + " AND MONTH(datainicio)=" + (data.get(Calendar.MONTH) + 1) + " AND definitivo='S' AND diatodo='S') OR ";
            sql += "(prof_reg='" + prof_reg + "' AND DAY(datainicio)=" + data.get(Calendar.DATE) + " AND MONTH(datainicio)=" + (data.get(Calendar.MONTH) + 1) + " AND hora_inicio <= '" + hora + "' AND hora_fim >= '" + hora + "' AND definitivo='S' AND diatodo='N') OR ";
            sql += "(prof_reg='todos' AND DAY(datainicio)=" + data.get(Calendar.DATE) + " AND MONTH(datainicio)=" + (data.get(Calendar.MONTH) + 1) + " AND hora_inicio <= '" + hora + "' AND hora_fim >= '" + hora + "' AND definitivo='S' AND diatodo='N') OR ";
            sql += "(prof_reg='todos' AND dataInicio<='" + formataDataBusca(data) + "' AND dataFim>='" + formataDataBusca(data) + "' AND hora_inicio <= '" + hora + "' AND hora_fim >= '" + hora + "' AND definitivo='N' AND diatodo='N')";

            ResultSet rs = null;

            rs = stmt2.executeQuery(sql);

            if (rs.next()) {
                resp[0] = rs.getString("cod_feriado");
                resp[1] = "<font color='red'>" + rs.getString("descricao") + "</font>";
            }

            //Se não achou feriado, verificar se é horário de almoço
            else {
                int dia_semana = data.get(Calendar.DAY_OF_WEEK);
                sql  = "SELECT * FROM agendamedico WHERE dia_semana=" + dia_semana;
                sql += " AND inicio_almoco <= '" + hora + "' AND fim_almoco >'" + hora + "' ";
                sql += "AND prof_reg='" + prof_reg + "' ";
                sql += "AND agendamedico.vigencia IN (";
                sql += "SELECT MAX(agendamedico.vigencia) ";
                sql += "FROM agendamedico WHERE vigencia <= '" + formataDataBusca(data);
                sql += "' AND prof_reg='" + prof_reg + "') ";

                rs = stmt2.executeQuery(sql);
                //Se achou, horário de almoço
                if(rs.next()) {
                    resp[0] = "almoco";
                    resp[1] = "<font color='red'>Horário de Almoço</font>";
                }
            }

            rs.close();
            stmt2.close();
        } catch (SQLException e) {
            resp[1] = "ERRO: " + e.toString() + " SQL: " + sql;
        }

        return resp;

    }

    /*
     * id da agenda
     */
    public String[] getAgenda(String id) {
        String sql = "";
        String resp[] = {"", "", "", "", "", "", "", "", ""};

        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);

            sql += "SELECT paciente.nome, paciente.email, paciente.ddd_celular, ";
            sql += "paciente.tel_celular, profissional.nome, ";
            sql += "profissional.email, grupoprocedimento.grupoproced, ";
            sql += "agendamento.data, agendamento.hora ";
            sql += "FROM grupoprocedimento INNER JOIN ((paciente INNER ";
            sql += "JOIN agendamento ON paciente.codcli = ";
            sql += "agendamento.codcli) INNER JOIN profissional ";
            sql += "ON agendamento.prof_reg = profissional.prof_reg";
            sql += ") ON grupoprocedimento.cod_grupoproced = agendamento.cod_proced ";
            sql += "WHERE agendamento.agendamento_id=" + id;

            ResultSet rs = null;

            rs = stmt.executeQuery(sql);

            if (rs.next()) {
                resp[0] = rs.getString("paciente.nome");
                resp[1] = rs.getString("profissional.nome");
                resp[2] = rs.getString("profissional.email");
                resp[3] = rs.getString("grupoproced");
                resp[4] = rs.getString("data");
                resp[5] = rs.getString("hora");
                resp[6] = rs.getString("paciente.email");
                resp[7] = rs.getString("paciente.ddd_celular");
                resp[8] = rs.getString("paciente.tel_celular");
            }

            rs.close();
            stmt.close();

            return resp;
        } catch (SQLException e) {
            resp[0] = e.toString();
            return resp;
        }
    }

    /*
     * String[0] = Consulta Anterior
     * String[1] = Consulta posterior
     */
    public String[] pegaConsultas(String codcli, String data, String cod_proced) {
        String resp[] = {"", ""};
        Statement stmt = null;
        String sql = "";

        try {
            //Cria nova Statement para o ponteiro não alterar o anterior
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);

            ResultSet rs = null;

            //Pega a última agenda para o paciente
            sql = "SELECT agendamento.data FROM agendamento INNER JOIN ";
            sql += "(procedimentos INNER JOIN grupoprocedimento ON ";
            sql += "procedimentos.grupoproced = grupoprocedimento.cod_grupoproced) ";
            sql += "ON agendamento.cod_proced = grupoprocedimento.cod_grupoproced ";
            //Só pega procedimento de consulta (com possibilidade de retorno)
            sql += "WHERE agendamento.ativo='S' AND procedimentos.tipoGuia=1 AND ";
            //Para o mesmo paciente e com data menor que a atual
            sql += "codcli=" + codcli + " AND agendamento.data < '";
            sql += Util.formataDataInvertida(data) + "' ";
            //Com o mesmo procedimento atual (mesmo tipo de consulta)
            sql += "AND agendamento.cod_proced='" + cod_proced + "' ";
            //Que não tenha faltado na consulta (status=3)
            sql += "AND agendamento.status<>3 ";
            //Que não tenha sido um retorno
            sql += "AND retorno='N' ";
            //Por ordem de data
            sql += "ORDER BY data DESC LIMIT 1";

            rs = stmt.executeQuery(sql);
            if (rs.next()) {
                resp[0] = Util.formataData(rs.getString("data"));
            } else {
                resp[0] = "Primeira vez para esse procedimento";
            }

            //Pega a última agenda para o paciente
            sql = "SELECT agendamento.data FROM agendamento INNER JOIN ";
            sql += "(procedimentos INNER JOIN grupoprocedimento ON ";
            sql += "procedimentos.grupoproced = grupoprocedimento.cod_grupoproced) ";
            sql += "ON agendamento.cod_proced = grupoprocedimento.cod_grupoproced ";
            sql += "WHERE agendamento.ativo='S' AND procedimentos.tipoGuia=1 AND ";
            sql += "codcli=" + codcli + " AND agendamento.data > '";
            sql += Util.formataDataInvertida(data) + "' ";
            sql += "AND agendamento.cod_proced='" + cod_proced + "' ORDER BY data ASC LIMIT 1";

            rs = stmt.executeQuery(sql);
            if (rs.next()) {
                resp[1] = Util.formataData(rs.getString("data"));
            }

            rs.close();
            stmt.close();
            return resp;
        } catch (SQLException e) {
            resp[0] = "ERRO: " + e.toString() + " SQL: " + sql;
            return resp;
        }
    }

    
    /*
     * String[0] = Data da última consulta
     * String[1] = Data a começar a procurar
     */
    public String[] proxData(String codcli, String cod_proced, String cod_plano) {
        String resp[] = {"", ""};
        Statement stmt = null;
        String sql = "";
        
        //Se não veio paciente, não pesquisar data
        if(Util.isNull(codcli)) {
            resp[0] = "Sem paciente";
            resp[1] = Util.getData();
            return resp;
        }

        try {
            //Cria nova Statement para o ponteiro não alterar o anterior
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);

            ResultSet rs = null;

            //Pega a última agenda para o paciente
            sql = "SELECT agendamento.data FROM agendamento INNER JOIN ";
            sql += "(procedimentos INNER JOIN grupoprocedimento ON ";
            sql += "procedimentos.grupoproced = grupoprocedimento.cod_grupoproced) ";
            sql += "ON agendamento.cod_proced = grupoprocedimento.cod_grupoproced ";
            //Só pega procedimento de consulta (com possibilidade de retorno)
            sql += "WHERE agendamento.ativo='S' AND procedimentos.tipoGuia=1 AND ";
            //Para o mesmo paciente e com data menor que a atual
            sql += "codcli=" + codcli + " AND agendamento.data <= '";
            sql += Util.formataDataInvertida(Util.getData()) + "' ";
            //Com o mesmo procedimento atual (mesmo tipo de consulta)
            sql += "AND agendamento.cod_proced='" + cod_proced + "' ";
            //Que não tenha faltado na consulta (status=3)
            sql += "AND agendamento.status<>3 ";
            //Que não tenha sido um retorno
            sql += "AND retorno='N' ";
            //Por ordem de data
            sql += "ORDER BY data DESC LIMIT 1";

            rs = stmt.executeQuery(sql);
            if (rs.next()) {
                resp[0] = Util.formataData(rs.getString("data"));
            } else {
                resp[0] = "Primeira vez";
            }

            //Pega os dias para retorno do convênio
            sql = "SELECT retorno_consulta FROM convenio WHERE cod_convenio=" + cod_plano.split("@")[0];
            rs = stmt.executeQuery(sql);
            if (rs.next()) {
                int dias = rs.getInt("retorno_consulta");
                //Se não achou data anterior, udar a data atual para pesquisa
                if(resp[0].length() > 10)
                    resp[1] = Util.getData();
                //Se achou data, usar a data anterior acrescida dos dias do retorno
                else {
                    String datanova = Util.addDias(resp[0], dias+2);
                    //Se a datanova for menor que a atual, usar a atual
                    if(Util.getDifDate(datanova, Util.getData()) < 0)
                        resp[1] = datanova;
                    else
                        resp[1] = Util.getData();
                }
            }

            rs.close();
            stmt.close();
            return resp;
        } catch (SQLException e) {
            resp[0] = "ERRO: " + e.toString() + " SQL: " + sql;
            return resp;
        }
    }

    //Busca a observação feita em uma agenda
    public String getObs(String cod_agenda) {
        String sql = "";
        String resp = "";

        try {
            //Cria nova Statement para o ponteiro não alterar o anterior
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);

            ResultSet rs = null;

            //Pega a última agenda para o paciente
            sql += "SELECT obs FROM agendamento WHERE agendamento_id=" + cod_agenda;

            rs = stmt.executeQuery(sql);
            if (rs.next()) {
                resp = rs.getString("obs");
                if (resp == null) {
                    resp = "";
                }
            } else {
                resp = "";
            }

            rs.close();
            stmt.close();
            return resp;
        } catch (SQLException e) {
            resp = e.toString() + sql;
            return resp;
        }
    }
    
    //Busca as 5 agendas anteriores de um paciente
    public String getAgendasAnteriores(String codcli, String data, String prof_reg) {
        String sql = "";
        String resp = "";
        boolean achou = false;

        try {
            //Cria nova Statement para o ponteiro não alterar o anterior
            Statement stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);

            ResultSet rs = null;

            //Pega as últimas 5 agenda para o paciente
            sql = "SELECT status, data, hora, agendamento.prof_reg AS prof_reg, nome FROM agendamento ";
            sql += "INNER JOIN profissional ON (";
            sql += "agendamento.prof_reg=profissional.prof_reg) ";
            sql += "WHERE agendamento.ativo='S' AND codcli=" + codcli;
            sql += " AND data < '" + data + "' ORDER BY data DESC LIMIT 5";

            rs = stmt.executeQuery(sql);
            while (rs.next()) {
                resp += "<img src=images/" + rs.getInt("status") + ".gif> ";
                resp += Util.formataData(rs.getString("data")) + " às " + Util.formataHora(rs.getString("hora"));

                //Se o médico não for o próprio, colocar o nome
                if (!prof_reg.equals(rs.getString("prof_reg"))) {
                    resp += " (" + rs.getString("nome") + ")";
                }
                resp += "<br>";
                achou = true;
            }

            //Se não achou, colocar mensagem
            if (!achou) {
                resp += "Primeira agenda do paciente";
            }

            rs.close();
            stmt.close();
            return resp;
        } catch (SQLException e) {
            resp = e.toString() + sql;
            return resp;
        }
    }

    //Altera a observação de uma agenda
    public String setObs(String cod_agenda, String obs) {
        String sql = "UPDATE agendamento set obs='" + obs + "' WHERE agendamento_id=" + cod_agenda;
        return new Banco().executaSQL(sql);
    }
    
    //Exclui uma agenda
    public String excluirAgenda(String cod_agenda, String cod_usuario) {
        String sql = "";

        //Monta comando para exclusão (alteração de Status)
        sql += "UPDATE agendamento set ativo='N', usuario_exclusao = " + cod_usuario;
        sql += ", data_exclusao='" + Util.formataDataInvertida(Util.getData());
        sql += "', hora_exclusao='" + Util.getHora();
        sql += "' WHERE agendamento_id=" + cod_agenda;

        return new Banco().executaSQL(sql);

    }

    //Busca os procedimentos para um determinado convênio de um grupo de procedimentos escolhido
    public String getProcedimentos(String cod_plano, String cod_grupoproced) {
        String sql = "";
        String resp = "";

        try {
            //Cria nova Statement para o ponteiro não alterar o anterior
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);

            boolean entrou = false;
            ResultSet rs = null;

            //Pega os procedimentos
            sql = "SELECT procedimentos.COD_PROCED, procedimentos.Procedimento, ";
            sql += "valorprocedimentos.valor ";
            sql += "FROM procedimentos INNER JOIN valorprocedimentos ON ";
            sql += "procedimentos.COD_PROCED = valorprocedimentos.cod_proced ";
            sql += "WHERE valorprocedimentos.cod_plano=" + cod_plano;
            sql += " AND procedimentos.grupoproced=" + cod_grupoproced;

            rs = stmt.executeQuery(sql);
            resp += "<table cellspacing=0 cellpadding=0 width='100%'>\n";
            while (rs.next()) {
                resp += "<tr onClick=\"escolheProcedimento('" + rs.getString("COD_PROCED") + "','" + rs.getString("Procedimento") + "','" + rs.getString("valor") + "')\" onMouseOver='trocaCor(this,1);' onMouseOut='trocaCor(this,2);'>";
                resp += "<td class='tdLight'>";
                resp += rs.getString("Procedimento");
                resp += "</td></tr>\n";
                entrou = true;
            }

            //Se veio vazio, exibir mensagem
            if (!entrou) {
                resp += "<tr>";
                resp += "  <td class='tdMedium' width='100%'>Dados Incompletos</td>";
                resp += "</tr>";
                resp += "<tr>";
                resp += "  <td class='tdLight'>Falta informações para o lançamento. Valor do procedimento ou vínculo ao grupo está faltando</td>";
                resp += "</tr>";
            }

            resp += "</table>";
            rs.close();
            stmt.close();
            return resp;
        } catch (SQLException e) {
            resp = "ERRO: " + e.toString() + " SQL: " + sql;
            return resp;
        }
    }
    /* resp[0] = descrição do convênio (plano)
     * resp[1] = dias de retorno
     */

    public String[] getDadosConvenio(String cod_convenio) {
        String sql = "";
        String resp[] = {"", ""};

        try {
            //Cria nova Statement para o ponteiro não alterar o anterior
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);

            ResultSet rs = null;

            //Pega os procedimentos
            sql = "SELECT convenio.retorno_consulta, convenio.descr_convenio ";
            sql += "FROM convenio WHERE cod_convenio=" + cod_convenio;

            rs = stmt.executeQuery(sql);

            if (rs.next()) {
                resp[0] = rs.getString("descr_convenio");
                resp[1] = rs.getString("retorno_consulta");
            } else {
                resp[0] = "Não encontrado!";
                resp[1] = "N/C";
            }

            rs.close();
            stmt.close();
            return resp;
        } catch (SQLException e) {
            resp[0] = "ERRO: " + e.toString() + " SQL: " + sql;
            return resp;
        }
    }
    //Recebe uma data e devolve ela adicionada em dias com um valor
    public int[] navegaData(int dia, int mes, int ano, int qtde) {
        int resp[] = null;
        try {
            resp = new int[3];
            GregorianCalendar data = new GregorianCalendar(ano, mes - 1, dia);
            data.add(GregorianCalendar.DATE, qtde);
            resp[0] = data.get(Calendar.DATE);
            resp[1] = data.get(Calendar.MONTH) + 1;
            resp[2] = data.get(Calendar.YEAR);
        } catch (Exception e) {
        }
        return resp;

    }
    //Traz as próximas agendas baseados em um filtro
    public String getProximasAgendas(String[] diassemana, String data, String prof_reg, String manha, String tarde, String cod_proced, String cod_empresa) {
        String sql = "";
        String resp = "";
        String prof_reg_local = "";
        try {

            //Cria nova Statement para o ponteiro não alterar o anterior
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);

            ResultSet rs = null;

            //Cria uma data para pegar o dia da semana
            GregorianCalendar inicio = Util.toTime("00:00:00", Integer.parseInt(Util.getDia(data)), Integer.parseInt(Util.getMes(data)), Integer.parseInt(Util.getAno(data)));

            //Pega dia da semana para ver os médicos com agenda nesse dia
            int dia_semana = inicio.get(Calendar.DAY_OF_WEEK);

            //Busca os médicos que atendem naquele dia
            sql = "SELECT prof_reg, nome, LEFT(profissional.nome,15) AS nome15, tempoconsulta ";
            sql += "FROM profissional ";
            sql += "WHERE profissional.ativo = 'S' AND profissional.exibir = 'S' AND locacao='interno' ";
            sql += "AND cod_empresa=" + cod_empresa;

            //Se veio médico, filtrar
            if (!Util.isNull(prof_reg) && !prof_reg.equals("todos")) {
                sql += " AND profissional.prof_reg='" + prof_reg + "' ";
            }
            
            sql += " ORDER BY nome";
            
            rs = stmt.executeQuery(sql);

            //Início da Tabela
            resp = "<div style='width:380px;height:38px; overflow: auto'>\n";
            resp += "<table cellspacing=0 cellpadding=0 class='table' width='98%'>\n<tr>\n";

            while (rs.next()) {
                resp += "<td id='cabecalho" + rs.getString("profissional.prof_reg") + "' class='tdMedium' style='padding:0px'>&nbsp; <a title='" + rs.getString("nome") + "' href=\"Javascript:escolheProfissional('" + rs.getString("prof_reg") + "')\">" + rs.getString("nome15") + "...</a></td>\n";
            }
            resp += "</tr>\n</table>\n</div>\n";

            //Volta para o começo do rs
            rs.beforeFirst();
            while (rs.next()) {
                prof_reg_local = rs.getString("prof_reg");
                resp += "<div id='medico" + prof_reg_local + "' style='display:none'>\n";
                resp += "<table cellspacing='0' cellpadding='0' border='0' class='table'>\n";
                resp += getAgendaLivreMedico(diassemana, data, prof_reg_local, manha, tarde, cod_proced, rs.getInt("tempoconsulta"), 0, 0);
                resp += "</table>\n</div>\n";
            }
        } catch (SQLException e) {
            resp = "ERRO: " + e.toString() + " SQL: " + sql;
        }

        return resp;
    }
    //Traz as próximas agendas baseados em um filtro
    public String getAgendaLivreMedico(String[] diassemana, String data, String prof_reg, String manha, String tarde, String cod_proced, int intervalo, int cont, int tentativas) {
        String sql = "";
        String resp = "";
        int dia, mes, ano;
        int totaldehorarioslivres = 10;
        int totaltentativas = 100;
        GregorianCalendar gc_iniciomedico, gc_fimmedico;
        String strinicio, strfim;

        try {
            //Separa dia, mês e ano
            dia = Integer.parseInt(Util.getDia(data));
            mes = Integer.parseInt(Util.getMes(data));
            ano = Integer.parseInt(Util.getAno(data));

            //Cria nova Statement para o ponteiro não alterar o anterior
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);

            ResultSet rs = null;

            //Cria uma data para pegar o dia da semana
            GregorianCalendar inicio = Util.toTime("00:00:00", Integer.parseInt(Util.getDia(data)), Integer.parseInt(Util.getMes(data)), Integer.parseInt(Util.getAno(data)));

            //Pega dia da semana para ver os médicos com agenda nesse dia
            int dia_semana = inicio.get(Calendar.DAY_OF_WEEK);

            //Busca se o médico atende nesse dia
            sql = "SELECT agendamedico.hora_inicio, agendamedico.hora_fim ";
            sql += "FROM agenda_procedimento INNER JOIN agendamedico ON ";
            sql += "agenda_procedimento.agenda_id = agendamedico.agenda_id ";
            sql += "WHERE agendamedico.dia_semana=" + dia_semana;
            sql += " AND prof_reg='" + prof_reg + "' ";
            sql += "AND agendamedico.vigencia IN (";
            sql += "SELECT MAX(agendamedico.vigencia) ";
            sql += "FROM agendamedico WHERE vigencia <= '" + Util.formataDataInvertida(data);
            sql += "' AND prof_reg='" + prof_reg + "') ";

            //Se veio procedimento
            if (!Util.isNull(cod_proced)) {
                sql += " AND agenda_procedimento.cod_proced=" + cod_proced;
            }

            rs = stmt.executeQuery(sql);

            //Se atende nesse dia
            if (rs.next()) {
                //Pega os horários de atendimento
                strinicio = rs.getString("hora_inicio");
                strfim = rs.getString("hora_fim");
 
                //Converte as Strings de horários em objetos GregorianCalendar
                gc_iniciomedico = Util.toTime(strinicio, dia, mes, ano);
                gc_fimmedico = Util.toTime(strfim, dia, mes, ano);

                resp = "";
                //Verfica se o horário será processado
                boolean processar = false;
                
                //Monta cabeçalho de horário de meia em meia hora
                while (Util.emMinutos(gc_iniciomedico) < Util.emMinutos(gc_fimmedico) && cont < totaldehorarioslivres) {
                    String ag = "";
                    //Começa considerando que vai processar o horário
                    //Caso entre em alguma regra, não processar
                    processar = true;
                    
                   //Se não escolheu manhã e o horário for manhã, ignorar na lista
                    if (Util.isNull(manha)) {
                        if (Util.emMinutos(gc_iniciomedico) < Util.emMinutos(Util.toTime("12:00", 1, 1, 1))) {
                            processar = false;
                        }
                    }
                    //Se não escolheu tarde, e o horário for tarde, ignorar
                    if (Util.isNull(tarde)) {
                        if (Util.emMinutos(gc_iniciomedico) > Util.emMinutos(Util.toTime("12:00", 1, 1, 1))) {
                            processar = false;
                        }
                    }
                    //Se a hora for menor que a hora atual e a data for hoje, ignorar
                    if(Util.getData().equals(formataData(gc_iniciomedico)) && Util.emMinutos(gc_iniciomedico) < Util.emMinutos(Util.toTime(Util.getHora(), 1, 1, 1))) {
                        processar = false;
                    }

                    //Se não entrou em nenhuma regra
                    if(processar) {
                        //Se o dia da semana está nos escolhidos, fazer a busca
                        if (new Banco().pertence(dia_semana + "", diassemana)) {
                            //Pega a agenda do dia
                            ag = getAgendaLivre(gc_iniciomedico, prof_reg);
                        }

                        //Se veio alguma coisa, contar
                        if (!ag.equals("")) {
                            resp += ag;
                            cont++;
                        }
                    }
                    
                    //Adiciona o intervalo em minutos
                    gc_iniciomedico = Util.addMinutos(gc_iniciomedico, intervalo);
                }

            }

            //Se ainda não completou os horários, buscar dia seguinte
            if (cont < totaldehorarioslivres && tentativas < totaltentativas) {
                //Calcula o dia de amanhã
                GregorianCalendar proxdia = Util.addMinutos(inicio, 24 * 60);
                String strproxdia = this.formataData(proxdia);
                resp += getAgendaLivreMedico(diassemana, strproxdia, prof_reg, manha, tarde, cod_proced, intervalo, cont, tentativas + 1);
            }

            return resp;

        } catch (SQLException e) {
            resp = "ERRO: " + e.toString() + " SQL: " + sql;
        }

        return resp;
    }

    //Devolve as agendas livres do médico na data
    public String getAgendaLivre(GregorianCalendar data, String prof_reg) {
        String  estrutura = "", estruturaaux = "";
        Statement stmt = null;

        try {
            //Verifica se é feriado ou tem cancelamento de agenda
            String cancelaAgenda[] = existeCancelamentoAgenda(data, prof_reg);
            String feriado = new AgendadoMedico().ehFeriado(data);
            if (!Util.isNull(cancelaAgenda[1]) || feriado != null) {
                return "";            
            }
            //Cria nova Statement para o ponteiro não alterar o anterior
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);

            String sql = "";
            ResultSet rs = null;

            //Verifica se existe agendamento para essa hora
            sql += "SELECT * FROM agendamento ";
            sql += "WHERE agendamento.data='" + formataDataBusca(data) + "' ";
            sql += "AND agendamento.prof_reg='" + prof_reg + "' ";
            sql += "AND hora ='" + toString(data) + "' ";
            sql += "AND agendamento.ativo='S'";

            rs = stmt.executeQuery(sql);

            String agendar = "";

            //Se achou, não é livre
            if (rs.next()) {
                //Não faz nada
            } //Se não achou o registro de agenda e não for hora de encaixe, permitir agendamento
            else {
                String data1 = formataData(data);
                //Ícone para agendar
                agendar = "<a href=\"Javascript:agendar(" + Util.getDia(data1) + "," + Util.getMes(data1) + "," + Util.getAno(data1) + ",'" + prof_reg + "','" + toString(data) + "')\" title='Agendar Paciente'><img src='images/agenda.gif' border=0 heigth='13'></a> ";

                //Para montar o horário antes dos encaixes
                estruturaaux = "<tr>";
                estruturaaux += " <td width='100' class='tdLight'>(" + Util.getDiaSemana(data1).substring(0,3) + ") " + data1 + "</td>\n";
                estruturaaux += " <td width='40' class='tdLight'>" + toString(data) + "</td>\n";
                estruturaaux += " <td class='tdLight' style='background-color:white; heigth:20px'>" + agendar + "</td>\n";
                estruturaaux += "</tr>";
            }

            estrutura = estruturaaux + estrutura;
            rs.close();
            stmt.close();


            return estrutura;
        } catch (SQLException e) {
            return e.toString();
        }

    }
    //Recebe o cód. da agenda para enviar os dados para a INDIQ
    public String enviaDadosIndiq(String agendamento_id) {
        String sql = "";
        String resp = "";
        String email, nome, nascimento, sexo, cpf, profissional, crm;

        try {

            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);

            ResultSet rs = null;

            //Busca os dados a serem enviados
            sql = "SELECT paciente.email, paciente.nome, paciente.data_nascimento, ";
            sql += "paciente.cod_sexo, paciente.cic, profissional.nome, profissional.reg_prof ";
            sql += "FROM (agendamento INNER JOIN paciente ON agendamento.codcli = ";
            sql += "paciente.codcli) INNER JOIN profissional ON ";
            sql += "agendamento.prof_reg = profissional.prof_reg ";
            sql += "WHERE agendamento.agendamento_id=" + agendamento_id;
            rs = stmt.executeQuery(sql);

            //Se achou informação, enviar
            if (rs.next()) {
                //Captura os valores da consulta
                email = Util.trataNulo(rs.getString("email"), "");
                nome = Util.trataNulo(rs.getString("paciente.nome"), "");
                nascimento = Util.trataNulo(rs.getString("data_nascimento"), "");
                sexo = Util.trataNulo(rs.getString("cod_sexo"), "");
                cpf = Util.trataNulo(rs.getString("cic"), "");
                //Tira pontos e traços do CPF
                cpf = cpf.replace(".", "");
                cpf = cpf.replace("-", "");
                profissional = Util.trataNulo(rs.getString("profissional.nome"), "");
                crm = Util.trataNulo(rs.getString("reg_prof"), "");

                //Monta URL para responder
                resp = "http://www.indiq.com.br/cad_katu.php?email=" + email + "&nome=" + nome + "&dnasc=" + nascimento;
                resp += "&sexo=" + sexo + "&doc=" + cpf + "&nmedico=" + profissional + "&docm=" + crm;

                //Substitui espaços por %20
                resp = resp.replace(" ", "%20");
                
                //Só envia se o CPF não estiver nulo
                if(!Util.isNull(cpf)) {
                    //Conecta a URL para enviar dados para o portal INDIQ
                    URL url = new URL(resp);
                    HttpURLConnection con = (HttpURLConnection) url.openConnection();
                    BufferedReader br = new BufferedReader(new InputStreamReader(con.getInputStream()));
                    con.disconnect();
                }

                return "OK";

            }
            else
                return "Usuário não encontrado";
        } catch (SQLException e) {
            return "ERRO no banco de dados: " + e.toString() + " SQL: " + sql;
        } catch (MalformedURLException ex) {
            return "Erro no URL: " + ex.toString();
        } catch (IOException ex) {
            return "Erro de entrada e saída: " + ex.toString();
        }
    }

    public static void main(String args[]) {
        Agenda ag = new Agenda();
        String teste;


        teste = ag.montaAgendaMedico(28,5,2009,"93080","92","");
        System.out.println(teste);
    }
}
