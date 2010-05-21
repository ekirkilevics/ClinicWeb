/* Arquivo: Imagem.java
 * Autor: Amilton Souza Martha
 * Criação: 17/04/2006 - Atualização: 02/09/2008
 * Obs: Manipula imagens que foram feitas upload
 */

package recursos;
import java.sql.*;

public class Imagem {
    
    //Atributos privados para conexão
    private Connection con = null;
    private Statement stmt = null;
    
    public Imagem() {
        con = Conecta.getInstance();
    }
    
    public String getImagens(String cod_historia) {
        //Record Set
        ResultSet rs = null;
        String tipo = "";
        String imagem = "";
        
        String resp = "<table width='100%' class='table'>\n";
        
        try {
            
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            //Busca as imagens da história
            String sql  = "SELECT * FROM imagens WHERE cod_hist=" + cod_historia;
            
            rs = stmt.executeQuery(sql);
            
            while(rs.next()) {
                //Verifica tipo de arquivo
                imagem = rs.getString("imagem");
                tipo = imagem.substring(imagem.length()-3,imagem.length());
                
                resp += "<tr>\n";
                
                //Se for imagem, colocar em tag IMG, senão, usar link
                if(tipo.equalsIgnoreCase("jpg") || tipo.equalsIgnoreCase("gif") || tipo.equalsIgnoreCase("jpeg") || tipo.equalsIgnoreCase("png") || tipo.equalsIgnoreCase("bmp"))
                    resp += "  <td class='tdLight'><a title='Ver Imagem Ampliada' href=\"Javascript:mostraImagem('upload/" + rs.getString("imagem") + "');\"><img src='upload/" + rs.getString("imagem") + "' width='100' height='100' border='0'></a></td>\n";
                else
                    resp += "  <td class='tdLight'><a title='" + rs.getString("descricao") + "' href='upload/" + rs.getString("imagem") + "' target='_blank'>" + rs.getString("descricao") + "</a></td>\n";               
                
                //Coloca ícone para ver / editar texto
                resp += " <td class='tdMedium' align='center'><a title='Ver/Editar Texto' href='Javascript:verTexto(" + rs.getString("cod_imagem") + ")'><img src='images/agenda.gif' border=0></a></td>\n";
                
                //Coloca ícone para excluir
                resp += "  <td class='tdMedium' align='center'><a href=\"Javascript:excluirImagem(" + rs.getString("cod_imagem") + ",'" + rs.getString("imagem") + "','imagem');\"><img src='images/delete.gif' border='0'></a></td>\n";

                //Se tiver próximo para colocar em 2 colunas
                if(rs.next()) {
                    //Se for imagem, colocar em tag IMG, senão, usar link
                    if(tipo.equalsIgnoreCase("jpg") || tipo.equalsIgnoreCase("gif") || tipo.equalsIgnoreCase("jpeg") || tipo.equalsIgnoreCase("png") || tipo.equalsIgnoreCase("bmp"))
                        resp += "  <td class='tdLight'><a title='Ver Imagem Ampliada' href=\"Javascript:mostraImagem('upload/" + rs.getString("imagem") + "');\"><img src='upload/" + rs.getString("imagem") + "' width='100' height='100' border='0'></a></td>\n";
                    else
                        resp += "  <td class='tdLight'><a title='" + rs.getString("descricao") + "' href='upload/" + rs.getString("imagem") + "' target='_blank'>" + rs.getString("descricao") + "</a></td>\n";               

                    //Coloca ícone para ver / editar texto
                    resp += " <td class='tdMedium' align='center'><a title='Ver/Editar Texto' href='Javascript:verTexto(" + rs.getString("cod_imagem") + ")'><img src='images/agenda.gif' border=0></a></td>\n";

                    //Coloca ícone para excluir
                    resp += "  <td class='tdMedium' align='center'><a href=\"Javascript:excluirImagem(" + rs.getString("cod_imagem") + ",'" + rs.getString("imagem") + "','imagem');\"><img src='images/delete.gif' border='0'></a></td>\n";
                }
                resp += "</tr>\n";
            }
            
            resp += "</table>\n";
            
            rs.close();
            stmt.close();
            
            return resp;
        } catch(Exception e) {
            return e.toString();
        }
        
    }
    
