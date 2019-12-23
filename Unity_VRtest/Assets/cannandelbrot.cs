using System.Collections;
using System.Collections.Generic;
using System;

public class cannandelbrot  {
    int rad, max;
    int lado;
    cannandelbrot () {
         this.rad = 2;
         this.max = 100;

         this.lado = 50;
         
         
	}

    public double Hypotenuse(double a, double b)
    {  
        return Math.Sqrt(Math.Pow(a, 2) + Math.Pow(b, 2));  
    }

    public double fx(double x, double y, double cr) {
        return (Math.Pow(x,2) - Math.Pow(y,2))+cr;
    }

    public double fy(double x, double y, double ci) {
        return (2*x*y)+ci;
    }

    public int escape(double x, double y, double cr, double ci) {

        int i = 0;
        double auxx = this.fx(x, y, cr);
        double auxy = this.fy(x, y, ci);

        while (this.Hypotenuse(auxx, auxy) < this.rad && i<this.max) {
            double auxx2 = this.fx(auxx, auxy, cr);
            auxy = this.fy(auxx, auxy, ci);
            auxx = auxx2;
            i++;
        }

        return i;

    }
}