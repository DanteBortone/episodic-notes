//
//  DBControllerOfOutlineViews.m
//  NoteTaker
//
//  Created by Dante on 6/30/13.
//
//


//---------------------------------------------
#import "DBControllerOfOutlineViews.h"
//---------------------------------------------
#import "DBDetailController.h"
#import "DBDetailOutlineViewController.h"
#import "DBTopicOutlineViewController.h"
#import "DBOutlineView.h"
#import "DBDetailOutlineViewDelegate.h"
#import "DBTopicObject.h"
#import "NoteTaker_AppDelegate.h"
#import "NSString_Extensions.h"
#import "DBRelatedOutlineViewController.h"
#import "DBDetailViewController.h"
#import "DBTestController.h"
#import "DBDetailViewController.h"
#import "DBCalendarController.h"
#import "DBViewObject.h"
#import "NSMutableArray_Extensions.h"
#import "DBDetailViewsSplitView.h"
#import "DBDetail.h"
#import "NSTreeController_Extensions.h"
#import "DBHighlightView.h"

//debugging
#import "DBHeaderOrganizer.h"
#import "DBSubTopic.h"

@implementation DBControllerOfOutlineViews

@synthesize preferedDefaultDetailOutlineView;
@synthesize preferedDefaultRelatedOutlineView;
@synthesize activeOutlineViewController;
@synthesize activeDetailOutlineViewController = _activeDetailOutlineViewController;  // a DBDetailOutlineViewController
//@synthesize removeViewButton;
@synthesize detailViewControllerArray;//keeps in order of last active
//@synthesize draggedObject;
@synthesize draggedObjects;
@synthesize draggedSubGroups;

@synthesize topicOutlineViewController;
@synthesize recentTopicController;
@synthesize recentTopicTable;


//@synthesize forwardHistoryButton;
//@synthesize reverseHistoryButton;
@synthesize detailSplitView;
//@synthesize segmentedControlsForView;


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(void) awakeFromNib
{

  [super awakeFromNib];
  calendarController = appDelegate.calendarController;
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) loadStoredTopicsIntoOutlines
{
  DBDetailViewController * detailViewController;
  NSArray * viewObjects;
  
  viewObjects = [ self viewObjectArray ];
  detailViewControllerArray = [ NSMutableArray arrayWithCapacity:0 ];
  
  //[ preferedDefaultDetailOutlineView sizeToFit ];//needs this to access the autosaveName for other tables during loadDefaultOutlineSettings.  I think this is an apple bug
  
  
  if (viewObjects.count>0){
    
    DBDetailViewController * detailViewController;
    DBTopicObject * topic;
    
    for ( DBViewObject * viewObject in viewObjects){

      detailViewController = [[DBDetailViewController alloc] init];
      
      [ detailViewControllerArray addObject: detailViewController];
      
      [detailViewController setManagedViewObject: viewObject];
      [viewObject setDetailViewController:detailViewController];
      
      // here we store the topic, clear it and then add it back as if it were a newly assigned topic.  if this isn't done then it won't be added to the history array and the forward reverse navigation buttons won't work right away.
      topic = viewObject.viewTopic;
      viewObject.viewTopic = NULL;
      [detailViewController assignTopic:topic];
      
      //sortIndex = [ viewObject.sortIndex integerValue ];
      
      [ detailSplitView addSubview:detailViewController.myView ];
      
      [ self transferColumnSettingsFrom:preferedDefaultDetailOutlineView to:detailViewController.primaryOutlineViewController.view];

    }

    [detailSplitView setNeedsDisplay:YES]; // this prevents a bug.  when only two views were present, the second wouldn't display.
    
  } else {

    [self addView:NULL];

  }
  
  // disble remove view button
  //if(viewObjects.count<2) [segmentedControlsForView setEnabled:NO forSegment:3 ];
  if (detailViewControllerArray.count==1){
    
    DBDetailViewController * disableRemovingViewOnThisController = [detailViewControllerArray objectAtIndex:0];
    
    
    [ self setOutlineViewTitleToSingular ];
    [ disableRemovingViewOnThisController setEnableRemovingMyself:NO ];
    
  } else {
    
    [ self setOutlineViewTitleToPlural ];

  }
  
  
  
  // select the first item
  detailViewController = [detailViewControllerArray objectAtIndex:0];
  
  [ appDelegate.mainWindow makeFirstResponder:detailViewController.primaryOutlineViewController.view];
  //[detailViewController.primaryOutlineViewController.view becomeFirstResponder];
  
  

}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(void) setOutlineViewTitleToSingular
{
  
  [outlineViewTitle setStringValue:@"Outline View of Selected Topic"];
  
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(void) setOutlineViewTitleToPlural{
  
  [outlineViewTitle setStringValue:@"Outline Views of Selected Topics"];
  
}



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) updateViewsWithSameTopicAs: (DBDetailViewController *) viewController
{
  
  //NSLog(@"updateViewsWithSameTopicAs...");
  for (DBDetailViewController * otherDetailViewController in detailViewControllerArray){
    
    if (otherDetailViewController != viewController){

      if (otherDetailViewController.primaryOutlineViewController.viewTopic == viewController.primaryOutlineViewController.viewTopic) {
      
        otherDetailViewController.managedViewObject = otherDetailViewController.managedViewObject;
      
      }
    }
    
  }
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) setActiveDetailOutlineViewController:(DBDetailOutlineViewController *)controller
{

  //move corresponding DBDetailViewController to top of detailViewControllerArray
  
  [detailViewControllerArray moveObject:controller.mainDetailViewController toIndex:0];
  
  _activeDetailOutlineViewController = controller;
  
  // check which nav buttons should be enabled
  [controller.mainDetailViewController setFwdRevEnabled];
}




// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (NSArray*) viewObjectArray
{
  
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  NSArray * fetchResult;
  
  NSEntityDescription *entity;

  entity = [NSEntityDescription entityForName:@"ViewObject" inManagedObjectContext:appDelegate.managedObjectContext];
  
  [fetchRequest setSortDescriptors:[self viewSortDescriptors]];
  [fetchRequest setEntity:entity];
  
  NSError *error;
  fetchResult = [[appDelegate managedObjectContext] executeFetchRequest:fetchRequest error:&error];

  return [NSMutableArray arrayWithArray:fetchResult];
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (DBDetailOutlineViewController *) targetViewControllerForLinks
{
  
  if ([detailViewControllerArray count] == 1) {
    
    return _activeDetailOutlineViewController;
  
  } else {
    
    //NSString *viewSelection = [[NSUserDefaults standardUserDefaults] stringForKey:@"targetViewForTopic"];
    NSNumber *viewSelectionIndex = [[NSUserDefaults standardUserDefaults] objectForKey:@"targetViewIndex"];
    
//    if ([viewSelection isEqualToString:@"Previous"]) {
    if ([viewSelectionIndex isEqualToNumber:[NSNumber numberWithInt:0]]) {
      
      //NSLog(@"link to previous view");
      
      DBDetailViewController * detailViewController = [ detailViewControllerArray objectAtIndex: 1 ];
      
      return [ detailViewController primaryOutlineViewController]; //returns DBDetailViewController
      
    } else {
      
      //NSLog(@"link to same view");

      return _activeDetailOutlineViewController; //returns a DBDetailOutlineViewController
      
    }
    
  }
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(void)reloadDetailViews
{
  
  for ( DBDetailViewController * viewController in detailViewControllerArray){
    
    
    [viewController.primaryOutlineViewController.view reloadData];

  }
  
  
}

// this is for when the root items have changed and they've gone undetected
-(void)resetDetailViews
{
  
  for ( DBDetailViewController * viewController in detailViewControllerArray){
    
    viewController.managedViewObject = viewController.managedViewObject;
    
  }
  
  
}

// -------------------------------------------------------------------------------

//  highlightActiveOutline

// -------------------------------------------------------------------------------

// Dims inactive outlineviews and highlights view of active tree so user can tell which view buttons will affect.

-(void)highlightActiveOutline
{

  NSColor * activeColor;
  NSColor * activeDetailViewInactiveColor;
  NSColor * inactiveColor;

  //activeDetailViewInactiveColor is used by the DBTableRowViews to tell what color to change the selections
    // if they detect NSColor white tells them to be active
    // activeDetailViewInactiveColor doesn't register as white
    // this lets us have the rows detect their color based on the background &
    // lets us keep the backgroud the same color
  
  activeColor = [NSColor whiteColor];
  activeDetailViewInactiveColor = [NSColor colorWithCalibratedRed:(float)255/255 green:(float)255/255 blue:(float)255/255 alpha:1.0];
  //activeDetailViewInactiveColor = [NSColor colorWithCalibratedRed:(float)242/255 green:(float)247/255 blue:(float)255/255 alpha:1.0];
  inactiveColor = [NSColor colorWithCalibratedRed:(float)245/255 green:(float)245/255 blue:(float)245/255 alpha:1.0];
  
  //20131116 made seperate buttons for topic outlineViewController
 if ( topicOutlineViewController == activeOutlineViewController ){
   //NSLog(@"topicOutlineViewController is active");
    [ topicOutlineViewController.view setBackgroundColor:activeColor];
   

  } else {
    //NSLog(@"topicOutlineViewController is inactive");

    [ topicOutlineViewController.view setBackgroundColor:activeDetailViewInactiveColor];
    
  }
  
  for ( DBDetailViewController * viewController in detailViewControllerArray) {
    
    if ( viewController == _activeDetailOutlineViewController.mainDetailViewController ){
      
      if ( viewController == activeOutlineViewController.mainDetailViewController ) {
        
        [(DBHighlightView*)viewController.myView setActiveView:true];
        [(DBHighlightView*)viewController.myView setNeedsDisplay:true];
        [ viewController.primaryOutlineViewController.view setBackgroundColor:activeColor];
        [ viewController.relatedOutlineViewController.view setBackgroundColor:activeColor];
      
        //[ viewController highlightView];

      } else {
        


        [ viewController.primaryOutlineViewController.view setBackgroundColor:activeDetailViewInactiveColor];
        [ viewController.relatedOutlineViewController.view setBackgroundColor:activeDetailViewInactiveColor];
        
      }
            
    } else {
      
      [(DBHighlightView*)viewController.myView setActiveView:false];
      [(DBHighlightView*)viewController.myView setNeedsDisplay:true];
      
      [ viewController.primaryOutlineViewController.view setBackgroundColor:inactiveColor];
      [ viewController.relatedOutlineViewController.view setBackgroundColor:inactiveColor];
      
    }
    
  }
  
}



// -------------------------------------------------------------------------------

//  updateRelatedContent

// -------------------------------------------------------------------------------

- (void) updateRelatedContent
{
    
  for ( DBDetailViewController * controller in detailViewControllerArray ){
    
    [ controller.relatedOutlineViewController updateRelatedContent ];
    
  }
  
}


// -------------------------------------------------------------------------------

//  copyOutlineToSystem:

// -------------------------------------------------------------------------------

- (IBAction) copyOutlineToSystem : sender
{
  
  int rowNumber;
  
  NSMutableString * toClipBoard;
  int numberOfTabs;
  NSString * tab = @"  ";
  id activeOutline;//all inherit from NSOutlineView
  NSTreeNode * myTreeNode;
  NSPasteboard *pasteboard;
  NSArray *copiedObject;
  
  activeOutline = activeOutlineViewController.view;
  
  rowNumber = (int)[activeOutline numberOfRows];
  if (rowNumber > 0){
    
    toClipBoard = [NSMutableString stringWithString:@"Outline from Episodic:"];
    for (int i = 0; i < rowNumber; i++){
      myTreeNode = [activeOutline itemAtRow:i];
      numberOfTabs = (int)[[myTreeNode indexPath] length];
      [toClipBoard appendString:@"\r"];
      
      for (int j = 0; j < numberOfTabs; j++){
        [toClipBoard appendString:tab];
      }
      
      [toClipBoard appendString:[[myTreeNode representedObject] valueForKey:@"displayName"]];
    }
    
    pasteboard = [NSPasteboard generalPasteboard];
    [pasteboard clearContents];
    copiedObject = [NSArray arrayWithObject:toClipBoard];
    [pasteboard writeObjects:copiedObject];
    
  } else NSLog(@"copyOutlineToSystem: no outline items");
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (DBDetailViewController *) initializeDetailViewController
{

  DBDetailViewController * detailViewController = [[DBDetailViewController alloc] init];

  if (![NSBundle loadNibNamed:@"DetailView" owner:detailViewController]) {
    
    NSLog(@"Error loading Nib for detailViewController.");
    
    return NULL;
  
  } else {
    
    return detailViewController;
    
  }
  
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(void)resetIndicesOfDetailViewControllerArray
{
  
  DBDetailViewController * detailViewController;
  
  for (int i=0;i<detailViewControllerArray.count;i=i+1) {
  
    detailViewController = [detailViewControllerArray objectAtIndex:i];
    
    detailViewController.managedViewObject.sortIndex = [NSNumber numberWithInt:i];
    
  }
  
}



// -------------------------------------------------------------------------------

// debugInfo

// -------------------------------------------------------------------------------
// for debug info
// occasionally on quitting model is missing a required value
//
-(void) debugInfo
{
  
  /*
  //NSLog(@"--------------------");
  //NSLog(@"detailViewControllerArray count: %li", detailViewControllerArray.count);
  //NSLog(@"-----");

  
  
  
  
  NSFetchRequest *fetchAllManagedViews = [[NSFetchRequest alloc] init];
  [fetchAllManagedViews setEntity:[NSEntityDescription entityForName:@"ViewObject" inManagedObjectContext:appDelegate.managedObjectContext]];
  
  NSError *error = nil;
  NSArray *viewObjects = [appDelegate.managedObjectContext executeFetchRequest:fetchAllManagedViews error:&error];
  
  NSLog(@"viewObjects count: %li", viewObjects.count);
  
  for ( DBViewObject * viewObject in viewObjects ) {
    NSLog(@"-----");
    NSLog(@"viewObject.viewTopic: %@", viewObject.viewTopic.displayName);
    NSLog(@"viewObject.sortIndex: %i", [viewObject.sortIndex intValue]);
    NSLog(@"viewObject.detailPanelHidden: %i", [viewObject.detailPanelHidden intValue]);
    NSLog(@"viewObject.detailPanelSize: %i", [viewObject.detailPanelSize intValue]);
    //NSLog(@"viewObject.relatedPanelHidden: %i", [viewObject.relatedPanelHidden intValue]);
    //NSLog(@"viewObject.relatedPanelSize: %i", [viewObject.relatedPanelSize intValue]);
    NSLog(@"viewObject.tabViewIndex: %i", [viewObject.tabViewIndex intValue]);
    
  }

  NSLog(@"-----");

  */
  
}



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(IBAction)addView:(id)sender
{

  DBDetailViewController * detailViewController;
  DBDetailViewController * insertRelativeToThisViewController;
  DBViewObject * managedViewObject;
  NSInteger insertPosition; // for detailViewControllerArray
  
  detailViewController = [[DBDetailViewController alloc] init];
  
  managedViewObject = [NSEntityDescription insertNewObjectForEntityForName:@"ViewObject"
                                                 inManagedObjectContext:appDelegate.managedObjectContext];
  
  
  //turn on "remove view" button
  if (detailViewControllerArray.count == 1) {
    
    DBDetailViewController * controllerToEnableRemoveBtn = [detailViewControllerArray objectAtIndex:0];
    
    [ self setOutlineViewTitleToPlural ];

    [controllerToEnableRemoveBtn setEnableRemovingMyself:YES];
    
  }
  
  //need to change default values of managedViewObject before setting the managed view object
  [managedViewObject takeSettingsFrom: _activeDetailOutlineViewController.mainDetailViewController.managedViewObject];
  
  [detailViewController setManagedViewObject: managedViewObject];
  [managedViewObject setDetailViewController: detailViewController];

  [ self transferColumnSettingsFrom:preferedDefaultDetailOutlineView to:detailViewController.primaryOutlineViewController.view];

  //NSLog(@"activeOutlineViewController: %@", [activeOutlineViewController className]);
  
  if (activeOutlineViewController == topicOutlineViewController || activeOutlineViewController == NULL) {

    insertPosition = 0;

    [ detailViewControllerArray insertObject:detailViewController atIndex:insertPosition ];

    if (detailViewControllerArray.count > 0) {
      
      insertRelativeToThisViewController = [detailViewControllerArray objectAtIndex:0];
      
      [ detailSplitView addSubview:detailViewController.myView positioned:NSWindowBelow relativeTo:insertRelativeToThisViewController.myView];
      
    } else { //no items in there yet
     
      [detailSplitView addSubview:detailViewController.myView];
      
    }

    
  } else {
    
    //if (detailViewControllerArray.count > 0) {
      
      insertRelativeToThisViewController = _activeDetailOutlineViewController.mainDetailViewController;
      
      insertPosition = [ insertRelativeToThisViewController.managedViewObject.sortIndex integerValue ] +1 ;
      
      [ detailViewControllerArray insertObject:detailViewController atIndex:insertPosition ];//crash
    
    
      [ detailSplitView addSubview:detailViewController.myView positioned:NSWindowAbove relativeTo:insertRelativeToThisViewController.myView];

  }

  [ detailSplitView adjustSubviews];
  
  
  [ self resetIndicesOfDetailViewControllerArray ]; //  sets sortIndices based on order of array
  

  [ appDelegate.mainWindow makeFirstResponder:detailViewController.primaryOutlineViewController.view];

  //[ detailViewController.primaryOutlineViewController.view becomeFirstResponder ];
  
  [ calendarController selectDay:[ NSDate date ] ];
  
  
  [ calendarController labelDatesLoadedInViews ];  // selects calendar button
  
  //turn on "remove view" segment
  //if (detailViewControllerArray.count == 2) [segmentedControlsForView setEnabled:YES forSegment:3 ];
 
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

// need to transfer settings of one outline to another to load autosaved default into new views and to save views into defaults
// transfer column order, relative size and hidden property
// assumes the tables are set up with the same number of columns and identifiers

- (void) transferColumnSettingsFrom: (NSTableView * )fromTable to: (NSTableView *) toTable
{
  NSString * identifier;
  NSTableColumn * toColumn;
  NSInteger gotoIndex;
  NSInteger startingIndex;
  
  for (NSTableColumn *fromColumn in fromTable.tableColumns) {
    
    // get equivalent column
    identifier = [ fromColumn identifier ];
    toColumn = [ toTable tableColumnWithIdentifier:identifier ];
    
    // move column
    startingIndex = [ toTable columnWithIdentifier:identifier ];
    gotoIndex = [ fromTable columnWithIdentifier:identifier ];
    [ toTable moveColumn:startingIndex toColumn:gotoIndex];
    
    // set column properties
    [toColumn setHidden:[fromColumn isHidden]];
    [toColumn setWidth:[fromColumn width]];
    
  }
  
  [toTable sizeToFit];

}


// -------------------------------------------------------------------------------

// removeActiveView:

// -------------------------------------------------------------------------------

-(IBAction)removeActiveView:(id)sender
{

    [self removeView: _activeDetailOutlineViewController.mainDetailViewController];
  
}


// -------------------------------------------------------------------------------

// removeView:

// -------------------------------------------------------------------------------

- (void) removeView: (DBDetailViewController *) detailViewController
{
  
  NSView * detailView;
  DBDetailViewController * newActiveDetailViewController;
  DBTopicObject * viewTopic;
  Boolean wasActiveOutlineView;
  
  if (detailViewControllerArray.count>1) {
    
    if (detailViewController.primaryOutlineViewController == activeOutlineViewController) {
      
      wasActiveOutlineView = YES;
      newActiveDetailViewController = [ detailViewControllerArray objectAtIndex:1];

    } else {

      wasActiveOutlineView = NO;
      newActiveDetailViewController = [ detailViewControllerArray objectAtIndex:0];
    }
    

    
    viewTopic = detailViewController.managedViewObject.viewTopic;
    detailView = detailViewController.myView;
    [detailView removeFromSuperview];
    

    
    
    [self setActiveDetailOutlineViewController:newActiveDetailViewController.primaryOutlineViewController];
    
    // -----------------------------------------------
    
    [ detailViewControllerArray removeObject: detailViewController ];

    [ self resetIndicesOfDetailViewControllerArray ];
    
    [ appDelegate.managedObjectContext deleteObject:detailViewController.managedViewObject ];
    
    [ appDelegate.managedObjectContext processPendingChanges ];
    
    [ calendarController deselectIfDateTopic:viewTopic ]; // has to go after view is removed
    [ calendarController labelDatesLoadedInViews ];
    
    if (wasActiveOutlineView) {
      [ appDelegate.mainWindow makeFirstResponder:detailViewController.primaryOutlineViewController.view];

      //[newActiveDetailViewController.primaryOutlineViewController.view becomeFirstResponder];
    } else {
      [ self highlightActiveOutline ];
    }
    
    //turn off remove view cell
    if (detailViewControllerArray.count==1){

      DBDetailViewController * disableRemovingViewOnThisController = [detailViewControllerArray objectAtIndex:0];
    
      [ self setOutlineViewTitleToSingular ];

      [ disableRemovingViewOnThisController setEnableRemovingMyself:NO ];
      
    }
    
    //[appDelegate save];
    
  }
  
  
  
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(NSArray *)allViewsWithTopic:(DBTopicObject *)topic
{
  NSMutableArray * views = [NSMutableArray array];
  
  for (DBDetailViewController * detailViewController in detailViewControllerArray) {
    if (detailViewController.managedViewObject.viewTopic == topic) {
      [views addObject:detailViewController];
    }
  }
  
  return views;

}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(NSArray *)viewControllersWithSameTopicAs:(DBDetailViewController *)viewController
{
  
  
  NSMutableArray * views = [NSMutableArray arrayWithArray:[self allViewsWithTopic:viewController.managedViewObject.viewTopic]];

  [views removeObject:viewController];
  
  return [NSArray arrayWithArray:views];
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (NSArray *)viewSortDescriptors
{
	return [NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"sortIndex" ascending:YES]];
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(IBAction)forwardHistory:(id)sender
{

  [_activeDetailOutlineViewController.mainDetailViewController forwardHistory];
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(IBAction)reverseHistory:(id)sender
{

  [_activeDetailOutlineViewController.mainDetailViewController reverseHistory];

}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (IBAction)segementedCellViewActions:(id)sender
{
  NSInteger selectedSegment = [sender selectedSegment];
  NSInteger clickedSegmentTag = [[sender cell] tagForSegment:selectedSegment];

  switch (clickedSegmentTag) {
    case 0: [self reverseHistory:sender]; break;
    case 1: [self forwardHistory:sender]; break;
    case 2: [self addView:sender]; break;
    case 3: [self removeActiveView:sender]; break;
  }
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (IBAction)test:(id)sender
{
  
  DBHeaderOrganizer * headerOrganizer = [topicOutlineViewController.tree.selectedObjects objectAtIndex:0];
  DBSubTopic * topic = (DBSubTopic*)headerOrganizer.topic;
  
  if (topic.isGlobal) {
    NSLog(@"Global-------------");
    NSLog(@"header sortIndex: %@", [headerOrganizer.sortIndex stringValue]);
    
  } else {
    NSLog(@"Local-------------");
    
    NSLog(@"header sortIndex: %@", [headerOrganizer.sortIndex stringValue]);

    NSNumber * sortIndex = [ (DBSubTopic*)headerOrganizer.topic valueForKey:@"sortIndex"];

    NSLog(@"subTopic %@ sortIndex: %@", [topic className], [sortIndex stringValue]);
  }
}


// array of selection index paths to attempt to restore selections after undo and redo
// a better way would be to have each undo/redo store the selection paths but this would require doing all the undo redos from sratch instead of letting them be done automatically
-(NSArray *)viewSelectionIndexPaths
{
  
  NSMutableArray * mutArray = [NSMutableArray array];
  // add topic view selection paths
  [mutArray addObject:[[[self topicOutlineViewController] tree] selectionIndexPaths]];
  
  // add selection paths of views
  for (DBDetailViewController * detailViewController in detailViewControllerArray){
    
    [mutArray addObject:detailViewController.primaryOutlineViewController.tree.selectionIndexPaths];
    
  }
  
  return [NSArray arrayWithArray:mutArray];
  
}

-(void) setViewSelectionIndexPaths: (NSArray*)arrayOfSelectionIndexPaths
{
  //NSLog(@"count: %li ", arrayOfSelectionIndexPaths.count);
  // set path for first view
  [[[self topicOutlineViewController] tree] setSelectionIndexPaths:[arrayOfSelectionIndexPaths objectAtIndex:0]];
  
  // set paths of detail views
  for (int index = 1; index < arrayOfSelectionIndexPaths.count; index +=1){
    
    DBDetailViewController * detailViewController = [detailViewControllerArray objectAtIndex:index-1];
    
    [detailViewController.primaryOutlineViewController.tree setSelectionIndexPaths:[arrayOfSelectionIndexPaths objectAtIndex:index]];
    
  }
  
}

@end
