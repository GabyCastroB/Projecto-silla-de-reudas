#grupo 1
from migen import *
from migen.genlib.cdc import MultiReg
from litex.soc.interconnect.csr import *
from litex.soc.interconnect.csr_eventmanager import *

# Modulo de Movimiento
class movimiento(Module, AutoCSR):
    def __init__(self, right, left):
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