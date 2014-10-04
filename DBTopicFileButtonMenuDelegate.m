//
//  DBTopicFileButtonMenuDelegate.m
//  NoteTaker
//
//  Created by Dante on 8/12/13.
//
//
//---------------------------------------------
#import "DBTopicFileButtonMenuDelegate.h"
//---------------------------------------------
#import "DBFileTopic.h"
#import "DBDetailViewController.h"
#import "DBViewObject.h"

@implementation DBTopicFileButtonMenuDelegate



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(DBFileTopic *) fileTopic{
  
  //NSLog(@"Using DBTopicFileButtonMenuDelegate version of fileTopic method.");

  return (DBFileTopic *)detailViewController.managedViewObject.viewTopic;
  
}

@end
