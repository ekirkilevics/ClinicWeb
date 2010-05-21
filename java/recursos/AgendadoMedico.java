/* Arquivo: AgendadoMedico.java
 * Autor: Amilton Souza Martha
 * Criação: 16/09/2005   Atualização: 06/05/2009
 * Obs: Manipula as informações da agenda do médico
 */

package recursos;
import java.sql.*;
import java.util.*;

public class AgendadoMedico {
    
    //Atributos privados para conexão
    private Connection con = null;
    private Statement stmt = null;
    
    public AgendadoMedico() {
        con = Conecta.getInstance();
    }
    
    //Pega os procedimentos que um profissional realiza
    public String getProcedimentos(String prof_reg) {
        
        String sql =  "SELECT procedimentos.Procedimento, procedimentos.COD_PROCED ";
        sql += "FROM (especialidade RIGHT JOIN procedimentos ON ";
        sql += "especialidade.codesp = procedimentos.codesp) ";
        sql += "INNER JOIN prof_esp ON especialidade.codesp = prof_esp.codesp ";
        sql += "WHERE prof_esp.prof_reg='" + prof_reg + "' AND flag=1 ";
        sql += "ORDER BY Procedimento";
        
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
                resp += "<option value='" + rs.getString("COD_PROCED") + "'>" + rs.getString("Procedimento") + "</option>\n";
            }
            
            rs.close();
            stmt.close();
            
