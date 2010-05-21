<%@page import="recursos.*" %>
<%@page import="java.sql.*" %>

<jsp:useBean class="recursos.Banco" id="banco" scope="page"/>
<jsp:useBean class="recursos.Paciente" id="paciente" scope="page"/>

<%
//Configura��o
String tabela = "paciente";
String chave  = "codcli";
String pagina = "pacientes.jsp";
String ret = "";

//Par�metros
String acao = request.getParameter("acao");
String id   = request.getParameter("id");

//Nome dos campos (form e tabela)
String campos[]       = {"","data_abertura_registro","registro_hospitalar","nome","nome_responsavel","data_nascimento","cod_sexo","cod_cor","cod_estado_civil","rg","rg_emissor","rg_estado","cpf","endereco","numero","bairro","cidade","uf","contato","cep","ddd_residencial","tel_residencial","ddd_comercial","tel_comercial","ddd_celular","tel_celular","email","indicado_por","obs", "complemento","cartao_sus","codCBOS", "status", "indicacao", "prof_reg", "pai", "mae", "religiao", "pis_pasep", "ramal", "cod_empresa"};
String campostabela[] = {"codcli","data_abertura_registro","registro_hospitalar","nome","nome_responsavel","data_nascimento","cod_sexo","cod_cor","cod_est_civil","rg","rg_emissor","rg_estado","cic","nome_logradouro","numero","bairro","cidade","uf","nome_contato","cep","ddd_residencial","tel_residencial","ddd_comercial","tel_comercial","ddd_celular","tel_celular","email","indicado_por","obs", "complemento", "cartao_sus","profissao", "status", "indicacao", "prof_reg", "pai", "mae", "religiao", "pis_pasep", "ramal", "cod_empresa"};

//Vetor para dados dos alertas
String campostabelaA[] = {"cod_alerta_paci", "cod_alerta","cod_paci", "de", "ate"};
String dadosA[] = new String[campostabelaA.length];

//Campos a validar
int validar[] = {3,5};

//Vetor de dados que vai ser preenchido
String dados[] = new String[campos.length];

//Captura os dados dos campos (exceto c�digo que ser� auto-num�rico)
for(int i=1; i<campos.length; i++)
    dados[i] = request.getParameter(campos[i]);

//Captura o valor do pr�ximo �ndice num�rico e coloca no vetor de dados
dados[0] = banco.getNext(tabela, chave );

//Coloca o c�digo da empresa da sess�o no �ltimo campo
dados[dados.length-1] = (String)session.getAttribute("codempresa");

//Formatar os campos de data para o formato correto
dados[1] = Util.formataDataInvertida(dados[1]);
dados[5] = Util.formataDataInvertida(dados[5]);

//Se n�o for exclus�o, verificar se � registro duplicado
if(!acao.equals("exc")) {
//Verifica registro duplicado
    boolean passou = banco.validaRegistro(tabela, chave, id, dados, campostabela, validar );
    
//Se tiver, voltar com erro
    if(!passou)
        response.sendRedirect(pagina + "?inf=7"); //Registro Duplicado
    else
        
//Se a a��o for incluir
    if(acao.equals("inc")) {

		//Para o registro hospitalar, sempre pegar o pr�ximo e n�o o que est� na tela
		dados[2] = banco.getNext("paciente", "registro_hospitalar");
		
        ret = banco.gravarDados(tabela, dados, campostabela, (String)session.getAttribute("usuario"));
        if(ret.equals("OK")) {
			//Se gravou, pegar dados do conv�nio
			paciente.insereConvenio(dados[0], request.getParameter("cod_convenio"),  request.getParameter("cod_plano"), request.getParameter("num_associado_convenio"), request.getParameter("validade_carteira"));
            response.sendRedirect(pagina + "?inf=1"); //Inserido com sucesso
        } else
            response.sendRedirect(pagina + "?inf=" + ret); //Erro nas inser��o
        }
//Sen�o, � alterar
        else {
        ret = banco.alterarTabela(tabela, chave, id, dados, campostabela, (String)session.getAttribute("usuario"));
        if(ret.equals("OK")) {
			//Dados do conv�nio
			String convduplicado = paciente.insereConvenio(id, request.getParameter("cod_convenio"),  request.getParameter("cod_plano"), request.getParameter("num_associado_convenio"), request.getParameter("validade_carteira"));
			//Se seu como duplicado, retornar erro
			if(convduplicado.equals("duplicado"))
	            response.sendRedirect(pagina + "?cod=" + id + "&inf=Conv�nio%20Duplicado"); //Conv�nio duplicado
			else
				response.sendRedirect(pagina + "?cod=" + id + "&inf=5"); //Alterado com sucesso
        } else
            response.sendRedirect(pagina + "?inf=" + ret); //Erro na altera��o
        }
} else {
    ret = paciente.existeRegistros(id);
    if(!ret.equals("no"))
        response.sendRedirect(pagina + "?inf="+ret); //Removido com sucesso
    else {
//Excluir todos os alertas para o paciente e conv�nios vinculados
        banco.excluirTabela("alerta_paciente", "cod_paci", id, (String)session.getAttribute("usuario"));
		banco.excluirTabela("paciente_convenio", "codcli", id, (String)session.getAttribute("usuario"));
        
        ret = banco.excluirTabela(tabela, chave, id, (String)session.getAttribute("usuario"));
        if(ret.equals("OK"))
            response.sendRedirect(pagina + "?inf=3"); //Removido com sucesso
        else
            response.sendRedirect(pagina + "?inf=" + ret); //Erro na remo��o
    }
}
%>
