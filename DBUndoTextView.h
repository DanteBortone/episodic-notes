//
//  DBTestTextView.h
//  NoteTaker
//
//  Created by Dante on 8/23/13.
//
//

#import <Cocoa/Cocoa.h>

@class DBUndoManager;

@interface DBUndoTextView : NSTextView <NSTextViewDelegate>{
  
  DBUndoManager * undoManager;
  
}


@end