            return resp;
        } catch(SQLException e) {
            return e.toString();
        }
    }
    
    //Devolve os convênios
    public String getConvenios(String codconv, String cod_empresa) {
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            String resp = "", sql;
            ResultSet rs = null;
            
            //Se já escolheu o paciente, veio convênio
            if(!codconv.equals("")) {
                //Recupera todos os convênios para montar a lista
                sql =  "SELECT cod_convenio, descr_convenio FROM convenio ";
                sql += "WHERE cod_empresa=" + cod_empresa + " ORDER BY descr_convenio";
                
                //Executa a pesquisa
                rs = stmt.executeQuery(sql);
                
                //Cria looping com a resposta
                while(rs.next()) {
                    if(rs.getString("cod_convenio").equals(codconv))
                        resp += "<option value='" + rs.getString("cod_convenio") + "' selected>" + rs.getString("descr_convenio") + "</option>\n";
                    else
                        resp += "<option value='" + rs.getString("cod_convenio") + "'>" + rs.getString("descr_convenio") + "</option>\n";
                }
                
                rs.close();
            }
            
            stmt.close();
            return resp;
        } catch(SQLException e) {
            return e.toString();
        }
    }
    
    //Pega todos os procedimentos com a especialidade junto
    public String getProcedimentosAgenda(String cod_empresa) {
        
        String sql =  "SELECT * FROM grupoprocedimento ";
        sql += "WHERE cod_empresa=" + cod_empresa;
        sql += " AND ativo='S'";
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
    
    //pesquisa: valor a ser pesquisado
    //campo: campo a ser pesquisado
    //ordem: ordem de resposta dos campos
    //tipo: tipo de pesquisa (exata, substring)
    public String getProfissionais(String pesquisa, String campo, int qtd, String ordem, int tipo) {
        String resp = "";
        String sql = "";
        ResultSet rs = null;
        
        //Só pega profissionais internos
        sql += "SELECT nome, cod, prof_reg FROM profissional ";
        sql += "WHERE locacao='interno' AND ativo='S' AND exibir='S' ";
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            //Consulta exata
            if(tipo == 1)
                sql += "AND " + campo + "='" + pesquisa + "' ORDER BY " + ordem;
            //Começando com o valor
            else if(tipo == 2)
                sql += "AND " + campo + " LIKE '" + pesquisa + "%' ORDER BY " + ordem;
            //Com o valor no meio
            else if(tipo == 3)
                sql += "AND " + campo + " LIKE '%" + pesquisa + "%' ORDER BY " + ordem;
            
            //Limita para uma quantidade de registros
            sql += " LIMIT " + qtd;
            
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            //Cria looping com a resposta
            while(rs.next()) {
                resp += "<tr onClick=go('agendadomedico.jsp?cod=" + rs.getString("cod") + "') onMouseOver='trocaCor(this,1);' onMouseOut='trocaCor(this,2);'>";
                resp += "<td width='30%' class='tdLight'>" + rs.getString("prof_reg") + "&nbsp;</td>\n";
                resp += "<td width='70%' class='tdLight'>" + rs.getString("nome") + "&nbsp;</td>\n";
                resp += "</tr>";
            }
            
            //Se não retornar resposta, montar mensagem de não encontrado
            if(resp.equals("")) {
                resp += "<tr>";
                resp += "<td colspan='2' width='100%' class='tdLight'>";
                resp += "Nenhum registro encontrado para a pesquisa";
                resp += "</td>";
                resp += "</tr>";
            }
            rs.close();
            stmt.close();
            
            return resp;
            
        } catch(SQLException e) {
            return "Erro:" + e.toString();
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
            return "Erro:" + e.toString();
        }
    }
    
    //Chama a agenda com default sem profissional (prof_reg)
    public String montaCalendario(int mesData, int anoData, String pagina) {
        return montaCalendario(mesData, anoData, pagina, "");
    }
    
       /*
        * mesData: mês da montagem do calendário
        * anoData: ano da montagem do calendário
        * pagina: página destino quando clicar em um dia do calendário (sem o .jsp)
        * completa: se vai deixar link para dias anteriores ou não (caso do médico)
        */
    //Monta o calendário
    public String montaCalendario(int mesData, int anoData, String pagina, String prof_reg) {
        
        String resp="<table width='100%'>\n";
        int dia, mes, diaSemana;
        //Pega a data atual do sistema e zera hora, minuto e segundo (considerar apenas data)
        GregorianCalendar now  = new GregorianCalendar();
        now.set(Calendar.HOUR,0);
        now.set(Calendar.MINUTE,0);
        now.set(Calendar.SECOND,0);
        now.set(Calendar.MILLISECOND,0);
        
        //Data da agenda começando em 01 e zerando hora, minuto e segundo
        GregorianCalendar hoje = new GregorianCalendar(anoData, mesData-1, 1,0,0,0);
        boolean comecou = false;
        //Dia da semana de 1 a 7
        diaSemana = hoje.get(Calendar.DAY_OF_WEEK);
        //Mes atual
        mes = hoje.get(Calendar.MONTH);
        
        //Monta cabeçalho do calendário
        resp += "<tr>";
        resp += "<td class='tdMedium'>Domingo</td>";
        resp += "<td class='tdMedium'>Segunda</td>";
        resp += "<td class='tdMedium'>Terça</td>";
        resp += "<td class='tdMedium'>Quarta</td>";
        resp += "<td class='tdMedium'>Quinta</td>";
        resp += "<td class='tdMedium'>Sexta</td>";
        resp += "<td class='tdMedium'>Sábado</td>";
        resp += "</tr>";
        
        //Monta 6 linhas, uma linha para cada semana do mês
        for(int i=0; i<6; i++) {
            resp += "<tr height='40px' valign='top'>\n";
            //São 7 colunas. uma para cada dia da semana
            for(int j=1; j<=7; j++) {
                //Quando bater o dia da semana, começar a imprimir
                if(diaSemana == j) comecou = true;
                
                //Depois que começou a data e não passou para o próximo mês
                if(comecou && hoje.get(Calendar.MONTH)==mes) {
                    dia = hoje.get(Calendar.DATE);
                    
                    //Se for feriado
                    if(ehFeriado(hoje)!=null) {
                        resp += "<td width='14%' class='tdLight' style='cursor:hand; background-color:#AAAAAA' onClick=\"Javascript:alert('" + ehFeriado(hoje) + "')\">" + dia + "</td>\n"; 
                    }

                    //Se a data for a data atual, mudar a cor da célula
                    else if( datasIguais(now, hoje) ) {
                        resp += "<td width='14%' style='cursor:hand; color:white' class='tdDark' onClick=detalheAgenda(" + dia + "," + mesData + "," + anoData + ")><b>" + getDiaProfissional(hoje,prof_reg) + "</b></td>\n";
                    } else if( profissionalAtende(prof_reg, hoje) ) {
                        resp += "<td onMouseOver='trocaCor(this,1);' onMouseOut='trocaCor(this,2);' onClick=detalheAgenda(" + dia + "," + mesData + "," + anoData + ") width='14%' class='tdLight'>" + getDiaProfissional(hoje,prof_reg) + "</td>\n";
                    } else {
                        resp += "<td width='14%' class='tdLight' style='background-color:#DEDEDE'>" + dia + "</td>\n";
                    }
                    hoje.add(GregorianCalendar.DATE, 1);
                } else {
                    resp += "<td width='14%' class='tdLight'>&nbsp;</td>\n";
                }
            }
            resp += "</tr>";
            
        }
        resp += "</table>";
        
        return resp;
    }
    
    //Monta Calendário do paciente
    public String montaCalendarioPaciente(int mesData, int anoData, String pagina, String prof_reg) {
        
        String resp="<table width='100%'>\n";
        int dia, mes, diaSemana;
        //Pega a data atual do sistema e zera hora, minuto e segundo (considerar apenas data)
        GregorianCalendar now  = new GregorianCalendar();
        now.set(Calendar.HOUR,0);
        now.set(Calendar.MINUTE,0);
        now.set(Calendar.SECOND,0);
        now.set(Calendar.MILLISECOND,0);
        
        //Data da agenda começando em 01 e zerando hora, minuto e segundo
        GregorianCalendar hoje = new GregorianCalendar(anoData, mesData-1, 1,0,0,0);
        boolean comecou = false;
        //Dia da semana de 1 a 7
        diaSemana = hoje.get(Calendar.DAY_OF_WEEK);
        //Mes atual
        mes = hoje.get(Calendar.MONTH);
        
        //Monta cabeçalho do calendário
        resp += "<tr>\n";
        resp += " <td class='tdMedium'>Domingo</td>\n";
        resp += " <td class='tdMedium'>Segunda</td>\n";
        resp += " <td class='tdMedium'>Terça</td>\n";
        resp += " <td class='tdMedium'>Quarta</td>\n";
        resp += " <td class='tdMedium'>Quinta</td>\n";
        resp += " <td class='tdMedium'>Sexta</td>\n";
        resp += " <td class='tdMedium'>Sábado</td>\n";
        resp += "</tr>";
        
        //Monta 6 linhas, uma linha para cada semana do mês
        for(int i=0; i<6; i++) {
            resp += "<tr height='40px' valign='top'>\n";
            //São 7 colunas. uma para cada dia da semana
            for(int j=1; j<=7; j++) {
                //Quando bater o dia da semana, começar a imprimir
                if(diaSemana == j) comecou = true;
                
                //Depois que começou a data e não passou para o próximo mês
                if(comecou && hoje.get(Calendar.MONTH)==mes) {
                    dia = hoje.get(Calendar.DATE);
                    
                    //Se for feriado
                    if(ehFeriado(hoje)!=null) {
                        resp += "<td width='14%' class='tdLight' style='cursor:hand; background-color:#AAAAAA' onClick=\"Javascript:alert('" + ehFeriado(hoje) + "')\">" + dia + "</td>\n"; 
                    }

                    //Se a data for a data atual, mudar a cor da célula
                    else if( datasIguais(now, hoje) ) {
                        resp += "<td width='14%' style='cursor:hand' class='tdDark' onClick=detalheAgenda(" + dia + "," + mesData + "," + anoData + ")>" + getDiaProfissional(hoje,prof_reg) + "</td>\n";
                    } else {
                        resp += "<td onMouseOver='trocaCor(this,1);' onMouseOut='trocaCor(this,2);' onClick=detalheAgenda(" + dia + "," + mesData + "," + anoData + ") width='14%' class='tdLight'>" + getDiaProfissional(hoje,prof_reg)+ "</td>\n";
                    }
                    hoje.add(GregorianCalendar.DATE, 1);
                } else {
                    resp += "<td width='14%' class='tdLight'>&nbsp;</td>\n";
                }
            }
            resp += "</tr>";
            
        }
        resp += "</table>";
        
        return resp;
    }
  
    //Retorna o mês por extenso
    public String mesExtenso(int mes) {
        String resp = "";
        switch(mes) {
            case 1: resp  = "Janeiro";   break;
            case 2: resp  = "Fevereiro"; break;
            case 3: resp  = "Março";     break;
            case 4: resp  = "Abril";     break;
            case 5: resp  = "Maio";      break;
            case 6: resp  = "Junho";     break;
            case 7: resp  = "Julho";     break;
            case 8: resp  = "Agosto";    break;
            case 9: resp  = "Setembro";  break;
            case 10: resp = "Outubro";   break;
            case 11: resp = "Novembro";  break;
            case 12: resp = "Dezembro";  break;
        }
        return resp;
    }
    
    //Verifica se duas datas são iguais
    private boolean datasIguais(GregorianCalendar data1, GregorianCalendar data2) {
        int d1, m1, a1,  d2, m2,  a2;
        d1 = data1.get(Calendar.DATE);
        m1 = data1.get(Calendar.MONTH);
        a1 = data1.get(Calendar.YEAR);
        
        d2 = data2.get(Calendar.DATE);
        m2 = data2.get(Calendar.MONTH);
        a2 = data2.get(Calendar.YEAR);
        
        if(d1==d2 && m1==m2 && a1==a2)
            return true;
        else
            return false;
    }
    
    //Conta as agendas do médico para aquele dia por tipo
    private String getDiaProfissional(GregorianCalendar data, String prof_reg) {
        String resp = "";
        String sql = "";
        ResultSet rs = null;
        int vetor[] = new int[4];
        int status = 0;

        //Dia do Mês
        int dia = data.get(Calendar.DATE);
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);

            String strinicio="", strfim="";
            int intervalo=0;

            //Pega dia da semana para ver os médicos com agenda nesse dia
            int dia_semana = data.get(Calendar.DAY_OF_WEEK);

            sql  = "SELECT agendamedico.hora_inicio, agendamedico.hora_fim, profissional.tempoconsulta ";
            sql += "FROM agendamedico INNER JOIN profissional ";
            sql += "ON agendamedico.prof_reg = profissional.prof_reg ";
            sql += "WHERE agendamedico.dia_semana=" + dia_semana + " ";
            sql += "AND CONCAT(agendamedico.vigencia, agendamedico.prof_reg) IN (";
            sql += "SELECT CONCAT(MAX(agendamedico.vigencia), agendamedico.prof_reg) ";
            sql += "FROM agendamedico WHERE vigencia <= '" + formataDataBusca(data) + "' AND prof_reg='" + prof_reg + "')";

            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            if(rs.next()) {
                strinicio = rs.getString("hora_inicio");
                strfim = rs.getString("hora_fim");
                intervalo = rs.getInt("tempoconsulta");
            }

            //Busca quantas agendas existem abertas
            int agendasabertas = getAgendaMedico(data, prof_reg, strinicio, strfim, intervalo);

            //Busca a quantidade de agendas realizadas
            sql  = "SELECT COUNT(*) AS contador, status FROM agendamento ";
            sql += "WHERE prof_reg='" + prof_reg + "' ";
            sql += "AND data='" + formataDataBusca(data) + "' ";
            sql += "AND ativo='S' ";
            sql += "GROUP BY status ";
            sql += "ORDER By status";

            //Executa a pesquisa
            rs = stmt.executeQuery(sql);

            //Pega a resposta
            while(rs.next()) {
                status = rs.getInt("status");

                //Verifica o tipo de status para trocar a cor
                switch(status) {
                    case 1:
                        vetor[0] = rs.getInt("contador");
                        break;
                    case 3:
                        vetor[1] = rs.getInt("contador");
                        break;
                    case 9:
                        vetor[2] = rs.getInt("contador");
                        break;
                }
            }

            //Preeche agendas abertas
            vetor[3] = agendasabertas;

            //Monta a tabela resposta
            resp  = "<table cellpadding='0' cellspacing='0' width='100%' height='100%'>\n";
            resp += " <tr>\n";
            resp += "  <td class='texto' rowspan='2' align='left'><b>" + Util.formataNumero(dia+"", 2) + "</b></td>\n";
            resp += "  <td style='color:#868DB4; font-size:10px; padding:0px'  align='right'><b>" + formataValorAgenda(vetor,0) + "</b></td>\n";
            resp += "  <td style='color:red; font-size:10px; padding:0px' align='center'><b>" + formataValorAgenda(vetor,1) + "</b></td>\n";
            resp += " </tr>\n";
            resp += " <tr>\n";
            resp += "  <td width='50%' style='color:green; font-size:10px; padding:0px' align='right'><b>" + formataValorAgenda(vetor, 2) + "</b></td>\n";
            resp += "  <td width='50%' style='color:blue; font-size:10px'; padding:0px' align='center'><b>" + formataValorAgenda(vetor, 3) + "</b></td>\n";
            resp += " </tr>\n";
            resp += "</table>\n";

            rs.close();
            stmt.close();

            return resp;

        } catch(SQLException e) {
            return "ERRO: " + e.toString() + " SQL: " + sql;
        }

    }

    //Formata a saída dos totais
    private String formataValorAgenda(int vetor[], int pos) {

        //Se não for agendas disponíveis
        if(pos != 3) {
            if(vetor[pos] == 0) return "&nbsp;";
            else return Util.formataNumero(vetor[pos]+"", 2);
        }
        else {
            if(vetor[pos]==-1) return "&nbsp;";
            else if(vetor[pos] == 0) return "<img src='images/30.gif' width='16'>";
            else return Util.formataNumero(vetor[pos]+"", 2);
        }
    }


    //Verifica se a agenda do médico está lotada
    private int getAgendaMedico(GregorianCalendar data, String prof_reg, String inicioMedico, String fimMedico, int intervalo) {
        GregorianCalendar gc_iniciomedico, gc_fimmedico;
        
        //Contador de horários vagos
        int cont = 0;

        //Separa dia, mês e ano
        int dia, mes, ano;
        dia = data.get(Calendar.DATE);
        mes = data.get(Calendar.MONTH)+1;
        ano = data.get(Calendar.YEAR);

        //Se horário de início e fim forem iguais, ele não atende
        if(inicioMedico.equals(fimMedico)) return -1;

        //Converte as Strings de horários em objetos GregorianCalendar
        gc_iniciomedico = Util.toTime(inicioMedico, dia, mes, ano);
        gc_fimmedico = Util.toTime(fimMedico, dia, mes, ano);

        //Busca as agendas do profissional de acordo comm o seu intervalo
        while (Util.emMinutos(gc_iniciomedico) <= Util.emMinutos(Util.addMinutos(gc_fimmedico, -intervalo))) {

            //Se não achou agenda na data e hora, incrementar contador de agendas livres
            if(!this.getAgenda(gc_iniciomedico, prof_reg)) cont++;

            //Adiciona o intervalo em minutos
            gc_iniciomedico = Util.addMinutos(gc_iniciomedico, intervalo);

        }
        return cont;
    }

    //Retorna se existe agenda para essa data/hora do médico
    public boolean getAgenda(GregorianCalendar data, String prof_reg) {
        Statement stmt = null;
        boolean resp = false;

        try {

            //Cria nova Statement para o ponteiro não alterar o anterior
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);

            String sql = "";
            ResultSet rs = null;

            sql += "SELECT * FROM agendamento ";
            sql += "WHERE agendamento.ativo='S' AND agendamento.data='" + formataDataBusca(data) + "' ";
            sql += "AND agendamento.prof_reg='" + prof_reg + "' ";
            sql += "AND hora ='" + Util.GC2HHMM(data) + "' ";

            rs = stmt.executeQuery(sql);

            //Se achou, existe agenda para o dia e hora
            if (rs.next()) {
                resp = true;
            }
            else {
                //Verifica se há cancelamento na agenda
                String cancelaAgenda[] = new Agenda().existeCancelamentoAgenda(data, prof_reg);
                if (!Util.isNull(cancelaAgenda[1])) {
                    resp = true;
                }
                else {
                    resp = false;
                }
            }

            rs.close();
            stmt.close();

            return resp;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }

    }


    //Verifica se o profissional atende esse dia
    private boolean profissionalAtende(String prof_reg, GregorianCalendar data) {
        boolean resp = false;
        String sql = "";
        ResultSet rs = null;
        
        if(prof_reg.equals(""))
            return resp;
        else {
            try {
                //Cria statement para enviar sql
                stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                        ResultSet.CONCUR_READ_ONLY);
                
                int dia_semana = data.get(Calendar.DAY_OF_WEEK);
                //Data de referência
                String dataPesq = formataDataBusca(data);
                
                //Verifica se atende esse dia da semana ou tem hora extra
                sql += "SELECT prof_reg FROM agendamedico ";
                sql += "WHERE prof_reg='" + prof_reg + "' ";
                sql += "AND dia_semana=" + dia_semana + " ";
                sql += "AND hora_inicio > '00:00' ";
                sql += "AND agendamedico.vigencia IN (";
                sql += "SELECT MAX(agendamedico.vigencia) ";
                sql += "FROM agendamedico WHERE vigencia < '" + dataPesq + "' ";
                sql += "AND prof_reg='" + prof_reg + "') ";
                
                //Executa a pesquisa
                rs = stmt.executeQuery(sql);
                
                //Pega a resposta
                if(rs.next()) {
                    resp = true;
                }
                
                rs.close();
                stmt.close();
                
                return resp;
                
            } catch(SQLException e) {
                return false;
            }
        }
    }

    //Formata uma data GregorianCalendar para aaaa-mm-dd para buscar no banco com SQL
    private String formataDataBusca(GregorianCalendar data) {
        String resp = "";
        int d, m, a;
        d = data.get(Calendar.DATE);
        m = data.get(Calendar.MONTH)+1;
        a = data.get(Calendar.YEAR);
        
        resp = a + "-" + m + "-" + d;
        return resp;
        
    }
    
    //Busca as agendas para o paciente
    public String getAgendaPaciente(String codcli) {
        String resp = "";
        String sql = "";
        ResultSet rs = null;
        boolean achou = false;
        
        sql += "SELECT convenio.descr_convenio, grupoprocedimento.grupoproced, ";
        sql += "profissional.nome, agendamento.data, agendamento.hora, agendamento.status, ";
        sql += "agendamento.cod_convenio, agendamento.agendamento_id ";
        sql += "FROM ((agendamento LEFT JOIN convenio ON agendamento.cod_convenio = ";
        sql += "convenio.cod_convenio) INNER JOIN profissional ON agendamento.prof_reg = ";
        sql += "profissional.prof_reg) INNER JOIN grupoprocedimento ON agendamento.cod_proced ";
        sql += "= grupoprocedimento.cod_grupoproced ";
        sql += "WHERE agendamento.codcli=" + codcli + " AND agendamento.ativo='S' ORDER BY agendamento.data DESC";
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            resp += "<table cellspacing=0 cellpadding=0 class='table' width='100%'>\n";
            resp += "  <tr>\n";
            resp += "   <td class='tdMedium'>Data</td>\n";
            resp += "   <td class='tdMedium'>Hora</td>\n";
            resp += "   <td class='tdMedium'>Procedimento</td>\n";
            resp += "   <td class='tdMedium'>Profissional</td>\n";
            resp += "   <td class='tdMedium'>Convênio</td>\n";
            resp += "   <td class='tdMedium' align='center'>Status</td>\n";
            resp += "   <td class='tdMedium' align='center'>Excluir</td>\n";
            resp += "  </tr>\n";
            
            //Cria looping com a resposta
            while(rs.next()) {
                resp += "  <tr>\n";
                resp += "   <td class='tdLight'>" + Util.formataData(rs.getString("data")) + "</td>\n";
                resp += "   <td class='tdLight'>" + Util.formataHora(rs.getString("hora")) + "</td>\n";
                resp += "   <td class='tdLight'>" + rs.getString("grupoproced") + "</td>\n";
                resp += "   <td class='tdLight'>" + rs.getString("profissional.nome") + "</td>\n";
                resp += "   <td class='tdLight'>" + rs.getString("descr_convenio") + "</td>\n";
                resp += "   <td class='tdLight' style='text-align:center'><img src='images/" + rs.getString("status") + ".gif' border=0></td>\n";
                resp += "   <td class='tdLight' style='text-align:center'><a href='Javascript:excluiragenda(" + rs.getString("agendamento_id") + ")'><img src='images/delete.gif' border=0></a></td>\n";
                resp += "  </tr>\n";
                achou = true;
            }
            
            
            if(!achou) {
                resp += "<tr>\n";
                resp += " <td colspan=7 class='tdLight'>Sem agendas para o paciente</td>\n";
                resp += "</tr>\n";
            }
            
            resp += "  </table>\n";
            
            rs.close();
            stmt.close();
            return resp;
            
        } catch(SQLException e) {
            return "Erro:" + e.toString();
        }
    }
    
    public String ehFeriado(GregorianCalendar data){
    
        String resp = null;
        
        String sql =  "";
        sql += "SELECT * FROM feriados WHERE prof_reg='todos' AND diatodo='S'";
        sql += " AND ((dataInicio<='" + formataDataBusca(data) + "' AND dataFim>='" + formataDataBusca(data) + "' ";
        sql += "AND definitivo='N') OR (";
        sql += "Day(dataInicio)=" + data.get(Calendar.DATE) + " AND Month(dataInicio)=" + (data.get(Calendar.MONTH)+1);
        sql += " AND definitivo='S'))";
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            ResultSet rs = null;
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            //Cria looping com a resposta
            if(rs.next()) {
                resp = rs.getString("descricao");
            }
            
            rs.close();
            stmt.close();
            
            return resp;
        } catch(SQLException e) {
            return "ERRO: " + e.toString() + " SQL: " + sql;
        }        
    }
    
    public static void main(String args[]) {
        AgendadoMedico a = new AgendadoMedico();
        //String teste = a.montaCalendario(3, 2008, "detalheagenda", "12345");
        //System.out.println(teste);
        int agendasabertas = a.getAgendaMedico(new GregorianCalendar(2009,2,16), "40870", "08:00", "17:30", 20);
        System.out.println(agendasabertas);
    }
    
}