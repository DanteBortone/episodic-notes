//
//  DBUndoRedoWindow.h
//  Episodic Notes
//
//  Created by Dante Bortone on 5/11/14.
//
//

#import <Cocoa/Cocoa.h>

@class DBUndoManager;


@interface DBUndoRedoWindow : NSWindow <NSWindowDelegate>

@property (strong, nonatomic) DBUndoManager * undoManager;

@end
