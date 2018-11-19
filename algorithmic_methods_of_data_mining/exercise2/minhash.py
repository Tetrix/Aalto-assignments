import numpy as np
import pandas as pd
import operator
import sympy

A = [('a', 3), ('b', 1)]
B = [('a', 1), ('b', 1), ('c', 1)]

if len(A) >= len(B):
    bigger = A
    smaller = B
else:
    bigger = B
    smaller = A

def get_intersection(bigger, smaller):
    intersection = {}
    for item in bigger:
        for elem in smaller:
            if elem[0] == item[0]:
                intersection[elem[0]] = min(item[1], elem[1])

    intersection = sorted(intersection.items(), key=operator.itemgetter(0))
    return intersection

intersection = get_intersection(bigger, smaller)


def get_union(bigger, smaller):
    union = {}
    for item in bigger:
        elem = [elem for elem in smaller if elem[0] == item[0]]
        if len(elem) != 0:
           union[item[0]] = max(elem[0][1], item[1])
        else:
            union[item[0]] = item[1]
    union = sorted(union.items(), key=operator.itemgetter(0))
    return union

union = get_union(bigger, smaller)

# print(union)


jaccart_similarity = sum([pair[1] for pair in intersection]) / sum([pair[1] for pair in union])


# MinHash
def get_array(set, union):
    array = []

    for item in union:
        elem = [elem for elem in set if elem[0] == item[0]]
        if len(elem) != 0:
            for i in range(item[1]):
                if i + 1 <= elem[0][1]:
                    array.append(1)
                else:
                    array.append(0)
        else:
            array.append(0)
    return array

A_array = get_array(A, union)
B_array = get_array(B, union)

num_rows = sum([pair[1] for pair in union])

rows = np.arange(0, num_rows, 1)

temp_rows = num_rows + 1

# (ax + b) mod p
prime = False
while prime == False:
    if sympy.isprime(temp_rows) == True:
        p = temp_rows
        prime = True
    else:
        temp_rows += 1

a = [1, 3]
b = [1]


# permute the rows

















