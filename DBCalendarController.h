/*
 
 Episodic Notes: A personal wiki, note taking app for Mac OSX. Create notes through any application on your computer and keep them in one place.
 
 Copyright (C) 2014. Dante Bortone
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 */


//---------------------------------------------
#import "DBObjectController.h"
//---------------------------------------------

@class DBDateTopic;
@class DBControllerOfOutlineViews;
@class DBTopicObject;
@class BWSplitView;

//---------------------------------------------


@interface DBCalendarController : DBObjectController {

  DBControllerOfOutlineViews * controllerOfOutlineViews;
  
}

@property (strong) NSDate *calendarMonth;
@property (strong) NSMutableArray *calendarDayLabels;
@property (strong) IBOutlet NSTextField *monthYearLabel;
@property (strong) IBOutlet NSTextField *longDateLabel;

//@property (strong) IBOutlet BWSplitView * calendarSplitView;

@property (strong) IBOutlet NSButton *calendarGrid00, *calendarGrid01, *calendarGrid02, *calendarGrid03, *calendarGrid04, *calendarGrid05, *calendarGrid06;
@property (strong) IBOutlet NSButton *calendarGrid07, *calendarGrid08, *calendarGrid09, *calendarGrid10, *calendarGrid11, *calendarGrid12, *calendarGrid13;
@property (strong) IBOutlet NSButton *calendarGrid14, *calendarGrid15, *calendarGrid16, *calendarGrid17, *calendarGrid18, *calendarGrid19, *calendarGrid20;
@property (strong) IBOutlet NSButton *calendarGrid21, *calendarGrid22, *calendarGrid23, *calendarGrid24, *calendarGrid25, *calendarGrid26, *calendarGrid27;
@property (strong) IBOutlet NSButton *calendarGrid28, *calendarGrid29, *calendarGrid30, *calendarGrid31, *calendarGrid32, *calendarGrid33, *calendarGrid34;
@property (strong) IBOutlet NSButton *calendarGrid35, *calendarGrid36, *calendarGrid37, *calendarGrid38, *calendarGrid39, *calendarGrid40, *calendarGrid41;


#pragma mark -
#pragma mark Complex Calendar Formating

- (void)colorOtherMonthDaysGray;
- (void)selectMonth:(NSDate *)selectedDate;
- (void)selectDay:(NSDate *)givenDate;
- (void)markDatesWithEntries;
- (void)updateAllCalendarElements;
- (void)updateCalendarDayNumbers;
- (void)labelTodaysDate;
- (void)labelSelectedDate;
- (void)labelDatesLoadedInViews;
- (void)deselectIfDateTopic:(DBTopicObject *)topicObject;

- (void)assignDateTopicFromDate: (NSDate *) date throughLink:(BOOL) throughLink;

#pragma mark -
#pragma mark Calculations
- (void) cleanUpEmptyDate:(NSDate *) previousDate;
- (DBDateTopic *) topicAtDate:(NSDate *)givenDate;
- (id)calendarStartDate:(NSDate *)givenDate;
- (BOOL)isDateOnCurrentCalendar:(NSDate *)gridStart;
- (int)calendarGridNumber:(NSDate *)givenDate;
- (int)gridPosition:(NSDate *)gridStart forDate:(NSDate *)findDate;


#pragma mark -
#pragma mark Basic Calendar Formats

- (void)colorTodaysDate:(NSButton *)dateButton;
- (void)selectDate:(NSButton *)dateButton;
- (void)deselectDate:(NSButton *)dateButton;
- (void)colorOtherMonthDates:(NSButton *)dateButton;
- (void)resetCalendarGridColor:(NSButton *)dateButton;
- (void)colorDateWithEntry:(NSButton *)dateButton;
- (void)colorDateWithNoEntry:(NSButton *)dateButton;

- (void) testing;

#pragma mark -
#pragma mark Calendar Buttons

- (IBAction)daySelected:(id)sender; //used by all day buttons on calendar
- (IBAction)selectTodaysDate:(id)sender;
- (IBAction)nextMonth:(id)sender;
- (IBAction)lastMonth:(id)sender;

@end
