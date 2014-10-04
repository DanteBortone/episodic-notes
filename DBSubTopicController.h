//
//  DBSubTopicController.h
//  NoteTaker
//
//  Created by Dante on 11/17/13.
//
//

#import "DBPanelController.h"

@class DBTopicObject;
@class DBMainTopic;
@class DBHeaderOrganizer;

//@class DBDetailController;
//@class DBHyperlinkEditor;

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
