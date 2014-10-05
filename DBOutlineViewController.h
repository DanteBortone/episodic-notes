/*
 
 Episodic Notes: A personal wiki, note taking app for Mac OSX. Create notes through any application on your computer and keep them in one place.
 
 Copyright (C) 2014. Dante Bortone
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 */


//---------------------------------------------
#import "DBObjectController.h"
//---------------------------------------------

@class DBOutlineViewDelegate;
@class DBOutlineView;
@class DBOutlineViewDataSource;
@class DBTopicObject;
@class DBDetail;
@class DBDetailViewController;

//---------------------------------------------


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
