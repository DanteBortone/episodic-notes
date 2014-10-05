/*
 
 Episodic Notes: A personal wiki, note taking app for Mac OSX. Create notes through any application on your computer and keep them in one place.
 
 Copyright (C) 2014. Dante Bortone
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 */


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

//---------------------------------------------


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
