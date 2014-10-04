//
//  DBCalendarSplitview.m
//  NoteTaker
//
//  Created by Dante on 10/23/13.
//
//


//---------------------------------------------
#import "DBCalendarSplitview.h"
//---------------------------------------------
#import "NoteTaker_AppDelegate.h"

#define UNCOLLAPSED_CALENDAR_HEIGHT 160

@implementation DBCalendarSplitview 

//@synthesize calendarCheckBox;


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void)awakeFromNib
{
  //appDelegate = (NoteTaker_AppDelegate *)[[NSApplication sharedApplication] delegate];
  //controllerOfOutlineViews = appDelegate.controllerOfOutlineViews;

  [self setDelegate:self];
  
  // init calendar toggle check box
  //  don't want to bind it beacuse the check would set the value before the action and the calendar button would set the value after the action and things would be a mess
  
  //NSNumber * calendarIsHidden = [[NSUserDefaults standardUserDefaults] valueForKey:@"calendarIsHidden"];
  //[ calendarCheckBox setState:![calendarIsHidden boolValue]];// removed checkbox
  

  resizableSubview = [[self subviews] objectAtIndex:1];
  collapsibleSubview = [[self subviews] objectAtIndex:0];
  
  
  uncollapsedSize = UNCOLLAPSED_CALENDAR_HEIGHT;


  appDelegate = (NoteTaker_AppDelegate *)[[NSApplication sharedApplication] delegate];

  if (appDelegate.shouldResetViews) [self resetView];

  [ self initCalendarState ];

  [super awakeFromNib];

}

- (void) resetView
{

  // doesn't need to wait for awake from nib
  [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:YES] forKey: @"calendarIsHidden"];
  
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (BOOL)splitView:(NSSplitView *)splitView shouldAdjustSizeOfSubview:(NSView *)subview
{
  
  //return NO;
  
  if (subview == collapsibleSubview) {
    return NO;
  } else {
    return YES;
  }
  
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (CGFloat)splitView:(NSSplitView *)splitView constrainMinCoordinate:(CGFloat)proposedMinimumPosition ofSubviewAt:(NSInteger)dividerIndex;
{
  
  //return self.frame.size.height - uncollapsedSize;
  return uncollapsedSize;
  //return 500;
  
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (CGFloat)splitView:(NSSplitView *)splitView constrainMaxCoordinate:(CGFloat)proposedMinimumPosition ofSubviewAt:(NSInteger)dividerIndex;
{
  
  return uncollapsedSize;
  //return self.frame.size.height - uncollapsedSize;
  //return 500;
  
}



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void)splitViewDidResizeSubviews:(NSNotification *)aNotification
{
  //NSLog(@"splitViewDidResizeSubviews");
  
  if ([self isSubviewCollapsed:collapsibleSubview]){
    
    //NSLog(@"calendar IS hidden");
    //[ calendarCheckBox setState:0];

    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"calendarIsHidden"];
    
  } else {
    
    //NSLog(@"calendar is NOT Hidden");
    //[ calendarCheckBox setState:1];

    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"calendarIsHidden"];

  }
  
}




// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (BOOL)splitView:(NSSplitView *)splitView canCollapseSubview:(NSView *)subview{
  
  
  //[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"calendarIsHidden"];

  //if (collapsibleSubview == subview) {
    
    //return YES;

  //} else {
    
    //return NO;
    
  //}

  return (collapsibleSubview == subview);

}


// -------------------------------------------------------------------------------

// initCalendarState

// -------------------------------------------------------------------------------

// on updating versions of the program the calendar size and hidden properties might not match
// this makes sure they are set the same
- (void)initCalendarState
{
  BOOL calendarShouldBeHidden = [[NSUserDefaults standardUserDefaults] valueForKey:@"calendarIsHidden"];
  
  if (calendarShouldBeHidden)
    
  {
    //NSLog(@"calendar SHOULD be hidden");
    
    [self collapse];
  }
  else
  {
    //NSLog(@"calendar should NOT be hidden");
    
    [self uncollapse];
    
  }
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (IBAction)toggleCollapse:(id)sender;
{

  BOOL calendarIsHidden = [[NSUserDefaults standardUserDefaults] valueForKey:@"calendarIsHidden"];
  
  
  
  
  if (calendarIsHidden)
    
  {
    //NSLog(@"calendar SHOULD be hidden");
    
    [self uncollapse];
  }
  else
  {
    //NSLog(@"calendar should NOT be hidden");
    
    [self collapse];
    
  }
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(void) collapse
{
  
  [calendarToggle setState:0];

  float constantWidth = collapsibleSubview.frame.size.width;

  //NSLog(@"constantWidth: %f",constantWidth);
  [collapsibleSubview setFrameSize:NSMakeSize(constantWidth, 0.0)];
  [resizableSubview setFrameSize:NSMakeSize(constantWidth, self.frame.size.height - [self dividerThickness])];
  

  //[ calendarCheckBox setState:0];
  
  [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:YES] forKey:@"calendarIsHidden"];
  
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(void) uncollapse
{
  //NSLog(@"uncollapse");
  [calendarToggle setState:1];
  
  float constantWidth = collapsibleSubview.frame.size.width;

  [collapsibleSubview setFrameSize:NSMakeSize(constantWidth, uncollapsedSize)];
  [resizableSubview setFrameSize:NSMakeSize(constantWidth, self.frame.size.height - uncollapsedSize - [self dividerThickness])];
  
  //[ calendarCheckBox setState:1];

  [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:NO] forKey:@"calendarIsHidden"];

}

@end
