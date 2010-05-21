/* Arquivo: HonorarioIndividual.java
 * Autor: Amilton Souza Martha
 * Cria��o: 30/07/2008   Atualiza��o: 12/02/2009
 * Obs: Manipula informa��es de Honor�rio Individual e Resumo de Interna��o
 */
package recursos;

import java.sql.*;
import java.util.Calendar;

public class HonorarioIndividual {
    //Atributos privados para conex�o
    private Connection con = null;
    private Statement stmt = null;

    //Vetores de op��es da Guia
    private String[] vet_grauparticipacao = {   "00#Cirurgi�o","01#Primeiro Auxiliar", "02#Segundo Auxiliar","03#Terceiro Auxiliar",
                                                "04#Quarto Auxiliar", "05#Instrumentador", "06#Anestesista", "07#Auxiliar de Anestesista",
						"08#Consultor", "09#Perfusionista", "10#Pediatra na sala de parto",
						"11#Auxiliar SADT", "12#Cl�nico", "13#Intensivista"};
    private String[] vet_tipoacomodacao = { 	"1#Enfermaria", "2#Quarto particular", "3#UTI", "4#Enfermaria dois leitos", "5#One Day clinic",
						"6#Unidade intermediaria", "7#Apartamento", "8#Ambulat�rio", "11#Apartamento luxo", 
						"12#Apartamento Simples", "13#Apartamento Standard", "14#Apartamento Su�te",
						"15#Apartamento com alojamento conjunto", "21#Ber��rio normal", "22#Ber��rio patol�gico / prematuro",
						"23#Ber��rio patol�gico com isolamento", "31#Enfermaria (3 leitos)", "32#Enfermaria (4 ou mais leitos)",
						"33#Enfermaria com alojamento conjunto", "34#Hospital Dia", "35#Isolamento", "41#Quarto Coletivo (2 leitos)",
						"42#Quarto privativo", "43#Quarto com alojamento conjunto", "51#UTI Adulto", "52#UTI Pedi�trica",
						"53#UTI Neo-Natal", "54#TSI - Unidade de Terapia semi-Intensiva", "55#Unidade coronariana", "61#Outras di�rias"};

    private String[] vet_tipoInternacao = { 	"Cl�nica", "Cir�rgica", "Obst�trica", "Pedi�trica", "Psiqui�trica"  };

    //Decolve os tipos de interna��o para montar combo
    public String getTiposInternacao() {
        String resp = "";
        
        for(int i=0;i<vet_tipoInternacao.length; i++) {
            resp += "<option value='" + (i+1) + "'>" + vet_tipoInternacao[i] + "</option>\n";
        }
        
        return resp;
    }
                                                
    //Verifica se o campo est� escolhido ou n�o
    public String check(String campo, ResultSet rs, String texto) {
        
        try {
            //Captura o conte�do do campo
            String valor = rs.getString(campo);
        
            //Verifica se est� checado
            if(Util.isNull(valor)) return "|&nbsp;&nbsp;&nbsp;|" + texto + "&nbsp;&nbsp;";
            if(valor.equalsIgnoreCase("S")) return "|<b> X </b>|" + texto + "&nbsp;";
            else return "|&nbsp;&nbsp;&nbsp;|" + texto + "&nbsp;";
        }
        catch(Exception e) {
            return "ERRO: " + e.toString();
        }
    }

    public HonorarioIndividual() {
        con = Conecta.getInstance();
    }
    
    public String getGrausdeParticipacao() {
        String resp = "";
        //Varre o vetor para montar as options
        for(int i=0; i<vet_grauparticipacao.length; i++) {
            String registro = vet_grauparticipacao[i];
            
            //Separa c�digo do nome
            String aux[] = registro.split("#");
            resp += "<option value='" + aux[0] + "'>" + aux[1] + "</option>\n";
        }
        return resp;
    }

    public String getGrausdeParticipacao(String valor) {
        //Varre o vetor para montar as options
        for(int i=0; i<vet_grauparticipacao.length; i++) {
            String registro = vet_grauparticipacao[i];
            //Separa c�digo do nome
            String aux[] = registro.split("#");
    
            //Se encontrar, retornar
            if(aux[0].equals(valor))
                return aux[1];
        }
        return "N�o encontrado";
    }

