#!/usr/bin/env python
# PYTHON_ARGCOMPLETE_OK

"""
Find and download episodes from dailymotion.com
"""

import argparse
import json
import sys
import urllib

import argcomplete
from you_get.extractors import dailymotion

def get_videos(start=1, end=1000, output='.', user=None):
    """
    Fetch videos for a particular user in given episode range
    """
    url = 'https://api.dailymotion.com/user/{0}/videos?search={1}&fields=id'  # user, SEQ

    for episode in range(start, end):
        episode_url = url.format(user, episode)
        print(episode_url)
        try:
            data = urllib.request.urlopen(url.format(user, episode)).read()
        except urllib.error.HTTPError:
            sys.stderr.write('\n404 Error Encountered, check username...\n')
            sys.exit(1)
        try:
            video_id = json.loads(data)['list'][0]['id']
        except IndexError:
            print("Invalid episode number{0}, or video not found, skipping...".format(episode))
            continue

        video = "https://www.dailymotion.com/video/{0}".format(video_id)
        try:
            dailymotion.dailymotion_download(video, output_dir=output)
        except KeyboardInterrupt:
            sys.stderr.write('\nExiting...\n')
            sys.exit(1)


def main():
    """ Main function """
    parser = argparse.ArgumentParser()
    parser.add_argument('-s', '--start', help="start sequence", required=True, type=int)
    parser.add_argument('-e', '--end', help="end sequence", required=True, type=int)
    parser.add_argument('-o', '--output', help="output directory", required=False, default='.')
    parser.add_argument('-u', '--user', help="dailymotion user", required=True)
    argcomplete.autocomplete(parser)
    args = parser.parse_args()
    get_videos(int(args.start), int(args.end), args.output, args.user)

if __name__ == "__main__":
    main()
