/* Arquivo: Autenticador.java
 * Autor: Amilton Souza Martha
 * Criação: 25/05/2009   Atualização: 25/05/2009
 * Obs: Autentica o proxy de um navegador
 */
package recursos;

import java.net.Authenticator;
import java.net.InetAddress;
import java.net.PasswordAuthentication;

public class Autenticador extends Authenticator {
        // This method is called when a password-protected URL is accessed
        protected PasswordAuthentication getPasswordAuthentication() {
            // Get information about the request
            String promptString = getRequestingPrompt();
            String hostname = getRequestingHost();
            InetAddress ipaddr = getRequestingSite();
            int port = getRequestingPort();

            // Get the username from the user...
            String username = Propriedade.getCampo("userProxy");

            // Get the password from the user...
            String password = Propriedade.getCampo("passProxy");

            // Return the information
            return new PasswordAuthentication(username, password.toCharArray());
        }
    }
