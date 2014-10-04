//
//  DBTopicMenuDelegate.m
//  Episodic Notes
//
//  Created by Dante Bortone on 6/28/14.
//
//

#import "DBTopicMenuDelegate.h"

#import "DBOutlineView.h"
#import "DBOutlineViewController.h"
#import "DBOrganizerObject.h"
#import "DBDetailController.h"
#import "DBHeaderOrganizer.h"
#import "DBEditTopicController.h"
#import "DBFolderOrganizer.h"
#import "DBTopicObject.h"

@implementation DBTopicMenuDelegate

@synthesize tableView;


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void)awakeFromNib {
  
  //appDelegate = (NoteTaker_AppDelegate *)[[NSApplication sharedApplication] delegate];
  //controllerOfOutlineViews = appDelegate.controllerOfOutlineViews;
  //aliasController = appDelegate.aliasController;
  //calendarController = appDelegate.calendarController;
  
  myMenu = [[NSMenu alloc] initWithTitle:@""];
  [myMenu setAutoenablesItems:NO];
  
  myMenu.delegate = self;
  
  [self.tableView setMenu:myMenu];
  
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void)menuWillOpen:(NSMenu *)menu {
  
  NSLog(@"menuWillOpen");

  [myMenu removeAllItems];

  
  // when table view first loads I can't get it to select programatically.  if a row is selected then clicking the buttons doesn't work unless we go through a programatic selection
  if ( [ tableView selectedRow] > -1 ) {
    
    NSIndexSet * indexSet = [NSIndexSet indexSetWithIndex:[tableView clickedRow]];
    
    [tableView selectRowIndexes:indexSet byExtendingSelection:NO];  //doesn't work on first load
    
  } else {
    
    NSEvent *click = [NSEvent mouseEventWithType:NSLeftMouseDown location:[NSEvent mouseLocation] modifierFlags:NULL timestamp:1 windowNumber:NULL context:NULL eventNumber:NULL clickCount:1 pressure:(float)1.0];
    
    [tableView mouseDown:click];
    
    //select the row first and then load data off selectedDetail
    
    NSTreeNode * clickedNode = [tableView itemAtRow:[tableView clickedRow]];
    
    [tableView.controller.tree setSelectionIndexPath:[clickedNode indexPath]];
    
  }
  
  DBOrganizerObject *selectedObject;
  if (tableView.controller.tree.selectedObjects.count > 0) {
    selectedObject = [tableView.controller.tree.selectedObjects objectAtIndex:0];
  } else {
    selectedObject = NULL;
  }
  
  
  NSMenuItem *insertFolderItem = [[NSMenuItem alloc] initWithTitle:@"Insert folder"
                                                       action:@selector(insertFolder:)
                                                keyEquivalent:@""];
  insertFolderItem.target = detailController;
  [myMenu addItem:insertFolderItem];
  [insertFolderItem setState:NSOffState];

  
  NSMenuItem *insertTopicItem = [[NSMenuItem alloc] initWithTitle:@"Insert topic"
                                                           action:@selector(toggleAddTopicWindow:)
                                                    keyEquivalent:@""];
  insertTopicItem.target = addTopicController;
  [myMenu addItem:insertTopicItem];
  [insertFolderItem setState:NSOffState];
  
  if ([selectedObject isKindOfClass:[DBHeaderOrganizer class]]) {
    
    
    NSMenuItem *insertTopicItem = [[NSMenuItem alloc] initWithTitle:@"New subtopic"
                                                             action:@selector(toggleWindow:)
                                                      keyEquivalent:@""];
    insertTopicItem.target = subTopicController;
    [myMenu addItem:insertTopicItem];
    [insertFolderItem setState:NSOffState];
    
    
  
    NSMenuItem *editDeleteItem = [[NSMenuItem alloc] initWithTitle:@"Edit/delete..."
                                                             action:@selector(beginEditingTopic:)
                                                      keyEquivalent:@""];
    editDeleteItem.target = self;
    editDeleteItem.representedObject = [(DBHeaderOrganizer*)selectedObject topic];
    [myMenu addItem:editDeleteItem];
    [editDeleteItem setState:NSOffState];
  
  }
  
  if ([selectedObject isKindOfClass:[DBFolderOrganizer class]]) {
    
    NSMenuItem *removeFolderItem = [[NSMenuItem alloc] initWithTitle:@"Delete folder"
                                                            action:@selector(removeFromFolderView:)
                                                     keyEquivalent:@""];
    removeFolderItem.target = detailController;
    [myMenu addItem:removeFolderItem];
    [removeFolderItem setState:NSOffState];
  
  } else if ([selectedObject isKindOfClass:[DBHeaderOrganizer class]]){
    
    DBTopicObject * topic = [(DBHeaderOrganizer*)selectedObject topic];
    
    if ([topic isGlobal]) {
      
      NSMenuItem *removeTopicItem = [[NSMenuItem alloc] initWithTitle:@"Remove topic from view"
                                                          action:@selector(removeFromFolderView:)
                                                   keyEquivalent:@""];
      removeTopicItem.target = detailController;
      [myMenu addItem:removeTopicItem];
      [removeTopicItem setState:NSOffState];
      
      
    }
    
  }

  
}


-(void) beginEditingTopic: (id) sender
{
 
  DBTopicObject * topicToEdit = [sender representedObject];
  
  [editTopicController beginEditingTopic:topicToEdit];

  
}


@end