    public String getPranchetaHistoria(String cod_historia) {
        //Record Set
        ResultSet rs = null;
        
        String resp = "<table width='100%' class='table'>\n";
        
        try {
            
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            //Busca as imagens da história
            String sql  = "SELECT * FROM prancheta WHERE cod_hist=" + cod_historia;
            
            rs = stmt.executeQuery(sql);
            
            while(rs.next()) {
                resp += "<tr>\n";
                resp += "  <td class='tdLight'><a title='Abrir Imagem' href=\"Javascript:mostraImagem('prancheta/" + rs.getString("imagem") + "');\"><img src='prancheta/" + rs.getString("imagem") + "' width='100' height='100' border='0'></a></td>\n";
                //Coloca ícone para excluir
                resp += "  <td class='tdMedium' align='center'><a href=\"Javascript:excluirImagem(" + rs.getString("cod_prancheta") + ",'" + rs.getString("imagem") + "','prancheta');\"><img src='images/delete.gif' border='0'></a></td>\n";

                //Se tiver próximo para colocar em 2 colunas
                if(rs.next()) {
                    resp += "  <td class='tdLight'><a title='Abrir Imagem' href=\"Javascript:mostraImagem('prancheta/" + rs.getString("imagem") + "');\"><img src='prancheta/" + rs.getString("imagem") + "' width='100' height='100' border='0'></a></td>\n";
                    //Coloca ícone para excluir
                    resp += "  <td class='tdMedium' align='center'><a href=\"Javascript:excluirImagem(" + rs.getString("cod_prancheta") + ",'" + rs.getString("imagem") + "','prancheta');\"><img src='images/delete.gif' border='0'></a></td>\n";
                }
                resp += "</tr>\n";
            }
            
            resp += "</table>\n";
            
            rs.close();
            stmt.close();
            
            return resp;
        } catch(Exception e) {
            return e.toString();
        }
        
    }


