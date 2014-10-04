//
//  DBTopicOutlineViewController.m
//  NoteTaker
//
//  Created by Dante on 7/4/13.
//
//

//---------------------------------------------
#import "DBTopicOutlineViewController.h"
//---------------------------------------------

#import "DBTopicOutlineViewDelegate.h"
#import "DBOutlineView.h"
#import "DBOutlineViewDataSource.h"

@implementation DBTopicOutlineViewController


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void)awakeFromNib{
  
  self.delegate = [ [ DBTopicOutlineViewDelegate alloc ] init ];
  self.dataSource = [ [ DBOutlineViewDataSource alloc ] init ];
  
  self.dragType = [NSArray arrayWithObjects:@"detailDrag", nil];
  //self.dragType = [NSArray arrayWithObjects:@"topicDrag", nil];
  [ self.view registerForDraggedTypes:self.dragType ];

  [ super awakeFromNib ];
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(IBAction)test:(id)sender{
  
  [self.tree rearrangeObjects];
  
  NSLog(@"test...");
}

@end
