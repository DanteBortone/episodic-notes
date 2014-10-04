//
//  DBMainWindow.m
//  NoteTaker
//
//  Created by Dante on 9/28/13.
//
//


//---------------------------------------------
#import "DBMainWindow.h"
//---------------------------------------------
#import "DBTextViewCell.h"
#import "DBDetailOutlineView.h"
#import "DBMainSplitView.h"
#import "NoteTaker_AppDelegate.h"


@implementation DBMainWindow

@synthesize mainSplitView;
@synthesize gettingBigger;

// -------------------------------------------------------------------------------

// awakeFromNib

// -------------------------------------------------------------------------------

-(void)awakeFromNib {
  
  [self setDelegate:self];
  appDelegate = (NoteTaker_AppDelegate *)[[NSApplication sharedApplication] delegate];

}


// -------------------------------------------------------------------------------

// makeFirstResponder:

// -------------------------------------------------------------------------------

- (BOOL)makeFirstResponder:(NSResponder *)responder{
  //NSLog(@"first responder:  %@", [self.firstResponder className]);

  //NSLog(@"proposed responder:  %@", [responder className]);
  BOOL returnValue = [super makeFirstResponder:responder];
  
  [appDelegate timedSave];
  
  
  return returnValue;

}



// -------------------------------------------------------------------------------

// windowWillResize: toSize:

// -------------------------------------------------------------------------------

- (NSSize)windowWillResize:(NSWindow *)sender toSize:(NSSize)suggestedSize{
  //NSLog(@"DBMainindow windowWillResize");
  
  CGFloat suggestedWidth = suggestedSize.width;
  CGFloat currentWidth = self.frame.size.width;
  
  CGFloat minWidth = mainSplitView.myMinSize+4;//four is just a fudge factor
  
  // if the size is wider then it's no problem
  if (suggestedWidth > currentWidth) {
    
    gettingBigger = YES;

    return suggestedSize;
    
  } else {
    
    gettingBigger = NO;

    if (suggestedWidth > minWidth) {

      return suggestedSize;
    
    } else {

      NSSize minSize = NSMakeSize(minWidth, suggestedSize.height);
    
      return minSize;
    
    }
    
  }

}


@end
