class LinearRegression {
  int MAXN = 10;
  int n = 0;
  double sumx = 0.0, sumy = 0.0, sumx2 = 0.0;
  double beta1 = 0.0;
  double beta0 = 0.0;
  double xbar = 0;
  double ybar = 0;
  double xxbar = 0.0, yybar = 0.0, xybar = 0.0;
  double[] x = {1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0,9.0,10.0};
  double[] y = new double[10];

  LinearRegression(double[] y1) {
    // load into this array format
    this.y = y1;
    for (n = 0; n<MAXN; n++) {
      sumx  += x[n];
      sumx2 += x[n] * x[n];
      sumy  += y[n];
    }
    

    xbar = sumx / n;
    ybar = sumy / n;

    // second pass: compute summary statistics
    
    for (int i = 0; i < n; i++) {
      xxbar += (x[i] - xbar) * (x[i] - xbar);
      yybar += (y[i] - ybar) * (y[i] - ybar);
      xybar += (x[i] - xbar) * (y[i] - ybar);
    }
    beta1 = xybar / xxbar;
    beta0 = ybar - beta1 * xbar;
  }

  void analyze(){
     // analyze results
        int df = n - 2;
        double rss = 0.0;      // residual sum of squares
        double ssr = 0.0;      // regression sum of squares
        for (int i = 0; i < n; i++) {
            double fit = beta1*x[i] + beta0;
            rss += (fit - y[i]) * (fit - y[i]);
            ssr += (fit - ybar) * (fit - ybar);
        }
        double R2    = ssr / yybar;
        double svar  = rss / df;
        double svar1 = svar / xxbar;
        double svar0 = svar/n + xbar*xbar*svar1;
        println("Trend Down:          " + trendingDown());
        println("Trend up:             " + trendingUp());
        println("R^2                 = " + R2);
        println("std error of beta_1 = " + Math.sqrt(svar1));
        println("std error of beta_0 = " + Math.sqrt(svar0));
        svar0 = svar * sumx2 / (n * xxbar);
        println("std error of beta_0 = " + Math.sqrt(svar0));

        println("SSTO = " + yybar);
        println("SSE  = " + rss);
        println("SSR  = " + ssr);
  }

  double getBeta1() {
    return beta1;
  }

  double getBeta0() {
    return beta0;
  }

  double getValue(double x){
    return beta1 * x + beta0;
  }
  
  boolean trendingUp(){
    return y[9] < getValue(11.0);
  }
  boolean trendingDown(){
    return y[9] > getValue(11.0);
  }

  String toString() {
    return "y   = " + beta1 + " * x + " + beta0;
  }
}