//
//  DBCalendarController.m
//  NoteTaker
//
//  Created by Dante Bortone with Copyright on 8/17/12.
//  Copyright 2012 UNC-Chapel Hill. All rights reserved.
//


//---------------------------------------------
#import "DBCalendarController.h"
//---------------------------------------------
#import "DBControllerOfOutlineViews.h"
#import "DBDateTopic.h"
#import "DBDetailController.h"
#import "DBDetailOutlineViewController.h"
#import "DBDetailOutlineViewDelegate.h"
#import "DBDetailViewController.h"
#import "DBDetailViewController.h"
#import "DBOutlineViewDelegate.h"
#import "DBTopicFolderView.h"
#import "DBTopicObject.h"
#import "DBViewObject.h"
#import "NoteTaker_AppDelegate.h"
#import "NSButton_Extensions.h"
#import "NSDate_Extensions.h"
#import "NSString_Extensions.h"
#import "BWSplitView.h"

#define CALENDAR_BUTTON_IMAGE @"today.pdf"
#define NUMBER_OF_CALENDAR_DAYS 42
#pragma mark -


@implementation DBCalendarController

#pragma mark -

@synthesize calendarMonth;//keeps track of what month calendar is on
@synthesize calendarDayLabels;
@synthesize longDateLabel;
@synthesize monthYearLabel;
//@synthesize calendarSplitView;

@synthesize calendarGrid00,calendarGrid01,calendarGrid02,calendarGrid03,calendarGrid04,calendarGrid05,calendarGrid06;
@synthesize calendarGrid07,calendarGrid08,calendarGrid09,calendarGrid10,calendarGrid11,calendarGrid12,calendarGrid13;
@synthesize calendarGrid14,calendarGrid15,calendarGrid16,calendarGrid17,calendarGrid18,calendarGrid19,calendarGrid20;
@synthesize calendarGrid21,calendarGrid22,calendarGrid23,calendarGrid24,calendarGrid25,calendarGrid26,calendarGrid27;
@synthesize calendarGrid28,calendarGrid29,calendarGrid30,calendarGrid31,calendarGrid32,calendarGrid33,calendarGrid34;
@synthesize calendarGrid35,calendarGrid36,calendarGrid37,calendarGrid38,calendarGrid39,calendarGrid40,calendarGrid41;

#pragma mark -

// -------------------------------------------------------------------------------

//  awakeFromNib

// -------------------------------------------------------------------------------

- (void)awakeFromNib {	 

  [super awakeFromNib];
  //appDelegate = (NoteTaker_AppDelegate *)[[NSApplication sharedApplication] delegate];
  controllerOfOutlineViews = appDelegate.controllerOfOutlineViews;
  
  calendarMonth = [[NSDate date] startOfDay];
  
//assign calendar buttons to an array so I can access them dynamically later
  calendarDayLabels = [NSMutableArray arrayWithCapacity:(NUMBER_OF_CALENDAR_DAYS-1)];
  [calendarDayLabels addObject:calendarGrid00];[calendarDayLabels addObject:calendarGrid01];[calendarDayLabels addObject:calendarGrid02];
  [calendarDayLabels addObject:calendarGrid03];[calendarDayLabels addObject:calendarGrid04];[calendarDayLabels addObject:calendarGrid05];
  [calendarDayLabels addObject:calendarGrid06];[calendarDayLabels addObject:calendarGrid07];[calendarDayLabels addObject:calendarGrid08];
  [calendarDayLabels addObject:calendarGrid09];[calendarDayLabels addObject:calendarGrid10];[calendarDayLabels addObject:calendarGrid11];
  [calendarDayLabels addObject:calendarGrid12];[calendarDayLabels addObject:calendarGrid13];[calendarDayLabels addObject:calendarGrid14];
  [calendarDayLabels addObject:calendarGrid15];[calendarDayLabels addObject:calendarGrid16];[calendarDayLabels addObject:calendarGrid17];
  [calendarDayLabels addObject:calendarGrid18];[calendarDayLabels addObject:calendarGrid19];[calendarDayLabels addObject:calendarGrid20];
  [calendarDayLabels addObject:calendarGrid21];[calendarDayLabels addObject:calendarGrid22];[calendarDayLabels addObject:calendarGrid23];
  [calendarDayLabels addObject:calendarGrid24];[calendarDayLabels addObject:calendarGrid25];[calendarDayLabels addObject:calendarGrid26];
  [calendarDayLabels addObject:calendarGrid27];[calendarDayLabels addObject:calendarGrid28];[calendarDayLabels addObject:calendarGrid29];
  [calendarDayLabels addObject:calendarGrid30];[calendarDayLabels addObject:calendarGrid31];[calendarDayLabels addObject:calendarGrid32];
  [calendarDayLabels addObject:calendarGrid33];[calendarDayLabels addObject:calendarGrid34];[calendarDayLabels addObject:calendarGrid35];
  [calendarDayLabels addObject:calendarGrid36];[calendarDayLabels addObject:calendarGrid37];[calendarDayLabels addObject:calendarGrid38];
  [calendarDayLabels addObject:calendarGrid39];[calendarDayLabels addObject:calendarGrid40];[calendarDayLabels addObject:calendarGrid41];


  
}	 

