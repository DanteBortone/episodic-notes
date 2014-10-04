//
//  DBCalendarSplitview.h
//  NoteTaker
//
//  Created by Dante on 10/23/13.
//
//

#import <Cocoa/Cocoa.h>

@class NoteTaker_AppDelegate;

// pretty sure this class is not robust but it does what it's supposed to in (un)collapsing the calendar with drags and clicking disclosure triangle

@interface DBCalendarSplitview : NSSplitView <NSSplitViewDelegate>{
  
  //BOOL isAnimating;
  NoteTaker_AppDelegate *appDelegate; //to see if view needs to be reset

  NSView * collapsibleSubview;
  NSView * resizableSubview;
  float uncollapsedSize;
  
  IBOutlet NSButton * calendarToggle;

}

//@property (strong) IBOutlet NSButton * calendarCheckBox;

- (IBAction)toggleCollapse:(id)sender;

- (void) uncollapse;


@end
