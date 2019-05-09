import csv

def read(input_file, header_row=True, delimiter=';', quotechar='"'):
    data = []
    with open(input_file) as csv_file:
        reader = csv.reader(csv_file, delimiter=delimiter, quotechar=quotechar)
        for row in reader:
            data.append(row)
    if header_row:
        return data[0], data[1:]
    return data

def write(input_list, output_file, header_row=None, delimiter=';', quotechar='"'):
    with open(output_file, 'w', newline='\n') as csv_file:
        writer = csv.writer(csv_file, delimiter=delimiter,
                            quotechar=quotechar, quoting=csv.QUOTE_MINIMAL)
        if header_row:
            writer.writerow(header_row)
        for row in input_list:
            writer.writerow(row)