#pragma mark -
#pragma mark Complex Calendar Formating

// -------------------------------------------------------------------------------

//  resetCalendarColors

// -------------------------------------------------------------------------------

- (void)resetCalendarColors {
	int i;
	for (i=0;i<NUMBER_OF_CALENDAR_DAYS;++i){
		[self resetCalendarGridColor:[calendarDayLabels objectAtIndex:i]];
	}
}

// -------------------------------------------------------------------------------

//  markDatesWithEntries

// -------------------------------------------------------------------------------

- (void)markDatesWithEntries {
  //NSLog(@"marked dates with entries");
  //to do with topics:
  //make array of dates from fetchedpredicate
  //then for each date convert it to a grid number (gridPosition:forDate) and mark the calendar
  
  NSDate * dateOfCalendarsFirstGrid = [self calendarStartDate:calendarMonth];
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  NSPredicate *fetchedPredicate = [NSPredicate predicateWithFormat:@"date >= %@ && date < %@", dateOfCalendarsFirstGrid,
                                   [dateOfCalendarsFirstGrid addDays:NUMBER_OF_CALENDAR_DAYS]];
  
  NSEntityDescription *entity = [NSEntityDescription entityForName:@"DateTopic" inManagedObjectContext:[appDelegate managedObjectContext]];
  
  [fetchRequest setPredicate:fetchedPredicate];
  [fetchRequest setEntity:entity];
  
  NSError *error;
  NSArray *daysWithEntries = [[appDelegate managedObjectContext] executeFetchRequest:fetchRequest error:&error];
  int gridNumber;
  
  
  
  //unbold all entries first
  
  for (NSButton * dayButton in calendarDayLabels){
    
    [dayButton unmakeTextBold];
    
  }
  
  
  for (DBDateTopic * day in daysWithEntries) {
    
    if (day.details.count>0) {
      
      gridNumber = [self gridPosition:dateOfCalendarsFirstGrid forDate:day.date];
      [self colorDateWithEntry:[calendarDayLabels objectAtIndex:gridNumber]];
    }
  }

}


// -------------------------------------------------------------------------------

//  colorOtherMonthDaysGray

// -------------------------------------------------------------------------------

