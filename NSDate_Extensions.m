/*
 
 Episodic Notes: A personal wiki, note taking app for Mac OSX. Create notes through any application on your computer and keep them in one place.
 
 Copyright (C) 2014. Dante Bortone
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 */


//---------------------------------------------
#import "NSDate_Extensions.h"
//---------------------------------------------


#define DATE_COMPONENTS (NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit)
#define CURRENT_CALENDAR [NSCalendar currentCalendar]

@implementation NSDate (DBExtensions)


// -------------------------------------------------------------------------------

//  startOfDay

// -------------------------------------------------------------------------------

// Returns year month and day of NSDate.  Time is set to midnight.

-(NSDate *)startOfDay {
  
  NSDateComponents *comp;
  NSCalendar *cal;
  NSDate *returnDate;
  
  cal = [NSCalendar currentCalendar];
  comp = [[NSDateComponents alloc] init];
  returnDate = [[NSDate alloc] init];
  
	comp = [cal components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:self];
	returnDate = [cal dateFromComponents:comp];
  
  
  return returnDate;
}

// -------------------------------------------------------------------------------

//  startOfNextDay

// -------------------------------------------------------------------------------

// Returns year month and day of day after NSDate.  Time is set to midnight.

-(NSDate *)startOfNextDay {
  
  NSDateComponents *oneDay;
  NSDateComponents *comp;
  NSCalendar *cal;
  NSDate *returnDate;
  
  oneDay = [[NSDateComponents alloc] init];
  cal = [NSCalendar currentCalendar];
  comp = [[NSDateComponents alloc] init];
  returnDate = [[NSDate alloc] init];
  
  oneDay.day = 1;
	comp = [cal components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:self];
	returnDate = [cal dateFromComponents:comp];
  returnDate = [cal dateByAddingComponents:oneDay toDate:returnDate options:0];

  
  return returnDate;
}

// -------------------------------------------------------------------------------

//  startOfMonth

// -------------------------------------------------------------------------------

// Returns year and month of NSDate.  Time is set to midnight of first day of month.

-(NSDate *)startOfMonth {
  
  NSDateComponents *comp;
  NSCalendar *cal;
  NSDate *returnDate;
  
  cal = [NSCalendar currentCalendar];
  comp = [[NSDateComponents alloc] init];
  returnDate = [[NSDate alloc] init];
  
	comp = [cal components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:self];
  [comp setDay:1];  
	returnDate = [cal dateFromComponents:comp];
  
  
  return returnDate;
}

// -------------------------------------------------------------------------------

//  startOfNextMonth

// -------------------------------------------------------------------------------

// Returns year and month of NSDate.  Time is set to midnight of first day of month.

-(NSDate *)startOfNextMonth {
  
  NSDateComponents *comp;
  NSCalendar *cal;
  NSDate *returnDate;
  NSDateComponents *oneMonth;

  cal = [NSCalendar currentCalendar];
  comp = [[NSDateComponents alloc] init];
  returnDate = [[NSDate alloc] init];
  oneMonth = [[NSDateComponents alloc] init];

	comp = [cal components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:self];
  [comp setDay:1];  
	returnDate = [cal dateFromComponents:comp];
  oneMonth.month = 1;

  returnDate = [cal dateByAddingComponents:oneMonth toDate:returnDate options:0];
  
  
  return returnDate;
}

#pragma mark -
#pragma mark Date Comparisons


// -------------------------------------------------------------------------------

//  sameDateAs:matchDate

// -------------------------------------------------------------------------------

-(BOOL)sameDateAs:(NSDate *)matchDate{
  
  NSDate * startOfDay;
  NSDate * startOfNextDay;
  NSComparisonResult compareToStartOfDay;
  NSComparisonResult compareToStartOfNextDay;
  
  startOfDay = [self startOfDay]; 
  startOfNextDay = [self startOfNextDay];
  
  compareToStartOfDay = [matchDate compare:startOfDay];
  compareToStartOfNextDay = [matchDate compare:startOfNextDay];
  

  return ((compareToStartOfDay == NSOrderedSame || 
           compareToStartOfDay == NSOrderedDescending) && 
          (compareToStartOfNextDay == NSOrderedAscending));
  
}

// -------------------------------------------------------------------------------

//  sameMonthAs:matchDate

// -------------------------------------------------------------------------------

//  Finds if matchDate is in the same month of the same year

-(BOOL)sameMonthAs:(NSDate *)matchDate{
  
  NSDate * startOfMonth;
  NSDate * startOfNextMonth;
  NSComparisonResult compareToStartOfMonth;
  NSComparisonResult compareToStartOfNextMonth;
  
  startOfMonth = [self startOfMonth]; 
  startOfNextMonth = [self startOfNextMonth];
  
  compareToStartOfMonth = [matchDate compare:startOfMonth];
  compareToStartOfNextMonth = [matchDate compare:startOfNextMonth];
  
  
  return ((compareToStartOfMonth == NSOrderedSame || 
           compareToStartOfMonth == NSOrderedDescending) && 
          (compareToStartOfNextMonth == NSOrderedAscending));
}

