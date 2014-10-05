/*
 
 Episodic Notes: A personal wiki, note taking app for Mac OSX. Create notes through any application on your computer and keep them in one place.
 
 Copyright (C) 2014. Dante Bortone
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 */


//---------------------------------------------
#import "DBOutputScript.h"
//---------------------------------------------

#import "DBApplication.h"
#import "DBUndoManager.h"
#import "NoteTaker_AppDelegate.h"

//---------------------------------------------


@implementation DBOutputScript


// Attributes -------------
@dynamic displayName;
@dynamic script;
@dynamic testValue;
@dynamic testPath;
@dynamic isEditable;

// Relationships ----------
@dynamic application;
@dynamic details;
@dynamic inputScripts;


// -------------------------------------------------------------------------------

//  applicationOutputDisplay

// -------------------------------------------------------------------------------

- (NSString *) applicationOutputDisplay
{
  
  return [NSString stringWithFormat:@"%@ : %@",self.application.displayName,self.displayName];
  
}

// -------------------------------------------------------------------------------

//  detailNumber

// -------------------------------------------------------------------------------

- (NSInteger) detailNumber
{
  
  return self.details.count;
  
  
}


// -------------------------------------------------------------------------------

//  setTestPath:

// -------------------------------------------------------------------------------

// done to set up undo
// minor bug in that this creates two undo actions not one. seems using the path controller sends two actions when a selection is made.

- (void) setTestPath:(NSString *)testPath
{
  NSLog(@"test path");
  NoteTaker_AppDelegate * appDelegate = (NoteTaker_AppDelegate *)[[NSApplication sharedApplication] delegate];
  
  DBUndoManager * undoManager = appDelegate.undoManager;
  
  
  [undoManager makeUndoable];
  
  [self willChangeValueForKey:@"testPath"];
  [self setPrimitiveValue:testPath forKey:@"testPath"];
  [self didChangeValueForKey:@"testPath"];
  
  [undoManager stopMakingUndoable];
  
}


@end
