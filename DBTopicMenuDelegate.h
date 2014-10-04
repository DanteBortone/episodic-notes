//
//  DBTopicMenuDelegate.h
//  Episodic Notes
//
//  Created by Dante Bortone on 6/28/14.
//
//

#import <Cocoa/Cocoa.h>

@class DBOutlineView;
@class NoteTaker_AppDelegate;
@class DBDetailController;
@class DBAddTopicController;
@class DBSubTopicController;
@class DBEditTopicController;

@interface DBTopicMenuDelegate : NSViewController <NSMenuDelegate>{
  

  NoteTaker_AppDelegate * appDelegate;
  NSMenu *myMenu;

  IBOutlet DBDetailController *detailController;

  IBOutlet DBAddTopicController * addTopicController;
  IBOutlet DBSubTopicController * subTopicController;
  IBOutlet DBEditTopicController * editTopicController;

}

@property (weak) IBOutlet DBOutlineView *tableView;

@end
