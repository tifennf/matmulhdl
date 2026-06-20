# Architecture de Multiplication matricielle en HDL

Ce dépot contient les sources d'une architecture de multiplication matricielle à base de MAC (Multiply Accumulate).  
C'est à dire permettant d'effectuer le produit matriciel $$Ax=b$$
avec $A$ une matrice de taille $Ndata \cdot Mdata$.

Une version en **Verilog** a été réalisé dans le cadre de l'UE VLSI de mon Master (M1).   
Elle se trouve dans les dossiers *matmulverilog* et *other_architecture*.  
De plus, le compte rendu associé présentant une analyse comparative de plusieurs architectures est disponible dans le fichier *CR.pdf*


## Utiliser les testbenchs
### Version Verilog
En utilisant iverilog, vous pouvez lancer les testbenchs avec les commandes suivantes:

```bash
iverilog -o test mul.v mac.v tb_mac.v
vvp test
```

En remplaçant avec les bons noms de fichiers.
