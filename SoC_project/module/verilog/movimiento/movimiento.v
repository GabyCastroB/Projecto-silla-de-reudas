`timescale 1ns / 1ps


module movimiento(  input clk, // Reloj

                    // Registros
                    input [2:0] estado,
                    
                    // Conexiones del Dispositivo 
                    output reg [1:0] right,
                    output reg [1:0] left
                    );
    
always@(posedge clk)begin
	case(estado)
        // Parar
        3'b000: begin
                    right[0] = 0;
                    right[1] = 0;
                    left[0]  = 0;
                    left[1]  = 0;
                end
        // Avanzar
        3'b001: begin
                    right[0] = 1;
                    right[1] = 0;
                    left[0]  = 1;
                    left[1]  = 0;
                end
        // Retroceder
   	    3'b010: begin
                    right[0] = 0;
                    right[1] = 1;
                    left[0]  = 0;
                    left[1]  = 1;
                end
        // Izquierda
        3'b011: begin
                    right[0] = 1;
                    right[1] = 0;
                    left[0]  = 0;
                    left[1]  = 1;
                end
        // Derecha
        3'b100: begin
                    right[0] = 0;
                    right[1] = 1;
                    left[0]  = 1;
                    left[1]  = 0;
                end
        // Caso por Defecto (Parar)
        default:begin
                    right[0] = 0;
                    right[1] = 0;
                    left[0]  = 0;
                    left[1]  = 0;
                end
	endcase
end

endmodule