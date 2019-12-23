// voxel representaction

module capa_julia(lado_real= 100, resolucion= 100, profundidad= 1, cr=0.0, ci=0.0, r=2, capa=1, all_layers=false, inner=false){
    // 50mm lado real de todo el conjunto
    // subdivisiones
    // n de loops max
    // 2mm por capa

    lado=lado_real/resolucion; // lado del cubo
    // Algoritmo de tiempo de escape
        // hypotenusa
        function hypot(a, b) = sqrt((a*a)+(b*b));
        // calcula parte real r real, i imaginaria, cr parte real de c, ci parte imaginaria de c
        function real(r,i,cr) = (((r*r)-(i*i))+cr);
        function imag(r,i,ci) = ((2*r*i)+ci);
        // algoritmo escape recursivo
        function escape(rad=2, pr,pi,cr,ci, step=0, maxstep) = ( hypot (pr, pi) < rad && step < maxstep ) ? escape(rad, real(pr,pi,cr), imag(pr, pi, ci), cr, ci, step+1, maxstep) : step;
    // end algoritmo tiempo de escape
	// Más opciones:
	// posibilidad de variar la región de escape de un circulo a otro tipo de areas
	// posibilidad de variar ese area en función de el parametro z
	// posibilidad de usar una región generada por el algoritmo original como nuevo area, generando recursividad en ese nivel de area.

    // Funciones de conversión metrica
    function get_rel(x) = (4.0*x/resolucion)-2; // centra en el cuadrante [-2,2]

    union(){
    for ( x=[0:resolucion])
        for (y=[0:resolucion])
            translate([x*lado, y*lado, 0])
        if(all_layers){
            if(inner){
                if (escape(r, get_rel(x), get_rel(y), cr, ci, 0, profundidad+1) > profundidad){
                    cube([lado, lado, capa]);
                    //echo(x*lado, y*lado);
                }
            }else{

                if (escape(r, get_rel(x), get_rel(y), cr, ci, 0, profundidad+1) < profundidad+1){
                    cube([lado, lado, capa]);
                    //echo(x*lado, y*lado);
                }
        }

        }else{

         if (escape(r, get_rel(x), get_rel(y), cr, ci, 0, profundidad+1) == profundidad){
                    cube([lado, lado, capa]);
                    //echo(x*lado, y*lado);
         }
       }
    }
}
//capa_julia(profundidad=5, cr=0.2, ci=0.5, all_layers=false, inner=true);



module cannandelbrot(horizontal=false, cte=0.0, lado_real= 100, resolucion= 100, profundidad= 0, r=2, all_layers=false, inner=false){

    function get_rel(x) = (4.0*x/resolucion)-2;
    lado=lado_real/resolucion;

    union(){
    for ( z=[0:resolucion]){ // optimización hacer la mitad y la otra mitad copiarla como translación
            translate([0,0,z*lado])
                if(horizontal){
                    capa_julia(lado_real= lado_real, resolucion= resolucion, profundidad= profundidad, cr=get_rel(z), ci=cte, r=r, capa=lado, all_layers=all_layers, inner=inner);
                }else{
                    capa_julia(lado_real= lado_real, resolucion= resolucion, profundidad= profundidad, cr=cte, ci=get_rel(z), r=r, capa=lado, all_layers=all_layers, inner=inner);
                }
				echo(get_rel(z), cte, lado, z*lado);
			}
    }
}
//cannandelbrot(horizontal=false, cte=0.23, lado_real= 100, resolucion= 25, profundidad= 3, r=2, all_layers=true, inner=true);




module cannandelbrot_diagonal(positiva=true, cte=0.0, lado_real= 100, resolucion= 100, profundidad= 0, r=2, all_layers=false, inner=false){
    //cte -sqrt(2), sqrt(2)
    function get_rel(x) = (4.0*x/resolucion)-2;
    lado=lado_real/resolucion;

    function f(x) = x + cte;
    function f2(x) = (-1*x) + cte;

    union(){
    for ( z=[0:resolucion]){ // optimización hacer la mitad y la otra mitad copiarla como translación
            translate([0,0,z*lado])
                if(positiva){
                    capa_julia(lado_real= lado_real, resolucion= resolucion, profundidad= profundidad, cr=get_rel(z), ci=f(get_rel(z)), r=r, capa=lado, all_layers=all_layers, inner=inner);
                }else{
                    capa_julia(lado_real= lado_real, resolucion= resolucion, profundidad= profundidad, cr=get_rel(z), ci=f2(get_rel(z)), r=r, capa=lado, all_layers=all_layers, inner=inner);
                }
				echo(get_rel(z), f(get_rel(z)), z*lado);
			}
    }
}
//cannandelbrot_diagonal(positiva=true, cte=0, lado_real= 100, resolucion= 25, profundidad= 2, r=2, all_layers=false, inner=false);


