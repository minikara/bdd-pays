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
header = ['dateElement', 'peine', 'idResident', 'idAuthorite']

peines = ['EnCoursDExecution', 'Execute', 'NonElligible']
poids = [2, 5, 15]

# generate random states
nb = 150
peine = rnd.choices(peines, poids, k=nb)

data = []
for i in range(nb):
    row = []
    row.append(time.random_date('2000-01-01'))
    row.append(peine[i])
    row.append(str(rnd.randint(1, 70)))
    row.append(str(rnd.randint(1, 50)))
    data.append(row)
    del row
    

# write csv
csv.write(data, out_file, header_row=header)
