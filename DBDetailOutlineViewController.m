//
//  DBDetailOutlineViewController.m
//  NoteTaker
//
//  Created by Dante on 7/4/13.
//
//

//---------------------------------------------
#import "DBDetailOutlineViewController.h"
//---------------------------------------------

#import "DBDetailOutlineViewDelegate.h"
#import "DBOutlineViewDataSource.h"
#import "DBOutlineView.h"
#import "DBRelatedOutlineViewController.h"

//debug
#import "NSTreeController_Extensions.h"

@implementation DBDetailOutlineViewController

//@synthesize relatedOutlineViewController;
//@synthesize mainDetailViewController;

#pragma mark -
#pragma mark Set-up

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void)awakeFromNib{

  self.delegate = [ [ DBDetailOutlineViewDelegate alloc ] init ];
  self.dataSource = [ [ DBOutlineViewDataSource alloc ] init ];

  self.dragType = [ NSArray arrayWithObjects:@"detailDrag", nil ];
  [ self.view registerForDraggedTypes:self.dragType ];
  
  
  [ super awakeFromNib ];
  
  //NSLog(@"selectsInsertedObjects: %@", ([self.tree selectsInsertedObjects]) ? @"YES":@"NO");
  //NSLog(@"preservesSelection: %@", ([self.tree preservesSelection]) ? @"YES":@"NO");
  //NSLog(@"avoidsEmptySelection: %@", ([self.tree avoidsEmptySelection]) ? @"YES":@"NO");

  //relatedOutlineViewController.mainOutlineController = self;
  
}
/*
- (id)init{
  
  
  if (self = [super init]) {
    NSLog(@"detail outline: init");

    self.delegate = [[DBDetailOutlineViewDelegate alloc]init];
    self.dataSource = [ [ DBOutlineViewDataSource alloc ] init ];
    
    self.dragType = [NSArray arrayWithObjects:@"detailDrag", nil];
    [ self.view registerForDraggedTypes:self.dragType ];
    
    [ self setupDataSourceforOutlineView ];
    [ self setupDelegateforOutlineView ];
    
  }
  
  return self;
  
}
*/
@end
