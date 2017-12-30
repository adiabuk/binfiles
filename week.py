#!/usr/bin/env python

"""
Print timesheet headers for org-mode by taking in month and year
eg.
./week.py 03 18
** Mar 2018 - ?? days
*** w/e 4/3 - ? days
*** w/e 11/3 - ? days
*** w/e 18/3 - ? days
*** w/e 25/3 - ? days
"""

import sys
import calendar
from datetime import date, timedelta

def allsundays(year, month):
    """Get list of all Sundays"""
    try:
        day = date(year, month, 1)
    except ValueError:
        sys.stderr.write("Invalid date")
        sys.exit(1)
    day += timedelta(days=6 - day.weekday())  # First Sunday
    while day.year == year and day.month == month:
        yield "*** w/e {0}/{1} - ? days".format(day.day, day.month)
        day += timedelta(days=7)

def main():
    """
    Main function - take argruments and format output
    """
    if not len(sys.argv) == 3:
        sys.stderr.write("Usage: {0} <month> <year>\n".format(sys.argv[0]))
        sys.exit(1)

    month = int(sys.argv[1])
    year_str = sys.argv[2]
    year = year_str[0:2]
    if 59 <= int(year) <= 99:
        year = int('19' + year)
    else:
        year = int('20' + year)
    try:
        month_str = calendar.month_name[month][:3]
    except IndexError:
        sys.stderr.write("Invalid Month\n")
        sys.exit(1)

    print("** {0} {1} - ?? days".format(month_str, year))
    for line in allsundays(year, month):
        print(line)

if __name__ == '__main__':
    main()
