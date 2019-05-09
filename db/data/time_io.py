import time
from datetime import timedelta, datetime
from random import randint

def random_date(start, end=None, format='%Y-%m-%d'):
    """
    Returns a random date between start and end (included)
    in the given format.
    If no end date is given, today's date is used.
    Default format: 'YYYY-mm-dd'
    """
    start_epoch = int(time.mktime(time.strptime(start, format)))
    if end:
        end_epoch = int(time.mktime(time.strptime(end, format)))
    else:
        end_epoch = int(time.time())
    
    rand_epoch = randint(start_epoch, end_epoch)
    return time.strftime(format, time.localtime(rand_epoch))

def add_duration(start, yrs=1, months=0, format='%Y-%m-%d'):
    """
    Adds the given duration to the given date in a given format.
    Returns the end date in the same format.
    """
    start_date = datetime.strptime(start, format)
    months += yrs * 12
    days = months * 30
    end_date = start_date + timedelta(days=days)
    return end_date.strftime(format)

def add_random_duration(start, range_yrs=(0,10), range_months=(0,12), format='%Y-%m-%d'):
    """
    Adds a random duration to the given date in a given format.
    The added duration is less than the maximum duration.
    Returns the end date in the same format.
    """
    start_date = datetime.strptime(start, format)
    yrs = randint(range_yrs[0], range_yrs[1])
    mths = randint(range_months[0], range_months[1]) + (yrs * 12)
    days = mths * 30
    end_date = start_date + timedelta(days=days)
    return end_date.strftime(format)