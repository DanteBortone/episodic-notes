//
//  DBUndoRedoPanel.h
//  Episodic Notes
//
//  Created by Dante Bortone on 6/8/14.
//
//

#import <Cocoa/Cocoa.h>

@class DBUndoManager;

@interface DBUndoRedoPanel : NSPanel<NSWindowDelegate>

@property (strong, nonatomic) DBUndoManager * undoManager;


@end
