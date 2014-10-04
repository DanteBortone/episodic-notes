//
//  DBScriptTextView.m
//  Episodic Notes
//
//  Created by Dante Bortone on 6/30/14.
//
//

#import "DBScriptTextView.h"
#import "DBUndoManager.h"
#import "NoteTaker_AppDelegate.h"

@implementation DBScriptTextView

// -------------------------------------------------------------------------------

// becomes frist responder

// -------------------------------------------------------------------------------
// made to turn on undo for the script editing text view.
// see DBAppleScriptTextViewDelegate textdidEndEditing for stopMakingUndoAble
-(BOOL)becomeFirstResponder{
  
  NSLog(@"becomes first responder");
  NoteTaker_AppDelegate *appDelegate = (NoteTaker_AppDelegate *)[[NSApplication sharedApplication] delegate];
  
  DBUndoManager *undoManager = appDelegate.undoManager;
  
  [undoManager makeUndoable];
  
  return [super becomeFirstResponder];
  
}

@end
