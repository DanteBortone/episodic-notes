//
//  DBMainWindow.h
//  NoteTaker
//
//  Created by Dante on 9/28/13.
//
//

#import <Cocoa/Cocoa.h>
#import "DBUndoRedoWindow.h"

@class DBTextViewCell;
@class DBDetailOutlineView;
@class DBMainSplitView;
@class NoteTaker_AppDelegate;


@interface DBMainWindow : DBUndoRedoWindow  <NSWindowDelegate>{

  NoteTaker_AppDelegate *appDelegate;

}

@property IBOutlet DBMainSplitView * mainSplitView;
@property BOOL gettingBigger;


@end
