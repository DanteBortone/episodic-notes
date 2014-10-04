//
//  DBOutlineViewController.h
//  NoteTaker
//
//  Created by Dante on 7/2/13.
//
//

#import "DBObjectController.h"

@class DBOutlineViewDelegate;
@class DBOutlineView;
@class DBOutlineViewDataSource;
@class DBTopicObject;
@class DBDetail;
@class DBDetailViewController;

@interface DBOutlineViewController : DBObjectController

@property (strong) DBDetailViewController * mainDetailViewController; //set by detailViewController; null for topicoutlineview

@property (strong) NSArray	* dragType;
@property (strong) DBOutlineViewDelegate * delegate;
@property (strong) IBOutlet DBOutlineView * view;
@property (strong) DBOutlineViewDataSource * dataSource;
@property (strong) IBOutlet NSTreeController * tree;



//- (IBAction) testButton:(id)sender;
- (DBTopicObject * ) viewTopic;
- (void) setViewTopic:(DBTopicObject*)viewTopic;
//- (void) setupDelegateforOutlineView;
- (void) setupDataSourceforOutlineView;

@end
