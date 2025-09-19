#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

#include <irq.h>
#include <uart.h>
#include <console.h>
#include <generated/csr.h>

#include "delay.h"

//cuando toman estos valores, estan en la línea negra
#define INFRA_I 1
#define INFRA_FI 2
#define INFRA_FD 4
#define INFRA_D 8
#define INFRA_TD 16
#define INFRA_TI 32

//valor actual
_Bool I ;
_Bool FI ;
_Bool FD ;
_Bool D ;
_Bool TD ;
_Bool TI;

static char *readstr(void)
{
	char c[2];
	static char s[64];
	static int ptr = 0;

	if(readchar_nonblock()) {
		c[0] = readchar();
		c[1] = 0;
		switch(c[0]) {
			case 0x7f:
			case 0x08:
				if(ptr > 0) {
					ptr--;
					putsnonl("\x08 \x08");
				}
				break;
			case 0x07:
				break;
			case '\r':
			case '\n':
				s[ptr] = 0x00;
				putsnonl("\n");
				ptr = 0;
				return s;
			default:
				if(ptr >= (sizeof(s) - 1))
					break;
				putsnonl(c);
				s[ptr] = c[0];
				ptr++;
				break;
		}
	}
	return NULL;
}

static char *get_token(char **str)
{
	char *c, *d;

	c = (char *)strchr(*str, ' ');
	if(c == NULL) {
		d = *str;
		*str = *str+strlen(*str);
		return d;
	}
	*c = 0;
	d = *str;
	*str = c+1;
	return d;
}

static void prompt(void)
{
	printf("RUNTIME>");
}

static void help(void)
{
	puts("Available commands:");
	puts("help                            - this command");
	puts("reboot                          - reboot CPU");
	puts("led                             - led test");
	puts("switch                          - switch test");
	puts("display                         - display test");
	puts("rgbled                          - rgb led test");
	puts("vga                             - vga test");
	puts("infrarojo                       - infrarojo test");	
}

static void reboot(void)
{
	ctrl_reset_write(1);
}

static void display_test(void)
{
	int i;
	printf("display_test...\n");
	for(i=0; i<6; i++) {
		display_sel_write(i);
		display_value_write(7);
		display_write_write(1);
	}
}

static void led_test(void)
{
	unsigned int i;
//./l		printf("Test del los leds... se interrumpe con el botton 1\n");
	while(!(buttons_in_read()&1)) {

	for(i=1; i<65536; i=i*2) {
		leds_out_write(i);
		delay_ms(50);
	}
	for(i=32768;i>1; i=i/2) {
		leds_out_write(i);
		delay_ms(50);
	}
	}
	
}

static void rgbled_test(void)
{
	unsigned int T = 128;
	
	ledRGB_1_r_period_write(T);
	ledRGB_1_g_period_write(T);
	ledRGB_1_b_period_write(T);

	ledRGB_1_r_enable_write(1);
	ledRGB_1_g_enable_write(1);
	ledRGB_1_b_enable_write(1);
	
	ledRGB_2_r_period_write(T);
	ledRGB_2_g_period_write(T);
	ledRGB_2_b_period_write(T);

	ledRGB_2_r_enable_write(1);
	ledRGB_2_g_enable_write(1);
	ledRGB_2_b_enable_write(1);
	for (unsigned int j=0; j<100; j++){
		ledRGB_1_g_width_write(j);
		for (unsigned int i=0; i<100; i++){
			ledRGB_1_r_width_write(100-i);
			ledRGB_1_b_width_write(i);	
			delay_ms(20);
		}	
	}	
}

static void infrarojo_test(void)
{
	printf("Test de Modulo de Infrarojo. Para interrumpir oprimir el botton 1\n");
	while(!(buttons_in_read()&1))
	{ 
		int valorinfra=infrarojo_cntrl_in_read();
		printf(" el valor de los infrarojos es : %i, \n", valorinfra);
		if (valorinfra & INFRA_I)
				printf("el infra I = ON\n");
		else
				printf("el infra I = OFF\n");
		if (valorinfra & INFRA_FI)
				printf("el infra FI = ON\n");
		else
				printf("el infra FI = OFF\n");
		if (valorinfra & INFRA_FD)
				printf("el infra FD = ON\n");
		else
				printf("el infra FD = OFF\n");
		if (valorinfra & INFRA_D)
				printf("el infra D = ON\n");
		else
				printf("el infra D = OFF\n");
		if (valorinfra & INFRA_TD)
				printf("el infra TD = ON\n");
		else
				printf("el infra TD = OFF\n");
		if (valorinfra & INFRA_TI)
			printf("el infra  TI = ON\n");
		else
			printf("el infra TI = OFF\n");
		delay_ms(1000);	
	}
}

