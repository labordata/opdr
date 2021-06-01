import sys
import csv


writer = csv.writer(sys.stdout)

first_row = next(sys.stdin).strip().split('|')
writer.writerow(first_row)

expected_elements = len(first_row)

previous_elements = []
for line in sys.stdin:
    new_elements = line.strip().split('|')
    if not previous_elements and len(new_elements) >= expected_elements: 
        writer.writerow(new_elements)
    elif not(previous_elements):
        previous_elements = new_elements
    else:
        previous_elements[-1] += '\n' + new_elements[0]
        previous_elements += new_elements[1:]

        previous_elements[-1] = previous_elements[-1].strip()
        if len(previous_elements) == expected_elements:
            writer.writerow(previous_elements)
            previous_elements = []
        if len(previous_elements) > expected_elements:
            raise ValueError(previous_elements)

