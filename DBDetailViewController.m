//
//  DBDetailViewController.m
//  NoteTaker
//
//  Created by Dante on 7/8/13.
//
//

//---------------------------------------------
#import "DBDetailViewController.h"
//---------------------------------------------

#import "DBRelatedOutlineViewController.h"
#import "DBDetailOutlineViewController.h"
#import "NSNumber_Extensions.h"
#import "DBCalendarController.h"
#import "NoteTaker_AppDelegate.h"
#import "DBTopicObject.h"
#import "DBDateTopic.h"
#import "DBNamedTopic.h"
#import "NSDate_Extensions.h"
#import "DBDetail.h"
#import "DBAliasController.h"
#import "DBFileTopic.h"
#import "DBDetailController.h"
#import "DBNoteDelegate.h"
#import "DBControllerOfOutlineViews.h"
#import "DBViewObject.h"
#import "DBTrackingArea.h"
#import "DBDetailOutlineView.h"
#import "BWSplitView.h"
#import "NSTreeController_Extensions.h"

#import "DBNoteTextView.h"

#import "DBOutlineView.h"
#import "DBTableCellTextView.h"
#import "DBTextViewCell.h"
#import "NSIndexPath_Extensions.h"
#import "DBApplescriptController.h"
#import "DBDetailSplitView.h"
#import "DBSubTopic.h"
#import "NSButton_Extensions.h"
#import "NSTreeController_Extensions.h"
#import "DBCalendarSplitview.h"

static float minDisplayNameWidth = 185;

@implementation DBDetailViewController

@synthesize controllerOfOutlineViews;
@synthesize noteView;
@synthesize noteDelegate;
@synthesize nameDelegate;
@synthesize relatedOutlineViewController;
@synthesize primaryOutlineViewController;
@synthesize topicFileIconButton;
@synthesize historyIndex;
@synthesize historyArray;
@synthesize detailTabView;
@synthesize myDatePicker;
@synthesize headerLabel;
@synthesize myView;
@synthesize detailSplitView;
@synthesize relatedSplitView;
@synthesize detailTableView;
@synthesize removeMyselfBtn;
@synthesize forwardHistoryBtn;
@synthesize reverseHistoryBtn;
@synthesize detailTabBtn;
@synthesize relatedTabBtn;
@synthesize detailRelatedTabView;
@synthesize detailTabHeader;

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(void) awakeFromNib
{

  [super awakeFromNib];
  
  relatedOutlineViewController.mainDetailViewController = self;
  primaryOutlineViewController.mainDetailViewController = self;
  
  [self setupDelegateForNoteView];
  //[self setupDelegateForNameView];
  
  historyIndex = [ NSNumber numberWithInteger:-1 ];
  historyArray = [NSMutableArray arrayWithCapacity:1];
  
  controllerOfOutlineViews = appDelegate.controllerOfOutlineViews;

  //reverseHistoryButton = controllerOfOutlineViews.reverseHistoryButton;
  //forwardHistoryButton = controllerOfOutlineViews.forwardHistoryButton;
  
  //segmentedControlsForView = controllerOfOutlineViews.segmentedControlsForView;
  
  [ myDatePicker setDateValue:[ NSDate date ] ];// ideally this would be blank if there was no selection
  
  loadingTopicFromIndex = NO;

  
  [removeMyselfBtn setAction:@selector(removeMyself:)];
  [removeMyselfBtn setTarget:self];
  
  // no viewTopic here yet
  //[ self initializeDetailRelatedTab ];

  //[ self initDetailTab];
  //[ self initButtons ];

}



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

// needs to be done after topic is assigned

