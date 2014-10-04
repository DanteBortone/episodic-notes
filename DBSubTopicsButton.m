//
//  DBSubTopicsButton.m
//  NoteTaker
//
//  Created by Dante on 11/28/13.
//
//


//---------------------------------------------
#import "DBSubTopicsButton.h"
//---------------------------------------------


@implementation DBSubTopicsButton



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

//want the popup menu for left and right clicks

-(void)mouseDown:(NSEvent *)theEvent{
  
  NSPoint point = [self convertPoint:theEvent.locationInWindow fromView:nil]; //defaults to main window
  
  [self.menu popUpMenuPositioningItem:nil atLocation:point inView:self];
  
  //[super mouseDown:theEvent];
  
}


@end
