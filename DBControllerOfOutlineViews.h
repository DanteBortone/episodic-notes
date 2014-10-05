/*
 
 Episodic Notes: A personal wiki, note taking app for Mac OSX. Create notes through any application on your computer and keep them in one place.
 
 Copyright (C) 2014. Dante Bortone
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 */


//---------------------------------------------
#import "DBObjectController.h"
//---------------------------------------------

@class DBManagedTreeObject;
@class DBOutlineViewDelegate;
@class DBDetailOutlineViewDelegate;
@class DBOutlineViewController;
@class DBDetailOutlineViewController;
@class DBTopicOutlineViewController;
@class DBDetailViewController;
@class DBCalendarController;
@class DBTopicObject;
@class DBDetailViewsSplitView;

//---------------------------------------------


@interface DBControllerOfOutlineViews : DBObjectController {
  
  DBCalendarController * calendarController;
  IBOutlet NSTextField * outlineViewTitle;
  
}

//@property (strong) NSMutableArray * managedViewArray;
@property (strong) IBOutlet NSOutlineView * preferedDefaultDetailOutlineView;
@property (strong) IBOutlet NSOutlineView * preferedDefaultRelatedOutlineView;
@property (strong) NSArray * draggedSubGroups;
//@property (strong) DBManagedTreeObject * draggedObject;
@property (strong) NSArray * draggedObjects;
@property (strong) NSMutableArray * detailViewControllerArray;//DBDetailViewController

@property (strong) DBOutlineViewController * activeOutlineViewController;//includes topic and detail outlineViewControllers
@property (nonatomic,strong) DBDetailOutlineViewController * activeDetailOutlineViewController;//only detail outlineViewControllers

@property (strong) NSMutableArray * lastActiveDetailViewArray;

@property (strong) IBOutlet DBTopicOutlineViewController * topicOutlineViewController;

@property (strong) IBOutlet NSArrayController * recentTopicController;
@property (strong) IBOutlet NSTableView * recentTopicTable;

//@property (strong) IBOutlet NSSegmentedControl * segmentedControlsForView;

@property (strong) IBOutlet DBDetailViewsSplitView * detailSplitView;

- (void) highlightActiveOutline;
- (void) updateRelatedContent;

- (IBAction) copyOutlineToSystem:sender;

- (void) loadStoredTopicsIntoOutlines;

- (DBDetailOutlineViewController *) targetViewControllerForLinks;

- (IBAction) addView:(id)sender;
- (IBAction) removeActiveView:(id)sender;
- (void) removeView: (DBDetailViewController *) viewController;

//-(IBAction)forwardHistory:(id)sender;
//-(IBAction)reverseHistory:(id)sender;

- (IBAction) segementedCellViewActions:(id)sender;
- (IBAction) test:(id)sender;
- (void) updateViewsWithSameTopicAs: (DBDetailViewController *) viewController;

- (void) reloadDetailViews;
- (void) resetDetailViews;

- (void) debugInfo;

- (void) transferColumnSettingsFrom: (NSTableView * )fromTable to:(NSTableView *)toTable;

- (NSArray *)allViewsWithTopic:(DBTopicObject *)topic;
- (NSArray *)viewControllersWithSameTopicAs:(DBDetailViewController *)viewController;

- (NSArray *)viewSortDescriptors;


// for resetting array selection after undo/redo
-(NSArray *)viewSelectionIndexPaths; ///returns array of selection index paths for all view starting with topic view
-(void) setViewSelectionIndexPaths: (NSArray*) arrayOfSelectionIndexPaths;



@end
