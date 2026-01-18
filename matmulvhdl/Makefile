
GHDL = ghdl
FLAGS = --vcd=tb_mat_mul.vcd
FILES = mul.vhd mac.vhd scalar_product.vhd mat_mul.vhd tb_mat_mul.vhd
SIMTOP = tb_mat_mul

all: run

compile:
	$(GHDL) -a $(FILES)

elaborate: compile
	$(GHDL) -e $(SIMTOP)


run: elaborate
	$(GHDL) -r $(SIMTOP) $(FLAGS)

# Nettoyage des fichiers générés
clean:
	$(GHDL) --clean
	rm -f *.vcd *.cf

.PHONY: all compile elaborate run clean