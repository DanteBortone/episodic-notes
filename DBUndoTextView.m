/*
 
 Episodic Notes: A personal wiki, note taking app for Mac OSX. Create notes through any application on your computer and keep them in one place.
 
 Copyright (C) 2014. Dante Bortone
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 */


//---------------------------------------------
#import "DBUndoTextView.h"
//---------------------------------------------


#import "DBUndoManager.h"
#import "NoteTaker_AppDelegate.h"


@implementation DBUndoTextView

// -------------------------------------------------------------------------------

// awakeFromNib

// -------------------------------------------------------------------------------

-(void) awakeFromNib{
  
  NoteTaker_AppDelegate *appDelegate = (NoteTaker_AppDelegate *)[[NSApplication sharedApplication] delegate];
  
  undoManager = appDelegate.undoManager;
  
  [self setDelegate:self];
  
}


// -------------------------------------------------------------------------------

// becomes frist responder

// -------------------------------------------------------------------------------

//-(BOOL)becomeFirstResponder{
  
  //[undoManager makeUndoable];
  
  //return [super becomeFirstResponder];

//}


// -------------------------------------------------------------------------------

// textDidEndEditing:

// -------------------------------------------------------------------------------

-(void) textDidEndEditing:(NSNotification *)notification{
  
  [undoManager stopMakingUndoable];// look in becomesfrist responder for the makeUndoable command
  
}


/*
- (void) textDidBeginEditing:(NSNotification *)notification
{
  
  [undoManager makeUndoable];
  
}
*/


-(BOOL)textShouldBeginEditing:(NSText *)textObject
{
  
  [undoManager makeUndoable];
  
  return YES;
}

@end
