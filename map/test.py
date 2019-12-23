#!/usr/env/python
# -*- coding: utf-8 -*-
from math import hypot
import random
import time
import os
import ctypes
from PIL import Image, ImageDraw


l=1920                  # lado de la imagen
n=10#320                    # divisor 80 conjuntos de julia de lado 24 por fila1

# el conjunto de mandelbrot es de 80x80 y su bucle

filename="map-out.png"     # nombre de archivo de salida
#rad=2                   # radio de la circunferencia
p=4096                   # max de iteraciones

#c=(random.randrange(-2000,2000)/1000.0, random.randrange(-2000,2000)/1000.0	) # obtenemos un c aleatorio.
getcoord1=lambda i: (4.0*i/n)-2 # función para obtener el valor proporcional al pixel
getcoord2=lambda i: (4.0*i/(l/n))-2
ex=5
def drawimg(img, filename):
    """Función que a partir de la matriz de información genera la imagen y la guarda en formato png"""
    color = lambda i: "#"+("00"+ str(hex(i**ex))[2:])[-3:]
    im = Image.new("RGBA", (l, l), (0,0,0,0))# imagen de lxl fondo transparente
    draw = ImageDraw.Draw(im)
    for x in range (0,l):
        for y in range(0,l):
            draw.point( [(x,y)],  color(img[x][y]) ) # pinta el punto en la imagen
    im.save(filename, "PNG")
    del draw



# calcular con libreria dinamica en c
def c_test(rad):
    # cargar libreria dinamica
    testlib = ctypes.CDLL(os.getcwd()+'/escape-c.so', mode=ctypes.RTLD_GLOBAL)

    img = [[0]*l for x in xrange(l)] # matriz de la imagen principal


    r=ctypes.c_int(rad)
    p2=ctypes.c_int(p)

    # bucle mandelbrot
    for x in range(n):
        c1=ctypes.c_double(getcoord1(x))
        for y in range(n):
            # bucle julia subzona
            c2=ctypes.c_double(getcoord1(y))

            for xx in range(l/n):
                x1=ctypes.c_double(getcoord2(xx))
                for yy in range(l/n):
                    x2=ctypes.c_double(getcoord2(yy))
                    print  ((l/n)*x)+xx, ((l/n)*y)+yy
                    print "x,y,xx,yy", x, y, xx, yy      
                    img[((l/n)*x)+xx][((l/n)*y)+yy]=testlib.escape(x1,x2, c1, c2, r, p2)
    

    drawimg(img, filename)



def main():
    #for i in range(1,7):
    #    rad=2**(i)
    c_test(2)  
    

if __name__== "__main__":
    main()
