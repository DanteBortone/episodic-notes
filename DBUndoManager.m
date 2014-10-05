/*
 
 Episodic Notes: A personal wiki, note taking app for Mac OSX. Create notes through any application on your computer and keep them in one place.
 
 Copyright (C) 2014. Dante Bortone
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 */


//---------------------------------------------
#import "DBUndoManager.h"
//---------------------------------------------

#import "NoteTaker_AppDelegate.h"
#import "DBControllerOfOutlineViews.h"

//---------------------------------------------


@implementation DBUndoManager

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (id)init{
  
  if (self = [super init]) {
    
    appDelegate = (NoteTaker_AppDelegate *)[[NSApplication sharedApplication] delegate];
    
  }
  
  return self;
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(void) undo
{
  
  [self endEditing];

  [[appDelegate managedObjectContext] processPendingChanges];

  [self enableUndoRegistration];
  [[NSRunLoop currentRunLoop] runMode: NSDefaultRunLoopMode beforeDate:[NSDate date]];
  [super undo];
  [[appDelegate managedObjectContext] processPendingChanges];
  [self disableUndoRegistration];

  [self resetData];

}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(void) redo
{
  
  [self endEditing];
  
  [[appDelegate managedObjectContext] processPendingChanges];
  
  [self enableUndoRegistration];
  [[NSRunLoop currentRunLoop] runMode: NSDefaultRunLoopMode beforeDate:[NSDate date]];
  [super redo];
  [[appDelegate managedObjectContext] processPendingChanges];
  [self disableUndoRegistration];
  
  [self resetData];

}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------
// does the things needed to do before making an action undoable
-(void) makeUndoable
{
  //NSLog(@"makeUndoable");
  if (![self isUndoRegistrationEnabled]) {
  
    [appDelegate.managedObjectContext processPendingChanges]; // flush operations for which you do not want undos
    [self enableUndoRegistration];
  
    [self beginUndoGrouping];
  
  }
}




// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------
// does the things needed to do AFTER making an action undoable
-(void) stopMakingUndoable
{
  
  if ([self isUndoRegistrationEnabled]) {

    //NSLog(@"stopMakingUndoable");
    [appDelegate.managedObjectContext processPendingChanges]; // flush operations for which you want undos
    [[NSRunLoop currentRunLoop] runMode: NSDefaultRunLoopMode beforeDate:[NSDate date]];
    [self endUndoGrouping];
    [self disableUndoRegistration];
  
  }
  
}




// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------
-(void) endEditing
{
  // need to end editing so that a deleted row isn't stuck in edit mode
  NSWindow * activeWindow = [[NSApplication sharedApplication] keyWindow];
  [activeWindow makeFirstResponder:activeWindow];
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------
-(void) resetData
{
  //get selection paths for all tables

  DBControllerOfOutlineViews * controllerOfOutlineViews =[appDelegate controllerOfOutlineViews];
  
  NSArray * selectionPaths = [controllerOfOutlineViews viewSelectionIndexPaths];
  
  // reset views to show new data
  [controllerOfOutlineViews resetDetailViews];
  
  
  [ controllerOfOutlineViews setViewSelectionIndexPaths:selectionPaths ];
  
}

@end
