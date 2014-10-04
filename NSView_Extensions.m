//
//  NSView_Extensions.m
//  NoteTaker
//
//  Created by Dante on 10/28/13.
//
//


//---------------------------------------------
#import "NSView_Extensions.h"
//---------------------------------------------

@implementation NSView (DBExtensions)



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(void) changeWidthTo:(CGFloat)width{
  
  NSRect oldFrame = self.frame;
  
  NSRect newRect = NSMakeRect(oldFrame.origin.x, oldFrame.origin.y, width, oldFrame.size.height);
  
  [self setFrame:newRect];
  
}

@end
