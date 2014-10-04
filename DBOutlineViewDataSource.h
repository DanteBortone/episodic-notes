//
//  OutlineViewController.h
//  OutlineTest
//
//  Copyright 2012 Dante Bortone. All rights reserved.


#import <Cocoa/Cocoa.h>

@class DBManagedTreeObject;
@class DBDetailController;
@class DBOutlineView;
@class DBOutlineViewController;
@class DBOutlineViewDelegate;
@class NoteTaker_AppDelegate;
@class DBControllerOfOutlineViews;
@class DBTopicObject;

#define INTERVAL 10


@interface DBOutlineViewDataSource : NSObject <NSOutlineViewDataSource> {

  DBControllerOfOutlineViews * controllerOfOutlineViews;
  NSTreeController *treeController;
  NoteTaker_AppDelegate *appDelegate;
  DBDetailController * detailController;
  DBOutlineView * thisView;
  NSArray * originalIndexPaths;
  
}

@property (nonatomic, strong) DBOutlineViewController * controller; // set by controller


- (BOOL) category:(NSManagedObject* )cat hasSubCategory:(NSManagedObject* )possibleSub;

//overwritten by subclasses

- (void) resortGroupsforParent:(id)parent inTopic:(DBTopicObject*) topic;

- (NSArray* ) getSubGroupsforParent:(DBManagedTreeObject *)parent;
- (BOOL)makeCopyOf:(id)draggedObject;


@end

