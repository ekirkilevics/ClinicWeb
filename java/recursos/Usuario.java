/* Arquivo: Usuario.java
 * Autor: Amilton Souza Martha
 * Criação: 26/09/2005   Atualização: 30/07/2008
 * Obs: Manipula as informações do usuário
 */
package recursos;

import java.sql.*;
import java.util.Vector;

public class Usuario {
    //Atributos privados para conexão
    private Connection con = null;
    private Statement stmt = null;

    public Usuario() {
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
    public String[] getUsuarios(String pesquisa, String campo, String ordem, int numPag, int qtdeporpagina, int tipo, String cod_empresa) {
        String resp[] = {"", ""};
        String sql = "";
        ResultSet rs = null;

        //Limpa espaços em branco antes e depois da pesquisa
        pesquisa = pesquisa.trim();

        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);

            //Valores a pegar do banco
            sql = "SELECT t_usuario.cd_usuario, t_usuario.ds_nome, ";
            sql += "t_usuario.ds_login, t_usuario.ds_senha ";
            sql += "FROM t_usuario INNER JOIN t_grupos ON ";
            sql += "t_usuario.ds_grupo = t_grupos.grupo_id ";

            //Não exibir id=1, pois é administrador
            sql += "WHERE cd_usuario > 1 AND t_usuario.ativo='S' AND ";

            //Consulta exata
            if (tipo == 1) {
                sql += campo + "='" + pesquisa + "'";
            //Começando com o valor
            } else if (tipo == 2) {
                sql += campo + " LIKE '" + pesquisa + "%'";
            //Com o valor no meio
            } else if (tipo == 3) {
                sql += campo + " LIKE '%" + pesquisa + "%'";            //Filtra pela empresa
            }
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
            resp[1] = Util.criaPaginacao("usuarios.jsp", numPag, qtdeporpagina, numRows);

            //Limita para uma quantidade de registros
            sql += " LIMIT " + ((numPag - 1) * qtdeporpagina) + "," + qtdeporpagina;

            //Executa a pesquisa novamente com o limitador
            rs = stmt.executeQuery(sql);

            //Cria looping com a resposta
            while (rs.next()) {
                resp[0] += "<tr onClick=go('usuarios.jsp?cod=" + rs.getString("cd_usuario") + "') onMouseOver='trocaCor(this,1);' onMouseOut='trocaCor(this,2);'>\n";
                resp[0] += "	<td width='60%' class='tdLight'>" + rs.getString("ds_nome") + "</td>\n";
                resp[0] += "</tr>\n";
            }

            //Se não retornar resposta, montar mensagem de não encontrado
            if (resp[0].equals("")) {
                resp[0] += "<tr>";
                resp[0] += "<td width='600' class='tdLight'>";
                resp[0] += "Nenhum registro encontrado para a pesquisa";
                resp[0] += "</td>";
                resp[0] += "</tr>";
            }

            rs.close();
            stmt.close();
            return resp;
        } catch (SQLException e) {
            resp[0] = "Ocorreu um erro: " + e.toString();
            return resp;
        }
    }
    //Pega os grupos da empresa
    public String getGrupos(String cod_empresa) {
        String resp = "";
        String sql = "";
        ResultSet rs = null;

        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);

            //Valores a pegar do banco (menos administrador geral)
            sql = "SELECT * FROM t_grupos WHERE grupo_id > 1 ";
            sql += "AND cod_empresa=" + cod_empresa + " ORDER BY grupo";

            //Executa a pesquisa
            rs = stmt.executeQuery(sql);

            //Cria looping com a resposta
            while (rs.next()) {
                resp += "<option value='" + rs.getString("grupo_id") + "'>" + rs.getString("grupo") + "</option>\n";
            }

            rs.close();
            stmt.close();

            return resp;
        } catch (SQLException e) {
            return "Ocorreu um erro: " + e.toString();
        }
    }
    //Pega os grupos da empresa
    public String getProfissionais(String cod_empresa) {
        String resp = "";
        String sql = "";
        ResultSet rs = null;

        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);

            //Valores a pegar do banco (menos administrador geral)
            sql = "SELECT prof_reg, nome FROM profissional WHERE ativo='S' AND locacao='interno' ";
            sql += "AND cod_empresa=" + cod_empresa + " ORDER BY nome";

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
            return "Ocorreu um erro: " + e.toString();
        }
    }
    //Pega os usuários logados no sistema
    public String getUsuariosLogados(Vector lista) {
        String resp = "";
        String sql = "";
        ResultSet rs = null;

        //Se vier nula a lista, retornar vazio
        if(lista == null) return "Nenhum Usuário Online";
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            //Busca todos os usuários
            sql  = "SELECT ds_nome, cd_usuario FROM t_usuario WHERE cd_usuario > 1 ";
            sql += "AND cd_usuario IN (" + Util.Vector2String(lista) + ")";
            
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            resp = "<table cellspacing='0' cellpadding='0' border='0' width='100%'>";
            
            //Cria looping com a resposta
            while(rs.next()) {
                resp += "<tr>\n";
                resp += " <td class='texto' style='font-size:9px'>";
                resp += "<img src='images/on.gif'/> ";
                resp += rs.getString("ds_nome") + "</td>\n";
                resp += "</tr>\n";
            }
            
            resp += "</table>";
            
            rs.close();
            stmt.close();
            
            return resp;
        } catch(SQLException e) {
            return "Ocorreu um erro: " + e.toString();
        }
    }

    //Recebe o cód. usuário, a senha atual para validar e a nova senha
    public String alteraSenha(String usuario, String senhaatual, String novasenha) {
        String sql = "";

        try {
            ResultSet rs = null;

            //Cria statement para enviar sql
            stmt = con.createStatement();

            //Pesquisa para saber se a senha atual bate com a do usuário
            sql = "SELECT * FROM t_usuario WHERE cd_usuario=" + usuario;
            sql += " AND ds_senha=password('" + senhaatual + "')";

            rs = stmt.executeQuery(sql);

            //Se não achar registro, senha atual não bate!
            if (!rs.next()) {
                return "Senha atual não confere!";            //Sql para alteração
            }
            sql = "UPDATE t_usuario SET ds_senha=password('" + novasenha;
            sql += "'),dataalteracao='" + Util.formataDataInvertida(Util.getData());
            sql += "' WHERE cd_usuario=" + usuario;

            //Executa a pesquisa
            new Banco().executaSQL(sql);

            rs.close();
            stmt.close();

            return "Senha Alterada com sucesso!";
        } catch (SQLException e) {
            return "Ocorreu um erro: " + e.toString();
        }
    }
    //Atualiza dados do usuário na tabela usuários (só para Indiq)
    public String atualizaUsuarios(String parceiro, String acao, String dados[], String id, String cod_empresa) {

        //Se for cliente da Indiq=1, mandar valores
	if(Util.isNull(parceiro) || !parceiro.equals("1"))
            return "Não Indiq";

        //Filtra os dados necessários
        String codigo = dados[0];
	String login = dados[2];
	String senha = dados[3];
	
        String sqlaux = "";

        try {
            Connection conUsu = null;
            Statement stmtUsu = null;

            //Banco de Dados
            String serverName = "localhost";
            String mydatabase = "usuarios";

            //Login e senha do banco de usuários
            String username = "root";
            String password = "katus";

            // Carregando o JDBC Driver
            String driverName = "com.mysql.jdbc.Driver";
            Class.forName(driverName);

            // Criando a conexão com o Banco de Dados
            String url = "jdbc:mysql://" + serverName + "/" + mydatabase; // a JDBC url
            conUsu = DriverManager.getConnection(url, username, password);
            stmtUsu = conUsu.createStatement();

            if (!acao.equals("exc")) {
                //Inclusão
                if (acao.equals("inc")) {
                    sqlaux = "INSERT INTO t_usuario (cd_usuario, ds_login, ds_senha, cod_empresa) ";
                    sqlaux += " VALUES(" + codigo + ",'" + login + "', password('" + senha + "')," + cod_empresa + ")";
                    stmtUsu.executeUpdate(sqlaux);
                } //Alteração
                else {
                    if (!Util.isNull(senha)) {
                        sqlaux = "UPDATE t_usuario SET ds_login = '" + login + "', ds_senha=password('" + senha + "') ";
                        sqlaux += "WHERE cd_usuario=" + id + " AND cod_empresa=" + cod_empresa;
                    } else {
                        sqlaux = "UPDATE t_usuario SET ds_login = '" + login + "' ";
                        sqlaux += "WHERE cd_usuario=" + id + " AND cod_empresa=" + cod_empresa;
                    }
                    stmtUsu.executeUpdate(sqlaux);
                }
            } //Exclusão
            else {
                sqlaux = "DELETE FROM t_usuario WHERE cd_usuario=" + id + " AND cod_empresa=" + cod_empresa;
                stmtUsu.executeUpdate(sqlaux);
            }
            stmtUsu.close();
            conUsu.close();
            
            return "OK";
        } catch (ClassNotFoundException e) {
            //Driver não encontrado
            return "ERRO: " + e.toString() + " SQL: " + sqlaux;
        } catch (SQLException e) {
            return "ERRO: " + e.toString() + " SQL: " + sqlaux;
        }
    }
}