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
header = ['montant', 'dateDeclaration', 'etat', 'resident', 'admin']

# data sources

etats = ['EnCoursDeValidation', 'Valide', 'Refuse']
poids = [1, 9, 3]

# generate random states
nb = 500
etat = rnd.choices(etats, poids, k=nb)

data = []
for i in range(nb):
    row = []
    if etat[i] == 'EnCoursDeValidation':
        row.append('')
        row.append(time.random_date('2019-02-01'))
    elif etat[i] == 'Valide':
        row.append(str(rnd.randint(100,4000)))
        row.append(time.random_date('2014-01-01'))
    elif etat[i] == 'Refuse':
        row.append('')
        row.append(time.random_date('2014-01-01'))
    row.append(etat[i])
    row.append(str(rnd.randint(1, 100)))
    row.append(str(rnd.randint(1, 50)))
    data.append(row)
    del row
    

# write csv
csv.write(data, out_file, header_row=header)