    public String getTiposAcomodacao() {
        String resp = "";
        //Varre o vetor para montar as options
        for(int i=0; i<vet_tipoacomodacao.length; i++) {
            String registro = vet_tipoacomodacao[i];
            
            //Separa c�digo do nome
            String aux[] = registro.split("#");
            resp += "<option value='" + aux[0] + "'>" + aux[1] + "</option>\n";
        }
        return resp;
    }

    public String getTiposAcomodacao(String valor) {
        //Varre o vetor para montar as options
        for(int i=0; i<vet_tipoacomodacao.length; i++) {
            String registro = vet_tipoacomodacao[i];
            //Separa c�digo do nome
            String aux[] = registro.split("#");
    
            //Se encontrar, retornar
            if(aux[0].equals(valor))
                return aux[1];
        }
        return "N�o encontrado";
    }

    //Monta combo com todos os profissionais
    public String getProfissionais(String cod_empresa) {
        String resp = "";
        String sql = "";
        ResultSet rs = null;

        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);

            sql += "SELECT nome, cod, prof_reg FROM profissional ";
            sql += "WHERE cod_empresa=" + cod_empresa;

            //S� pega profissionais internos
            sql += " AND locacao='interno' and ativo='S' ORDER BY nome";

            //Executa a pesquisa
            rs = stmt.executeQuery(sql);

            //Cria looping com a resposta
            while (rs.next()) {
                resp += "<option value='" + rs.getString("prof_reg") + "'>" + rs.getString("nome") + "</option>\n";
            }

            rs.close();
            stmt.close();

