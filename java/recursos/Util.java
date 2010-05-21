/* Arquivo: Util.java
 * Autor: Amilton Souza Martha
 * Criação: 10/04/2006 - Atualização: 18/05/2009
 * Obs: Funções utilitárias
 */
package recursos;

import java.util.*;
import javax.swing.text.rtf.RTFEditorKit;
import java.text.*;
import java.io.*;
import java.net.Authenticator;
import java.net.MalformedURLException;
import java.net.URL;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.zip.*;
import javax.servlet.ServletContext;

public class Util {
    //Constantes
    static final int TAMANHO_BUFFER = 2048; // 2kb
    //Dados do cliente
    private static DadosCliente dadoscliente = new DadosCliente();
    //Devolve a data atual do servidor
    public static String getData() {
        GregorianCalendar data = new GregorianCalendar();
        int d = data.get(Calendar.DATE);
        int m = data.get(Calendar.MONTH) + 1;
        int a = data.get(Calendar.YEAR);

        String dia = d < 10 ? "0" + d : d + "";
        String mes = m < 10 ? "0" + m : m + "";
        String ano = a + "";

        return dia + "/" + mes + "/" + ano;

    }
    //Devolve o dia de uma data no formato String dd/mm/aaaa
    public static String getDia(String data) {
        String resp = "";

        if (data.length() == 10) {
            resp = data.substring(0, 2);
        }

        return resp;
    }
    //Devolve o mês de uma data no formato String dd/mm/aaaa
    public static String getMes(String data) {
        String resp = "";

        if (data.length() == 10) {
            resp = data.substring(3, 5);
        }

        return resp;
    }
    //Devolve o ano de uma data no formato String dd/mm/aaaa
    public static String getAno(String data) {
        String resp = "";

        if (data.length() == 10) {
            resp = data.substring(6);
        }

        return resp;
    }
    
    //Converte uma hora para GregorianCalendar
    public static GregorianCalendar Hora2GC(String hora) {

        try {
            String divide[] = hora.split(":");
            int h = Integer.parseInt(divide[0]);
            int m = Integer.parseInt(divide[1]);
            return new GregorianCalendar(0, 0, 0, h, m, 0);
        }
        catch(Exception e) {
            return null;
        }
    }
    
    //Devolve o dia da semana de uma data
    public static String getDiaSemana(int dia, int mes, int ano) {
        String resp = "";
        try {

            GregorianCalendar data = new GregorianCalendar(ano, mes - 1, dia);
            int dia_semana = data.get(Calendar.DAY_OF_WEEK);

            switch (dia_semana) {
                case 1:
                    resp = "Domingo";
                    break;
                case 2:
                    resp = "Segunda";
                    break;
                case 3:
                    resp = "Terça";
                    break;
                case 4:
                    resp = "Quarta";
                    break;
                case 5:
                    resp = "Quinta";
                    break;
                case 6:
                    resp = "Sexta";
                    break;
                case 7:
                    resp = "Sábado";
                    break;
            }
        } catch (Exception e) {
            resp = "ERRO: " + e.toString();
        }
        return resp;
    }
    //Sobrecarga do método anterior que recebe a data
    public static String getDiaSemana(String data) {
        int dia = Integer.parseInt(Util.getDia(data));
        int mes = Integer.parseInt(Util.getMes(data));
        int ano = Integer.parseInt(Util.getAno(data));

        return getDiaSemana(dia, mes, ano);
    }
    //Devolve a hora atual do servidor
    public static String getHora() {
        // Cria uma TIME ZONE correspondente ao horário de Brasília
        SimpleTimeZone pdt = new
                SimpleTimeZone(-3 * 60 * 60 * 1000,"GMT-3:00");
        
        // Seta as regras para o horário de verão Brasileiro
        // Começando no segundo domingo de outubro
        pdt.setStartRule(Calendar.OCTOBER, 2, Calendar.SUNDAY,0);
        
        // Terminando no último domingo do mês de Fevereiro
        pdt.setEndRule(Calendar.FEBRUARY, -1, Calendar.SUNDAY,0);
        
        // Instanciando um GregorianCalendar com com a time zone de BSB
        // e levando em consideração as regras do horário de verão.
        //Calendar dataHoje = new GregorianCalendar(pdt);
        
        //GregorianCalendar data = new GregorianCalendar(pdt);
        GregorianCalendar data = new GregorianCalendar();
        int h  = data.get(Calendar.HOUR_OF_DAY);
        int m  = data.get(Calendar.MINUTE);
        
        String hora   = h<10? "0" + h: h + "";
        String minuto = m<10? "0" + m: m + "";
        
        return hora + ":" + minuto;
    }

    //Calcula o tempo em minutos entre dois horários
    public static long getDifTime(String data1, String hora1, String data2, String hora2) {
        long dif = 0;

        //Se algum dado vier vazio, não calcular e retornar zero
        if (Util.isNull(data1) || Util.isNull(hora1) || Util.isNull(data2) || Util.isNull(hora2)) {
            return 0;
        }
        try {

            int d1 = Integer.parseInt(getDia(data1));
            int m1 = Integer.parseInt(getMes(data1));
            int a1 = Integer.parseInt(getAno(data1));
            int d2 = Integer.parseInt(getDia(data2));
            int m2 = Integer.parseInt(getMes(data2));
            int a2 = Integer.parseInt(getAno(data2));

            int h1 = Integer.parseInt(hora1.substring(0, 2));
            int mi1 = Integer.parseInt(hora1.substring(3, 5));
            int h2 = Integer.parseInt(hora2.substring(0, 2));
            int mi2 = Integer.parseInt(hora2.substring(3, 5));

            GregorianCalendar g1 = new GregorianCalendar(a1, m1 - 1, d1, h1, mi1);
            GregorianCalendar g2 = new GregorianCalendar(a2, m2 - 1, d2, h2, mi2);
            dif = Math.abs(g2.getTimeInMillis() - g1.getTimeInMillis());
        } catch (NumberFormatException ex) {
            ex.printStackTrace();
        }
        return (dif / 1000) / 60;

    }

