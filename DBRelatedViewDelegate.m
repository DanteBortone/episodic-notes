//
//  DBRelatedViewDelegate.m
//  NoteTaker
//
//  Created by Dante on 6/8/13.
//
//


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
//#import "DBHyperlinkEditor.h"
//#import "DBDetail.h"


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
