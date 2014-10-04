//
//  DBDetailViewController.h
//  NoteTaker
//
//  Created by Dante on 7/8/13.
//
//

#import "DBObjectController.h"
@class DBNoteDelegate;
@class DBDisplayNameDelegate;
@class DBDetailOutlineViewController;
@class DBControllerOfOutlineViews;
@class DBViewObject;
@class DBDetail;
@class DBTopicObject;
@class DBRelatedOutlineViewController;
@class BWSplitView;
@class DBDetailSplitView;
@class DBNoteTextView;
//@class DBHighlightView;

@interface DBDetailViewController : DBObjectController {
  
  BOOL loadingTopicFromIndex; //controls whether history array is modified
  //DBControllerOfOutlineViews * controllerOfOutlineViews;

  NSSegmentedControl * segmentedControlsForView;
  DBViewObject * managedViewObject;
  
}

//@property (strong) DBDetail * selectedObject;

@property (strong) DBControllerOfOutlineViews * controllerOfOutlineViews;

@property (strong) IBOutlet NSView * myView;
@property (strong) IBOutlet NSTabView * detailTabView;


@property (strong) IBOutlet NSButton * topicFileIconButton;

@property (strong) IBOutlet NSButton * detailTabBtn;
@property (strong) IBOutlet NSButton * relatedTabBtn;

@property (strong) DBNoteDelegate * noteDelegate;
@property (strong) DBDisplayNameDelegate * nameDelegate;

@property (strong) IBOutlet DBNoteTextView * noteView;
@property (strong) IBOutlet DBDetailOutlineViewController * primaryOutlineViewController;
@property (strong) IBOutlet DBRelatedOutlineViewController * relatedOutlineViewController;

@property (strong) IBOutlet NSTableView * detailTableView;

@property (strong) NSNumber * historyIndex;
@property (strong) NSMutableArray * historyArray;
@property (strong) IBOutlet NSTextField * headerLabel;
@property (strong) IBOutlet NSDatePicker * myDatePicker;

@property (strong) IBOutlet NSButton * removeMyselfBtn;
@property (strong) IBOutlet NSButton * forwardHistoryBtn;
@property (strong) IBOutlet NSButton * reverseHistoryBtn;

//@property (strong) IBOutlet BWSplitView *mainSplitView;
@property (strong) IBOutlet DBDetailSplitView *detailSplitView;
@property (strong) IBOutlet DBDetailSplitView *relatedSplitView;
@property (strong) IBOutlet NSTabView * detailRelatedTabView;

@property (strong) IBOutlet NSTextField * detailTabHeader;

//- (DBDetail *) selectedObject;
- (void) assignTopic:(DBTopicObject *)topic;
- (Boolean) loadTopicFromIndex:(NSInteger)index; // from back/foward buttons
- (DBTopicObject *) topic;

- (IBAction)detailTabSelected:(id)sender;

- (Boolean) forwardHistory;
- (Boolean) reverseHistory;
- (void) setFwdRevEnabled;
//- (void) highlightView;

- (DBViewObject*) managedViewObject;


- (void) setManagedViewObject:(DBViewObject *)viewObject;

- (CGFloat) minViewWidth;

- (void) openDetailPanel;

- (NSArray *)ascendingSortDescriptor;

- (void)selectDetailTabWithIdentifier:(NSString*)identifier;
- (void) shouldReloadRowWithItem:(DBDetail *)item ifShowingColumnWithIdentifier: (NSString *) columnIdentifier;

- (void) becomeActiveViewController;
- (void) setHeader:(DBTopicObject *) topic;

- (void) setEnableRemovingMyself:(BOOL)allowRemove;

- (IBAction) removeMyself:(id)sender;

- (IBAction) clearFilePath:(id)sender;
- (IBAction) openFileForTopic:(id)sender;
- (IBAction) openFileForSelectedDetail:(id)sender;
- (IBAction) testButton:(id)sender;
- (IBAction) pathControlClicked:(id)sender;
- (IBAction) selectTab:(NSButton *)sender;

@end
