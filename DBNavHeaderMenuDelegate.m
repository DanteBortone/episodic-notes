//
//  DBNavHeaderMenuDelegate.m
//  NoteTaker
//
//  Created by Dante on 8/5/13.
//
//
//---------------------------------------------
#import "DBNavHeaderMenuDelegate.h"
//---------------------------------------------

@implementation DBNavHeaderMenuDelegate



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
    
    if (![column.identifier isEqualToString:@"Topic"]) {//don't let them get rid of the topic
      menuItem.target = self;
      menuItem.representedObject = column;
      [columnsMenu addItem:menuItem];
    }
    
  }
  columnsMenu.delegate = self;
  [self.tableView.headerView setMenu:columnsMenu];
}


#pragma mark - Private Methods

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

// overwriting to only check one date option at a time
- (void)toggleColumn:(id)sender {
  
  NSTableColumn *selectedColumn = [sender representedObject];
  
  [selectedColumn setHidden:NO];

  
  for (NSTableColumn *otherColumn in self.tableView.tableColumns) {
    
    if (![otherColumn.identifier isEqualToString:@"Topic"]) { // don't get rid of the topic
      
      if (!(selectedColumn == otherColumn)) {                 // hide all columns but selectedColumn
        
        [otherColumn setHidden:YES];

      }

    }
    
  }
  
  NSString * sortKey = [[selectedColumn sortDescriptorPrototype] key];
  
  NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey: sortKey ascending: NO];
  [self.tableView setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
  
}

@end