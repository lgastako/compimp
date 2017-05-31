#!/usr/bin/env python3 -- -O
import random
import sys
sys.setrecursionlimit(10000)

def partition_first(array, l, r):
    p = array[l]
    i = l + 1
    for j in range(l+1, r):
        if array[j] < p:
            array[j], array[i] = array[i], array[j]
            i += 1
    array[l], array[i-1] = array[i-1], array[l]
    return (i-1)

def partition_last(array, l, r):
    array[r-1], array[l] = array[l], array[r-1]
    return partition_first(array, l, r)

def partition_median(array, l, r):
    p_idx = choose_median(array, l, r)
    array[p_idx], array[l] = array[l], array[p_idx]
    return partition_first(array, l, r)

def choose_median(array, l, r):
    head = array[l]
    last = array[r-1]
    length = r-l
    if length % 2 == 0:
        mid_idx = l + (length//2) - 1
    else:
        mid_idx = l + (length//2)
    mid = array[mid_idx]
    options = [(l, head), (mid_idx, mid), (r-1, last)]
    options.remove(max(options, key=lambda v: v[1]))
    options.remove(min(options, key=lambda v: v[1]))
    return options[0][0]

def quicksort(array, start, end, partition):
    global comparisons
    if end<=start: return
    else:
        p_idx = partition(array, start, end)
        comparisons += (end-start-1)
        quicksort(array, start, p_idx, partition)
        quicksort(array, p_idx+1, end, partition)


def generate_random_contents(n):
    mx = sys.maxsize
    mn = -mx
    return [random.randint(mn, mx) for i in range(n)]

contents = generate_random_contents(1000000)

comparisons = 0
inp1 = contents.copy()
quicksort(inp1, 0, len(inp1), partition_first)
print(comparisons)

comparisons = 0
inp2 = contents.copy()
quicksort(inp2, 0, len(inp2), partition_last)
print(comparisons)

comparisons = 0
inp3 = contents.copy()
quicksort(inp3, 0, len(inp3), partition_median)
print(comparisons)
