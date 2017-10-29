#!/usr/bin/python

import re

def find_locked_repos(target_dir):
    file_handler = open('output.txt')
    text = file_handler.read()
    locked_repos = re.findall(r"\s\sL\s+(\S+)", text)

    for locked_repo in locked_repos:
        print locked_repo

