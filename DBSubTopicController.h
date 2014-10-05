/*
 
 Episodic Notes: A personal wiki, note taking app for Mac OSX. Create notes through any application on your computer and keep them in one place.
 
 Copyright (C) 2014. Dante Bortone
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 */


//---------------------------------------------
#import "DBPanelController.h"
//---------------------------------------------

@class DBTopicObject;
@class DBMainTopic;
@class DBHeaderOrganizer;

//---------------------------------------------


@interface DBSubTopicController : DBPanelController{
  
  IBOutlet NSTextField * inputField;
  IBOutlet NSTextField * outputWikiField;
  IBOutlet NSTextField * warningFieldLabel;
  IBOutlet NSTextField * mainTopicLabel;
  IBOutlet NSButton * addButton;
  
  BOOL openedFromNavigation;
  DBTopicObject * selectedTopic;// so we know whether to insert as a subgroup or not
  DBHeaderOrganizer * mainTopicHeader; // so we can check other local subgroup names
  NSArray * selectionIndexPaths; // need to reselect just before insert avoid root insertions in case of deselection; wondering if selected topic and mainTopic header can be removed if these indexs are stored...
  
}

//@property (strong) DBTopicObject * selectedTopic;
//@property (strong) DBHeaderOrganizer * mainTopicHeader;

- (void) validateSubTopicName: (NSString *) mergeTopic;
- (void) topicViewSelectionChangedTo: (DBHeaderOrganizer *) organizer;

- (void) copySubTopicsFrom:(DBMainTopic*)templateTopic to:(DBMainTopic*)targetTopic withDetails:(BOOL)withDetails;

- (void) openPanelWithTopic:(DBMainTopic*) mainTopic; // NOT from topic folder navigation button

- (IBAction) createSubTopic:(id)sender;

@end
