//
//  NSTextView_Extensions.m
//  NoteTaker
//
//  Created by Dante on 10/9/13.
//
//


//---------------------------------------------
#import "NSTextView_Extensions.h"
//---------------------------------------------

@implementation NSTextView (DBExtensions)


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(void)enableHorizontalScrolling
{
  
  [[self textContainer] setContainerSize:NSMakeSize(FLT_MAX, FLT_MAX)];
  [[self textContainer] setWidthTracksTextView:NO];
  [self setHorizontallyResizable:YES];
  
}


@end
