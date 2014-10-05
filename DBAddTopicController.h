/*
 
 Episodic Notes: A personal wiki, note taking app for Mac OSX. Create notes through any application on your computer and keep them in one place.
 
 Copyright (C) 2014. Dante Bortone
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 */


//---------------------------------------------
#import "DBObjectController.h"
//---------------------------------------------

@class DBDetailController;
@class DBControllerOfOutlineViews;
@class DBWikiWordController;

//---------------------------------------------


@interface DBAddTopicController : DBObjectController <NSWindowDelegate> {
  
  DBDetailController * detailController;
  DBControllerOfOutlineViews * controllerOfOutlineViews;
  
  IBOutlet DBWikiWordController * wikiWordController;  //should come through appDelegate
  
  IBOutlet NSArrayController * topicTemplateArrayController;
  IBOutlet NSTextField * templateLabel;
  IBOutlet NSTextField * insertLabel;
  IBOutlet NSComboBox * templateComboBox;
  IBOutlet NSArrayController * topicArrayController;
  //IBOutlet NSButton * existingTopicButton;
  //IBOutlet NSButton * novelTopicButton;
  IBOutlet NSButton * addTopicButton;
  
  //IBOutlet NSTextField * optionsLabel;
  
  IBOutlet NSWindow * addTopicWindow;
  
  IBOutlet NSTextField * warningFieldLabel;
  IBOutlet NSTextField * outputWikiField;

  IBOutlet NSMatrix * insertOptions;
  
  IBOutlet NSTreeController * organizerTreeController;// so we can disable option to insert topic in topic navigation view if a subtopic is selected.
  
}

@property (strong) IBOutlet NSComboBox * topicListComboBox;

- (void) initExistingTopicItems;
- (void) initNovelTopicItems;
- (void) initNoTopicItems;

- (NSInteger) validateComboBoxEntry;
- (NSInteger) validateMainTopicName: (NSString *)partialString;
- (void) openPanel;

- (IBAction)addExistingTopic:(id)sender;
- (IBAction)addNovelTopic:(id)sender;

- (IBAction) togglePanelOptionDisplay:(id)sender;

- (IBAction) addTopic:(id) sender;
- (IBAction)toggleAddTopicWindow:(id)sender;
- (IBAction)cancelNewTopic:(id)sender;

@end
