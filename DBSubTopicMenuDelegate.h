//
//  DBSubTopicMenuDelegate.h
//  NoteTaker
//
//  Created by Dante on 11/28/13.
//
//

#import <Cocoa/Cocoa.h>

@class NoteTaker_AppDelegate;
@class DBDetailViewController;

@interface DBSubTopicMenuDelegate : NSViewController <NSMenuDelegate> {
  
  IBOutlet NSButton * subTopicButton;
  IBOutlet DBDetailViewController *detailViewController;

  NSMenu *subTopicsMenu;
  NoteTaker_AppDelegate * appDelegate;

}

@end
