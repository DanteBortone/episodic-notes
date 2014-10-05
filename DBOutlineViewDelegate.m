/*
 
 Episodic Notes: A personal wiki, note taking app for Mac OSX. Create notes through any application on your computer and keep them in one place.
 
 Copyright (C) 2014. Dante Bortone
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 */


//---------------------------------------------
#import "DBOutlineViewDelegate.h"
//---------------------------------------------

#import "DBDetailOutlineViewController.h"
#import "DBHeaderOrganizer.h"
#import "DBHyperlinkEditor.h"
#import "DBOutlineView.h"
#import "NoteTaker_AppDelegate.h"

#import "DBDetailOutlineViewController.h"
#import "DBTableCellTextView.h"
#import "DBTextViewCell.h"
#import "DBSubTopicController.h"
#import "DBControllerOfOutlineViews.h"
#import "DBDetailViewController.h"
#import "DBTopicObject.h"
// debugging
#import "DBDetail.h"
#import "NSString_Extensions.h"

//---------------------------------------------


@implementation DBOutlineViewDelegate 

@synthesize controller;
@synthesize event;


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) awakeFromNib {//this code isn't activated if it's not in the nib!!!!!!!!

  appDelegate = (NoteTaker_AppDelegate *)[[NSApplication sharedApplication] delegate];
  controllerOfOutlineViews = appDelegate.controllerOfOutlineViews;
  hyperlinkEditor = appDelegate.hyperlinkEditor;
  
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (id)init{

  if (self = [super init]) {
    
    appDelegate = (NoteTaker_AppDelegate *)[[NSApplication sharedApplication] delegate];
    controllerOfOutlineViews = appDelegate.controllerOfOutlineViews;
    hyperlinkEditor = appDelegate.hyperlinkEditor;
    
  }
  
  return self;

}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void)outlineViewItemDidCollapse:(NSNotification *)notification
{
  
  DBManagedTreeObject *collapsedItem = [[[notification userInfo] valueForKey:@"NSObject"] representedObject];
  
	collapsedItem.isExpanded = [NSNumber numberWithBool:NO]; 

}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void)outlineViewItemDidExpand:(NSNotification *)notification
{

  DBManagedTreeObject *expandedItem = [[[notification userInfo] valueForKey:@"NSObject"] representedObject];
	
  expandedItem.isExpanded = [NSNumber numberWithBool:YES];

}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

// both topic and detail views use this to put the row into edit mode if it needs to be
- (void)outlineViewSelectionDidChange:(NSNotification *)notification
{
  BOOL validSelection = (controller.tree.selectedObjects.count > 0);
  
  if (validSelection) {
    
    id selection = [controller.tree.selectedObjects objectAtIndex:0];
    
    // -------- < for debugging > --------
    /*DBManagedTreeObject * selectedObject = selection;
    
    if ([selectedObject isKindOfClass:[DBDetail class]]) {
      
      //DBTopicObject * topic = [selectedObject valueForKey:@"topic"];
      NSLog(@"%@ sort index: %li", selectedObject.displayName, [selectedObject.sortIndex integerValue]);

      
    }*/
    // -------- < / for debugging > --------
    
    
    if ([selection isKindOfClass:[DBHeaderOrganizer class]]) {

      DBTopicObject * selectedTopic = [(DBHeaderOrganizer *)selection topic];
      
      if (selectedTopic) {
        
        //NSLog(@"outlineViewSelectionDidChange: selectedTopic: %@", selectedTopic.displayName);
      
        [[controllerOfOutlineViews.activeDetailOutlineViewController mainDetailViewController] assignTopic:selectedTopic];
      
      }
    
    } else {
      
      BOOL isDetailViewController = NO;
      
      if ([controller isKindOfClass:[DBDetailOutlineViewController class]]) isDetailViewController = YES;

      // enter edit mode and select text
      if ([self.event containsString:@"enterEditMode"]) {

        NSInteger selectedRow = [self.controller.view selectedRow];
        NSInteger outlineColumn = [self.controller.view columnWithIdentifier:@"Detail"];
        
        [self.controller.view editColumn:outlineColumn row: selectedRow withEvent:nil select:YES];
        
        if (isDetailViewController) {
          
          DBTableCellTextView * cellView = [controller.view viewAtColumn:outlineColumn row:selectedRow makeIfNecessary:NO];
          
          DBTextViewCell * textView = cellView.textView;
          //NSLog(@"event: %@", self.event);
          if ([self.event isEqualToString:@"enterEditModeAndSelectAllText"]){
          
            [textView setSelectedRange:NSMakeRange(0, textView.textStorage.length)];
          
          } else if ([self.event isEqualToString:@"enterEditMode"]){
          
            [textView moveToEndOfLine:nil];
          
          }
          
        }
        
        self.event = NULL;

      }
      
    }
    
  }
  
}

@end
