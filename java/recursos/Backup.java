/* Arquivo: Backup.java
 * Autor: Amilton Souza Martha
 * Criação: 29/01/2007   Atualização: 02/09/2008
 * Obs: Executa o BackUp do Banco de Dados e envia para o servidor
 */

package recursos;

import java.sql.*;
import java.io.File;
import java.io.IOException;
import java.sql.SQLException;

public class Backup {
    
    private String arquivo_zip = "";

   //Atributos privados para conexão
    private Connection con = null;
    private Statement stmt = null;
    
    public Backup() {
        con = Conecta.getInstance();
    }

    public String executaBack(String cod_empresa) {
        
        /**** Variáveis de configuração ****/
        String usuario         = Propriedade.getCampo("userDB");
        String senha           = Propriedade.getCampo("passDB");
        String mysql_dir       = Propriedade.getCampo("mysqlFolder") + "/bin/";
        String dir_backup      = Propriedade.getCampo("backupFolder");
        String nomebanco       = Propriedade.getCampo("database");
        String data_atual      = Util.formataDataInvertida(Util.getData()).replace("-", "");
        String arquivo_backup  = dir_backup + "\\bck_" + Util.formataNumero(cod_empresa, 3) + "_" + data_atual + ".sql";
        arquivo_zip            = arquivo_backup + ".zip";
        String cmd             = "cmd /c \"" + mysql_dir + "mysqldump\" -u" + usuario + " -p" + senha + " --default-character-set=latin1 --skip-opt " + nomebanco + " > ";
        
        File diretorio = new File(dir_backup);
        File bck = new File(arquivo_backup);
        
        // Cria diretório se ainda não existe
        if(!diretorio.isDirectory()) {
            new File(dir_backup).mkdir();
        }
        
        // Cria Arquivo de Backup
        try {
            if(!bck.isFile()) {
                Process proc = Runtime.getRuntime().exec(cmd + arquivo_backup);
                //Aguarda encerrar o processo
                proc.waitFor();
            } else {
                
                while(bck.isFile()) {
                    bck.delete();
                    bck = new File(arquivo_backup);
                }
                
                Process proc = Runtime.getRuntime().exec(cmd+bck);
                //Aguarda encerrar o processo
                proc.waitFor();
            }
            
            Util.compactar(arquivo_backup,arquivo_zip);
            
            //Armazena que o backup foi alterado
            registraBackup(cod_empresa);
            
            return "OK";
            
        } catch (IOException ex) {
            return ex.toString();
        } catch(Throwable t){
            return t.toString();
        }
    }
   

   //Lkista os 5 últimos registros de backup
   public String getBackups(String cod_empresa) {
        String sql  = "SELECT * FROM backup WHERE cod_empresa=";
        sql += cod_empresa + " ORDER BY data DESC LIMIT 5";
        String resp = "";
        boolean achou = false;
        
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            ResultSet rs = null;
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);

            //Cria looping com a resposta
            while(rs.next()) {
                resp += "<tr>\n";
                resp += "  <td class='tdLight' align='center'>" + Util.formataData(rs.getString("data")) + "</td>\n";
                resp += "  <td class='tdLight' align='center'>" + Util.formataHora(rs.getString("hora")) + "</td>\n";
                resp += "  <td class='tdLight' align='center'>" + rs.getString("local") + "</td>\n";
                resp += "  <td class='tdLight' align='center'>" + rs.getString("remoto") + "</td>\n";
                resp += "</tr>\n";
                achou = true;
            }

            if(!achou) {
                resp += "<tr>\n";
                resp += " <td class='tdLight' colspan='4'>Nenhum registro de Backup encontrado</td>\n";
                resp += "</tr>\n";
            }
            rs.close();
            stmt.close();
            
            return resp;
        } catch(SQLException e) {
            return "ERRO: " + e.toString() + " SQL: " + sql;
        }
    }
   
   //Insere o registro de backup e retorno o código do backup gerado
   public String registraBackup(String cod_empresa) {
        
        String next = new Banco().getNext("backup", "cod_backup");
       
        String sql  = "INSERT INTO backup(cod_backup, cod_empresa, data, hora, local, remoto) ";
        sql += "VALUES(" + next + "," + cod_empresa + ",'" + Util.formataDataInvertida(Util.getData()) + "','";
        sql += Util.getHora() + "','S','N')";
        
        //Retorno o resultado da execução do script (OK para sucesso)
        String ret = new Banco().executaSQL(sql);

        //Se deu certo, retornar o next
        if(ret.equals("OK"))
            return next;
        else
            return ret;
    }
   
   //Atualiza o backup com status de enviado na data atual
   public String atualizaBackup(String cod_empresa) {
        
        String sql  = "UPDATE backup SET hora='" + Util.getHora() + "', ";
        sql += "remoto='S' ";
        sql += "WHERE data='" + Util.formataDataInvertida(Util.getData()) + "' ";
        sql += "AND cod_empresa=" + cod_empresa;
        
        //Retorno o resultado da execução do script (OK para sucesso)
        return new Banco().executaSQL(sql);
    }


}
