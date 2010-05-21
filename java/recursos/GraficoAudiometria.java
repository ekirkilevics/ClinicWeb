/* Arquivo: GraficoAudiometria.java
 * Autor: Amilton Souza Martha
 * Cria��o: 06/05/2009   Atualiza��o: 06/05/2009
 * Obs: Gera gr�ficos de Audiometria
 */
package recursos;

import com.keypoint.PngEncoder;
import java.sql.ResultSet;

import java.awt.Color;
import java.awt.Font;
import java.awt.image.BufferedImage;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;
import javax.servlet.http.HttpServletResponse;
import org.jfree.chart.ChartFactory;
import org.jfree.chart.JFreeChart;
import org.jfree.chart.annotations.XYTextAnnotation;
import org.jfree.chart.axis.NumberAxis;
import org.jfree.chart.plot.PlotOrientation;
import org.jfree.chart.plot.XYPlot;
import org.jfree.chart.renderer.xy.XYLineAndShapeRenderer;
import org.jfree.data.xy.XYSeries;
import org.jfree.data.xy.XYSeriesCollection;

public class GraficoAudiometria {

    //Atributos do gr�fico
    private String cod_audiometria;     //C�d. do exame de audiologia
    private String lado;                //E-esquerdo ou D-Direito

    //Atributos privados para conex�o
    private Connection con = null;
    private Statement stmt = null;

    public GraficoAudiometria() {
        con = Conecta.getInstance();
    }

    public byte[] gerarGrafico(String cod_audiometria, String lado, HttpServletResponse response, int width, int height) {

        //Altera par�metros
        this.setCod_audiometria(cod_audiometria);
        this.setLado(lado);

        try {
            JFreeChart chart = this.createChart(this.createDataset());

            //Configura sa�da do navehador para imagem
            response.setContentType( "image/png" );

            //Converte o gr�fico em imagem e publica
            BufferedImage buf = chart.createBufferedImage(width, height, null);
            PngEncoder encoder = new PngEncoder( buf, false, 0, 9 );

            //response.getOutputStream().write( encoder.pngEncode() );

            return encoder.pngEncode();
        }
        catch(Exception e) {

            return null;
        }

    }

    public XYSeriesCollection createDataset() {

        XYSeriesCollection ds = new XYSeriesCollection();

        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);

            ResultSet rs = null;

            String sql = "SELECT * FROM audiometria WHERE cod_audiometria=" + this.getCod_audiometria();

            //Executa a pesquisa
            rs = stmt.executeQuery(sql);

