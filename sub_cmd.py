#!/usr/bin/env python

from __future__ import print_function
import os
import json
import sys

HOME = os.getenv('HOME')
with open(HOME+'/bin/command_aliases.json', 'r') as fh:
    string = fh.read()
    subs = json.loads(string)

if sys.argv[1] in subs:
    replace = subs[sys.argv[1]]
else: replace = [sys.argv[1],'']

other_args = ' '.join(str(item) for item in sys.argv[2:])
command = 'docker {0} {1} {2} '.format(replace[0], other_args,  replace[1])
print(command, '\n')

os.system(command)
