<%@include file="cabecalho.jsp" %>

<html>
<head>
<title>Mudar código do Cliente</title>
<link href="css/css.css" rel="stylesheet" type="text/css">
<script language="Javascript" src="CBE/cbe_core.js"></script>
<script language="JavaScript" src="js/scriptsform.js"></script>
</head>

<body>
<%@include file="barrasessao.jsp" %>
<form action="mudarempresa.jsp" method="post">
	<center>
	<br><br>
	  <table cellpadding="0" cellspacing="0" width="400" class="table">
    	<tr>
        	<td colspan="2" align="center" class="tdMedium">Mudar código do Cliente</td>
        </tr>
        <tr>
        	<td class="tdMedium">Código: </td>
            <td class="tdLight"><input type="text" name="cod_empresa" id="cod_empresa" class="caixa"></td>
        </tr>
		<tr>
        	<td colspan="2" class="tdMedium" align="center"><button type="submit" class="botao"><img src="images/grava.gif">&nbsp;&nbsp;&nbsp;Alterar</button></td>
        </tr>
    </table>
    </center>
</form>
</body>
</html>

<%
	Connection con = null;
	Statement stmt = null;
	
	try
	     {
            //Banco de Dados
		    String serverName = Propriedade.getCampo("serverName");
		    String mydatabase = Propriedade.getCampo("database");

            //Login e senha do banco local
      		String username = Propriedade.getCampo("userDB");
	    	String password = Propriedade.getCampo("passDB");

		    // Carregando o JDBC Driver
		    String driverName = "com.mysql.jdbc.Driver";
		    Class.forName(driverName);

		    // Criando a conexão com o Banco de Dados
		    String url = "jdbc:mysql://" + serverName + "/" + mydatabase; // a JDBC url
		    con = DriverManager.getConnection(url, username, password);
		    stmt = con.createStatement();

			String codigo = request.getParameter("cod_empresa");
			if(codigo != null) {
				String tabelas[] = {"alertas", "bancos", "configuracoes", "convenio", "diagnosticos", "especialidade", "feriados", "fichasatendimento","grupoprocedimento", "indicacoes", "link_assuntos", "lotesguias", "medicamentos", "menu", "modelos", "paciente", "procedimentos", "profissao", "profissional", "t_grupos", "tabelas","guiasconsulta", "guiassadt", "exames", "cbo2002", "guiasoutrasdespesas", "hospitais", "guiashonorarioindividual", "prot_blocos", "prot_protocolos", "prot_questoes", "backup", "audiometria", "guiasresumointernacao", "procedimentoresumointernacaoguia", "procedimentosresumointernacao", "prof_resumointernacaoguia", "resumointernacao", "agendatelefonica", "tiposhistoria"};
				for(int i=0; i<tabelas.length; i++) {
					String sql = "UPDATE " + tabelas[i] + " SET cod_empresa=" + codigo;
					try {
						out.println("<li class='texto'>" + tabelas[i] + " --> " + stmt.executeUpdate(sql) + "</li>");
					}
					catch(SQLException e) {
						out.println("Erro ao executar a alteração: " + sql + "<br>");
					}
				}
				out.println("<div class='texto'><b>FIM</b></div>");
			}
			
	     }
	     catch (ClassNotFoundException e)
	     {
		    //Driver não encontrado
		    out.println(e.toString());
         }
	     catch (SQLException e)
	     {
		    //Não está conseguindo se conectar ao banco
		    out.println(e.toString());
	     }

%>