static void leer_infrarojos(void)
{
		int valorinfra = infrarojo_cntrl_in_read();
		int i_I = valorinfra & INFRA_I;
		int i_FI = valorinfra & INFRA_FI;
		int i_FD = valorinfra & INFRA_FD;
		int i_D = valorinfra & INFRA_D;
		int i_TD = valorinfra & INFRA_TD;
		int i_TI = valorinfra & INFRA_TI;
		//printf("Hola \n");
		//int infrarojos[6] = {i_I,i_FI,i_FD,i_D,i_TD,i_TI};
		//_Bool infrarojosL[6];
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

static void prueba_leerinfra(void)
{
	while(!(buttons_in_read()&1)) 
	{
		leer_infrarojos();
		printf("I: %i, ",I);
		printf("FI: %i, ",FI);
		printf("FD: %i, ",FD);
		printf("D: %i, ",D);
		printf("TD: %i, ",TD);
		printf("TI: %i, \n",TI);
	} 
}

//probar que esta funcion gire 90 grados
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

//si consideramos un sensor adelante y uno atras
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

static void console_service(void)
{
	char *str;
	char *token;

	str = readstr();
	if(str == NULL) return;
	token = get_token(&str);
	if(strcmp(token, "help") == 0)
		help();
	else if(strcmp(token, "reboot") == 0)
		reboot();
	//else if(strcmp(token, "led") == 0)
	//	led_test();
	//else if(strcmp(token, "switch") == 0)
	//	switch_test();
	else if(strcmp(token, "display") == 0)
		display_test();
	//else if(strcmp(token, "rgbled") == 0)
	//	rgbled_test();
/*	else if(strcmp(token, "vga") == 0)
		vga_test();
*/
	prompt();
}

static void  probar_switches(void){
    int switches1 ;
    _Bool partida[5];
    _Bool llegada[5];
    int temp1,temp2;

    while(!(buttons_in_read()&1)) {
        switches1 = switchs_in_read();
        for(int i = 0;i < 5;i++)
        {
            temp1 = switches1 & (int)pow(2,i);
            if (temp1 != 0){
                llegada[4 - i] = 1; 
            }else
            {
                llegada[4 - i] = 0; 
            }
			switches1 = switchs_in_read();
            temp2 = switches1 & (int)pow(2,i+5);    
            if (temp2 != 0){
                partida[4 - i] = 1; 
            }else
            {
                partida[4 - i] = 0;             
            }
        }
        for(int i = 0; i < 5; i++)
        {
            printf("%i, ",partida[i]);
            delay_ms(500);
        }
        printf("\n");
        for(int i = 0; i < 5; i++)
        {
            printf("%i, ",llegada[i]);
            delay_ms(500);
        }
        printf("\n");   
    }   
}	

int  seleccionar_ruta(void){
	//utilizar switchs
	int switches1 ;
    _Bool partida[5];
    _Bool llegada[5];
	int nruta = 0;
    int temp1,temp2;
	
	_Bool selpartida = 0;
	_Bool selllegada = 0;
	int n1 = 0;
	int n2 = 0;

	while(!(selpartida && selllegada)) {
        switches1 = switchs_in_read();
        for(int i = 0;i < 5;i++)
        {
            temp1 = switches1 & (int)pow(2,i);
            if (temp1 != 0){
				n1 = (4 - i) + 1; 
                llegada[n1 - 1] = 1; 
				selllegada = 1;
            }else
            {
                llegada[4 - i] = 0; 
            }
			switches1 = switchs_in_read();
            temp2 = switches1 & (int)pow(2,i+5);    
            if (temp2 != 0){
				n2 = (4 - i) + 1; 
                partida[n2 - 1] = 1; 
				selpartida = 1;
            }else
            {
                partida[4 - i] = 0;             
            }
        } 
		if (n1 != n2){
			nruta = (n2*10) + n1;
		}else
		{	
			selpartida = 0;
			selllegada = 0;
		}
		printf("ruta: %i",nruta );
		delay_ms(200);
	}   
	return nruta;
}


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


int main(void)
{
	int nruta = 0;
	#ifdef CONFIG_CPU_HAS_INTERRUPT
	irq_setmask(0);
	irq_setie(1);
	#endif
	uart_init();
	//prueba_leerinfra();
	
	//girarnov(3);
	//corregir_posicion();
	
	//switch_test();
	//probar_switches();
	
	//nruta = seleccionar_ruta();
	
	nruta = teclado();
	printf("nruta : %i \n", nruta);
	recorrer_ruta(nruta);

	

	//avanzar();
	puts("\nSoC - RiscV project UNAL 2022-2"__DATE__" "__TIME__"\n");
	help();
	prompt();

	while(1) {
		console_service();
	/*	infrarojo_test();
		leds_out_write(15);
		delay_ms(100);
		leds_out_write(240);
		delay_ms(100);
		printf("El programa \n");*/
	}

	return 0;
}
