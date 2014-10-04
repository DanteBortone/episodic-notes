//
//  DBHeaderMenuDelegate.h
//  NoteTaker
//
//  Created by Dante on 8/8/13.
//
//

#import <Cocoa/Cocoa.h>

@class NoteTaker_AppDelegate;
@class DBControllerOfOutlineViews;

@interface DBHeaderMenuDelegate : NSViewController<NSMenuDelegate> {
  
  NoteTaker_AppDelegate * appDelegate;
  DBControllerOfOutlineViews * controllerOfOutlineViews;
  
}

@property (weak) IBOutlet NSTableView *tableView;

- (void)toggleColumn:(id)sender;


@end
