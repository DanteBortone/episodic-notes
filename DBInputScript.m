/*
 
 Episodic Notes: A personal wiki, note taking app for Mac OSX. Create notes through any application on your computer and keep them in one place.
 
 Copyright (C) 2014. Dante Bortone
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 */


//---------------------------------------------
#import "DBInputScript.h"
//---------------------------------------------

#import "DBApplication.h"
#import "NoteTaker_AppDelegate.h"
#import "DBUndoManager.h"

//---------------------------------------------


@implementation DBInputScript

@synthesize undoManager = _undoManager;

// Attributes -------------
@dynamic displayName;
@dynamic script;
@dynamic isActiveScript;
@dynamic isEditable;

// Relationships ----------
@dynamic application;
@dynamic outputScript;

-(DBUndoManager *) undoManager
{
  
  if ( _undoManager == NULL ) {
    
    //NSLog(@"_undoManager for object is null");
     NoteTaker_AppDelegate * appDelegate = (NoteTaker_AppDelegate *)[[NSApplication sharedApplication] delegate];
    
    //NSUndoManager * undo = [appDelegate undoManager];
    
    _undoManager = [appDelegate undoManager];
    
  }
  
  return _undoManager;
  
}


// -------------------------------------------------------------------------------

//  setIsActiveScript :

// -------------------------------------------------------------------------------

// need to inactivate other scripts for this application

- (void) setIsActiveScript:(NSNumber *)isActiveScript
{
  //NSLog(@"inactivating other scripts");

  [self willChangeValueForKey:@"isActiveScript"];
  [self setPrimitiveValue:isActiveScript forKey:@"isActiveScript"];
  [self didChangeValueForKey:@"isActiveScript"];
  
  if ([isActiveScript boolValue] == YES) {
    NSMutableSet * otherScripts = [NSMutableSet setWithSet:[self.application inputScripts]];
    [otherScripts removeObject:self];
    
    for (DBInputScript * otherScript in otherScripts) {
      
      otherScript.isActiveScript = [NSNumber numberWithBool:NO];
  
    }
  
  }
  
}

@end
