//
//  DBCellFileButtonMenuDelegate.h
//  NoteTaker
//
//  Created by Angela Bortone on 8/13/13.
//
//

#import <Cocoa/Cocoa.h>

@class NoteTaker_AppDelegate;
@class DBControllerOfOutlineViews;
@class DBDetailViewController;
@class DBAliasController;
@class DBCalendarController;
@class DBEditDatesController;
@class DBOutlineView;

@interface DBTableMenuDelegate : NSViewController<NSMenuDelegate> {
  
  NoteTaker_AppDelegate * appDelegate;
  DBControllerOfOutlineViews * controllerOfOutlineViews;
  DBAliasController * aliasController;
  DBCalendarController * calendarController;
  
  NSMenu *columnsMenu;
  NSMutableArray *fullPathComponents;

  IBOutlet DBDetailViewController *detailViewController;
  IBOutlet DBEditDatesController * editDatesController;
}

@property (weak) IBOutlet DBOutlineView *tableView;


@end
