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
import youtube_dl

def get_videos(end=100, search='', user=None):
    """
    Fetch videos for a particular user in given episode range
    """

    search = "mile"
    url = 'https://api.dailymotion.com/user/{0}/videos?search={1}&limit={2}'  # user, SEQ
    print(url)
    try:
        print('AMROX' +  url.format(user, search, end))
        data = urllib.request.urlopen(url.format(user, search, end)).read()
    except urllib.error.HTTPError:
        sys.stderr.write('\n404 Error Encountered, check username...\n')
        sys.exit(1)
    video_ids = json.loads(data)['list']
    for  item in video_ids:
        video = "https://www.dailymotion.com/video/{0}".format(item['id'])
        ydl_opts = {}
        try:
            with youtube_dl.YoutubeDL(ydl_opts) as ydl:
                ydl.download([video])

        except KeyboardInterrupt:
            sys.stderr.write('\nExiting...\n')
            sys.exit(1)


def main():
    """ Main function """
    parser = argparse.ArgumentParser()
    parser.add_argument('-s', '--search', help="search string", required=True)
    parser.add_argument('-u', '--user', help="dailymotion user", required=True)
    argcomplete.autocomplete(parser)
    args = parser.parse_args()
    get_videos(user=args.user, search=args.search)

if __name__ == "__main__":
    main()
