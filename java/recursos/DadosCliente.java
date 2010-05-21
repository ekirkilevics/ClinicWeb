/* Arquivo: DadosCliente.java
 * Autor: Amilton Souza Martha
 * Criação: 07/07/2008   Atualização: 14/10/2008
 * Obs: Manipula as informações da agenda do paciente
 */

package recursos;

public class DadosCliente {
    private String nome;
    private String cadastro;
    private String validade;
    private String sms;
    private String pagina;
    private String cod_parceiro;
    private String parceiro;
    private String instalado;

    public DadosCliente() {
        nome = "Não conectado";
        cadastro = Util.getData();
        validade = Util.getData();
        sms = "N";
        pagina = "#";
        cod_parceiro = "0";
        parceiro = "N/C";
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public String getCadastro() {
        return cadastro;
    }

    public void setCadastro(String cadastro) {
        this.cadastro = cadastro;
    }

    public String getValidade() {
        return validade;
    }

    public void setValidade(String validade) {
        this.validade = validade;
    }

    public String getSms() {
        return sms;
    }

    public void setSms(String sms) {
        this.sms = sms;
    }

    public String getPagina() {
        return pagina;
    }

    public void setPagina(String pagina) {
        this.pagina = pagina;
    }

    public String getCod_parceiro() {
        return cod_parceiro;
    }

    public void setCod_parceiro(String cod_parceiro) {
        this.cod_parceiro = cod_parceiro;
    }

    public String getParceiro() {
        return parceiro;
    }

    public void setParceiro(String parceiro) {
        this.parceiro = parceiro;
    }
    
    public String getInstalado() {
        return instalado;
    }

    public void setInstalado(String instalado) {
        this.instalado = instalado;
    }

}
