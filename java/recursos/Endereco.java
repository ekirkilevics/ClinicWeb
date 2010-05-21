/* Arquivo: Endereco.java
 * Autor: Amilton Souza Martha
 * Criação: 25/09/2008   Atualização: 26/09/2008
 * Obs: Abstrai o endereço
 */
package recursos;

public class Endereco {
    private String logradouro;
    private String bairro;
    private String cidade;
    private String uf;

    public String getLogradouro() {
        return logradouro;
    }

    public void setLogradouro(String logradouro) {
        if(Util.isNull(logradouro))
            this.logradouro = "-";
        else
            this.logradouro = logradouro;
    }

    public String getBairro() {
        return bairro;
    }

    public void setBairro(String bairro) {
        if(Util.isNull(bairro))
            this.bairro = "-";
        else
            this.bairro = bairro;
    }

    public String getCidade() {
        return cidade;
    }

    public void setCidade(String cidade) {
        if(Util.isNull(cidade))
            this.cidade = "-";
        else
            this.cidade = cidade;
    }

    public String getUf() {
        return uf;
    }

    public void setUf(String uf) {
        if(Util.isNull(uf))
            this.uf = "-";
        else
            this.uf = uf;
    }
}