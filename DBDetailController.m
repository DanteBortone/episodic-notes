/*
 
 Episodic Notes: A personal wiki, note taking app for Mac OSX. Create notes through any application on your computer and keep them in one place.
 
 Copyright (C) 2014. Dante Bortone
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 */


//---------------------------------------------
#import "DBDetailController.h"
//---------------------------------------------

#import "DBAliasController.h"
#import "DBCalendarController.h"
#import "DBDateTopic.h"
#import "DBDetail.h"
#import "DBFileTopic.h"
#import "DBFolderOrganizer.h"
#import "DBHeaderOrganizer.h"
#import "DBNamedTopic.h"
#import "DBObjectController.h"
#import "DBOutlineView.h"
#import "DBOutlineViewDelegate.h"
#import "DBDetailOutlineViewController.h"
#import "DBDetailOutlineViewDelegate.h"
#import "DBControllerOfOutlineViews.h"
#import "DBTopicObject.h"
#import "DBTopicOutlineViewController.h"
#import "NoteTaker_AppDelegate.h"
#import "NSDate_Extensions.h"
#import "NSIndexPath_Extensions.h"
#import "NSTreeNode_Extensions.h"
#import "NSNumber_Extensions.h"
#import "NSString_Extensions.h"
#import "NSTreeController_Extensions.h"
#import "DBDetailViewController.h"
#import "DBApplescriptController.h"
#import "DBDetailOutlineView.h"
#import "DBDataToImageTransformer.h"
#import "DBViewObject.h"
#import "DBSubTopic.h"
#import "DBObjectClipboard.h"
#import "DBOutlineViewController.h"
#import "DBUndoManager.h"

//---------------------------------------------


@implementation DBDetailController

