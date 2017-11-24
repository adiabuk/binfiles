#!/usr/bin/env python -tt

""" Over symplistic py-cat, because why not? """

from __future__ import print_function
import sys

def cat(filename):
    """ open given file and print each line """
    filename = open(filename, 'rU')
    for line in filename:
        print(line,)


def main():
    cat(sys.argv[1])

if __name__ == '__main__':
    main()
