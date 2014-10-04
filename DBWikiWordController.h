//
//  DBWikiController.h
//  NoteTaker
//
//  Created by Dante on 2/27/13.
//
//


#import "DBObjectController.h"

@class DBControllerOfOutlineViews;
@class DBMainTopic;
@class DBHyperlinkEditor;
@class DBGlobalWiki;
@class DBLocalWiki;
@class DBSubTopic;
@class DBUndoManager;
@class DBUndoRedoPanel;

@interface DBWikiWordController : DBObjectController <NSTextFieldDelegate>{
  
  DBControllerOfOutlineViews * controllerOfOutlineViews;
  DBHyperlinkEditor * hyperlinkEditor;
  DBUndoManager * undoManager;

  
}

//@property (strong) DBMainTopic * topic;

//@property (strong) IBOutlet DBHyperlinkEditor * hyperlinkEditor;
@property (nonatomic, strong) IBOutlet DBUndoRedoPanel * wikiWordWindow;
@property (strong) IBOutlet NSArrayController * wikiWordArrayController;
@property (strong) IBOutlet NSTreeController * topicTreeController;
@property (strong) IBOutlet NSTextField * wikiWordField;
@property (strong) IBOutlet NSTextField * addWarningField;
@property (strong) IBOutlet NSTextField * removeWarningField;
@property (strong) IBOutlet NSButton * addButton;
@property (strong) IBOutlet NSSearchField * mySearchField;
@property (strong) IBOutlet NSOutlineView * myOutlineView;


- (IBAction)toggleWikiWordWindow:(id)sender;
- (IBAction)addWikiWord:(id)sender;
- (IBAction)removeWikiWord:(id)sender;
- (DBGlobalWiki *) newGlobalWikiWord:(NSString *)string withTopic:(DBMainTopic *)topicObject;
- (DBLocalWiki *) newLocalWikiWord:(NSString *)string withTopic:(DBSubTopic *)topicObject;

- (DBLocalWiki *) localWikiWordWithString:(NSString *)string inTopic: (DBMainTopic *) topic;
- (BOOL) validateWikiWordName: (NSString *)word;
@end
