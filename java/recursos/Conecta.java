/* Arquivo: Conecta.java
 * Autor: Amilton Souza Martha
 * Cria��o: 30/08/2005 Atualiza��o: 03/08/2009
 * Obs: Conecta com o banco de dados MySQL
 */

package recursos;
import java.sql.*;

public class Conecta {
    //Objeto est�tico da classe
    private static Conecta conecta;
    
    //Banco de Dados
    private static String serverName = Propriedade.getCampo("serverName");
    private static String mydatabase = Propriedade.getCampo("database");
    
    //Configura��o da conex�o
    private static String nomeBD   = "jdbc:mysql://" + serverName + "/" + mydatabase + "?autoReconnect=true&useUnicode=true&characterEncoding=latin1";
    private static String userBD   = Propriedade.getCampo("userDB");
    private static String passwdBD = Propriedade.getCampo("passDB");
    private static String driverBD = "com.mysql.jdbc.Driver";
    
    //Conex�o
    private static Connection con = null;
    
    //Cria inst�ncia de conex�o do banco
    private Conecta() throws ClassNotFoundException, SQLException{
        //verifica se o driver est� instalado
        Class.forName(driverBD);
        //abre a conex�o com o banco de dados
        con = DriverManager.getConnection(nomeBD, userBD, passwdBD);
    }
    
    //Retorna a conex�o
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

