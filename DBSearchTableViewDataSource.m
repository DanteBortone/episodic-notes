/*
 
 Episodic Notes: A personal wiki, note taking app for Mac OSX. Create notes through any application on your computer and keep them in one place.
 
 Copyright (C) 2014. Dante Bortone
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 */


//---------------------------------------------
#import "DBSearchTableViewDataSource.h"
//---------------------------------------------

#import "DBControllerOfOutlineViews.h"
#import "DBSearchController.h"
#import "NoteTaker_AppDelegate.h"
#import "DBManagedTreeObject.h"

//---------------------------------------------


@implementation DBSearchTableViewDataSource


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void)awakeFromNib {	 
  dragType = [NSArray arrayWithObjects: @"detailDrag", nil]; 
  [searchView registerForDraggedTypes:dragType ]; 
  appDelegate = (NoteTaker_AppDelegate *)[[NSApplication sharedApplication] delegate];
  controllerOfOutlineViews = appDelegate.controllerOfOutlineViews;
  searchArrayController = appDelegate.searchController.searchArrayController;
  [searchView setRowHeight:18];
}	 


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (BOOL)tableView:(NSTableView *)aTableView 
        writeRowsWithIndexes:(NSIndexSet *)rowIndexes 
     toPasteboard:(NSPasteboard *)pboard{
  
  
  [searchView selectRowIndexes:rowIndexes byExtendingSelection:NO];
	[ pboard declareTypes:dragType owner:self ];
  
  // only allows one item to be dragged for now
  DBManagedTreeObject * draggedObject = [[searchArrayController arrangedObjects] objectAtIndex:[rowIndexes firstIndex]];
  NSLog(@"dragging object: %@", draggedObject.displayName);
  controllerOfOutlineViews.draggedObjects = [NSArray arrayWithObject: draggedObject];
  controllerOfOutlineViews.draggedSubGroups = [draggedObject descendantObjects];
  
  return YES;
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (BOOL)tableView:(NSTableView *)aTableView 
       acceptDrop:(id < NSDraggingInfo >)info 
              row:(NSInteger)row 
    dropOperation:(NSTableViewDropOperation)operation{

  return NO; 
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (NSDragOperation)tableView:(NSTableView *)aTableView 
                validateDrop:(id < NSDraggingInfo >)info 
                 proposedRow:(NSInteger)row 
       proposedDropOperation:(NSTableViewDropOperation)operation {
  
	return NSDragOperationNone;

  
}


@end
