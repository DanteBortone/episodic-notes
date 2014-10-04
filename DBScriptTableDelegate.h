//
//  DBInputScriptTableDelegate.h
//  NoteTaker
//
//  Created by Dante on 10/8/13.
//
//

#import <Cocoa/Cocoa.h>

@class NoteTaker_AppDelegate;
@class DBApplescriptController;


// Subclass just needed to tell the applescript controller it may need to change the editingScript when the view becomes active.

@interface DBScriptTableDelegate : NSObject <NSTableViewDelegate> {
  
  NoteTaker_AppDelegate *appDelegate;
  DBApplescriptController *appleScriptController;
  IBOutlet NSTableView * myTable;

}


@end
