//
//  DBOpenScript.m
//  NoteTaker
//
//  Created by Dante on 10/7/13.
//
//

#import "DBInputScript.h"

#import "DBApplication.h"
#import "NoteTaker_AppDelegate.h"
#import "DBUndoManager.h"

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
