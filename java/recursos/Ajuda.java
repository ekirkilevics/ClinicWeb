/* Arquivo: Ajuda.java
 * Autor: Amilton Souza Martha
 * Cria��o: 24/07/2008   Atualiza��o: 30/09/2008
 * Obs: Manipula as informa��es de ajudas
 */

package recursos;

public class Ajuda {
    
    //Busca uma ajuda espec�fica
    public String getAjuda(String cod_ajuda) {
       
        try {
            //Para capturar a resposta do WS
            String result = "";
            
            //Cria inst�ncia do m�todo remoto
            recursos.HelpWSService service = new recursos.HelpWSService();
            
            //Conecta na porta do servi�o
            recursos.HelpWS port = service.getHelpWSPort();

            //Invoca o m�todo remoto
            result = port.getTextHelp(cod_ajuda);
            
            //Retorna a respista
            return result;

        } catch (Exception ex) {
            return "<div class='texto'>Servi�o de ajuda n�o dispon�vel<br>Servidor de Ajuda n�o encontrado</div>";
        }

    }
    
}