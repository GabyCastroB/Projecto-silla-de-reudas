################################################################################
# IO constraints
################################################################################
# serial:0.tx
set_property LOC D4 [get_ports {serial_tx}]
set_property IOSTANDARD LVCMOS33 [get_ports {serial_tx}]

# serial:0.rx
set_property LOC C4 [get_ports {serial_rx}]
set_property IOSTANDARD LVCMOS33 [get_ports {serial_rx}]

# clk:0
set_property LOC E3 [get_ports {clk}]
set_property IOSTANDARD LVCMOS33 [get_ports {clk}]

# cpu_reset:0
set_property LOC C12 [get_ports {cpu_reset}]
set_property IOSTANDARD LVCMOS33 [get_ports {cpu_reset}]

# sw:0
set_property LOC J15 [get_ports {sw0}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw0}]

# sw:1
set_property LOC L16 [get_ports {sw1}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw1}]

# sw:2
set_property LOC M13 [get_ports {sw2}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw2}]

# sw:3
set_property LOC R15 [get_ports {sw3}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw3}]

# sw:4
set_property LOC R17 [get_ports {sw4}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw4}]

# sw:5
set_property LOC T18 [get_ports {sw5}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw5}]

# sw:6
set_property LOC U18 [get_ports {sw6}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw6}]

# sw:7
set_property LOC R13 [get_ports {sw7}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw7}]

# sw:8
set_property LOC T8 [get_ports {sw8}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw8}]

# sw:9
set_property LOC U8 [get_ports {sw9}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw9}]

# sw:10
set_property LOC R16 [get_ports {sw10}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw10}]

# sw:11
set_property LOC T13 [get_ports {sw11}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw11}]

# sw:12
set_property LOC H6 [get_ports {sw12}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw12}]

# sw:13
set_property LOC U12 [get_ports {sw13}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw13}]

# sw:14
set_property LOC U11 [get_ports {sw14}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw14}]

# sw:15
set_property LOC V10 [get_ports {sw15}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw15}]

# btnc:0
set_property LOC N17 [get_ports {btnc}]
set_property IOSTANDARD LVCMOS33 [get_ports {btnc}]

# btnd:0
set_property LOC P18 [get_ports {btnd}]
set_property IOSTANDARD LVCMOS33 [get_ports {btnd}]

# btnu:0
set_property LOC M18 [get_ports {btnu}]
set_property IOSTANDARD LVCMOS33 [get_ports {btnu}]

