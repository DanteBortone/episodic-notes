//
//  DBWikiController.m
//  NoteTaker
//
//  Created by Dante on 2/27/13.
//
//


//---------------------------------------------
#import "DBWikiWordController.h"
//---------------------------------------------
#import "DBHyperlinkEditor.h"
#import "DBOutlineView.h"
#import "DBOutlineViewDelegate.h"
#import "DBControllerOfOutlineViews.h"
#import "DBTopicObject.h"
#import "DBTopicOutlineViewController.h"
#import "DBWikiWord.h"
#import "NoteTaker_AppDelegate.h"
#import "NSTreeController_Extensions.h"
#import "DBGlobalWiki.h"
#import "DBLocalWiki.h"
#import "DBMainTopic.h"
#import "DBSubTopic.h"
#import "DBUndoManager.h"
#import "DBUndoRedoPanel.h"

@implementation DBWikiWordController 

@synthesize wikiWordWindow;
@synthesize mySearchField;

@synthesize wikiWordArrayController;
@synthesize wikiWordField;
@synthesize addWarningField;
@synthesize removeWarningField;
@synthesize addButton;
@synthesize topicTreeController;
@synthesize myOutlineView;



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void)awakeFromNib {
  
  //hyperlinkEditor = appDelegate.hyperlinkEditor;
  controllerOfOutlineViews = appDelegate.controllerOfOutlineViews;
  [ super awakeFromNib ];
  [addWarningField setStringValue:@""];
  [addWarningField setStringValue:@""];
  
  
  undoManager = (DBUndoManager*)appDelegate.managedObjectContext.undoManager;

}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void)controlTextDidEndEditing: (NSNotification *)aNotification {

  NSPredicate *aPredicate = nil;
  
  if ([[[self mySearchField] stringValue] isEqualToString:@""]) {
    aPredicate = NULL;
  } else {
    aPredicate = [NSPredicate predicateWithFormat:@"displayName contains[cd] %@", [[self mySearchField] stringValue]];
  }
  
  [[self topicTreeController] setFetchPredicate: aPredicate];
  [[self myOutlineView] reloadData];

}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------


