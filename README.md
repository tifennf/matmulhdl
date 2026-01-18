# Architecture de Multiplication matricielle en HDL

Ce dépot contient les sources d'une architecture de multiplication matricielle à base de MAC (Multiply Accumulate).  
C'est à dire permettant d'effectuer le produit matriciel $$Ax=b$$
avec $A$ une matrice de taille $Ndata \cdot Mdata$.

Une version en **Verilog** a été réalisé dans le cadre de l'UE VLSI de mon Master (M1).   
Elle se trouve dans les dossiers *matmulverilog* et *other_architecture*.  
De plus, le compte rendu associé présentant une analyse comparative de plusieurs architectures est disponible dans le fichier *CR.pdf*

Un portage en **VHDL** a été fait de ma propre initiative et se trouve dans le dossier *matmulvhdl*.

## Utiliser les testbenchs
### Version VHDL
```bash
cd matmulvhdl
make run
```
Cela va compiler et lancer le testbench pour la multiplication matricielle.  

D'autres testbenchs sont disponibles pour les composants du module (mul, mac, scalar_product).  
Il faut utiliser *ghdl* pour les lancer:

```bash
ghdl -a mul.vhd mac.vhd tb_mac.vhd
ghdl -e tb_mac
ghdl -r tb_mac
```

### Version Verilog
En utilisant iverilog, vous pouvez lancer les testbenchs avec les commandes suivantes:

```bash
iverilog -o test mul.v mac.v tb_mac.v
vvp test
```

En remplaçant avec les bons noms de fichiers.
