#!/usr/bin/env python
# PYTHON_ARGCOMPLETE_OK

"""
Remove spaces from filenames and dirs, and replace them with underscores
Look for files recursively starting from current directory
"""

import argparse
import os
import sys

from glob import glob
from getch import getch
import argcomplete

def main():
    """ Main module """

    space_files = []
    parser = argparse.ArgumentParser('Remove spaces from files and dirs')
    group = parser.add_mutually_exclusive_group(required=True)

    group.add_argument('-a', '--all', required=False, action='store_true',
                       default=False, help='Parse all files')
    group.add_argument('-l', '--list', required=False, action='store_true',
                       default=False, help='list all files')
    group.add_argument('-i', '--interactive', required=False,
                       action='store_true', default=False,
                       help='interactive rename')
    parser.add_argument('-f', '--files_only', required=False,
                        action='store_true', default=False,
                        help="don't show dirs")

    argcomplete.autocomplete(parser)
    args = parser.parse_args()
    path = os.curdir
    results = [y for x in os.walk(path)
               for y in glob(os.path.join(x[0], '*'))]

    if not results:
        print "No files found"
        sys.exit(1)

    files=[]
    dirs=[]

    for result in results:
        if os.path.isfile(result):
            files.append(result)
        elif os.path.isdir(result):
            dirs.append(result)

    for curr_file in files:
        base_name = os.path.basename(curr_file)
        if " " in base_name:
            space_files.append(curr_file)

    # need to do dirs last, so that we don't remove a path that we traverse later
    if not args.files_only and dirs:
        for curr_dir in dirs:
            if " " in curr_dir:
                space_files.append(curr_dir)

    if not space_files:
        print "No files with spaces found"
        sys.exit(1)


    for item in space_files:
        if args.list:
            print "*", item
        elif args.all:
            dir_name = os.path.dirname(item)
            base_name = os.path.basename(item)
            fixed_name = dir_name + '/' + base_name.replace(" ", "_")
            print "Renaming {0} to {1}".format(item, fixed_name)
            os.rename(item, fixed_name)
        elif args.interactive:
            dir_name = os.path.dirname(item)
            base_name = os.path.basename(item)
            fixed_name = dir_name + '/' + base_name.replace(" ", "_")

            print "Renaming {0} to {1}".format(item, fixed_name)
            print "Proceed? [y|N]:",
            answer = getch()
            if answer.upper() == 'Y':
                os.rename(item, fixed_name)
            print

if __name__ == '__main__':
    main()
