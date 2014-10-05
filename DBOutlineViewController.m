/*
 
 Episodic Notes: A personal wiki, note taking app for Mac OSX. Create notes through any application on your computer and keep them in one place.
 
 Copyright (C) 2014. Dante Bortone
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 */


//---------------------------------------------
#import "DBOutlineViewController.h"
//---------------------------------------------

#import "DBOutlineViewDataSource.h"
#import "DBOutlineViewDelegate.h"
#import "DBOutlineView.h"
#import "DBDetailViewController.h"
#import "DBViewObject.h"

//---------------------------------------------


@implementation DBOutlineViewController

@synthesize dataSource;
@synthesize delegate;
@synthesize dragType;
@synthesize mainDetailViewController;
@synthesize tree;
@synthesize view;


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void)awakeFromNib{

  [ super awakeFromNib ];
  
  view.controller = self;
  
  [ self setupDataSourceforOutlineView ];
  [ self setupDelegateforOutlineView ];

}

/*
- (id)init{
  
  if (self = [super init]) {

    view.controller = self;
    
    [ self setupDataSourceforOutlineView ];
    [ self setupDelegateforOutlineView ];
    
  }
  
  return self;
  
}
*/

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------


- (void) setupDelegateforOutlineView {
  
  delegate.controller = self;
  
  [ self.view setDelegate:delegate ];
  
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) setupDataSourceforOutlineView {
  
  dataSource.controller = self;

  [ self.view setDataSource:dataSource ];
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (DBTopicObject * ) viewTopic {
  
  if (mainDetailViewController){
    
    return mainDetailViewController.managedViewObject.viewTopic;

  } else {
    
    return NULL;
    
  }
  
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------


- (void) setViewTopic:(DBTopicObject*)viewTopic {
  
  if (mainDetailViewController){
    
    [mainDetailViewController.managedViewObject setViewTopic:viewTopic];
    
  } else {
    
    // do nothing.  it's a topicview controller
  
  }
  
}


@end
