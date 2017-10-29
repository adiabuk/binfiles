#!/usr/bin/python


# Notifier example from tutorial
#
# See: http://github.com/seb-m/pyinotify/wiki/Tutorial
#
# odtwatcher.py

import os
import pyinotify
import subprocess

HOME = os.getenv("HOME")
WATCHED_DIR = HOME + '/Downloads'

wm = pyinotify.WatchManager()  # Watch Manager
mask = pyinotify.IN_MODIFY

class EventHandler(pyinotify.ProcessEvent):
    def process_IN_MODIFY(self, event):
        fname = event.pathname
        if os.path.splitext(fname)[1] == '.odt':
            print 'MODIFIED: ', fname
            args = ['unoconv', '-f', 'pdf', fname]
            try:
                subprocess.Popen(args)
            except OSError as e:
                print 'Could not convert file %s to PDF. Error %s' % (fname, str(e))

if __name__ == '__main__':
    handler = EventHandler()
    notifier = pyinotify.Notifier(wm, handler)
    wdd = wm.add_watch(WATCHED_DIR, mask, rec=True)
    notifier.loop()
