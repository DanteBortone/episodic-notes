//
//  NSDate_Extensions.h
//  NoteTaker
//
//  Created by Dante Bortone with Copyright on 8/11/12.
//  Copyright 2012 UNC-Chapel Hill. All rights reserved.
//


#import <Cocoa/Cocoa.h>


@interface NSDate (DBExtensions) 


- (NSDate *) startOfDay;
- (NSDate *) startOfNextDay;
- (NSDate *) startOfMonth;
- (NSDate *) startOfNextMonth;

//Date Comparisons
- (BOOL) sameDateAs:(NSDate *)matchDate;
- (BOOL) sameMonthAs:(NSDate *)matchDate;

//-(BOOL)sameMonthAs:(NSDate *)matchDate;

// from https://github.com/erica/NSDate-Extensions/blob/master/NSDate-Utilities.m
- (BOOL) isToday;
- (BOOL) isEqualToDateIgnoringTime: (NSDate *) aDate;
- (BOOL) isSameYearAsDate: (NSDate *) aDate;

// Date Maths
- (NSDate *) addDay;
- (NSDate *) addDays:(int)numberOfDays;

- (NSDate *) subtractDay;
- (NSDate *) subtractDays:(int)numberOfDays;

- (NSDate *) addMonth;
- (NSDate *) addMonths:(int)numberOfMonths;

- (NSDate *) subtractMonth;
- (NSDate *) subtractMonths:(int)numberOfMonths;

- (NSDate *) addYear;
- (NSDate *) addYears:(int)numberOfYears;

- (NSDate *) subtractYear;
- (NSDate *) subtractYears:(int)numberOfYears;


- (NSString *) dayToString;
- (NSString *) monthToString;
- (NSString *) yearToString;
- (NSString *) longDateToString;
- (NSString *) fullDateToString;
- (NSString *) contextString;
- (NSString *) topicString;

@end
