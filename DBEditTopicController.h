//
//  DBEditTopicController.h
//  NoteTaker
//
//  Created by Dante on 4/21/13.
//
//

#import <Cocoa/Cocoa.h>
#import "DBObjectController.h"

@class DBDetailController;
@class DBHeaderOrganizer;
@class DBDetailOutlineViewDelegate;
@class DBControllerOfOutlineViews;
@class DBTopicObject;

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
