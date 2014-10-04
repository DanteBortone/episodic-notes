//
//  DBRelatedTextViewCell.m
//  NoteTaker
//
//  Created by Dante on 10/5/13.
//
//

#import "DBRelatedTextViewCell.h"
#import "NoteTaker_AppDelegate.h"
//#import "DBOutlineViewController.h"

@implementation DBRelatedTextViewCell

//@synthesize outlineViewController;//dboutlineviewcontroller


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(void) awakeFromNib{
  
  appDelegate = (NoteTaker_AppDelegate *)[[NSApplication sharedApplication] delegate];
  
  [self.textContainer setContainerSize:NSMakeSize(FLT_MAX, FLT_MAX)];
  [self.textContainer setWidthTracksTextView:NO];
  [self setHorizontallyResizable:YES];
  [self setEditable:NO];
  [self setDrawsBackground: NO];
  [self setDisplaysLinkToolTips:NO];
  
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

// need to prevent this textView from absorbing the mouseDown events, so we'll pass them to the outline view unless the textview is already the first responder.
-(NSView *)hitTest:(NSPoint)aPoint{
  
  //NSLog(@"DBRelatedTextViewCell: hitTest");
  
  //[[NSCursor pointingHandCursor] set];
  
  if ([appDelegate.mainWindow firstResponder] == self ) {
    
    return self;
    
  } else {
    
    return NULL;//(NSView*)outlineViewController.view;
    
  }
  
}



-(BOOL) isEditable {
  return NO;
}


@end
