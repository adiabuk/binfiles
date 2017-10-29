#!/usr/bin/python

"""
Return number and sum size of coredumps in /var/tmp/cores
for each filename prefix
"""

from __future__ import print_function
import json
import os
import re

COREDUMP_DIRS = ['/var/tmp/cores/']
OCCURANCES = dict()

def files(dirs):
    """ return generator of coredumps in directories """

    for path in dirs:
        for filename in os.listdir(path):
            fullpath = os.path.join(path, filename)
            if os.path.isfile(fullpath):

                size = os.path.getsize(fullpath)

                # get filename prefix
                match = re.search("(^[a-zA-Z0-9_-]+[a-zA-Z]+).*$", filename)
                yield match.group(1), size

def add_occurance_to_dict(file_key, size_key, size):
    """ add occurance of filename prefix to dict """

    if file_key in OCCURANCES:
        OCCURANCES[file_key] += 1
    else: OCCURANCES[file_key] = 1

    if size_key in OCCURANCES:
        OCCURANCES[size_key] += size
    else:
        OCCURANCES[size_key] = size

def get_coredump_stats():
    """ Collect coredump stats """

    total_occurances = 0
    total_size = 0

    for file_name, file_size in files(COREDUMP_DIRS):
        total_occurances += 1
        total_size += file_size

        # add occurance to dict
        add_occurance_to_dict('coredump.count.' + file_name,
                              'coredump.size.' + file_name, file_size)

    # Add aggregrgated results
    OCCURANCES['coredump.count'] = total_occurances
    OCCURANCES['coredump.size'] = total_size

    # return output as JSON
    return json.dumps(OCCURANCES, ensure_ascii=True)

if __name__ == '__main__':
    print(get_coredump_stats())
