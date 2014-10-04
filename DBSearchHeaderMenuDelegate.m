//
//  DBSearchHeaderMenuDelegate.m
//  NoteTaker
//
//  Created by Dante on 8/5/13.
//
//
//---------------------------------------------
#import "DBSearchHeaderMenuDelegate.h"
//---------------------------------------------

@implementation DBSearchHeaderMenuDelegate



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void)awakeFromNib {
  
  [super awakeFromNib];
  NSMenu *columnsMenu = [[NSMenu alloc] initWithTitle:@""];
  for (NSTableColumn *column in self.tableView.tableColumns) {
    NSMenuItem *menuItem = [[NSMenuItem alloc] initWithTitle:column.identifier
                                                      action:@selector(toggleColumn:)
                                               keyEquivalent:@""];
    
    if (![column.identifier isEqualToString:@"Detail"]) {//don't let them get rid of the displayName
      menuItem.target = self;
      menuItem.representedObject = column;
      [columnsMenu addItem:menuItem];
    }
    
  }

  columnsMenu.delegate = self;
  [self.tableView.headerView setMenu:columnsMenu];

}


@end