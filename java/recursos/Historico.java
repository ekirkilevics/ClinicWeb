/* Arquivo: Historico.java
 * Autor: Amilton Souza Martha
 * Criação: 03/10/2005   Atualização: 14/04/2009
 * Obs: Manipula as informações do histórico do paciente
 */

package recursos;
import java.sql.*;
import java.util.Vector;

public class Historico {
    //Atributos privados para conexão
    private Connection con = null;
    private Statement stmt = null;
    
    public Historico() {
        con = Conecta.getInstance();
    }
    
    public Vector getHistorias(String codcli, String ordem, String tddark) {
        String resp = "";
        String sql = "";
        ResultSet rs = null;
        String cor = "";
        String hora = "";
        String definitivo = "";
        int cont=1;
        
        //Retorno dos dados
        Vector retorno = new Vector();
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            //Campos a pesquisar na tabela
            sql  = "SELECT historia.cod_hist AS codigo, historia.codcli, historia.PROF_REG, ";
            sql += "historia.DTACON, historia.HORA, historia.TEXTO, historia.definitivo, ";
            sql += "profissional.nome, profissional.reg_prof, profissao.tipo_registro, tiposhistoria.cor ";
            sql += "FROM tiposhistoria RIGHT JOIN ((profissao RIGHT JOIN ((profissional ";
            sql += "LEFT JOIN prof_esp ON profissional.prof_reg = prof_esp.prof_reg) ";
            sql += "LEFT JOIN especialidade ON prof_esp.codesp = especialidade.codesp) ";
            sql += "ON profissao.cod_profis = especialidade.cod_profis) INNER JOIN historia ";
            sql += "ON profissional.prof_reg = historia.PROF_REG) ON ";
            sql += "tiposhistoria.cod_tipohistoria = historia.tipohistoria ";
            sql += "WHERE historia.codcli='" + codcli + "' ";
            sql += "GROUP BY historia.codcli, historia.cod_hist, historia.PROF_REG, ";
            sql += "historia.DTACON, historia.HORA, historia.TEXTO, historia.definitivo, ";
            sql += "historia.resumo, profissional.nome, profissional.reg_prof ";
            sql += "ORDER BY historia.DTACON " + ordem + ",historia.HORA " + ordem;
            
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            //Cria looping com a resposta
            while(rs.next()) {
                //Verifica se a história é definitiva
                definitivo = rs.getString("definitivo");
                
                //Captura a hora e coloca em 5 caracteres
                hora = Util.formataHora(rs.getString("HORA"));
                
                //Cor (se não vier, usar padrão
                cor = rs.getString("cor");
                if(Util.isNull(cor)) cor = tddark;
                
                resp = "";
                resp += "<table width='90%' border='0' cellpadding='0' cellspacing='0' class='table'>\n";
                resp += "<tr>\n";
                //Se é história definitiva, colocar imagem de cadeado fechado, senão, colocar aberto
                if(definitivo.equals("S"))
                    resp += "   <td class='tdMedium' style='background-color:"+cor+"' width='18' align='center'><img src='images/cadeado.gif'></td>\n";
                else
                    resp += "   <td class='tdMedium' style='background-color:"+cor+"' width='18' align='center'><img src='images/cadeadoaberto.gif'></td>\n";                    
                resp += "       <td class='tdMedium' style='background-color:"+cor+"'><img id='img" + cont + "' src='images/plus.png' onClick='view("+cont+")'> Profissional: <b>" + rs.getString("profissional.nome") + " ( " + (rs.getString("tipo_registro")!=null ? rs.getString("tipo_registro") : "Reg.") + ": " + rs.getString("reg_prof") + " )</b></td>\n";
                resp += "	<td width='130px' class='tdMedium' style='background-color:"+cor+"'>Data: <b>" + Util.formataData(rs.getString("DTACON")) + "</b></td>\n";
                resp += "	<td width='80px' class='tdMedium' style='background-color:"+cor+"'>Hora: <b>" + hora + "</b></td>\n";
                resp += "	<td width='20px' class='tdMedium' style='background-color:"+cor+"'><a href='Javascript:imprimirHist(" + rs.getString("codigo") + ")'><img src='images/print.gif' border=0></a></td>\n";
                resp += "	<td width='20px' class='tdMedium' style='background-color:"+cor+"'><a href=\"Javascript:historia('" + rs.getString("codigo") + "')\" title='Editar História'><img src='images/23.gif' border=0></a></td>\n";
                resp += "</tr>\n";
                resp += "</table>\n";
                resp += "<div id='tr"+cont+"' style='display:\"none\"'>\n";
                resp += "<table width='90%' border='0' cellpadding='0' cellspacing='0' class='table'>\n";
                resp += "<tr>\n";
                resp += "	<td colspan='2' width='100%' style='border: 0px; border-bottom: 1px solid #111111; border-right: 1px solid #000000;background-color:white'><font face=Verdana, Arial, Helvetica, sans-serif size=2>" + Util.formataTextoLista(rs.getString("historia.TEXTO")) + "</font></td>\n";
                resp += "</tr>\n";
                resp += "<tr>\n";
                resp += "   <td class='tdMedium'>Diagnósticos</td>\n";
                resp += "   <td class='tdLight' style='background-color:white'>" + getDiagnosticos(rs.getString("codigo"), codcli, 2) + "&nbsp;</td>\n";
                resp += "</tr>\n";
                resp += "<tr>\n";
                resp += "   <td class='tdMedium'>Procedimentos</td>\n";
                resp += "   <td class='tdLight' style='background-color:white'>" + getProcedimentos(rs.getString("codigo"), 2) + "&nbsp;</td>\n";
                resp += "</tr>\n";
                resp += "<tr>\n";
                resp += "   <td width='100' class='tdMedium'>Medicamentos</td>\n";
                resp += "   <td width='100%' class='tdLight' style='background-color:white'>" + getMedicamentos(rs.getString("codigo"), codcli, 2) + "&nbsp;</td>\n";
                resp += "</tr>\n";
                resp += "</table>";
                resp += "</div>\n";
                resp += "<table><tr><td height='3px'></td></tr></table>";
                cont++;
                
                //Adiciona no retorno
                retorno.add(resp);
            }
            
            //Se não retornar resposta, montar mensagem de não encontrado
            if(resp.equals("")) {
                resp =  "";
                resp += "<table width='90%' border='0' cellpadding='0' cellspacing='0' class='table'>\n";
                resp += "<tr>";
                resp += "<td width='100%' class='tdLight' style='background-color:white'>";
                resp += "Nenhuma história gravada para o paciente";
                resp += "</td>";
                resp += "</tr>";
                resp += "</table>";
                
                //Adiciona no retorno
                retorno.add(resp);
            }
            
            resp = "<input type='hidden' id='total' name='total' value='"+ (cont-1) + "'>";
            
            //Adiciona no retorno
            retorno.add(resp);
            
            rs.close();
            stmt.close();
            
            return retorno;
        } catch(SQLException e) {
            retorno.add("ERRO: " + e.toString() + " SQL=" + sql);
            return retorno;
        }
    }
    
   /*
    * codcli: código do paciente
    * resumo: 1-se for resumo, 0-se não for
    */
    public Vector getHistoriasRel(String codcli, String resumo) {
        String resp = "";
        String sql = "";
        ResultSet rs = null;
        String cor = "";
        String hist_resumo = "", hora = "";
        int cont=1;
        
        //Retorno dos dados
        Vector retorno = new Vector();
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            //Campos a pesquisar na tabela
            sql =  "SELECT DISTINCT historia.cod_hist AS codigo, historia.codcli, historia.PROF_REG, ";
            sql += "historia.DTACON, historia.HORA, historia.TEXTO, historia.definitivo, ";
            sql += "historia.resumo, profissional.nome, profissional.reg_prof, profissao.tipo_registro ";
            sql += "FROM (historia INNER JOIN profissional ON historia.PROF_REG = profissional.prof_reg) ";
            sql += "INNER JOIN (profissao INNER JOIN (prof_esp INNER JOIN especialidade ON prof_esp.codesp ";
            sql += "= especialidade.codesp) ON profissao.cod_profis = especialidade.cod_profis) ON ";
            sql += "profissional.prof_reg = prof_esp.prof_reg ";
            sql += "WHERE historia.codcli='" + codcli + "' ";
            
            //Se escolheu que quer só resumos, filtrar
            if(resumo.equals("1")) sql += "AND historia.resumo=1 ";
            
            sql += "GROUP BY historia.codcli, historia.cod_hist, historia.PROF_REG, ";
            sql += "historia.DTACON, historia.HORA, historia.TEXTO, historia.definitivo, ";
            sql += "historia.resumo, profissional.nome, profissional.reg_prof ";
            sql += "ORDER BY historia.DTACON DESC ";
            
            
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            //Cria looping com a resposta
            while(rs.next()) {
                //Captura resumo 1=é resumo, 2=não é resumo
                hist_resumo = rs.getString("resumo");
                
                //Captura a hora e coloca em 5 caracteres
                hora = rs.getString("HORA");
                if(hora.length()>5)	hora = hora.substring(0,5);
                
                //Se for ficha resumo, outra cor
                if(Integer.parseInt(hist_resumo) == 1) {
                    cor = "#FFCC99";
                } else {
                    //Se for definitivo, trocar de cor
                    if(rs.getString("definitivo").equals("N")) {
                        cor = "#94AED6";
                    } else {
                        cor = "#CCFFFF";
                    }
                }
                
                resp = "";
                resp += "<table width='90%' border='0' cellpadding='0' cellspacing='0' class='table'>\n";
                resp += "<tr>\n";
                resp += "       <td class='tdMedium' style='background-color:"+cor+"'><img id='img" + cont + "' src='images/plus.png' onClick='view("+cont+")'> Profissional: <b>" + rs.getString("profissional.nome") + " ( " + rs.getString("tipo_registro") + ": " + rs.getString("reg_prof") + " )</b></td>\n";
                resp += "	<td width='130px' class='tdMedium' style='background-color:"+cor+"'>Data: <b>" + Util.formataData(rs.getString("DTACON")) + "</b></td>\n";
                resp += "	<td width='80px' class='tdMedium' style='background-color:"+cor+"'>Hora: <b>" + hora + "</b></td>\n";
                resp += "	<td width='20px' class='tdMedium' style='background-color:"+cor+"'><a href='Javascript:imprimirHist(" + rs.getString("codigo") + ")'><img src='images/print.gif' border=0></a></td>\n";
                resp += "</tr>\n";
                resp += "</table>\n";
                resp += "<div id='tr"+cont+"' style='display:\"none\"'>\n";
                resp += "<table width='90%' border='0' cellpadding='0' cellspacing='0' class='table'>\n";
                resp += "<tr>\n";
                resp += "	<td colspan='2' width='100%' style='background-color:white; border: 0px; border-bottom: 1px solid #111111; border-right: 1px solid #000000;'><font face=Verdana, Arial, Helvetica, sans-serif size=2>" + Util.formataTextoLista(rs.getString("historia.TEXTO")) + "</font></td>\n";
                resp += "</tr>\n";
                resp += "<tr>\n";
                resp += "   <td class='tdMedium'>Diagnósticos</td>\n";
                resp += "   <td class='tdLight' style='background-color:white'>" + getDiagnosticos(rs.getString("codigo"), codcli, 2) + "&nbsp;</td>\n";
                resp += "</tr>\n";
                resp += "<tr>\n";
                resp += "   <td class='tdMedium'>Procedimentos</td>\n";
                resp += "   <td class='tdLight' style='background-color:white'>" + getProcedimentos(rs.getString("codigo"), 2) + "&nbsp;</td>\n";
                resp += "</tr>\n";
                resp += "<tr>\n";
                resp += "   <td width='100' class='tdMedium'>Medicamentos</td>\n";
                resp += "   <td width='100%' class='tdLight' style='background-color:white'>" + getMedicamentos(rs.getString("codigo"), codcli, 2) + "&nbsp;</td>\n";
                resp += "</tr>\n";
                resp += "</table>";
                resp += "</div>\n";
                resp += "<table><tr><td height='3px'></td></tr></table>";
                cont++;
                
                //Adiciona no retorno
                retorno.add(resp);
            }
            
            //Se não retornar resposta, montar mensagem de não encontrado
            if(resp.equals("")) {
                resp =  "";
                resp += "<table width='90%' border='0' cellpadding='0' cellspacing='0' class='table'>\n";
                resp += "<tr>";
                resp += "<td width='100%' class='tdLight'>";
                resp += "Nenhuma história gravada para o paciente";
                resp += "</td>";
                resp += "</tr>";
                resp += "</table>";
                
                //Adiciona no retorno
                retorno.add(resp);
            }
            
            resp = "<input type='hidden' id='total' name='total' value='"+ (cont-1) + "'>";
            
            //Adiciona no retorno
            retorno.add(resp);
            
            rs.close();
            stmt.close();
            
            return retorno;
        } catch(SQLException e) {
            retorno.add("Ocorreu um erro: " + e.toString());
            return retorno;
        }
    }
    
       /* Recebe o id do histórico
        * Retorna:  [0]: Nome do paciente
                    [1]: Código do paciente
                    [2]: Nome do profissional
                    [3]: Registro do profissional
                    [4]: Data da Consulta
                    [5]: Hora da Consulta
                    [6]: História
                    [7]: Definitiva
                    [8]: História Resumo
                    [9]: tipohistoria
        */
    public String[] getHistorico(String id) {
        String resp[] = {"","","","","","","","","",""};
        String sql = "";
        ResultSet rs = null;
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            //Campos a pesquisar na tabela
            sql += "SELECT historia.*, profissional.prof_reg, paciente.codcli, ";
            sql += "profissional.nome, paciente.nome ";
            sql += "FROM paciente INNER JOIN (historia INNER JOIN profissional ";
            sql += "ON historia.PROF_REG = profissional.prof_reg) ";
            sql += "ON paciente.codcli = historia.codcli WHERE historia.cod_hist=" + id;
            
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            //Cria looping com a resposta
            if(rs.next()) {
                resp[0] = rs.getString("paciente.nome");
                resp[1] = rs.getString("codcli");
                resp[2] = rs.getString("profissional.nome");
                resp[3] = rs.getString("prof_reg");
                resp[4] = Util.formataData(rs.getString("DTACON"));
                resp[5] = rs.getString("HORA");
                resp[6] = Util.formataTexto(rs.getString("TEXTO"));
                resp[7] = rs.getString("definitivo");
                resp[8] = rs.getString("resumo");
                resp[9] = rs.getString("tipohistoria");
            }
            
            rs.close();
            stmt.close();
            
            return resp;
        } catch(SQLException e) {
            return resp;
        }
    }
    
    
    //Retorna os medicamentos usuais (flag=1)
    public String getMedicamentos(String cod_empresa) {
        String resp = "";
        String sql = "";
        ResultSet rs = null;
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            //Campos a pesquisar na tabela
            sql += "SELECT cod_comercial, comercial FROM medicamentos ";
            sql += "WHERE flag=1 AND cod_empresa=" + cod_empresa + " ORDER BY comercial";
            
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            //Cria looping com a resposta
            while(rs.next()) {
                resp += "<option value='" + rs.getString("cod_comercial");
                resp += "'>" + rs.getString("comercial") + "</option>\n";
            }
            
            rs.close();
            stmt.close();
        } catch(SQLException e) {
            resp += e.toString();
        }
        
        return resp;
    }
    
    //Retorna os procedimentos usuais (flag=1)
    public String getProcedimentos(String cod_empresa) {
        String resp = "";
        String sql = "";
        ResultSet rs = null;
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            //Campos a pesquisar na tabela
            sql += "SELECT COD_PROCED, Procedimento, CODIGO FROM procedimentos ";
            sql += "WHERE flag=1 AND cod_empresa=" + cod_empresa + " ORDER BY Procedimento";
            
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            //Cria looping com a resposta
            while(rs.next()) {
                resp += "<option value='" + rs.getString("COD_PROCED");
                resp += "'>[" + rs.getString("CODIGO") + "] " + rs.getString("Procedimento") + "</option>\n";
            }
            
            rs.close();
            stmt.close();
        } catch(SQLException e) {
            resp += e.toString();
        }
        
        return resp;
    }
    
    //Retorna os diagnósticos usuais (flag=1)
    public String getDiagnosticos(String cod_empresa) {
        String resp = "";
        String sql = "";
        ResultSet rs = null;
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            //Campos a pesquisar na tabela
            sql += "SELECT cod_diag, DESCRICAO, CID FROM diagnosticos ";
            sql += "WHERE flag=1 AND cod_empresa=" + cod_empresa + " ORDER BY DESCRICAO";
            
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            //Cria looping com a resposta
            while(rs.next()) {
                resp += "<option value='" + rs.getString("cod_diag");
                resp += "'>[" + rs.getString("CID") + "] " + rs.getString("DESCRICAO") + "</option>\n";
            }
            
            rs.close();
            stmt.close();
        } catch(SQLException e) {
            resp += e.toString();
        }
        
        return resp;
    }
    
    //Retorna os diagnósticos ded uma determinadas história
    //tipo 1-em options, 2-em lista
    public String getDiagnosticos(String cod_hist, String codcli, int tipo) {
        String resp = "";
        String sql = "";
        ResultSet rs = null;
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            if(!Util.isNull(cod_hist)) {
                
                //Campos a pesquisar na tabela
                sql += "SELECT diagnosticos.* ";
                sql += "FROM diagnosticos INNER JOIN hist_diagnostico ";
                sql += "ON diagnosticos.cod_diag = hist_diagnostico.cod_diag ";
                sql += "WHERE hist_diagnostico.cod_hist=" + cod_hist;
                
                //Executa a pesquisa
                rs = stmt.executeQuery(sql);
                
                //Cria looping com a resposta
                while(rs.next()) {
                    if(tipo == 1) {
                        resp += "<option value='" + rs.getString("cod_diag");
                        resp += "'>[" + rs.getString("CID") + "] " + rs.getString("DESCRICAO") + "</option>\n";
                    } else {
                        resp += "<li>[" + rs.getString("CID") + "] " + rs.getString("DESCRICAO") + "</li>\n";
                    }
                }
                
                rs.close();
            } else {
                //Busca última história do paciente
                sql += "SELECT diagnosticos.cod_diag, diagnosticos.CID, diagnosticos.DESCRICAO, hist_diagnostico.cod_hist ";
                sql += "FROM hist_diagnostico INNER JOIN diagnosticos ON hist_diagnostico.cod_diag = diagnosticos.cod_diag ";
                sql += "WHERE diagnosticos.flag=1 AND (hist_diagnostico.cod_hist) = (";
                sql += "SELECT cod_hist FROM historia WHERE codcli=" + codcli + " ORDER BY DTACON DESC, HORA DESC LIMIT 1)";
                
                //Executa a pesquisa
                rs = stmt.executeQuery(sql);
                
                //Cria looping com a resposta
                while(rs.next()) {
                    if(tipo == 1) {
                        resp += "<option value='" + rs.getString("cod_diag");
                        resp += "'>" + rs.getString("CID") + "-" + rs.getString("DESCRICAO") + "</option>\n";
                    } else {
                        resp += "<li>" + rs.getString("CID") + "-" + rs.getString("DESCRICAO") + "</li>\n";
                    }
                }
                
                rs.close();
                
            }
            stmt.close();
        } catch(SQLException e) {
            resp += e.toString();
        }
        
        return resp;
    }
    

    //Retorna as indicações de medicamentos em options
    public String getIndicacoesMedicamentos(String cod_hist, String codcli) {
         String resp = "";
        String sql = "";
        ResultSet rs = null;
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            //Se veio história, pegar medicamentos dessa história
            if(!Util.isNull(cod_hist)) {

                //Campos a pesquisar na tabela
                sql += "SELECT indicacao ";
                sql += "FROM hist_medicamento ";
                sql += "WHERE hist_medicamento.cod_hist=" + cod_hist;
                sql += " ORDER BY cod_hist_med";

                //Executa a pesquisa
                rs = stmt.executeQuery(sql);

                //Cria looping com a resposta
                while(rs.next()) {
                        resp += "<option value='" + rs.getString("indicacao");
                        resp += "'>" + rs.getString("indicacao") + "</option>\n";
                }
            }
            //Buscar medicamentos de uso contínuo na última história
            else {
                sql += "SELECT hist_medicamento.* ";
                sql += "FROM hist_medicamento INNER JOIN medicamentos ON hist_medicamento.cod_comercial = medicamentos.cod_comercial ";
                sql += "WHERE medicamentos.flag=1 AND (hist_medicamento.cod_hist) = (";
                sql += "SELECT cod_hist FROM historia WHERE codcli=" + codcli + " ORDER BY DTACON DESC, HORA DESC LIMIT 1)";
                
                //Executa a pesquisa
                rs = stmt.executeQuery(sql);
                
                //Cria looping com a resposta
                while(rs.next()) {
                        resp += "<option value='" + rs.getString("indicacao");
                        resp += "'>" + rs.getString("indicacao") + "</option>\n";
                }
            }
            
            rs.close();
            stmt.close();
        } catch(SQLException e) {
            resp += e.toString();
        }
        
        return resp;
    }

    //Retorna os diagnósticos de uma determinadas história
    public String getDiagnosticosHist(String cod_hist, String codcli) {
        return getDiagnosticos(cod_hist, codcli, 1);
    }
    
    //Retorna os procedimentos de uma determinada história
    //tipo 1-em options, 2-em lista
    public String getProcedimentos(String cod_hist, int tipo) {
        String resp = "";
        String sql = "";
        ResultSet rs = null;
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            //Campos a pesquisar na tabela
            sql += "SELECT procedimentos.COD_PROCED, procedimentos.Procedimento, procedimentos.CODIGO ";
            sql += "FROM procedimentos INNER JOIN hist_procedimento ";
            sql += "ON procedimentos.cod_proced = hist_procedimento.cod_proced ";
            sql += "WHERE hist_procedimento.cod_hist=" + cod_hist;
            
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            //Cria looping com a resposta
            while(rs.next()) {
                if(tipo == 1) {
                    resp += "<option value='" + rs.getString("COD_PROCED");
                    resp += "'>[" + rs.getString("CODIGO") + "] " + rs.getString("Procedimento") + "</option>\n";
                } else {
                    resp += "<li>[" + rs.getString("CODIGO") + "] " + rs.getString("Procedimento") + "</li>\n";
                }
            }
            rs.close();
            
            stmt.close();
        } catch(SQLException e) {
            resp += e.toString();
        }
        
        return resp;
    }
    
    //Retorna os procedimentos de uma determinada história
    public String getProcedimentosHist(String cod_hist) {
        return getProcedimentos(cod_hist, 1);
    }
    
    //Retorna os procedimentos de uma determinada história para escolhe e impressão
    public String getProcedimentosHistoria(String cod_hist) {
        String resp = "";
        String sql = "";
        ResultSet rs = null;

        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);

            //Campos a pesquisar na tabela
            sql += "SELECT hist_procedimento.cod_hist_proced, procedimentos.COD_PROCED, ";
            sql += "procedimentos.Procedimento, procedimentos.CODIGO ";
            sql += "FROM procedimentos INNER JOIN hist_procedimento ";
            sql += "ON procedimentos.cod_proced = hist_procedimento.cod_proced ";
            sql += "WHERE hist_procedimento.cod_hist=" + cod_hist;

            //Executa a pesquisa
            rs = stmt.executeQuery(sql);

            //Cria looping com a resposta
            while(rs.next()) {
                resp += "<tr>\n";
                resp += " <td class='tdLight' align='center'>\n";
                resp += "   <input type='checkbox' name='chk' id='chk" + rs.getString("cod_hist_proced") + "' value='" + rs.getString("cod_hist_proced") + "'>";
                resp += " </td>\n";
                resp += " <td class='tdLight'>\n";
                resp += "[" + rs.getString("CODIGO") + "] " + rs.getString("Procedimento");
                resp += " </td>\n";
                resp += "</tr>\n";
            }
            rs.close();

            stmt.close();
        } catch(SQLException e) {
            resp += e.toString();
        }

        return resp;
    }
    
    //Retorna os medicamentos de uma determinada história
    //tipo 1-em options, 2-em lista
    public String getMedicamentos(String cod_hist, String codcli, int tipo) {
        String resp = "";
        String sql = "";
        ResultSet rs = null;
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            //Se veio história, pegar medicamentos dessa história
            if(!Util.isNull(cod_hist)) {

                //Campos a pesquisar na tabela
                sql += "SELECT medicamentos.cod_comercial, medicamentos.comercial, hist_medicamento.indicacao ";
                sql += "FROM medicamentos INNER JOIN hist_medicamento ";
                sql += "ON medicamentos.cod_comercial = hist_medicamento.cod_comercial ";
                sql += "WHERE hist_medicamento.cod_hist=" + cod_hist;
                sql += " ORDER BY cod_hist_med";

                //Executa a pesquisa
                rs = stmt.executeQuery(sql);

                //Cria looping com a resposta
                while(rs.next()) {
                    if(tipo == 1) {
                        resp += "<option value='" + rs.getString("cod_comercial");
                        resp += "'>" + rs.getString("comercial") + "</option>\n";
                    } else if(tipo == 2) {
                        resp += "<li>" + rs.getString("comercial") + " - " + Util.trataNulo(rs.getString("indicacao"),"").replace("<br>", " - ") + "</li>";
                    }
                }
            }
            //Buscar medicamentos de uso contínuo na última história
            else {
                sql += "SELECT medicamentos.cod_comercial, medicamentos.comercial, hist_medicamento.cod_hist ";
                sql += "FROM hist_medicamento INNER JOIN medicamentos ON hist_medicamento.cod_comercial = medicamentos.cod_comercial ";
                sql += "WHERE medicamentos.flag=1 AND (hist_medicamento.cod_hist) = (";
                sql += "SELECT cod_hist FROM historia WHERE codcli=" + codcli + " ORDER BY DTACON DESC, HORA DESC LIMIT 1)";
                
                //Executa a pesquisa
                rs = stmt.executeQuery(sql);
                
                //Cria looping com a resposta
                while(rs.next()) {
                    if(tipo == 1) {
                        resp += "<option value='" + rs.getString("cod_comercial");
                        resp += "'>" + rs.getString("comercial") + "</option>\n";
                    } else {
                        resp += "<li>" + rs.getString("comercial") + "</li>\n";
                    }
                }
            }
            
            rs.close();
            stmt.close();
        } catch(SQLException e) {
            resp += e.toString();
        }
        
        return resp;
    }
    
    //Retorna os medicamentos de uma determinada história
    public String getMedicamentosHist(String cod_hist, String codcli) {
        return getMedicamentos(cod_hist, codcli, 1);
    }
    
    
    //Recupera a quantidade de alertas do paciente
    public String getAlertas(String codcli) {
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

        /* de: data início da pesquisa
        * ate: data fim da pesquisa
        * ordem: ordem de resposta dos campos
        * numPag: número da página selecionada (paginação)
        * qtdeporpagina: quantidade de registros por página
        * cod_empresa: código da empresa logada
        */
    public String[] getHistoriasPorPeriodo(String de, String ate, String ordem, int numPag, int qtdeporpagina, String cod_empresa) {
        String resp[] = {"",""};
        String sql = "";
        ResultSet rs = null;
        
        //Formata as datas
        de = Util.formataDataInvertida(de);
        ate = Util.formataDataInvertida(ate);
        
        //Busca os históricos
        sql  = "SELECT paciente.nome, historia.DTACON, profissional.nome, paciente.codcli ";
        sql += "FROM (historia INNER JOIN paciente ON historia.codcli = paciente.codcli) ";
        sql += "INNER JOIN profissional ON historia.PROF_REG = profissional.prof_reg ";
        sql += "WHERE DTACON BETWEEN '" + de + "' AND '" + ate + "' ";
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
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
            resp[1] = Util.criaPaginacao("buscarhistoricos.jsp", numPag, qtdeporpagina, numRows);
            
            //Limita para uma quantidade de registros
            sql += " LIMIT " + ((numPag-1)*qtdeporpagina) + "," + qtdeporpagina;
           
            //Executa a pesquisa novamente com o limitador
            rs = stmt.executeQuery(sql);
            
            //Cria looping com a resposta
            while(rs.next()) {
                resp[0] += "<tr onClick=\"escolher(" + rs.getString("codcli") + ",'" + rs.getString("paciente.nome") + "')\" onMouseOver='trocaCor(this,1);' onMouseOut='trocaCor(this,2);'>";
                resp[0] += "<td class='tdLight'>" + rs.getString("paciente.nome") + "&nbsp;</td>\n";
                resp[0] += "<td width='80' class='tdLight'>" + Util.formataData(rs.getString("DTACON")) + "&nbsp;</td>\n";
                resp[0] += "<td width='230' class='tdLight'>" + rs.getString("profissional.nome") + "&nbsp;</td>\n";
                resp[0] += "</tr>";
            }
            
            //Se não retornar resposta, montar mensagem de não encontrado
            if(resp[0].equals("")) {
                resp[0] += "<tr>";
                resp[0] += "<td colspan='3' width='600' class='tdLight'>";
                resp[0] += "Nenhum registro encontrado para o período";
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

    //Altera o status da agenda para 9 (atendido)
    public String atualizaAgenda(String codcli, String data, String prof_reg) {
        String sql = "";
            
        //atualiza tabela
        sql += "UPDATE agendamento SET status=9 WHERE codcli=" + codcli;
        sql += " AND data='" + data + "' AND prof_reg='" + prof_reg + "'";
        sql += " AND ativo='S'";

        //Retorna o resultado do script
        return new Banco().executaSQL(sql);
    }
    
    //Pega os dados de uma SDAT para solicitação
    public GuiaSADT getDadosSADT(String cod_hist) {
        String sql = "";
        GuiaSADT resp = new GuiaSADT();
        ResultSet rs = null;

        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            sql += "SELECT convenio.cod_ans, historia.DTACON, historia.prof_reg, paciente_convenio.num_associado_convenio, ";
            sql += "planos.plano, paciente_convenio.validade_carteira, paciente_convenio.cod_convenio, paciente.nome, paciente.cartao_sus, ";
            sql += "convenio.identificadoroperadora, profissional.nome, profissao.tipo_registro, paciente.cod_empresa, ";
            sql += "profissional.ufConselho, profissional.reg_prof, diagnosticos.CID, profissao.codCBOS ";
            sql += "FROM (((((((((historia INNER JOIN profissional ON historia.PROF_REG = profissional.prof_reg) ";
            sql += "INNER JOIN paciente ON historia.codcli = paciente.codcli) LEFT JOIN paciente_convenio ON ";
            sql += "paciente.codcli = paciente_convenio.codcli) LEFT JOIN convenio ON ";
            sql += "paciente_convenio.cod_convenio = convenio.cod_convenio) LEFT JOIN planos ON ";
            sql += "paciente_convenio.cod_plano = planos.cod_plano) LEFT JOIN prof_esp ON ";
            sql += "profissional.prof_reg = prof_esp.prof_reg) LEFT JOIN especialidade ON ";
            sql += "prof_esp.codesp = especialidade.codesp) LEFT JOIN profissao ON ";
            sql += "especialidade.cod_profis = profissao.cod_profis) LEFT JOIN hist_diagnostico ON ";
            sql += "historia.cod_hist = hist_diagnostico.cod_hist) LEFT JOIN diagnosticos ON ";
            sql += "hist_diagnostico.cod_diag = diagnosticos.cod_diag ";
            sql += "WHERE historia.cod_hist=" + cod_hist;
            sql += " GROUP BY convenio.cod_ans, historia.DTACON, paciente_convenio.num_associado_convenio, ";
            sql += "planos.plano, paciente_convenio.validade_carteira, paciente.nome, paciente.cartao_sus, ";
            sql += "convenio.identificadoroperadora, profissional.nome, profissao.tipo_registro, ";
            sql += "profissional.ufConselho, profissional.reg_prof, diagnosticos.CID, historia.cod_hist ";
            
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            //Se contou
            if(rs.next()) {
                resp.setCartaoSUS(Util.trataNulo(rs.getString("cartao_sus"),""));
                resp.setCarteira(Util.trataNulo(rs.getString("num_associado_convenio"),""));
                resp.setCbos(Util.trataNulo(rs.getString("codCBOS"),""));
                resp.setCid10(Util.trataNulo(rs.getString("CID"),""));
                resp.setCodANS(Util.trataNulo(rs.getString("cod_ans"),""));
                resp.setConselho(Util.trataNulo(rs.getString("tipo_registro"),""));
                resp.setData(Util.trataNulo(Util.formataData(rs.getString("DTACON")),""));
                resp.setNumeroConselho(Util.trataNulo(rs.getString("reg_prof"),""));
                resp.setPaciente(Util.trataNulo(rs.getString("paciente.nome"),""));
                resp.setPlano(Util.trataNulo(rs.getString("plano"),""));
                resp.setSolicitante(Util.trataNulo(rs.getString("profissional.nome"),""));
                resp.setUfConselho(Util.trataNulo(rs.getString("ufConselho"),""));
                resp.setValidade(Util.trataNulo(Util.formataData(rs.getString("validade_carteira")),""));

                //Identifica o prestador (se estiver cadastrado como pessoa física, pega dados, senão é PJ)
                String pf = new TISS().getCodProfissional(rs.getString("prof_reg"), rs.getString("cod_convenio"));
                if(Util.isNull(pf)) { //PJ
                    resp.setContratado(new Configuracao().getItemConfig("nomeContratado", rs.getString("cod_empresa")));
                    resp.setCodNaOperadora(Util.trataNulo(rs.getString("identificadoroperadora"),""));
                }
                else {
                    resp.setContratado(Util.trataNulo(rs.getString("profissional.nome"),""));
                    resp.setCodNaOperadora(pf);
                }
            }
            
            rs.close();
            stmt.close();
            
            return resp;
        } catch(SQLException e) {
            resp.setPaciente("ERRO: " + e.toString() + " SQL: " + sql);
            
            return resp;
        }
    }
 
    //Busca os procedimentos de uma guia SADT
    public String getProcedimentosSolicitados(String cod_hist, String chk[]) {
        String resp = "";
        String sql = "";
        ResultSet rs = null;
        
        //Converte o vetor em String
        String proceds = Util.vetorToString(chk);

        //Busca os procedimentos selecionados
        sql += "SELECT procedimentos.Procedimento, procedimentos.CODIGO ";
        sql += "FROM hist_procedimento INNER JOIN procedimentos ON ";
        sql += "hist_procedimento.cod_proced = procedimentos.COD_PROCED ";
        sql += "WHERE hist_procedimento.cod_hist=" + cod_hist;
        sql += " AND hist_procedimento.cod_hist_proced IN(" + proceds + ")";
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            //Cria looping com a resposta
            while(rs.next()) {
                resp += "<tr>\n";
                resp += " <td class='texto'>&nbsp;</td>\n";
                resp += " <td class='texto'>" + rs.getString("codigo") + "</td>\n";
                resp += " <td class='texto'>" + rs.getString("Procedimento") + "</td>\n";
                resp += " <td class='texto'>1</td>\n";
                resp += " <td class='texto'>&nbsp;</td>\n";
                resp += "</tr>\n";
            }
            
            rs.close();
            stmt.close();
            return resp;
            
        } catch(SQLException e) {
            resp = "ERRO: " + e.toString() + " SQL:" + sql;
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
    public String[] getTiposHistoria(String pesquisa, String campo, String ordem, int numPag, int qtdeporpagina, int tipo, String cod_empresa) {
        String resp[] = {"",""};
        String sql = "";
        ResultSet rs = null;
        
        //Limpa espaços em branco antes e depois da pesquisa
        pesquisa = pesquisa.trim();
        
        sql += "SELECT * FROM tiposhistoria ";
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
            resp[1] = Util.criaPaginacao("tiposhistoria.jsp", numPag, qtdeporpagina, numRows);
            
            //Limita para uma quantidade de registros
            sql += " LIMIT " + ((numPag-1)*qtdeporpagina) + "," + qtdeporpagina;
             
            //Executa a pesquisa novamente com o limitador
            rs = stmt.executeQuery(sql);
            
              //Cria looping com a resposta
            while(rs.next()) {
                
                resp[0] += "<tr onClick=go('tiposhistoria.jsp?cod=" + rs.getString("cod_tipohistoria") + "') onMouseOver='trocaCor(this,1);' onMouseOut='trocaCor(this,2);'>";
                resp[0] += "  <td width='100%' class='tdLight'>" + rs.getString("descricao") + "&nbsp;</td>\n";
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
            resp[0] = "Erro:" + e.toString();
            return resp;
        }
    }
    
    //Retorna os tipos de história
    public String getTiposHistoria(String cod_empresa) {
        String resp = "";
        String sql = "";
        ResultSet rs = null;
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            //Campos a pesquisar na tabela
            sql += "SELECT * ";
            sql += "FROM tiposhistoria ";
            sql += "WHERE cod_empresa=" + cod_empresa;
            sql += " ORDER BY descricao";

            //Executa a pesquisa
            rs = stmt.executeQuery(sql);

            //Cria looping com a resposta
            while(rs.next()) {
                    resp += "<option value='" + rs.getString("cod_tipohistoria");
                    resp += "'>" + rs.getString("descricao") + "</option>\n";
            }
            
            rs.close();
            stmt.close();
            
            return resp;
        } catch(SQLException e) {
            return "ERRO: " + e.toString() + " SQL: " + sql;
        }
        
    }
    
    //Retorna os tipos de história
    public String getTiposHistoriaView(String cod_empresa) {
        String resp = "";
        String sql = "";
        ResultSet rs = null;
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            //Campos a pesquisar na tabela
            sql += "SELECT * ";
            sql += "FROM tiposhistoria ";
            sql += "WHERE cod_empresa=" + cod_empresa;
            sql += " ORDER BY descricao";

            //Executa a pesquisa
            rs = stmt.executeQuery(sql);

            resp = "<table cellspacing='0' cellpadding='0'>\n";
            resp += "<tr>\n";
            resp += "  <td class='texto'>Padrão&nbsp;&nbsp;</td>\n";
            resp += "  <td class='tdDark' style='width:20px; border:0px; padding:0px'>&nbsp;</td>\n";
            
            //Cria looping com a resposta
            while(rs.next()) {
                    resp += "  <td class='texto'>&nbsp;&nbsp;" + rs.getString("descricao") + "&nbsp;&nbsp;</td>\n";
                    resp += "  <td class='texto' style='width:20px; background-color:" + rs.getString("cor") + "'>&nbsp;</td>\n";
            }
            
            resp += "</tr>\n";
            resp += "</table>\n";
            
            rs.close();
            stmt.close();
            
            return resp;
        } catch(SQLException e) {
            return "ERRO: " + e.toString() + " SQL: " + sql;
        }
        
    }
    
    public static void main(String args[]) {
        Historico h = new Historico();
        Vector teste = h.getHistorias("19","DESC", "#FF9900");
    }
    
}