- (void) initializeDetailRelatedTabButtons{

  //NSLog(@"initializeDetailRelatedTab");
  
  NSInteger activeTabIndex = [managedViewObject.detailRelatedTabIndex integerValue];

  
  if (activeTabIndex == 0) {
    
    [detailTabBtn makeTextBold];
    [relatedTabBtn unmakeTextBold];
    
    [detailTabBtn setState:NSOnState];
    [relatedTabBtn setState:NSOffState];
    
  } else if (activeTabIndex == 1){
    
    [detailTabBtn unmakeTextBold];
    [relatedTabBtn makeTextBold];
    
    [detailTabBtn setState:NSOffState];
    [relatedTabBtn setState:NSOnState];
    
  } else NSLog(@"appDelegate initializeActiveTab: unknown activeTab");
  
}



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) shouldReloadRowWithItem:(DBDetail *)item ifShowingColumnWithIdentifier: (NSString *) columnIdentifier
{
  
  NSOutlineView * outlineView = primaryOutlineViewController.view;
  //NSLog(@"%@ at column %@", item.displayName, columnIdentifier);
  
  NSTableColumn * tableColumn = [outlineView tableColumnWithIdentifier:columnIdentifier];
  
  if ( ! [tableColumn isHidden] ){

    NSInteger totalRows =[outlineView numberOfRows];
    
    NSInteger rowNumber = -1;
    for (int index = 0; index < totalRows; index += 1) {
      
      DBDetail * rowObject = [[outlineView itemAtRow:index] representedObject];
      if (item == rowObject) {
        rowNumber = index;
        break;
      }
      
    }
    
    if (rowNumber > -1){

      [outlineView reloadDataForRowIndexes:[NSIndexSet indexSetWithIndex:rowNumber] columnIndexes:[NSIndexSet indexSetWithIndex:[outlineView columnWithIdentifier:columnIdentifier]]];

      NSTableRowView * tableRowView = [outlineView rowViewAtRow:rowNumber makeIfNecessary:NO];
      
      [tableRowView display];
      
    }
    
  }
 
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (CGFloat) minViewWidth
{
  //get all the table view columns
  NSArray * columnArray = [NSArray arrayWithArray:[detailTableView tableColumns]];
  NSString * identifer;
  
  CGFloat width = 0.0f;
  
  for (NSTableColumn * column in columnArray){
    
    identifer = [column identifier];
  
    if ( ! [identifer isEqualToString:@"Detail"] ){
      
      if ( ! column.isHidden) {
        
        width += column.width;

      }
      
    }
  
  }
  
  width += minDisplayNameWidth;

  //NSLog(@"DBDetailViewController minViewWidth: %f", width);
  
  return width;

}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(DBViewObject*) managedViewObject
{
  
  return managedViewObject;

}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) setManagedViewObject:(DBViewObject *)viewObject
{
  
  managedViewObject = viewObject;
  
  [detailTabView selectTabViewItemAtIndex:[viewObject.tabViewIndex integerValue]];
  [self updateDetailTabHeader];

  
  [detailRelatedTabView selectTabViewItemAtIndex:[viewObject.detailRelatedTabIndex integerValue]];
  [ self initializeDetailRelatedTabButtons ];
  
  
  [detailSplitView setKeysAndUpdateSplitViewWith:self hiddenPanelKey:@"detailPanelHidden" sizeKey:@"detailPanelSize"];
  
  //[relatedSplitView setKeysAndUpdateSplitViewWith:self hiddenPanelKey:@"relatedPanelHidden" sizeKey:@"relatedPanelSize"];
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (NSArray *)ascendingSortDescriptor
{
  
  NSSortDescriptor *sorter = [[NSSortDescriptor alloc]
                              initWithKey:@"applicationOutputDisplay"
                              ascending:YES
                              selector:@selector(localizedCaseInsensitiveCompare:)];
  
	return [NSArray arrayWithObject:sorter];
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------
/*
- (void) initDetailTab
{
  
  
  //should also set the matrix
  [detailTabView selectTabViewItemWithIdentifier: @"InfoTab"];
  
  
}
*/

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) test
{
  
  NSLog(@"test");
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

// does init and then loads nib from file

- (id)init
{

  if (self = [super init]) {
    
    if (![NSBundle loadNibNamed:@"DetailView" owner:self]) {
      
      NSLog(@"Error loading Nib for detailViewController.");
      
    }
    
  }
  
  return self;
  
}



// -------------------------------------------------------------------------------

//  treeNodeSortDescriptors

// -------------------------------------------------------------------------------

- (NSArray *)treeNodeSortDescriptors
{
	return [NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"sortIndex" ascending:YES]];
}


// tried setting this up but the delegate kept attaching to random objects unless I did delegate as an @property.  dunno why.


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) setupDelegateForNoteView
{
  
  noteDelegate = [ [ DBNoteDelegate alloc ] init ];
  
  noteDelegate.myTextView = noteView; //have to set myTextView first before setDelegate
  [ noteView setDetailViewController:self];
  [ noteView setDelegate: noteDelegate ];
  
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(void) becomeActiveViewController
{
  
  if (controllerOfOutlineViews.activeOutlineViewController != self.primaryOutlineViewController) {
    
    [appDelegate.mainWindow makeFirstResponder:primaryOutlineViewController.view];
    
    controllerOfOutlineViews.activeDetailOutlineViewController = self.primaryOutlineViewController;
    
    controllerOfOutlineViews.activeOutlineViewController = self.primaryOutlineViewController;
    
    [controllerOfOutlineViews highlightActiveOutline];
  
  }
  
}


// -------------------------------------------------------------------------------

// enableRemovingMyself

// -------------------------------------------------------------------------------

- (void) setEnableRemovingMyself:(BOOL) allowRemove
{
  
  [removeMyselfBtn setEnabled:allowRemove];
  
}


// -------------------------------------------------------------------------------

// highlightView

// -------------------------------------------------------------------------------
/*
- (void) highlightView
{
  
  NSGradient *gradient = [[NSGradient alloc] initWithColorsAndLocations:
              [NSColor colorWithDeviceRed:(float)233/255 green:(float)243/255 blue:(float)255/255 alpha:1.0], 0.0,
              [NSColor colorWithDeviceRed:(float)206/255 green:(float)222/255 blue:(float)230/255 alpha:1.0], 1.0, nil];


NSRect selectionRect = NSInsetRect(self.myView.frame, 0, 0);

NSBezierPath *selectionPath = [NSBezierPath bezierPathWithRect:selectionRect];

[gradient drawInBezierPath:selectionPath angle:90];
  //NSLog(@"highlight");
  
  
}
*/

#pragma mark -
#pragma mark Navagation History


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) incrementIndex
{
  
  historyIndex = [historyIndex increment];
  
  [self setFwdRevEnabled];
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) decrementIndex
{
  
  historyIndex = [historyIndex decrement];
  
  [self setFwdRevEnabled];
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) setFwdRevEnabled
{

  if ([historyIndex integerValue]+1 < (historyArray.count)) {

    [forwardHistoryBtn setEnabled:YES];
    //[segmentedControlsForView setEnabled:YES forSegment:1];
    
  } else {
    
    [forwardHistoryBtn setEnabled:NO];
    //[segmentedControlsForView setEnabled:NO forSegment:1];

  }
  
  
  if ([historyIndex integerValue] <= 0) {
    
    [reverseHistoryBtn setEnabled:NO];
    //[segmentedControlsForView setEnabled:NO forSegment:0];

  } else {
    
    [reverseHistoryBtn setEnabled:YES];
    //[segmentedControlsForView setEnabled:YES forSegment:0];

  }
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

// selector added programatically since the button is already bound for setting active/inactive

- (IBAction) reverseHistory:(id)sender
{
  
  [self becomeActiveViewController];

  [ self reverseHistory ];
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (Boolean) reverseHistory
{
  
  [self decrementIndex];
  
  return [self loadTopicFromIndex: [ historyIndex integerValue ] ]; //returns boolean
  
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

// selector added programatically since the button is already bound for setting active/inactive
- (IBAction) forwardHistory:(id)sender
{
  [self becomeActiveViewController];

  [ self forwardHistory ];
  
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (Boolean) forwardHistory {
  
  
  [self incrementIndex];
  
  return [self loadTopicFromIndex: [historyIndex integerValue]]; //returns boolean
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------
// from back/foward buttons
- (Boolean) loadTopicFromIndex:(NSInteger)index

{
  id item;
  
  loadingTopicFromIndex = YES;  //  don't want newly assigned item to be added to historyArray again
  
  if (index >= historyArray.count) {
    
    return FALSE;
    
  }
  
  item = [ historyArray objectAtIndex:index ];
  
  if ([item isKindOfClass:[NSDate class]]){
    
    [(DBDetailOutlineView *)primaryOutlineViewController.view checkTextViewCellforEndEditing]; //selecting day doesn't check this

    [appDelegate.calendarController selectDay:item];
    return TRUE;
    
  } else if ([item isKindOfClass:[DBTopicObject class]]){
    
    [primaryOutlineViewController.mainDetailViewController assignTopic:item];
    return TRUE;
    
  } else if (item == NULL) {
    
    return FALSE;
    
  } else {
    
    NSLog(@"DBOutlineViewDelegate loadTopicFromIndex:  - loading topic of unknown type");
    return FALSE;
    
  }
  
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (DBTopicObject *) topic
{

  return self.managedViewObject.viewTopic;
  
}



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) assignTopic:(DBTopicObject *)topic {
  //NSLog(@"assignTopic selectedRow: %li",[primaryOutlineViewController.view selectedRow]);

  DBTopicObject * previousTopic;
  DBCalendarController * calendarController;
  DBDetailOutlineView * detailOutlineView = (DBDetailOutlineView * )self.primaryOutlineViewController.view;

  // deselect outline views
  [self.primaryOutlineViewController.tree selectNone];
  [self.relatedOutlineViewController.tree selectNone];
  
  [detailOutlineView checkTextViewCellforEndEditing];

  detailOutlineView.selectRowIndexesEnabled = [NSNumber numberWithBool:NO]; //prevents initial selection of views when loading table for the first time
  
  calendarController = appDelegate.calendarController;

  //NSLog(@"assign topic");
  
  previousTopic = self.managedViewObject.viewTopic;
  self.managedViewObject.viewTopic = topic;
  topic.dateViewed = [NSDate date];

  [calendarController deselectIfDateTopic:previousTopic];
  
 // NSLog(@"topic: %@", self.managedViewObject.viewTopic.displayName);

  [calendarController labelDatesLoadedInViews];
  
  self.managedViewObject = self.managedViewObject;  // this is a hack, but seems to be the only way to tell the view to update

  
  [calendarController labelDatesLoadedInViews];
  [relatedOutlineViewController updateRelatedContent];
  //NSLog(@"topic: %@",topic.displayName);
  
  [self setHeader:topic];

  
  if ([topic isKindOfClass:[DBFileTopic class]]) {
    NSImage * iconImage = [topic valueForKey:@"fileIcon"];
    NSSize size;
    
    size.width = 15;
    size.height = 15;
    
    [iconImage setSize: size];
    [topicFileIconButton setImage:iconImage];
    [topicFileIconButton setHidden:NO];
    
  } else {
    
    [topicFileIconButton setHidden:YES];
  
  }
  
  if ( ! loadingTopicFromIndex && topic){
    
    //NSLog(@"not loadingTopicFromIndex");

    if (previousTopic != topic) {
      
      [self updateHistoryArrayWithTopic:topic];
      
    } else {
      
      //NSLog(@"duplicate selection");
      
    }
    
  } else {
    
    loadingTopicFromIndex = NO;     //reset value
    
  }
  
  
  //for debugging---------------------------------
  /*
   NSLog(@"history-----------------------");
   
   NSDate * dateItem;
   DBTopicObject * univItem;
   
   for (id item in historyArray){
   
   if ([item isKindOfClass:[NSDate class]]){
   
   dateItem = item;
   NSLog(@"%@", [dateItem longDateToString] );
   
   } else {
   
   univItem = item;
   NSLog(@"%@", univItem.displayName);
   
   }
   
   }
   
   NSLog(@"------------------------------");
   */
  //for debugging---------------------------------


}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) setHeader:(DBTopicObject *)topic{
  
  NSString * headerText;
  
  if ([topic isKindOfClass:[DBDateTopic class]]) {
    
    NSDate * dateForHeader = [topic valueForKey:@"date"];
    
    headerText = [dateForHeader longDateToString];
    
  } else if ([topic isKindOfClass:[DBSubTopic class]]){
    
    DBMainTopic * mainTopic = [(DBSubTopic *)topic mainTopic];
    headerText = [ NSString stringWithFormat:@"%@: %@", mainTopic.displayName, topic.displayName];
    
  } else {
    
    headerText = topic.displayName;
    
  }
  
  [headerLabel setStringValue:headerText];  
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) updateHistoryArrayWithTopic:(DBTopicObject *)topic{
  
  //NSLog(@"updateHistoryArrayWithTopic");
  
  if ([topic isKindOfClass:[DBDateTopic class]]) {
    
    [ historyArray insertObject:[ topic valueForKey: @"date" ] atIndex:[ historyIndex integerValue ]+1 ];
    
  } else {
    
    [ historyArray insertObject:topic atIndex:[historyIndex integerValue]+1];
    
  }
  
  [self incrementIndex];
  // historyIndex = [historyIndex increment];
  
  //then delete historyArray after insertion point
  if (historyArray.count - 1 > [historyIndex integerValue]) {
    
    NSRange range;
    NSUInteger startDeletion;
    NSUInteger lengthDeletion;
    
    startDeletion = [historyIndex integerValue]+1;
    lengthDeletion = historyArray.count - startDeletion;
    
    range = NSMakeRange(startDeletion, lengthDeletion);
    
    
    //NSLog(@"delete from %li for length of %li", (unsigned long)startDeletion, (unsigned long)lengthDeletion);
    
    [ historyArray removeObjectsInRange:range ];
    [self setFwdRevEnabled];
  }
}

#pragma mark -
#pragma mark File buttons

/*
- (IBAction)openFile:(id)sender{
  
  
  NSString * path;
  //should update path first
  if(selectedDetail.sourceFile){
    [appDelegate.aliasController updateAliasObjectPath:selectedDetail.sourceFile];
  }
  
  
  path = [NSString stringWithString:[selectedDetail.sourceFile valueForKey:@"recentPath"]];
  if (path!=NULL) {
    [[NSWorkspace sharedWorkspace] openFile:path];
  } else {
    NSLog(@"no path found");
    
  }
  
}
*/

/*
- (IBAction)showFileInFinder:(id)sender{
  
  NSString * path;
  NSURL * url;
  NSArray * array;
  
  //should update path first
  if(selectedDetail.sourceFile){
    [appDelegate.aliasController updateAliasObjectPath:selectedDetail.sourceFile];
  }
  
  path = [NSString stringWithString:[selectedDetail.sourceFile valueForKey:@"recentPath"]];
  url = [NSURL fileURLWithPath:path];
  array  = [NSArray arrayWithObject:url];
  
  if (path!=NULL) {
    [[NSWorkspace sharedWorkspace] activateFileViewerSelectingURLs:array];
  } else {
    NSLog(@"no path found");
    
  }
  
}
*/

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (IBAction)openFileForTopic:(id)sender {
  
  //[self becomeActiveViewController]; //active view gets locked for some reason if this is clicked

  DBFileTopic * fileTopic = (DBFileTopic *)managedViewObject.viewTopic;
  
  [self openFileforFileTopic:fileTopic];
  

}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (IBAction)openFileForSelectedDetail:(id)sender {
  
  //[self becomeActiveViewController];

  NSArray * selectedObjects = primaryOutlineViewController.tree.selectedObjects;
  
  if (selectedObjects.count > 0) {
  
    DBDetail * detail = [selectedObjects objectAtIndex:0];
    
    [appDelegate.appleScriptController runOutputScriptForDetail: detail];
    
    
    
    //DBFileTopic * fileTopic = detail.sourceFile;
    
    //[self openFileforFileTopic:fileTopic];

  }
  
}




// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(void) openFileforFileTopic: (DBFileTopic *)fileTopic
{
  //NSLog(@"openFileforFileTopic");

  [ self becomeActiveViewController ];
  
  [ appDelegate.aliasController updateAliasObjectPath:fileTopic ];
  
  NSString *path = [NSString stringWithString:[fileTopic valueForKey:@"recentPath"]];
  if (path!=NULL) {
    [[NSWorkspace sharedWorkspace] openFile:path];
  } else {
    NSLog(@"no path found");
    
  }
  
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (IBAction)detailTabSelected:(id)sender
{
  
  //[self becomeActiveViewController];

  NSString *identifier = [[sender selectedCell] identifier];

  [self selectDetailTabWithIdentifier:identifier];
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void)selectDetailTabWithIdentifier:(NSString*)identifier{
  
  [detailTabView selectTabViewItemWithIdentifier:identifier ];
  
  [self updateDetailTabHeader];
  
  managedViewObject.tabViewIndex = [NSNumber numberWithInteger:[detailTabView indexOfTabViewItemWithIdentifier:identifier]] ;
  
  [self openDetailPanel];
  
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------
- (void)updateDetailTabHeader
{

  NSString * identifier = [[ detailTabView selectedTabViewItem ] identifier ];
  
  if ([identifier isEqualToString:@"NoteTab"]) {
    
    [detailTabHeader setStringValue:@"Note"];
    
  } else if ([identifier isEqualToString:@"ImageTab"]) {
    
    [detailTabHeader setStringValue:@"Image"];
    
  } else if ([identifier isEqualToString:@"FileTab"]) {
    
    [detailTabHeader setStringValue:@"File"];
    
  }

}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) openDetailPanel{
  
  [self becomeActiveViewController];

  if([managedViewObject.detailPanelHidden boolValue])
    [detailSplitView uncollapse];
  
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (IBAction)testButton:(id)sender{
  
  [self initializeDetailRelatedTabButtons];

}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(IBAction) pathControlClicked:(id)sender {
  
  //NSLog(@"pathControlClicked");
  
  NSPathControl* pathCntl = (NSPathControl *)sender;
  
  NSPathComponentCell *component = [pathCntl clickedPathComponentCell];   // find the path component selected
  [pathCntl setURL:[component URL]];          // set the url to the path control
  
  NSString * newPath = [[component URL] path];
  
  DBFileTopic * newFileLink = [appDelegate.aliasController linkForPath:newPath];
  
  //assuming the button is disabled if there isn't a selection
  DBDetail * detail = [[primaryOutlineViewController.tree selectedObjects] objectAtIndex:0];
  
  [detail setSourceFile:newFileLink];
  
}

// -------------------------------------------------------------------------------

// removeMyself:

// -------------------------------------------------------------------------------

- (IBAction) removeMyself:(id)sender
{
  
  [controllerOfOutlineViews removeView:self];
  
}

// -------------------------------------------------------------------------------

// removeMyself:

// -------------------------------------------------------------------------------

- (IBAction)selectTab:(NSButton *)sender {
  

  NSString * title;
  
  title = [sender alternateTitle];
  //NSLog(@"altTitle: %@", title);
  [detailRelatedTabView selectTabViewItemWithIdentifier: title];
  
  [detailTabBtn unmakeTextBold];
  [relatedTabBtn unmakeTextBold];
  
  [detailTabBtn setState:NSOffState];
  [relatedTabBtn setState:NSOffState];

  [sender setState:NSOnState];
  [sender makeTextBold];
  
  
  NSInteger tabIndex = [detailRelatedTabView indexOfTabViewItem:[detailRelatedTabView selectedTabViewItem]];
  
  //NSLog(@"tabIndex changed to: %li ", tabIndex);
  
  managedViewObject.detailRelatedTabIndex = [NSNumber numberWithInteger: tabIndex];
  
  //NSLog(@"detailRelatedTabIndex is now: %li ", [managedViewObject.detailRelatedTabIndex integerValue]);

  
  [ detailSplitView uncollapse ];
  
  [self becomeActiveViewController];

}


// -------------------------------------------------------------------------------

// gotoDate:

// -------------------------------------------------------------------------------

- (IBAction)gotoDate:(id)sender{

  [self becomeActiveViewController];
  [appDelegate.calendarSplitview uncollapse];
  
  // this button is only active for date topics
  // and we made this the activeviewcontroller
  
  DBDetailViewController * detailViewController = [[controllerOfOutlineViews activeDetailOutlineViewController] mainDetailViewController];
  
  DBDateTopic * dateTopic = (DBDateTopic*)detailViewController.managedViewObject.viewTopic;
  
  [ appDelegate.calendarController selectMonth: [ dateTopic date ] ];

}


// -------------------------------------------------------------------------------

// clearFilePath:

// -------------------------------------------------------------------------------

- (IBAction) clearFilePath:(id)sender
{
  NSArray * selectedObjects = primaryOutlineViewController.tree.selectedObjects;
  
  if (selectedObjects.count >0 ) {
    
    DBDetail * detail = [selectedObjects objectAtIndex:0];
    
    detail.sourceFile = NULL;
    
  }
  
}


@end
