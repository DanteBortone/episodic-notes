//
//  DBSubTopicController.m
//  NoteTaker
//
//  Created by Dante on 11/17/13.
//
//

//---------------------------------------------
#import "DBSubTopicController.h"
//---------------------------------------------
#import "DBHeaderOrganizer.h"
#import "NoteTaker_AppDelegate.h"
#import "DBDetailController.h"
#import "DBLocalWiki.h"
#import "DBHyperlinkEditor.h"
#import "DBControllerOfOutlineViews.h"
#import "DBTopicOutlineViewController.h"
#import "DBSubTopic.h"
#import "DBMainTopic.h"
#import "DBGlobalWiki.h"
#import "DBOutlineView.h"
#import "DBWikiWordController.h"

@implementation DBSubTopicController



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(void) awakeFromNib{
  
  [super awakeFromNib];
  [self resetPanel];
  
}



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(IBAction)createSubTopic:(id)sender{
  
  if (openedFromNavigation) {
    
    [self makeSubTopicUsingNavigation];
    
  } else {
    
    [self makeSubTopicWithoutNavigation];
    
  }
  
  //NSLog(@"created subtopic");
  [appDelegate.wikiWordController.myOutlineView reloadData];
  
}

-(void)makeSubTopicWithoutNavigation
{
  
  NSLog(@"makeSubTopicWithoutNavigation: %@", selectedTopic.displayName);
  
  NSString *name = [inputField stringValue];
  
  DBMainTopic * mainTopic = (DBMainTopic*)selectedTopic;
  
  DBSubTopic * newSubTopic = [NSEntityDescription insertNewObjectForEntityForName:@"SubTopic"
                                                           inManagedObjectContext:appDelegate.managedObjectContext];
  [newSubTopic setMainTopic:mainTopic];
  
  [newSubTopic setDisplayName: name];
  
  // remove spaces and other characters from wikiword name
  name = [ name stringByReplacingOccurrencesOfString:@" " withString:@""];
  
  DBLocalWiki * localWikiWord = [appDelegate.wikiWordController newLocalWikiWord:name withTopic:newSubTopic];
  
  localWikiWord.isPrimary = [NSNumber numberWithBool:YES];
  
  NSNumber * sortIndex = [NSNumber numberWithInteger: mainTopic.subTopics.count * 10]; //put it at the end
  
  NSMutableArray * headerArray = [NSMutableArray arrayWithArray:[mainTopic.headers allObjects]];
  BOOL moreThanOneHeader = NO;
  for (DBHeaderOrganizer * header in headerArray) {
    DBHeaderOrganizer * subHeader = [appDelegate.detailController newHeaderOrganizerWithTopic:newSubTopic];
    [ subHeader setIsLeaf: [NSNumber numberWithBool:YES ] ];
    [ subHeader setSortIndex:sortIndex];  // needs to be set before parent header so it goes in the right order
    [ subHeader setParent:header ];
    moreThanOneHeader = YES;
  }
  
  [self closePanel];
  
}



