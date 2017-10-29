#!/usr/bin/env python

"""
IRC Log parser
Looks up IRC hog history sotred in mysql and returns messages in a given channel
matching a given pattern from a particular time

Message field from database is the only one we care about.  THis contains an
array of elements.  Notably: host, time, and exception details.  We assume that
the order is unchanged and this is currently hardcoded

A dot file called ~/.irclogrc needs to be created with the following variables:
* channel
* handle
* db_host
* from_email
* to_email

where channel is the name of the IRC channel we are searching, handle is the
name of the handle in the message, db_host the the host the database is running
on, and to/from email, are the email addresses we send to and from for each
message we find.

Author: Amro Diab
Email: adiab@hotmail.co.uk
Date: 17/04/2014
"""

import calendar
import csv
import datetime
import smtplib
import subprocess
import os
import re
import sys
import time

import imp

try:
    HOME = os.getenv("HOME")
    CONFIG = imp.load_source('module.name', HOME + '/.irclogrc')
except IOError:
    sys.stderr.write("Unable to load config ~/.irclogrc\n")
    sys.exit(1)
try:
    CHANNEL = CONFIG.channel
    HANDLE = CONFIG.handle
    DB_HOST = CONFIG.db_host
    FROM_EMAIL = CONFIG.from_email
    TO_EMAIL = CONFIG.to_email

except AttributeError:
    sys.stderr.write("Unable to find all attributes in ~/.irclogrc\n")
    sys.exit(2)

HOUR_AGO = str(calendar.timegm(time.gmtime())-3600)
SQL_QUERY = ('select message from irc_log WHERE time > {0} and '
             'channel="#{1}" and message like "{2}:%";'.format(HOUR_AGO,
                                                               CHANNEL,
                                                               HANDLE))

DB_CMD = "echo '%s' | mysql test" % SQL_QUERY

# TODO: use mysql library rather than subprocess
PROCESS = subprocess.Popen(DB_CMD, shell=True, stdout=subprocess.PIPE,
                           stderr=subprocess.STDOUT)

RET_VAL = PROCESS.wait()
ROW_DATA = []
READER = csv.reader(PROCESS.stdout.readlines(), delimiter='|')

for row in READER:
    ROW_DATA.append(row)

SIZE = len(ROW_DATA) -2
ROW_DATA.pop(0)  # Remove first item of the list which contains header
for exception in range(0, len(ROW_DATA)):
    sys.stdout.write("Processing item...\n")
    try:
        alert = ROW_DATA[exception][1].strip()
        host = re.sub(r"\..*\.com", "", ROW_DATA[exception][2])  # remove domain

        # Turn epoch into human readable
        time = datetime.datetime.fromtimestamp(int(ROW_DATA[exception][3]
                                                   .strip())).strftime('%Y-%m-%d %H:%M:%S')
        exception = ROW_DATA[exception][4].strip().decode('unicode_escape')

        SERVER = "localhost"
        FROM = FROM_EMAIL
        TO = TO_EMAIL

        SUBJECT = "Python EXCEPTION %s on %s" %(alert, host)

        TEXT = """
    Alert: %s
    Host: %s
    Time: %s

    Exception:

    %s
    """ %(alert, host, time, exception)

        message = 'Subject: %s\n\n%s' % (SUBJECT, TEXT)

        server = smtplib.SMTP(SERVER)
        sys.stdout.write("Sending email...\n")
        server.sendmail(FROM, TO, message)
        server.quit()
    except IndexError:
        sys.stderr.write("Skipping item: {0}...\n".format(ROW_DATA[exception]))
    # If we encounter an indexerror, it means the number of fields is
    # not as expected, so we simply skip sending the email, and go onto the next
    # message in the for loop.  We will print it to stderr to keep track of what
    # is being skipped, incase we need better handeling of mysql contents