    //Calcula o tempo em dias entre duas datas
    public static long getDifDate(String data1, String data2) {
        long dif = 0;

        //Se algum dado vier vazio, não calcular e retornar zero
        if (Util.isNull(data1) || Util.isNull(data2)) {
            return 0;
        }
        try {

            int d1 = Integer.parseInt(getDia(data1));
            int m1 = Integer.parseInt(getMes(data1));
            int a1 = Integer.parseInt(getAno(data1));
            int d2 = Integer.parseInt(getDia(data2));
            int m2 = Integer.parseInt(getMes(data2));
            int a2 = Integer.parseInt(getAno(data2));

            GregorianCalendar g1 = new GregorianCalendar(a1, m1 - 1, d1, 0, 0);
            GregorianCalendar g2 = new GregorianCalendar(a2, m2 - 1, d2, 0, 0);
            dif = g2.getTimeInMillis() - g1.getTimeInMillis();
        } catch (NumberFormatException ex) {
            ex.printStackTrace();
        }
        return (dif / 1000) / 60 / 60 / 24;

    }
    //Método privado que completa com zeros à esquerda
    public static String formataNumero(String numero, int digitos) {
        String resp = "";
        for (int i = 1; i <= digitos - numero.length(); i++) {
            resp += "0";
        }
        resp += numero;
        return resp;
    }
    //Formata a data de dd/mm/aaa para aaaa-mm-dd
    public static String formataDataInvertida(String data) {
        //Se veio nula, não tratar
        if (data == null) {
            return null;
        }
        if (data.length() >= 10) {
            String dia = data.substring(0, 2);
            String mes = data.substring(3, 5);
            String ano = data.substring(6, 10);

            return ano + "-" + mes + "-" + dia;
        } else {
            return "";
        }
    }

    //Substitui espaços em branco por código HTML (&nbsp;)
    public static String trataEspacos(String nome) {
        String resp = "";
        char letra;
        for (int i = 0; i < nome.length(); i++) {
            letra = nome.charAt(i);
            if (letra == '\n') {
                resp += "<br>";
            } else if (letra == ' ') {
                resp += "&nbsp;";
            } else {
                resp += letra;
            }
        }
        return resp;
    }

    //Recebe uma data e devolve no formato dd/mm/aaaa
    public static String formataData(String data) {
        if (data != null && data.length() >= 10) {
            String ano = data.substring(0, 4);
            String mes = data.substring(5, 7);
            String dia = data.substring(8, 10);

            return dia + "/" + mes + "/" + ano;
        } else {
            return "";
        }
    }
    //Verifica se uma data é válida
    public static boolean dataValida(int dia, int mes, int ano) {
        int vetordias[] = {0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};

        //Verifica se o ano é bissexto
        if ((ano % 4 == 0 && ano % 100 != 0) || ano % 400 == 0) {
            vetordias[2] = 29;        //Verifica se o dia está no intervalo
        }
        if (dia >= 1 && dia <= vetordias[mes]) {
            return true;
        } else {
            return false;
        }
    }
    //Recebe uma data e devolve no formato dd/mm/aaaa
    public static String formataData(int dia, int mes, int ano) {
        String sdia = "" + dia;
        String smes = "" + mes;
        String sano = "" + ano;

        if (dia < 10) {
            sdia = "0" + sdia;
        }
        if (mes < 10) {
            smes = "0" + smes;
        }
        if (dataValida(dia, mes, ano)) {
            return sdia + "/" + smes + "/" + sano;
        } else {
            return "";
        }
    }
    //Recebe uma hora do banco e retorna no formato hh:mm
    public static String formataHora(String hora) {
        try {
            if (hora == null) {
                hora = "";
            }
            if (hora.length() > 5) {
                hora = hora.substring(0, 5);
            }
            return hora;
        } catch (Exception e) {
            return e.toString();
        }
    }

    //Recebe uma hora do banco e retorna no formato hh:mm
    public static String formataHoraHHMMSS(String hora) {
        try {
            if (hora == null) {
                hora = "00:00:00";
            }
            if (hora.length() == 5) {
                hora = hora + ":00";
            }
            return hora;
        } catch (Exception e) {
            return e.toString();
        }
    }

    public static String formatCurrency(String valor) {

        //Se não veio valor, não converter
        if (isNull(valor)) {
            return "";
        }
        try {
            double d_valor = Double.parseDouble(valor);
            String resp = "";

            NumberFormat moneyFormat = NumberFormat.getCurrencyInstance(new Locale("pt", "BR"));
            resp = moneyFormat.format(d_valor);
            //Fixa o R$ antes e remove o espaço e coloca &nbsp;
            resp = "R$&nbsp;" + resp.substring(3);

            return resp;
        } catch (Exception e) {
            return "Valor:" + valor + " ERRO: " + e.toString();
        }
    }

