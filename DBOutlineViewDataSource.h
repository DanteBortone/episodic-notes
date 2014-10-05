/*
 
 Episodic Notes: A personal wiki, note taking app for Mac OSX. Create notes through any application on your computer and keep them in one place.
 
 Copyright (C) 2014. Dante Bortone
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 */


//---------------------------------------------
#import <Cocoa/Cocoa.h>
//---------------------------------------------

@class DBManagedTreeObject;
@class DBDetailController;
@class DBOutlineView;
@class DBOutlineViewController;
@class DBOutlineViewDelegate;
@class NoteTaker_AppDelegate;
@class DBControllerOfOutlineViews;
@class DBTopicObject;

//---------------------------------------------


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

