//
//  DBTopicOutlineViewDelegate.m
//  NoteTaker
//
//  Created by Dante Bortone with Copyright on 7/6/12.
//  Copyright 2012 UNC-Chapel Hill. All rights reserved.
//
//---------------------------------------------
#import "DBTopicOutlineViewDelegate.h"
//---------------------------------------------
#import "DBOrganizerObject.h"
#import "DBDetailOutlineViewController.h"
#import "DBDetailOutlineViewDelegate.h"
#import "DBControllerOfOutlineViews.h"
#import "DBOutlineViewDelegate.h"
#import "DBTopicOutlineViewController.h"
#import "DBWikiWordController.h"
#import "NoteTaker_AppDelegate.h"
#import "NSTreeController_Extensions.h"
#import "DBDetailViewController.h"
#import "DBTopicTableRowView.h"
#import "DBOutlineView.h"
#import "DBFolderOrganizer.h"
#import "DBTopicObject.h"

@implementation DBTopicOutlineViewDelegate


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (NSView*)outlineView:(DBOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(id)item{
  
  //  item is a NSTreeNode
  //NSLog(@"viewForTableColumn");

  NSString *identifier = [tableColumn identifier];
  
  if ([identifier isEqualToString:@"Main"]) {

    DBOrganizerObject * organizer = [item representedObject];
    
    NSTableCellView * cellView = [outlineView makeViewWithIdentifier:@"TopicCellView" owner:self];
    NSTextField * textField = cellView.textField;
    //[textField setTextColor:[NSColor blackColor]];

    if (organizer) {
        [textField bind:NSValueBinding
                       toObject:organizer
                    withKeyPath:@"displayName"
                        options:(@{
                                 NSContinuouslyUpdatesValueBindingOption : @YES })];
      
      
      NSString *theImageName;
        
      if([organizer isKindOfClass:[DBFolderOrganizer class]]){
        [textField setEditable:YES];

        theImageName = @"GenericFolderIcon.png";
      } else {

        [textField setEditable:NO];
        DBTopicObject * topicObject = [organizer valueForKey:@"topic"];
        
        
        if (topicObject.isGlobal) {
          theImageName = @"global.pdf";
        } else {
          theImageName = @"local.pdf";
        }
      }
      
      NSImage *theImage = [NSImage imageNamed: theImageName];
      [cellView.imageView setImage:theImage];
      
    }
    
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
