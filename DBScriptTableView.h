//
//  DBScriptTableView.h
//  NoteTaker
//
//  Created by Dante on 10/9/13.
//
//

#import <Cocoa/Cocoa.h>
@class NoteTaker_AppDelegate;
@class DBApplescriptController;

@interface DBScriptTableView : NSTableView {
  NoteTaker_AppDelegate *appDelegate;
  DBApplescriptController *appleScriptController;
}

@end
