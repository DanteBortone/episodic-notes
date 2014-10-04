//
//  DBDetailFileButtonMenuDelegate.m
//  NoteTaker
//
//  Created by Dante on 8/13/13.
//
//
//---------------------------------------------
#import "DBSelectedDetailFileButtonMenuDelegate.h"
//---------------------------------------------
#import "DBFileTopic.h"
#import "DBDetailViewController.h"
#import "DBDetailOutlineViewController.h"
#import "DBDetail.h"

@implementation DBSelectedDetailFileButtonMenuDelegate



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(DBFileTopic *) fileTopic{
    
  DBDetail *selectedDetail = [detailViewController.primaryOutlineViewController.tree.selectedObjects objectAtIndex:0];

  return selectedDetail.sourceFile;
  
}

@end
