//
//  DBDefaultRelatedHeaderMenuDelegate.m
//  NoteTaker
//
//  Created by Dante on 8/8/13.
//
//

//---------------------------------------------
#import "DBDefaultRelatedHeaderMenuDelegate.h"
//---------------------------------------------
#import "DBDetailViewController.h"
#import "DBControllerOfOutlineViews.h"
#import "DBRelatedOutlineViewController.h"

@interface DBDefaultRelatedHeaderMenuDelegate ()

@end

@implementation DBDefaultRelatedHeaderMenuDelegate



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void)awakeFromNib {
  
  [super awakeFromNib];
  
  //appDelegate = (NoteTaker_AppDelegate *)[[NSApplication sharedApplication] delegate];
  //controllerOfOutlineViews = appDelegate.controllerOfOutlineViews;
  
  NSMenu *columnsMenu = [[NSMenu alloc] initWithTitle:@""];
  
  [columnsMenu setAutoenablesItems:NO];
  
  for (NSTableColumn *column in self.tableView.tableColumns) {
    
    
    if (![column.identifier isEqualToString:@"Detail"]) {//don't let them get rid of the displayName
      
      NSMenuItem *menuItem = [[NSMenuItem alloc] initWithTitle:column.identifier
                                                        action:@selector(toggleColumn:)
                                                 keyEquivalent:@""];
      menuItem.target = self;
      menuItem.representedObject = column;
      [columnsMenu addItem:menuItem];
      
    }
    
  }
  
  [columnsMenu addItem:[NSMenuItem separatorItem]];
  
  NSMenuItem *applyAllItem = [[NSMenuItem alloc] initWithTitle:@"Apply to all"
                                                        action:@selector(applyToAll:)
                                                 keyEquivalent:@""];
  applyAllItem.target = self;
  [columnsMenu addItem:applyAllItem];
  
  columnsMenu.delegate = self;
  [self.tableView.headerView setMenu:columnsMenu];
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------


- (void) applyToAll:(NSNotification *) notification{
  
  //NSLog(@"apply to all");
  
  for (DBDetailViewController * detailViewController in controllerOfOutlineViews.detailViewControllerArray) {
    
    [controllerOfOutlineViews transferColumnSettingsFrom:self.tableView to:(NSTableView *)detailViewController.relatedOutlineViewController.view];
    
    
  }
  
}

@end
