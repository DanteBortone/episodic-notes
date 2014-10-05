/*
 
 Episodic Notes: A personal wiki, note taking app for Mac OSX. Create notes through any application on your computer and keep them in one place.
 
 Copyright (C) 2014. Dante Bortone
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 */


//---------------------------------------------
#import "DBAppleScriptPanel.h"
//---------------------------------------------

#import "NoteTaker_AppDelegate.h"

//---------------------------------------------


@implementation DBAppleScriptPanel

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

  BOOL returnValue = [super makeFirstResponder:responder];
  
  [appDelegate timedSave];
  
  return returnValue;
  
}

-(DBUndoManager *) undoManager
{
  
  if ( _undoManager == NULL ) {
    
    _undoManager = [appDelegate undoManager];
    
  }
  
  return _undoManager;
  
}


- (DBUndoManager *)windowWillReturnUndoManager:(NSWindow *)window
{
  return [self undoManager];
}


@end
