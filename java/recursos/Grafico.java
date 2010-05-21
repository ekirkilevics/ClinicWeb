/* Arquivo: Grafico.java
 * Autor: Amilton Souza Martha
 * Cria��o: 19/03/2009   Atualiza��o: 19/03/2009
 * Obs: Gera gr�ficos
 */
package recursos;

import com.keypoint.PngEncoder;
import java.sql.ResultSet;

import org.jfree.data.category.DefaultCategoryDataset;
import java.awt.Color;
import java.awt.image.BufferedImage;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;
import javax.servlet.http.HttpServletResponse;
import org.jfree.chart.ChartFactory;
import org.jfree.chart.JFreeChart;
import org.jfree.chart.plot.PlotOrientation;
import org.jfree.data.category.CategoryDataset;

public class Grafico {

    //Atributos do gr�fico
    private String codcli;
    private String codExame;

    //Atributos privados para conex�o
    private Connection con = null;
    private Statement stmt = null;

    public Grafico() {
        con = Conecta.getInstance();
    }

    public byte[] gerarGrafico(String cod_exame, String codcli, HttpServletResponse response, int width, int height) {

        //Altera par�metros
        this.setCodExame(cod_exame);
        this.setCodcli(codcli);

        try {
            JFreeChart chart = this.createChart(this.createDataset());

            //Configura sa�da do navehador para imagem
            response.setContentType("image/png");

            //Converte o gr�fico em imagem e publica
            BufferedImage buf = chart.createBufferedImage(width, height, null);
            PngEncoder encoder = new PngEncoder(buf, false, 0, 9);

            return encoder.pngEncode();
        } catch (Exception e) {

            return null;
        }

    }

    public DefaultCategoryDataset createDataset() {

        DefaultCategoryDataset ds = new DefaultCategoryDataset();

        try {
            //Cria statement para enviar sql
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);

            ResultSet rs = null;

            String sql = "SELECT exames.exame, exames.unidade, resultados.DATA, resultados.valor ";
            sql += "FROM exames INNER JOIN resultados ON exames.cod_exame = resultados.cod_exame ";
            sql += "WHERE resultados.codcli=" + codcli + " AND resultados.cod_exame=" + codExame;
            sql += " ORDER BY DATA ASC";

            //Executa a pesquisa
            rs = stmt.executeQuery(sql);

            //Cria looping com a resposta
            while (rs.next()) {
                ds.addValue(rs.getDouble("valor"), rs.getString("exame"), Util.formataData(rs.getString("data")));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return ds;
    }

    private JFreeChart createChart(CategoryDataset dataset) {//cria gr�fico

        // cria o gr�fico
        final JFreeChart chart = ChartFactory.createLineChart(
            "Gr�fico de Evolu��o", "", "",
            dataset, PlotOrientation.VERTICAL, true, true, false
        );

        //Cor de fundo
        chart.setBackgroundPaint(Color.WHITE);

        return chart;
    }//fecha createChart

    /**
     * @return the codcli
     */
    public String getCodcli() {
        return codcli;
    }

    /**
     * @param codcli the codcli to set
     */
    public void setCodcli(String codcli) {
        this.codcli = codcli;
    }

    /**
     * @return the codExame
     */
    public String getCodExame() {
        return codExame;
    }

    /**
     * @param codExame the codExame to set
     */
    public void setCodExame(String codExame) {
        this.codExame = codExame;
    }

    public static void main(String args[]) {
        Grafico graf = new Grafico();
        byte[] bytes = graf.gerarGrafico("400", "13873", null, 300, 250);
        
    }
}