- (void)colorOtherMonthDaysGray {

  //rightmost day has to be in same month, so check next one over first
  NSDate *checkAgainstDate = [[self calendarStartDate:calendarMonth] addDays:5];
  
  // check days at begining of month
  int i;
  for (i=5; i>=0; --i){
    
    if([calendarMonth sameMonthAs:checkAgainstDate] == NO){
      [self colorOtherMonthDates:[calendarDayLabels objectAtIndex:i]];			
      
      checkAgainstDate = [checkAgainstDate subtractDay];
      i = i-1;
      while (i>=0){ //don't need to keep calling 'sameMonth' when before this can't be
        [self colorOtherMonthDates:[calendarDayLabels objectAtIndex:i]];			
        checkAgainstDate = [checkAgainstDate subtractDay];
        i=i-1;
      }
    }
    else {
      checkAgainstDate = [checkAgainstDate subtractDay];
    }
  }
  
  //check days at end of month
  checkAgainstDate = [[self calendarStartDate:calendarMonth] addDays:28];
  int j;
  for (j=28; j<=(NUMBER_OF_CALENDAR_DAYS-1); ++j){
    if([calendarMonth sameMonthAs:checkAgainstDate] == NO){
			
      [self colorOtherMonthDates:[calendarDayLabels objectAtIndex:j]];			
      checkAgainstDate = [checkAgainstDate addDay];
      j = j+1;

      while (j<=(NUMBER_OF_CALENDAR_DAYS-1)){ //don't need to keep calling 'sameMonth' when days after this can't be
        [self colorOtherMonthDates:[calendarDayLabels objectAtIndex:j]];			
        checkAgainstDate = [checkAgainstDate addDay];
        j=j+1;
      }
      
    }
    else {

      checkAgainstDate = [checkAgainstDate addDay];

    }
  } //foor loop
} //colorOtherMonthDaysGray



// -------------------------------------------------------------------------------

//  selectMonth:selectedDate

// -------------------------------------------------------------------------------

- (void)selectMonth:(NSDate *)selectedDate {
  //NSLog(@"seelct day");
  
  // DBDateTopic * dateTopic;
  //DBDetailOutlineViewController * activeDetailOutlineViewController;
  
  //activeDetailOutlineViewController = controllerOfOutlineViews.activeDetailOutlineViewController;
  
  //if it's a different month, change calendarMonth and update everything
  if([selectedDate sameMonthAs:calendarMonth] == NO){
    
    calendarMonth = selectedDate;
    [self updateAllCalendarElements];
    
  }
  
}



// -------------------------------------------------------------------------------

//  selectDay:selectedDate

// -------------------------------------------------------------------------------

- (void)selectDay:(NSDate *)selectedDate {
  //NSLog(@"seelct day");
  
 // DBDateTopic * dateTopic;
  //DBDetailOutlineViewController * activeDetailOutlineViewController;
  
  //activeDetailOutlineViewController = controllerOfOutlineViews.activeDetailOutlineViewController;

  //if it's a different month, change calendarMonth and update everything
  if([selectedDate sameMonthAs:calendarMonth] == NO){  

    calendarMonth = selectedDate;
    [self updateAllCalendarElements];

  } 

  [ self assignDateTopicFromDate:selectedDate throughLink: NO];
  
}


// -------------------------------------------------------------------------------

//  assignDateTopicFromDate: throughLink

// -------------------------------------------------------------------------------

-(void)assignDateTopicFromDate: (NSDate *) date throughLink:(BOOL) throughLink
{
  
  DBDateTopic * dateTopic = [self topicAtDate:date];
  
  if ( dateTopic == NULL ) {
    
    dateTopic = [appDelegate.detailController newDateTopicAtDate:date ];
    
  }
  
  DBDetailOutlineViewController * detailOutlineViewController;
  
  if (!throughLink) {
    
    detailOutlineViewController = controllerOfOutlineViews.activeDetailOutlineViewController;
    
  } else {

    detailOutlineViewController = [controllerOfOutlineViews targetViewControllerForLinks];
    
  }
  
  [[detailOutlineViewController mainDetailViewController] assignTopic:dateTopic];
  
}


// -------------------------------------------------------------------------------

//  updateAllCalendarElements

// -------------------------------------------------------------------------------

- (void)updateAllCalendarElements {	

  [self updateCalendarDayNumbers];
  [self resetCalendarColors];
  [self colorOtherMonthDaysGray];
  [self markDatesWithEntries];
  [self labelTodaysDate];
  //[self labelSelectedDate];
  [self labelDatesLoadedInViews];
  [monthYearLabel setStringValue: [NSString stringWithFormat:@"%@ %@", 
                                   [calendarMonth monthToString], 
                                   [calendarMonth yearToString]]];
  
}


