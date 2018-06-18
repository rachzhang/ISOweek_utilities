from math import floor
from datetime import date, timedelta


def weekLessEq(week1, week2):
    '''argument format: string 'yyyy-ww' ; return week1 < week2 (earlier)'''
    y1, w1 = map(lambda x: int(x), week1.split('-'))
    y2, w2 = map(lambda x: int(x), week2.split('-'))
    if y1 < y2:
        return True
    elif y1 > y2:
        return False
    else:
        if w1 <= w2:
            return True
        else:
            return False

def getFirstLastDayOfWeek(year, week):
    d = date(year, 1, 1)
    if(d.weekday() > 3):
        d = d + timedelta(7 - d.weekday())
    else:
        d = d - timedelta(d.weekday())

    dlt = timedelta(days = (week - 1) * 7)
    return d + dlt,  d + dlt + timedelta(days = 6)

def getMiddleDayOfWeek(year, week):
    d = date(year, 1, 1)
    if(d.weekday() > 3):
        d = d + timedelta(7 - d.weekday())
    else:
        d = d - timedelta(d.weekday())
    dlt = timedelta(days = (week - 1) * 7)
    return d + dlt + timedelta(days = 3)


def weekPlusOne(week):
    #week is a string 'yyyy-w'
    yr, wk = map(int, week.split('-'))
    mid_date = getMiddleDayOfWeek(yr, wk)
    res_date = mid_date + timedelta(days=7)
    isoyear, isoweek, isoday = res_date.isocalendar()
    return str(isoyear) + '-' + str(isoweek)


def weekMinus(week, minusweek):
    #week is a string 'yyyy-w'
    yr, wk = map(int, week.split('-'))
    mid_date = getMiddleDayOfWeek(yr, wk)
    res_date = mid_date - timedelta(days = 7*minusweek)
    isoyear, isoweek, isoday = res_date.isocalendar()
    return str(isoyear) + '-' + str(isoweek)


def week_difference(week1, week2):
    '''argument format: yyyy-ww'''
    if week1 == 'None' :
        return int(-1e6)
    if week2 == 'None' :
        return int(1e6)

    mid_date1 = getMiddleDayOfWeek(*map(int, week1.split('-')))
    mid_date2 = getMiddleDayOfWeek(*map(int, week2.split('-')))
    day_diff = (mid_date1 - mid_date2).days
    return day_diff/7



def weekSubset(weekpair1, weekpair2):
    '''check if week1 is included in week2
    e.g., (2012-32, 2012-40) is a subset of (2012-30, 2012-40)
    arguments formats: (yyyy-ww, yyyy-ww), (yyyy-ww, yyyy-ww)
    '''
    start1 = weekpair1[0]
    end1 = weekpair1[1]
    start2 = weekpair2[0]
    end2 = weekpair2[1]

    return (weekLessEq(start2, start1) and weekLessEq(end1, end2))

def ContinuousWeeks(week_list):
    week_list = sorted(week_list, cmp = week_difference)
    candidates = []
    candidate = []
    for i in xrange(len(week_list)):
        curWeek = week_list[i]
        candidate.append(curWeek)
        if i < len(week_list)-1 and week_list[i+1] == weekPlusOne(curWeek) :
            pass
        else:
            candidates.append(candidate)
            candidate = []

    return candidates

def orderedList2Set(seq):
    '''convert a list to a set preserving order of list'''
    seen = set()
    seen_add = seen.add
    return [ x for x in seq if x not in seen and not seen_add(x)]

def add_month(sdate, months):
    month = sdate.month - 1 + months
    year = int(sdate.year + month / 12)
    month = month % 12 + 1
    day = min(sdate.day, calendar.monthrange(year,month)[1])
    return datetime(year, month, day, 0, 0)

def diff_month(d1, d2):
    return (d1.year - d2.year)*12 + d1.month - d2.month
