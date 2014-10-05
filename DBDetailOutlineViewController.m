/*
 
 Episodic Notes: A personal wiki, note taking app for Mac OSX. Create notes through any application on your computer and keep them in one place.
 
 Copyright (C) 2014. Dante Bortone
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 */


//---------------------------------------------
#import "DBDetailOutlineViewController.h"
//---------------------------------------------

#import "DBDetailOutlineViewDelegate.h"
#import "DBOutlineViewDataSource.h"
#import "DBOutlineView.h"
#import "DBRelatedOutlineViewController.h"

//debug
#import "NSTreeController_Extensions.h"

//---------------------------------------------


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
