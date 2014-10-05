/*
 
 Episodic Notes: A personal wiki, note taking app for Mac OSX. Create notes through any application on your computer and keep them in one place.
 
 Copyright (C) 2014. Dante Bortone
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 */


//---------------------------------------------
#import <Cocoa/Cocoa.h>
//---------------------------------------------

#import "DBObjectController.h"

@class DBDetailController;
@class DBHeaderOrganizer;
@class DBDetailOutlineViewDelegate;
@class DBControllerOfOutlineViews;
@class DBTopicObject;

//---------------------------------------------

@interface DBEditTopicController : DBObjectController <NSWindowDelegate,NSComboBoxDelegate> {
  
  DBDetailController * detailController;
  DBControllerOfOutlineViews * controllerOfOutlineViews;
  NSManagedObjectContext * managedObjectContext;

  IBOutlet NSWindow * myWindow;
  IBOutlet NSButton * makeChangeBtn;
  IBOutlet NSButton * cancelBtn;
  
  IBOutlet NSTextField * newNameField;
  
  //merge options
  //IBOutlet NSTextField * newNameLabel;
  IBOutlet NSMatrix * actionTypeMatrix;
  IBOutlet NSArrayController * editTopicArrayController;
  IBOutlet NSComboBox * topicComboBox;
  IBOutlet NSTextField * newNameLabel;
  
}

@property IBOutlet NSTextField * warningFieldLabel;

@property (strong) DBTopicObject * topicToEdit;

- (IBAction)openPanelFromMenu:(id)sender;

- (IBAction)editTopic:(id)sender;
- (IBAction)deleteTopic:(id)sender;

- (IBAction)cancel:(id)sender;

- (void) beginEditingTopic:(DBTopicObject *)topicToEdit;
- (BOOL) validateNewName: (NSString * ) newName;
- (void) openPanel;

@end
