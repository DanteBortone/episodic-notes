//
//  DBAppleScriptPanel.h
//  NoteTaker
//
//  Created by Dante on 11/13/13.
//
//

#import <Cocoa/Cocoa.h>
#import "DBUndoRedoWindow.h"

@class NoteTaker_AppDelegate;


@interface DBAppleScriptPanel : NSPanel <NSWindowDelegate>{
  
  NoteTaker_AppDelegate *appDelegate; 
  
}

@property (strong, nonatomic) DBUndoManager * undoManager;


@end
