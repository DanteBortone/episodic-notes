//
//  DBHeaderMenuDelegate.m
//  NoteTaker
//
//  Created by Dante on 8/8/13.
//
//
//---------------------------------------------
#import "DBHeaderMenuDelegate.h"
//---------------------------------------------
#import "NoteTaker_AppDelegate.h"
#import "DBControllerOfOutlineViews.h"
#import "DBDetailViewController.h"
#import "DBDetailOutlineViewController.h"
#import "DBTextFormats.h"

// will usually just want to customize awakeFromNib
@implementation DBHeaderMenuDelegate

@synthesize tableView;

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void)awakeFromNib {
  
  
  appDelegate = (NoteTaker_AppDelegate *)[[NSApplication sharedApplication] delegate];
  controllerOfOutlineViews = appDelegate.controllerOfOutlineViews;
  

  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) setAsDefault:(NSNotification *) notification{
  
  //NSLog(@"setAsDefault");
  
  [controllerOfOutlineViews transferColumnSettingsFrom:tableView to:controllerOfOutlineViews.preferedDefaultDetailOutlineView];
  
  [controllerOfOutlineViews.preferedDefaultDetailOutlineView sizeToFit];

  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) applyToAll:(NSNotification *) notification{
  
  //NSLog(@"apply to all");
  
  for (DBDetailViewController * detailViewController in controllerOfOutlineViews.detailViewControllerArray) {
    
    [controllerOfOutlineViews transferColumnSettingsFrom:tableView to:(NSTableView *)detailViewController.primaryOutlineViewController.view];
    
  }
  
}


#pragma mark - NSMenuDelegate conformance

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void)menuWillOpen:(NSMenu *)menu {
  
  //NSDictionary *attributes = @{
    //                           NSFontAttributeName: [NSFont fontWithName:@"Lucida Grande" size:14.0],
       //                        };
  NSAttributedString *attributedTitle;
  
  for (NSMenuItem *menuItem in menu.itemArray) {
    
    NSTableColumn *column = [menuItem representedObject];
    
    attributedTitle = [[NSAttributedString alloc] initWithString:[menuItem title] attributes:appDelegate.textFormatter.menuTextAttributes];
    
    [menuItem setAttributedTitle:attributedTitle];
    
    if (column) {
      [menuItem setState:column.isHidden ? NSOffState : NSOnState];
    } else {
      [menuItem setState:NSOffState];
    }
    
  }
  
}

#pragma mark - Private Methods

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void)toggleColumn:(id)sender {
  
  NSTableColumn *column = [sender representedObject];
  [column setHidden:![column isHidden]];
  [tableView sizeToFit];

}

@end
