//
//  DBUndoRedoWindow.m
//  Episodic Notes
//
//  Created by Dante Bortone on 5/11/14.
//
//

#import "DBUndoRedoWindow.h"
#import "NoteTaker_AppDelegate.h"

@implementation DBUndoRedoWindow

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
