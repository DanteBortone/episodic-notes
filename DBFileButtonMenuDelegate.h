//
//  DBFileButtonMenuDelegate.h
//  NoteTaker
//
//  Created by Dante on 8/10/13.
//
//

#import <Cocoa/Cocoa.h>

@class DBDetailViewController;
@class NoteTaker_AppDelegate;
@class DBAliasController;

@interface DBFileButtonMenuDelegate : NSViewController<NSMenuDelegate> {
  
  NoteTaker_AppDelegate * appDelegate;
  DBAliasController * aliasController;
  
  IBOutlet DBDetailViewController *detailViewController;
  
  NSMutableArray *fullPathComponents;
  NSMenu *columnsMenu;

  
}

@property (weak) IBOutlet NSButton *myButton;

- (void)openURL:(id)sender;


@end
