//
//  DBOutlineViewController.m
//  NoteTaker
//
//  Created by Dante on 7/2/13.
//
//

//---------------------------------------------
#import "DBOutlineViewController.h"
//---------------------------------------------

#import "DBOutlineViewDataSource.h"
#import "DBOutlineViewDelegate.h"
#import "DBOutlineView.h"
#import "DBDetailViewController.h"
#import "DBViewObject.h"

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
