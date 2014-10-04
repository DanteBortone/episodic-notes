//
//  DBViewButton.m
//  NoteTaker
//
//  Created by Dante on 9/8/13.
//
//


//---------------------------------------------
#import "DBViewButton.h"
//---------------------------------------------
#import "DBDetailOutlineView.h"


@implementation DBViewButton


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(void)rightMouseDown:(NSEvent *)theEvent{

  [ self selectRow:theEvent];

  NSView *tableView = self.superview.superview.superview;
  
  NSPoint point = [tableView convertPoint:theEvent.locationInWindow fromView:nil];//defaults to main window

  [tableView.menu popUpMenuPositioningItem:nil atLocation:point inView:tableView]; //assumes row is selected
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(void)mouseDown:(NSEvent *)theEvent{

  if (theEvent.modifierFlags & NSControlKeyMask) {
  
    // won't select row here because the right mouse click needs to do it as well
    [self rightMouseDown:theEvent];

  } else {


    [super mouseDown:theEvent];
    
    [ self selectRow:theEvent];

    //NSLog(@"button down");
    
  }
  

}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

//  we can't just pass the event to the tableview:mouseDown because it caused the buttons to get stuck
- (void) selectRow:(NSEvent *)theEvent {
  
  //NSLog(@"select row");
  DBDetailOutlineView *tableView = (DBDetailOutlineView *)self.superview.superview.superview;
  
  [[self window] makeFirstResponder:tableView];
  //[tableView becomeFirstResponder];
  
  [tableView selectedRowFromEvent:theEvent];
  
}

@end