-(void)makeSubTopicUsingNavigation
{
  
  NSString *name = [inputField stringValue];
  
  DBMainTopic * mainTopic = (DBMainTopic*)mainTopicHeader.topic;
  
  DBSubTopic * newSubTopic = [NSEntityDescription insertNewObjectForEntityForName:@"SubTopic"
                                                           inManagedObjectContext:appDelegate.managedObjectContext];
  
  [newSubTopic setMainTopic:mainTopic];
  
  [newSubTopic setDisplayName: name];
  
  // remove spaces and other characters from wikiword name
  name = [ name stringByReplacingOccurrencesOfString:@" " withString:@""];
  
  DBLocalWiki * localWikiWord = [appDelegate.wikiWordController newLocalWikiWord:name withTopic:newSubTopic];
  
  
  localWikiWord.isPrimary = [NSNumber numberWithBool:YES];
  
  
  BOOL insertAsSubGroup = selectedTopic.isGlobal;
  
  
  DBHeaderOrganizer * newTopicHeader = [appDelegate.detailController newHeaderOrganizerWithTopic:newSubTopic];
  [ newTopicHeader setIsLeaf: [NSNumber numberWithBool:YES ] ];
  
  // with a three finger drag off the window the selection is dropped and this subtopic inserts into the root folder; need to reassign selection index paths
  DBTopicOutlineViewController * topicOutlineViewController = appDelegate.controllerOfOutlineViews.topicOutlineViewController;
  [topicOutlineViewController.tree setSelectionIndexPaths: selectionIndexPaths];
  
  [appDelegate.detailController insert:newTopicHeader withViewController:topicOutlineViewController asSubGroup:insertAsSubGroup enterEditMode:NO andSelectAllText:NO];
  
  NSMutableArray * headerArray = [NSMutableArray arrayWithArray:[mainTopic.headers allObjects]];
  [headerArray removeObject:mainTopicHeader];
  BOOL moreThanOneHeader = NO;
  for (DBHeaderOrganizer * header in headerArray) {
    DBHeaderOrganizer * subHeader = [appDelegate.detailController newHeaderOrganizerWithTopic:newSubTopic];
    [ subHeader setIsLeaf: [NSNumber numberWithBool:YES ] ];
    [ subHeader setSortIndex:newTopicHeader.sortIndex];  // needs to be set before parent header so it goes in the righ order
    [ subHeader setParent:header ];
    moreThanOneHeader = YES;
  }
  
  [self closePanel];
  
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) copySubTopicsFrom: (DBMainTopic*)templateTopic
                        to: (DBMainTopic*)targetTopic
               withDetails: (BOOL) withDetails{
  
  //need to copy subTopics
  for (DBSubTopic * templateSubTopic in templateTopic.subTopics ) {
    DBSubTopic * copiedSubTopic = [NSEntityDescription insertNewObjectForEntityForName:@"SubTopic"
                                                                inManagedObjectContext:appDelegate.managedObjectContext];
    
    [copiedSubTopic setMainTopic:targetTopic];
    
    [copiedSubTopic setDisplayName: templateSubTopic.displayName];
    
    [self copyLocalWikiWordsFrom:templateSubTopic to:copiedSubTopic];
    
    if (withDetails) {
      
      [appDelegate.detailController copySubGroupsFrom:templateSubTopic toParent:copiedSubTopic];
      
    }
    
  }
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) copyLocalWikiWordsFrom: (DBSubTopic*) templateTopic
                             to: (DBSubTopic*) targetTopic
{
  
  for (DBLocalWiki * localWiki in templateTopic.wikiWords) {
    
    DBLocalWiki * copiedWikiWord = [self newLocalWikiWordNamed:localWiki.word];
    copiedWikiWord.topic = targetTopic;
    
  }
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (DBLocalWiki*)newLocalWikiWordNamed:(NSString *)name {
  
  DBLocalWiki * localWikiWord = [NSEntityDescription insertNewObjectForEntityForName:@"LocalWiki"
                                                              inManagedObjectContext:appDelegate.managedObjectContext];
  
  [localWikiWord setWord:name];
  
  return localWikiWord;
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- ( void) openPanel // from navigation button
{
  openedFromNavigation = YES;
  
  //get the selected objects to restore value before insertion
  selectionIndexPaths = appDelegate.controllerOfOutlineViews.topicOutlineViewController.tree.selectionIndexPaths;
  
  DBOrganizerObject * selectedObject;
  
  NSArray * selectedObjects = [appDelegate.controllerOfOutlineViews.topicOutlineViewController.tree selectedObjects];
  
  if (selectedObjects.count > 0) {
    selectedObject = [selectedObjects objectAtIndex:0];
  }
  
  if (selectedObject) {
    //NSLog(@"selected object is: %@", selectedObject.displayName);
    
    if ([selectedObject isKindOfClass:[DBHeaderOrganizer class]]) {
      
      [self topicViewSelectionChangedTo:(DBHeaderOrganizer *)selectedObject];
      
      [super openPanel];
      
    }
    
  }
  
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

// need to make this topic without using the topic folder navigation view
// this method will be accessed through "Add Local Wiki Topic" in drop down menu
// combines openPanel & topicViewSelectionChangedTo: methods
// but doesn't need header information
- ( void) openPanelWithTopic:(DBMainTopic*) mainTopic // NOT from navigation button
{
  openedFromNavigation = NO;// to be used by createSubTopic to know if the
  
  selectedTopic = mainTopic;
  
  mainTopicHeader = NULL;
  
  [mainTopicLabel setStringValue:mainTopic.displayName];
  
  [super openPanel];
  
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) topicViewSelectionChangedTo:(DBHeaderOrganizer *) organizer{
  
  //NSLog(@"topicViewSelectionChangedTo");
  
  [self resetPanel];
  
  selectedTopic = organizer.topic;  //could be local or global
  
  //if (selectedTopic) {
  
  //NSLog(@"selectedTopic: %@", selectedTopic.displayName);
  
  DBHeaderOrganizer * header = organizer;
  
  if (! header.topic.isGlobal) header = (DBHeaderOrganizer*)header.parent;
  
  mainTopicHeader = header;  //always a global
  
  [mainTopicLabel setStringValue:header.topic.displayName];
  
  //}
  
}



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(void) resetPanel{
  
  [warningFieldLabel setStringValue:@""];
  [outputWikiField setStringValue:@""];
  [inputField setStringValue:@""];
  [mainTopicLabel setStringValue:@""];
  
}


// check no entry
// check equal to global wikiwords
// check equal to local wikiwords



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) validateSubTopicName: (NSString *) name {
  
  if (myWindow.delegate == NULL) NSLog(@"no delegate");
  
  BOOL isValid = NO;
  
  name = [ name stringByTrimmingCharactersInSet:[ NSCharacterSet whitespaceAndNewlineCharacterSet ]];
  name = [ name stringByReplacingOccurrencesOfString:@" " withString:@""];
  
  outputWikiField.stringValue = name;
  
  
  if ([name isEqualToString:@""]) {
    
    [ warningFieldLabel setStringValue:@"No entry." ];
    
  } else {
    
    // check name against hyperlink string array
    
    DBGlobalWiki *globalWiki = [appDelegate.hyperlinkEditor globalWikiFromString:name];
    
    if (globalWiki) {
      
      [ warningFieldLabel setStringValue: [NSString stringWithFormat:@"WikiWord in use by main topic: %@",globalWiki.topic.displayName]];
      
    } else {//if ([self localWikiWordsIncludesString:name]){
      
      //NSLog(@"main topic header: %@", mainTopicHeader.topic.displayName);
      DBLocalWiki * localWikiWord = [appDelegate.wikiWordController localWikiWordWithString:name inTopic:(DBMainTopic *)mainTopicHeader.topic];
      
      
      if (localWikiWord) {
        
        [ warningFieldLabel setStringValue:@"Name in use by a local topic."];
        
      } else {
        
        [ warningFieldLabel setStringValue:@"Valid topic name." ];
        
        isValid = YES;
      }
    }
  }
  
  [ addButton setEnabled: isValid ];
  
}



@end
