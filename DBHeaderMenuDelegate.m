/*
 
 Episodic Notes: A personal wiki, note taking app for Mac OSX. Create notes through any application on your computer and keep them in one place.
 
 Copyright (C) 2014. Dante Bortone
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 */


//---------------------------------------------
#import "DBHeaderMenuDelegate.h"
//---------------------------------------------

#import "NoteTaker_AppDelegate.h"
#import "DBControllerOfOutlineViews.h"
#import "DBDetailViewController.h"
#import "DBDetailOutlineViewController.h"
#import "DBTextFormats.h"

//---------------------------------------------

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
