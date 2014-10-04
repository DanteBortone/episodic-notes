//
//  DBRemoveOutputScriptController.h
//  NoteTaker
//
//  Created by Dante on 10/20/13.
//
//

#import <Cocoa/Cocoa.h>

@class NoteTaker_AppDelegate;

@interface DBPanelController : NSObjectController <NSWindowDelegate> {
  
  NoteTaker_AppDelegate * appDelegate;
  
  IBOutlet NSWindow * myWindow;

}

- (void) closePanel;
- (void) openPanel;

- (IBAction)openWindow:(id)sender;
- (IBAction)closeWindow:(id)sender;
- (IBAction)toggleWindow:(id)sender;


@end