            //Se achou o exame, montar
            if (rs.next()) {
                //Linha das medi��es via a�rea
                XYSeries viaaerea = new XYSeries("via a�rea");
                insereValor(rs.getString(this.getLado() + "_a_025"), viaaerea, 0.25);
                insereValor(rs.getString(this.getLado() + "_a_050"), viaaerea, 0.50);
                insereValor(rs.getString(this.getLado() + "_a_1"), viaaerea, 1);
                insereValor(rs.getString(this.getLado() + "_a_2"), viaaerea, 2);
                insereValor(rs.getString(this.getLado() + "_a_3"), viaaerea, 3);
                insereValor(rs.getString(this.getLado() + "_a_4"), viaaerea, 4);
                insereValor(rs.getString(this.getLado() + "_a_6"), viaaerea, 6);
                insereValor(rs.getString(this.getLado() + "_a_8"), viaaerea, 8);

                //Adiciona linha no gr�fico
                ds.addSeries(viaaerea);

            }
            rs.close();
            stmt.close();

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return ds;
    }

    private JFreeChart createChart(XYSeriesCollection dataset){//cria gr�fico

        XYLineAndShapeRenderer renderer = new XYLineAndShapeRenderer();

        //Verifica os s�mbolos de acordo com os lados
        String simbol1="", simbol2="", titulo="";
        if(this.getLado().equalsIgnoreCase("D")) {
            simbol1 = "O";
            simbol2 = "<";
            titulo = "Orelha Direita";
            renderer.setSeriesPaint(0, java.awt.Color.RED); //Cor da linha
        }
        else {
            simbol1 = "X";
            simbol2 = ">";
            titulo = "Orelha Esquerda";
            renderer.setSeriesPaint(0, java.awt.Color.BLUE); //Cor da linha
        }

        // cria o gr�fico
        final JFreeChart chart = ChartFactory.createXYLineChart(
                titulo, // t�tulo do gr�fico
                "Frequ�ncia - KHz", // t�tulo eixo X
                "Intensidade - dB", // t�tulo eixo Y
                dataset, // linha criada
                PlotOrientation.VERTICAL,
                false, // inclui legenda
                true, // tooltips
                false // urls
        );

        //Cor de fundo
        chart.setBackgroundPaint(Color.WHITE);

        //Cores do gr�fico
        final XYPlot plot = chart.getXYPlot();
        plot.setBackgroundPaint(Color.LIGHT_GRAY);
        plot.setDomainGridlinePaint(Color.BLACK);
        plot.setRangeGridlinePaint(Color.BLACK);

        //Invertendo o eixo Y
        plot.getRangeAxis().setInverted(true);

        //Definindo valor m�nimo e m�ximo do eixo y
        plot.getRangeAxis().setRange(0,120);

        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);

            ResultSet rs = null;

            String sql = "SELECT * FROM audiometria WHERE cod_audiometria=" + this.getCod_audiometria();

            //Executa a pesquisa
            rs = stmt.executeQuery(sql);

            //Se achou o exame, montar
            if (rs.next()) {

                //Insere o s�mbolo nos pontos de medi��o a�rea
                novaAnotacao(plot, simbol1, 0.25, rs.getString(this.getLado() + "_a_025"));
                novaAnotacao(plot, simbol1, 0.50, rs.getString(this.getLado() + "_a_050"));
                novaAnotacao(plot, simbol1, 1, rs.getString(this.getLado() + "_a_1"));
                novaAnotacao(plot, simbol1, 2, rs.getString(this.getLado() + "_a_2"));
                novaAnotacao(plot, simbol1, 3, rs.getString(this.getLado() + "_a_3"));
                novaAnotacao(plot, simbol1, 4, rs.getString(this.getLado() + "_a_4"));
                novaAnotacao(plot, simbol1, 6, rs.getString(this.getLado() + "_a_6"));
                novaAnotacao(plot, simbol1, 8, rs.getString(this.getLado() + "_a_8"));

                //Insere marcas dos pontos da medi��o �ssea
                novaAnotacao(plot, simbol2, 0.50, rs.getString(this.getLado() + "_o_050"));
                novaAnotacao(plot, simbol2, 1, rs.getString(this.getLado() + "_o_1"));
                novaAnotacao(plot, simbol2, 2, rs.getString(this.getLado() + "_o_2"));
                novaAnotacao(plot, simbol2, 3, rs.getString(this.getLado() + "_o_3"));
                novaAnotacao(plot, simbol2, 4, rs.getString(this.getLado() + "_o_4"));
            }

            rs.close();
            stmt.close();
        }
        catch(SQLException e) {

        }

        renderer.setSeriesLinesVisible(0, true);

        renderer.setSeriesShapesVisible(0, false);//se false linha sem ponto senao true linha com ponto
        renderer.setBaseShapesVisible(false);//se false mostra apenas a reta referenciada no comando setSeriesShapesVisible(0,true);

        renderer.setUseFillPaint(true);//controla o pintar do ponto, false pinta, true nao pinta
        renderer.setUseOutlinePaint(false);//se true desabilita as cores ficando preto e branco
        renderer.setBaseShapesFilled(false);//ponto sem preenchimento
        renderer.setDrawOutlines(true);//se false nao mostra nenhuma linha

        plot.setRenderer(renderer);

        final NumberAxis rangeAxis = (NumberAxis) plot.getRangeAxis();
        rangeAxis.setStandardTickUnits(NumberAxis.createIntegerTickUnits());

        return chart;
    }//fecha createChart

    //Retorna uma nova anota��o para inserir no gr�fico
    private void novaAnotacao(XYPlot plot, String simbolo, double x, String y) {

        //Se o y veio com valor, plotar
        if(!Util.isNull(y)) {
            //Criar a anota��o
            XYTextAnnotation annotation = new XYTextAnnotation(simbolo, x, Float.parseFloat(y));

            //Alterar fonte
            annotation.setFont(new Font("SansSerif", Font.PLAIN, 15));

            //Se for ouvido direito, vermelho, sen�o, azul
            if(this.getLado().equalsIgnoreCase("D"))
                annotation.setPaint(Color.RED);
            else
                annotation.setPaint(Color.BLUE);

            //Insere a anota��o no gr�fico
            plot.addAnnotation(annotation);
        }
    }

    //Insere o valor no gr�fico se n�o estiver nulo
    private void insereValor(String valor, XYSeries linha, double frequencia) {

        //Se o valor n�o estiver nulo, insere
        if (!Util.isNull(valor)) {
            linha.add(frequencia, Float.parseFloat(valor));
        }

    }

    /**
     * @return the cod_audiometria
     */
    public String getCod_audiometria() {
        return cod_audiometria;
    }

    /**
     * @param cod_audiometria the cod_audiometria to set
     */
    public void setCod_audiometria(String cod_audiometria) {
        this.cod_audiometria = cod_audiometria;
    }

    /**
     * @return the lado
     */
    public String getLado() {
        return lado;
    }

    public void setLado(String lado) {
        this.lado = lado;
    }
}