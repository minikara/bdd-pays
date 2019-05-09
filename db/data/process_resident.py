#!/bin/python3

import sys
import csv_io as csv
import numpy as np
from random import randrange as rnd

# parse script arguments
if len(sys.argv) == 3:
    in_file = sys.argv[1]
    out_file = sys.argv[2]
else:
    print("Error: wrong number of arguments.")
    sys.exit(1)

# read csv
header, data = csv.read(in_file)

# choose random N occurances
indices = []
N = 80
assert N < len(data)
while len(indices) < N:
    index = rnd(len(data))
    if index not in indices:
        indices.append(index)

# find field index
field = header.index('nationalite')

# alter data in chosen indices
for index in indices:
    data[index][field] = 'France'

# write csv
csv.write(data, out_file, header_row=header)
