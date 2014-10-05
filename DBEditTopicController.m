/*
 
 Episodic Notes: A personal wiki, note taking app for Mac OSX. Create notes through any application on your computer and keep them in one place.
 
 Copyright (C) 2014. Dante Bortone
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 */

// would be nice to correct historyArray to remove two topics in a row after merging or deleting a topic....

//---------------------------------------------
#import "DBEditTopicController.h"
//---------------------------------------------

#import "DBDetail.h"
#import "DBDetailController.h"
#import "DBDetailOutlineViewController.h"
#import "DBOutlineView.h"
#import "DBOutlineViewDelegate.h"
#import "DBDetailOutlineViewController.h"
#import "DBDetailOutlineViewDelegate.h"
#import "DBControllerOfOutlineViews.h"
#import "DBTopicObject.h"
#import "DBWikiWord.h"
#import "DBWikiWordController.h"
#import "NoteTaker_AppDelegate.h"
#import "NSArray_Extensions.h"
#import "NSNumber_Extensions.h"
#import "DBDetailViewController.h"
#import "DBViewObject.h"
#import "DBHyperlinkEditor.h"
#import "DBHeaderOrganizer.h"
#import "DBSubTopic.h"
#import "DBLocalWiki.h"
#import "DBGlobalWiki.h"
#import "DBMainTopic.h"
#import "DBTopicOutlineViewController.h"
#import "DBCalendarController.h"
#import "DBUndoManager.h"

//---------------------------------------------


@implementation DBEditTopicController

