# Génération des données pour le testbench du produit scalaire

import math

import numpy as np

Nbits = 4  # Nombre de bits d'un élément d'un vecteur
Ndata = 4  # Taille d'un vecteur
N = 100  # Nombre de vecteur

max_val = 1 << Nbits
vec_A = np.random.randint(0, max_val, (N, Ndata))
vec_B = np.random.randint(0, max_val, (N, Ndata))
sp = np.sum((vec_A * vec_B), axis=1)

l_char = math.ceil(Nbits / 4)  # largeur en nombre de char
with (
    open("data_sp_A.hex", "w") as fA,
    open("data_sp_B.hex", "w") as fB,
    open("data_sp_expected.hex", "w") as fExp,
):
    for i in range(N):
        # conversion de chaque élément en hex de la bonne longueur avant de write
        # val:0LX donne val en hexadecimal de longuer L char, et on comble avec des 0 devant si besoin
        line_A = "".join([f"{val:0{l_char}X}" for val in vec_A[i]])
        fA.write(line_A + "\n")
        line_B = "".join([f"{val:0{l_char}X}" for val in vec_B[i]])
        fB.write(line_B + "\n")

        fExp.write(f"{sp[i]:04X}\n")
