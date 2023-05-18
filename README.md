# Selection-Sort-for-characters-and-Integers-with-MIPS
[![Language Badge](https://img.shields.io/badge/Language-MIPS-orange.svg)](https://en.wikipedia.org/wiki/MIPS_architecture)
[![License Badge](https://img.shields.io/badge/License-CC%20BY--NC%204.0-0a2c46.svg)](https://creativecommons.org/licenses/by-nc/4.0/legalcode)

This project implements selection sort algorithm in MIPS assembly language to sort both characters and integers.

## Algorithm

The selection sort algorithm works by repeatedly finding the minimum element from the unsorted part of the array and putting it at the beginning. The algorithm maintains two subarrays in a given array:

1. The subarray which is already sorted.
2. Remaining subarray which is unsorted.

## Usage

To use the program, simply load the input array into the `.data` section of the MIPS program and call the `selection_sort` function. The sorted array will be stored in the same input array.

## Improvements

The program can be optimized by using different sorting algorithms such as insertion sort and bubble sort. The program can also be extended to sort other types of data structures such as linked lists and trees.
