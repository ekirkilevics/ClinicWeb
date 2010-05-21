/* Arquivo: Propriedade.java
 * Autor: Amilton Souza Martha
 * Criação: 27/03/2007   Atualização: 27/03/2007
 * Obs: Captura valores das propriedades
 */

package recursos;

import java.util.Properties;

public class Propriedade {
    
   //Recebe o nome do campo e retorna o valor do mesmo no arquivo de propriedades
    public static String getCampo(String campo) {
        
        try {
            Properties properties = new Properties();
            properties.load(Propriedade.class.getResourceAsStream("/clinicweb.properties"));
            
            String resp = properties.getProperty(campo);
            
            return resp;
            
        } catch(Exception e){
            return "Erro em Propriedade: " + e.toString();
        }
    }
    public static void main(String args[])
    {
        System.out.println(Propriedade.getCampo("userDB"));
    }
}