    public static String formatCurrencyOld(String valor) {

        String resp = "0";

        if (valor != null && !valor.equals("")) {
            try {
                //Pega o valor e converte em float
                float lvalor = Float.parseFloat(valor);

                //Arredonda para 2 casas decimais
                lvalor = (float) (Math.round(lvalor * 100)) / 100;

                //Converte novamente em String
                valor = lvalor + "";

                //Troca o ponto por vírgula
                resp = valor.replace('.', ',');

                //Acha a vírgula
                int virgula = resp.indexOf(',');

                //Captura as casas decimais
                String decimal = resp.substring(virgula + 1);

                //Se tiver mais de 2 casas decimais, cortar até a 2ª
                if (decimal.length() > 2) {
                    resp = resp.substring(0, virgula + 3);
                //Se tiver só uma, completar com zero
                } else if (decimal.length() < 2) {
                    resp = resp + "0";                //Pega a parte inteira
                }
                String inteira = resp.substring(0, virgula);

                //Varre a estrutura e a cada 3 caracteres, insere um ponto (milhar)
                String aux = "";
                int cont = 0;
                for (int j = inteira.length() - 1; j >= 0; j--) {
                    //Se for múltiplo de 3 (exceto o peimeiro 0)
                    if (cont % 3 == 0 && cont != 0) {
                        aux = inteira.charAt(j) + "." + aux;
                    } else {
                        aux = inteira.charAt(j) + aux;
                    }
                    cont++;
                }

                resp = inteira;///aux + resp.substring(virgula);
            } catch (Exception e) {
                resp = e.toString();
            }
        }

        return resp;
    }
    //Retorno o nome do arquivo a partir do path
    public static String getArquivo(String path) {
        int barra = path.lastIndexOf('\\');
        if (barra != -1) {
            return path.substring(barra + 1);
        } else {
            return path;
        }
    }
    //Converte uma hora no formato hh:mm e minutos
    public static int emMinutos(String hora) {
        try {
            int h = Integer.parseInt(hora.substring(0, 2));
            int m = Integer.parseInt(hora.substring(3, 5));

            return (h * 60) + m;
        } catch (Exception e) {
            return 0;
        }
    }
    //Recebe uma quantidade de minutos e coverte no formato hh:mm
    public static String emHoras(int minutos) {

        int h = minutos / 60;
        int m = minutos % 60;

        String hora,minuto ;

        if (h < 10) {
            hora = "0" + h;
        } else {
            hora = "" + h;
        }
        if (m < 10) {
            minuto = "0" + m;
        } else {
            minuto = "" + m;
        }
        return hora + ":" + minuto;
    }
    //Formata textos para remover caracteres especiais e substituir por HTML
    public static String formataTextoLista(String texto) {
        String resp = "";

        //Se vier texto nulo, retornar vazio
        if (texto == null) {
            return "";
        }
        try {
            resp = texto.replace("\t", "&nbsp;&nbsp;&nbsp;&nbsp;");
        } catch (Exception e) {
            resp = "ERRO no Util.formataTextoLista: " + e.toString();
        }
        return resp;
    }
    
    //Formata textos para remover caracteres especiais e substituir por HTML
    public static String formataTexto(String texto) {

        //Se veio nulo, retornar vazio
        if (texto == null) {
            return "";
        }
        try {
            //Se for data, converter para formato data
            if (texto.length() == 10 && texto.charAt(4) == '-' && texto.charAt(7) == '-') {
                texto = Util.formataData(texto);
                return texto;
            }

            texto = texto.replace('\'', '´');
            return texto;
        } catch (Exception e) {
            return "ERRO: " + e.toString();
        }
    }
    //Monta links para paginação
    public static String criaPaginacao(String pagina, int numPag, int qtdeporpagina, int total) {
        String paginacao = "";

        int comeco,  fim;

        //Calcula a quantidade de páginas
        int totalPaginas = total / qtdeporpagina;

        //Se no arredondamento faltar itens, colocar uma página a mais
        if (totalPaginas * qtdeporpagina < total) {
            totalPaginas++;        //Até a página 5, colocar de 1 a 10
        }
        if (numPag <= 5) {
            comeco = 1;
            fim = totalPaginas < 10 ? totalPaginas : 10;
        } //De 6 em diante, colocar 5 para frente e 5 para trás
        else {
            comeco = numPag - 5;
            fim = totalPaginas < numPag + 5 ? totalPaginas : numPag + 5;
        }

        //Monta a paginação
        for (int i = comeco; i <= fim; i++) {
            if (i == numPag) {
                paginacao += "<font color='#6F0000'><b>" + i + "</b></font> ";
            } else {
                paginacao += "<a style='text-decoration:underline' title='Pág. " + i + "' href=\"Javascript:navegacao('" + pagina + "'," + i + ")\">" + i + "</a> ";
            }
        }

        //Se não vier resultados
        if (total == 0) {
            paginacao += " <b>(Nenhum registro encontrado)</b>";
        //Se só vier 1 resultado, colocar no singular
        } else if (total == 1) {
            paginacao += " <b>(" + total + " registro encontrado)</b>";
        //Se vier mais de 1 registro
        } else {
            paginacao += " <b>(" + total + " registros encontrados)</b>";        //Coloca campo oculto com a página que está
        }
        paginacao += "<input type='hidden' name='numPag' value='" + numPag + "'>";

        return paginacao;
    }
    //Verifica se um item String está nulo ou vazio
    public static boolean isNull(String dado) {
        if (dado == null) {
            return true;
        }
        dado = dado.trim();
        if (dado.equals("")) {
            return true;
        }
        if (dado.equalsIgnoreCase("null")) {
            return true;
        }
        return false;
    }
    //Converte de RTF para HTML
    public static String RTF2HTML(String entrada) {
        StringReader stream;
        if (entrada == null) {
            return "";
        }
        try {
            entrada = entrada.replace('\'', '´');

            stream = new StringReader(entrada);
            RTFEditorKit kit = new RTFEditorKit();
            javax.swing.text.Document doc = kit.createDefaultDocument();
            kit.read(stream, doc, 0);
            return doc.getText(0, doc.getLength());
        } catch (Exception e) {
            return e.toString();
        }
    }
    //Executa um programa externo
    public static String converteDHWtoPNG(String caminhoupload, String caminhoperl, String caminhoj2sdk, String nomearquivo) {

        try {
            String programa1[] = {caminhoperl + "perl.exe", caminhoupload + "dhw2ps.pl", "--ps", caminhoupload + nomearquivo};
            String programa2[] = {caminhoj2sdk + "java", "-cp", caminhoupload + "digimemo.jar", "DigiPSToPng", caminhoupload, nomearquivo};
            Process p1 = Runtime.getRuntime().exec(programa1);
            Process p2 = Runtime.getRuntime().exec(programa2);
            return "OK";
        } catch (Exception e) {
            return e.toString();
        }

    }
    //Executa um Trim
    public static String trim(String str) {
        try {
            if (str == null) {
                return "";
            } else {
                str = str.replace("'", "''");
                return str.trim();
            }
        } catch (Exception e) {
            return "";
        }
    }
    //Trata nulos ou vazios com outra coisa
    public static String trataNulo(String valor, String novo) {
        if (Util.isNull(valor)) {
            return novo;
        }
        return valor;
    }

