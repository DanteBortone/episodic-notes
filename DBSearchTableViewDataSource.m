//
//  DBSearchTableViewController.m
//  NoteTaker
//
//  Created by Dante Bortone with Copyright on 7/29/12.
//  Copyright 2012 UNC-Chapel Hill. All rights reserved.
//


//---------------------------------------------
#import "DBSearchTableViewDataSource.h"
//---------------------------------------------
#import "DBControllerOfOutlineViews.h"
#import "DBSearchController.h"
#import "NoteTaker_AppDelegate.h"
#import "DBManagedTreeObject.h"

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
