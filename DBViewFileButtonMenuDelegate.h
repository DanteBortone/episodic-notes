//
//  DBViewFileButtonMenuDelegateViewController.h
//  NoteTaker
//
//  Created by Dante on 9/8/13.
//
//

#import <Cocoa/Cocoa.h>

@class DBDetailViewController;
@class NoteTaker_AppDelegate;
@class DBAliasController;

//not inheriting from filebuttonmenu because this one needs to load from init and don't want to mess up the orginal while I'm working around
//changes:
  //  columnsMenu, detailviewController and myButton are visible properties
  //  new init

@interface DBViewFileButtonMenuDelegate : NSViewController<NSMenuDelegate> {
  
  NoteTaker_AppDelegate * appDelegate;
  DBAliasController * aliasController;
  
  //IBOutlet DBDetailViewController *detailViewController;
  
  NSMutableArray *fullPathComponents;  
  
}

//SLOPPY.  make this prety if it works.
@property (strong) DBViewFileButtonMenuDelegate *menuDelegate; //this is needed to keep it from being dropped
@property (strong) DBDetailViewController *detailViewController;
@property (strong) NSMenu *columnsMenu;
//@property (strong) NSButton *myButton;

- (void)openURL:(id)sender;


@end