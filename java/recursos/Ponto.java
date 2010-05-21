/* Arquivo: Ponto.java
 * Autor: Amilton Souza Martha
 * Criação: 20/04/2006   Atualização: 05/03/2008
 * Obs: Manipula as informações de ponto do usuário
 */

package recursos;
import java.sql.*;
import java.util.*;

public class Ponto {
    
    //Atributos privados para conexão
    private Connection con = null;
    private Statement stmt = null;
    
    public Ponto() {
        con = Conecta.getInstance();
    }
    
    
    //Registra o ponto do usuário
    public String registraPonto(String cod_barras, String usuario_logado) {
        String sql = "";
        String nome = "", msg = "";
        String ret = "";
        
        //Pega data e hora atual do servidor
        String data = Util.getData();
        String hora = Util.getHora();
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement();
            
            //Busca os dados do usuário logado para ver se o código de barras confere
            sql = "SELECT cod_barra, cd_usuario, ds_nome FROM t_usuario WHERE cd_usuario = " + usuario_logado;
            ResultSet rs = stmt.executeQuery(sql);
            
            //Se achou, verificar se bate o código de barras
            if(rs.next()) {
                nome   = rs.getString("ds_nome");
                
                //Se achou, mas não bate com o usuário, retornar
                if(!cod_barras.equalsIgnoreCase(rs.getString("cod_barra")))
                    return "Código de barras não corresponde ao usuário logado no sistema.";
            }
            
            //Procura se já existe ponto para o dia
            sql  = "SELECT * FROM ponto WHERE data = '" + Util.formataDataInvertida(data) + "'";
            sql += " AND cd_usuario=" + usuario_logado;
            rs = stmt.executeQuery(sql);
            
            //Se existir, verifica se existe hora de entrada
            if(rs.next()) {
                //Se não existir saida1, registrar como saída
                if(rs.getString("saida1")==null) {
                    //Se intervalo menor que 15 minutos, não lançar
                    if(getIntervalo(rs.getString("entrada1"),hora) < 15) {
                        msg = "Intervalo entre entrada e saída é menor que 15 minutos. Lançamento não executado";
                    } else {
                        sql  = "UPDATE ponto SET saida1='" + hora + "' WHERE data = '" + Util.formataDataInvertida(data) + "'";
                        sql += " AND cd_usuario=" + usuario_logado;
                        new Banco().executaSQL(sql);
                        stmt.close();
                        msg = "Lançamento em " + data + " às " + hora + " efetuado na hora de saída para o almoço";
                    }
                }
                //Se não existir entrada2, registrar como entrada
                else if(rs.getString("entrada2")==null) {
                    //Se intervalo menor que 15 minutos, não lançar
                    if(getIntervalo(rs.getString("saida1"),hora) < 15) {
                        msg = "Intervalo entre saída e entrada é menor que 15 minutos. Lançamento não executado";
                    } else {
                        sql = "UPDATE ponto SET entrada2='" + hora + "' WHERE data = '" + Util.formataDataInvertida(data) + "'";
                        sql += " AND cd_usuario=" + usuario_logado;
                        new Banco().executaSQL(sql);
                        stmt.close();
                        msg =  "Lançamento em " + data + " às " + hora + " efetuado na hora de entrada do almoço";
                    }
                }
                //Se não existir saida2, registra como saída
                else if(rs.getString("saida2")==null) {
                    //Se intervalo menor que 15 minutos, não lançar
                    if(getIntervalo(rs.getString("entrada2"),hora) < 15) {
                        msg = "Intervalo entre entrada e saída é menor que 15 minutos. Lançamento não executado";
                    } else {
                        sql = "UPDATE ponto SET saida2='" + hora + "' WHERE data = '" + Util.formataDataInvertida(data) + "'";
                        sql += " AND cd_usuario=" + usuario_logado;
                        new Banco().executaSQL(sql);
                        stmt.close();
                        msg = "Lançamento em " + data + " às " + hora + " efetuado na hora de saída do dia";
                    }
                }
                //Senão, o dia inteiro já foi lançado
                else {
                    stmt.close();
                    msg = "Já foram computadas todas as entradas e saídas para o dia " + data;
                }
                
                msg += " para o usuário '" + nome + "'";
                return msg;
                
            }
            
            //Se não existir, cadastrar ponto novo, lançar na entrada1
            else {
                sql =  "INSERT INTO ponto(cd_usuario, data, entrada1) VALUES(";
                sql += usuario_logado + ",'" + Util.formataDataInvertida(data) + "','";
                sql += hora + "')";
                
                new Banco().executaSQL(sql);
                stmt.close();
                msg =  "Lançamento em " + data + " às " + hora + " efetuado na hora de entrada do dia";
            }
            
            msg += " para o usuário '" + nome + "'";
            return msg;
        } catch(SQLException e) {
            return e.toString();
        }
    }
    
    //Calcula a diferente entre duas horas
    private int getIntervalo(String hora1, String hora2) {
        int h1, m1, h2, m2, dif;
        
        h1 = Integer.parseInt(hora1.substring(0,2));
        m1 = Integer.parseInt(hora1.substring(3,5));
        h2 = Integer.parseInt(hora2.substring(0,2));
        m2 = Integer.parseInt(hora2.substring(3,5));
        
        dif = ((h2 * 60) + m2) - ((h1*60) + m1);
        
        return dif;
        
    }
    
    //Devolve todos os usuário cadastrados de uma empresa
    public String getUsuarios(String usuario, String cod_empresa) {
        String resp = "";
        String sql = "";
        ResultSet rs = null;
        String sel = "";
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            //Valores a pegar do banco (menos administrador geral)
            sql  = "SELECT t_usuario.* FROM t_usuario ";
            sql += "INNER JOIN t_grupos ON t_usuario.ds_grupo = ";
            sql += "t_grupos.grupo_id WHERE cd_usuario > 1 ";
            sql += "AND t_grupos.cod_empresa=" + cod_empresa;
            sql += " AND t_usuario.ativo='S'";
            sql += " ORDER BY ds_nome";
            
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            //Cria looping com a resposta
            while(rs.next()) {
                if(usuario != null && usuario.equals(rs.getString("cd_usuario")))
                    sel = " selected";
                else
                    sel = "";
                
                resp += "<option value='" + rs.getString("cd_usuario") + "'" + sel + ">" + rs.getString("ds_nome") + "</option>\n";
            }
            
            rs.close();
            stmt.close();
            
            return resp;
        } catch(SQLException e) {
            return "Ocorreu um erro: " + e.toString();
        }
    }
    
    //Devolve todos os usuário cadastrados
    public Vector getLancamentos(String usuario, String mes, String ano) {
        Vector ret = new Vector();
        String resp = "";
        String sql = "";
        ResultSet rs = null;
        String sel = "";
        String e1, s1, e2, s2, difS;
        String cabecalho = "";
        int soma = 0, dif = 0;
        String data = "";
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            //Cabeçalho da tabela
            cabecalho += "<tr>";
            cabecalho += "  <td class='tdMedium'>Data</td>";
            cabecalho += "  <td class='tdMedium'>Entrada</td>";
            cabecalho += "  <td class='tdMedium'>Saída</td>";
            cabecalho += "  <td class='tdMedium'>Entrada</td>";
            cabecalho += "  <td class='tdMedium'>Saída</td>";
            cabecalho += "  <td class='tdMedium'>Período</td>";
            cabecalho += "  <td width='5' class='tdMedium'>&nbsp;</td>";
            cabecalho += "  <td class='tdMedium'>Data</td>";
            cabecalho += "  <td class='tdMedium'>Entrada</td>";
            cabecalho += "  <td class='tdMedium'>Saída</td>";
            cabecalho += "  <td class='tdMedium'>Entrada</td>";
            cabecalho += "  <td class='tdMedium'>Saída</td>";
            cabecalho += "  <td class='tdMedium'>Período</td>";
            cabecalho += "</tr>";
            
            ret.add(cabecalho);
            
            //Cria looping com a resposta
            for(int dia=1; dia<=16; dia++) {
                
                data = Util.formataData(dia, Integer.parseInt(mes), Integer.parseInt(ano));
                
                //Pega primeira quinzena
                sql  = "SELECT * FROM ponto WHERE cd_usuario=" + usuario;
                sql += " AND data='" + ano + "-" + mes + "-" + dia + "'";
                
                //Executa a pesquisa
                rs = stmt.executeQuery(sql);
                
                //Se achou a data, colocar
                if(rs.next()) {
                    e1 = "<input onKeyPress=\"return formatar(this, event, '##:##'); \" type='text' onBlur=\"Javascript:alterarPonto(this,'entrada1','" + Util.formataHora(rs.getString("entrada1")) + "'," + usuario + ",'" + data + "')\" class='caixa' size='5' maxlength='5' value='" + Util.formataHora(rs.getString("entrada1")) + "'>";
                    s1 = "<input onKeyPress=\"return formatar(this, event, '##:##'); \" type='text' onBlur=\"Javascript:alterarPonto(this,'saida1','" + Util.formataHora(rs.getString("saida1")) + "'," + usuario + ",'" + data + "')\" class='caixa' size='5' maxlength='5' value='" + Util.formataHora(rs.getString("saida1")) + "'>";
                    e2 = "<input onKeyPress=\"return formatar(this, event, '##:##'); \" type='text' onBlur=\"Javascript:alterarPonto(this,'entrada2','" + Util.formataHora(rs.getString("entrada2")) + "'," + usuario + ",'" + data + "')\" class='caixa' size='5' maxlength='5' value='" + Util.formataHora(rs.getString("entrada2")) + "'>";
                    s2 = "<input onKeyPress=\"return formatar(this, event, '##:##'); \" type='text' onBlur=\"Javascript:alterarPonto(this,'saida2','" + Util.formataHora(rs.getString("saida2")) + "'," + usuario + ",'" + data + "')\" class='caixa' size='5' maxlength='5' value='" + Util.formataHora(rs.getString("saida2")) + "'>";
                     
                    if(s1.equals(""))
                        dif = 0;
                    else if(s2.equals(""))
                        dif = Util.emMinutos(Util.formataHora(rs.getString("saida1"))) - Util.emMinutos(Util.formataHora(rs.getString("entrada1")));
                    else
                        dif = (Util.emMinutos(Util.formataHora(rs.getString("saida1"))) - Util.emMinutos(Util.formataHora(rs.getString("entrada1")))) + (Util.emMinutos(Util.formataHora(rs.getString("saida2"))) - Util.emMinutos(Util.formataHora(rs.getString("entrada2"))));
                    
                    difS = Util.emHoras(dif);
                    soma += dif;
                } else {
                   if(Util.dataValida(dia, Integer.parseInt(mes), Integer.parseInt(ano))) {
                        e1 = "<input onKeyPress=\"return formatar(this, event, '##:##'); \" type='text' onBlur=\"Javascript:alterarPonto(this,'entrada1',''," + usuario + ",'" + data + "')\" class='caixa' size='5' maxlength='5'>";
                        s1 = "<input onKeyPress=\"return formatar(this, event, '##:##'); \" type='text' onBlur=\"Javascript:alterarPonto(this,'saida1',''," + usuario + ",'" + data + "')\" class='caixa' size='5' maxlength='5'>";
                        e2 = "<input onKeyPress=\"return formatar(this, event, '##:##'); \" type='text' onBlur=\"Javascript:alterarPonto(this,'entrada2',''," + usuario + ",'" + data + "')\" class='caixa' size='5' maxlength='5'>";
                        s2 = "<input onKeyPress=\"return formatar(this, event, '##:##'); \" type='text' onBlur=\"Javascript:alterarPonto(this,'saida2',''," + usuario + ",'" + data + "')\" class='caixa' size='5' maxlength='5'>";
                    }
                    else {
                        e1 = s1 = e2 = s2 = "&nbsp;";
                    }
                   difS = "&nbsp;";
                }
                
                resp = "";
                resp += "<tr>\n";
                
                resp += "  <td class='tdLight'>" + data + "&nbsp;</td>\n";
                resp += "  <td class='tdLight'>" + e1 + "&nbsp;</td>\n";
                resp += "  <td class='tdLight'>" + s1 + "&nbsp;</td>\n";
                resp += "  <td class='tdLight'>" + e2 + "&nbsp;</td>\n";
                resp += "  <td class='tdLight'>" + s2 + "&nbsp;</td>\n";
                resp += "  <td class='tdLight'>" + difS + "</td>\n";
               
                //Pega segunda quinzena
                sql  = "SELECT * FROM ponto WHERE cd_usuario=" + usuario;
                sql += " AND data='" + ano + "-" + mes + "-" + (dia+16) + "'";
                
                //Data
                data = Util.formataData(dia+16, Integer.parseInt(mes), Integer.parseInt(ano));

                //Executa a pesquisa
                rs = stmt.executeQuery(sql);
                
                //Se achou a data, colocar
                if(rs.next()) {
                    e1 = "<input onKeyPress=\"return formatar(this, event, '##:##'); \" type='text' onBlur=\"Javascript:alterarPonto(this,'entrada1','" + Util.formataHora(rs.getString("entrada1")) + "'," + usuario + ",'" + data + "')\" class='caixa' size='5' maxlength='5' value='" + Util.formataHora(rs.getString("entrada1")) + "'>";
                    s1 = "<input onKeyPress=\"return formatar(this, event, '##:##'); \" type='text' onBlur=\"Javascript:alterarPonto(this,'saida1','" + Util.formataHora(rs.getString("saida1")) + "'," + usuario + ",'" + data + "')\" class='caixa' size='5' maxlength='5' value='" + Util.formataHora(rs.getString("saida1")) + "'>";
                    e2 = "<input onKeyPress=\"return formatar(this, event, '##:##'); \" type='text' onBlur=\"Javascript:alterarPonto(this,'entrada2','" + Util.formataHora(rs.getString("entrada2")) + "'," + usuario + ",'" + data + "')\" class='caixa' size='5' maxlength='5' value='" + Util.formataHora(rs.getString("entrada2")) + "'>";
                    s2 = "<input onKeyPress=\"return formatar(this, event, '##:##'); \" type='text' onBlur=\"Javascript:alterarPonto(this,'saida2','" + Util.formataHora(rs.getString("saida2")) + "'," + usuario + ",'" + data + "')\" class='caixa' size='5' maxlength='5' value='" + Util.formataHora(rs.getString("saida2")) + "'>";
                       
                    if(s1.equals(""))
                        dif = 0;
                    else if(s2.equals(""))
                        dif = Util.emMinutos(Util.formataHora(rs.getString("saida1"))) - Util.emMinutos(Util.formataHora(rs.getString("entrada1")));
                    else
                        dif = (Util.emMinutos(Util.formataHora(rs.getString("saida1"))) - Util.emMinutos(Util.formataHora(rs.getString("entrada1")))) + (Util.emMinutos(Util.formataHora(rs.getString("saida2"))) - Util.emMinutos(Util.formataHora(rs.getString("entrada2"))));
                    
                    difS = Util.emHoras(dif);
                    soma += dif;
                } else {
                    if(Util.dataValida(dia+16, Integer.parseInt(mes), Integer.parseInt(ano))) {
                        e1 = "<input onKeyPress=\"return formatar(this, event, '##:##'); \" type='text' onBlur=\"Javascript:alterarPonto(this,'entrada1',''," + usuario + ",'" + data + "')\" class='caixa' size='5' maxlength='5'>";
                        s1 = "<input onKeyPress=\"return formatar(this, event, '##:##'); \" type='text' onBlur=\"Javascript:alterarPonto(this,'saida1',''," + usuario + ",'" + data + "')\" class='caixa' size='5' maxlength='5'>";
                        e2 = "<input onKeyPress=\"return formatar(this, event, '##:##'); \" type='text' onBlur=\"Javascript:alterarPonto(this,'entrada2',''," + usuario + ",'" + data + "')\" class='caixa' size='5' maxlength='5'>";
                        s2 = "<input onKeyPress=\"return formatar(this, event, '##:##'); \" type='text' onBlur=\"Javascript:alterarPonto(this,'saida2',''," + usuario + ",'" + data + "')\" class='caixa' size='5' maxlength='5'>";
                      }
                    else {
                        e1 = s1 = e2 = s2 = "&nbsp;";
                    }
                    difS = "&nbsp;";
                }
                
                resp += "  <td width='5' class='tdMedium'>&nbsp;</td>";
                resp += "  <td class='tdLight'>" + data + "&nbsp;</td>\n";
                resp += "  <td class='tdLight'>" + e1 + "&nbsp;</td>\n";
                resp += "  <td class='tdLight'>" + s1 + "&nbsp;</td>\n";
                resp += "  <td class='tdLight'>" + e2 + "&nbsp;</td>\n";
                resp += "  <td class='tdLight'>" + s2 + "&nbsp;</td>\n";
                resp += "  <td class='tdLight'>" + difS + "</td>\n";
                
                resp += "</tr>\n";
                
                //Adiciona linha no retorno
                ret.add(resp);
            }
            
            resp =  "<tr>\n";
            resp += "  <td colspan=12 class='tdMedium' align='right'>Total do Período: </td>\n";
            resp += "  <td class='tdMedium'>" + Util.emHoras(soma) + "</td>\n";
            resp +=  "</tr>\n";
            
            //Adiciona linha no retorno
            ret.add(resp);
            
            rs.close();
            stmt.close();
            
            return ret;
        } catch(SQLException e) {
            ret.add("Ocorreu um erro: " + e.toString() + " SQL=" + sql);
            return ret;
        }
    }

    //Atualiza o ponto
    public String atualizaPonto(String hora, String campo, String usuario, String data) {
        String sql = "";
        ResultSet rs = null;
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement();
            
            sql = "SELECT * FROM ponto WHERE cd_usuario=" + usuario + " AND data='" + Util.formataDataInvertida(data) + "'";
   
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            //Cria looping com a resposta
            if(rs.next()) {
                sql = "UPDATE ponto SET " + campo + "='" + hora + "' WHERE cd_usuario=" + usuario + " AND data='" + Util.formataDataInvertida(data) + "'";
            }
            else {
                sql = "INSERT INTO ponto(cd_usuario, data, " + campo + ") VALUES(";
                sql += usuario + ",'" + Util.formataDataInvertida(data) + "','" + hora + "')";
            }
            
            rs.close();
            stmt.close();
            
            //Retorna o resultado do script
            return new Banco().executaSQL(sql);

        } catch(SQLException e) {
            return "Erro:" + e.toString() + " SQL:" + sql;
        }
    }        
    
   //Devolve todos os usuário cadastrados
   public Vector getLancamentosIndividual(String usuario, String mes, String ano) {
        Vector ret = new Vector();
        String resp = "";
        String sql = "";
        ResultSet rs = null;
        String sel = "";
        String e1, s1, e2, s2, difS;
        String cabecalho = "";
        int soma = 0, dif = 0;
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            //Cabeçalho da tabela
            cabecalho += "<tr>";
            cabecalho += "  <td class='tdMedium'  style='font-size:10px; padding:2px'>Data</td>";
            cabecalho += "  <td class='tdMedium'  style='font-size:10px; padding:2px'>Entrada</td>";
            cabecalho += "  <td class='tdMedium'  style='font-size:10px; padding:2px'>Saída</td>";
            cabecalho += "  <td class='tdMedium'  style='font-size:10px; padding:2px'>Entrada</td>";
            cabecalho += "  <td class='tdMedium'  style='font-size:10px; padding:2px'>Saída</td>";
            cabecalho += "  <td class='tdMedium'  style='font-size:10px; padding:2px'>Período</td>";
            cabecalho += "  <td width='5' class='tdMedium'>&nbsp;</td>";
            cabecalho += "  <td class='tdMedium'  style='font-size:10px; padding:2px'>Data</td>";
            cabecalho += "  <td class='tdMedium'  style='font-size:10px; padding:2px'>Entrada</td>";
            cabecalho += "  <td class='tdMedium'  style='font-size:10px; padding:2px'>Saída</td>";
            cabecalho += "  <td class='tdMedium'  style='font-size:10px; padding:2px'>Entrada</td>";
            cabecalho += "  <td class='tdMedium'  style='font-size:10px; padding:2px'>Saída</td>";
            cabecalho += "  <td class='tdMedium'  style='font-size:10px; padding:2px'>Período</td>";
            cabecalho += "</tr>";
            
            ret.add(cabecalho);
            
            //Cria looping com a resposta
            for(int dia=1; dia<=16; dia++) {
                
                //Pega primeira quinzena
                sql  = "SELECT * FROM ponto WHERE cd_usuario=" + usuario;
                sql += " AND data='" + ano + "-" + mes + "-" + dia + "'";
                
                //Executa a pesquisa
                rs = stmt.executeQuery(sql);
                
                //Se achou a data, colocar
                if(rs.next()) {
                    e1 = Util.formataHora(rs.getString("entrada1"));
                    s1 = Util.formataHora(rs.getString("saida1"));
                    e2 = Util.formataHora(rs.getString("entrada2"));
                    s2 = Util.formataHora(rs.getString("saida2"));
                    
                    if(s1.equals(""))
                        dif = 0;
                    else if(s2.equals(""))
                        dif = Util.emMinutos(s1) - Util.emMinutos(e1);
                    else
                        dif = (Util.emMinutos(s1) - Util.emMinutos(e1)) + (Util.emMinutos(s2) - Util.emMinutos(e2));
                    
                    difS = Util.emHoras(dif);
                    soma += dif;
                } else {
                    e1 = s1 = e2 = s2 = "&nbsp;";
                    difS = "&nbsp;";
                }
                
                resp = "";
                resp += "<tr>\n";
                
                resp += "  <td class='tdLight'  style='font-size:10px; padding:2px'>" + Util.formataData(dia, Integer.parseInt(mes), Integer.parseInt(ano)) + "&nbsp;</td>\n";
                resp += "  <td class='tdLight'  style='font-size:10px; padding:2px'>" + e1 + "&nbsp;</td>\n";
                resp += "  <td class='tdLight'  style='font-size:10px; padding:2px'>" + s1 + "&nbsp;</td>\n";
                resp += "  <td class='tdLight'  style='font-size:10px; padding:2px'>" + e2 + "&nbsp;</td>\n";
                resp += "  <td class='tdLight'  style='font-size:10px; padding:2px'>" + s2 + "&nbsp;</td>\n";
                resp += "  <td class='tdLight'  style='font-size:10px; padding:2px'>" + difS + "</td>\n";
                
                //Pega segunda quinzena
                sql  = "SELECT * FROM ponto WHERE cd_usuario=" + usuario;
                sql += " AND data='" + ano + "-" + mes + "-" + (dia+16) + "'";
                
                //Executa a pesquisa
                rs = stmt.executeQuery(sql);
                
                //Se achou a data, colocar
                if(rs.next()) {
                    e1 = Util.formataHora(rs.getString("entrada1"));
                    s1 = Util.formataHora(rs.getString("saida1"));
                    e2 = Util.formataHora(rs.getString("entrada2"));
                    s2 = Util.formataHora(rs.getString("saida2"));
                    
                    if(s1.equals(""))
                        dif = 0;
                    else if(s2.equals(""))
                        dif = Util.emMinutos(s1) - Util.emMinutos(e1);
                    else
                        dif = (Util.emMinutos(s1) - Util.emMinutos(e1)) + (Util.emMinutos(s2) - Util.emMinutos(e2));
                    
                    difS = Util.emHoras(dif);
                    soma += dif;
                } else {
                    e1 = s1 = e2 = s2 = "&nbsp;";
                    difS = "&nbsp;";
                }
                
                resp += "  <td width='5' class='tdMedium'>&nbsp;</td>";
                resp += "  <td class='tdLight'  style='font-size:10px; padding:2px'>" + Util.formataData(dia+16, Integer.parseInt(mes), Integer.parseInt(ano)) + "&nbsp;</td>\n";
                resp += "  <td class='tdLight'  style='font-size:10px; padding:2px'>" + e1 + "&nbsp;</td>\n";
                resp += "  <td class='tdLight'  style='font-size:10px; padding:2px'>" + s1 + "&nbsp;</td>\n";
                resp += "  <td class='tdLight'  style='font-size:10px; padding:2px'>" + e2 + "&nbsp;</td>\n";
                resp += "  <td class='tdLight'  style='font-size:10px; padding:2px'>" + s2 + "&nbsp;</td>\n";
                resp += "  <td class='tdLight'  style='font-size:10px; padding:2px'>" + difS + "</td>\n";
                
                resp += "</tr>\n";
                
                //Adiciona linha no retorno
                ret.add(resp);
            }
            
            resp =  "<tr>\n";
            resp += "  <td colspan=12 class='tdMedium' align='right'>Total do Período: </td>\n";
            resp += "  <td class='tdMedium'>" + Util.emHoras(soma) + "</td>\n";
            resp +=  "</tr>\n";
            
            //Adiciona linha no retorno
            ret.add(resp);
            
            rs.close();
            stmt.close();
            
            return ret;
        } catch(SQLException e) {
            ret.add("Ocorreu um erro: " + e.toString() + " SQL=" + sql);
            return ret;
        }
    }
}