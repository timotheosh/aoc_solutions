#!/usr/bin/env python

from functools import reduce
from sys import argv,exit

def load_file(input_file):
    with open(input_file, 'r') as file:
        my_string = file.read().split('\n\n')
    return sorted(tuple(map(lambda x: reduce(lambda k,l: k + l, map(lambda y: int(y), x.split())), my_string)), reverse=True)

def results(file):
    data = load_file(file)

    print("AoC 2022 Day 1 Part 1: Most Calories: {}".format(data[0]))
    print("AoC 2022 Day 1 Part 2: Sum of top 3 calorie values: {}".format(reduce(lambda k,l: k + l, data[0:3])))

if __name__ == "__main__":
    if len(argv) != 2:
        print("Usage: {} PATH_TO_INPUT_FILE".format(argv[0]))
        exit(1)
    results(argv[1])
