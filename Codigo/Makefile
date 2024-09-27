# Ayuda sobre los comandos disponibles
help: help-sim help-syn

# Limpieza de archivos generados por síntesis y simulación
clean: clean-syn clean-sim

# Nombre del módulo principal
TOP=seguidor_linea

# Nombre del testbench del proyecto para la simulación
tb?=$(TOP)_tb.v

# Archivos de diseño del proyecto
DESIGN=$(TOP).v top.v  # Asegúrate de incluir todos los archivos necesarios
DIR_BUILD=build
DEVSERIAL=/dev/ttyACM0

# Nombre del proyecto para empaquetar
Z=seguidor_linea

# Archivo de restricciones
PCF?=$(TOP).pcf

# Archivos generados por el proceso de síntesis y implementación
JSON?=$(DIR_BUILD)/$(TOP).json
ASC?=$(DIR_BUILD)/$(TOP).asc
BITSTREAM?=$(DIR_BUILD)/$(TOP).bin

help-syn:
	@echo "\n## SINTESIS Y CONFIGURACIÓN ##"
	@echo "\tmake syn\t-> Sintetizar diseño"
	@echo "\tmake config\t-> Configurar fpga"

syn: json asc bitstream

OBJS+=$(DESIGN)

$(JSON): $(OBJS)
	mkdir -p $(DIR_BUILD)
	yosys -p "synth_ice40 -top $(TOP) -json $(JSON)" $(OBJS)

$(ASC): $(JSON)
	nextpnr-ice40 --hx4k --package tq144 --json $(JSON) --pcf $(PCF) --asc $(ASC)

$(BITSTREAM): $(ASC)
	icepack $(ASC) $(BITSTREAM)

config:
	stty -F $(DEVSERIAL) raw
	cat $(BITSTREAM) > $(DEVSERIAL)

json: $(JSON)
asc: $(ASC)
bitstream: $(BITSTREAM)

Z?=prj
zip:
	$(RM) $Z $Z.zip
	mkdir -p $Z
	head -n -3 Makefile > $Z/Makefile
	sed -n '5,$$p' $(MK_SYN) >> $Z/Makefile
	sed -n '7,$$p' $(MK_SIM) >> $Z/Makefile
	cp -var *.v *.md *.pcf .gitignore $Z
ifneq ($(wildcard *.mem),) # Si existe un archivo .mem
	cp -var *.mem $Z
endif
ifneq ($(wildcard *.hex),) # Si existe un archivo .hex
	cp -var *.hex $Z
endif
ifneq ($(wildcard *.png),) # Si existe un archivo .png
	cp -var *.png $Z
endif
ifneq ($(wildcard *.txt),) # Si existe un archivo .txt
	cp -var *.txt $Z
endif
ifneq ($(wildcard *.gtkw),) # Si existe un archivo .gtkw
	cp -var *.gtkw $Z
endif
	zip -r $Z.zip $Z

init:
	@echo "build/\nsim/\n*.log\n$Z/\n" > .gitignore
	touch $(TOP).png README.md

clean-syn:
	$(RM) -rf $(DIR_BUILD)

.PHONY: clean

S=sim

help-sim:
	@echo "\n## SIMULACIÓN Y RTL##"
	@echo "\tmake rtl \t-> Crear el RTL desde el TOP"
	@echo "\tmake sim \t-> Simular diseño"
	@echo "\tmake wave \t-> Ver simulación en gtkwave"
	@echo "\nEjemplos de simulaciones con más argumentos:"
	@echo "\tmake sim VVP_ARG=+inputs=5\t\t:Agregar un argumento a la simulación"
	@echo "\tmake sim VVP_ARG=+a=5\ +b=6\t\t:Agregar varios argumentos a la simulación"
	@echo "\tmake sim VVP_ARG+=+a=5 VVP_ARG+=+b=6\t:Agregar varios argumentos a la simulación"
	@echo "\tmake rtl TOP=modulo1\t\t\t:Obtiene el RTL de otros modulos (submodulos)"
	@echo "\tmake rtl rtl2png\t\t\t:Convertir el RTL del TOP desde formato svg a png"
	@echo "\tmake rtl rtl2png TOP=modulo1\t\t:Además de convertir, obtiene el RTL de otros modulos (submodulos)"
	@echo "\tmake convertOneVerilogFile\t\t\t:Crear un único verilog del diseño"

rtl: rtl-from-json view-svg

sim: clean-sim iverilog-compile vpp-simulate wave

MORE_SRC2SIM?=
iverilog-compile:
	mkdir -p $S
ifneq ($(MORE_SRC2SIM), )
	cp -var $(MORE_SRC2SIM) $S
endif
	iverilog -o $S/$(TOP).vvp $(tb) $(DESIGN)

VVP_ARG=
vpp-simulate:
	cd $S && vvp $(TOP).vvp -vcd $(VVP_ARG) -dumpfile=$(TOP).vcd

wave:
	@gtkwave $S/$(TOP).vcd $(TOP).gtkw || (echo "No hay una forma de onda que mostrar en gtkwave, posiblemente no fue solicitada en la simulación")

json-yosys:
	mkdir -p $S
	yosys -p 'read_verilog $(DESIGN); prep -top $(TOP); hierarchy -check; proc; write_json $S/$(TOP).json'

convertOneVerilogFile:
	mkdir -p $S
	yosys -p 'read_verilog $(DESIGN); prep -top $(TOP); hierarchy -check; proc; opt -full; write_verilog -noattr -nodec $S/$(TOP).v'

rtl-from-json: json-yosys
	netlistsvg $S/$(TOP).json -o $S/$(TOP).svg

view-svg:
	eog $S/$(TOP).svg

rtl-xdot:
	yosys -p $(RTL_COMMAND)

rtl2png:
	convert -density 200 -resize 1200 $S/$(TOP).svg $(TOP).png

init-sim:	
	@echo "sim/\n$Z/\n" > .gitignore
	touch README.md $(TOP).png

RM=rm -rf
zip-sim:
	$(RM) $Z $Z.zip
	mkdir -p $Z
	head -n -2 Makefile > $Z/Makefile
	sed -n '7,$$p' $(MK_SIM) >> $Z/Makefile
	cp -var *.v *.md .gitignore $Z
ifneq ($(wildcard *.mem),) # Si existe un archivo .mem
	cp -var *.mem $Z
endif
ifneq ($(wildcard *.hex),) # Si existe un archivo .hex
	cp -var *.hex $Z
endif
ifneq ($(wildcard *.png),) # Si existe un archivo .png
	cp -var *.png $Z
endif
ifneq ($(wildcard *.txt),) # Si existe un archivo .txt
	cp -var *.txt $Z
endif
ifneq ($(wildcard *.gtkw),) # Si existe un archivo .gtkw
	cp -var *.gtkw $Z
endif
ifneq ($(wildcard *.dig),) # Si existe un archivo .dig
	cp -var *.dig $Z
endif
	zip -r $Z.zip $Z

clean-sim:
	rm -rf $S $Z $Z.zip

## YOSYS ARGUMENTS
RTL_COMMAND?='read_verilog $(DESIGN);\
						 hierarchy -check;\
						 show $(TOP)'

