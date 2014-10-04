//
//  DBNewTopicController.h
//  NoteTaker
//
//  Created by Dante on 3/3/13.
//
//


#import "DBObjectController.h"

@class DBDetailController;
@class DBControllerOfOutlineViews;
@class DBWikiWordController;


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
