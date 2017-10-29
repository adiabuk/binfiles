#!/usr/bin/env python2

"""
Displays current, previous, and next months
calendar for conky
"""

import calendar
import re
import time

MONTHS = [-1, 0, 1]

for month in MONTHS:
    localtime = time.localtime(time.time())
    calendar.setfirstweekday(calendar.MONDAY)
    display_month = localtime[1] + month
    display_year = localtime[0]
    if display_month == 0:
        display_month = 12
        display_year -= 1
    cal = calendar.month(display_year, display_month)
    parts = cal.split('\n')
    cal = '${alignc}${offset -8}' + '\n${offset 37}'.join(parts)

    regex = '(?<= )%s(?= )|(?<=\n)%s(?= )|(?<= )%s(?=\n)' % (
        localtime[2], localtime[2], localtime[2])
    if month == 0:
        replace = '${color1}%s${color2}' % localtime[2]
        newCal = re.sub(regex, replace, cal)
    else:
        newCal = cal
    print newCal
