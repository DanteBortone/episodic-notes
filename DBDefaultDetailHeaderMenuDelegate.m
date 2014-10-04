//
//  DBDetailHeaderMenuDelegate.m
//  NoteTaker
//
//  Created by Dante on 7/30/13.
//
//
//---------------------------------------------
#import "DBDefaultDetailHeaderMenuDelegate.h"
//---------------------------------------------

@implementation DBDefaultDetailHeaderMenuDelegate

//@synthesize outlineView;


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


/*
- (void) applyToAll:(NSNotification *) notification{
  
  //NSLog(@"apply to all");
  
  for (DBDetailViewController * detailViewController in controllerOfOutlineViews.detailViewControllerArray) {
    
    [controllerOfOutlineViews transferColumnSettingsFrom:outlineView to:(NSTableView *)detailViewController.primaryOutlineViewController.view];
    
  }
  
}

#pragma mark - NSMenuDelegate conformance
- (void)menuWillOpen:(NSMenu *)menu {
  
  NSDictionary *attributes = @{
                               NSFontAttributeName: [NSFont fontWithName:@"Lucida Grande" size:14.0],
                               };
  NSAttributedString *attributedTitle;
  
  for (NSMenuItem *menuItem in menu.itemArray) {
    
    NSTableColumn *column = [menuItem representedObject];
    
    attributedTitle = [[NSAttributedString alloc] initWithString:[menuItem title] attributes:attributes];
    [menuItem setAttributedTitle:attributedTitle];
    
    if (column) {
      [menuItem setState:column.isHidden ? NSOffState : NSOnState];
    } else {
      [menuItem setState:NSOffState];
    }
  }
  
  
}
*/
/*
#pragma mark - Private Methods
- (void)toggleColumn:(id)sender {
  NSTableColumn *column = [sender representedObject];
  [column setHidden:![column isHidden]];
  [outlineView sizeToFit];
}
*/
@end