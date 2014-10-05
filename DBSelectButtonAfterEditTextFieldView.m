/*
 
 Episodic Notes: A personal wiki, note taking app for Mac OSX. Create notes through any application on your computer and keep them in one place.
 
 Copyright (C) 2014. Dante Bortone
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 */


//---------------------------------------------
#import "DBSelectButtonAfterEditTextFieldView.h"
//---------------------------------------------


@implementation DBSelectButtonAfterEditTextFieldView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------
- (void)textDidEndEditing:(NSNotification *)aNotification
{
  
  //NSLog(@"textDidEndEditing");
  
  // remove selection
  NSWindow * myWindow = [ self window ];
  NSText* textEditor = [myWindow fieldEditor:YES forObject:self];
  [textEditor setSelectedRange:NSMakeRange(0, 0)];
  
  
  [ myWindow makeFirstResponder: buttonToSelect ];
  
}

@end
