from migen import *
from migen.genlib.cdc import MultiReg
from litex.soc.interconnect.csr import *
from litex.soc.interconnect.csr_eventmanager import *

# Modulo Principal
class Tecladoverilog(Module,AutoCSR):
    def __init__(self,Fila,Columna):
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
                


        
      
        

        
        
        
        
        
        
        
        
        
