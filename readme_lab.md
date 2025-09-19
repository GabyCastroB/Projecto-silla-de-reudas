## Compresión de los procesos y entrega del laboratorio con el SoC inicial antes de implementar el proyecto

1. Leer los pasos propuestos en la terminal , y ejecutar cada ejemplo que da
![help](https://github.com/unal-edigital2-labs/lab03-2022-2-grupo07-22-2/blob/main/help.png)

Cuando se ejecuta help, vuelve a mandar la lista de posibles comandos que recibe el SoC.
![help](https://github.com/unal-edigital2-labs/lab03-2022-2-grupo07-22-2/blob/main/reboot.png)

Cuando se ejecuta la función reboot, reinicia el SoC y vuelve a aparecer todo el texto de inicio.
Cuando se ejecutan led, switch, display, rgbled, y vga hacen diferentes secuencias para mostrar que el periférico está funcionando correctamente, En el ejemplo solo está funcionando led debido a que en SW los demás están comentados. 


2. Revisar el archivo buildSoCproject.py e intente generar la arquitectura del SoC.

![soc](https://github.com/unal-edigital2-labs/lab03-2022-2-grupo07-22-2/blob/main/hardware%20soc.png)

3. Revise el archivo main.c y comprenda en SW que se esta haciendo. Verifique el SW con la ejecución que realizo en los puntos 1 y 2.
```C
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
```
Cuando se ejecuta leds lo que hace es hacer que los 4 leds que se tienen en HW hagan una secuencia de prender y apagar como si fuera un barrido.

```C
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
	else if(strcmp(token, "led") == 0)
		led_test();
	else if(strcmp(token, "switch") == 0)
		switch_test();
	else if(strcmp(token, "display") == 0)
		display_test();
	else if(strcmp(token, "rgbled") == 0)
		rgbled_test();
/*	else if(strcmp(token, "vga") == 0)
		vga_test();
*/
	prompt();
}

```
Esta parte lo que hace es mostrar el help y recibe lo que se le escriba para correra la función seleccionada.

```C
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

```
En esta parte se hace un testeo de los ledsrgb.

```C
static void switch_test(void)
{
	unsigned short temp2 =0;
	printf("Test del los interruptores... se interrumpe con el botton 1\n");
	while(!(buttons_in_read()&1)) {
		unsigned short temp = switchs_in_read();
		if (temp2 != temp){
			printf("switch bus : %i\n", temp);
			leds_out_write(temp);
			temp2 = temp;
		}
	}
}

```
Lo que hace esta función es que cuando se usa un switch, se encienda un led arriba de este.
