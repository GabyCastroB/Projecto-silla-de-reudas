# Proyecto silla de ruedas
## Integrantes
1. Gabriela Castro
2. Gabriel Manrique
3. Linda Mendez

## Introducción
En el presente informe se presentará el proyecto de una silla de ruedas automatizada, definiendo los periféricos que se van a usar, su funcionamiento, se presentará el mapa del memoria, se mostrará las diferentes pruebas del SoC antes de implementar el proyecto y los resultados de las pruebas de las herramientas correspondientes al framework de litex.  

Los periféricos que se utilizaron en este proyecto, fueron 6 sensores infrarrojos, 2 Motorreductores controlados a partir de un puente H y un teclado matricial para la lectura de la selección del usuario. El mapa de memoria se encuentra detalladamente en el archivo  csr.csv, las bases correspondientes para cada driver del SoC son las siguientes:

![Mapa_menoria](https://github.com/unal-edigital2-labs/lab03-2022-2-grupo07-22-2/blob/main/Screenshot%20from%202022-11-24%2022-55-56.png)

## Palabras clave
Procesador, SoC, periférico, framework, mapa de memoria.

## Descripción de cada periférico, definir las interconexiones de entradas y salidas. (caja negra)
### Sensor seguidor de linea

El sensor infrarojo es capaz de detectar el color negro sobre cualquier superficie. Está compuesto de un LED infrarrojo y un fototransistor, situados uno al lado del otro. El LED actúa como emisor y el fototransistor actúa como receptor. El LED infrarrojo emite luz infrarroja, es decir, de mayor longitud de onda (o menor frecuencia), invisible al ojo humano. Si esta luz choca contra una superficie blanca, se reflejará y rebotará hacia el fototransistor. En cambio, si choca contra una superficie negra, el material absorberá la mayoría de la luz y esta no llegará al fotorreceptor. se hace uso del GPIO. Estos sensores se utilizan con el fin de demarcar el camino que debe seguir la silla de ruedas para llegar a las diferentes partes de la casa, siendo totalmente autónomia, despues de que el usuario presione el lugar al cual desea dirigirse.

Los sensores infrarojos se implementaron como gpio, se creó una función en main.c la cual nos imprime el valor de cada sensor, tenemos seis sensores, aunque para el proyecto solo se utilizaron 3, el izquiero(I), derecho (D) y el frontal derecho(FD). LA funcion creada por litex para leer los infrarojos se llama infrarojo_cntrl_in_read(), tiene como retorno un valor entero que en binario representa la lectura de cada infrarojo, por ejemplo si el retorno es 36 = 100100 , esto significa que hay dos sensores detectando la línea negra, por tanto para obtener el valor de cada sensor por aparte, se multiplica con la respectiva potencia de 2, por ejemplo al hacer 100100 & 2 , obtendremos el segundo sensor, en este caso esta en cero, y al hacer 100100 & (32) , se obtendrá el valor del último sensor, el cual esta en 1 para este caso. Al hacer esta operación se obtendrá la potencia de dos si el sensor esta en 1 y cero  si el sensor esta en 0, pero es incómodo trabajar con 0 y potencias de 2, es mejor trabajar con 0  y 1, representando 1 la línea negra y 0 cualquier otro color, por lo que después se utilizan unos condicionales para lograr estocua


```C
static void leer_infrarojos(void)
{
		int valorinfra = infrarojo_cntrl_in_read();
		int i_I = valorinfra & INFRA_I;
		int i_FI = valorinfra & INFRA_FI;
		int i_FD = valorinfra & INFRA_FD;
		int i_D = valorinfra & INFRA_D;
		int i_TD = valorinfra & INFRA_TD;
		int i_TI = valorinfra & INFRA_TI;
		if(i_I != 0){
			I =1; 
		}else{
			I = 0;
		}
		if(i_FI != 0){
			FI =1; 
		}else{
			FI = 0;
		}
		if(i_FD != 0){
			FD =1; 
		}else{
			FD = 0;
		}
		if(i_D != 0){
			D =1; 
		}else{
			D = 0;
		}
		if(i_TD != 0){
			TD =1; 
		}else{
			TD = 0;
		}
		if(i_TI != 0){
			TI =1; 
		}else{
			TI = 0;
		}				
}
```

### Motor
![Motor](https://github.com/unal-edigital2-labs/lab03-2022-2-grupo07-22-2/blob/main/motor1.png)
![Motor](https://github.com/unal-edigital2-labs/lab03-2022-2-grupo07-22-2/blob/main/motor.png)

El periférico del motor recibe una señal de entrada (estado) que pueden ser 0, 1, 2, 3 y 4 , las cuales realizaran el movimiento del motor y tiene como salida cuatro señales, 2 para cada motor. Para su funcionamiento en la entrada de estado si se recibe un 0 significa parar, entonces todas las señales de salida son 0, si recibe 1 significa avanzar, entonces las señales de salida son 1, 0, 1, 0, si recibe 2, significa retroceder, entonces las señales de salida son 0, 1, 0, 1, si recibe un 3 significa que debe ir a la izquierda, por lo que las señales de salida son 0, 1, 1, 0 y por último si recibe un cuatro significa ir a la derecha y las señales de salida son 0, 1, 1, 0. En la siguiente tabla muestran las acciones de movimiento que se realizan de acuerdo al valor de las entradas del puente H.

<p align="center">  

| Acción     | Derecha[0] | Derecha[1] | Izquierda[0] | Izquierda[1] |
| ---------- | ---------- | ---------- | ------------ | ------------ |
| Parar      |     0      |     0      |      0       |      0       |  
| Avanzar    |     1      |     0      |      1       |      0       | 
| Retroceder |     0      |     1      |      0       |      1       | 
| Izquierda  |     0      |     1      |      1       |      0       | 
| Derecha    |     1      |     0      |      0       |      1       | 

Tabla 1.
</p>

El funcionamiento del módulo se basa en una máquina de estados, en la que se define el movimiento del carro de acuerdo al valor de la señal de entrada estado, en la que se establecen los valores de salida al igual que se muestra previamente en la tabla.

### Movimiento del motor

```C
`timescale 1ns / 1ps

module Movimiento( 
                    input [3:0] botones,
                    output reg [1:0] izquierda,
                    output reg [1:0] derecha,
                    output reg [3:0] led
                    );

always@(*)begin
	case(botones)
        // Parar  
       4'b0100: begin//3
                    derecha[0] = 0;
                    derecha[1] = 0;
                    izquierda[0] = 0;
                    izquierda[1] = 0;
                    led[0]=0;
                    led[1]=0;
                    led[2]=0;
                    led[3]=0;
                end
        // Avanzar  
        4'b0110: begin//6
                    derecha[0] = 1;
                    derecha[1] = 0;
                    izquierda[0]  = 1;
                    izquierda[1]  = 0;
                    led[0]=1;
                    led[1]=0;
                    led[2]=1;
                    led[3]=0;
                end
        // Retroceder  
   	     4'b1100: begin//c
                    derecha[0] = 0;
                    derecha[1] = 1;
                    izquierda[0]  = 0;
                    izquierda[1]  = 1;
                    led[0]=0;
                    led[1]=1;
                    led[2]=0;
                    led[3]=1;
                end
        // Izquierda  
        4'b1101 : begin//d
                    derecha[0] = 1;
                    derecha[1] = 0;
                    izquierda[0]  = 0;
                    izquierda[1]  = 1;
                    led[0]=1;
                    led[1]=0;
                    led[2]=0;
                    led[3]=1;
                end
        // Derecha
        4'b1110: begin//#
                    derecha[0] = 0;
                    derecha[1] = 1;
                    izquierda[0]  = 1;
                    izquierda[1]  = 0;
                    led[0]=0;
                    led[1]=1; 
                    led[2]=1;
                    led[3]=0;
                end
               default: begin
                    derecha[0] = 0;
                    derecha[1] = 0;
                    izquierda[0] = 0;
                    izquierda[1] = 0;
                    led[0]=0;
                    led[1]=0;
                    led[2]=0;
                    led[3]=0;
                end
	endcase
end
```
El código en C que se utilizó para dar ordenes al carro de moverse recibía un número entero para seleccionar la dirección, 0 significa parar, 1 avanzar, 3 izquierda y 4 derecha, cuando se seleccione alguna de estas opciones el carro se mantendrá haciendo esto hasta que se le envíe otra instrucción, por lo que se usarán delays en milisegundos para lograr esto. Se programó una función para girar noventa grados el carro, la cual utiliza un delay y un while que le permite girar al carro hasta encontrar de nuevo la línea negra.

```C
static void girarnov(int direccion) 
{
	const int PararMotor = 0;
	const int IzquierdaMotor = 3;
	const int DerechaMotor = 4;
	const int AvanzarMotor = 1;
	movimiento_cntrl_estado_write(PararMotor);

	movimiento_cntrl_estado_write(AvanzarMotor);
	delay_ms(300);
	switch (direccion)
	{
		case 3: movimiento_cntrl_estado_write(IzquierdaMotor);
			break;
		case 4: movimiento_cntrl_estado_write(DerechaMotor);
			break;
		//case 0: movimiento_cntrl_estado_write(DerechaMotor);
		//		delay_ms(1000);
		//		break;
		default:movimiento_cntrl_estado_write(PararMotor);
			break;
	}
	delay_ms(600);
	leer_infrarojos();
	//girar hasta detectar la línea nuevamente
	while(FD == 1){
		leer_infrarojos();
		movimiento_cntrl_estado_write(direccion);
	}
	//despues de que detecta la línea negra, que pare
	movimiento_cntrl_estado_write(PararMotor);
}

```

Posteriormente se realizó la implementación por medio de Python, tal como se ilustra a continuación

```Python
from migen import *
from migen.genlib.cdc import MultiReg
from litex.soc.interconnect.csr import *
from litex.soc.interconnect.csr_eventmanager import *

# Modulo de Movimiento
class movimiento(Module, AutoCSR):
    def _init_(self, right, left):
        self.clk = ClockSignal() # Reloj

        # Registros
        self.estado = CSRStorage(3)

        # Conexiones del Dispositivo
        self.right = right
        self.left = left

        self.specials += Instance("movimiento",
            i_clk = self.clk,
            i_estado = self.estado.storage,
            o_right = self.right,
            o_left = self.left)
```
![Teclado](https://github.com/unal-edigital2-labs/lab03-2022-2-grupo07-22-2/blob/main/movimiento.py.jpg)

### Teclado matricial

![Teclado](https://github.com/unal-edigital2-labs/lab03-2022-2-grupo07-22-2/blob/main/teclado2.png)

En el teclado como se puede observar en la anterior figura, se tiene un divisor de frecuencia el cual permite realizar el barrido de las filas y posteriormente las columnas para hallar la tecla que el usuario este presionando, para ello primero se asignan las entradas como columnas y las salidas como filas. Si se oprime una tecla, la entrada de esa pasa a ser 0, luego lo que hace el programa es hacer un barrido de las columnas para saber cual es el botón que se oprimió.

El código que se realizó en vivado se muestra a continuación:

### Módulo Teclado 
```C
`timescale 1ns / 1ps
module teclado4X4(
  	input clk,
	input rst,
	input [3:0] col,
	output [3:0] fila,
	output [3:0] num
);

wire clk_e;
wire [3:0] temp_fila;
wire [1:0] izquierda;
wire [1:0] derecha;
assign fila=temp_fila;
div_f div(.clk(clk), .clk_e(clk_e));
dynamic_v dv(.clk_e(clk_e), .fila(temp_fila));
compt comp(.clk_e(clk_e),.col(col),.fila(temp_fila),.num(num));

endmodule
```
### Módulo Dividor de frecuencia
```C
`timescale 1ns / 1ps

module div_f(input clk,output reg clk_e);

reg [27:0] cont;
initial begin
cont=28'd0;
clk_e=0;
end
always @(posedge clk) begin//cuenta los ciclos de reloj
    cont= cont+28'd1;
  if(cont == 5000) begin
    cont=0;
	clk_e=~clk_e;
	end
	end
endmodule
```
### Módulo Dinamic_v

```C
`timescale 1ns / 1ps

module dynamic_v(input rst,input clk_e, output reg [3:0] fila);

reg [1:0] count=0;
always @(posedge clk_e or posedge rst) begin
		if(rst==1) begin
			count <= 0;
			fila<=4'b0000; 
		end else begin 
			case (count) 
				2'b00: begin fila <= 4'b1000; end 
				2'b01: begin fila <= 4'b0100; end 
				2'b10: begin fila <= 4'b0010; end 
				2'b11: begin fila <= 4'b0001; end 
			endcase
			count<= count+1;
		end
end
endmodule
```
### Módulo Comparación
```C
`timescale 1ns / 1ps

module compt( input clk_e,input [3:0] col, input [3:0] fila, output reg [3:0] num);

initial begin
num<= 4'b0000;
end

always@(posedge clk_e) begin
   if(fila==4'b1000)begin
        case(col)
        4'b1000: begin num= 4'b0001; end //1
        4'b0100: begin num= 4'b0010; end //2
        4'b0010: begin num= 4'b0100; end //3
        4'b0001: begin num= 4'b1010; end //A
        endcase
    end
    else if(fila==4'b0100) begin
        case(col)
        4'b1000: begin num= 4'b0100; end //4
        4'b0100: begin num= 4'b0101; end //5
        4'b0010: begin num= 4'b0110; end //6
        4'b0001: begin num= 4'b1011; end //B
        endcase
    end
    else if(fila==4'b0010) begin
        case(col)
        4'b1000: begin num= 4'b0111; end //7
        4'b0100: begin num= 4'b1000; end //8
        4'b0010: begin num= 4'b1001; end //9
        4'b0001: begin num= 4'b1100; end //C
        endcase
    end
    else if(fila==4'b0001) begin
        case(col)
        4'b1000: begin num= 4'b1110; end //*
        4'b0100: begin num= 4'b1111; end //0
        4'b0010: begin num= 4'b1110; end //#
        4'b0001: begin num= 4'b1101; end //D
        endcase
    end
    end
endmodule

```
Para utilizar el teclado en C, hay que tener en cuenta que las filas son las salidas y las columnas el valor de lectura, al presionar una tecla esta quedará seleccionada por el programa hasta que una nueva sea presionada, para el movimiento del carro es necesario que sea presionada una teclas para seleccionar el punto de partida y otra diferente para el punto de llegada, la función Top_teclado_ascii_read() nos retorna un número dependiendo de la tecla que fue presionada, por ello se hace una conversión por medio de unos condicionales, los cuales también tienen como función capturar las dos teclas que fueron presionadas y retornarlas como un entero.

```C
int teclado(void){
	int selec = 0;
	int n1 = 0;
	int n2 = 0;
	
	while(selec != 2){		
	int lectura = Top_teclado_ascii_read();	

	if(lectura == 127) 
	{
		if(selec == 0){
			n1 = 1;
			selec = selec + 1;

		}
		else if (selec == 1 && n1 != 1){
			n2 = 1;
			selec = selec + 1;

		}
	}else if(lectura == 9) 
	{
		if(selec == 0){
			selec = selec + 1;
			n1 = 2;
		}
		else if (selec == 1 && n1 != 2){
			n2 = 2;
			selec = selec + 1;
		}

	}else if(lectura == 3) 
	{
		if(selec == 0){
			n1 = 3;
			selec = selec + 1;
		}
		else if (selec == 1 && n1 != 3){
			n2 = 3;
			selec = selec + 1;
		}
		
	}else if(lectura == 111) 
	{
		if(selec == 0){
			n1 = 4;
			selec = selec + 1;

		}
		else if (selec == 1 && n1 != 4){
			n2 = 4;
			selec = selec + 1;

		}
	
	}else if(lectura == 78) 
	{
		if(selec == 0){
			n1 = 5;
			selec = selec + 1;

		}
		else if (selec == 1 && n1 != 5){
			n2 = 5;
			selec = selec + 1;

		}
	}


			printf("%i \n",n1);
			printf("%i \n",n2);		
	}
	return ((n1 * 10) + n2);
}

```

Posteriormente se realizó la implementación por medio de Python, tal como se ilustra a continueación:

```Python
from migen import *
from migen.genlib.cdc import MultiReg
from litex.soc.interconnect.csr import *
from litex.soc.interconnect.csr_eventmanager import *

# Modulo Principal
class Tecladoverilog(Module,AutoCSR):
    def _init_(self,Fila,Columna):
        self.clk50 = ClockSignal()
        self.ascii=CSRStatus(7)
        self.Fila= Fila
        self.Columna= Columna
        self.isDone= CSRStatus()
        
        self.specials +=Instance("Top_teclado",
            i_clk50 = self.clk50,
            o_ascii= self.ascii.status,
            i_Columna= self.Columna,
            o_isDone =self.isDone.status,
            o_Fila =self.Fila,
             
        )
```
![Teclado](https://github.com/unal-edigital2-labs/lab03-2022-2-grupo07-22-2/blob/main/teclado.png)

## Funciones en C 

El carro recorre la ruta que fue seleccionada por el teclado, estas rutas están guardadas en listas de enteros, cada ruta contiene que debe hacer la silla de ruedas en cada cruce que se encuentra en el camino que quiere recorrer, donde 0 significa parar, 1 avanzar, 3 izquierda, 4 derecha, las rutas se almacenan en otras listas de listas, para que puedan ser ordenadas, así coíncidan con los números digitados en el teclado. Los lugares de la casa son entrada, cocina, habitación, baño y sala, a estos nombres se debe los nombres de las listas.

```C 
//desde la entrada
int entcoc[2] = {3,0};
int enthab[3] = {1,3,0};
int entban[3] = {1,4,0};
int entsal[2] = {4,0};
// desde la cocina
int cochab[4] = {1,3,3,0};
int cocban[4] = {1,3,4,0};
int cocsal[3] = {1,1,0};
int cocent[3] = {1,4,0};
//desde la habitación
int habban[3] = {1,1,0};
int habsal[4] = {1,4,3,0};
int habent[4] = {1,4,1,0};
int habcoc[4] = {1,4,4,0};
//desde la baño
int bansal[4] = {1,3,3,0};
int banent[4] = {1,3,1,0};
int bancoc[4] = {1,3,4,0};
int banhab[3] = {1,1,0};
//desde la sala
int salent[3] = {1,3,0};
int salcoc[3] = {1,1,0};
int salhab[4] = {1,4,3,0};
int salban[4] = {1,4,4,0};
int vacia[1] = {0};
//rutas en un arreglo
int *rutasent[5] = {vacia,entcoc, enthab, entban, entsal};
int *rutascoc[5] = {cocent, vacia, cochab, cocban, cocsal};
int *rutashab[5] = {habent, habcoc,vacia , habban , habsal};
int *rutasban[5] = {banent, bancoc, banhab,vacia ,bansal};
int *rutassal[5] = {salent, salcoc, salhab ,salban, vacia};
 
int **rutas[5] = {rutasent, rutascoc, rutashab, rutasban, rutassal};

```

La función corregir posición se encarga de que el carro este avanzando por la línea negra, leyendo el estado del sensor frontal derecho(FD), si no esta en linea negra entonces da giros inicialmente pequeños que van aumentado de tamaño a izquierda y derecha hasta que encuentra la línea negra.

``` C
int corregir_posicion(void)
{
	leer_infrarojos();
	int  r = 50;
	while(!(FD) && !(D && I) )
	{
		printf("en la funcion corrigiendo\n ");
		//girar un poco a la izquierda
		movimiento_cntrl_estado_write(3);
		leer_infrarojos(); 
		if (!(D && I)) {delay_ms(r);}
		movimiento_cntrl_estado_write(0);
		leer_infrarojos();
		if(!(FD)){ 
		//girar un poco mas a la derecha
		movimiento_cntrl_estado_write(4);
		leer_infrarojos(); 
		if (!(D && I)) {delay_ms(r + 50);}
		
		movimiento_cntrl_estado_write(0);
		}
		leer_infrarojos();
		r = r + 50;
	}
	movimiento_cntrl_estado_write(0);
	return 1;
}

```



La función principal que integra todo se llama recorrer_ruta(), la cual recibe un entero de la ruta deseada, se encarga de seleccionar la ruta que es una lista de instrucciones a seguir dependiendo de este número, luego si esta en un cruce ejecuta la instrucción que le indique esta lista, sino entonces corrige la posición del carro en caso de que no esté en la línea negra, finalmente si esto esta bien entonces avanza, todo esto lo logra usando las funciones antes descritas.

``` C
static void recorrer_ruta(int n){
	int n1 = (int)n / 10;
  	int n2 = n - (n1 * 10);
	printf("%i \n", n1 - 1);
	printf("%i \n", n2 - 1);
	int *ruta = rutas[n1 - 1][n2 - 1];
	
	/*printf("%i \n",sizeof(*ruta));
	for (int i = 0; i < sizeof(*ruta); i++) {
    	printf("%i ", ruta[i]);
  	}*/
	printf("\n");
	//delay_ms(5000);
	_Bool llego = 0;
	int i = 0; 
	while (!llego && !(buttons_in_read()&1))
	{
		leer_infrarojos(); 
		if (!(D && I)) {delay_ms(100);}
		movimiento_cntrl_estado_write(0);
		delay_ms(100);
		//corregir_posicion();
		leer_infrarojos(); 
		 
			if(D && I)	
			{
				printf("1 %i\n", ruta[i]);
				movimiento_cntrl_estado_write(0);
				if(ruta[i] == 3 || ruta[i] == 4)
				{
					printf("2 lee direccion: %i\n", ruta[i]);
					girarnov(ruta[i]);
					movimiento_cntrl_estado_write(1);
					delay_ms(100);
					movimiento_cntrl_estado_write(0);
					//corregir_posicion();
					i = i +1;
				}else if(ruta[i] == 0)
				{	
					printf("3 detenido %i\n", ruta[i]);
					movimiento_cntrl_estado_write(0);	
					i = i +1;
					llego = 1;	
				}else{
					printf("4 avanzado \n");
					movimiento_cntrl_estado_write(1);	
					delay_ms(400);	
					i = i + 1;
				}
			}
			else if(FD && TD) {
				printf("5 avanzado \n");
				movimiento_cntrl_estado_write(1);	
				//hacer un pausa? 
				//corregir_posicion();
			}
			else if (!FD)
			{
				printf("6 corrigiendo posicion \n");
				corregir_posicion();
			}
			else
			{
				printf("7 avanzando \n");
				movimiento_cntrl_estado_write(1);
				leer_infrarojos(); 
				if (!(D && I)) {delay_ms(100);}		
			}
	}
	movimiento_cntrl_estado_write(0);
}
```

## Video de funcionamiento

[Video funcionamiento](https://youtube.com/shorts/-RdEc_xJZ_8?feature=share "Funcionamiento")

[Video funcionamiento1](https://youtube.com/shorts/xVOEOwLeHbI?feature=share "Funcionamiento")

[Video funcionamiento2](https://youtube.com/shorts/gt1KRH4IurQ?feature=share "Funcionamiento")


## Describir de forma general el funcionamiento de cada bloque en HW y describir en pseudo código la interconexión con el SW.

En el plantamiento del proyecto, el cual es diseñar un sistema que pueda ser implementado en una silla de ruedas para optimizar el tiempo de desplazamiento de una persona con discapacidad motriz en su hogar. El proyecto contará con una silla de ruedas pequeña en una maqueta de una casa, esta podrá desplazarse a el lugar seleccionado por medio de un teclado matricial, 
esto se lograra controlando los motores de la silla de ruedas, teniendo en cuenta un mapa de la casa que hará previamente el
sistema utilizando sensores infrarrojos que detectan las líneas negras en el suelo de la casa.

Para el desarrollo y montaje de la silla se ruedas se realizó los bloques de movimiento para el manejo de la dirreción en la cual se deseea desplazar el usuario sea hacia adelante, atrás, izquiera, derecha y frenar o a una parte especifica de la casa, y esto lo hace por medio del bloque del teclado matricial, en donde detecta cual tecla se pulso y a que función cumple esa tecla para el motor. Además de esto al pulsarse una tecla e inicial el movimiento de la silla al destino por medio de una camino demarcado para que los sensores de líneas detectan la líne negra ajustandose según sea necesario mateniendose en esta.

## Realizar el mapa de memoria del SoC y de cada periférico.
![Mapamemoria](https://github.com/unal-edigital2-labs/lab03-2022-2-grupo07-22-2/blob/main/mapa%20de%20memoria.png)

## Realizar el diagrama del Soc con los perifericos
![help](https://github.com/unal-edigital2-labs/lab03-2022-2-grupo07-22-2/blob/main/SoC.png)
