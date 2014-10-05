/*
 
 Episodic Notes: A personal wiki, note taking app for Mac OSX. Create notes through any application on your computer and keep them in one place.
 
 Copyright (C) 2014. Dante Bortone
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 */


//---------------------------------------------
#import "DBRelatedTextViewCell.h"
//---------------------------------------------

#import "NoteTaker_AppDelegate.h"

//---------------------------------------------


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
