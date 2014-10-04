//
//  DBNewTopicController.m
//  NoteTaker
//
//  Created by Dante on 3/3/13.
//
//

//---------------------------------------------
#import "DBAddTopicController.h"
//---------------------------------------------
#import "DBDetailController.h"
#import "DBNamedTopic.h"
#import "DBObjectController.h"
#import "DBTopicOutlineViewController.h"
#import "DBDetailOutlineViewDelegate.h"
#import "DBDetailOutlineViewController.h"
#import "DBControllerOfOutlineViews.h"
#import "DBWikiWordController.h"
#import "NoteTaker_AppDelegate.h"
#import "NSString_Extensions.h"
#import "DBDetailViewController.h"
#import "DBOrganizerObject.h"
#import "DBFolderOrganizer.h"
#import "DBSubTopic.h"
#import "DBHeaderOrganizer.h"
#import "DBHyperlinkEditor.h"
#import "DBGlobalWiki.h"
#import "DBSubTopicController.h"
#import "DBDetail.h"
#import "DBUndoManager.h"

@implementation DBAddTopicController

@synthesize topicListComboBox;


// -------------------------------------------------------------------------------

// awakeFromNib

// -------------------------------------------------------------------------------

- (void) awakeFromNib
{

  [super awakeFromNib];
  [addTopicWindow setDelegate:self];
  [ self resetPanel];
  detailController = appDelegate.detailController;
  controllerOfOutlineViews = appDelegate.controllerOfOutlineViews;
  
  [addTopicWindow setDelegate:self];
  
  [ self togglePanelOptionDisplay:NULL];
  
  NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
  
  [nc addObserver:self
         selector:@selector(applicationDidFinishLaunching:)
             name:@"applicationDidFinishLaunching"
           object:nil ];
  
}


// -------------------------------------------------------------------------------

// applicationDidFinishLaunching:

// -------------------------------------------------------------------------------

- (void) applicationDidFinishLaunching:(NSNotification *) notification
{

  [self initNoTopicItems]; //checkboxes don't comply if this is done at awakeFromNib
  
}


// -------------------------------------------------------------------------------

// toggleAddTopicWindow:

// -------------------------------------------------------------------------------

- (IBAction)toggleAddTopicWindow:(id)sender{
  
  if ([addTopicWindow isVisible]){
    
    [self orderOutPanel];

  } else {
    
    [ self openPanel ];
    
  }
  
  
}


// -------------------------------------------------------------------------------

// openPanel

// -------------------------------------------------------------------------------

-(void) openPanel
{
  
  [addTopicWindow makeKeyAndOrderFront:addTopicWindow];

}



// -------------------------------------------------------------------------------

// validateComboBoxEntry

// -------------------------------------------------------------------------------

-  (NSInteger)validateComboBoxEntry
{
  
  return [ self validateMainTopicName: topicListComboBox.stringValue ];
  
}



// -------------------------------------------------------------------------------

// validateMainTopicName:

// -------------------------------------------------------------------------------

// return values
//   0 for invalid topics
//   1 for valid new topic
//   2 for existing topic

-  (NSInteger)validateMainTopicName: (NSString *)partialString
{
  
  NSString * proposedWikiWord = [ partialString stringByReplacingOccurrencesOfString:@" " withString:@""];
  
  [outputWikiField setStringValue:proposedWikiWord];

  
  if ([partialString isEqualToString:@""]) {
    //NSLog(@"no entry");
    [ warningFieldLabel setStringValue:@"No entry." ];

    [self initNoTopicItems];
    
    return 0;
    
    // if partial string is a topic then activate items relevant to adding existing topic
    
  } else if ([detailController findMainTopicWithName:partialString usingUserPreferences:YES]){
    [ warningFieldLabel setStringValue:@"Topic already exists." ];
    [ self initExistingTopicItems ];
    
    return 2;
    
  } else if ([detailController findSubTopicWithName:partialString usingUserPreferences:YES]){
     [ warningFieldLabel setStringValue:@"Topic matches a local topic name." ];
     [self initNoTopicItems];
    
    return 0;
    
  } else if ([appDelegate.hyperlinkEditor wikiWordFromString:proposedWikiWord]){
    
    [ warningFieldLabel setStringValue:@"Derived WikiWord is already in use." ];
    [self initNoTopicItems];
    
    return 0;
    
  } else {

    [ warningFieldLabel setStringValue:@"Novel topic name." ];

    [self initNovelTopicItems];
    
    return 1;
    
  }
  
}


