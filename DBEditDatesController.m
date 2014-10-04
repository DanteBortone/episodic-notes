//
//  DBEditDatesController.m
//  NoteTaker
//
//  Created by Dante on 9/13/13.
//
//
//---------------------------------------------
#import "DBEditDatesController.h"
//---------------------------------------------
#import "NoteTaker_AppDelegate.h"
#import "DBUndoManager.h"

@implementation DBEditDatesController

@synthesize editingDetail;


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) openPanel
{

  
  [myWindow makeKeyAndOrderFront:myWindow];
  
  // set up undo functions
  DBUndoManager * undoManager = appDelegate.undoManager;
  [undoManager makeUndoable];
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (IBAction)toggleWindow:(id)sender{
  
  if ([ myWindow isVisible ]){
    
    [ self orderOutPanel ];
    
  } else {
    
    [ myWindow makeKeyAndOrderFront:myWindow ];
    
  }
  
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) orderOutPanel{
  
  // set up undo functions
  DBUndoManager * undoManager = appDelegate.undoManager;
  [undoManager stopMakingUndoable];
  
  [ myWindow orderOut:myWindow ];
  
  //[self clearPanel];
  
}


@end