@synthesize topicToEdit;
@synthesize warningFieldLabel;


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) awakeFromNib {
  
  [ super awakeFromNib ];

  detailController = appDelegate.detailController;
  controllerOfOutlineViews = appDelegate.controllerOfOutlineViews;
  managedObjectContext = appDelegate.managedObjectContext;
  
  NSPredicate * namePredicate;
  NSMutableArray * subPredicates;
  NSPredicate * combinedPredicate;

  NSString * name = @"DBNamedObject";
  namePredicate = [NSPredicate predicateWithFormat:@"className CONTAINS[cd] %@", name ];
  
  
  subPredicates = [ NSMutableArray array ];
  [ subPredicates addObject:namePredicate ];
  //[subPredicates addObject:globalPredicate];
  combinedPredicate = [ NSCompoundPredicate andPredicateWithSubpredicates:subPredicates ];
  
  [ editTopicArrayController setFetchPredicate: combinedPredicate ];

  [ self resetPanel ];
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) beginEditingTopic: ( DBTopicObject * ) topic
{
  
  self.topicToEdit = topic;
  
  [ self openPanel ];
  
}



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (BOOL) validateNewName: (NSString * ) newName
{
 
  newName = [ newName stringByTrimmingCharactersInSet:[ NSCharacterSet whitespaceAndNewlineCharacterSet ]];
  
  
  if ([newName isEqualToString:@""]) {
    
    [ warningFieldLabel setStringValue:@"No entry." ];
    
    [ makeChangeBtn setEnabled: NO ];
    
    return NO;
    
  } else if ([newName isEqualToString:self.topicToEdit.displayName]){

    [ warningFieldLabel setStringValue:@"Name unchanged." ];

    [ makeChangeBtn setEnabled: NO ];
    
    return NO;
    
  } else {
    
    NSString *wikiWordString = [[newName stringByReplacingOccurrencesOfString:@" " withString:@""] lowercaseString];


    if (topicToEdit.isGlobal) {
      
      //Summary
      // 1) if primary wiki word wouldn't change it's okay
      // 2) make sure the NAME is unique for all topics
      // 3) make sure the wikiWordString is unique for all topics
      
      // 1) if primary wiki word wouldn't change it's okay
      DBGlobalWiki * globalWikiWord = [(DBMainTopic *)topicToEdit primaryWikiWord];
      NSString * topicToEditCurrentWikiWordString = [globalWikiWord word];
      if ([wikiWordString isEqualToString:[topicToEditCurrentWikiWordString lowercaseString]]) {
        
        [ warningFieldLabel setStringValue:@"Valid name." ];
        
        [ makeChangeBtn setEnabled: YES ];
        
        return YES;
      }
    
      // 2) make sure the NAME is unique for all topics
      if ([detailController findMainTopicWithName:newName usingUserPreferences:YES]){
        
        [ warningFieldLabel setStringValue:@"Name taken by another topic." ];
        
        [ makeChangeBtn setEnabled: NO ];

        return NO;

      } else {
        
        // 3) make sure the wikiWordString is unique
        if ([appDelegate.hyperlinkEditor wikiWordFromString:wikiWordString]) {
          
          [ warningFieldLabel setStringValue:@"Derrived WikiWord is taken." ];
          
          [ makeChangeBtn setEnabled: NO ];
          
          return NO;
        }
        
        [ warningFieldLabel setStringValue:@"Valid name." ];
        
        [ makeChangeBtn setEnabled: YES ];
        
        return YES;
      }
      
      
    } else { // a local topic
      
      //Summary
      // 1) if primary wiki word wouldn't change it's okay
      // 2) make sure the wikiWordString is unique for all global wiki words
      // 3) make sure the wikiWordString is unique for all local wiki words
      
      
      // 1) if primary wiki word wouldn't change it's okay
          // just making a variation (spacing or capitalization) of itsown name
      DBLocalWiki * localWikiWord = [(DBSubTopic *)topicToEdit primaryWikiWord];
      
      NSString * topicToEditCurrentWikiWordString = [localWikiWord word];
      if ([wikiWordString isEqualToString:[topicToEditCurrentWikiWordString lowercaseString]]) {
        
        [ warningFieldLabel setStringValue:@"Valid name." ];
        
        [ makeChangeBtn setEnabled: YES ];
        
        return YES;
      }
      
      // 2) make sure the wikiWordString is unique for all global wiki words
      if ([appDelegate.hyperlinkEditor globalWikiWordsIncludesString:wikiWordString]) {
        
        [ warningFieldLabel setStringValue:@"Local topic WikiWord is taken." ];
        
        [ makeChangeBtn setEnabled: NO ];
        
        return NO;
        
      } else {
        
        // 3) make sure the wikiWordString is unique for all local wiki words

        DBLocalWiki * localWikiWord = [appDelegate.wikiWordController localWikiWordWithString:wikiWordString inTopic:[(DBSubTopic*)topicToEdit mainTopic]];

        if (localWikiWord) {
          
          [ warningFieldLabel setStringValue:@"Local topic WikiWord is taken." ];
          
          [ makeChangeBtn setEnabled: NO ];
          
          return NO;
          
        }
        
        [ warningFieldLabel setStringValue:@"Valid name." ];
        
        [ makeChangeBtn setEnabled: YES ];
        
        return YES;
        
      }

    } // else a local topic
  
  }
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) orderOutPanel{
  
  [myWindow orderOut:myWindow];
  
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) openPanel

{
  
  [ actionTypeMatrix selectCellAtRow:0 column:0 ];
  
  [ newNameField setEnabled: YES ];
  [ newNameLabel setTextColor: [NSColor blackColor] ];
  
  //fill comboBoxArray editTopicArrayController
  //  needs to have all MainTopics and SubTopics
  
  [editTopicArrayController setContent:[self fetchMainAndSubtopics]];
  
  [topicComboBox selectItemWithObjectValue:topicToEdit.formattedName];
  
  
  [ newNameField setStringValue:topicToEdit.displayName ];
  [ self validateNewName: [ newNameField stringValue ] ];
  [ warningFieldLabel setStringValue:@""];
  [ myWindow makeKeyAndOrderFront: myWindow ];
  
}



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------


