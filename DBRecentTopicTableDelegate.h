//
//  DBRecentTopicTableDelegate.h
//  NoteTaker
//
//  Created by Dante on 7/27/13.
//
//

#import <Cocoa/Cocoa.h>

@class DBControllerOfOutlineViews;
@class NoteTaker_AppDelegate;
@class DBHyperlinkEditor;

@interface DBRecentTopicTableDelegate : NSObjectController <NSTableViewDelegate>
{
  
  IBOutlet NSArrayController * arrayController;
  DBControllerOfOutlineViews * controllerOfOutlineViews;
  NoteTaker_AppDelegate *appDelegate;
  DBHyperlinkEditor *hyperlinkEditor;
  
}


@end
