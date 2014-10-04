//
//  DBOutputScript.m
//  NoteTaker
//
//  Created by Dante on 10/9/13.
//
//

#import "DBOutputScript.h"

#import "DBApplication.h"
#import "DBUndoManager.h"
#import "NoteTaker_AppDelegate.h"

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
