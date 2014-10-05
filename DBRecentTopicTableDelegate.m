/*
 
 Episodic Notes: A personal wiki, note taking app for Mac OSX. Create notes through any application on your computer and keep them in one place.
 
 Copyright (C) 2014. Dante Bortone
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 */


//---------------------------------------------
#import "DBRecentTopicTableDelegate.h"
//---------------------------------------------

#import "DBTopicObject.h"
#import "DBDetailOutlineViewController.h"
#import "DBControllerOfOutlineViews.h"
#import "NoteTaker_AppDelegate.h"
#import "DBDetailViewController.h"

//---------------------------------------------


@implementation DBRecentTopicTableDelegate


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) awakeFromNib{
  
  appDelegate = (NoteTaker_AppDelegate *)[[NSApplication sharedApplication] delegate];
  controllerOfOutlineViews = appDelegate.controllerOfOutlineViews;
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification{
  NSArray * selectedObjects = [arrayController selectedObjects];
  DBTopicObject * selectedTopic;
  DBDetailOutlineViewController * activeDetailOutlineViewController;

  if (selectedObjects.count > 0) {
    
    selectedTopic = [selectedObjects objectAtIndex:0];
    activeDetailOutlineViewController = controllerOfOutlineViews.activeDetailOutlineViewController;
    [[(DBDetailOutlineViewController *)activeDetailOutlineViewController mainDetailViewController] assignTopic:selectedTopic];
    
    [arrayController rearrangeObjects];
  }
    
}




@end
