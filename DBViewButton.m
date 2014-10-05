/*
 
 Episodic Notes: A personal wiki, note taking app for Mac OSX. Create notes through any application on your computer and keep them in one place.
 
 Copyright (C) 2014. Dante Bortone
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 */


//---------------------------------------------
#import "DBViewButton.h"
//---------------------------------------------

#import "DBDetailOutlineView.h"

//---------------------------------------------


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
