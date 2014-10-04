//
//  DBTestTextView.m
//  NoteTaker
//
//  Created by Dante on 8/23/13.
//
//


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