#pragma mark -
#pragma mark Date Maths

// -------------------------------------------------------------------------------

//  addDay

// -------------------------------------------------------------------------------

-(NSDate *)addDay {

  NSCalendar *cal;
	NSDateComponents *oneDay;
  NSDate *returnDate;

  cal = [NSCalendar currentCalendar];
  oneDay = [[NSDateComponents alloc] init];
  returnDate = [[NSDate alloc] init];

  oneDay.day = 1;

  returnDate = [cal dateByAddingComponents:oneDay toDate:self options:0];

  
  return returnDate;
}



// -------------------------------------------------------------------------------

//  addDays:numberOfDays

// -------------------------------------------------------------------------------

-(NSDate *)addDays:(int)numberOfDays {
  
  NSCalendar *cal;
	NSDateComponents *days;
  NSDate *returnDate;
  
  cal = [NSCalendar currentCalendar];
  days = [[NSDateComponents alloc] init];
  returnDate = [[NSDate alloc] init];
  
  days.day = numberOfDays;
  
  returnDate = [cal dateByAddingComponents:days toDate:self options:0];
  
  
  return returnDate;
}

// -------------------------------------------------------------------------------

//  subtractDay

// -------------------------------------------------------------------------------

-(NSDate *)subtractDay {
  
  NSCalendar *cal;
	NSDateComponents *oneDay;
  NSDate *returnDate;
  
  cal = [NSCalendar currentCalendar];
  oneDay = [[NSDateComponents alloc] init];
  returnDate = [[NSDate alloc] init];
  
  oneDay.day = -1;
  
  returnDate = [cal dateByAddingComponents:oneDay toDate:self options:0];
  
  
  return returnDate;
}

// -------------------------------------------------------------------------------

//  subtractDays:numberOfDays

// -------------------------------------------------------------------------------

-(NSDate *)subtractDays:(int)numberOfDays {
  
  NSCalendar *cal;
	NSDateComponents *days;
  NSDate *returnDate;
  
  cal = [NSCalendar currentCalendar];
  days = [[NSDateComponents alloc] init];
  returnDate = [[NSDate alloc] init];
  
  days.day = -1 * numberOfDays;
  
  returnDate = [cal dateByAddingComponents:days toDate:self options:0];
  
  
  return returnDate;
}

// -------------------------------------------------------------------------------

//  addMonth

// -------------------------------------------------------------------------------

-(NSDate *)addMonth {
  
  NSCalendar *cal;
	NSDateComponents *oneMonth;
  NSDate *returnDate;
  
  cal = [NSCalendar currentCalendar];
  oneMonth = [[NSDateComponents alloc] init];
  returnDate = [[NSDate alloc] init];
  
  oneMonth.month = 1;
  
  returnDate = [cal dateByAddingComponents:oneMonth toDate:self options:0];
  
  
  return returnDate;
}


// -------------------------------------------------------------------------------

//  addMonths:numberOfMonths

// -------------------------------------------------------------------------------

-(NSDate *)addMonths:(int)numberOfMonths {
  
  NSCalendar *cal;
	NSDateComponents *months;
  NSDate *returnDate;
  
  cal = [NSCalendar currentCalendar];
  months = [[NSDateComponents alloc] init];
  returnDate = [[NSDate alloc] init];
  
  months.month = numberOfMonths;
  
  returnDate = [cal dateByAddingComponents:months toDate:self options:0];
  
  
  return returnDate;
}

// -------------------------------------------------------------------------------

//  subtractMonth

// -------------------------------------------------------------------------------

-(NSDate *)subtractMonth {
  
  NSCalendar *cal;
	NSDateComponents *oneMonth;
  NSDate *returnDate;
  
  cal = [NSCalendar currentCalendar];
  oneMonth = [[NSDateComponents alloc] init];
  returnDate = [[NSDate alloc] init];
  
  oneMonth.month = -1;
  
  returnDate = [cal dateByAddingComponents:oneMonth toDate:self options:0];
  
  
  return returnDate;
}


// -------------------------------------------------------------------------------

//  subtractMonths:numberOfMonths

// -------------------------------------------------------------------------------

-(NSDate *)subtractMonths:(int)numberOfMonths {
  
  NSCalendar *cal;
	NSDateComponents *months;
  NSDate *returnDate;
  
  cal = [NSCalendar currentCalendar];
  months = [[NSDateComponents alloc] init];
  returnDate = [[NSDate alloc] init];
  
  months.month = -1 * numberOfMonths;
  
  returnDate = [cal dateByAddingComponents:months toDate:self options:0];
  
  
  return returnDate;
}

// -------------------------------------------------------------------------------

//  addYear

// -------------------------------------------------------------------------------

-(NSDate *)addYear {
  
  NSCalendar *cal;
	NSDateComponents *oneYear;
  NSDate *returnDate;
  
  cal = [NSCalendar currentCalendar];
  oneYear = [[NSDateComponents alloc] init];
  returnDate = [[NSDate alloc] init];
  
  oneYear.year = 1;
  
  returnDate = [cal dateByAddingComponents:oneYear toDate:self options:0];
  
  
  return returnDate;
}