-(NSArray *)fetchMainAndSubtopics {
  
  NSPredicate* predicate;
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];

  
  
  NSEntityDescription *entity = [NSEntityDescription entityForName:@"NamedTopic"
                                            inManagedObjectContext:managedObjectContext];
  
  [fetchRequest setPredicate:predicate];
  [fetchRequest setEntity:entity];
  //[fetchRequest setSortDescriptors:@[aliasSorter]];
  
  NSError *error;
  
  NSMutableArray * topics = [NSMutableArray arrayWithArray:[managedObjectContext executeFetchRequest:fetchRequest error:&error]];
  
  entity = [NSEntityDescription entityForName:@"SubTopic"
                                            inManagedObjectContext:managedObjectContext];
  [fetchRequest setEntity:entity];
  

  [topics addObjectsFromArray:[managedObjectContext executeFetchRequest:fetchRequest error:&error]];

  topics = [ NSMutableArray arrayWithArray:[topics sortedArrayUsingComparator:^(DBTopicObject *o1, DBTopicObject *o2) {
    NSString *str1 = o1.formattedName;
    NSString *str2 = o2.formattedName;
    
    return [str1 compare:str2 options:NSCaseInsensitiveSearch];
  }]];
  
  //NSSortDescriptor * sortDescriptor;
  //sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"formattedName" ascending:YES];
  
  //[topics sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
  
  return topics;

}



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void)comboBoxSelectionDidChange:(NSNotification *)notification{
  
  if ([topicComboBox objectValueOfSelectedItem]) {
    
    
    NSInteger index = [topicComboBox indexOfSelectedItem];
    topicToEdit = [[editTopicArrayController arrangedObjects] objectAtIndex:index];
    
    //NSLog(@"topicToEdit: %@", topicToEdit.displayName);
    
    [newNameField setStringValue:topicToEdit.displayName];
  }
  
}



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) resetPanel {
  
  //[ newNameField setStringValue:@"" ];
  [ warningFieldLabel setStringValue:@"" ];

}


