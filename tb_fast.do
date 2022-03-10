#Cria biblioteca do projeto
vlib work

#compila projeto: todos os aquivo. Ordem � importante
vcom rom.vhd ir.vhd tb_fast.vhd

#Simula (work � o diretorio, testbench � o nome da entity)
vsim -t ns work.tb_fast

#Mosta forma de onda
view wave

#Adiciona ondas espec�ficas
# -radix: binary, hex, dec
# -label: nome da forma de onda
add wave -radix binary  /clk
add wave -radix binary  /en
add wave -radix binary  /rd_addr
add wave -radix binary  /data_out

add wave -radix binary  /clear         
add wave -radix binary  /load        
add wave -radix binary  /opcode
add wave -radix binary  /rs
add wave -radix binary  /rt
add wave -radix binary  /rd
add wave -radix binary  /shamt 
add wave -radix binary  /funct
add wave -radix binary  /address
add wave -radix binary  /pseudo_address

#Simula at� um 500ns
run 80ns

wave zoomfull
write wave wave.ps