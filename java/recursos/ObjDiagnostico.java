/* Arquivo: ObjDiagnostico.java
 * Autor: Amilton Souza Martha
 * Criação: 18/06/2008   Atualização: 19/06/2008
 * Obs: Classe para Diagnósticos
 */

package recursos;

public class ObjDiagnostico {
    
    private String CID;
    private String descricao;
    private String cod_diag;
    private int contador;
    
    public ObjDiagnostico(String _CID, String _descricao, String _cod_diag, int _contador) {
        this.CID = _CID;
        this.descricao = _descricao;
        this.cod_diag = _cod_diag;
        this.contador = _contador;
    }
    
    public ObjDiagnostico() {
        setContador(1);
    }

    public String getCID() {
        return CID;
    }

    public void setCID(String CID) {
        this.CID = CID;
    }

    public String getDescricao() {
        return descricao;
    }

    public void setDescricao(String descricao) {
        this.descricao = descricao;
    }

    public String getCod_diag() {
        return cod_diag;
    }

    public void setCod_diag(String cod_diag) {
        this.cod_diag = cod_diag;
    }

    public int getContador() {
        return contador;
    }

    public void setContador(int contador) {
        this.contador = contador;
    }

    
}
