/* Arquivo: Sincronismo.java
 * Autor: Amilton Souza Martha
 * Criação: 01/09/2008   Atualização: 03/08/2009
 * Obs: Faz o sincronismo entre banco de dados
 */

package recursos;

public class Sincronismo extends Thread  {
    
    //Tabelas a serem sincronizadas
    private String itensSincronismo[] = {"Paciente", "Convênio", "Agenda", "História", "Protocolos", "Modelos de Texto", "Faturamento"};
    private String tabelasSincronimsmo[] = {"paciente#paciente_convenio", "convenio#planos", "agendamento", "historia#hist_diagnostico#hist_procedimento#hist_medicamento","prot_bloco_protocolo#prot_blocos#prot_itens#prot_protocolos#prot_questao_bloco#prot_questoes", "modelos", "faturas#faturas_itens#faturas_chq#faturas_cartoes"};
    private String tabela;
    boolean aguarda = false;

    //Construtor que recebe a tabela a sinconizar
    public Sincronismo(String tabela) {
        this.tabela = tabela;
        this.aguarda = true;
    }
    
    //Construtor que recebe a tabela e se vai esperar
    public Sincronismo(String tabela, boolean aguarda) {
        this.tabela = tabela;
        this.aguarda = aguarda;
    }
    
    //Sobrecarrega método da Thread
    public void run() {
        //
    }
    
    //Lista os itens a sincronizar
    public String getItensSincronismo() {
        String resp = "";
        
        for(int i=0; i<itensSincronismo.length; i++) {
            resp += "<tr>\n";
            resp += " <td class='tdLight'>" + itensSincronismo[i] + "</td>\n";
            resp += " <td width='80' class='tdLight' align='center'><input type='checkbox' name='item' value='" + i + "'></td>\n";
            resp += "</tr>\n";
        }
        
        return resp;
    }
    
    //Retorna as tabelas do item que está sendo sincronizado
    public String getTabelasItem(String cod) {
        String resp = "";
        try {
            resp = tabelasSincronimsmo[Integer.parseInt(cod)];
        }
        catch(Exception e) {
            resp = "";
        }
        return resp;
    }
 
  
}