// -------------------------------------------------------------------------------

//  updateCalendarDays

// -------------------------------------------------------------------------------

- (void)updateCalendarDayNumbers {

  NSDate *gridDateSetter;
    
  NSDate * dateOfCalendarsFirstGrid = [self calendarStartDate:calendarMonth];
  gridDateSetter = dateOfCalendarsFirstGrid;

  for (int i = 0; i < NUMBER_OF_CALENDAR_DAYS; ++i){
    [[calendarDayLabels objectAtIndex:i] setTitle: [ gridDateSetter dayToString ]]; 
    gridDateSetter = [gridDateSetter addDay];
  }	
  
	
}



// -------------------------------------------------------------------------------

//  labelTodaysDate

// -------------------------------------------------------------------------------

- (void)labelTodaysDate {

  int positionOnGrid;
  
  if ([self isDateOnCurrentCalendar:[NSDate date]]){
    positionOnGrid = [self calendarGridNumber:[NSDate date]];
    [self colorTodaysDate:[calendarDayLabels objectAtIndex:positionOnGrid]];
  }

}

// -------------------------------------------------------------------------------

//  labelSelectedDate

// -------------------------------------------------------------------------------

- (void)labelSelectedDate {

  NSDate * thisDate;
  DBTopicObject * viewTopic;
  int positionOnGrid;
  
  for (DBDetailViewController * detailViewController in controllerOfOutlineViews.detailViewControllerArray) {
    
    //problem here
    viewTopic = detailViewController.managedViewObject.viewTopic;
    
    if ([viewTopic isKindOfClass:[DBDateTopic class]]) {
      thisDate = [viewTopic valueForKey: @"date"];
      if ([self isDateOnCurrentCalendar:thisDate]){
        positionOnGrid = [self calendarGridNumber:thisDate];
        [self selectDate:[calendarDayLabels objectAtIndex:positionOnGrid]];
      }
    }
  }
}



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void)labelDatesLoadedInViews {  // does not unlabel the dates already selected

  //NSArray * loadedDates;
  NSDate * thisDate;
  int positionOnGrid;
  
  DBViewObject * viewObject;
  for (DBDetailViewController * detailView in controllerOfOutlineViews.detailViewControllerArray){
    
    viewObject = detailView.managedViewObject;
    if ([viewObject.viewTopic isKindOfClass:[DBDateTopic class]]) {
      thisDate = [viewObject.viewTopic valueForKey: @"date"];
      if ([self isDateOnCurrentCalendar:thisDate]){
        positionOnGrid = [self calendarGridNumber:thisDate];
        [self selectDate:[calendarDayLabels objectAtIndex:positionOnGrid]];
      }
      
    }
    
  }
  
}



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) deselectIfDateTopic:(DBTopicObject *)dateTopic {
  
  if ([dateTopic isKindOfClass:[DBDateTopic class]]) {
    
    NSDate * topicDate;
    int positionOnGrid;

    // if DateTopic doesn't have any views deselect it
    if (dateTopic.views.count == 0) {
      
      //deselect date
      topicDate = [dateTopic valueForKey:@"date"];
      //calendarController = appDelegate.calendarController;
      if ([self isDateOnCurrentCalendar:topicDate]){
        positionOnGrid = [self calendarGridNumber:topicDate];
        [self deselectDate:[self.calendarDayLabels objectAtIndex:positionOnGrid]];
      }
      
      if (dateTopic.details.count == 0){
        
        [appDelegate.managedObjectContext deleteObject:dateTopic];
        
      }
    }
  }
  
  
}

#pragma mark -
#pragma mark Calculations


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) cleanUpEmptyDate:(NSDate *) previousDate{
// whenever outlineView.viewTopic changes
  
  DBDateTopic * dateTopic;
  
  dateTopic = [self topicAtDate:previousDate];
  
  if (dateTopic.details.count == 0){
    NSLog(@"deleting prevoius date");

    if (dateTopic) [appDelegate.managedObjectContext deleteObject:dateTopic];
    
  }

}


