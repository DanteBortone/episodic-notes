/*
 
 Episodic Notes: A personal wiki, note taking app for Mac OSX. Create notes through any application on your computer and keep them in one place.
 
 Copyright (C) 2014. Dante Bortone
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 */


//---------------------------------------------
#import "DBObjectController.h"
//---------------------------------------------

@class DBCalendarController;
@class DBDateTopic;
@class DBDetail;
@class DBFileTopic;
@class DBFolderOrganizer;
@class DBHeaderOrganizer;
@class DBManagedTreeObject;
@class DBNamedTopic;
@class DBOutlineViewDelegate;
@class DBControllerOfOutlineViews;
@class DBTopicObject;
@class DBOutlineViewController;
@class DBMainTopic;
@class DBSubTopic;
@class DBObjectClipboard;
@class DBOrganizerObject;
@class DBUndoManager;

//---------------------------------------------


@interface DBDetailController : DBObjectController {
  
  NSManagedObjectContext * managedObjectContext;
  DBCalendarController * calendarController;
  DBControllerOfOutlineViews * controllerOfOutlineViews;
  DBUndoManager * undoManager;
}

@property (strong) DBObjectClipboard * objectClipboard;
@property (strong) IBOutlet NSComboBox * dividerOptions;
@property (strong) IBOutlet NSButton * addExistingTopic;
@property (strong) IBOutlet NSArrayController * topicArrayController;
@property (strong) IBOutlet NSComboBox * addTopicComboBox;

- (void) copySelectedObjectsUsingController: (DBOutlineViewController *)viewController;
- (void) pasteObjectClipboardContentsUsingController: (DBOutlineViewController *) viewController;
- (void) cutObjectClipboardContentsUsingController: (DBOutlineViewController *) viewController;

- (NSArray * ) founderNodes:(NSArray *) potentialFounderNodes;
- (NSArray * ) topicFounderNodes:(NSArray *) founderNodes;


- (DBDetail *) copyOrganizerAsDetailWithSubGroups:(DBOrganizerObject *)originalObject
                                         toParent:(DBDetail *)parent;
- (NSArray *) ascendingSortDescriptor;
- (DBDateTopic *) newDateTopicAtDate:(NSDate *)selectedDate;
- (DBNamedTopic *) newNamedTopic;
- (DBFolderOrganizer *) newFolderOrganizer;
- (DBHeaderOrganizer *) newHeaderOrganizer;
- (DBDetail *) newDetailWithName;
- (DBDetail *) newDetailDivider;
- (DBHeaderOrganizer *) newHeaderOrganizerWithName;
- (void) assignDetailAndSubGroupsOf:(DBDetail *)detail
                            toTopic:(DBTopicObject*)topic;
- (void) copySubGroupsFrom:(DBTopicObject *)originalTopic
                  toParent:(DBTopicObject *)parent;
- (DBDetail *) copyDetailWithSubGroups:(DBDetail *)originalObject
                                  toParent:(DBDetail *)parent;

- (DBOrganizerObject *) copyOrganizerWithSubGroups:(DBOrganizerObject *)originalObject
                                          toParent:(DBOrganizerObject *)parent;

- (DBManagedTreeObject *) createObjectForOutlineViewController:(DBOutlineViewController*) controller;

//- (void) createDefaultItems;
- (DBDetail *) newDetail;
- (DBHeaderOrganizer *) newHeaderOrganizerWithTopic:(DBTopicObject *)topic;
- (NSString *) makeUniqueName:(NSString *)suggestedName inEntity:(NSString *)entityName;
- (void)detailWithAlias:(DBFileTopic *)aliasLink withFileNamed:(NSString *)fileName andText:(NSString *)copiedText;
- (void) deleteObject:(DBManagedTreeObject *) objectToRemove;

- (void) insert:(DBManagedTreeObject*)newObject
                            withViewController:(DBOutlineViewController *) activeController
                                    asSubGroup:(BOOL)insertAsSubGroup
                                 enterEditMode:(BOOL)enterEditMode
                              andSelectAllText:(BOOL)selectAllText;

- (DBMainTopic *) findMainTopicWithName:(NSString *)name usingUserPreferences:(BOOL)useUserPreference;
- (DBSubTopic *) findSubTopicWithName:(NSString *)name usingUserPreferences:(BOOL)shouldUseUserPreferences;

- (NSArray *)getFolderViewRootObjects;

- (void) newDetailWithPath:(NSString *)path
                      note:(NSString *)copiedText
               outputValue:(NSString *)outputValue
          imageOnClipboard:(BOOL)hasImageOnClipBoard
                  entitled:(NSString *)detailTitle;

- (void)insertBulletWithString:(NSString*)newName;


// should perhaps be in a topic controller?
- (IBAction) newTopic:sender;
//- (IBAction) pathControlClicked:(id)sender;
//- (IBAction) navigateHome:(id)sender;

//----------

//- (IBAction)add:sender;
- (IBAction)insert:(id)sender;
- (IBAction)insertFolder:(id)sender;
- (IBAction)subGroup:(id)sender;
//- (IBAction)remove:(id)sender;
- (IBAction)divider:(id)sender;


- (IBAction)menuRemove:(id)sender;

- (IBAction)removeFromDetailView:(id)sender;

- (IBAction)removeFromFolderView:(id)sender;


- (IBAction)segementedCellDetailActions:(id)sender;

- (IBAction)sortSubgroupsAZ:(id)sender;
- (IBAction)sortSubgroupsZA:(id)sender;

- (IBAction)testButton:(id)sender;



@end