// ejemplo con funcion ej f(x)=x*x+cte
function fun(x) = (x*x);
//function fun(x) = (x*x*x);
//function fun(x) = (sin(x)/cos(x));
//function fun(x) = ((x*x*x)+log((x*x)+0.1)+sin(x))-sqrt(abs(x*x*x));
e=2.7182818;
//function fun(x) = x*pow(e,sin(x*330));

module cannandelbrot_fun(cte=0.0, lado_real= 100, resolucion= 100, profundidad= 0, r=2, all_layers=false, inner=false){
    //cte -sqrt(2), sqrt(2)
    function get_rel(x) = (4.0*x/resolucion)-2;
    lado=lado_real/resolucion;
    union(){
    for ( z=[0:resolucion]){ 
            translate([0,0,z*lado])
                capa_julia(lado_real= lado_real, resolucion= resolucion, profundidad= profundidad, cr=get_rel(z), ci=fun(get_rel(z))+cte, r=r, capa=lado, all_layers=all_layers, inner=inner);
        }
    }
}
//cannandelbrot_fun(cte=0, lado_real= 100, resolucion= 50, profundidad= 3, r=2, all_layers=false, inner=false);


// en el otro eje
function funy(y) = y*y;
module cannandelbrot_funy(cte=0.0,  lado_real= 100, resolucion= 100, profundidad= 0, r=2, all_layers=false, inner=false){
    //cte -sqrt(2), sqrt(2)
    function get_rel(x) = (4.0*x/resolucion)-2;
    lado=lado_real/resolucion;
    union(){
    for ( z=[0:resolucion]){ 
            translate([0,0,z*lado])
                capa_julia(lado_real= lado_real, resolucion= resolucion, profundidad= profundidad, cr=funy(get_rel(z))+cte, ci=get_rel(z), r=r, capa=lado, all_layers=all_layers, inner=inner);
        }
    }
}
//cannandelbrot_funy(cte=0, lado_real= 100, resolucion= 50, profundidad= 3, r=2, all_layers=false, inner=false);


// doble función
function fun1(x) = 2*exp(0.15*x)*cos(200*x);
function fun2(y) = 2*exp(0.15*y)*sin(200*y);
module cannandelbrot_2fun(cte1=0, cte2=0.0, lado_real= 100, resolucion= 100, profundidad= 0, r=2, all_layers=false, inner=false){
    //cte -sqrt(2), sqrt(2)
    function get_rel(x) = (4.0*x/resolucion)-2;
    lado=lado_real/resolucion;
    union(){
    for ( z=[0:resolucion]){ 
            translate([0,0,z*lado])
                capa_julia(lado_real= lado_real, resolucion= resolucion, profundidad= profundidad, cr=fun2(get_rel(z))+cte2, ci=fun1(get_rel(z))+cte1, r=r, capa=lado, all_layers=all_layers, inner=inner);
        }
    }
}

//cannandelbrot_2fun(cte1=0, cte2=0, lado_real= 100, resolucion= 50, profundidad= 2, r=2, all_layers=false, inner=false);



// Animation 100 steps 1fps

    function get_t(x) = (4.0*x/100)-2;

//  Vertical-imaginaria (morada) Horizontal-real (roja)

color("purple")
cannandelbrot(horizontal=false, cte=get_t($t), lado_real= 100, resolucion= 25, profundidad= 3, r=2, all_layers=true, inner=true);

color("red")
translate([-100,0,0])
cannandelbrot(horizontal=true, cte=get_t($t), lado_real= 100, resolucion= 25, profundidad= 3, r=2, all_layers=true, inner=true);


// diagonales y=x+cte y=-x+cte

color("green")
translate([0,-100,0])
cannandelbrot_diagonal(positiva=true, cte=get_t($t), lado_real= 100, resolucion= 25, profundidad= 3, r=2, all_layers=true, inner=true);

color("brown")
translate([-100,-100,0])
cannandelbrot_diagonal(positiva=false, cte=get_t($t), lado_real= 100, resolucion= 25, profundidad= 3, r=2, all_layers=true, inner=true);