// -------------------------------------------------------------------------------

//  topicAtDate:givenDate

// -------------------------------------------------------------------------------

- (DBDateTopic *) topicAtDate:(NSDate *)givenDate{
  
  NSFetchRequest * request;
  NSEntityDescription * entity;
  NSPredicate * datePredicate;
  NSError * error;
  NSArray * objectArray;
  
	entity = [NSEntityDescription entityForName:@"DateTopic" inManagedObjectContext:appDelegate.managedObjectContext];
	datePredicate = [NSPredicate predicateWithFormat:@"date = %@", [givenDate startOfDay]];
  
  request = [[NSFetchRequest alloc] init];
  [request setEntity:entity];
  [request setPredicate:datePredicate];
	error = nil;
  
  objectArray = [appDelegate.managedObjectContext executeFetchRequest:request error:&error];	//returns array of objects
  
  if (objectArray.count == 1) {
    
    return [objectArray objectAtIndex:0];
    
  } else if (objectArray.count < 1){

    return NULL;
    
  } else {
    
    NSLog(@"More than one date topic found for date!");
    return NULL;

  }
    
}



// -------------------------------------------------------------------------------

//  calendarStartDate:givenDate

// -------------------------------------------------------------------------------

- (id)calendarStartDate:(NSDate *)givenDate{
  
	int dayOfWeek;
	NSDate *startDate;
	NSInteger daysFromFirstOfMonth;
  NSCalendar *cal;
	NSDateComponents *comp;
  
  cal = [NSCalendar currentCalendar];
  comp = [[NSDateComponents alloc] init];
  comp =[cal components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:givenDate];

	daysFromFirstOfMonth = [comp day] - 1 ; //if it's the 1st we want to subtract 0 days
  
// get rid of hours mins etc.
	startDate = [[cal dateFromComponents:comp] subtractDays:(int)daysFromFirstOfMonth];
	comp =[cal components:NSWeekdayCalendarUnit fromDate:startDate];

// find first day of month
	dayOfWeek = (int)[comp weekday] - 1;
  
//find first day on calendar grid
	startDate = [startDate subtractDays:dayOfWeek];
  
	return startDate;

}


// -------------------------------------------------------------------------------

//  isDateOnCurrentCalendar:gridStart

// -------------------------------------------------------------------------------

-(BOOL)isDateOnCurrentCalendar:(NSDate *)givenDate{

	//NSDate *now = [NSDate date];
	NSDate *startDate = [self calendarStartDate:calendarMonth];
  NSDate *lastDate = [startDate addDays:NUMBER_OF_CALENDAR_DAYS];
  
	if ([givenDate laterDate:startDate] == givenDate && [givenDate earlierDate:lastDate] == givenDate)
		return YES;
	else
		return NO;
  
}


// -------------------------------------------------------------------------------

//  todaysGridNumber:gridStart

// -------------------------------------------------------------------------------

-(int)calendarGridNumber:(NSDate *)givenDate{

  NSDate * dateOfCalendarsFirstGrid = [self calendarStartDate:calendarMonth];
	NSTimeInterval timeDifference;
	int daysPastGridStart;
  
	givenDate = [givenDate startOfDay];
	
  timeDifference = [givenDate timeIntervalSinceDate:dateOfCalendarsFirstGrid]/86400;//converted to days
	daysPastGridStart = round(timeDifference); //get rid of decimal
  
	return daysPastGridStart;
}

// -------------------------------------------------------------------------------

//  gridPosition:forDate

// -------------------------------------------------------------------------------

-(int)gridPosition:(NSDate *)gridStart forDate:(NSDate *)findDate{

	NSTimeInterval timeDifference;
	int daysPastGridStart;
	
	timeDifference = [findDate timeIntervalSinceDate:gridStart]/86400;//converted to days

	daysPastGridStart = round(timeDifference); //get rid of decimal
  
	return daysPastGridStart;
}


