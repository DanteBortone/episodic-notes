/*
 
 Episodic Notes: A personal wiki, note taking app for Mac OSX. Create notes through any application on your computer and keep them in one place.
 
 Copyright (C) 2014. Dante Bortone
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 */


//---------------------------------------------
#import "DBEditDatesController.h"
//---------------------------------------------

#import "NoteTaker_AppDelegate.h"
#import "DBUndoManager.h"

//---------------------------------------------


@implementation DBEditDatesController

@synthesize editingDetail;


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) openPanel
{

  
  [myWindow makeKeyAndOrderFront:myWindow];
  
  // set up undo functions
  DBUndoManager * undoManager = appDelegate.undoManager;
  [undoManager makeUndoable];
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (IBAction)toggleWindow:(id)sender{
  
  if ([ myWindow isVisible ]){
    
    [ self orderOutPanel ];
    
  } else {
    
    [ myWindow makeKeyAndOrderFront:myWindow ];
    
  }
  
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) orderOutPanel{
  
  // set up undo functions
  DBUndoManager * undoManager = appDelegate.undoManager;
  [undoManager stopMakingUndoable];
  
  [ myWindow orderOut:myWindow ];
  
  //[self clearPanel];
  
}


@end
