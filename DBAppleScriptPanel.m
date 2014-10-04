//
//  DBAppleScriptPanel.m
//  NoteTaker
//
//  Created by Dante on 11/13/13.
//
//


//---------------------------------------------
#import "DBAppleScriptPanel.h"
//---------------------------------------------
#import "NoteTaker_AppDelegate.h"


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