#pragma mark -
#pragma mark Basic Calendar Formats

// -------------------------------------------------------------------------------

//  colorTodaysDate:dateButton

// -------------------------------------------------------------------------------

-(void)colorTodaysDate:(NSButton *)dateButton{

//add image
  NSImage * thisImage;
  thisImage = [NSImage imageNamed: CALENDAR_BUTTON_IMAGE];  
  [dateButton setImage:thisImage];  

//change text color
	[dateButton setTextColor:[NSColor whiteColor]];

}

// -------------------------------------------------------------------------------

//  selectDate:dateButton

// -------------------------------------------------------------------------------

- (void)selectDate:(NSButton *)dateButton{
  
  //draw border
  [dateButton setBordered:YES];
}

// -------------------------------------------------------------------------------

//  deselectDate:dateButton

// -------------------------------------------------------------------------------

- (void)deselectDate:(NSButton *)dateButton{
  
  //get rid of border
  [dateButton setBordered:NO];
  
}

// -------------------------------------------------------------------------------

//  colorOtherMonthDates:dateButton

// -------------------------------------------------------------------------------

- (void)colorOtherMonthDates:(NSButton *)dateButton{

//make text light gray
  [dateButton setTextColor:[NSColor lightGrayColor]];
}

// -------------------------------------------------------------------------------

//  resetCalendarGridColor:dateButton

// -------------------------------------------------------------------------------

- (void)resetCalendarGridColor:(NSButton *)dateButton{

//get rid of border
  [dateButton setBordered:NO];
  
//get rid of image
  [dateButton setImage:NULL];  

//make text black
  [dateButton setTextColor:[NSColor blackColor]];

}




// -------------------------------------------------------------------------------

//  colorDateWithEntry:dateButton

// -------------------------------------------------------------------------------

- (void)colorDateWithEntry:(NSButton *)dateButton{

//make text bold
  [ dateButton makeTextBold ];
  
}

// -------------------------------------------------------------------------------

//  colorDateWithNoEntry:dateButton

// -------------------------------------------------------------------------------

// this isn't used
- (void)colorDateWithNoEntry:(NSButton *)dateButton{

//unbold text
  [ dateButton unmakeTextBold ];
  
}


#pragma mark -
#pragma mark Calendar Buttons

// -------------------------------------------------------------------------------

//  daySelected:sender

// -------------------------------------------------------------------------------

- (IBAction)daySelected:(id)sender {
  
  [ sender setBordered:YES ]; // this doens't always happen when the button is clicked
  
  NSString *title = [sender alternateTitle];
  int i = [title intValue];
  NSDate * dateOfCalendarsFirstGrid = [self calendarStartDate:calendarMonth];
  NSDate *selectedDate =[dateOfCalendarsFirstGrid addDays:i];		
  [self selectDay:selectedDate];
  
}

// -------------------------------------------------------------------------------

//  selectTodaysDate:sender

// -------------------------------------------------------------------------------

- (IBAction)selectTodaysDate:(id)sender {
  
  NSDate *selectedDate = [[NSDate date] startOfDay];	
  
  //[calendarSplitView undoCollapse];
  
  [self selectDay:selectedDate];

}

// -------------------------------------------------------------------------------

//  nextMonth:sender

// -------------------------------------------------------------------------------

- (IBAction)nextMonth:(id)sender {
  
  calendarMonth = [calendarMonth addMonth];
  
  //[calendarSplitView undoCollapse];

  [self updateAllCalendarElements];
  
}

// -------------------------------------------------------------------------------

//  lastMonth:sender

// -------------------------------------------------------------------------------

- (IBAction)lastMonth:(id)sender {
  
  calendarMonth = [calendarMonth subtractMonth];

  //[calendarSplitView undoCollapse];
  
  [self updateAllCalendarElements];
  
}




// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------


- (void) testing {
  
  NSLog(@"calendar controller testing");
  
}

@end
