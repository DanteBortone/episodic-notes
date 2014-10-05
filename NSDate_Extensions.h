/*
 
 Episodic Notes: A personal wiki, note taking app for Mac OSX. Create notes through any application on your computer and keep them in one place.
 
 Copyright (C) 2014. Dante Bortone
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 */


//---------------------------------------------
#import <Cocoa/Cocoa.h>
//---------------------------------------------


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
