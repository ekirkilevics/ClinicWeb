/* Arquivo: Conecta.java
 * Autor: Amilton Souza Martha
 * Criação: 30/08/2005 Atualização: 03/08/2009
 * Obs: Conecta com o banco de dados MySQL
 */

package recursos;
import java.sql.*;

public class Conecta {
    //Objeto estático da classe
    private static Conecta conecta;
    
    //Banco de Dados
    private static String serverName = Propriedade.getCampo("serverName");
    private static String mydatabase = Propriedade.getCampo("database");
    
    //Configuração da conexão
    private static String nomeBD   = "jdbc:mysql://" + serverName + "/" + mydatabase + "?autoReconnect=true&useUnicode=true&characterEncoding=latin1";
    private static String userBD   = Propriedade.getCampo("userDB");
    private static String passwdBD = Propriedade.getCampo("passDB");
    private static String driverBD = "com.mysql.jdbc.Driver";
    
    //Conexão
    private static Connection con = null;
    
    //Cria instância de conexão do banco
    private Conecta() throws ClassNotFoundException, SQLException{
        //verifica se o driver está instalado
        Class.forName(driverBD);
        //abre a conexão com o banco de dados
        con = DriverManager.getConnection(nomeBD, userBD, passwdBD);
    }
    
    //Retorna a conexão
    public static Connection getInstance(){
        try{
            if(con == null || con.isClosed()){
                conecta = new Conecta();
            }
        } catch(Exception e) {
            
        }
        
        return con;
    }
    
}

