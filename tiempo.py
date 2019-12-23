#!/usr/env/python
# -*- coding: utf-8 -*-
import time
import ctypes
import os

def times(tiempo_medio):
# n lado del hipercubo
    for n in [100, 512, 1000]:
        pixeles=(n*n) * (n*n/2) # ancho * alto

        # depende de la profundidad, la potencia computacional, el n de intrucciones del algoritmo, el n de hilos ejecutando simultaneamente.
        hilos=6 # supongamos una maquina de 6 nucleos capaz de calcular con una media de 0.1 seg cada pto
        #tiempo_medio=0.1 # seg por cada pixel de media P=4096

        segs= (pixeles/hilos)*tiempo_medio
        mins= segs/60.0
        h=mins/60.0
        d=h/24.0
        m=d/30.0
        y=d/365.0
        print "\t["+"-"*10+"Lado: "+str(n)+"-"*10+"]"
        for txt,val in (("pixeles",pixeles), ("hilos", hilos), ("t_medio/hilo (s)", tiempo_medio), ("seg",segs), ("min",mins), ("h",h), ("d",d), ("m",m), ("y",y)):
            print "\t\t"+txt+":\t"+str(val)
        print ""

def calcular_tiempo_medio(profundidad, lib):
    # el tiempo medio es menor cuanto más grande es la matriz por que el primer pixel esta fuera de la norma ya que tarda más al cargar la libreria dinamica en memoria, aunque no es muy significativo
    getcoord=lambda i: (4.0*i/10)-2
    # calcular los tiempos de una matriz mandelbrot de 10x10 y luego hacer la media para obtener un resultado con diferentes profundidades
    testlib = ctypes.CDLL(os.getcwd()+"/"+lib, mode=ctypes.RTLD_GLOBAL)
    t=[]
    img = [[0]*10 for x in xrange(10)]
    r=ctypes.c_int(2)
    p2=ctypes.c_int(profundidad)
    for x in range(10):
        x1=ctypes.c_double(getcoord(x))
        for y in range(10):
            x2=ctypes.c_double(getcoord(y))
            ti=time.time()
            img[x][y]=testlib.escape(x1,x2, x1, x2, r, p2)
            tf=time.time()
            t.append(tf-ti)
    return sum(t)/len(t)

def main():
    lib="escapeclang.so"
    for p in [50, 100, 500, 4096]: #range(4096):
        print "["+"-"*10+"Profundidad: "+str(p)+"-"*10+"]"
        times(calcular_tiempo_medio(p, lib))

main()
