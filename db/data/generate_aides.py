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
header = ['typeAide', 'frequence', 'montant', 'dateObtention', 'dateExpiration',
            'etat', 'resident', 'admin']

# data sources
aide = ['CAF', 'CROUS', 'RSA', 'CMU', 'PrimeNaissance']
frequence = ['m', 'm', 'm', 'a', 'p']
montant = [220, 500, 550, 500, 872]
duree_ans = [1, 1, 1, 1, 0]

etats = ['EnCoursDeValidation', 'Valide', 'Refuse', 'Expire']
poids = [1, 3, 7, 15]

# generate random states
nb = 500
etat = rnd.choices(etats, poids, k=nb)

data = []
for i in range(nb):
    choice = rnd.randrange(len(aide))
    row = [aide[choice], frequence[choice]]
    if etat[i] == 'EnCoursDeValidation':
        row.append('')
        row.append(time.random_date('2019-02-01'))
        row.append('')
    elif etat[i] == 'Valide':
        row.append(str(rnd.randint(montant[choice]//5, montant[choice])))
        debut = time.random_date('2018-06-01')
        row.append(debut)
        row.append(time.add_duration(debut, yrs=duree_ans[choice]))
    elif etat[i] == 'Refuse':
        row.append('')
        row.append(time.random_date('2012-01-01'))
        row.append('')
    elif etat[i] == 'Expire':
        row.append(str(rnd.randint(montant[choice]//5, montant[choice])))
        fin = time.random_date('2011-01-01')
        row.append(time.add_duration(fin, yrs=-duree_ans[choice]))
        row.append(fin)
    row.append(etat[i])
    row.append(str(rnd.randint(1, 100)))
    row.append(str(rnd.randint(1, 50)))
    data.append(row)
    del row
    

# write csv
csv.write(data, out_file, header_row=header)
