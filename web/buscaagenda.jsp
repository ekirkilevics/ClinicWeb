<%@page import="java.sql.*" %>
<%@page import="recursos.*" %>
<%@page pageEncoding="UTF-8"%>
<%
	String data = request.getParameter("data");
	String cod = request.getParameter("cod");
	Connection con = null;
	Statement stmt = null;
	try{
            //Banco de Dados
		    String serverName = "localhost";
		    String mydatabase = "clinicweb";

            //Login e senha do banco local
      		String username = "root";
	    	String password = "";

      		//Login e senha do banco remoto (INF)
      		//String username = "clinic";
	    	//String password = "8kpf16";

		    // Carregando o JDBC Driver
		    String driverName = "com.mysql.jdbc.Driver";
		    Class.forName(driverName);

		    // Criando a conexão com o Banco de Dados
		    String url = "jdbc:mysql://" + serverName + "/" + mydatabase; // a JDBC url
		    con = DriverManager.getConnection(url, username, password);
		    stmt = con.createStatement();

			String sql  = "SELECT agendamento.hora, paciente.nome, grupoprocedimento.grupoproced ";
			       sql += "FROM (agendamento INNER JOIN paciente ON agendamento.codcli = paciente.codcli) ";
				   sql += "INNER JOIN grupoprocedimento ON agendamento.cod_proced = grupoprocedimento.cod_grupoproced ";
				   sql += "WHERE agendamento.prof_reg='" + cod + "' AND agendamento.data='" + Util.formataDataInvertida(data) + "' ";
				   sql += "ORDER BY agendamento.hora";
			ResultSet rs = null;

			rs = stmt.executeQuery(sql);
			
			out.clear();
			while(rs.next()) {
				out.println(Util.formataHora(rs.getString("hora")) + "-" + rs.getString("nome") + "-" + rs.getString("grupoproced"));
			}
			out.close();
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

