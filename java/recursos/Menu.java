/* Arquivo: Menu.java
 * Autor: Amilton Souza Martha
 * Cria��o: 30/08/2005   Atualiza��o: 17/04/2009
 * Obs: Conecta a Tabela do menu para mont�-lo
 */

package recursos;
import java.sql.*;

public class Menu {
    
    //Atributos privados para conex�o
    private Connection con = null;
    private Statement stmt = null;
    
    //Construtor que cria conex�o com o banco
    public Menu() {
        con = Conecta.getInstance();
    }
    
    public String montaMenu(String usuario_id, String cod_empresa) {
        //Chama a recurs�o a partir das ra�zes (0)
        String menu  = "<ul id='containerul'>\n";
        menu += pegaFilhos(0,  usuario_id, cod_empresa);
        
        menu += "</ul>\n";
        
        return menu;
    }
    
    public String pegaFilhos(int numPai, String usuario_id, String cod_empresa) {
        String result = "";   //Concatena String HTML do menu
        String link = "";     //Captura o link
        String filhos = "";   //Captura os filhos na recurs�o
        String sql = "";      //Comando SQL
        
        try {
            //Cria statemente para enviar sql
            Statement stmtaux = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            ResultSet rs = null;
            
            try {
                // Busca os filhos desse pai
                sql  = "SELECT * FROM menu WHERE ";
                sql += "cod_empresa=" + cod_empresa;
                sql += " AND menuPai=" + numPai + " ORDER BY ordem ASC";
                rs = stmtaux.executeQuery(sql);
                
                //Para cada filho, assumir que � o pai e buscar seus filhos
                while(rs.next()) {
                    //Capturo os dados dos filhos
                    link = rs.getString("link");
                    filhos = pegaFilhos(rs.getInt("menuId"), usuario_id, cod_empresa);
                    
                    //Se n�o tiver link, ent�o n�o montar a TAG <a> e usar tipo raiz <ul>
                    if(Util.isNull(link)) {
                        result += "<li>\n";
                        result += "<img src='images/" + rs.getString("status") + ".gif'> ";
                        result += trataEspacos(rs.getString("item")) + "\n";
                        result += "<ul>\n";
                        if(!filhos.equals(""))
                            result += filhos + "\n";
                        result += "</ul>\n";
                        result += "</li>\n";
                    } else {
                        //Se tiver autoriza��o para qualquer a��o na p�gina, mostrar
                        String aut[] = new Banco().autorizado(usuario_id, rs.getString("link"), cod_empresa);
                        
                        if(aut[0].equals("1") || aut[1].equals("1") || aut[2].equals("1") || aut[3].equals("1")) {
                            result += "<li>";
                            result += "<img src='images/" + rs.getString("status") + ".gif'>&nbsp;";
                            result += "<a title='" + rs.getString("item") + "' href='" + link + "' target='mainFrame'>" + trataEspacos(rs.getString("item")) + "</a></li>\n";
                            if(!filhos.equals(""))
                                result += filhos + "\n";
                        }
                    }
                }
                stmtaux.close();
                rs.close();
                rs = null;
                result += "</li>\n";
                
                //Se n�o tem filhos, o result s� tem o <li></li>, ent�o n�o retornar
                if(result.length() < 14)
                    return result;
                else
                    return result;
            } catch(SQLException e) {
                return("Ocorreu um erro: " + e.toString());
            }
        } catch(Exception e) {
            return("Ocorreu um erro: " + e.toString());
        }
    }
    
    public String montaMenuEdit(String cod_empresa) {
        //Chama a recurs�o a partir das ra�zes (0)
        return "<ol class='texto' type='I'>" + pegaFilhosEdit(0, cod_empresa) + "</ol>";
    }
    
    public String pegaFilhosEdit(int numPai, String cod_empresa) {
        String result = "";   //Concatena String HTML do menu
        String link = "";     //Captura o link
        String filhos = "";   //Captura os filhos na recurs�o
        
        try {
            //Cria statemente para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            ResultSet rs = null;
            String menuId = "";
            
            try {
                // Busca os filhos desse pai
                String sql  = "SELECT * FROM menu WHERE ";
                sql += "cod_empresa=" + cod_empresa;
                sql += " AND menuPai=" + numPai;
                sql += " AND item <> 'Empresas' ORDER BY ordem ASC";
                rs = stmt.executeQuery(sql);
                
                //Para cada filho, assumir que � o pai e buscar seus filhos
                while(rs.next()) {
                    menuId = rs.getString("menuId");
                    filhos = pegaFilhosEdit(Integer.parseInt(menuId), cod_empresa);
                    
                    result += "<li>\n";
                    result += "<div class='texto'>\n";
                    result += "<input type='text' size='35' maxlength='50' class='caixa' name='item" + menuId + "' value='" + rs.getString("item") + "'>\n";
                    result += getItensMenu(rs.getString("menuPai"), menuId, cod_empresa);
                    result += "<input tye='text' class='caixa' size='2' name='ordem" + menuId + "' value='" + rs.getString("ordem") + "'>";
                    result += "&nbsp;&nbsp;<a href='Javascript:alteraitem(" + menuId + ")' title='Alterar Item'><img src='images/grava.gif' border='0'></a>\n";
                    result += "</div>\n";
                    result += "<ol class='texto'>\n";
                    if(!filhos.equals(""))
                        result += filhos + "\n";
                    result += "</ol>\n";
                    result += "</li>\n";
                }
                rs.close();
                rs = null;
                result += "</li>\n";
                
                //Se n�o tem filhos, o result s� tem o <li></li>, ent�o n�o retornar
                if(result.length() < 14)
                    return result;
                else
                    return result;
            } catch(SQLException e) {
                return("Ocorreu um erro: " + e.toString());
            }
        } catch(Exception e) {
            return("Ocorreu um erro: " + e.toString());
        }
    }
    
    //Substitui espa�os em branco por c�digo HTML (&nbsp;)
    private String trataEspacos(String nome) {
        String resp = "";
        char letra;
        for(int i=0; i<nome.length(); i++) {
            letra = nome.charAt(i);
            if(letra == ' ')
                resp += "&nbsp;";
            else
                resp += letra;
        }
        return resp;
    }
    
    //Devolve os conv�nios
    public String getItensMenu(String pai, String menuId, String cod_empresa) {
        String sql  = "SELECT menuId, item FROM menu WHERE cod_empresa=";
        sql += cod_empresa + " ORDER BY item ASC";
        String resp = "<select class='caixa' name='combopai" + menuId + "' id='combopai" + menuId + "'>";
        resp += "<option value='0'>Raiz</option>\n";
        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            ResultSet rs = null;
            //Executa a pesquisa
            rs = stmt.executeQuery(sql);
            
            //Cria looping com a resposta
            while(rs.next()) {
                if(rs.getString("menuId").equals(pai))
                    resp += "<option value='" + rs.getString("menuId") + "' selected>";
                else
                    resp += "<option value='" + rs.getString("menuId") + "'>";
                
                resp += rs.getString("item") + "</option>\n";
            }
            
            resp += "</select>\n";
            
            rs.close();
            stmt.close();
            
            return resp;
        } catch(SQLException e) {
            return e.toString();
        }
    }
    
    public static void main(String args[]) {
        String teste = new Menu().montaMenu("2","-2");
        System.out.println(teste);
    }
    
}