# display_cs_n:0
set_property LOC J17 [get_ports {display_cs_n[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {display_cs_n[0]}]

# display_cs_n:0
set_property LOC J18 [get_ports {display_cs_n[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {display_cs_n[1]}]

# display_cs_n:0
set_property LOC J14 [get_ports {display_cs_n[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {display_cs_n[2]}]

# display_cs_n:0
set_property LOC P14 [get_ports {display_cs_n[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {display_cs_n[3]}]

# display_cs_n:0
set_property LOC K2 [get_ports {display_cs_n[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {display_cs_n[4]}]

# display_cs_n:0
set_property LOC U13 [get_ports {display_cs_n[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {display_cs_n[5]}]

# display_cs_n:0
set_property LOC T9 [get_ports {display_cs_n[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {display_cs_n[6]}]

# display_cs_n:0
set_property LOC T14 [get_ports {display_cs_n[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {display_cs_n[7]}]

# display_abcdefg:0
set_property LOC T10 [get_ports {display_abcdefg[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {display_abcdefg[0]}]

# display_abcdefg:0
set_property LOC R10 [get_ports {display_abcdefg[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {display_abcdefg[1]}]

# display_abcdefg:0
set_property LOC K16 [get_ports {display_abcdefg[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {display_abcdefg[2]}]

# display_abcdefg:0
set_property LOC K13 [get_ports {display_abcdefg[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {display_abcdefg[3]}]

# display_abcdefg:0
set_property LOC P15 [get_ports {display_abcdefg[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {display_abcdefg[4]}]

# display_abcdefg:0
set_property LOC T11 [get_ports {display_abcdefg[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {display_abcdefg[5]}]

# display_abcdefg:0
set_property LOC L18 [get_ports {display_abcdefg[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {display_abcdefg[6]}]

# display_abcdefg:0
set_property LOC H15 [get_ports {display_abcdefg[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {display_abcdefg[7]}]

# infrarojo:0
set_property LOC H2 [get_ports {infrarojo0}]
set_property IOSTANDARD LVCMOS33 [get_ports {infrarojo0}]

# infrarojo:1
set_property LOC G2 [get_ports {infrarojo1}]
set_property IOSTANDARD LVCMOS33 [get_ports {infrarojo1}]

# infrarojo:2
set_property LOC E7 [get_ports {infrarojo2}]
set_property IOSTANDARD LVCMOS33 [get_ports {infrarojo2}]

# infrarojo:3
set_property LOC J3 [get_ports {infrarojo3}]
set_property IOSTANDARD LVCMOS33 [get_ports {infrarojo3}]

# infrarojo:4
set_property LOC J4 [get_ports {infrarojo4}]
set_property IOSTANDARD LVCMOS33 [get_ports {infrarojo4}]

# infrarojo:5
set_property LOC G4 [get_ports {infrarojo5}]
set_property IOSTANDARD LVCMOS33 [get_ports {infrarojo5}]

# Fila:0
set_property LOC K1 [get_ports {Fila0}]
set_property IOSTANDARD LVCMOS33 [get_ports {Fila0}]

# Fila:1
set_property LOC F6 [get_ports {Fila1}]
set_property IOSTANDARD LVCMOS33 [get_ports {Fila1}]

# Fila:2
set_property LOC J2 [get_ports {Fila2}]
set_property IOSTANDARD LVCMOS33 [get_ports {Fila2}]

# Fila:3
set_property LOC G6 [get_ports {Fila3}]
set_property IOSTANDARD LVCMOS33 [get_ports {Fila3}]

# Columna:0
set_property LOC H4 [get_ports {Columna0}]
set_property IOSTANDARD LVCMOS33 [get_ports {Columna0}]

# Columna:1
set_property LOC H1 [get_ports {Columna1}]
set_property IOSTANDARD LVCMOS33 [get_ports {Columna1}]

# Columna:2
set_property LOC G1 [get_ports {Columna2}]
set_property IOSTANDARD LVCMOS33 [get_ports {Columna2}]

# Columna:3
set_property LOC G3 [get_ports {Columna3}]
set_property IOSTANDARD LVCMOS33 [get_ports {Columna3}]

# right:0
set_property LOC F18 [get_ports {right0}]
set_property IOSTANDARD LVCMOS33 [get_ports {right0}]

# right:1
set_property LOC G18 [get_ports {right1}]
set_property IOSTANDARD LVCMOS33 [get_ports {right1}]

# left:0
set_property LOC D17 [get_ports {left0}]
set_property IOSTANDARD LVCMOS33 [get_ports {left0}]

# left:1
set_property LOC E17 [get_ports {left1}]
set_property IOSTANDARD LVCMOS33 [get_ports {left1}]

################################################################################
# Design constraints
################################################################################

set_property INTERNAL_VREF 0.750 [get_iobanks 34]

################################################################################
# Clock constraints
################################################################################


################################################################################
# False path constraints
################################################################################


set_false_path -quiet -through [get_nets -hierarchical -filter {mr_ff == TRUE}]

set_false_path -quiet -to [get_pins -filter {REF_PIN_NAME == PRE} -of_objects [get_cells -hierarchical -filter {ars_ff1 == TRUE || ars_ff2 == TRUE}]]

set_max_delay 2 -quiet -from [get_pins -filter {REF_PIN_NAME == C} -of_objects [get_cells -hierarchical -filter {ars_ff1 == TRUE}]] -to [get_pins -filter {REF_PIN_NAME == D} -of_objects [get_cells -hierarchical -filter {ars_ff2 == TRUE}]]