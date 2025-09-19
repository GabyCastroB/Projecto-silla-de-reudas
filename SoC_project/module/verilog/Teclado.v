`timescale 1ns / 1ps
module Teclado(clk_Teclado,Fila,Columna,ascii,isDone);
	input clk_Teclado;
	input [3:0]Fila,Columna;
	output reg isDone;
	output reg[6:0]ascii;
	
reg en;
reg[3:0]sal;
reg[7:0]cod;
reg opr;//se activa cuando se ha primido la tecla, para poseriormene poner en=1
reg cont;
	
	initial begin
		ascii=7'b0000000;
		sal=4'b0;
		en=0;
		cod=0;
		cont=0;
		isDone=0;
	end
	always@(posedge clk_Teclado)begin
	if(Fila==4'b1111)begin		//se activan todas las filas
	if(Columna==4'b1000 | Columna==4'b0100 | Columna==4'b0010 | Columna==4'b0001)begin
	sal=Columna;	//se guarda el codigo de 4 bits de columna
	if(opr==1)
	en=1;
	end
			else begin
				en=0;
				opr=0;
			end
		end
		else begin	//se empieza a hacer el recorrido 1000 - 0100 - 0010 - 0001
			if(sal==0)cod=cod;
			else begin
if(Columna==sal)begin//se vuelve a comparar sal con Columna y solo sera igual cuando este activada la fila en la que se oprimio la tecla
if(en==0)begin 		//una vez se suelta la tecla oprimida se concatena la fila con la columna y se guarda en la variable cod.
						cod={Fila,Columna};		
						opr=1;
					end
				end
			end
		end
	end
	
	always@(posedge clk_Teclado)
		if(en)begin
			if(~(cont==0)) begin
				cont<=cont+1'b1;
				isDone=1;
			end
			else
				isDone=0;
		end
		else cont<=1;
	
	
	always@(*)
			case(cod)
			
		        8'b00010100: ascii=7'b0000000; // 0
				8'b10001000: ascii=7'b0000001; // 1
				8'b10000100: ascii=7'b0000010; // 2
				8'b10000010: ascii=7'b0000011; // 3
				8'b01001000: ascii=7'b0000100; // 4
				8'b01000100: ascii=7'b0000101; // 5
				8'b01000010: ascii=7'b0000110; // 6
				8'b00101000: ascii=7'b0000111; // 7
				8'b00100100: ascii=7'b0001000; // 8
				8'b00100010: ascii=7'b0001001; // 9
				8'b10000001: ascii=7'b1001010; // A
				8'b01000001: ascii=7'b0101011; // B
				8'b00100001: ascii=7'b1001110; // C
				8'b00010001: ascii=7'b1101111; // D
				8'b00011000: ascii=7'b0101110; // "*"
				8'b00010010: ascii=7'b1111111; // "#"
				default: ascii=7'b0000000; //Vacio
			endcase

endmodule