    /**
     *    1 - Valor a arredondar.
     *    2 - Quantidade de casas depois da vírgula.
     *    3 - Arredondar para cima ou para baixo?
     *        Para cima = 0 (ceil)
     *        Para baixo = 1 ou qualquer outro inteiro (floor)
     **/
    public static double arredondar(String valor, int casas, int tipo) {
        if (isNull(valor)) {
            return 0;
        } else {
            return arredondar(Double.parseDouble(valor), casas, tipo);
        }
    }

    public static double arredondar(double valor, int casas, int tipo) {
        double arredondado = valor;
        arredondado *= (Math.pow(10, casas));
        if (tipo == 0) {
            arredondado = Math.ceil(arredondado);
        } else if (tipo == 1) {
            arredondado = Math.floor(arredondado);
        } else {
            arredondado = Math.round(arredondado);
        }
        arredondado /= (Math.pow(10, casas));
        return arredondado;
    }
    //Cria um arquivo file com um conteúdo memo
    public static void criaArquivo(String file, String memo) {
        try {
            FileWriter fw = new FileWriter(file);
            fw.write(memo);
            fw.close();
        } catch (Exception er) {
        }
    }

    private static int getDias(int mes, int ano) {
        //Cria vetor com a quantidade de dias de cada mês
        int vetorDias[] = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
        //Se for ano bissexto, fevereiro tem 29 dias
        if ((ano % 4 == 0 && ano % 100 != 0) || ano % 400 == 0) {
            vetorDias[1] = 29;        //Retorna a quantidade de dias do mês, mas se for janeiro, retornar dezembro
        }
        if (mes > 0) {
            return vetorDias[mes - 1];
        } else {
            return vetorDias[11];
        }
    }
    //Devolve o tempo de vida da pessoa em anos, meses e dias
    public static String getIdade(String nascimento) {
        return getIdade(nascimento, Util.getData());
    }

    //Devolve o tempo de vida da pessoa em anos, meses e dias até uma data
    public static String getIdade(String nascimento, String data) {
        //Se Nao veio data de nascimento, não calcula idade
        if (Util.isNull(nascimento) || nascimento.length() != 10) {
            return "";        //Se não veio data da história, considerar data atual
        }
        if (Util.isNull(data)) {
            data = Util.getData();        //Variáveis
        }
        int anos,  meses,  dias;
        String Sanos,Smeses ,Sdias ;

        //Separa dia, mês e ano para calcular idade
        int dia = Integer.parseInt(nascimento.substring(0, 2));
        int mes = Integer.parseInt(nascimento.substring(3, 5));
        int ano = Integer.parseInt(nascimento.substring(6));

        //Captura a data atual
        GregorianCalendar dataRef = toDate(data);
        int diahoje = dataRef.get(Calendar.DATE);
        int meshoje = dataRef.get(Calendar.MONTH) + 1;
        int anohoje = dataRef.get(Calendar.YEAR);

        //Diferença entre os anos
        anos = anohoje - ano;

        //Se ainda não chegou no mês de aniversário
        if (meshoje < mes) {
            anos--;
            meses = 12 - (mes - meshoje);
            if (diahoje < dia) {
                meses--;
                dias = (getDias(meshoje - 1, anohoje) - dia) + diahoje;
            } else {
                //Resto do mês atual mais dias do mês seguinte até o aniversário
                dias = diahoje - dia;
            }
        } //Se está no mês do aniversário
        else if (meshoje == mes) {
            //Se ainda não chego no dia
            if (diahoje < dia) {
                anos--;
                meses = 11;
                dias = getDias(meshoje - 1, anohoje) - dia + diahoje;
            } else {
                meses = 0;
                dias = diahoje - dia;
            }
        } //Se já passou o mês de aniversário
        else {
            meses = meshoje - mes;
            if (diahoje < dia) {
                meses--;
                dias = getDias(meshoje - 1, meshoje) - dia + diahoje;
            } else {
                dias = diahoje - dia;
            }
        }

        //Se tiver zerado algum item, não imprimir
        if (anos == 0) {
            Sanos = "";
        } else {
            Sanos = anos + "a ";
        }
        if (meses == 0) {
            Smeses = "";
        } else {
            Smeses = meses + "m ";
        }
        if (dias == 0) {
            Sdias = "";
        } else {
            Sdias = dias + "d ";
        }
        return (Sanos + Smeses + Sdias);

    }

