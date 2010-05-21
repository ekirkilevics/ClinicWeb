/* Arquivo: Ajuda.java
 * Autor: Amilton Souza Martha
 * Criação: 24/07/2008   Atualização: 30/09/2008
 * Obs: Manipula as informações de ajudas
 */

package recursos;

public class Ajuda {
    
    //Busca uma ajuda específica
    public String getAjuda(String cod_ajuda) {
       
        try {
            //Para capturar a resposta do WS
            String result = "";
            
            //Cria instância do método remoto
            recursos.HelpWSService service = new recursos.HelpWSService();
            
            //Conecta na porta do serviço
            recursos.HelpWS port = service.getHelpWSPort();

            //Invoca o método remoto
            result = port.getTextHelp(cod_ajuda);
            
            //Retorna a respista
            return result;

        } catch (Exception ex) {
            return "<div class='texto'>Serviço de ajuda não disponível<br>Servidor de Ajuda não encontrado</div>";
        }

    }
    
}