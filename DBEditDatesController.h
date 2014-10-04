//
//  DBEditDatesController.h
//  NoteTaker
//
//  Created by Dante on 9/13/13.
//
//

#import "DBObjectController.h"

@class DBDetail;

@interface DBEditDatesController : DBObjectController  <NSWindowDelegate> {
  
  IBOutlet NSWindow * myWindow;
  
}

@property (strong) DBDetail * editingDetail;

- (IBAction)toggleWindow:(id)sender;
- (IBAction)openPanel;


@end