    //Compacta um arquivo de entrada em um arquivo de saída
    public static void compactar(String arqEntrada, String arqSaida) {
        //variaveis
        int i,  cont;

        // Este array receberá os bytes lidos do arquivo a ser compactado.
        // Veja que TAMANHO_BUFFER foi declarado como uma constante inteira de valor 2048, logo, o arquivo
        // será lido de 2 em 2 KB. Você pode optar por ler blocos maiores ou menores, sem problema.
        byte[] dados = new byte[TAMANHO_BUFFER];

        // f nos dará informações sobre a pasta (entrada) em que se encontra a classe.
        File f = null;
        // Streams de entrada e saída.
        BufferedInputStream origem = null;
        FileInputStream streamDeEntrada = null;
        BufferedOutputStream buffer = null;
        FileOutputStream destino = null;
        // saida será usada para gravar nossos dados de forma comprimida.
        ZipOutputStream saida = null;
        // Cada entrada do nosso arquivo ZIP.
        ZipEntry entry = null;

        try {
            destino = new FileOutputStream(arqSaida);
            buffer = new BufferedOutputStream(destino);
            saida = new ZipOutputStream(buffer);

            File arquivo = new File(arqEntrada);

            //Se é um arquivo ou se o nome do arquivo é diferente do nome
            //de saida.
            if (arquivo.isFile() && !(arquivo.getName()).equals(arqSaida)) {
                System.out.println("Compactando: " + arquivo.getName());

                streamDeEntrada = new FileInputStream(arquivo);
                origem = new BufferedInputStream(streamDeEntrada, TAMANHO_BUFFER);
                entry = new ZipEntry(arquivo.getName());
                saida.putNextEntry(entry);

                //Saida que estamos enviando um novo
                //arquivo (entrada).
                //Gravar (de 2 em 2 KB,) os
                //dados no arquivo ZIP.
                while ((cont = origem.read(dados, 0, TAMANHO_BUFFER)) != -1) {
                    saida.write(dados, 0, cont);
                }

                origem.close();
            }

            saida.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    //Recebe uma String e retorna outra somente com os números encontrados
    //Remove todos os outros caracteres
    public static String soNumeros(String valor) {

        String resp = "";
        char ch;
        for (int i = 0; i < valor.length(); i++) {
            //Captura caracter por caracter
            ch = valor.charAt(i);
            //Se for número, concatenar
            if (ch == '1' || ch == '2' || ch == '3' || ch == '4' || ch == '5' || ch == '6' || ch == '7' || ch == '8' || ch == '9' || ch == '0') {
                resp += ch;
            }
        }
        return resp;
    }

    /**
     * Calcula carimbo MD5 sobre um string dado.
     * @param pBase O string base.
     * @param pCharSet O character set no qual o string base deve ser considerado
     *        valor fixo "ISO8859_1"
     * @return O carimbo MD5, na forma de um string.
     */
    public static String digest(String pBase, String pCharSet) {
        String wdgs = null;
        try {
            MessageDigest wmd = MessageDigest.getInstance("MD5");
            wmd.reset();

            // valor fixo "ISO8859_1"
            wmd.update(pBase.getBytes(pCharSet));
            byte[] wdg = wmd.digest();
            StringBuffer hexString = new StringBuffer();
            for (int i = 0; i < wdg.length; i++) {
                String w_dup = Integer.toHexString(0xFF & wdg[i]);
                if (w_dup.length() < 2) {
                    w_dup = "0" + w_dup;
                }
                hexString.append(w_dup);
            }
            wdgs = hexString.toString();
        } catch (NoSuchAlgorithmException ex) {
            ex.printStackTrace();
        } finally {
            return wdgs;
        }
    }

    //Verifica se uma página está no ar
    public static String getStatusPage(String strurl) {

        String resp = "";
        try {
            // Create a URL for the desired page
            URL url = new URL(strurl);
            resp = url.getContent().toString();

            return "OK";

        } catch (MalformedURLException e) {
            resp = e.toString();
        } catch (IOException e) {
            resp = e.toString();
        } catch (Exception e) {
            resp = e.toString();
        }

        return resp;
    }
    //Busca o conteúdo de uma página HTML
    public static String getPagina(String strurl) {

        String resp = "";
        Authenticator.setDefault(new Autenticador());

        try {
            // Create a URL for the desired page
            URL url = new URL(strurl);

            // Read all the text returned by the server
            BufferedReader in = new BufferedReader(new InputStreamReader(url.openStream()));
            String str;
            while ((str = in.readLine()) != null) {
                resp += str;
            }
            in.close();
        } catch (MalformedURLException e) {
            resp = e.toString();
        } catch (IOException e) {
            resp = e.toString();
        } catch (Exception e) {
            resp = e.toString();
        }

        return resp;
    }

    //Retorna true se um arquivo existe e false se não
    public static boolean existeArquivo(String path) {
        String baseFolder = Propriedade.getCampo("baseFolder");
        File f = new File(baseFolder + "//" + path);
        return f.exists();
    }
    //Retorna se tem atualização no sistema ou no#no se não tiver
    //resp[0] = nova versão
    //resp[1] = data da nova versão
    public static String[] verificaAtualizacoes() {
        String resp[] = new String[2];
        try {
            String atual[] = new Atualizacao().getUltimaVersao();
            String dados = Util.getPagina("http://www.katusis.com.br/buscaatualizacoes.asp?v=" + atual[0]);
            resp = dados.split("#");

            //Se veio erro, a mensagem é uma só e não conseguiu fazer split
            if (resp.length == 1) {
                resp = new String[2];
                resp[0] = "no";
                resp[1] = "no";
            }
        } catch (Exception e) {
            resp[0] = "ERRO: " + e.toString();
        }
        return resp;
    }

    public static boolean terminaCom(String texto, String termino) {

        String fim = texto.substring(texto.length() - termino.length(), texto.length());

        if (fim.equalsIgnoreCase(termino)) {
            return true;
        } else {
            return false;
        }
    }
    //Recebe um vetor de Strings e devolve no formato de String separado por vírgulas
    public static String vetorToString(String vetor[]) {
        String resp = "";
        int i = 0;

        //Se o vetor está vazio, retornar vazio
        if (vetor == null || vetor.length == 0) {
            return resp;        //Pega todos os valores e acumula na String
        }
        for (i = 0; i < vetor.length - 1; i++) {
            resp += vetor[i] + ", ";
        }
        resp += vetor[i];
        return resp;
    }

    //Insere um usuário na variável de aplicação
    public static void insereUsuario(String cod_usuario, ServletContext app) {
        //Verifica se o usuário já está na lista
        boolean achou = false;

        //Recupera o vetor de usuários na variável de aplicação
        Vector lista = (Vector) app.getAttribute("codigos");

        //Se a lista está nula, criar uma nova
        if (lista == null) {
            lista = new Vector();        //Varre a lista verificando se ja existe 
        }
        for (int i = 0; i < lista.size(); i++) {
            if (cod_usuario.equals((String) lista.get(i))) {
                achou = true;
            }
        }

        //Adiciona o usuário na lista se ainda não existir
        if (!achou) {
            lista.add(cod_usuario);        //Coloca novamente o vetor na variavel de aplicação 
        }
        app.setAttribute("codigos", lista);

    }
    //Remove um usuário da variável de aplicação
    public static void removeUsuario(String cod_usuario, ServletContext app) {
        //Recupera o vetor de usuários na variável de aplicação
        Vector lista = (Vector) app.getAttribute("codigos");

        //Se a lista não está nula, remove
        if (lista != null) {
            lista.removeElement(cod_usuario);
        }

        //Coloca novamente o vetor na variavel de aplicação 
        app.setAttribute("codigos", lista);

    }
    //Devolve combo de estados
    public static String getUF(String uf) {
        String resp = "";
        String ufs[] = {"", "AC", "AL", "AM", "AP", "BA", "CE", "DF", "ES", "GO", "MA", "MG", "MS", "MT", "PA", "PB", "PE", "PI", "PR", "RJ", "RN", "RO", "RR", "RS", "SC", "SE", "SP", "TO"};
        int i = 0;

        resp = "<select name='uf' id='uf' class='caixa'>\n";
        for (i = 0; i < ufs.length; i++) {
            if (!Util.isNull(uf) && uf.equals(ufs[i])) {
                resp += "<option value='" + ufs[i] + "' selected>" + ufs[i] + "</option>\n";
            } else {
                resp += "<option value='" + ufs[i] + "'>" + ufs[i] + "</option>\n";
            }
        }
        resp += "</select>\n";
        return resp;
    }
    //Verifica se uma String pertence a um vetor de Strings
    public static boolean pertence(String valor, Object vetor[]) {
        boolean resp = false;

        //Se vetor veio vazio ou o valor, retornar que não achou
        if (Util.isNull(valor) || vetor == null) {
            return resp;        //Tira espaços adicionais
        }
        valor = valor.trim();

        //Varre o vetor procurando o elemento
        for (int i = 0; i < vetor.length; i++) {
            //Se achar, troca o flag e força sair do loopping
            String valorVetor = vetor[i].toString().trim();

            if (valor.equalsIgnoreCase(valorVetor)) {
                resp = true;
                i = vetor.length;
            }
        }
        return resp;
    }

    //Converte um Vector em String separada por vírgulas
    public static String Vector2String(Vector vetor) {
        String resp = "";

        //Se vier nulo, sair
        if (vetor == null) {
            return "";        //Concatena todos os itens com uma vírgula depois (exceto o último)
        }
        for (int i = 0; i < vetor.size() - 1; i++) {
            resp += vetor.get(i).toString() + ",";
        }

        //Insere o último item (se tiver pelo menos 1 no vetor)
        if (vetor.size() > 0) {
            resp += vetor.get(vetor.size() - 1).toString();
        }
        return resp;
    }

    public static String freeRTE_Preload(String content) {
        String resp = content;
        resp = resp.replace("\n", " ");
        resp = resp.replace("\r", " ");
        resp = resp.replace("\t", " ");
        resp = resp.replace("'", "\"");
        return resp;
    }
    //Converte uma hora String hh:mm:ss em objeto
    public static GregorianCalendar toTime(String hora, int dia, int mes, int ano) {
        int h,  m,  s;
        GregorianCalendar resp;
        try {
            h = Integer.parseInt(hora.substring(0, 2));
            m = Integer.parseInt(hora.substring(3, 5));
            resp = new GregorianCalendar(ano, mes - 1, dia, h, m);
            return resp;
        } catch (Exception e) {
            return null;
        }
    }

    public static String toString(GregorianCalendar data) {
        int dia,  mes,  ano;
        String sd,sm ,sa ;

        try {
            dia = data.get(Calendar.DATE);
            mes = data.get(Calendar.MONTH) + 1;
            ano = data.get(Calendar.YEAR);

            sd = (dia < 10) ? "0" + dia : "" + dia;
            sm = (mes < 10) ? "0" + mes : "" + mes;
            sa = "" + ano;

            return sd + "/" + sm + "/" + sa;
        } catch (Exception e) {
            return "Erro na conversão para String: " + e.toString();
        }
    }
    //Converte uma data de dd/mm/aaaa para GregorianCalendar
    public static GregorianCalendar toDate(String data) {

        //Se não veio data no formato correto, retornar nulo
        if (Util.isNull(data) || data.length() != 10) {
            return null;
        }
        try {
            //Separa dia, mês e ano para calcular idade
            int dia = Integer.parseInt(data.substring(0, 2));
            int mes = Integer.parseInt(data.substring(3, 5));
            int ano = Integer.parseInt(data.substring(6));

            GregorianCalendar gc = new GregorianCalendar(ano, mes - 1, dia);
            return gc;

        } catch (Exception e) {
            return null;
        }

    }

    //Adiciona dias em uma data
    public static String addDias(String data, int dias) {
        int dia,  mes,  ano;
        String resp;

        //Separa dias, meses e anos
        dia = Integer.parseInt(data.substring(0, 2));
        mes = Integer.parseInt(data.substring(3, 5));
        ano = Integer.parseInt(data.substring(6));

        GregorianCalendar gc = new GregorianCalendar(ano, mes - 1, dia + dias - 1);
        resp = toString(gc);

        return resp;
    }
    //Trata valor para inserir no banco
    public static String trataValorNulo(String valor) {
        if (Util.isNull(valor)) {
            return "null";
        } else {
            return "'" + valor + "'";
        }
    }

    public static String cortaString(String str, int limite) {
        String resp = "";

        //Se veio nulo, retornar vazio
        if (Util.isNull(str)) {
            return "";        //Verifica se o tamanho da String é maior que o limite, se for, cortar
        }
        if (str.length() > limite) {
            resp = str.substring(0, limite);
        } else {
            resp = str;
        }
        return resp;
    }
    //Método que monta os botões de Novo, Salvar, Excluir e Pesquisar
    public static String getBotoes(String pagina, String pesq, int tipo) {
        return getBotoes(pagina, pesq, tipo, false);
    }

    //Método que monta os botões de Novo, Salvar, Excluir e Pesquisar
    public static String getBotoes(String pagina, String pesq, int tipo, boolean imprime) {
        String resp = "";

        try {
            Banco banco = new Banco();

            resp += "<tr align='center' valign='top'>\n";
            resp += " <td width='100%'>\n";
            resp += "  <table width='100%' border='0' cellpadding='0' cellspacing='0' class='table'>\n";
            resp += "   <tr>\n";
            resp += "    <td class='tdMedium' style='text-align:center'>\n";
            resp += "      	<button type='button' name='novo' id='novo' class='botao' style='width:70px' onClick='clickBotaoNovo()'><img src='images/16.gif' height='17'>&nbsp;&nbsp;&nbsp;&nbsp;Novo</button>\n";
            resp += "    </td>\n";
            resp += "    <td class='tdMedium' style='text-align:center'>\n";
            resp += "     	<button type='button' name='salvar' id='salvar' class='botao' style='width:70px' onClick='clickBotaoSalvar()'><img src='images/gravamini.gif' height='17'>&nbsp;&nbsp;&nbsp;&nbsp;Salvar</button>\n";
            resp += "    </td>\n";
            resp += "    <td class='tdMedium' style='text-align:center'>\n";
            resp += "           <button type='button' name='exclui' id='exclui' class='botao' style='width:70px' onClick='clickBotaoExcluir()'><img src='images/delete.gif' width='13' height='17'>&nbsp;&nbsp;&nbsp;&nbsp;Excluir</button>\n";
            resp += "     </td>\n";

            //Se tem imprime
            if (imprime) {
                resp += "<td class='tdMedium' style='text-align:center'><a href='Javascript:imprime()' title='Imprime Ficha Modelo'><img src='images/print.gif' border='0'></a></td>";
            }

            resp += "     <td class='tdMedium' style='text-align:left'>\n";
            resp += "	<input type='text' name='pesq' id='pesq' class='caixa' value='" + pesq + "' style='width:" + ((imprime) ? "90" : "150") + "px' onKeyPress=\"buscarEnter(event, '" + pagina + "');\">&nbsp;\n";
            resp += "           <select name='tipo' id='tipo' class='caixa'>\n";
            resp += "		<option value='1'" + banco.getSel(tipo, 1) + ">Exata</option>\n";
            resp += "		<option value='2'" + banco.getSel(tipo, 2) + ">Início</option>\n";
            resp += "		<option value='3'" + banco.getSel(tipo, 3) + ">Meio</option>\n";
            resp += "	    </select>\n";
            resp += "	<button type='button' class='botao' style='width:80px' onClick=\"buscar('" + pagina + "');\">";
            resp += "       <img src='images/busca.gif' height='17'>&nbsp;Consultar</button></td>\n";
            resp += "   </tr>\n";
            resp += "  </table>\n";
            resp += " </td>\n";
            resp += "</tr>\n";
        } catch (Exception e) {
            resp = "ERRO: " + e.toString();
        }
        return resp;

    }

    //Recebe um texto em HTML e devolve em formato texto
    public static String htmltotext(String texto) {
        try {
            Pattern pDel = Pattern.compile("(?s)<.*?>");
            Pattern pText = Pattern.compile("(.*)");
            Matcher m;

            if (texto != null) {
                //remove as TAGS
                m = pDel.matcher(texto);
                texto = m.replaceAll(" ");
                texto = texto.trim();

                //capture all the other text lines for later processing since all font tags appear
                //before they are used, the they're in memory by now.
                m = pText.matcher(texto);
                if (m.matches()) {
                    texto = m.group(1);
                    texto = texto.trim();
                }
                return texto;
            }
            return texto;
        } catch (Exception e) {
            return "ERRO no htmltotext: " + e.toString();
        }
    }
    //Recebe um paciente, uma data de referência e se importa se a agenda é ausente ou não
    //e retorna se é paciente de primeira vez
    public static boolean primeiraVez(String codcli, String data, boolean importaseveio) {
        boolean resp = true;
        String sql = "SELECT agendamento_id FROM agendamento ";
        sql += "WHERE ativo='S' AND codcli=" + codcli;
        sql += " AND data < '" + formataDataInvertida(data) + "' ";

        //Se importa se veio, filtrar
        if (importaseveio) {
            sql += "AND status <> 3";        //Busca se existe agendamento
        }
        String aux = new Banco().getValor("agendamento_id", sql);

        //Se não existir, é primeira vez
        if (Util.isNull(aux)) {
            resp = true;
        } else {
            resp = false;
        }
        return resp;
    }
    
    //Remove a acentuação da palavra
    public static String tiraAcento(String palavra) {
        
        //Se não veio nada, nem tratar
        if(Util.isNull(palavra)) return "";
        
        //Trabalha somente com minúscular
        String resp = palavra.toLowerCase();
        
        //A
        resp = resp.replace("á","a");
        resp = resp.replace("à","a");
        resp = resp.replace("ã","a");
        resp = resp.replace("â","a");
        resp = resp.replace("ä","a");
        
        //E
        resp = resp.replace("é","e");
        resp = resp.replace("ê","e");
        resp = resp.replace("è","e");
        resp = resp.replace("ë","e");
        
        //I
        resp = resp.replace("í","i");
        resp = resp.replace("î","i");
        resp = resp.replace("ì","i");
        resp = resp.replace("ï","i");
        
        //O
        resp = resp.replace("ó","o");
        resp = resp.replace("ò","o");
        resp = resp.replace("õ","o");
        resp = resp.replace("ô","o");
        resp = resp.replace("ö","o");
        
        //U
        resp = resp.replace("ú","u");
        resp = resp.replace("ù","u");
        resp = resp.replace("û","u");
        resp = resp.replace("ü","u");
        
        //Especiais
        resp = resp.replace("ç","c");
        resp = resp.replace("ñ","n");
        
        return resp;
    }
    
    //Remover caracteres "estranhos"
    public static String removeCaracteres(String palavra) {
       String resp = "";
       String chvalidos = "abcdefghijklmnopqrstuvwxyz1234567890 .,-+:/";
       
       //Se tiver nulo, não tratar
       if(Util.isNull(palavra)) return "";
       
       //Converte para minúscula para checar
       palavra = palavra.toLowerCase();
       
       //Varre a string
       for(int i=0; i<palavra.length(); i++) {
           //Verifica se o caracter está na coleção
           if(chvalidos.indexOf(palavra.charAt(i))>=0)
               resp += palavra.charAt(i);
       }

        return resp;
       
    }
    
    public static String trataTermo(String termo) {
        
        //Se vier nulo, ignore
        if(Util.isNull(termo)) return "";
        
        //Remove acentos
        termo = tiraAcento(termo);
        
        //Remover caracteres estranhos
        termo = removeCaracteres(termo);

        //Remove espaços à esq e dir
        termo = termo.trim();

        //Converte em maiúscula
        termo = termo.toUpperCase();
        
        return termo;
    }
    
    //Recebe data/hora no formato aaaa-mm-ddThh:mm e formata para dd/mm/aaaa e hh:mm
    public static String formataDataHora(String datahora) {
        String resp = "";

        //Se veio nulo, nem continua
        if(Util.isNull(datahora)) return "";
        
        try {
            resp  = Util.formataData(datahora.substring(0,10));
            resp += " " + datahora.substring(11);
        }
        catch(Exception e) {
            resp= "ERRO: " + e.toString();
        }
        return resp;
    }

    //Tranforma uma hora em minutos
    public static float emMinutos(GregorianCalendar hora) {
        int h, m;
        h = hora.get(Calendar.HOUR_OF_DAY);
        m = hora.get(Calendar.MINUTE);

        return (h * 60) + m;
    }

    //Adiciona minutos na sua hora
    public static GregorianCalendar addMinutos(GregorianCalendar data, int minutos) {
        int h, m, dia, mes, ano;
        GregorianCalendar resp;
        dia = data.get(Calendar.DATE);
        mes = data.get(Calendar.MONTH);
        ano = data.get(Calendar.YEAR);

        h = data.get(Calendar.HOUR_OF_DAY);
        m = data.get(Calendar.MINUTE);
        resp = new GregorianCalendar(ano, mes, dia, h, m + minutos);

        return resp;
    }

    //Converte GregorianCalendar de hora para o formato hh:mm
    public static String GC2HHMM(GregorianCalendar hora) {
        int h, m;
        String resp, hs = "", ms = "";
        try {
            h = hora.get(Calendar.HOUR_OF_DAY);
            m = hora.get(Calendar.MINUTE);

            if (h < 10) {
                hs = "0";
            }
            if (m < 10) {
                ms = "0";
            }
            resp = hs + h + ":" + ms + m;

            return resp;
        } catch (Exception e) {
            return "Erro na conversão para String: " + e.toString();
        }
    }

    //Recebe uma string dinheiro e devolve no formato de valor (só pontos)
    public static String getValorMoney(String valor) {
        String resp = valor;

        //Se vier nulo, valor zero
        if(Util.isNull(valor)) return "0";

        //Se tiver ponto e vírgula e o ponto antes da vírgula, então veio no formato 23.333,50
        if(resp.indexOf(".")>=0 && resp.indexOf(",")>=0 && resp.indexOf(".")< resp.indexOf(",")) {
            //Tira o ponto
            resp = resp.replace(".", "");
            //Troca vírgula por ponto
            resp = resp.replace(",", ".");
        }
        //Se tiver ponto e vírgula e o ponto depois da vírgula, então veio no formato 23,333.50
        else if(resp.indexOf(".")>=0 && resp.indexOf(",")>=0 && resp.indexOf(".")> resp.indexOf(",")) {
            //Tira a vírgula
            resp = resp.replace(",", "");
        }
        //Se veio só com vírgula, vira ponto
        else if(resp.indexOf(",")>=0) {
            //Tira a vírgula
            resp = resp.replace(",", ".");
        }
        return resp;
    }

  
}