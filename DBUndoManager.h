//
//  DBUndoManager.h
//  Episodic Notes
//
//  Created by Dante Bortone on 6/2/14.
//
//

#import <Foundation/Foundation.h>

@class NoteTaker_AppDelegate;

@interface DBUndoManager : NSUndoManager {
  
  NoteTaker_AppDelegate * appDelegate;
  
}

-(void) makeUndoable; // does the things needed to do before making an action undoable
-(void) stopMakingUndoable; // does the things needed to do AFTER making an action undoable

@end
