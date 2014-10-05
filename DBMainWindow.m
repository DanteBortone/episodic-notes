/*
 
 Episodic Notes: A personal wiki, note taking app for Mac OSX. Create notes through any application on your computer and keep them in one place.
 
 Copyright (C) 2014. Dante Bortone
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 */


//---------------------------------------------
#import "DBMainWindow.h"
//---------------------------------------------

#import "DBTextViewCell.h"
#import "DBDetailOutlineView.h"
#import "DBMainSplitView.h"
#import "NoteTaker_AppDelegate.h"

//---------------------------------------------


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
