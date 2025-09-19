`timescale 1ns / 1ps
module Top_teclado(clk50,ascii,Columna,isDone,Fila);
	input clk50; 
	input [3:0]Columna;
	output [6:0]ascii; 
	output  isDone;
	output [3:0] Fila;
	
	wire w_clk;

	LectorFila lec_F(.clk_sec(w_clk), .ent_teclado(Fila));
	Teclado teclado(.clk_Teclado(w_clk), .Fila(Fila), .ascii(ascii), .Columna(Columna), .isDone(isDone));
	Divisor_Teclado div_T(.clk_T(clk50), .t(w_clk));
endmodule