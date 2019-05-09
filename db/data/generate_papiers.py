#!/bin/python3

import sys
import csv_io as csv
import random as rnd
import time_io as time

# parse script arguments
if len(sys.argv) == 2:
    out_file = sys.argv[1]
else:
    print("Error: wrong number of arguments.")
    sys.exit(1)

# init header csv
header = ['typePapier', 'dateDebut', 'dateFin', 'tarif', 'etat', 'resident']

# data sources
types = ['passeport', 'titreDeSejour', 'livretFamille', 'carteId' , 'carteElectorale']
duree_min = [10, 1, None, 15, 3]
duree_max = [10, 5, None, 15, 5]
tarif = [86, 47, 0, 0, 0, 0, 0]

etats = ['EnCoursDeValidation', 'Valide', 'Refuse', 'Expire']
poids = [1, 10, 0, 2]

# generate random states
nb = 500
etat = rnd.choices(etats, poids, k=nb)

data = []
for i in range(nb):
    j = rnd.randrange(len(types))
    row = [types[j]]
    if types[j] == 'livretFamille':
        row.append(time.random_date('1960-01-01'))
        row += ['', 0, 'Valide']
    else:
        if etat[i] == 'EnCoursDeValidation':
            row.append(time.random_date('2019-02-01'))
            row.append('')
        elif etat[i] == 'Valide':
            if j in [1, 2]:
                fin = time.random_date('2019-06-01', '2019-08-01')
            else:
                fin = time.random_date('2019-06-01', '2021-05-31')
            row.append(time.add_random_duration(fin, range_yrs=(-duree_max[j], -duree_min[j])))
            row.append(fin)
        elif etat[i] == 'Refuse':
            row.append(time.random_date('2012-01-01'))
            row.append('')
        elif etat[i] == 'Expire':
            fin = time.random_date('2000-01-01', '2019-05-10')
            row.append(time.add_random_duration(fin, range_yrs=(-duree_max[j], -duree_min[j])))
            row.append(fin)
        row.append(tarif[j])
        row.append(etat[i])
    row.append(str(rnd.randint(1, 100)))
    data.append(row)
    del row
    

# write csv
csv.write(data, out_file, header_row=header)
