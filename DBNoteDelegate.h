//
//  DBTextDelegate.h
//  NoteTaker
//
//  Created by Dante on 2/27/13.
//
//

#import <Cocoa/Cocoa.h>

@class DBHyperlinkEditor;
@class NoteTaker_AppDelegate;
@class DBNoteTextView;
@class DBDetail;
@class DBUndoManager;

@interface DBNoteDelegate : NSObject <NSTextViewDelegate> {
  
  NoteTaker_AppDelegate *appDelegate;
  DBHyperlinkEditor * hyperlinkEditor;
  NSInteger insertionPoint;
  NSInteger textLength;
  DBDetail * representedObject;
  DBUndoManager * undoManager;

}

//@property (strong) IBOutlet NSTextView * myTextView;

@property (strong) DBNoteTextView * myTextView;

@end