- (DBGlobalWiki *)newGlobalWikiWord {
  
  return [NSEntityDescription insertNewObjectForEntityForName:@"GlobalWiki"
                                       inManagedObjectContext:appDelegate.managedObjectContext];
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (DBLocalWiki *)newLocalWikiWord {
  
  return [NSEntityDescription insertNewObjectForEntityForName:@"LocalWiki"
                                       inManagedObjectContext:appDelegate.managedObjectContext];
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (DBGlobalWiki *) newGlobalWikiWord:(NSString *)string withTopic:(DBMainTopic *)topicObject {
  DBGlobalWiki * wikiWord;
  
  wikiWord = [self newGlobalWikiWord];
  wikiWord.word = string;
  
  wikiWord.topic = topicObject;
    
  [appDelegate.hyperlinkEditor updateGlobalWikiWordStrings];
  
  return wikiWord;
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (DBLocalWiki *) newLocalWikiWord:(NSString *)string withTopic:(DBSubTopic *)topicObject {

  DBLocalWiki * wikiWord = [self newLocalWikiWord];
  
  wikiWord.word = string;
  
  wikiWord.topic = topicObject;
  
  [appDelegate.hyperlinkEditor updateGlobalWikiWordStrings];
  
  return wikiWord;
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (IBAction)toggleWikiWordWindow:(id)sender{
  
  if ([wikiWordWindow isVisible]){
    
    [wikiWordWindow orderOut:wikiWordWindow];
    
  } else {
    
    [wikiWordWindow makeKeyAndOrderFront:wikiWordWindow];
    
  }
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (IBAction)addWikiWord:(id)sender{
  
  [undoManager makeUndoable];
  
  DBTopicObject * topic  = [[topicTreeController selectedObjects] objectAtIndex:0];
  
  
  //NSLog(@"add wiki word");
  NSString * word;
  
  word = wikiWordField.stringValue;

  if (topic.isGlobal) {
    
    [self newGlobalWikiWord:word withTopic:(DBMainTopic *)topic];

  } else {
    
    [self newLocalWikiWord:word withTopic:(DBSubTopic *)topic];
    
  }
  
  //[self newGlobalWikiWord:word withTopic:topic];
  // tried:
  //     - running it through wikiword entity
  //     - adding wikiWord to topic and visa versa
  // some kvo isn't getting notified, but I don't know where
  
  [ controllerOfOutlineViews updateRelatedContent ];
  
  [ controllerOfOutlineViews reloadDetailViews ];

  [wikiWordField setStringValue:@""];

  [appDelegate.hyperlinkEditor updateGlobalWikiWordStrings];
  
  [undoManager stopMakingUndoable];
}



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (IBAction)removeWikiWord:(id)sender{
  
  [undoManager makeUndoable];

  //DBTopicObject * topic  = [[[topicTreeController selectedObjects] objectAtIndex:0] representedObject];

  NSArray * selectedObjects = wikiWordArrayController.selectedObjects;
  
  //for (int i=0; i<selectedObjects.count; i+=1) {
  for (DBWikiWord * word in selectedObjects){
    
    [word setValue:NULL forKey:@"topic"];
    ////[topic removeWikiWord:word];
    
    [appDelegate.managedObjectContext deleteObject:word];

  }

  [ controllerOfOutlineViews updateRelatedContent ];

  [ controllerOfOutlineViews reloadDetailViews ];
  
  [appDelegate.hyperlinkEditor updateGlobalWikiWordStrings];

  [undoManager stopMakingUndoable];

}



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (BOOL) validateWikiWordName: (NSString *) word {

  BOOL validWordName = NO;

  
  NSArray * array = [topicTreeController selectedObjects];
  
  if (array.count > 0) {
      
    
    DBTopicObject * topic  = [[topicTreeController selectedObjects] objectAtIndex:0];

    
    word = [ word stringByTrimmingCharactersInSet:[ NSCharacterSet whitespaceAndNewlineCharacterSet ]];
    
    if ([word isEqualToString:@""]) {
      
      [ addWarningField setStringValue:@"No entry." ];
      
    } else {
      
      if (topic.isGlobal) {
        
        DBWikiWord *wikiWord = [appDelegate.hyperlinkEditor wikiWordFromString:word];
        
        if (wikiWord) {
          
          if (wikiWord.isGlobal) {
            
            DBMainTopic * conflictingWikiTopic =[(DBGlobalWiki*)wikiWord topic];
            [ addWarningField setStringValue: [NSString stringWithFormat:@"In use by topic: %@", conflictingWikiTopic.displayName]];

          } else {
            
            DBSubTopic * conflictingWikiSubTopic =[(DBLocalWiki*)wikiWord topic];
            DBMainTopic * parentTopic = conflictingWikiSubTopic.mainTopic;
            
            [ addWarningField setStringValue: [NSString stringWithFormat:@"In use by subtopic: %@.%@", parentTopic.displayName,conflictingWikiSubTopic.displayName]];
            
          }
                  
        } else { //no wikiword by this name
          
          [ addWarningField setStringValue:@"Valid WikiWord name." ];
          
          validWordName = YES;
          
        }
        
      } else { //it's a local topic
     
      //make sure it's not a global
        DBGlobalWiki *globalWikiWord = [appDelegate.hyperlinkEditor globalWikiFromString:word];

        if (globalWikiWord) {
          
          DBMainTopic * conflictingWikiTopic =[(DBGlobalWiki*)globalWikiWord topic];
          [ addWarningField setStringValue: [NSString stringWithFormat:@"In use by topic: %@", conflictingWikiTopic.displayName]];

        } else {
          
          DBLocalWiki * localWikiWord = [self localWikiWordWithString:word inTopic:[(DBSubTopic *)topic mainTopic]];
          
          if (localWikiWord) {
            
            [ addWarningField setStringValue: [NSString stringWithFormat:@"In use by subtopic: %@.%@", localWikiWord.topic.mainTopic.displayName,localWikiWord.topic.displayName]];
            
          } else {
            
            [ addWarningField setStringValue:@"Valid WikiWord name." ];
            validWordName = YES;
            
          }
          
        }
      
      }
      
    }
      
  }
  
  [ addButton setEnabled: validWordName ];
  
  return validWordName;
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (DBLocalWiki *) localWikiWordWithString:(NSString *)string inTopic: (DBMainTopic *) topic{
  
  string = [string lowercaseString];
  
  NSSet * subTopicSiblings = [topic subTopics];
    
  for (DBTopicObject * subTopic in subTopicSiblings) {
    
    NSArray * wikiWords = [[(DBSubTopic *)subTopic wikiWords] allObjects];
    
    for (DBLocalWiki * wikiWord in wikiWords) {
      
      //NSLog(@"test wikiword: %@ against %@", [wikiWord.word lowercaseString], string );
      
      if ([[wikiWord.word lowercaseString] isEqualToString: string]) {
        
        return wikiWord;
        
      }
      
    }
    
  }
  
  return NULL;
  
}


@end
