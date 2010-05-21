<%@include file="cabecalho.jsp" %>

<%
            String codigo = Util.isNull(request.getParameter("codigoempresa")) ? "" : request.getParameter("codigoempresa");
            DadosCliente dados = null;

            String confirma = request.getParameter("confirma");

            if (!Util.isNull(codigo)) {
                dados = Util.getDadosCliente(codigo, "-1");
            }

			//Se confirmou dados, gravar
            if (!Util.isNull(confirma) && confirma.equals("true")) {

                String tabelas[] = {"alertas", "bancos", "configuracoes", "convenio", "diagnosticos", "especialidade", "feriados", "fichasatendimento", "grupoprocedimento", "indicacoes", "link_assuntos", "lotesguias", "medicamentos", "menu", "modelos", "paciente", "procedimentos", "profissao", "profissional", "t_grupos", "tabelas", "guiasconsulta", "guiassadt", "exames", "cbo2002"};
                for (int i = 0; i < tabelas.length; i++) {
                    String sql = "UPDATE " + tabelas[i] + " SET cod_empresa=" + codigo;
                    new Banco().executaSQL(sql);
                }
                response.sendRedirect("index.jsp");

            }

%>


<html>
    <head>
        <title>Código de Cadastramento do Clinic Web</title>
        <link href="css/css.css" rel="stylesheet" type="text/css">
        <script language="Javascript" src="CBE/cbe_core.js"></script>
        <script language="JavaScript" src="js/scriptsform.js"></script>
        <script language="JavaScript">
            function confirmar() {
                var frm = cbeGetElementById("frmcadastrar");
				var jsinstalado = cbeGetElementById("instalado").innerHTML;
				var jscliente = cbeGetElementById("cliente").innerHTML;
					 
				if(jsinstalado == "S") {
					alert("Sistema já instalado. Entre em contato com o parceiro para maiores informações");
				}
				else if(jscliente == "Não registrado") {
					alert("Código de cliente não identificado. Entre em contato com o parceiro para maiores informações");
				}
				else {
					frm.action += "?confirma=true";									
	                frm.submit();
				}
            }
			
			function consultaCodigo() {
                var frm = cbeGetElementById("frmcadastrar");			
				frm.action += "?confirma=false";									
				frm.submit();
			}
        </script>
    </head>
    
    <body>
        <form name="frmcadastrar" id="frmcadastrar" action="setarempresa.jsp" method="post">
            <center>
                <div class="title">Novo Cliente Clinic Web</div>
                <br>
                
                <img src="images/logo.gif">
                <table cellpadding="0" cellspacing="0" class="table" width="400">
                    <tr>
                        <td class="tdMedium" width="150">Código do Cliente:</td>
                        <td class="tdLight"><input type="text" name="codigoempresa" id="codigoempresa" class="caixa" value="<%= codigo%>"></td>
                    </tr>
                    <tr>
                        <td colspan="2" class="tdMedium" align="center"><input type="button" value="Enviar" class="botao" onClick="consultaCodigo()"></td>
                    </tr>
                </table>
                <br>
                <%
            if (dados != null) {
                out.println("<table cellpadding='0' cellspacing='0' class='table' width='400'>");
                out.println("<tr>");
                out.println("<td class='tdMedium' width='150'>Cliente:</td><td class='tdLight'>");
                out.println("<div id='cliente'>" + dados.getNome() + "</div>");
                out.println("</td></tr>");
                out.println("<tr>");
                out.println("<td class='tdMedium' width='150'>Parceiro:</td><td class='tdLight'>");
                out.println(dados.getParceiro());
                out.println("</td></tr>");
                out.println("<tr>");
                out.println("<td class='tdMedium' width='150'>Sistema Instalado:</td><td class='tdLight'>");
                out.println("<div id='instalado'>" + dados.getInstalado() + "</div>");
                out.println("</td></tr>");
                out.println("<tr><td colspan='2' class='tdMedium' align='center'>");
                out.println("<input type='button' class='botao' value='Confirmar?' onclick='confirmar()'></td></tr>");
                out.println("</table>");
            }
                %>
            </center>
        </form>
    </body>
</html>