#pragma mark -
#pragma mark Button actions

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (IBAction)openPanelFromMenu:(id)sender
{
  
  
  // set a topic to the active view's topic
  //  !! can't edit a date or file name...
  
  DBTopicObject * potentialTopicToEdit = controllerOfOutlineViews.activeDetailOutlineViewController.mainDetailViewController.managedViewObject.viewTopic;
  
  if ( [potentialTopicToEdit isKindOfClass:[DBMainTopic class]] || [potentialTopicToEdit isKindOfClass:[DBSubTopic class]]){
    
    topicToEdit = potentialTopicToEdit;
  
  }
  
  [self openPanel];
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (IBAction)cancel:(id)sender
{

  [self orderOutPanel];
  
}



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

 
- (IBAction)editTopic:(id)sender
{
  
  [ warningFieldLabel setStringValue:@"" ];

  [ newNameField setEnabled: YES ];
  [ newNameLabel setTextColor: [NSColor blackColor] ];

  
  [ self validateNewName: [newNameField stringValue ] ];
  
}



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (IBAction)deleteTopic:(id)sender
{

  [ warningFieldLabel setStringValue:@"Warning: topic deletion cannot be undone." ];
  
  [ newNameField setEnabled: NO ];
  [ newNameLabel setTextColor: [NSColor grayColor] ];

  
  [ makeChangeBtn setEnabled: YES ];
  
}



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (IBAction)makeChange:(id)sender
{
  NSButtonCell * selectedCell = (NSButtonCell * )[ actionTypeMatrix selectedCell ];
  NSString * selectedString = [ selectedCell title ];
  
  if ([selectedString isEqualToString:@"Rename"]){

    [appDelegate.undoManager makeUndoable];
    

    NSString * newName = [newNameField stringValue];
    topicToEdit.displayName = newName;

    NSString * newPrimaryWikiWord = [newName stringByReplacingOccurrencesOfString:@" " withString:@""];

    if (topicToEdit.isGlobal) {
      
      [[(DBMainTopic *)topicToEdit primaryWikiWord] setWord:newPrimaryWikiWord];

      [appDelegate.hyperlinkEditor updateGlobalWikiWordStrings];

    } else {
      
      [[(DBSubTopic *)topicToEdit primaryWikiWord] setWord:newPrimaryWikiWord];
      
    }
    
    // update titles of detail views if needed
    
    for (DBDetailViewController * detailViewController in controllerOfOutlineViews.detailViewControllerArray ) {
      if (detailViewController.managedViewObject.viewTopic == topicToEdit){
        
        [detailViewController setHeader:topicToEdit];
        
      }
      
    }
    
    [appDelegate.undoManager stopMakingUndoable];

    
  } else if ([selectedString isEqualToString:@"Delete"]) { 
    
    // don't want to set this up for undo yet.  undo topic deletions will be a mess
    
    [(DBUndoManager*)managedObjectContext.undoManager makeUndoable];

    [self deleteTopic];
    [(DBUndoManager*)managedObjectContext.undoManager stopMakingUndoable];

    
  }
  
  [appDelegate.controllerOfOutlineViews.topicOutlineViewController.view reloadData];
  
  [ self orderOutPanel ];

}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) removeFromViews:(DBTopicObject*)topicToRemove{
  
  //NSLog(@"removing topic from views: %@", topicToRemove.displayName );
  
  for (DBDetailViewController * controller in controllerOfOutlineViews.detailViewControllerArray) {
    
    //DBDetailOutlineViewDelegate *delegate = (DBDetailOutlineViewDelegate*) controller.primaryOutlineViewController.delegate;
    
    // count number of times topicToEdit is at or before current index
    NSArray *indexArray = [ controller.historyArray indexesOfObject:topicToEdit
                                                     below:([controller.historyIndex integerValue] + 1 )];
    
    // remove topicToEdit from navigation array
    [ controller.historyArray removeObject:topicToEdit ];
    
    //should check for duplicates in navagation array here:
    //  abcb  (delete c)
    //  abb   (instead of ab)
    
    // if the deleted item was at or before the currently selected item
    if (indexArray.count>0) {
      
      // adjust the history index
      controller.historyIndex = [controller.historyIndex decrementBy:indexArray.count];
      
      //  check if the deleted topic was the viewTopic
      if ( controller.managedViewObject.viewTopic == topicToEdit ){
        
        // if there were no items before the deleted item
        if ((long)[controller.historyIndex integerValue] == -1){
          
          //if the array isn't empty
          if (controller.historyArray.count > 0){
            //select the first item
            controller.historyIndex = [NSNumber numberWithInt:0];
            [controller loadTopicFromIndex:0];
            
          }  else {  //  array is empty
            //NSLog(@"assigning date topic");
            
            DBDateTopic * dateTopic = [appDelegate.calendarController topicAtDate:[NSDate date]];
            
            if ( dateTopic == NULL ) {
              
              dateTopic = [appDelegate.detailController newDateTopicAtDate:[NSDate date] ];
              
            }
            
            [controller assignTopic:(DBTopicObject*)dateTopic];
            
          }
          
        }  else {  //  there is item preceeding deleted item.
          
          //  select item at new history index
          [controller loadTopicFromIndex:[controller.historyIndex integerValue]];
          
        }  //  else
        
      }  //  end if ( delegate.viewTopic == topicToEdit ){
      
    }
    
  }  //  end for

  
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void)deleteTopic {
  
  [self removeFromViews: topicToEdit];
  
  if (topicToEdit.isGlobal) {
    for (DBSubTopic * subTopic in [(DBMainTopic*)topicToEdit subTopics]) {
      
      [self removeFromViews: subTopic];
      [ managedObjectContext deleteObject:subTopic ];
    }
  }

  [ managedObjectContext deleteObject:topicToEdit ];  // Cascade will take care of rest
  
  [ managedObjectContext processPendingChanges ];
  
  [ appDelegate.wikiWordController.myOutlineView reloadData ];

  [ controllerOfOutlineViews updateRelatedContent ];

  self.topicToEdit = NULL; //updates title on editTopicPanel
  
}

@end