@synthesize dividerOptions;
@synthesize addExistingTopic;
@synthesize addTopicComboBox;
@synthesize topicArrayController;
@synthesize objectClipboard;


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void)awakeFromNib {	 

  [ super awakeFromNib ];

  managedObjectContext = appDelegate.managedObjectContext;
  
  calendarController = appDelegate.calendarController;  
  controllerOfOutlineViews = appDelegate.controllerOfOutlineViews;
  
  undoManager = (DBUndoManager*)managedObjectContext.undoManager;
  
  [ self setUpObjectClipboard ];
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) setUpObjectClipboard {
  
  //there should only be one clipboard
  // lets find it and set the objectClipboarad to that one object
  // if it doesn't exist then we'll create it
  
  NSFetchRequest *fetchAllClipboards = [[NSFetchRequest alloc] init];
  [fetchAllClipboards setEntity:[NSEntityDescription entityForName:@"ObjectClipboard" inManagedObjectContext:managedObjectContext]];
  
  NSError *error = nil;
  
  NSArray *clipboards = [managedObjectContext executeFetchRequest:fetchAllClipboards error:&error];
  
  
  if (clipboards.count == 1) {
    
    objectClipboard = [clipboards objectAtIndex:0];
    
  } else if (clipboards.count == 0) {
    
    //make a clipboard
    // this should only happen on the first run
    objectClipboard = [NSEntityDescription insertNewObjectForEntityForName:@"ObjectClipboard"
                                  inManagedObjectContext:managedObjectContext];
    
  } else if (clipboards.count >1) {
    
    objectClipboard = [clipboards objectAtIndex:0];

    NSLog(@"DBDetailController : setUpObjectClipboard - found more than one clipboard.");
    
  }
  
  
}



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (NSArray *)ascendingSortDescriptor;
{
  
  NSSortDescriptor *sorter = [[NSSortDescriptor alloc]
                               initWithKey:@"displayName"
                               ascending:YES
                               selector:@selector(localizedCaseInsensitiveCompare:)];
  
	return [NSArray arrayWithObject:sorter];
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (NSArray *)azSortDescriptor;
{
  
  NSSortDescriptor *sorter = [[NSSortDescriptor alloc]
                              initWithKey:@"displayName"
                              ascending:YES
                              selector:@selector(localizedCaseInsensitiveCompare:)];
  
	return [NSArray arrayWithObject:sorter];
}



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (NSArray *)zaSortDescriptor;
{
  
  NSSortDescriptor *sorter = [[NSSortDescriptor alloc]
                              initWithKey:@"displayName"
                              ascending:NO
                              selector:@selector(localizedCaseInsensitiveCompare:)];
  
	return [NSArray arrayWithObject:sorter];
  
}



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------
// should just be in dbdetail.
// when you change the topic of an object you automatically change the topic of it's subgroups
- (void) assignDetailAndSubGroupsOf:(DBDetail *)detail toTopic:(DBTopicObject*)topic
{
  
  //crashes here
  
  NSArray * array = [NSArray arrayWithArray:[detail flattenedWithSubGroups]];
  
  for (DBDetail * detail in array){
    
    detail.topic = topic;
    
  }
  
  
}



// -------------------------------------------------------------------------------

// copyDetailWithSubGroups: toParent:

// -------------------------------------------------------------------------------

- (DBDetail *) copyDetailWithSubGroups:(DBDetail *)originalObject
                                  toParent:(DBDetail *)parent
{
  
  DBDetail * copiedObject;
  
  copiedObject = [self newDetail];
  
  // Attributes
  copiedObject.displayName = originalObject.displayName;
  copiedObject.isExpanded = originalObject.isExpanded;
  //copiedObject.isLeaf = originalObject.isLeaf;
  copiedObject.sortIndex = originalObject.sortIndex;
  copiedObject.dateAssociated = originalObject.dateAssociated;
  copiedObject.dateCreated = [NSDate date];
  copiedObject.dateModified = [NSDate date];
  copiedObject.isChecked = originalObject.isChecked;
  copiedObject.note = originalObject.note;
  copiedObject.outputValue = originalObject.outputValue;
  copiedObject.image = originalObject.image;
  copiedObject.showSubGroupChecks = originalObject.showSubGroupChecks;
  copiedObject.sourceFile = originalObject.sourceFile;
  // topic value is changed in DBOutlineviewDataSource
  copiedObject.outputScript = originalObject.outputScript;
  
  
  // Relationships
  copiedObject.parent = parent;
  
  for (id subGroup in [originalObject valueForKey:@"subGroups"]){
    [self copyDetailWithSubGroups:subGroup toParent:copiedObject];//this returns copied object, but it's not used
  }
  
  return copiedObject;

}



// -------------------------------------------------------------------------------

// copyOrganizerAsDetailWithSubGroups: toParent:

// -------------------------------------------------------------------------------

- (DBDetail *) copyOrganizerAsDetailWithSubGroups:(DBOrganizerObject *)originalObject
                                          toParent:(DBDetail *)parent
{
  
  DBDetail * copiedObject = [self newDetail];

  [ copiedObject doneInitializing ]; // we can't set the date changes unless we unlock this
  
  // Set attributes

  NSDate * now = [NSDate date];
  copiedObject.dateCreated = now;
  copiedObject.dateAssociated = now;
  copiedObject.dateModified = now;

  if ([originalObject isKindOfClass:[DBFolderOrganizer class]]) {

    copiedObject.displayName = originalObject.displayName;

  } else {
    
    // it represents a topic and need to put wiki word as display name
    DBTopicObject * topic = [ originalObject valueForKey:@"topic" ];
    
    copiedObject.displayName = [topic wikiString];
    
  }
  
  
  
  copiedObject.isExpanded = originalObject.isExpanded;
  copiedObject.sortIndex = originalObject.sortIndex;

  // Relationships
  copiedObject.parent = parent;

  for (id subGroup in [originalObject valueForKey:@"subGroups"]){
    
    [self copyOrganizerAsDetailWithSubGroups:subGroup toParent:copiedObject];//this returns copied object, but it's not used
  
  }

  return copiedObject;

}


// -------------------------------------------------------------------------------

// copyOrganizerWithSubGroups: toParent:

// -------------------------------------------------------------------------------

- (DBOrganizerObject *) copyOrganizerWithSubGroups:(DBOrganizerObject *)originalObject
                              toParent:(DBOrganizerObject *)parent
{
  
  DBOrganizerObject * copiedObject;
  
  // isOnClipboard default value is NO
  
  if ( [ originalObject isKindOfClass:[ DBFolderOrganizer class ] ] ) {

    copiedObject = [self newFolderOrganizer];
    
  } else {
    
    copiedObject = [self newHeaderOrganizer];

    [copiedObject setValue:[originalObject valueForKey: @"topic"] forKey:@"topic"];

  }
  
  // Attributes
  copiedObject.displayName = originalObject.displayName;
  copiedObject.isExpanded = originalObject.isExpanded;
  copiedObject.sortIndex = originalObject.sortIndex;
  
  // Relationships
  copiedObject.parent = parent;
  
  for (id subGroup in [originalObject valueForKey:@"subGroups"]){
    [self copyOrganizerWithSubGroups:subGroup toParent:copiedObject];//this returns copied object, but it's not used
  }
  
  return copiedObject;
  
}


// -------------------------------------------------------------------------------

// copySubGroupsFrom: toParent:

// -------------------------------------------------------------------------------

//needed to copy details of template topic for new topic

- (void) copySubGroupsFrom:(DBTopicObject *)templateTopic
                  toParent:(DBTopicObject *)newTopic
{
  
  DBDetail * copiedDetail;
  NSSet * rootSet;
  
  rootSet = [NSSet setWithSet:[templateTopic rootSet]];
  
  for (DBDetail * detail in rootSet){
    
    copiedDetail = [self copyDetailWithSubGroups:detail toParent:NULL];
    [self assignDetailAndSubGroupsOf:copiedDetail toTopic:newTopic];
    
  }

}



#pragma mark -
#pragma mark Create Objects

// -------------------------------------------------------------------------------

// newDateTopicAtDate:

// -------------------------------------------------------------------------------

- (DBDateTopic * ) newDateTopicAtDate:(NSDate *)selectedDate
{
  
  DBDateTopic * dateTopic;
  
  dateTopic = [self newDateTopic];
  
  
  [dateTopic setValue:[selectedDate startOfDay] forKey:@"date"];
  
  [dateTopic setValue:[selectedDate topicString] forKey:@"displayName"];
  
  return dateTopic;
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (DBNamedTopic * ) newNamedTopic
{
  
  DBNamedTopic *topic = [NSEntityDescription insertNewObjectForEntityForName:@"NamedTopic"
                                                              inManagedObjectContext:managedObjectContext];
  return topic;
  
}



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (DBDateTopic * ) newDateTopic
{
  
  DBDateTopic *topic = [NSEntityDescription insertNewObjectForEntityForName:@"DateTopic"
                                                              inManagedObjectContext:managedObjectContext];
  return topic;
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (DBFolderOrganizer*)newFolderOrganizer
{
  
  DBFolderOrganizer *newObject = [NSEntityDescription insertNewObjectForEntityForName:@"FolderOrganizer"
                                                           inManagedObjectContext:managedObjectContext];
  [newObject setValue:@"topic folder" forKey:@"displayName"];
  
  return newObject;
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (DBHeaderOrganizer*)newHeaderOrganizer
{
  
  DBHeaderOrganizer *newObject = [NSEntityDescription insertNewObjectForEntityForName:@"HeaderOrganizer"
                                                           inManagedObjectContext:managedObjectContext];
  
  return newObject;
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (DBDetail*)newDetail
{
  //NSLog(@"newDetail");
  return [NSEntityDescription insertNewObjectForEntityForName:@"Detail"
                                                           inManagedObjectContext:managedObjectContext];

}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (DBDetail *) newDetailWithName
{
  
  DBDetail * detail;
  NSString * displayName;
  
  //make new object
  detail = [self newDetail];

  //name it after base name set in preferences
  displayName = [[NSUserDefaults standardUserDefaults] objectForKey:@"detailBaseName"];
  displayName = [self makeUniqueName:displayName inEntity:@"Detail"];

  detail.displayName = displayName;
    
  return detail;
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (DBDetail *) newDetailDivider
{
  
  DBDetail * detail;
  NSString * displayName;
  NSInteger dividerIndex;
  
  detail = [self newDetail];

  dividerIndex = [dividerOptions  indexOfSelectedItem];
  if (dividerIndex == -1) dividerIndex = 0;
  
  displayName  = [dividerOptions itemObjectValueAtIndex:dividerIndex];
  detail.displayName = displayName;
  detail.isLeaf = [NSNumber numberWithBool:YES];
  detail.topic = controllerOfOutlineViews.activeDetailOutlineViewController.viewTopic;
  return detail;
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (DBFolderOrganizer *) newFolderOrganizerWithName
{
  
  DBFolderOrganizer * folderOrganizer;
  NSString * folderName;
  
  folderOrganizer = [self newFolderOrganizer];
  
  //name it after base name set in preferences
  folderName = [[NSUserDefaults standardUserDefaults] objectForKey:@"folderBaseName"];
  folderName = [self makeUniqueName:folderName inEntity:@"OrganizerObject"];
  
  folderOrganizer.displayName = folderName;
  
  return folderOrganizer;
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (DBHeaderOrganizer *) newHeaderOrganizerWithName
{
  
  DBHeaderOrganizer * headerOrganizer;
  NSString * topicName;
  DBNamedTopic * namedTopic;
  
  //make new object
  headerOrganizer = [self newHeaderOrganizer];
    

  //name it after base name set in preferences
  topicName = [[NSUserDefaults standardUserDefaults] objectForKey:@"headerBaseName"];
  topicName = [self makeUniqueName:topicName inEntity:@"TopicObject"];

  namedTopic = [self newNamedTopic];

  headerOrganizer.topic = namedTopic;   //doesn't update header toic with name unless the name is set after binding to the header
  
  namedTopic.displayName = topicName;//name propagates to topic header from topic
  
  return headerOrganizer;
  
}



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (DBHeaderOrganizer *) newHeaderOrganizerWithTopic:(DBTopicObject *)topic
{

  DBHeaderOrganizer * headerOrganizer;

  headerOrganizer = [self newHeaderOrganizer];
  headerOrganizer.topic = topic;

  headerOrganizer.displayName = topic.displayName;
  
  return headerOrganizer;
  
}



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

//be nice to increment by letters and roman numerals in future
- (NSString *) makeUniqueName:(NSString *)suggestedName inEntity:(NSString *)entityName
{
  

  NSFetchRequest * request;
  NSEntityDescription * entity;

  NSPredicate * namePredicate;

  NSError * error;
  NSArray * objectNames;
  NSSortDescriptor * aSortDesc;

  //NSLog(@"make unique name in entity triggered");
  request = [[NSFetchRequest alloc] init];
	entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:managedObjectContext];
	[request setEntity:entity];
  
  aSortDesc = [[NSSortDescriptor alloc] initWithKey:@"displayName" ascending:YES];//need to rename all values display name
	[request setSortDescriptors:[NSArray arrayWithObject: aSortDesc] ];
  
	namePredicate = [NSPredicate predicateWithFormat:@"displayName BEGINSWITH %@", suggestedName ];

  [request setPredicate:namePredicate];
	error = nil;
  
  objectNames = [managedObjectContext executeFetchRequest:request error:&error];	//returns array of objects

  return [self makeUniqueName:suggestedName inArray:[objectNames valueForKey:@"displayName"]];

}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (NSString *) makeUniqueName:(NSString *)suggestedName inArray:(NSArray *)arrayOfStrings{

  NSMutableArray * namesContainingSuggestion;
  NSString * uniqueName;
  bool nameFound;
  
  namesContainingSuggestion = [NSMutableArray arrayWithCapacity:arrayOfStrings.count];
  [namesContainingSuggestion setArray:arrayOfStrings];
  
  if (namesContainingSuggestion.count>0) {
    
    //check original name: suggested name should be at the top of the list
    if ([suggestedName isEqualToString:[namesContainingSuggestion objectAtIndex:0]]) {
      [namesContainingSuggestion removeObjectAtIndex:0];
      if (namesContainingSuggestion.count>0) {
        int j = 1;
        do {
          uniqueName = [suggestedName stringByAppendingFormat:@" %i", j];
          //NSLog(@"attempting uniqueName: %@",uniqueName);
          nameFound = FALSE;
          for (int k=0; k < namesContainingSuggestion.count; k+=1) {
            
            if ([uniqueName isEqualToString:[namesContainingSuggestion objectAtIndex:k]]){
              nameFound= TRUE;
              //get rid of name that was just found to shorten array (won't be checking that name again)
              [namesContainingSuggestion removeObjectAtIndex:k];
              //NSLog(@"removed a name:%@", [namesContainingSuggestion listStrings]);
              break;
            }
          }
          j += 1;
        } while (nameFound);
      } else {
        uniqueName = [suggestedName stringByAppendingFormat:@" 1"];
      }
    } else uniqueName = suggestedName;
  } else uniqueName = suggestedName;
  
  return uniqueName;
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (DBManagedTreeObject *) createObjectForOutlineViewController:(DBOutlineViewController*) controller {

  DBOutlineView * outlineView;
  DBManagedTreeObject * newObject;
  NSTreeController * activeTree;
  DBTopicObject * topicObject;
  NSDate * topicDate;
  
  activeTree = controller.tree;
  outlineView = controller.view;

  //if(activeTree == controllerOfOutlineViews.
    // topicOutlineViewController.tree){
    
    //newObject = [self newFolderOrganizerWithName];
    
  //} else {
    
    newObject = [self newDetailWithName];
    topicObject = controller.viewTopic;    
    [newObject setValue:controller.viewTopic forKey:@"topic"];
    
    if ([topicObject isKindOfClass:[DBDateTopic class]]) {
      
      topicDate = [topicObject valueForKey:@"date"];
      [newObject setValue:topicDate forKey:@"dateAssociated"];
      
    }
    
  //}

  return newObject;

}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) newDetailWithPath:(NSString *)filePath
                      note:(NSString *)copiedText
               outputValue:(NSString *)outputValue
          imageOnClipboard:(BOOL)hasImageOnClipBoard
                  entitled:(NSString *)detailTitle
{
  //this inserts into topic folder view if that the active one
 
  //NSLog(@"newDetailWithPath");
  
  //if (hasImageOnClipBoard) {
    //NSLog(@"hasImageOnClipBoard = YES");
  //} else {
    //NSLog(@"hasImageOnClipBoard = NO");

  //}
  
  DBDetailOutlineViewController *activeDetailOutlineViewController = controllerOfOutlineViews.activeDetailOutlineViewController;
  
   DBDetail * newDetail = (DBDetail*)[self createObjectForOutlineViewController:activeDetailOutlineViewController];  //create detail sets the topic of the newObject
  
  
  //if (copiedText) newDetail.note = copiedText;
  if (outputValue)newDetail.outputValue = outputValue;
  if ( ! [filePath isEqualToString:@""] ) [newDetail setSourceFile:[appDelegate.aliasController linkForPath:filePath]];
    // link for path should return null if the file path doesn't exist
// set title if given
  if (! [detailTitle isEqualToString:@""] ) {
    
    newDetail.displayName = detailTitle;

// if not see if we can name it after the note
  } else if (! [copiedText isEqualToString:@""]){
   
    newDetail.displayName = [copiedText firstWords:[[NSUserDefaults standardUserDefaults] integerForKey:@"wordsOfNoteInTitle"]];

    if (copiedText) {
      
      // add markers to id the note as quoted material
      
      NSString * stringBeforeQuote =[[NSUserDefaults standardUserDefaults] objectForKey:@"appendBeforeQuote"];
      NSString * stringAfterQuote =[[NSUserDefaults standardUserDefaults] objectForKey:@"appendAfterQuote"];
      
      
      copiedText = [stringBeforeQuote stringByAppendingString:copiedText];
      copiedText = [copiedText stringByAppendingString:stringAfterQuote];
      
      newDetail.note = copiedText;
      
      //[[NSUserDefaults standardUserDefaults] objectForKey:appendBeforeQuote];
    }
    
// if not see if we can name it after the note
  } else if (newDetail.sourceFile) {
    
    newDetail.displayName = newDetail.sourceFile.displayName;
    
  } else {
    
    NSString * displayName = [[NSUserDefaults standardUserDefaults] objectForKey:@"detailBaseName"];
    displayName = [self makeUniqueName:displayName inEntity:@"Detail"];
    
    newDetail.displayName = displayName;  //it will be given a generic name
    
  }

// get an output script if it's there
  newDetail.outputScript = appDelegate.appleScriptController.scriptForIncommingDetail;
  appDelegate.appleScriptController.scriptForIncommingDetail = NULL;

// get the image from the clipboard if it's there
  if ( hasImageOnClipBoard ){
    
    //NSLog(@"attempting to get image from clipboard...");
    
    // from http://stackoverflow.com/questions/5923138/how-to-get-the-type-of-pasteboard-entry/5923710#5923710
    
    NSPasteboard * pboard = [NSPasteboard generalPasteboard];
    NSArray * imgType = [NSArray arrayWithObject:[NSImage class]];
    NSArray * pboardImg = [pboard readObjectsForClasses:imgType
                                                options:nil];
    NSImage * clipboardImage;
    
    if( pboardImg.count > 0 ){
      //NSLog(@"Found image!");
      
      clipboardImage = [pboardImg objectAtIndex:0];
      
      //DBDataToImageTransformer * imageTransformer = [[DBDataToImageTransformer alloc] init];
      //[newDetail setImage:[imageTransformer reverseTransformedValue:clipboardImage]];
      
    } else {
      
      //NSLog(@"no image.  looking for path instead");
      //check if a path is there instead of an image
      NSString* pasteBoardString = [pboard  stringForType:NSPasteboardTypeString];

      if (pasteBoardString.length > 0) {
        
        NSLog(@"found string instead of image: %@", pasteBoardString);

        NSURL * possibleURL = [appDelegate.aliasController fileURL:pasteBoardString];
        
        if (possibleURL) {
          NSLog(@"found string is a url");
          
          clipboardImage = [[NSImage alloc] initWithContentsOfURL:possibleURL];

        }
        
      }
    }
    
    if (clipboardImage){
      //NSLog(@"Got image!");

      DBDataToImageTransformer * imageTransformer = [[DBDataToImageTransformer alloc] init];
      [newDetail setImage:[imageTransformer reverseTransformedValue:clipboardImage]];
      
    } else {
      
      NSLog(@"Couldn't find an image on the clipboard. ");
      
      NSAlert * alertNoImageFound = [NSAlert alertWithMessageText:@"No image was found on the clipboard." defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@""];
      [alertNoImageFound runModal];
      
    }
    
    
    


  }
  
  [self insert:newDetail withViewController: activeDetailOutlineViewController asSubGroup:NO enterEditMode:NO andSelectAllText:NO];

}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void)detailWithAlias:(DBFileTopic *)aliasLink
          withFileNamed:(NSString *)fileName
                andText:(NSString *)copiedText{
  
  DBDetail * newObject;
  DBDetailOutlineViewController * activeDetailOutlineViewController;
  activeDetailOutlineViewController = controllerOfOutlineViews.activeDetailOutlineViewController;

  
  //create detail is putting the files alias in topic organizer
  newObject = (DBDetail*)[self createObjectForOutlineViewController:activeDetailOutlineViewController];  //create detail sets the topic of the newObject
  
  [newObject setValue:aliasLink forKey:@"sourceFile"];//

  [newObject setValue:copiedText forKey:@"note"];
  
  if ([copiedText isEqualToString:@""]) {

    newObject.displayName = fileName;

    
  } else {
    
    newObject.displayName = [copiedText firstWords:5];
    
  }
  
  // should make the active detail view the first responder first
  [self insert:newObject withViewController:activeDetailOutlineViewController asSubGroup:NO enterEditMode:NO andSelectAllText:NO];

}


#pragma mark -
#pragma mark Remove Objects


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

//20130622 can probably get rid of this now
//deletes object
//and detail if
//1) the deleted object is a DBTopicDetail or DBDateDetail
//and 2) it is a has one that is only represented by the deleted context
- (void) deleteObject:(DBManagedTreeObject *) objectToRemove {
  
  [managedObjectContext deleteObject:objectToRemove];

}



#pragma mark -
#pragma mark Topic Organization Buttons

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

//needed improvements: first object has sort index of -1, the rest seem fine
- (IBAction)newTopic:sender {
  
  DBHeaderOrganizer * newObject;
  DBOutlineViewController * activeOutlineViewController = controllerOfOutlineViews.activeOutlineViewController;
    
  newObject = [self newHeaderOrganizerWithName];
  
  [self insert:newObject withViewController:activeOutlineViewController asSubGroup:NO enterEditMode:YES andSelectAllText:YES];
  
}
/*
-(IBAction) pathControlClicked:(id)sender{
  
  // works for both clicking the path and the "Choose..." option
  
  //NSLog(@"pathControlClicked");
  
  NSPathControl* pathCntrl = (NSPathControl *)sender;
  
  NSPathComponentCell *component = [pathCntrl clickedPathComponentCell];   // find the path component selected
  [pathCntrl setURL:[component URL]];          // set the url to the path control
  
  NSString * newPath = [[component URL] path];
  
  
  [[NSUserDefaults standardUserDefaults] setObject: newPath
                                            forKey:@"navigationHomePath"];
  
}

-(IBAction)navigateHome:(id)sender{
  
  
  
  
}
*/

#pragma mark -
#pragma mark Main Detail Buttons

/* just using insert for now
 
- (IBAction)add:(id)sender {
  
  DBOutlineView * activeView;
  NSTreeController * activeTree;
  NSIndexPath * createdIndexPath;
  
  DBManagedTreeObject * newObject;
  DBOutlineViewController * activeController = controllerOfOutlineViews.activeOutlineViewController;
  DBOutlineViewDelegate * viewDelegate = activeController.delegate;
  NSUInteger rootIndex;
  DBTopicObject * viewTopic;
  BOOL detailView = NO;
    

  //enable selection for view-based OutlineView
  //if (detailView) [activeView setValue:[NSNumber numberWithBool:YES] forKey:@"selectRowIndexesEnabled"];
  
  activeTree = activeController.tree;
  activeView = activeController.view;
  
  if ([activeView isKindOfClass:([DBDetailOutlineView class])]) detailView = YES;
  
  
  // accept changes and end editing
  if (detailView) {
    
    [(DBDetailOutlineView*)activeView checkTextViewCellforEndEditing];
    
  } else {
    
    [activeView reloadData];
    
  }

  [activeTree selectNone];  //could use delegate selectNone
  
  newObject = [self createObjectForOutlineViewController:activeController];
  
  //determine placement of newObject
  if (activeController == controllerOfOutlineViews.topicOutlineViewController) {

    // will need to change this to implement catagories for OrganizerObjects
    rootIndex = ([self getFolderViewRootObjects].count - 1);
    
  } else {
    
    // viewTopic does not exist for topicOutlineViewController
    viewTopic = activeController.viewTopic;

    rootIndex = viewTopic.rootSet.count - 1 ;

    // see if a calendar date needs to be bold now
    if ([viewTopic isKindOfClass:[DBDateTopic class]]) {
      
      [calendarController markDatesWithEntries];
      
    }
    
  }

  [newObject setValue:[ NSNumber numberWithInt:((int)rootIndex * 10) ] forKey:@"sortIndex"];
  createdIndexPath = [NSIndexPath indexPathWithIndex:rootIndex ];

  //insert item
  viewDelegate.event = @"enterEditMode";  // this will enter edit mode
  [activeTree insertObject:newObject atArrangedObjectIndexPath:createdIndexPath];
  [newObject doneInitializing];

  [activeTree setSelectionIndexPath:createdIndexPath];  //this is supposed to happen automatically but doesn't on the third insert for some reason
  
  if (detailView) [controllerOfOutlineViews updateViewsWithSameTopicAs: activeController.mainDetailViewController ];
  
  // don't need to set children indices because it's adding to the end
  
  [ controllerOfOutlineViews updateRelatedContent ];
  NSLog(@"done adding");
  //[ appDelegate save ];

}

*/


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (IBAction)divider:(id)sender {
  
  [undoManager makeUndoable];

    DBDetail *newObject = [self newDetailDivider];
    [self insert:newObject withViewController:controllerOfOutlineViews.activeDetailOutlineViewController asSubGroup:NO enterEditMode:NO andSelectAllText:NO];

  [undoManager stopMakingUndoable];
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (IBAction)insert:(id)sender;
{

  [undoManager makeUndoable];

  DBManagedTreeObject *newObject = [self createObjectForOutlineViewController:controllerOfOutlineViews.activeDetailOutlineViewController];
  [self insert:newObject withViewController:controllerOfOutlineViews.activeDetailOutlineViewController asSubGroup:NO enterEditMode:YES andSelectAllText:YES]; // <-- begin undogrouping must be in here

  [undoManager stopMakingUndoable];

}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

// method would allow user to hit a key to insert at the root
// ? What if they want to just insert one tab up... two tabs up

- (void) insertToRoot:(DBManagedTreeObject*)newObject
   withViewController:(DBOutlineViewController *) activeController
        enterEditMode:(BOOL)enterEditMode
     andSelectAllText:(BOOL)selectAllText

{
  
  
  // get the selected object
  // find the root parent of that object
  // insert under that root object
  
  
  /*
  NSIndexPath * createdIndexPath;
  
  NSIndexPath * selectionIndex;
  NSIndexPath * parentIndex;
  DBManagedTreeObject * parentObject;
  
  NSTreeNode * parentNode;
  NSInteger selectedSiblingNumber;
  BOOL detailView = NO;
  
  NSTreeController *activeTree = activeController.tree;
  DBOutlineView *activeView = activeController.view;
  
  if ([activeView isKindOfClass:[DBDetailOutlineView class]]) detailView = YES;
  
  DBOutlineViewDelegate *viewDelegate = activeController.delegate;
  
  // accept changes and end editing
  
  if (detailView) {
    
    //[(DBDetailOutlineView*)activeView checkTextViewCellforEndEditing];
    
  } else {
    
    [activeView reloadData];
    
  }
  
  //enable selection for view-based OutlineView
  if (detailView) [activeView setValue:[NSNumber numberWithBool:YES] forKey:@"selectRowIndexesEnabled"];
  
  
  
  // get the bottom index if multiple indexpaths are selected
  NSArray * selectedPaths = [activeTree selectionIndexPaths];
  
  if ( selectedPaths.count > 0 ) {
    
    //for (NSIndexPath * path in selectedPaths) {
    
    //NSLog(@"%@", path.indexPathString );
    
    //}
    
    selectionIndex = [selectedPaths objectAtIndex:selectedPaths.count-1];
    
  } else {
    
    selectionIndex = NULL;
    
  }
  // --------------------------
  
  [activeTree selectNone];
  
  //determine placement of newObject
  
  if (!selectionIndex){
    // no item is selected, adds to bottom of list
    
    NSInteger rootIndex;
    
    if (activeController == controllerOfOutlineViews.topicOutlineViewController) {
      
      // I don't remember why this one doesn't subtract one but the rootIndex for the detilviewControllers is -1
      rootIndex = [[controllerOfOutlineViews.topicOutlineViewController.tree arrangedObjects] count];
      
    } else {
      
      // viewTopic does not exist for topicOutlineViewController
      
      DBTopicObject *viewTopic = activeController.viewTopic;
      
      rootIndex = viewTopic.rootSet.count - 1 ;
      
    }
    
    // NSLog(@"rootIndex : %li", rootIndex);
    
    [newObject setValue:[ NSNumber numberWithInt:((int)rootIndex * 10) ] forKey:@"sortIndex"];
    
    createdIndexPath = [NSIndexPath indexPathWithIndex:rootIndex ];
    parentObject = NULL;
    parentIndex = [ createdIndexPath indexPathByRemovingLastIndex ];
    
  } else {  //an item is selected
    
    parentNode = [activeTree nodeAtIndexPath:selectionIndex];
    parentObject = [parentNode representedObject];
    
    // If a subtopic is selected topics and folders need to be inserted outside of maintopic
    
    
    if ([parentObject isKindOfClass:[DBHeaderOrganizer class]]) {
      DBTopicObject * parentTopic = [parentObject valueForKey:@"topic"];
      //NSLog(@"class: %@", [parentTopic className]);
      if ([parentTopic isKindOfClass:[DBSubTopic class]]) {
        
        if ([newObject isKindOfClass:[DBHeaderOrganizer class]]) {
          DBTopicObject * insertTopic = [newObject valueForKey:@"topic"];
          
          // if it's not a subtopic header then we have to insert in the grandparent
          if ( ! [insertTopic isKindOfClass:[DBSubTopic class]]) {
            
            parentObject = [parentObject valueForKey:@"parent"];
            selectionIndex = [selectionIndex indexPathByRemovingLastIndex];
            
          }
        } else { // folder organizer
          
          parentObject = [parentObject valueForKey:@"parent"];
          selectionIndex = [selectionIndex indexPathByRemovingLastIndex];
          
        }
      }
    }
    //NSLog(@"isALeaf: %@",[parentObject isALeaf]?@"YES":@"NO");
    //NSLog(@"insertAsSubGroup: %@",insertAsSubGroup?@"YES":@"NO");
    //NSLog(@"parentObject: %@", parentObject.displayName);
    
    if([parentObject isALeaf] || !(insertAsSubGroup) ){
      
      parentObject = parentObject.parent;
      parentIndex = [ selectionIndex indexPathByRemovingLastIndex ];
      
      selectedSiblingNumber= [selectionIndex indexAtPosition:(selectionIndex.length-1)];  //length of one corresponds to index of zero
      [newObject setValue:[ NSNumber numberWithInt:((int)selectedSiblingNumber * 10+1) ] forKey:@"sortIndex"];
      createdIndexPath = [ parentIndex indexPathByAddingIndex:(selectedSiblingNumber+1) ];
      
    } else {  // insert as subGroup
      
      parentIndex = selectionIndex;
      [newObject setValue:[ NSNumber numberWithInt:(-1)] forKey:@"sortIndex"];
      createdIndexPath = [ selectionIndex indexPathByAddingIndex:0];
      
    }
    
    
  }
  
  //NSLog(@"createdIndexPath %@", [createdIndexPath indexPathString]);
  
  
  // insert item
  // item won't be there if we try to enter edit mode now so we'll tell viewDelegate to do it for us when the object shows up
  if (enterEditMode) {
    
    if (selectAllText){
      
      viewDelegate.event = @"enterEditModeAndSelectAllText";
      
    } else {
      
      viewDelegate.event = @"enterEditMode";
      
    }
    
  }
  
  [activeTree insertObject:newObject atArrangedObjectIndexPath:createdIndexPath];
  
  [newObject doneInitializing];
  
  if (detailView) {
    DBDetail *parent = (DBDetail *)newObject.parent;
    if (parent) {
      [ parent updateCheckMark];
    }
  }
  
  [activeTree setSelectionIndexPath:createdIndexPath]; // can't rely on selecting inserted items beacuse it doesn't work for more than one insert
  
  // recalculate the indices of the other details in the same subGroup
  [activeTree setChildrenIndices:parentIndex];  //no delay needed, items exist in db; undo grouping in here
  
  // see if a calendar date needs to be bold now
  if ([activeController.viewTopic isKindOfClass:[DBDateTopic class]]) {
    
    [calendarController markDatesWithEntries];
    
  }
  
  if (detailView) {
    
    if (newObject.parent == NULL) {
      
      [controllerOfOutlineViews updateViewsWithSameTopicAs: activeController.mainDetailViewController ];
      
    }
    
  }
  
  [ controllerOfOutlineViews updateRelatedContent ];
  
*/
}





// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void)insertBulletWithString:(NSString*)newName {
  
  [undoManager makeUndoable];

  
  BOOL shouldSelectText = false;
  DBManagedTreeObject *newObject = [self createObjectForOutlineViewController:controllerOfOutlineViews.activeDetailOutlineViewController];
  
  if (newName) {
    
    newObject.displayName = newName; // don't want null strings to replace default name
    
  } else {
    // let's only select the text if the string is null
    //   this should only happen when <enter> has been pressed
    shouldSelectText = true;
    
  }
  
  
  [self insert:newObject withViewController:controllerOfOutlineViews.activeDetailOutlineViewController asSubGroup:NO enterEditMode:YES andSelectAllText:shouldSelectText];
  
  [undoManager stopMakingUndoable];

}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (IBAction)insertFolder:(id)sender;

{
  NSLog(@"insert folder");
  [undoManager makeUndoable];

  DBManagedTreeObject * newObject = [self newFolderOrganizerWithName];
    
  [self insert:newObject withViewController:controllerOfOutlineViews.topicOutlineViewController asSubGroup:NO enterEditMode:YES andSelectAllText:YES];

  [undoManager stopMakingUndoable];

}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (IBAction)subGroup:(id)sender
{
  [undoManager makeUndoable];

  DBManagedTreeObject *newObject = [self createObjectForOutlineViewController:controllerOfOutlineViews.activeDetailOutlineViewController];
  
  [self insert:newObject withViewController:controllerOfOutlineViews.activeDetailOutlineViewController asSubGroup:YES enterEditMode:YES andSelectAllText:YES];
  
  [undoManager stopMakingUndoable];

}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (IBAction)removeFromDetailView:(id)sender {

  [self removeFromViewController: controllerOfOutlineViews.activeDetailOutlineViewController];

}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (IBAction)removeFromFolderView:(id)sender {

  [self removeFromViewController: controllerOfOutlineViews.topicOutlineViewController];

}



// -------------------------------------------------------------------------------

// menuRemove:

// -------------------------------------------------------------------------------

-(IBAction)menuRemove:(id)sender
{
  
  //NSLog(@"menuRemove");
  
  DBOutlineViewController * activeOutlineViewController = controllerOfOutlineViews.activeOutlineViewController;
  
  if ([activeOutlineViewController isKindOfClass:[DBDetailOutlineViewController class]]) {
    
    [ self removeFromDetailView:NULL ];
    
  } else if ([activeOutlineViewController isKindOfClass:[DBTopicOutlineViewController class]]) {
    
    [ self removeFromFolderView:NULL ];
    
  }
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) removeFromViewController: (DBOutlineViewController *) viewController{
  
  [ undoManager makeUndoable ];
  
  NSTreeController *activeTree = viewController.tree;
  //selectionIndex = [activeTree selectionIndexPath];
  
  NSArray *selectedNodes = [activeTree selectedNodes];
  
  //NSLog(@"-----");
  //NSLog(@"starting selectionIndex: %@", [selectionIndex indexPathString]);
  if (selectedNodes.count > 0) {

    //NSLog(@"starting deletion");
    
    NSIndexPath * newSelectionIndex;

    DBOutlineView *activeView = viewController.view;
    
    BOOL detailView = NO;
    if ([activeView isKindOfClass:[DBDetailOutlineView class]]) detailView = YES;
    
    //enable selection for view-based OutlineView
    if (detailView) [activeView setValue:[NSNumber numberWithBool:YES] forKey:@"selectRowIndexesEnabled"];
    
    if (! detailView) [activeView reloadData];
    
    [activeTree selectNone];//clears selection if present and prevents crash

    
    BOOL lastNode = NO;
    BOOL updateViewsWithSameTopic = NO;
    

    for (int index = (int)selectedNodes.count - 1; index >= 0; index -= 1) {
      
      
      if (index == 0 ) lastNode = YES;
      
      NSTreeNode * nodeToRemove = [selectedNodes objectAtIndex:index];
      
      NSIndexPath * indexToRemove = nodeToRemove.indexPath;
      NSIndexPath * parentIndexPath = [[nodeToRemove parentNode] indexPath];
      
      DBManagedTreeObject *objectToRemove = [ [ activeTree nodeAtIndexPath:indexToRemove ] representedObject ];
      
      
      DBManagedTreeObject *parent = objectToRemove.parent;
      
      NSSet *subGroups = [ NSSet setWithSet:objectToRemove.subGroups ];
      
      //selectedNode = [activeTree nodeAtIndexPath:indexToRemove];
      
      // need to clear subHeaders if it's a topicHeader
      //   note: only main topic headers can be removed this way
      // also need to abort if the object to remove is a subtopic
      
      BOOL objectIsASubtopic = NO;
      
      if ([objectToRemove isKindOfClass:[DBHeaderOrganizer class]]){
        
        DBTopicObject * topic = [objectToRemove valueForKey:@"topic"];
        
        if ([topic isKindOfClass:[DBSubTopic class]]) {
          objectIsASubtopic = YES;
      
        } else {
        
          for (DBHeaderOrganizer * subHeader in objectToRemove.subGroups) {
            
            [ managedObjectContext deleteObject:subHeader ];

          }
          
        }
      
      }

      if (! objectIsASubtopic) {
        
        // check if the objectToDelete has children
        if ( subGroups.count > 0 ) {
          
          //try getting index paths of child objects
          //remove them and add them above parent
          //assume they will be assigned topic if they are put in the root
          
          
          //increase sort index of all siblings after the deleted one to allow for inserted children
          int increaseSiblingSortIndex = (int)subGroups.count * INTERVAL; // to increase sort index of siblings so they push down
          
          
          // initialize variables for loop to update sibling sortIndices
          // Using nodes here because the root object siblings would be harder to get to through object relationships (would require checking if they are root objects and then fetching the object with the same topic with parent = nil.)
          
          NSIndexPath *incrementIndexPath = [indexToRemove indexPathByIncrementingLastIndex]; // to get next sibling
          NSTreeNode *incrementNode = [activeTree nodeAtIndexPath:incrementIndexPath];
          
          while (incrementNode!=NULL){
            
            NSManagedObject *thisSibling = [incrementNode representedObject];
            NSNumber *updatedSortIndex = [NSNumber numberWithInt:[[thisSibling valueForKey:@"sortIndex"] intValue] + increaseSiblingSortIndex];
            [thisSibling setValue:updatedSortIndex forKey:@"sortIndex"];
            incrementIndexPath = [incrementIndexPath indexPathByIncrementingLastIndex];
            incrementNode = [activeTree nodeAtIndexPath:incrementIndexPath];
            
          }
          
          // adjust subGroup's parent to objectToRemove.parent (grandparent) & update their sort index
          // in the future it could be much more efficient to check if parent is goingo be deleted before assigning it.  In some cases: A123abc deleting A123 would have abc reassigned to A and then reassigned again to the root.
          
          int parentSortIndex = [objectToRemove.sortIndex intValue];
          
          //should be NSManagedTreeObject
          for (DBManagedTreeObject * subGroup in subGroups){ //can't do objectToRemove.subGroups directly or it takes the item out of group while it's using the group
            
            subGroup.sortIndex = [subGroup.sortIndex incrementBy: parentSortIndex];
            subGroup.parent = parent;  //this moves it from the group while it's enumerated
            
          }
          // Change this so this is only done for the last of the selected nodes
          if (lastNode) newSelectionIndex = indexToRemove; // had subGroups so keep selection where it is
          
        } else {  // end if ( subGroups.count > 0 )
          
          if (lastNode) {
            
            // Change this so this is only done for the last of the selected nodes
            if ([activeTree previousSiblingOfNodeAtIndexPath:indexToRemove]) {
              
              //NSLog(@"has previous sibling");
              newSelectionIndex = [indexToRemove indexPathByDecrementingLastIndex];
              
              
            } else if ( [activeTree nextSiblingOfNodeAtIndexPath:indexToRemove] ) {
              //NSLog(@"has next sibling");
              newSelectionIndex = indexToRemove;
              
            } else if ( parent ) {
              //NSLog(@"no siblings. select parent");
              
              newSelectionIndex = [indexToRemove indexPathByRemovingLastIndex];
              
            } else {
              //NSLog(@"no parent or siblings.  must be last item");
              
              newSelectionIndex = NULL;
              
            }
          }
          
        }
        
      
        if (detailView) {
          
          DBDetail *detailToRemove =(DBDetail*)objectToRemove;
          
          [detailToRemove.topic setDateModified:[NSDate date]];
          [detailToRemove setTopic:NULL];
        
          if (parent == nil && !updateViewsWithSameTopic) updateViewsWithSameTopic = YES;
          
        }
        
        
        if (parent == nil) [ activeTree removeObjectAtArrangedObjectIndexPath: indexToRemove ];// if not a root item removal, this code would move first subgroup item to root
        
        [ managedObjectContext deleteObject:objectToRemove ];
        
        
        [ managedObjectContext processPendingChanges ];
        
        if ([parent isKindOfClass:[DBDetail class]]){
          [(DBDetail *)parent updateCheckMark];
        }
        
      } // end if (! objectIsASubTopic)

      [activeTree setChildrenIndices:parentIndexPath];
      
    } // end for loop on removing selected nodes

    
    [ activeTree setSelectionIndexPath: newSelectionIndex ];
    
    if ([viewController.viewTopic isKindOfClass:[DBDateTopic class]])
      [calendarController markDatesWithEntries];
    
    
    if (updateViewsWithSameTopic)
      [controllerOfOutlineViews updateViewsWithSameTopicAs: viewController.mainDetailViewController ];// causes all other views to deselect
    
    [ controllerOfOutlineViews updateRelatedContent ];
    
  }  // end if ( selectedNodes.count >0 )
  
  [ undoManager stopMakingUndoable ];

}




#pragma mark -
#pragma mark Other

// -------------------------------------------------------------------------------

// getFolderViewRootObjects

// -------------------------------------------------------------------------------
// returns sorted array

// useful in that calling arrangedObjects on the tree controller only returns a proxy array that isn't useful for much



- (NSArray *) getFolderViewRootObjects

{
 
  NSError *error;
  
  NSEntityDescription *entity = [NSEntityDescription entityForName:@"OrganizerObject" inManagedObjectContext:managedObjectContext];
  NSPredicate * parentPredicate = [NSPredicate predicateWithFormat:@"parent == NULL" ];
  NSPredicate * clipboardPredicate = [NSPredicate predicateWithFormat:@"isOnClipboard == NO" ];
  NSPredicate * combinedPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithObjects:parentPredicate, clipboardPredicate, nil]];
  NSSortDescriptor * sortDescriptor = [ [ NSSortDescriptor alloc ] initWithKey:@"sortIndex" ascending:YES ];

  NSFetchRequest *request = [ [ NSFetchRequest alloc ] init ];
  [ request setEntity:entity ];
  [ request setSortDescriptors: [ NSArray arrayWithObject: sortDescriptor ] ];
  [ request setPredicate:combinedPredicate ];
  
  error = nil;

  return [managedObjectContext executeFetchRequest:request error:&error];
  
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

//the topic with the displayName
//and return null if none found
- (DBMainTopic *) findMainTopicWithName:(NSString *)name usingUserPreferences:(BOOL)shouldUseUserPreferences{
      
  //use shared user preferences to set if spaces & caps effect
  //if they change those settings it will just work that way from then on...
  
  NSFetchRequest * request;
  NSEntityDescription * entity;
  NSPredicate * namePredicate;
  NSMutableArray * subPredicates;
  NSPredicate * combinedPredicate;
  NSError * error;
  NSArray * returnedObjects;
  BOOL ignoreCase;
  BOOL ignoreDiacritic;

  ignoreCase = [[NSUserDefaults standardUserDefaults] boolForKey:@"topicsIgnoreCase"];
  ignoreDiacritic = [[NSUserDefaults standardUserDefaults] boolForKey:@"topicsIgnoreDiacritic"];
  
  
  request = [[NSFetchRequest alloc] init];
	entity = [NSEntityDescription entityForName:@"MainTopic" inManagedObjectContext:managedObjectContext];
  if (shouldUseUserPreferences) {
    if (ignoreCase && ignoreDiacritic) {
      namePredicate = [NSPredicate predicateWithFormat:@"displayName MATCHES[cd] %@", name ];//[cd] ignores case and diacritic
    } else if (!(ignoreCase || ignoreDiacritic)) {
      namePredicate = [NSPredicate predicateWithFormat:@"displayName MATCHES %@", name ];
    } else if (ignoreCase){  // just ignoreCase
      namePredicate = [NSPredicate predicateWithFormat:@"displayName MATCHES[c] %@", name ];
    } else { // just ignoreDiacritic
      namePredicate = [NSPredicate predicateWithFormat:@"displayName MATCHES[d] %@", name ];
    }
  } else {
    namePredicate = [NSPredicate predicateWithFormat:@"displayName MATCHES %@", name ];
  }


  subPredicates = [NSMutableArray array];
  [subPredicates addObject:namePredicate];
  //[subPredicates addObject:globalPredicate];
  combinedPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:subPredicates];
	[request setEntity:entity];
  [request setPredicate:combinedPredicate];
	error = nil;
  
  returnedObjects = [managedObjectContext executeFetchRequest:request error:&error];

  if (returnedObjects.count > 1) {
    NSLog(@"detailController findGlobalWithName: error - found more than one topic with the same name.");
  }

  if (returnedObjects.count > 0) {

    return [returnedObjects objectAtIndex:0];

  } else {
  
    return NULL;

  }

}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

//the topic with the displayName
//and return null if none found
- (DBSubTopic *) findSubTopicWithName:(NSString *)name usingUserPreferences:(BOOL)shouldUseUserPreferences{
  
  //use shared user preferences to set if spaces & caps effect
  //if they change those settings it will just work that way from then on...
  
  NSFetchRequest * request;
  NSEntityDescription * entity;
  NSPredicate * namePredicate;
  NSMutableArray * subPredicates;
  NSPredicate * combinedPredicate;
  NSError * error;
  NSArray * returnedObjects;
  BOOL ignoreCase;
  BOOL ignoreDiacritic;
  
  ignoreCase = [[NSUserDefaults standardUserDefaults] boolForKey:@"topicsIgnoreCase"];
  ignoreDiacritic = [[NSUserDefaults standardUserDefaults] boolForKey:@"topicsIgnoreDiacritic"];
  
  
  request = [[NSFetchRequest alloc] init];
	entity = [NSEntityDescription entityForName:@"SubTopic" inManagedObjectContext:managedObjectContext];
  if (shouldUseUserPreferences) {
    if (ignoreCase && ignoreDiacritic) {
      namePredicate = [NSPredicate predicateWithFormat:@"displayName MATCHES[cd] %@", name ];//[cd] ignores case and diacritic
    } else if (!(ignoreCase || ignoreDiacritic)) {
      namePredicate = [NSPredicate predicateWithFormat:@"displayName MATCHES %@", name ];
    } else if (ignoreCase){  // just ignoreCase
      namePredicate = [NSPredicate predicateWithFormat:@"displayName MATCHES[c] %@", name ];
    } else { // just ignoreDiacritic
      namePredicate = [NSPredicate predicateWithFormat:@"displayName MATCHES[d] %@", name ];
    }
  } else {
    namePredicate = [NSPredicate predicateWithFormat:@"displayName MATCHES %@", name ];
  }
  
  
  subPredicates = [NSMutableArray array];
  [subPredicates addObject:namePredicate];
  //[subPredicates addObject:globalPredicate];
  combinedPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:subPredicates];
	[request setEntity:entity];
  [request setPredicate:combinedPredicate];
	error = nil;
  
  returnedObjects = [managedObjectContext executeFetchRequest:request error:&error];
  
  if (returnedObjects.count > 1) {
    NSLog(@"detailController findGlobalWithName: error - found more than one topic with the same name.");
  }
  
  if (returnedObjects.count > 0) {
    
    return [returnedObjects objectAtIndex:0];
    
  } else {
    
    return NULL;
    
  }
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

// this handels insertions for topic additions, detail inserts, divider inserts and applescript triggered insertions

- (void) insert:(DBManagedTreeObject*)newObject
  withViewController:(DBOutlineViewController *) activeController
          asSubGroup:(BOOL)insertAsSubGroup
    enterEditMode:(BOOL)enterEditMode
    andSelectAllText:(BOOL)selectAllText

{

  NSIndexPath * createdIndexPath;
  
  NSIndexPath * selectionIndex;
  NSIndexPath * parentIndex;
  DBManagedTreeObject * parentObject;
  
  NSTreeNode * parentNode;
  NSInteger selectedSiblingNumber;
  BOOL detailView = NO;
  
  NSTreeController *activeTree = activeController.tree;
  DBOutlineView *activeView = activeController.view;
  
  if ([activeView isKindOfClass:[DBDetailOutlineView class]]) detailView = YES;
  
  DBOutlineViewDelegate *viewDelegate = activeController.delegate;
  
  // accept changes and end editing

  if (detailView) {

    //[(DBDetailOutlineView*)activeView checkTextViewCellforEndEditing];
  
  } else {
  
    [activeView reloadData];
  
  }
  
  //enable selection for view-based OutlineView
  if (detailView) [activeView setValue:[NSNumber numberWithBool:YES] forKey:@"selectRowIndexesEnabled"];
  
  
  
  // get the bottom index if multiple indexpaths are selected
  NSArray * selectedPaths = [activeTree selectionIndexPaths];
  
  if ( selectedPaths.count > 0 ) {
    
    //for (NSIndexPath * path in selectedPaths) {
      
      //NSLog(@"%@", path.indexPathString );
      
    //}
    
    selectionIndex = [selectedPaths objectAtIndex:selectedPaths.count-1];

  } else {
    
    selectionIndex = NULL;
    
  }
  // --------------------------
  
  [activeTree selectNone];
  
  //determine placement of newObject
  
  if (!selectionIndex){
    // no item is selected, adds to bottom of list
    
    NSInteger rootIndex;
    
    if (activeController == controllerOfOutlineViews.topicOutlineViewController) {
      
      // I don't remember why this one doesn't subtract one but the rootIndex for the detilviewControllers is -1
      rootIndex = [[controllerOfOutlineViews.topicOutlineViewController.tree arrangedObjects] count];
      
    } else {
      
      // viewTopic does not exist for topicOutlineViewController
      
      DBTopicObject *viewTopic = activeController.viewTopic;
      
      rootIndex = viewTopic.rootSet.count - 1 ;
      
    }

    // NSLog(@"rootIndex : %li", rootIndex);
    
    [newObject setValue:[ NSNumber numberWithInt:((int)rootIndex * 10) ] forKey:@"sortIndex"];

    createdIndexPath = [NSIndexPath indexPathWithIndex:rootIndex ];
    parentObject = NULL;
    parentIndex = [ createdIndexPath indexPathByRemovingLastIndex ];
    
  } else {  //an item is selected
    
    parentNode = [activeTree nodeAtIndexPath:selectionIndex];
    parentObject = [parentNode representedObject];

    // If a subtopic is selected topics and folders need to be inserted outside of maintopic


    if ([parentObject isKindOfClass:[DBHeaderOrganizer class]]) {
      DBTopicObject * parentTopic = [parentObject valueForKey:@"topic"];
      //NSLog(@"class: %@", [parentTopic className]);
      if ([parentTopic isKindOfClass:[DBSubTopic class]]) {
        
        if ([newObject isKindOfClass:[DBHeaderOrganizer class]]) {
          DBTopicObject * insertTopic = [newObject valueForKey:@"topic"];
          
          // if it's not a subtopic header then we have to insert in the grandparent
          if ( ! [insertTopic isKindOfClass:[DBSubTopic class]]) {
        
            parentObject = [parentObject valueForKey:@"parent"];
            selectionIndex = [selectionIndex indexPathByRemovingLastIndex];
            
          }
        } else { // folder organizer
          
          parentObject = [parentObject valueForKey:@"parent"];
          selectionIndex = [selectionIndex indexPathByRemovingLastIndex];
          
        }
      }
    }
    //NSLog(@"isALeaf: %@",[parentObject isALeaf]?@"YES":@"NO");
    //NSLog(@"insertAsSubGroup: %@",insertAsSubGroup?@"YES":@"NO");
    //NSLog(@"parentObject: %@", parentObject.displayName);
    
    if([parentObject isALeaf] || !(insertAsSubGroup) ){

      parentObject = parentObject.parent;
      parentIndex = [ selectionIndex indexPathByRemovingLastIndex ];
  
      selectedSiblingNumber= [selectionIndex indexAtPosition:(selectionIndex.length-1)];  //length of one corresponds to index of zero
      [newObject setValue:[ NSNumber numberWithInt:((int)selectedSiblingNumber * 10+1) ] forKey:@"sortIndex"];
      createdIndexPath = [ parentIndex indexPathByAddingIndex:(selectedSiblingNumber+1) ];

    } else {  // insert as subGroup
      
      parentIndex = selectionIndex;
      [newObject setValue:[ NSNumber numberWithInt:(-1)] forKey:@"sortIndex"];
      createdIndexPath = [ selectionIndex indexPathByAddingIndex:0];
      
    }
      
      
  }
  
  //NSLog(@"createdIndexPath %@", [createdIndexPath indexPathString]);

  
  // insert item
  // item won't be there if we try to enter edit mode now so we'll tell viewDelegate to do it for us when the object shows up
  if (enterEditMode) {
    
    if (selectAllText){
      
      viewDelegate.event = @"enterEditModeAndSelectAllText";
      
    } else {
      
      viewDelegate.event = @"enterEditMode";

      
    }
    
  }
  
  [activeTree insertObject:newObject atArrangedObjectIndexPath:createdIndexPath];

  
  
  [newObject doneInitializing];

  if (detailView) {
    DBDetail *parent = (DBDetail *)newObject.parent;
    if (parent) {
      [ parent updateCheckMark];
    }
  }

  [activeTree setSelectionIndexPath:createdIndexPath]; // can't rely on selecting inserted items beacuse it doesn't work for more than one insert

  // recalculate the indices of the other details in the same subGroup
  [activeTree setChildrenIndices:parentIndex];  //no delay needed, items exist in db; undo grouping in here

  // see if a calendar date needs to be bold now
  if ([activeController.viewTopic isKindOfClass:[DBDateTopic class]]) {
    
    [calendarController markDatesWithEntries];
    
  }

  if (detailView) {
  
    if (newObject.parent == NULL) {
      
      [controllerOfOutlineViews updateViewsWithSameTopicAs: activeController.mainDetailViewController ];
  
    }
  
  }
  
  [ controllerOfOutlineViews updateRelatedContent ];

}



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (IBAction)segementedCellDetailActions:(id)sender {
  NSInteger selectedSegment = [sender selectedSegment];
  NSInteger clickedSegmentTag = [[sender cell] tagForSegment:selectedSegment];
  
  switch (clickedSegmentTag) {
      
    case 0: [self insert:sender]; break;
    case 1: [self removeFromDetailView:sender]; break;
    case 2: [self subGroup:sender]; break;
    case 3: [self divider:sender]; break;
  
    //case 0: [self add:sender]; break;
    //case 1: [self remove:sender]; break;
    //case 2: [self insert:sender]; break;
    //case 3: [self subGroup:sender]; break;
    //case 4: [self divider:sender]; break;
  }
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (IBAction)sortSubgroupsAZ:(id)sender{
  
  [self sortSubgroupsWithDescriptor:self.azSortDescriptor];
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (IBAction)sortSubgroupsZA:(id)sender{
  
  [self sortSubgroupsWithDescriptor:self.zaSortDescriptor];

}


// -------------------------------------------------------------------------------

// sortSubgroupsWithDescriptor:

// -------------------------------------------------------------------------------

-(void) sortSubgroupsWithDescriptor:(NSArray *)sortDescriptor{
  
  NSArray * selectedObjects = controllerOfOutlineViews.activeOutlineViewController.tree.selectedObjects;
  NSArray * sortItems;
  
  if (selectedObjects.count > 0) {

    DBManagedTreeObject * object = [selectedObjects objectAtIndex:0];
    sortItems = [object.subGroups allObjects];
    
  } else { //no selection.  get root objects
    
    sortItems = [controllerOfOutlineViews.activeOutlineViewController.mainDetailViewController.managedViewObject.viewTopic.details allObjects];
    
  }
  
  if (sortItems.count > 1) {
    
    sortItems = [sortItems sortedArrayUsingDescriptors:sortDescriptor];
    
    DBManagedTreeObject * item;
    
    for ( int index = 0; index < sortItems.count; index += 1 ) {
      
      item = [ sortItems objectAtIndex:index ];
      [ item setSortIndex: [ NSNumber numberWithInt:index ] ];
      
    }
    
    [controllerOfOutlineViews.activeOutlineViewController.tree rearrangeObjects];
    
  }
  
}


// -------------------------------------------------------------------------------

// deleteClipboardObjects

// -------------------------------------------------------------------------------

// deletes all items and their subgroups on the objectClipboard
// clipboard items are copies of the copied or cut items so this won't destroy any real data
- (void) deleteClipboardObjects
{
  
  NSArray * clipboardArray = [objectClipboard.items allObjects];

  NSMutableArray * objectsToDelete = [ NSMutableArray array ];
  
  // get all of the subgroups to delete
  for (int index = 0; index < clipboardArray.count; index +=1){
    
    DBManagedTreeObject * item = [ clipboardArray objectAtIndex:index ];
    
    [ objectsToDelete addObjectsFromArray:[item flattenedWithSubGroups ]];
    
  }
  
  objectClipboard.items = [ NSSet set ]; //clear set
  
  // delete all items
  for (int index = 0; index < objectsToDelete.count; index +=1 ) {
    
    [ managedObjectContext deleteObject:[ objectsToDelete objectAtIndex:index ] ];

  }
  
  [ managedObjectContext processPendingChanges ];
  
}


- (void) cutObjectClipboardContentsUsingController: (DBOutlineViewController *) viewController

{
  
  [self copySelectedObjectsUsingController:viewController];
 
  [self removeFromViewController:viewController];

}



// -------------------------------------------------------------------------------

// pasteObjectClipboardContentsUsingController:

// -------------------------------------------------------------------------------

- (void) pasteObjectClipboardContentsUsingController: (DBOutlineViewController *) viewController
{
  //  Behavior
  //    if nothing selected, clipboard objects should go at end
  //    if an item is selected, objects should go below selected item
  //    if multiple items are selected, object should go go below last selected item
  //    will paste copies of the clipboard objects so the clipboard doesn't empty
  //
  // in the future this will need to distinguish and convert the type of items
  //    DBDetails will need to be put inside topic items,
  //    Topic headers will need to be converted into wikiwords
  
  // proceed if items are on clipboard
  if (objectClipboard.items.count > 0) {
    
    NSTreeController * tree = viewController.tree;
    
    DBTopicObject * topic;
    BOOL detailView = NO;
    BOOL continuePaste = YES;
    //BOOL pastingIntoVisibleView = YES;
    
    if ([viewController.view isKindOfClass:[DBDetailOutlineView class]]){
      
      detailView = YES;
      
      //get topic from view since there might not be any objects in the view to get it from.
      topic = viewController.mainDetailViewController.managedViewObject.viewTopic;// mainDetailViewController is null for topicOutlineView
      
    }
    
    NSInteger sortIndexOfLastSelectedObject = -10;  // -10 lets us increment ten when there is no selection or when the selection has a sortindex of 0 and it still works
    
    DBManagedTreeObject * selectionParent = NULL;
    //NSIndexPath * pasteAfterPath;
    NSIndexPath * firstPastePath;
    
    // get sortIndices, path and parent from the last of the selected objects
    
    if (tree.selectedObjects.count > 0){
      
      
      NSArray * selectedNodes = tree.selectedNodes;
      
      [tree selectNone];
      
      NSTreeNode * lastSelectedNode = [selectedNodes objectAtIndex:selectedNodes.count-1];
      
      //pasteAfterPath = lastSelectedNode.indexPath;
      
      firstPastePath = [lastSelectedNode.indexPath indexPathByIncrementingLastIndex];
      
      DBManagedTreeObject * selectedObject = [lastSelectedNode representedObject]; // last object of selection
      
      sortIndexOfLastSelectedObject = [selectedObject.sortIndex intValue];
      
      selectionParent = selectedObject.parent;
      
    } else {
      
      // no selection
      // need to set first paste path based on the number of items
      // if there are no items then we can paste at indexpath zero
      //    sortIndexOfLastSelectedObject will be -10
      // if there are items then we want to paste after the last item
      
      NSInteger numObjects = [[tree arrangedObjects] count];
      // get the index of the last root item on the list
      // note: this is the ideal calculated index not the actual
      //       bugs further upstream will cause problems here
      sortIndexOfLastSelectedObject = (numObjects - 1) * 10;
      
      firstPastePath = [NSIndexPath indexPathWithIndex:numObjects];
      
      
    }
    
    // can't continue for the following conditions with a topic view
    //    parent can't be a header organizer
    //    copied objects can't contain subgroups headerorganizers
    //    or the clipboard contains details
    
    
    if ([selectionParent isKindOfClass:[DBHeaderOrganizer class]]) continuePaste = NO;
    
    NSArray * clipboardItems = objectClipboard.orderedContent;
    NSMutableArray * copiedObjects = [NSMutableArray array];
    
    int index = 10;
    
    if (continuePaste) {
      
    
      for (DBManagedTreeObject * object in clipboardItems) {
        BOOL continueWithItem = YES;
        DBManagedTreeObject * copiedObject;
        
        // copy clipboardItem
        if (detailView) {
          
          if (objectClipboard.containsDetailObjects) {
            
            // simple copy of detail object to detail object
            copiedObject = [self copyDetailWithSubGroups:(DBDetail *)object toParent:NULL];
            
          } else {
            
            // copy of topic objects to detail view as details
            copiedObject = [self copyOrganizerAsDetailWithSubGroups:(DBOrganizerObject *)object toParent:NULL];
            
          }
          
          [copiedObject setValue:topic forKeyPath:@"topic"];
          
        } else {
          
          
          // this is a topic view
          
          if (objectClipboard.containsDetailObjects) {
            
            continuePaste = NO; // lets hold off on this for now
            
            NSLog(@"paste aborted - cannot paste a detail object into a topic view at this time");
            
            // this is complicated and
            // outcome here depends on if a topic header is selected
            // two cases here
            // 1) if a header is the target
            //      paste into the topic
            //      pastingIntoVisibleView = NO;
            
            // 2) if header is not the target
            //      paste as organizers objects translated the best we can
            
            // what to do if more than one item is selected?
            //    paste into all of them
            //    paste into none?
            //    the first one?
            //    --> after all of them
            
          } else if( [object isKindOfClass:[DBHeaderOrganizer class]]){
          
            DBTopicObject * topic = [(DBHeaderOrganizer*)object valueForKeyPath:@"topic"];
            
            if (topic.isGlobal) {
              
              copiedObject = [self copyOrganizerWithSubGroups:(DBOrganizerObject *)object toParent:NULL];

            } else {
              
              // should convert the subtopic to it's main topic
              //  but for now let's just disallow this option
              continueWithItem = NO;
              
            }
            
          } else {
            
            // simple copy of organizer object to organizer object
            
            copiedObject = [self copyOrganizerWithSubGroups:(DBOrganizerObject *)object toParent:NULL];
            
          }
          
          
        }
        
        if (continuePaste && continueWithItem) {
          
          //copiedObject.parent = selectionParent;
          copiedObject.sortIndex = [NSNumber numberWithInteger: sortIndexOfLastSelectedObject + index];
          
          index += 10;
          
          [ copiedObjects addObject: copiedObject];
          
        } else {
          
          break;
          
        }
        
        
      } // end of for loop
    } // if continue paste
    if (copiedObjects.count == 0) continuePaste = NO;
    
    if (continuePaste) {
      
      // increase sortindex for all groups that would follow the pasted items ------
      //   root inserts will not go in correct places sithout this step
      //   pasted items have not been inserted yet
      NSInteger increaseSortIndex = copiedObjects.count * 10;
      NSTreeNode * nextNode = [tree nodeAtIndexPath:firstPastePath];
      while (nextNode) {
        
        DBManagedTreeObject * objectToUpdate = [nextNode representedObject];
        
        //NSLog(@"increasing index of: %@", objectToUpdate.displayName);
        objectToUpdate.sortIndex = [ objectToUpdate.sortIndex incrementBy:increaseSortIndex ];
        
        nextNode = [tree nextSiblingOfNodeAtIndexPath:[nextNode indexPath]];
        
      }
      // ---------------------------------------------------------------------------
      
      
      // --- fill index path array for inserted objects
      NSMutableArray * objectIndexPaths = [NSMutableArray array];
      
      NSIndexPath *incrementIndexPath = firstPastePath;
      //  NSLog(@"Filling object index path ------ ");
      
      for (int index = 0; index < copiedObjects.count; index += 1) {
        
        //  NSLog(@"Object index path: %@", firstPastePath.indexPathString);
        
        [ objectIndexPaths addObject:incrementIndexPath];
        
        incrementIndexPath  = [incrementIndexPath indexPathByIncrementingLastIndex];
        
      }
      // ---
      
      [tree insertObjects:copiedObjects atArrangedObjectIndexPaths:objectIndexPaths ];
      
      
      [tree setSelectionIndexPaths:objectIndexPaths];
      
      // the rest of these actions are also done for inserts so they could be combined into their own method
      // --------------------------------------------------------------------------------------
      if (detailView) {
        
        for (DBDetail * detail in copiedObjects) {
          
          [detail doneInitializing]; //will this update the subgroups?
          
        }
        
        if (selectionParent) {
          
          [ (DBDetail *)selectionParent updateCheckMark];
          
        } else {
          
          [controllerOfOutlineViews updateViewsWithSameTopicAs: viewController.mainDetailViewController ];
          
        }
        // see if a calendar date needs to be bold now
        if ([viewController.viewTopic isKindOfClass:[DBDateTopic class]]) {
          
          [calendarController markDatesWithEntries];
          
        }
        
        [ controllerOfOutlineViews updateRelatedContent ];
        
      }
    }
  }
  
}



// -------------------------------------------------------------------------------

// copySelectedObjectsUsingController:

// -------------------------------------------------------------------------------

-(void) copySelectedObjectsUsingController: (DBOutlineViewController *)viewController
{
  
  NSArray * selectedNodes = viewController.tree.selectedNodes;

  if (selectedNodes.count > 0) {
  
    NSArray * nodesToCopy = [ self founderNodes:selectedNodes ];

    NSMutableArray * copiedItems = [NSMutableArray array];
    
    BOOL isDetailViewController = [ viewController isKindOfClass:[DBDetailOutlineViewController class] ];
    
    if ( isDetailViewController ) {
      
      //NSLog(@"number of nodes: %li", nodesToCopy.count);
      
      int index = 0;
      for (NSTreeNode * node in nodesToCopy) {
        
        DBDetail * copiedObject = [self copyDetailWithSubGroups:node.representedObject toParent:NULL];

        copiedObject.sortIndex = [NSNumber numberWithInt: index * 10];

        index += 10;

        [ copiedItems addObject: copiedObject];
        
      }
      
    } else {
      
      // not limiting to global topic items at this point
      NSArray * topicFounderNodes  = nodesToCopy;//[self topicFounderNodes:nodesToCopy];

      int index = 0;
      
      for (NSTreeNode * node in topicFounderNodes) {
        
        DBOrganizerObject * copiedObject = [ self copyOrganizerWithSubGroups:node.representedObject toParent:NULL ];
        
        copiedObject.isOnClipboard = YES;
        
        copiedObject.sortIndex = [NSNumber numberWithInt: index * 10];
        
        index += 10;
        
        [ copiedItems addObject: copiedObject];
        
      }
      
    }
    
    [ self deleteClipboardObjects ]; // these are copied items, won't hurt real ones
    
    objectClipboard.items = [ NSSet setWithArray: copiedItems ];
    
    
  }
  
}



// -------------------------------------------------------------------------------

// topicFounderNodes:

// -------------------------------------------------------------------------------
// this does not limit to just founder items (need founderNodes for this)
// gets founderNodes and then replaces subtopic nodes with topic nodes
// we never want to just cut or copy a subtopic headerObject
// don't think this is useful anymore for drags
//    it blocks from moving subtopics around

- (NSArray * ) topicFounderNodes:(NSArray *) founderNodes{
  
  //NSArray * founderNodes = [ self founderNodes: potentialFounderNodes ];
  NSMutableArray * returnItems = [ NSMutableArray array ];
  
  for (NSTreeNode * node in founderNodes) {

    if ([[node representedObject] isKindOfClass:[DBHeaderOrganizer class]]) {
      
      DBTopicObject * topic = [[node representedObject] valueForKey:@"topic"];
      
      if ([topic isKindOfClass:[DBSubTopic class]]) {
        //node is a subtopic.  need to put in the mainTopicNode if it's not already in there
        NSTreeNode * mainTopicNode = [node parentNode];
        
        if ( ![ returnItems containsObject:mainTopicNode ] ) {
          
          [ returnItems addObject:mainTopicNode ];

        }
        
      } else {
        // node is a main topic. okay to use as a founder
        
        [ returnItems addObject:node ];

      }
      
    } else {
      
      // node is a folder. okay to use as a founder

      [ returnItems addObject:node ];
      
    }
 
  }
  
  return [NSArray arrayWithArray:returnItems];
  
}

// -------------------------------------------------------------------------------

// founderNodes:

// -------------------------------------------------------------------------------

// reduces nodes to just those that are the parent nodes of the others in the array
// useful in that these founder nodes are the only ones that need to be moved/copied/removed/etc.
- (NSArray * ) founderNodes:(NSArray *) potentialFounderNodes{
  
  /*
  NSLog(@"founderNodes start items-------");
  
  for (NSTreeNode * node in potentialFounderNodes) {
    
    NSLog(@"%@", [[node representedObject] valueForKey:@"displayName"]);
    
  }
  */
  
  NSMutableArray * founderNodes = [ NSMutableArray array ];
  
  // need to reduce the nodes selected to just those that are the parent nodes of the others
  // an important assumption is that the nodes are in order
  if (potentialFounderNodes.count > 0) {
    
    // top node has to be a unique parent node
    [founderNodes addObject:[potentialFounderNodes objectAtIndex:0]];
    
    // after that, if the next item isn't a descendent of the last founderNode then should be added as a founder
    // starting at 1 because it's already been added
    for (NSUInteger index = 1; index < potentialFounderNodes.count; index += 1){
      
      NSTreeNode * testNode = [ potentialFounderNodes objectAtIndex: index ];
      NSTreeNode * founderNode = [ founderNodes objectAtIndex: founderNodes.count-1 ];
      
      if (![testNode isDescendantOfNode:founderNode]) {
        
        [founderNodes addObject:testNode];
        
      }
      
    }
    
  }
  
  /*
  NSLog(@"founderNodes finish items-------");
  
  for (NSTreeNode * node in founderNodes) {
    
    NSLog(@"%@", [[node representedObject] valueForKey:@"displayName"]);
    
  }
  */
  
  return [NSArray arrayWithArray:founderNodes];
  
}




// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

// returns the main nodes of a selection that need to be modified (copied, moved, removed, etc.) on the outlineViewController
// could contain DBHeaderOrganizers for DBSubTopic which may need to be dropped depending on the task

- ( NSArray * ) nodesSelectedForModification: ( DBOutlineViewController *) outlineViewController
{
  
  NSArray * selectedNodes = outlineViewController.tree.selectedNodes;
  
  NSArray * modifyingNodes =  [ self founderNodes: selectedNodes ]; //reduces nodes to the key nodes that need to be moved.
  
  
  NSLog(@"SelectedNodes ------");
  
  for (NSTreeNode * selectedNode in selectedNodes) {
    
    NSLog(@"%@", [selectedNode.representedObject valueForKey:@"displayName"]);
    
  }
  
  
  NSLog(@"Primary nodes to modify ------");
  
  for (NSTreeNode * modifyingNode in modifyingNodes) {
    
    NSLog(@"%@", [modifyingNode.representedObject valueForKey:@"displayName"]);
    
  }
  
  return modifyingNodes;
  
}



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

// returns all of the nodes that need to be reassigned if the selected are moved/deleted
// could contain DBHeaderOrganizers for DBSubTopic which may need to be dropped depending on the task

- ( NSArray * ) nodesToReassignWithModificationToSelection: ( DBOutlineViewController *) outlineViewController
{

  NSArray * selectedNodes = outlineViewController.tree.selectedNodes;
  NSOutlineView * outlineView = outlineViewController.view;
  
  NSMutableIndexSet * indexesFolowingSelections = [ NSMutableIndexSet indexSet ];
  
  
  NSIndexSet * selectedRowIndexes = outlineView.selectedRowIndexes;
  [selectedRowIndexes enumerateIndexesUsingBlock:^(NSUInteger thisIndex, BOOL *stop) {
    
    NSUInteger nextIndex = [ selectedRowIndexes indexGreaterThanIndex:thisIndex ];
    
    if (nextIndex != NSNotFound) {
      
      //NSLog(@"thisTndex: %li  nextIndex: %li", thisIndex, nextIndex);
      
      // if the next index is consecutive then we don't need to add it
      //   at this point we want the last selected row of a block of rows
      if ((nextIndex - thisIndex) != 1) {
        
        [ indexesFolowingSelections addIndex: thisIndex ];
        
      }
      
    } else {
      //this is the last index in the set.  Is it the last row?
      // don't want to add item if it's at the end, because there cannot be an item after it which needs to be reassigned
      NSUInteger lastRowIndex = outlineView.numberOfRows - 1;
      if (thisIndex != lastRowIndex) {
        
        [ indexesFolowingSelections addIndex: thisIndex ];
        
      }
      
    }
    
  }];
  
  //want node following selected node(s)
  [ indexesFolowingSelections shiftIndexesStartingAtIndex:0 by:1 ];
  
  // now only take those indexes following selections whose parent node are selected
  
  // convert row index into node
  NSMutableArray * reassignNodes = [NSMutableArray array]; //nodes folowing selected nodes that need to be reassigned
  NSMutableArray * siblingNodes = [NSMutableArray array];  //siblings of reassignedNode that MIGHT need to be reassigned if they aren't selected themselves
  
  [ indexesFolowingSelections enumerateIndexesUsingBlock:^(NSUInteger index, BOOL *stop) {
    
    NSTreeNode * nodeFollowingSelection = [ outlineView itemAtRow: index ];
    
    // check if nodes parent is selected for modification
    if ( [ selectedNodes containsObject: [ nodeFollowingSelection parentNode ] ] ) {
      
      //!! should drop subtopic items first
      [ reassignNodes addObject: nodeFollowingSelection ];
      [ siblingNodes addObjectsFromArray: [ nodeFollowingSelection siblingsExclusive ] ];
      
    }
    
  }];
  
  [ siblingNodes removeObjectsInArray:selectedNodes ];
  
  [ siblingNodes removeObjectsInArray:reassignNodes ];
  
  [ reassignNodes addObjectsFromArray: siblingNodes ];
  
   NSLog(@"All nodes to reassign------");
  
  for (NSTreeNode * reassignNode in reassignNodes) {
  
    NSLog(@"%@", [reassignNode.representedObject valueForKey:@"displayName"]);
  
  }
  
  return [ NSArray arrayWithArray:reassignNodes ];

}




// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (IBAction)testButton:(id)sender
{
 
  
  DBOutlineViewController * activeOutlineViewController = controllerOfOutlineViews.topicOutlineViewController;
 
  NSTreeController * tree = activeOutlineViewController.tree;
  
  DBManagedTreeObject * selectedObject = [[tree.selectedNodes objectAtIndex:0] representedObject];
  
  
  
  NSLog(@"selected object: %@", selectedObject.displayName);
  
  NSLog(@"selection index: %i", [selectedObject.sortIndex intValue]);

  
  
}



@end
