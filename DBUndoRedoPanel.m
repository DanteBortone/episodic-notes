//
//  DBUndoRedoPanel.m
//  Episodic Notes
//
//  Created by Dante Bortone on 6/8/14.
//
//

#import "DBUndoRedoPanel.h"

#import "NoteTaker_AppDelegate.h"


@implementation DBUndoRedoPanel

@synthesize undoManager = _undoManager;

-(void) awakeFromNib{
  //NSLog(@"awoken");
  [self setDelegate:self];
  
}

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


- (DBUndoManager *)windowWillReturnUndoManager:(NSWindow *)window
{
  return [self undoManager];
}



@end
