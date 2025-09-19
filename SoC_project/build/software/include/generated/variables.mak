PACKAGES=libc libcompiler_rt libbase libfatfs liblitespi liblitedram libliteeth liblitesdcard liblitesata bios
PACKAGE_DIRS=/home/julious/litex/litex/litex/soc/software/libc /home/julious/litex/litex/litex/soc/software/libcompiler_rt /home/julious/litex/litex/litex/soc/software/libbase /home/julious/litex/litex/litex/soc/software/libfatfs /home/julious/litex/litex/litex/soc/software/liblitespi /home/julious/litex/litex/litex/soc/software/liblitedram /home/julious/litex/litex/litex/soc/software/libliteeth /home/julious/litex/litex/litex/soc/software/liblitesdcard /home/julious/litex/litex/litex/soc/software/liblitesata /home/julious/litex/litex/litex/soc/software/bios
LIBS=libc libcompiler_rt libbase libfatfs liblitespi liblitedram libliteeth liblitesdcard liblitesata
TRIPLE=riscv64-unknown-elf
CPU=vexriscv
CPUFAMILY=riscv
CPUFLAGS=-march=rv32i2p0_m     -mabi=ilp32 -D__vexriscv__
CPUENDIANNESS=little
CLANG=0
CPU_DIRECTORY=/home/julious/litex/litex/litex/soc/cores/cpu/vexriscv
SOC_DIRECTORY=/home/julious/litex/litex/litex/soc
PICOLIBC_DIRECTORY=/home/julious/litex/pythondata-software-picolibc/pythondata_software_picolibc/data
COMPILER_RT_DIRECTORY=/home/julious/litex/pythondata-software-compiler_rt/pythondata_software_compiler_rt/data
export BUILDINC_DIRECTORY
BUILDINC_DIRECTORY=/home/julious/Documentos/RG7Digital2/intento3/lab03-2022-2-grupo07-22-2-20221119T191554Z-001/lab03-2022-2-grupo07-22-2/SoC_project/build/software/include
LIBC_DIRECTORY=/home/julious/litex/litex/litex/soc/software/libc
LIBCOMPILER_RT_DIRECTORY=/home/julious/litex/litex/litex/soc/software/libcompiler_rt
LIBBASE_DIRECTORY=/home/julious/litex/litex/litex/soc/software/libbase
LIBFATFS_DIRECTORY=/home/julious/litex/litex/litex/soc/software/libfatfs
LIBLITESPI_DIRECTORY=/home/julious/litex/litex/litex/soc/software/liblitespi
LIBLITEDRAM_DIRECTORY=/home/julious/litex/litex/litex/soc/software/liblitedram
LIBLITEETH_DIRECTORY=/home/julious/litex/litex/litex/soc/software/libliteeth
LIBLITESDCARD_DIRECTORY=/home/julious/litex/litex/litex/soc/software/liblitesdcard
LIBLITESATA_DIRECTORY=/home/julious/litex/litex/litex/soc/software/liblitesata
BIOS_DIRECTORY=/home/julious/litex/litex/litex/soc/software/bios
LTO=0
BIOS_CONSOLE_FULL=1