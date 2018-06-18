library(ISOweek) 
#for iso calendar week operations
#for more examples about ISOweek see https://cran.r-project.org/web/packages/ISOweek/

# Auxilialy functions for week operations
WeekStr2Num <- function(week){
  c<-unlist(strsplit(week, "-"));
  num.year <- as.numeric(c[1]);
  num.week <- as.numeric(c[2]);
  return(c(num.year, num.week));
}

convWeekStr2ISOweek <- function(weekStr){
  if (nchar(weekStr) == 7){
    w <- gsub('^(.{5})(.*)$', '\\1W\\2', weekStr);
  }
  else{
    w <- gsub('^(.{5})(.*)$', '\\1W0\\2', weekStr);
  }
  return(w)
}

convISOweek2WeekStr <- function(isoweek){
  c<-unlist(strsplit(isoweek, "-W"));
  num.week <- as.numeric(c[2]);
  week <- paste(c[1], as.character(num.week), sep = '-')
  return(week)
}

WeekDifference <- function(week1, week2){ # "2014-10" - "2014-6" = 4
  w1 <- convWeekStr2ISOweek(week1);
  w2 <- convWeekStr2ISOweek(week2);
  w1_d1 <- as.POSIXlt(ISOweek2date(paste(w1, '1', sep = "-")), format="%Y-%m-%d");
  w2_d1 <- as.POSIXlt(ISOweek2date(paste(w2, '1', sep = "-")), format="%Y-%m-%d");
  week_diff <- as.integer(difftime(w1_d1, w2_d1, units = "weeks"));
  return(week_diff)
}

WeekMinus <- function(week, minusweek){ # e.g. "2014-4" - 1 = "2014-3"
  w <- convWeekStr2ISOweek(week);
  w_d1 <- ISOweek2date(paste(w, '1', sep = "-"));
  new_d1 <- w_d1 - minusweek * 7;
  new_w <- ISOweek(new_d1);
  return(convISOweek2WeekStr(new_w))
}

WeekLessEq <- function(week1, week2){
  # compare if week1 is smaller (older) than week2
  input.yearwk1 <-WeekStr2Num(week1);
  input.year1 <- input.yearwk1[1];
  input.week1 <- input.yearwk1[2];
  input.yearwk2 <-WeekStr2Num(week2);
  input.year2 <- input.yearwk2[1];
  input.week2 <- input.yearwk2[2];
  
  if (input.year1 < input.year2){
    return(TRUE)
  }else if (input.year1 > input.year2){
    return(FALSE)
  }else{
    if (input.week1 <= input.week2){
      return(TRUE)
    }else{
      return(FALSE)
    }
  }
}