// -------------------------------------------------------------------------------

//  addYears:numberOfYears

// -------------------------------------------------------------------------------

-(NSDate *)addYears:(int)numberOfYears {
  
  NSCalendar *cal;
	NSDateComponents *years;
  NSDate *returnDate;
  
  cal = [NSCalendar currentCalendar];
  years = [[NSDateComponents alloc] init];
  returnDate = [[NSDate alloc] init];
  
  years.year = numberOfYears;
  
  returnDate = [cal dateByAddingComponents:years toDate:self options:0];
  
  
  return returnDate;
}

// -------------------------------------------------------------------------------

//  subtractYear

// -------------------------------------------------------------------------------

-(NSDate *)subtractYear {
  
  NSCalendar *cal;
	NSDateComponents *oneYear;
  NSDate *returnDate;
  
  cal = [NSCalendar currentCalendar];
  oneYear = [[NSDateComponents alloc] init];
  returnDate = [[NSDate alloc] init];
  
  oneYear.year = -1;
  
  returnDate = [cal dateByAddingComponents:oneYear toDate:self options:0];
  
  
  return returnDate;
}


// -------------------------------------------------------------------------------

//  subtractYears:numberOfYears

// -------------------------------------------------------------------------------

-(NSDate *)subtractYears:(int)numberOfYears {
  
  NSCalendar *cal;
	NSDateComponents *years;
  NSDate *returnDate;
  
  cal = [NSCalendar currentCalendar];
  years = [[NSDateComponents alloc] init];
  returnDate = [[NSDate alloc] init];
  
  years.year = -1 * numberOfYears;
  
  returnDate = [cal dateByAddingComponents:years toDate:self options:0];
  
  
  return returnDate;
}

// -------------------------------------------------------------------------------

//  dayToString:givenDate

// -------------------------------------------------------------------------------

- (NSString *)dayToString {
  
  NSDateFormatter *dayFormat;
  dayFormat = [[NSDateFormatter alloc] init];
  
  [dayFormat setDateFormat:@"d"];
  
	return [dayFormat stringFromDate:self];
  
}

// -------------------------------------------------------------------------------

//  monthToString:givenDate

// -------------------------------------------------------------------------------

- (NSString *)monthToString {
  
  NSDateFormatter *monthFormat;
  monthFormat = [[NSDateFormatter alloc] init];
  
  [monthFormat setDateFormat:@"MMMM"];
  
	return [monthFormat stringFromDate:self];
  
}

// -------------------------------------------------------------------------------

//  yearToString:givenDate

// -------------------------------------------------------------------------------

- (NSString *)yearToString {
  
  NSDateFormatter *yearFormat;
  yearFormat = [[NSDateFormatter alloc] init];
  
  [yearFormat setDateFormat:@"yyyy"];
  
	return [yearFormat stringFromDate:self];
  
}

// -------------------------------------------------------------------------------

//  longDateToString:givenDate

// -------------------------------------------------------------------------------

- (NSString *)longDateToString {
  
  NSDateFormatter *longDateFormat;
  longDateFormat = [[NSDateFormatter alloc] init];
  
  [longDateFormat setDateFormat:@"EEEE, MMMM d, yyyy"];
  
	return [longDateFormat stringFromDate:self];
  
}



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (NSString *)fullDateToString {
  
  NSDateFormatter *fullDateFormat;
  fullDateFormat = [[NSDateFormatter alloc] init];
  
  [fullDateFormat setDateFormat:@"EEEE, MMMM d, yyyy hh:mm:ss"];
  
	return [fullDateFormat stringFromDate:self];
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (NSString *) contextString {
  
  NSDateFormatter *contextFormat;
  contextFormat = [[NSDateFormatter alloc] init];
  
  [contextFormat setDateFormat:@"yyyyMMdd"];
  
	return [contextFormat stringFromDate:self];
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (NSString *) topicString {
  NSDateFormatter *contextFormat;
  contextFormat = [[NSDateFormatter alloc] init];
  
  [contextFormat setDateFormat:@"M/d/yy"];
  
	return [contextFormat stringFromDate:self];
  
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (BOOL) isToday {
  
  return [self isEqualToDateIgnoringTime:[NSDate date]];
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (BOOL) isEqualToDateIgnoringTime: (NSDate *) aDate
{
  NSDateComponents *components1 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
  NSDateComponents *components2 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:aDate];
  return ((components1.year == components2.year) &&
          (components1.month == components2.month) &&
          (components1.day == components2.day));
}



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (BOOL) isSameYearAsDate: (NSDate *) aDate
{
  NSDateComponents *components1 = [CURRENT_CALENDAR components:NSYearCalendarUnit fromDate:self];
  NSDateComponents *components2 = [CURRENT_CALENDAR components:NSYearCalendarUnit fromDate:aDate];
  return (components1.year == components2.year);
}

@end