    public String getImagensPaciente(String codcli) {
        //Record Set
        ResultSet rs = null;
        
        String resp  = "<table>\n";
        resp += "  <tr>\n";
        
        try {
            
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            //Busca as imagens da história
            String sql  = "SELECT imagens.*, historia.DTACON ";
            sql += "FROM imagens INNER JOIN (historia ";
            sql += "INNER JOIN paciente ON historia.codcli = paciente.codcli) ";
            sql += "ON imagens.cod_hist = historia.cod_hist ";
            sql += "WHERE acompanhar=1 AND paciente.codcli=" + codcli;
            sql += " ORDER BY historia.DTACON ASC";
            
            String imagem="", tipo="";
            rs = stmt.executeQuery(sql);
            boolean achou = false;
            
            while(rs.next()) {
               //Verifica tipo de arquivo
                imagem = rs.getString("imagem");
                tipo = imagem.substring(imagem.length()-3,imagem.length());
 
                resp += "<td>\n";
                resp += " <table cellspading=0 cellspacing=0>\n";
                resp += "   <tr>\n";
                resp += "     <td class='tdMedium' align='center'>" + Util.formataData(rs.getString("historia.DTACON")) + "</td>\n";
                resp += "   </tr>\n";
                resp += "   <tr>\n";

                //Se for imagem, colocar em tag IMG, senão, usar link
                if(tipo.equalsIgnoreCase("jpg") || tipo.equalsIgnoreCase("gif") || tipo.equalsIgnoreCase("jpeg") || tipo.equalsIgnoreCase("png") || tipo.equalsIgnoreCase("bmp"))
                    resp += "     <td class='tdLight'><a title='" + rs.getString("descricao") + "' href=\"Javascript:mostraImagem('upload/" + rs.getString("imagem") + "');\"><img src='upload/" + rs.getString("imagem") + "' width='100' height='100' border='0'></a></td>\n";
                else
                    resp += "     <td class='tdLight'><a title='" + rs.getString("descricao") + "' href='upload/" + rs.getString("imagem") + "')>upload/" + rs.getString("imagem") + "</a></td>\n";
                resp += "   </tr>\n";
                resp += " </table>";
                resp += "</td>\n";
                
                achou = true;
            }
            
            //se não achou nenhuma imagem
            if(!achou) {
                resp += "<td class='tdMedium'>Nenhuma Imagem Encontrada</td>\n";
            }
            
            resp += "  </tr>\n";
            resp += "</table>\n";
            
            rs.close();
            stmt.close();
            
            return resp;
        } catch(Exception e) {
            return e.toString();
        }
        
    }
    public String getImagensPrancheta(String codcli) {
        //Record Set
        ResultSet rs = null;
        
        String resp  = "<table>\n";
        resp += "  <tr>\n";
        boolean achou = false;
        
        try {
            
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            //Busca as imagens da história
            String sql  = "SELECT prancheta.*, historia.DTACON ";
            sql += "FROM prancheta INNER JOIN (historia ";
            sql += "INNER JOIN paciente ON historia.codcli = paciente.codcli) ";
            sql += "ON prancheta.cod_hist = historia.cod_hist ";
            sql += "WHERE paciente.codcli=" + codcli;
            sql += " ORDER BY historia.DTACON ASC";

            rs = stmt.executeQuery(sql);
            
            while(rs.next()) {
                resp += "<td>\n";
                resp += " <table cellspading=0 cellspacing=0>\n";
                resp += "   <tr>\n";
                resp += "     <td class='tdMedium' align='center'>" + Util.formataData(rs.getString("historia.DTACON")) + "</td>\n";
                resp += "   </tr>\n";
                resp += "   <tr>\n";
                resp += "     <td class='tdLight'><a href=\"Javascript:mostraImagem('prancheta/" + rs.getString("imagem") + "');\"><img src='prancheta/" + rs.getString("imagem") + "' width='100' height='100' border='0'></a></td>\n";
                resp += "   </tr>\n";
                resp += " </table>";
                resp += "</td>\n";
                achou = true;
            }
            
            //se não achou nenhuma imagem
            if(!achou) {
                resp += "<td class='tdMedium'>Nenhuma Imagem Encontrada</td>\n";
            }

            resp += "  </tr>\n";
            resp += "</table>\n";
            
            rs.close();
            stmt.close();
            
            return resp;
        } catch(Exception e) {
            return e.toString();
        }
        
    }

    //Altera o texto de uma imagem
    public String setTexto(String cod_imagem, String texto) {
        String sql = "";
        
        //Atualiza a descrição da imagem
        sql = "UPDATE imagens SET descricao='" + texto + "' WHERE cod_imagem=" + cod_imagem;

        //Retorna o resultado do script
        return new Banco().executaSQL(sql);
    }

    //Busca o texto de uma imagem
    public String getTexto(String cod_imagem) {
        String sql = "";
        String resp = "";
        
        try {
            //Cria nova Statement para o ponteiro não alterar o anterior
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            ResultSet rs = null;
            
            //Pega o texto
            sql = "SELECT descricao FROM imagens WHERE cod_imagem=" + cod_imagem;
            
            rs = stmt.executeQuery(sql);
            if(rs.next()) {
                resp = rs.getString("descricao");
                if(resp==null) resp = "";
            } else {
                resp = "";
            }
            
            rs.close();
            stmt.close();
            return resp;
        } catch (SQLException e) {
            resp = e.toString() + sql;
            return resp;
        }
    }
    
}