// -------------------------------------------------------------------------------

// cancelNewTopic

// -------------------------------------------------------------------------------

- (IBAction)cancelNewTopic:(id)sender
{
  
  [self orderOutPanel];

}

// -------------------------------------------------------------------------------

// insertAsSubGroup

// -------------------------------------------------------------------------------

-(BOOL) insertAsSubGroup
{
  
  // if the topiccontroller is selecting a folder do it as a subgroup other ust insert
  
  NSArray * array = [appDelegate.controllerOfOutlineViews.topicOutlineViewController.tree selectedObjects];
  
  if (array.count > 0) {
    
    DBOrganizerObject * organizer = [array objectAtIndex:0];
    
    if ([organizer isKindOfClass:[DBFolderOrganizer class]]){
      
      return YES;
      
    } else {
      
      return NO;
      
    }
    
  } else {
    
    return NO;
    
  }
  
}


// -------------------------------------------------------------------------------

// addNovelTopic:

// -------------------------------------------------------------------------------

- (IBAction)addNovelTopic:(id)sender
{
  //[appDelegate.undoManager makeUndoable]; // undo here is a mess. the viewer will be left with an orphined topic
  
  NSString *topicName = [[topicListComboBox stringValue] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
  
  DBNamedTopic *newTopic = [detailController newNamedTopic];
  newTopic.displayName = topicName;

  //copies subGroups of template if one is selected
  if ([templateComboBox objectValueOfSelectedItem]){
    
    NSInteger selectionIndex = [templateComboBox indexOfSelectedItem];
    DBMainTopic *selectedTopic = [[topicTemplateArrayController arrangedObjects] objectAtIndex:selectionIndex];
    
    [detailController copySubGroupsFrom:selectedTopic toParent:newTopic];
    
    [appDelegate.subTopicController copySubTopicsFrom:selectedTopic to:newTopic withDetails:YES];
    
  }
  
  //make primary wikiword for topic...
  NSString * wikiString = [topicName stringByReplacingOccurrencesOfString:@" " withString:@""];
  DBGlobalWiki * newGlobalWikiword = [appDelegate.wikiWordController newGlobalWikiWord:wikiString withTopic:newTopic];
  [newGlobalWikiword setIsPrimary:[NSNumber numberWithBool:YES]];
  
  [self insertAddedTopic:newTopic];
  
  //[appDelegate.undoManager stopMakingUndoable];

}


// -------------------------------------------------------------------------------

// insertAddedTopic:

// -------------------------------------------------------------------------------

-(void) insertAddedTopic:(DBMainTopic*)newTopic
{
  
  NSInteger choiceIndex = [[NSUserDefaults standardUserDefaults] integerForKey:@"insertTopicOptions"];
  // 0) as wikiword 1) into folder view

  
  if (choiceIndex == 0){
  
    [ self insertAsWikiWord:newTopic ];
    
  } else {

    [ self insertIntoFolderView:newTopic ];

    
  }
  
  [self orderOutPanel];

}


// -------------------------------------------------------------------------------

// insertAsWikiWord:

// -------------------------------------------------------------------------------

-(void) insertAsWikiWord:(DBMainTopic*)topic
{
  
  //NSLog(@"DBAddTopicController:insertAsWikiWord");
  
  DBDetailOutlineViewController * viewController = [appDelegate.controllerOfOutlineViews targetViewControllerForLinks];

  DBDetail * wikiDetail = [detailController newDetail];
  wikiDetail.displayName = topic.primaryWikiWord.word;
  wikiDetail.topic = viewController.viewTopic;

  [appDelegate.detailController insert:wikiDetail withViewController:viewController asSubGroup:NO enterEditMode:YES andSelectAllText:YES];
  
}

// -------------------------------------------------------------------------------

// insertIntoFolderView:

// -------------------------------------------------------------------------------

-(void) insertIntoFolderView:(DBMainTopic*) topic{
  
  DBHeaderOrganizer *headerOrganizer = [detailController newHeaderOrganizerWithTopic:topic];
  
  [detailController insert:(DBManagedTreeObject*)headerOrganizer withViewController:appDelegate.controllerOfOutlineViews.topicOutlineViewController asSubGroup:[self insertAsSubGroup] enterEditMode:NO andSelectAllText:NO];
  
  // if this globlTopic has subTopics then we need to add them
  for (DBSubTopic * subTopic in topic.subTopics) {
    DBHeaderOrganizer *subTopicHeader = [detailController newHeaderOrganizerWithTopic:subTopic];
    subTopicHeader.sortIndex = subTopic.sortIndex;
    subTopicHeader.parent = headerOrganizer;
  }
  
  
}

// -------------------------------------------------------------------------------

// addExistingTopic:

// -------------------------------------------------------------------------------

- (IBAction)addExistingTopic:(id)sender
{
  //[appDelegate.undoManager makeUndoable]; // undos here mess up viewer

  //add existing
  // insert as wikiword enabled
  // insert as into nav enabled
  
  
  NSInteger selectionIndex;
  DBMainTopic * selectedTopic;
//  DBHeaderOrganizer * headerOrganizer;

  selectionIndex = [topicListComboBox indexOfSelectedItem];
  selectedTopic = [[topicArrayController arrangedObjects] objectAtIndex:selectionIndex];

  [self insertAddedTopic:selectedTopic];
  
  //[appDelegate.undoManager stopMakingUndoable];

}



// -------------------------------------------------------------------------------

// windowWillClose:

// -------------------------------------------------------------------------------

- (void)windowWillClose:(NSNotification *)notification
{
  
  [self resetPanel];
  
}

// -------------------------------------------------------------------------------

// orderOutPanel

// -------------------------------------------------------------------------------

- (void) orderOutPanel
{
  
  [addTopicWindow orderOut:addTopicWindow];
  [self resetPanel];
  
}

// -------------------------------------------------------------------------------

// initExistingTopicItems

// -------------------------------------------------------------------------------

-(void) initExistingTopicItems
{
  
  NSColor * novelAddColor = [NSColor grayColor];

  [addTopicButton setEnabled:YES];

  //items needed for inserting existing topic
  //[existingTopicButton setEnabled:YES];
  
  //items needed for adding novel topic
  //[novelTopicButton setEnabled:NO];
  [templateComboBox setEnabled:NO];
  [templateLabel setTextColor:novelAddColor];

  //items needed for novel and existing topic
  [insertOptions setEnabled:YES];
  //[self enableInsertOptions: YES];

  //[optionsLabel setTextColor:[NSColor blackColor]];
  [insertLabel setTextColor:[NSColor blackColor]];

}

// -------------------------------------------------------------------------------

// initNovelTopicItems

// -------------------------------------------------------------------------------

-(void) initNovelTopicItems
{
  [addTopicButton setEnabled:YES];

  NSColor * novelAddColor = [NSColor blackColor];
  
  //items needed for inserting existing topic
  //[existingTopicButton setEnabled:NO];
  
  //items needed for adding novel topic
  //[novelTopicButton setEnabled:YES];
  
  
  [templateComboBox setEnabled:YES];
  [templateLabel setTextColor:novelAddColor];

  //items needed for novel and existing topic
  [insertOptions setEnabled:YES];
  //[self enableInsertOptions: YES];

  //[optionsLabel setTextColor:novelAddColor];
  [insertLabel setTextColor:novelAddColor];

}

// -------------------------------------------------------------------------------

// initNoTopicItems

// -------------------------------------------------------------------------------

-(void) initNoTopicItems  //for initial settings and no text entered
{
  //NSLog(@"initNoTopicItems");
  
  [addTopicButton setEnabled:NO];

  NSColor * novelAddColor = [NSColor grayColor];

  //items needed for inserting existing topic
  //[existingTopicButton setEnabled:NO];
  
  //items needed for adding novel topic
  //[novelTopicButton setEnabled:NO];
  
  
  
  [templateComboBox setEnabled:NO];
  [templateLabel setTextColor:novelAddColor];

  
  //items needed for novel and existing topic
  [insertOptions setEnabled:NO];
  //[self enableInsertOptions: NO];
  [insertLabel setTextColor:novelAddColor];
  //[optionsLabel setTextColor:novelAddColor];

}



// -------------------------------------------------------------------------------

// resetPanel

// -------------------------------------------------------------------------------

- (void) resetPanel
{
  
  [warningFieldLabel setStringValue:@""];
  [outputWikiField setStringValue:@""];
  [topicListComboBox setStringValue:@""];
  [templateComboBox setStringValue:@""];
  [self initNoTopicItems];
  
}


#pragma mark -
#pragma mark Booleans

// -------------------------------------------------------------------------------

// loadNewTopicIntoActiveView

// -------------------------------------------------------------------------------

- (BOOL) loadNewTopicIntoActiveView
{

  return [[NSUserDefaults standardUserDefaults] boolForKey: @"loadNewTopicIntoActiveView"];

}

// -------------------------------------------------------------------------------

// insertNewTopicAfterAdd

// -------------------------------------------------------------------------------

- (BOOL) insertNewTopicAfterAdd
{
  
  return [[NSUserDefaults standardUserDefaults] boolForKey:@"insertNewTopicAfterAdd"];
  
}


// -------------------------------------------------------------------------------

// insertNewTopicAsWikiWord

// -------------------------------------------------------------------------------

- (BOOL) insertNewTopicAsWikiWord
{
  
  return [[NSUserDefaults standardUserDefaults] boolForKey:@"insertNewTopicAsWikiWord"];
  
}

// -------------------------------------------------------------------------------

// windowDidResignKey:

// -------------------------------------------------------------------------------

- (void)windowDidResignKey:(NSNotification *)notification
{
  
  //NSLog(@"windowDidResignKey");
  [self orderOutPanel];
  
}


// -------------------------------------------------------------------------------

// togglePanelOptions:

// -------------------------------------------------------------------------------

- (IBAction) togglePanelOptionDisplay: (id)sender
{
  
  //NSView * contentView = addTopicWindow.contentView;
  NSRect frame = addTopicWindow.frame;

  float expandedHeight = 314;
  float collapsedHeight = 169;

  float titleBarHeight = 16;
  float heightDisplacement =expandedHeight - collapsedHeight;
  
  if ([[NSUserDefaults standardUserDefaults] boolForKey:@"showAddTopicOptions"]) {
    
    frame = NSMakeRect(frame.origin.x, frame.origin.y - heightDisplacement, frame.size.width, 314 + titleBarHeight);
    
  } else {
    
    frame = NSMakeRect(frame.origin.x, frame.origin.y + heightDisplacement, frame.size.width, 169 + titleBarHeight);

  }

  [ addTopicWindow setFrame:frame display:YES];
  
}



// -------------------------------------------------------------------------------

// addTopic:

// -------------------------------------------------------------------------------

- (IBAction) addTopic:(id) sender
{
  // should be disabled if the name is invalid (empty or matches a wikiword or subtopic)

  NSInteger addType = [self validateMainTopicName:[topicListComboBox stringValue]];
  
  if (addType == 1) {             // add novel topic
    
    [ self addNovelTopic: NULL ];
    
  } else if (addType == 2){       // add existing topic
  
    [ self addExistingTopic: NULL ];
    
  } else {
    
    NSLog(@"Null topic. Add button should have been disabled.");

  }

  
  
}


@end