            return resp;

        } catch (SQLException e) {
            return "Erro:" + e.toString();
        }
    }

    //Monta combo com todos os hospitais
    public String getHospitais(String cod_empresa) {
        String resp = "";
        String sql = "";
        ResultSet rs = null;

        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);

            sql += "SELECT descricao, cod_hospital FROM hospitais ";
            sql += "WHERE cod_empresa=" + cod_empresa;
            sql += " AND ativo='S'";
            sql += " ORDER By descricao";
            
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);

            //Cria looping com a resposta
            while (rs.next()) {
                resp += "<option value='" + rs.getString("cod_hospital") + "'>" + rs.getString("descricao") + "</option>\n";
            }

            rs.close();
            stmt.close();

            return resp;

        } catch (SQLException e) {
            return "ERRO: " + e.toString() + " SQL: " + sql;
        }
    }
    
    //Pega os procedimentos que o conv�nio possui, na especialidade selecionada
    public String getProcedimentos(String cod_plano) {
        //Vetor para a resposta
        String resp = "";
        String sql = "";
        boolean achou = false;

        try {

            resp = "<select name='cod_proced' id='cod_proced' class='caixa' style='width:180px' onChange='mudarProcedimento(this); atualizar();'>\n";
            resp += "  <option value=''></option>\n";

            //Se veio cod_plano vazio, retornar nada
            if (Util.isNull(cod_plano)) {
                resp += "</select>\n";
                return resp;
            }

            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);

            ResultSet rs = null;

            //Recupera os procedimentos que o plano cobre
            sql = "SELECT procedimentos.COD_PROCED, procedimentos.Procedimento ";
            sql += "FROM valorprocedimentos INNER JOIN procedimentos ";
            sql += "ON valorprocedimentos.cod_proced = procedimentos.COD_PROCED ";
            sql += "WHERE valorprocedimentos.cod_plano=" + cod_plano;
            sql += " AND procedimentos.flag=1 ";
            sql += "ORDER BY Procedimento";

            //Executa a pesquisa
            rs = stmt.executeQuery(sql);

            while (rs.next()) {
                resp += "<option value='" + rs.getString("COD_PROCED") + "'>";
                resp += rs.getString("Procedimento") + "</option>\n";
                achou = true;
            }
            
            //Se n�o achou procedimento, colocar mensagem
            if(!achou) {
                resp += "<option value=''>N�o encontrou procedimentos cadastrados para esse conv�nio</option>\n";
            }
            resp += "</select>\n";

            //Fecha o recordset
            rs.close();
            stmt.close();

            return resp;
        } catch (SQLException e) {
            resp = "ERRO: " + e.toString() + " SQL: " + sql;
            return resp;
        }
    }

    //Pega o valor do procedimento para o conv�nio
    public String getValorProcedimento(String cod_proced, String cod_plano, String gp, String ta, String hi, String tp, String data, String va) {
        //Vetor para a resposta
        String resp = "";
        String sql = "";
        float valor = 0;
        String cod_convenio = "";

        try {

            //Se veio cod_plano vazio, retornar nada
            if (Util.isNull(cod_plano)) {
                return resp;
            }

            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);

            ResultSet rs = null;

            //Recupera os procedimentos que o plano cobre
            sql = "SELECT valor, cod_convenio ";
            sql += "FROM valorprocedimentos ";
            sql += "WHERE cod_plano=" + cod_plano;
            sql += " AND cod_proced='" + cod_proced + "' ";

            //Executa a pesquisa
            rs = stmt.executeQuery(sql);

            if (rs.next()) {
                valor = rs.getFloat("valor");
                cod_convenio = rs.getString("cod_convenio");
            }
            else {
                valor = -1;
            }
            
            //Se achou o valor, fazer as outras verifica��es
            if(valor != -1) {
            
               /***** Verifica se � apto ou quarto particular para dobrar *****/
               if(ta.equals("2") || ta.equals("7") || ta.equals("11") || ta.equals("12") || ta.equals("13") || ta.equals("14") || ta.equals("15") || ta.equals("42"))
                   valor = valor * 2;
               /***** Verifica se � apto para dobrar *****/

               
               /***** Verifica o Hora Extra *****/
               //Se o tipo de procedimento for "U"rg�ncia, calcular os 30%, se for "E"letivo, n�o calcular
               if(tp.equals("U")) {

                    //Separa dia, m�s e ano
                    int dia = Integer.parseInt(Util.getDia(data));
                    int mes = Integer.parseInt(Util.getMes(data));
                    int ano = Integer.parseInt(Util.getAno(data));
                    //Pega o dia da semana da data
                    int dia_semana = Util.toTime("00:00",dia , mes, ano).get(Calendar.DAY_OF_WEEK);

                    //Se for feriado ou domingo, aplicar 30%
                    if(ehFeriado(data).equals("yes") || dia_semana == 1) {
                        valor = valor * 1.3f;
                    }
                    else {
                        //Se for s�bado, procurar se est� acima no per�odo
                        if(dia_semana == 7) {
                            sql  = "SELECT * FROM CONVENIO WHERE iniciosabado <= '" + hi + "' ";
                            sql += " AND cod_convenio=" + cod_convenio;
                            String aux = new Banco().getValor("cod_convenio", sql);
                            
                            //Se achou, � extra, calcular os 30%
                            if(!Util.isNull(aux)) {
                                valor = valor * 1.3f;
                            }
                        }
                        //Se for dia da semana
                        else {
                            sql  = "SELECT * FROM CONVENIO WHERE iniciosemana <= '" + hi + "' ";
                            sql += " AND cod_convenio=" + cod_convenio;
                            String aux = new Banco().getValor("cod_convenio", sql);

                            //Se achou, � extra, calcular os 30%
                            if(!Util.isNull(aux)) {
                                valor = valor * 1.3f;
                            }
                        }
                    }
                }
                /***** Verifica o Hora Extra *****/
                
                /***** Verifica o grau de participa��o *****/
               if(gp.equals("00")) //Cirurgi�o
                   valor = valor * 1;
               else if(gp.equals("01")) //Primeiro auxiliar
                    valor = valor * 0.3f;
               else if(gp.equals("02") || gp.equals("03") || gp.equals("04")) //Segundo ao quarto auxiliar
                    valor = valor * 0.2f;
               else if(gp.equals("05")) //Instrumentador
                    valor = valor * 0.1f;
               else //Zerar o valor para fazer manual
                    valor = 0;
                /***** Verifica o grau de participa��o *****/
               
               
               /***** Verifica a Via de Acesso *****/
               if(va.equals("D")) valor = valor * 0.7f;
               else if(va.equals("M")) valor = valor * 0.5f;
               /***** Verifica a Via de Acesso *****/
            }
            
            //Fecha o recordset
            rs.close();
            stmt.close();

            //Converte a resposta para string
            resp = Util.arredondar(valor, 2, 0) + "";
            
            return resp;
        } catch (SQLException e) {
            resp = "ERRO: " + e.toString() + " SQL: " + sql;
            return resp;
        }
    }
    
    //Recupera os itens do honor�rio individual
    public String getItensHonorario(String cod_honorario) {
        String resp = "";
        String sql = "";
        ResultSet rs = null;

        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);

            //Captura os itens
            sql  = "SELECT honorario_item.cod_honorario_item, honorario_item.qtde, honorario_item.data, ";
            sql += "honorario_item.valor, honorario_item.viaAcesso, procedimentos.Procedimento, honorario_item.tipoProced ";
            sql += "FROM honorario_item INNER JOIN procedimentos ON honorario_item.cod_proced = procedimentos.COD_PROCED ";
            sql += "WHERE honorario_item.cod_honorario=" + cod_honorario;
            sql += " ORDER BY cod_honorario_item";

            //Executa a pesquisa
            rs = stmt.executeQuery(sql);

            //Acumulador
            float soma = 0;
            
            //Cria looping com a resposta
            while (rs.next()) {
                String sqtde = rs.getString("qtde");
                String svalor = rs.getString("valor");
                float subtotal = Float.parseFloat(sqtde) * Float.parseFloat(svalor);
                   
                soma += subtotal;
                
                resp += "<tr>\n";
                resp += "	<td class='tdLight'>" + Util.formataData(rs.getString("data")) + "&nbsp;</td>\n";
                resp += "	<td class='tdLight' align='center'>" + rs.getString("tipoProced") + "&nbsp;</td>\n";
                resp += "	<td class='tdLight' align='center'>" + Util.trataNulo(rs.getString("viaAcesso"), "") + "&nbsp;</td>\n";
                resp += "	<td class='tdLight'>" + rs.getString("Procedimento") + "&nbsp;</td>\n";
                resp += "	<td class='tdLight' align='center'>" + sqtde + "&nbsp;</td>\n";
                resp += "	<td class='tdLight'>" + Util.formatCurrency(svalor) + "&nbsp;</td>\n";
                resp += "	<td class='TdLight' align='center'><a title='Excluir Registro' href='Javascript:excluirItem(" + rs.getString("cod_honorario_item") + ");'><img src='images/delete.gif' border='0'></a></td>\n";
                resp += "</tr>\n";

            }

            resp += "<tr><td colspan='5' class='tdMedium' align='right'>Total: </td><td class='tdMedium' colspan='2'>" + Util.formatCurrency(""+soma) + "</td></tr>";

            rs.close();
            stmt.close();

            return resp;

        } catch (SQLException e) {
            return "Erro:" + e.toString();
        }
    }

    //Recupera os itens do resumo de interna��o
    public String getItensResumoInternacao(String cod_resumointernacao, String cod_empresa) {
        String resp = "";
        String sql = "";
        ResultSet rs = null;

        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);

            //Captura os itens
            sql  = "SELECT data, cod_procedimentoresumointernacao, horaInicio, ";
            sql += "horaFim, procedimentos.Procedimento,procedimentosresumointernacao.viaAcesso, ";
            sql += "procedimentosresumointernacao.quantidadeRealizada, procedimentosresumointernacao.valor ";
            sql += "FROM procedimentos INNER JOIN procedimentosresumointernacao ON ";
            sql += "procedimentos.COD_PROCED = procedimentosresumointernacao.cod_proced ";
            sql += "WHERE procedimentosresumointernacao.codGuia=" + cod_resumointernacao;
            sql += " AND procedimentosresumointernacao.cod_empresa=" + cod_empresa;
            sql += " ORDER BY cod_procedimentoresumointernacao";

            //Executa a pesquisa
            rs = stmt.executeQuery(sql);

            //Acumulador
            float soma = 0;
            
            //Cria looping com a resposta
            while (rs.next()) { 
                String sqtde = rs.getString("quantidadeRealizada");
                String svalor = rs.getString("valor");
                float subtotal = Float.parseFloat(sqtde) * Float.parseFloat(svalor);
                   
                soma += subtotal;
                
                resp += "<tr>\n";
                resp += "	<td class='tdLight'>" + Util.formataData(rs.getString("data")) + "&nbsp;</td>\n";
                resp += "	<td class='tdLight' align='center'>" + Util.formataHora(rs.getString("horaInicio")) + "&nbsp;</td>\n";
                resp += "	<td class='tdLight' align='center'>" + Util.formataHora(rs.getString("horaFim")) + "&nbsp;</td>\n";
                resp += "	<td class='tdLight'>" + rs.getString("viaAcesso") + "&nbsp;</td>\n";
                resp += "	<td class='tdLight'>" + rs.getString("Procedimento") + "&nbsp;</td>\n";
                resp += "	<td class='tdLight' align='center'>" + sqtde + "&nbsp;</td>\n";
                resp += "	<td class='tdLight'>" + Util.formatCurrency(svalor) + "&nbsp;</td>\n";
                resp += "	<td class='TdLight' align='center'><a title='Excluir Registro' href='Javascript:excluirItem(" + rs.getString("cod_procedimentoresumointernacao") + ");'><img src='images/delete.gif' border='0'></a></td>\n";
                resp += "</tr>\n";

            }

            resp += "<tr><td colspan='7' class='tdMedium' align='right'>Total: </td><td class='tdMedium' colspan='2'>" + Util.formatCurrency(""+soma) + "</td></tr>";

            rs.close();
            stmt.close();

            return resp;

        } catch (SQLException e) {
            return "Erro:" + e.toString();
        }
    }

    //Recupera os itens do resumo de interna��o
    public String getProfissionaisResumoInternacao(String cod_resumointernacao) {
        String resp = "";
        String sql = "";
        ResultSet rs = null;

        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);

            //Captura os itens
            sql  = "SELECT nome, cod_profresumointernacao, grauParticipacao ";
            sql += "FROM profissional INNER JOIN prof_resumointernacao ON ";
            sql += "profissional.prof_reg = prof_resumointernacao.prof_reg ";
            sql += "WHERE prof_resumointernacao.cod_resumointernacao=" + cod_resumointernacao;
            sql += " ORDER BY cod_profresumointernacao";

            //Executa a pesquisa
            rs = stmt.executeQuery(sql);

            //Cria looping com a resposta
            while (rs.next()) { 
                resp += "<tr>\n";
                resp += "	<td class='tdLight'>" + getGrausdeParticipacao(rs.getString("grauParticipacao")) + "&nbsp;</td>\n";
                resp += "	<td class='tdLight'>" + rs.getString("nome") + "&nbsp;</td>\n";
                resp += "	<td class='TdLight' align='center'><a title='Excluir Registro' href='Javascript:excluirProfItem(" + rs.getString("cod_profresumointernacao") + ");'><img src='images/delete.gif' border='0'></a></td>\n";
                resp += "</tr>\n";

            }

            rs.close();
            stmt.close();

            return resp;

        } catch (SQLException e) {
            return "Erro:" + e.toString();
        }
    }

    /* pesquisa: valor a ser pesquisado
        * campo: campo a ser pesquisado
        * ordem: ordem de resposta dos campos
        * numPag: n�mero da p�gina selecionada (pagina��o)
        * qtdeporpagina: quantidade de registros por p�gina
        * tipo: tipo de pesquisa (exata, substring)
        * cod_empresa: c�digo da empresa logada
        */
    public String[] getHonorarios(String pesquisa, String ordem, int numPag, int qtdeporpagina, int tipo, String cod_empresa) {
        String resp[] = {"",""};
        String sql = "";
        ResultSet rs = null;
        
        //Limpa espa�os em branco antes e depois da pesquisa
        pesquisa = pesquisa.trim();
        
        sql  = "SELECT honorarios.cod_honorario, honorarios.data, profissional.nome, paciente.nome, hospitais.descricao ";
        sql += "FROM ((honorarios INNER JOIN profissional ON honorarios.prof_reg = profissional.prof_reg) ";
        sql += "INNER JOIN paciente ON honorarios.codcli = paciente.codcli) ";
        sql += "INNER JOIN hospitais ON honorarios.cod_hospital = hospitais.cod_hospital ";
         
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            //Consulta exata
            if(tipo == 1)
                sql += "WHERE (paciente.nome='" + pesquisa + "' OR profissional.nome='" + pesquisa + "')";
            //Come�ando com o valor
            else if(tipo == 2)
                sql += "WHERE (paciente.nome LIKE '" + pesquisa + "%' OR profissional.nome LIKE '" + pesquisa + "%')";
            //Com o valor no meio
            else if(tipo == 3)
                sql += "WHERE (paciente.nome LIKE '%" + pesquisa + "%' OR profissional.nome LIKE '%" + pesquisa + "%')";
            
            //Filtra pela empresa
            sql += " AND hospitais.cod_empresa=" + cod_empresa;
            
            //Coloca na ordem
            sql += " ORDER BY " + ordem;
            
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            //Vai para o �ltimo registro
            rs.last();
            
            //Captura a quantidade de linhas
            int numRows = rs.getRow();
            rs.close();
            
            //Cria pagina��o das p�ginas
            resp[1] = Util.criaPaginacao("honorarioindividual.jsp", numPag, qtdeporpagina, numRows);
            
            //Limita para uma quantidade de registros
            sql += " LIMIT " + ((numPag-1)*qtdeporpagina) + "," + qtdeporpagina;
           
            //Executa a pesquisa novamente com o limitador
            rs = stmt.executeQuery(sql);
            
            //Cria looping com a resposta
            while(rs.next()) {
                resp[0] += "<tr onClick=go('honorarioindividual.jsp?cod=" + rs.getString("cod_honorario") + "') onMouseOver='trocaCor(this,1);' onMouseOut='trocaCor(this,2);'>";
                resp[0] += "  <td width='70' class='tdLight'>" + Util.formataData(rs.getString("data")) + "&nbsp;</td>\n";
                resp[0] += "  <td width='170' class='tdLight'>" + rs.getString("paciente.nome") + "&nbsp;</td>\n";
                resp[0] += "  <td width='170' class='tdLight'>" + rs.getString("profissional.nome") + "&nbsp;</td>\n";
                resp[0] += "  <td class='tdLight'>" + rs.getString("descricao") + "&nbsp;</td>\n";
                resp[0] += "</tr>";
            }
            
            //Se n�o retornar resposta, montar mensagem de n�o encontrado
            if(resp[0].equals("")) {
                resp[0] += "<tr>";
                resp[0] += "<td colspan='3' width='600' class='tdLight'>";
                resp[0] += "Nenhum registro encontrado para a pesquisa";
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

       /* pesquisa: valor a ser pesquisado
        * campo: campo a ser pesquisado
        * ordem: ordem de resposta dos campos
        * numPag: n�mero da p�gina selecionada (pagina��o)
        * qtdeporpagina: quantidade de registros por p�gina
        * tipo: tipo de pesquisa (exata, substring)
        * cod_empresa: c�digo da empresa logada
        */
    public String[] getResumosInternacao(String pesquisa, String ordem, int numPag, int qtdeporpagina, int tipo, String cod_empresa) {
        String resp[] = {"",""};
        String sql = "";
        ResultSet rs = null;
        
        //Limpa espa�os em branco antes e depois da pesquisa
        pesquisa = pesquisa.trim();
        
        sql  = "SELECT resumointernacao.cod_resumointernacao, resumointernacao.data, paciente.nome ";
        sql += "FROM resumointernacao INNER JOIN paciente ON resumointernacao.codcli = paciente.codcli ";
         
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            //Consulta exata
            if(tipo == 1)
                sql += "WHERE (paciente.nome='" + pesquisa + "')";
            //Come�ando com o valor
            else if(tipo == 2)
                sql += "WHERE (paciente.nome LIKE '" + pesquisa + "%')";
            //Com o valor no meio
            else if(tipo == 3)
                sql += "WHERE (paciente.nome LIKE '%" + pesquisa + "%')";
            
            //Filtro de empresa
            sql += " AND resumointernacao.cod_empresa=" + cod_empresa;
            
            //Coloca na ordem
            sql += " ORDER BY " + ordem;
            
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            //Vai para o �ltimo registro
            rs.last();
            
            //Captura a quantidade de linhas
            int numRows = rs.getRow();
            rs.close();
            
            //Cria pagina��o das p�ginas
            resp[1] = Util.criaPaginacao("resumointernacao.jsp", numPag, qtdeporpagina, numRows);
            
            //Limita para uma quantidade de registros
            sql += " LIMIT " + ((numPag-1)*qtdeporpagina) + "," + qtdeporpagina;
           
            //Executa a pesquisa novamente com o limitador
            rs = stmt.executeQuery(sql);
            
            //Cria looping com a resposta
            while(rs.next()) {
                resp[0] += "<tr onClick=go('resumointernacao.jsp?cod=" + rs.getString("cod_resumointernacao") + "') onMouseOver='trocaCor(this,1);' onMouseOut='trocaCor(this,2);'>";
                resp[0] += "  <td width='70' class='tdLight'>" + Util.formataData(rs.getString("data")) + "&nbsp;</td>\n";
                resp[0] += "  <td class='tdLight'>" + rs.getString("paciente.nome") + "&nbsp;</td>\n";
                resp[0] += "</tr>";
            }
            
            //Se n�o retornar resposta, montar mensagem de n�o encontrado
            if(resp[0].equals("")) {
                resp[0] += "<tr>";
                resp[0] += "<td colspan='2' width='600' class='tdLight'>";
                resp[0] += "Nenhum registro encontrado para a pesquisa";
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

    //Excluir um registro de item do honor�rio
    public String removeItemHonorario(String cod) {
        String sql = "", resp = "";

        //Se n�o veio c�digo
        if (Util.isNull(cod)) {
            return "";
        }
        try {
            Banco bc = new Banco();
            sql = "DELETE FROM honorario_item WHERE cod_honorario_item=" + cod;
            resp = bc.executaSQL(sql);

            return resp;

        } catch (Exception e) {
            resp = "ERRO: " + e.toString() + " SQL: " + sql;
            return resp;
        }

    }

    //Excluir um registro de item de resumo de interna��o
    public String removeItemResumoInternacao(String cod) {
        String sql = "", resp = "";

        //Se n�o veio c�digo
        if (Util.isNull(cod)) {
            return "";
        }
        try {
            Banco bc = new Banco();
            sql = "DELETE FROM procedimentosresumointernacao WHERE cod_procedimentoresumointernacao=" + cod;
            resp = bc.executaSQL(sql);

            return resp;

        } catch (Exception e) {
            resp = "ERRO: " + e.toString() + " SQL: " + sql;
            return resp;
        }

    }
    
    //Excluir um profissional do resumo de interna��o
    public String removeProfResumoInternacao(String cod) {
        String sql = "", resp = "";

        //Se n�o veio c�digo
        if (Util.isNull(cod)) {
            return "";
        }
        try {
            Banco bc = new Banco();
            sql = "DELETE FROM prof_resumointernacao WHERE cod_profresumointernacao=" + cod;
            resp = bc.executaSQL(sql);

            return resp;

        } catch (Exception e) {
            resp = "ERRO: " + e.toString() + " SQL: " + sql;
            return resp;
        }

    }

    //Insere um registro de item do honor�rio individual
    public String insereItemHonorario(String cod_honorario, String data, String cod_proced, String qtde, String valor, String viaAcesso, String tipoProced) {
        String sql = "", resp = "";

        //Se n�o veio todos os itens, retornar
        if (Util.isNull(cod_honorario) || Util.isNull(cod_proced) || Util.isNull(qtde) || Util.isNull(valor) || Util.isNull(viaAcesso)) {
            return "OK";
        }
        try {
            Banco bc = new Banco();
            
            //Pr�ximo registro
            String prox = bc.getNext("honorario_item", "cod_honorario_item");
            
            //Monta instru��es para inser��o
            sql  = "INSERT INTO honorario_item(cod_honorario_item, cod_honorario, data, cod_proced, qtde, valor, viaAcesso, tipoProced) ";
            sql += "VALUES(" + prox + "," + cod_honorario + ",'" + Util.formataDataInvertida(data) + "','" + cod_proced + "'," + qtde + "," + valor;
            sql += ",'" + viaAcesso + "','" + tipoProced + "')";
            
            //Executa o comando
            resp = bc.executaSQL(sql);

            return resp;

        } catch (Exception e) {
            resp = "ERRO: " + e.toString() + " SQL: " + sql;
            return resp;
        }

    }
    
    //Insere um registro de item do resumo de interna��o
    public String insereItemResumoInternacao(String cod_resumointernacao, String dataproced, String cod_proced, String viaAcesso, String horaInicio, String horaFim, String qtde, String valor, String cod_empresa) {
        String sql = "", resp = "";

        //Se n�o veio todos os itens, retornar
        if (Util.isNull(cod_resumointernacao) || Util.isNull(cod_proced) || Util.isNull(qtde) || Util.isNull(valor)) {
            return "OK";
        }
        try {
            Banco bc = new Banco();
            
            //Pr�ximo registro
            String prox = bc.getNext("procedimentosresumointernacao", "cod_procedimentoresumointernacao");
            
            //Monta instru��es para inser��o
            sql  = "INSERT INTO procedimentosresumointernacao(cod_procedimentoresumointernacao, codGuia, cod_empresa, data, ";
            sql += "horaInicio, horaFim, cod_proced, quantidadeRealizada, valor, viaAcesso) ";
            sql += "VALUES(" + prox + "," + cod_resumointernacao + "," + cod_empresa + ",'" + Util.formataDataInvertida(dataproced) + "','";
            sql += horaInicio + "','" + horaFim + "','" + cod_proced + "'," + qtde + "," + valor + ",'" + viaAcesso + "')";
            
            //Executa o comando
            resp = bc.executaSQL(sql);

            return resp;

        } catch (Exception e) {
            resp = "ERRO: " + e.toString() + " SQL: " + sql;
            return resp;
        }

    }

    //Insere um profissional no resumo de interna��o
    public String insereProfResumoInternacao(String cod_resumointernacao, String grauParticipacao, String prof_reg) {
        String sql = "", resp = "";

        //Se n�o veio todos os itens, retornar
        if (Util.isNull(cod_resumointernacao) || Util.isNull(grauParticipacao) || Util.isNull(prof_reg) ) {
            return "OK";
        }
        try {
            Banco bc = new Banco();
            
            //Pr�ximo registro
            String prox = bc.getNext("prof_resumointernacao", "cod_profresumointernacao");
            
            //Monta instru��es para inser��o
            sql  = "INSERT INTO prof_resumointernacao(cod_profresumointernacao, cod_resumointernacao, grauParticipacao, prof_reg) ";
            sql += "VALUES(" + prox + "," + cod_resumointernacao + ",'" + grauParticipacao + "','" + prof_reg + "')";
            
            //Executa o comando
            resp = bc.executaSQL(sql);

            return resp;

        } catch (Exception e) {
            resp = "ERRO: " + e.toString() + " SQL: " + sql;
            return resp;
        }

    }

    //Verifica se uma data � feriado
    public String ehFeriado(String data){
    
        String resp = "no";
        
        String sql =  "";
        //S� considera feriado se for o dia todo, definivo e para todos os m�dicos
        sql += "SELECT * FROM feriados WHERE prof_reg='todos' AND diatodo='S'";
        sql += " AND DAY(dataInicio) ='" + Util.getDia(data) + "' AND MONTH(dataInicio) ='" + Util.getMes(data) + "' ";
        sql += "AND definitivo='S'";
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            ResultSet rs = null;
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            //Cria looping com a resposta
            if(rs.next()) {
                resp = "yes";
            }
            
            rs.close();
            stmt.close();
            
            return resp;
        } catch(SQLException e) {
            return "ERRO: " + e.toString() + " SQL: " + sql;
        }        
    }
    
    public static void main(String args[]) {
        HonorarioIndividual h = new HonorarioIndividual();
        String teste = h.getValorProcedimento("14","8", "00","2","07:20","U","22/08/2008","M");
        System.out.println(teste);
    }
}