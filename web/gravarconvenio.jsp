<%@page import="recursos.*" %>
<%@page import="java.sql.*" %>

<jsp:useBean class="recursos.Banco" id="banco" scope="page"/>

<%
//Configuração
String tabela = "convenio";
String chave = "cod_convenio";
String pagina = "convenios.jsp";
String ret = ""; //Retorno

//Parâmetros
String acao = request.getParameter("acao");
String id = request.getParameter("id");

//Nome dos campos (form e tabela)
String campos[]       = {"","sigla","razao","endereco","cnpj","cidade","uf","cep","contato","ddd","tel","ramal","dddfax","telfax","email","retorno","cod_ans", "numero", "complemento", "Indice_CH", "cod_banco", "valor_SADT", "diasrecurso", "qtderecurso", "iniciosemana", "fimsemana", "iniciosabado", "fimsabado", "tipoidentificadoroperadora", "identificadoroperadora", "tipocobranca", "mascaranumconvenio",  "ativo", "cod_empresa"};
String campostabela[] = {"cod_convenio","descr_convenio","Razao_social","Endereco","CGC","Cidade","UF","CEP","Contato","DDD","Telefone","Ramal","DDD_FAX","Fax","email","retorno_consulta","cod_ans", "numero", "complemento","Indice_CH", "cod_banco", "valor_SADT", "diasrecurso", "qtderecurso", "iniciosemana", "fimsemana", "iniciosabado", "fimsabado", "tipoidentificadoroperadora", "identificadoroperadora", "tipoCobranca", "mascaranumconvenio",  "ativo", "cod_empresa"};

//Campos a validar
int validar[] = {1,2, campos.length-1};

//Vetor de dados que vai ser preenchido
String dados[] = new String[campos.length];

//Captura os dados dos campos (exceto código que será auto-numérico)
for(int i=1; i<campos.length; i++)
    dados[i] = request.getParameter(campos[i]);

//Captura o valor do próximo índice numérico e coloca no vetor de dados
dados[0] = banco.getNext(tabela, chave );

//Coloca o código da empresa da sessão no último campo
dados[dados.length-1] = (String)session.getAttribute("codempresa");

//Deixa convênio como ativo
dados[dados.length-2] = "S";

//Se valor do CH, SADT e retorno veio nulo, colocar zero
if(Util.isNull(dados[19])) dados[19] = "0";
if(Util.isNull(dados[21])) dados[21] = "0";
if(Util.isNull(dados[22])) dados[22] = "0";
if(Util.isNull(dados[23])) dados[23] = "0";

//Horários de extra
if(Util.isNull(dados[24])) dados[24] = "00:00";
if(Util.isNull(dados[25])) dados[25] = "00:00";
if(Util.isNull(dados[26])) dados[26] = "00:00";
if(Util.isNull(dados[27])) dados[27] = "00:00";

//Porc. de acréscimo de extra
if(Util.isNull(dados[28])) dados[28] = "0";

%>

<%@include file="gravar_modelo.jsp" %>
