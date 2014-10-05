/*
 
 Episodic Notes: A personal wiki, note taking app for Mac OSX. Create notes through any application on your computer and keep them in one place.
 
 Copyright (C) 2014. Dante Bortone
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 */


//---------------------------------------------
#import "DBRelatedViewDelegate.h"
//---------------------------------------------

#import "DBDetail.h"
#import "DBDetailOutlineViewController.h"
#import "DBDetailOutlineViewController.h"
#import "DBDetailOutlineViewDelegate.h"
#import "DBDetailViewController.h"
#import "DBHyperlinkEditor.h"
#import "DBRelatedOutlineViewController.h"
#import "DBViewObject.h"
#import "NoteTaker_AppDelegate.h"
#import "DBTopicTableRowView.h"
#import "DBTableCellTextView.h"
#import "DBOutlineView.h"
#import "DBRelatedTextViewCell.h"

//---------------------------------------------


@implementation DBRelatedViewDelegate


//don't want to have related view modifications change the open/close state of objects
- (void)outlineViewItemDidCollapse:(NSNotification *)notification {}
- (void)outlineViewItemDidExpand:(NSNotification *)notification{}



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

// sets selected object of view

- (void)outlineViewSelectionDidChange:(NSNotification *)notification {
/*
  NSLog(@"DBRelatedViewDelegate:outlineViewSelectionDidChange");
  
  NSArray * selectedObjects;
  DBDetailViewController * mainDetailViewController;
  
  mainDetailViewController = [(DBRelatedOutlineViewController*)(self.controller) mainDetailViewController];

  if (mainDetailViewController.managedViewObject.viewTopic) {
    
    selectedObjects = [self.controller.tree selectedObjects];
    
    if (selectedObjects.count > 0) {
      
      mainDetailViewController.selectedDetail = [selectedObjects objectAtIndex:0];//this should be changed to mainDetailViewController after the selectedDetail moves

      [hyperlinkEditor addHyperlinksTo:[mainDetailViewController noteView]];
      //20130907 [hyperlinkEditor addHyperlinksTo:[mainDetailViewController nameView]];
      
    } else {
      
      mainDetailViewController.selectedDetail = NULL;
      
    }
    
  }
*/
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

// this sets the hyperlink of the view cells on initial load
// see DBTextViewCellDelegate for changing value while typing

- (NSView*)outlineView:(DBOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(id)item{
  
  
  //  FYI: item is a NSTreeNode
  
  NSString *identifier = [tableColumn identifier];
  // possible values: Detail, Topic, Date
    
  DBDetail * detail = [item representedObject];
    
  if ([identifier isEqualToString:@"Detail"]) {
    
    DBTableCellTextView * cellView = [outlineView makeViewWithIdentifier:@"RelatedDetailCellView" owner:self];
    
    DBRelatedTextViewCell * textView = (DBRelatedTextViewCell *) cellView.textView;
    
    if (detail) {
      [textView bind:NSAttributedStringBinding
                     toObject:detail
                  withKeyPath:@"displayName"
                      options:(@{
                               NSValueTransformerNameBindingOption :@"DBAttributedStringTransformer",
                               NSContinuouslyUpdatesValueBindingOption : @YES })];
    }
    
    [hyperlinkEditor addHyperlinksToEntireTextOf:textView withRespectTo:detail.topic];
    
    return cellView;
  
  } else if ([identifier isEqualToString:@"Topic"]){
    
    DBTableCellTextView * cellView = [outlineView makeViewWithIdentifier:@"RelatedTopicCellView" owner:self];
    
    DBRelatedTextViewCell * textView = (DBRelatedTextViewCell *) cellView.textView;
    
    if (detail) {
      [textView bind:NSAttributedStringBinding
            toObject:detail
         withKeyPath:@"topic"
             options:(@{
                      NSValueTransformerNameBindingOption :@"DBTopicNameTransformer",
                      NSContinuouslyUpdatesValueBindingOption : @YES })];

      
    } //RelatedDateCellView
    
    [hyperlinkEditor addModelLinksTo:textView];//will tell mouseDown event in DBRelatedOutlineView to figure the target of the lnk out based on the model.
    
    return cellView;
    
  } else {
    
    return NULL;
    
  }
  
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(NSTableRowView *)outlineView:(DBOutlineView *)outlineView rowViewForItem:(id)item{
  //NSLog(@"rowViewForItem");
  
  return [[DBTopicTableRowView alloc] init];
  
}

@end
