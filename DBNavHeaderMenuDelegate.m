/*
 
 Episodic Notes: A personal wiki, note taking app for Mac OSX. Create notes through any application on your computer and keep them in one place.
 
 Copyright (C) 2014. Dante Bortone
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 */


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